#!/usr/bin/env python3
"""Emit reviewable patches for the six M pilot packages; never execute SQL.

This is curated extraction, not a generic BNF converter. Unselected source
blocks stay unmapped/unreviewed. Apply the emitted patch with apply_patch.
"""
import argparse
import copy
import difflib
import hashlib
import json
from pathlib import Path
import re

import yaml

ROOT = Path(__file__).resolve().parents[1]
CORPUS = ROOT / 'work/m_compat_batch_01/corpus'
CATALOG = json.loads((CORPUS / 'catalog.json').read_text())
CHAPTERS = {c['title']: c for c in CATALOG['chapters']}


def lit(text):
    return dict(kind='literal', text=text)


def slot(name):
    return dict(kind='slot', slot=name)


def seq(*items):
    return dict(kind='sequence', items=[lit(x) if isinstance(x, str) else x for x in items])


def repeat(name, separator=', '):
    return dict(kind='repeat', slot=name, separator=separator, items_property='items')


class Package:
    def __init__(self, command, category, corpus=CORPUS):
        self.command, self.category = command, category
        self.id = 'm_'+command.lower().replace(' ', '_')
        self.catalog = json.loads((corpus / 'catalog.json').read_text())
        self.chapter = next(c for c in self.catalog['chapters'] if c['title'] == command)
        raw = (corpus / self.chapter['source_relpath']).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == self.chapter['chapter_sha256']
        self.lines = raw.decode().splitlines()
        self.facts, self.spans, self.dims, self.rules = [], [], {}, []
        self.files, self.manifests, self.fixtures, self.scenarios, self.matrices = {}, [], [], [], []
        self.checks, self.exports = [], []
        self.syntax_fact_refs = None
        self.extra_ignored_lines = []
        self.production = None
        self.slot_overrides = {}
        self.ast, self.subgrammars = None, {}
        self.fact('mode', 'environment', '本包只适用于 PDF 第二章 M-Compatibility 语法。', 2, 1)

    def fid(self, suffix):
        return self.id+'_fact_'+suffix

    def vid(self, dim, suffix):
        return self.id+'_'+dim+'_'+suffix

    def fact(self, suffix, kind, statement, anchor, count=1, status='confirmed'):
        if isinstance(anchor, int):
            start = anchor
        else:
            found = [i+1 for i, line in enumerate(self.lines) if anchor in line]
            if not found:
                raise ValueError((self.id, anchor))
            start = found[0]
        end = start + count - 1
        assert end <= len(self.lines)
        fid = self.fid(suffix)
        self.facts.append(dict(id=fid, type=kind, statement=statement, status=status,
                               source_anchor=f"{self.chapter['section_number']} L{start}-{end}"))
        self.spans.append((start, end, fid))
        return fid

    def dim(self, name, values, fact='syntax'):
        classes = []
        for entry in values:
            suffix, render, *extra = entry
            props = extra[0] if extra else {}
            val = dict(id=self.vid(name, suffix), render=render, representative=True,
                       validity='valid', properties=props, fact_refs=[self.fid(fact)])
            classes.append(dict(id=val['id']+'_class', meaning=suffix, values=[val]))
        self.dims[name] = dict(description=name+'：有限代表域', classes=classes,
                               default_value_id=classes[0]['values'][0]['id'])

    def matrix_dim(self, name, values, fact='syntax'):
        self.dim(name, values, fact)
        profiles = [c['values'][0] for c in self.dims[name]['classes']]
        for p in profiles:
            p.pop('representative')
        mid = 'matrix_'+self.id+'_'+name
        self.dims[name] = dict(description=name+'：有列契约的有限 profile',
                              profile_source=dict(matrix_ref=mid), default_value_id=profiles[0]['id'])
        self.matrices.append(mid)
        self.files['matrices/'+name+'.matrix.yaml'] = self.entity('matrix', mid,
            profiles=profiles, fact_refs=[self.fid(fact)])

    def rule(self, suffix, expression, fact):
        self.rules.append(dict(id=self.id+'_rule_'+suffix, kind='requires',
                               expression=expression, fact_refs=[self.fid(fact)], severity='error'))

    def entity(self, kind, identity, **kw):
        return dict(schema_version=1, kind=kind, id=identity, name=identity,
                    status='needs_review', description='M 有限模型；不承诺全章覆盖或实机成功。',
                    factor_ref=self.id, **kw)

    def fixture(self, suffix, tables, setup, teardown, requires=()):
        fid = 'fixture_'+self.id+'_'+suffix
        provided = [dict(name=name, persistence='permanent', table_kind='regular',
                        columns=[dict(name=c, type='INTEGER', nullable=True) for c in cols])
                    for name, cols in tables]
        obj = self.entity('fixture', fid, requires_fixture_refs=list(requires),
                          provides=dict(tables=provided), seed=dict(required=False, rows=[]),
                          execution=dict(status='ready', mode='explicit', setup_sqls=setup,
                                         teardown_sqls=teardown, note=
                                         '仅静态产物；将来须独占隔离测试空间、逐 case 生命周期。'
                                         '对象名必须预先不存在；setup 失败不能运行目标或清理他人对象。'
                                         '不依赖 DDL 回滚，不关闭约束，不吞异常。'))
        self.files['fixtures/'+suffix+'.fixture.yaml'] = obj
        self.fixtures.append(fid)
        return fid

    def manifest(self, suffix, bindings, fixtures, negative=None):
        mid = 'manifest_'+self.id+'_'+suffix
        expected = dict(default='success', scope='syntax_only')
        if negative:
            expected = dict(default='error', scope='syntax_and_semantics',
                            oracle_status='needs_verification', error_category=negative)
        self.files['manifests/'+suffix+'.manifest.yaml'] = self.entity('manifest', mid,
            syntax_ref='syntax_'+self.id, suite_type='negative' if negative else 'positive',
            strategy='pairwise', fixture_refs=fixtures,
            identifier_policy={},
            bindings={k:[self.vid(k,x) for x in v] for k,v in bindings.items()},
            environment_requirements=[dict(key='compatibility_mode', allowed_values=['M'],
                                           fact_refs=[self.fid('mode')])],
            violates_rule_refs=[self.id+'_rule_'+negative] if negative else [],
            expected=expected, coverage_requirements=dict(strength=2, require_all_feasible_pairs=True))
        self.manifests.append(mid)

    def scenario(self, suffix, facts, fixtures, steps, oracles):
        sid = 'scenario_'+self.id+'_'+suffix
        obj = self.entity('scenario', sid, fact_refs=[self.fid(x) for x in facts],
                          fixture_refs=fixtures, preconditions=['M-Compatibility；独立隔离测试空间'],
                          steps=steps, oracles=oracles,
                          execution_requirements=['database_authorization', 'target_oracle_calibration'])
        obj['status'] = 'planned'
        self.files['scenarios/'+suffix+'.scenario.yaml'] = obj
        self.scenarios.append(sid)

    def finish(self):
        # Cross-package resources are dependencies, not fixtures owned twice.
        owned = set(self.fixtures) & {obj['id'] for obj in self.files.values() if obj['kind']=='fixture'}
        for dependency in (BASE, VIEW):
            if dependency in owned:
                continue
            users = [obj for obj in self.files.values() if dependency in obj.get('fixture_refs', [])]
            if not users:
                continue
            suffix = 'shared_view' if dependency == VIEW else 'shared_table'
            fid = 'fixture_'+self.id+'_'+suffix
            self.files['fixtures/'+suffix+'.fixture.yaml'] = self.entity('fixture', fid,
                requires_fixture_refs=[dependency], provides=dict(tables=[]),
                seed=dict(required=False, rows=[]), execution=dict(status='ready', mode='auto',
                    note='仅组合依赖，不复制 DDL；依赖拓扑生成 setup，逆序生成 teardown。'))
            self.fixtures = [f for f in self.fixtures if f != dependency]
            self.fixtures.append(fid)
            for obj in users:
                obj['fixture_refs'] = [fid if f == dependency else f for f in obj['fixture_refs']]
        source = dict(product='GaussDB', document='集中式参考 / '+self.chapter['section_number']+' '+self.command,
                      version=self.catalog['product_version'], artifact_sha256=self.chapter['chapter_sha256'],
                      parent_pdf_sha256=self.catalog['parent_pdf_sha256'],
                      extraction_rule_version=self.catalog['extraction_rule_version'], extraction_date='2026-09-08',
                      catalog_chapter_ref=dict(document_id=self.catalog['document_id'],
                          source_relpath=self.chapter['source_relpath'], chapter_sha256=self.chapter['chapter_sha256']))
        factor = self.entity('factor', self.id, category=self.category, source=source,
            source_ledger_ref='source_ledger_'+self.id, syntax_ref='syntax_'+self.id,
            dimensions=self.dims, facts=self.facts, rules=self.rules, structural_checks=self.checks,
            exported_fact_refs=self.exports, manifest_refs=self.manifests, matrix_refs=self.matrices,
            fixture_refs=self.fixtures, scenario_refs=self.scenarios)
        factor.pop('factor_ref')
        factor['name'] = self.command+' [M]'
        self.files[self.id+'.factor.yaml'] = factor
        syntax = self.entity('syntax', 'syntax_'+self.id,
            category=self.category, ast=self.ast, subgrammars=self.subgrammars,
            rendering=dict(whitespace='collapse', statement_terminator=';'),
            slots={k:dict(type='sql_fragment', optional=True, dimension_ref=self.id+'.'+k) for k in self.dims},
            source_fact_refs=(self.syntax_fact_refs if self.syntax_fact_refs is not None
                              else [f['id'] for f in self.facts if f['type']=='syntax']))
        if self.production is not None:
            syntax['production'] = self.production
            syntax.pop('ast', None)
            syntax.pop('subgrammars', None)
        for slot_name, overrides in self.slot_overrides.items():
            syntax['slots'][slot_name].update(overrides)
        self.files[self.id+'.syntax.yaml'] = syntax
        # Preserve every line. Unselected paragraphs are explicit gaps, not
        # out_of_scope or bulk "atomic" waivers. Overlapping fact spans share
        # one source unit; detailed atomicity remains visibly unreviewed.
        units, ignored, i = [], [], 1
        while i <= len(self.lines):
            active = [s for s in self.spans if s[0] <= i <= s[1]]
            line = self.lines[i-1].strip()
            if not active and (not line or line.startswith('[[PDF_PAGE')):
                ignored.append(dict(line=i, rationale='排版空行或 PDF 页定位标记。'))
                i += 1
                continue
            end = max([s[1] for s in active], default=i)
            if active:
                while True:
                    spans = [s for s in self.spans if s[0]<=end and s[1]>=i]
                    new_end = max(s[1] for s in spans)
                    if end == new_end:
                        break
                    end = new_end
                refs = [s[2] for s in spans]
                states = {f['status'] for f in self.facts if f['id'] in refs}
                unit = dict(status='open_question' if states=={'needs_verification'} else 'mapped', fact_refs=refs)
            else:
                while end < len(self.lines) and end-i < 11:
                    nxt = self.lines[end].strip()
                    if not nxt or nxt.startswith('[[PDF_PAGE') or any(s[0]==end+1 for s in self.spans):
                        break
                    end += 1
                unit = dict(status='unmapped', rationale='正文已定位；此分支尚未逐条形式化，不计抽取/生成全覆盖。')
            unit.update(id=self.id+f'_su_{i}', section='M 原文', source_anchor=f'L{i}-{end}',
                        line_start=i, line_end=end, statement=line[:180],
                        atomicity='unreviewed')
            units.append(unit)
            i = end+1
        self.files[self.id+'.source.yaml'] = self.entity('source_ledger', 'source_ledger_'+self.id,
            artifact_sha256=source['artifact_sha256'], source_line_count=len(self.lines),
            units=units, ignored_lines=sorted(ignored + self.extra_ignored_lines, key=lambda x: x["line"]))
        if self.id == 'm_select' and any(f['id'] == self.fid('sum_signature') for f in self.facts):
            # The SELECT expression is the consumer anchor, not the source of
            # SUM's mode-specific signature. Keep the actual M chapter explicit.
            corpus = ROOT/'work/pdf_tiered_2026_09_07/batch_22/corpus'
            catalog = json.loads((corpus/'catalog.json').read_text())
            chapter = next(c for c in catalog['chapters'] if c['section_number'] == '2.5.11')
            assert catalog['parent_pdf_sha256'] == self.catalog['parent_pdf_sha256']
            assert hashlib.sha256((corpus/chapter['source_relpath']).read_bytes()).hexdigest() == chapter['chapter_sha256']
            sid = 'm_select_sum_signature_source'
            ledger = self.files[self.id+'.source.yaml']
            ledger['supplemental_sources'] = [dict(id=sid, document='2.5.11 M 聚合函数 SUM',
                version=catalog['product_version'], retrieval_date='2026-09-08', source_anchor='L952-965',
                catalog_chapter_ref=dict(document_id=catalog['document_id'],
                    source_relpath=chapter['source_relpath'], chapter_sha256=chapter['chapter_sha256']))]
            for unit in units:
                if self.fid('sum_signature') in unit.get('fact_refs', []):
                    unit['supplemental_source_refs'] = [sid]
                    unit['rationale'] = 'SELECT表达式为消费者位置；SUM类型/结果来自M2.5.11补充来源，不由本行语法推断。'
            for function,span in (('max','L574-591'),('min','L635-652'),('avg','L72-87'),('count','L338-388')):
                if not any(f['id']==self.fid(function+'_signature') for f in self.facts):
                    continue
                source_id=f'm_select_{function}_signature_source'
                ledger['supplemental_sources'].append(dict(id=source_id,
                    document=f'2.5.11 M 聚合函数 {function.upper()}',version=catalog['product_version'],
                    retrieval_date='2026-09-10',source_anchor=span,catalog_chapter_ref=dict(
                        document_id=catalog['document_id'],source_relpath=chapter['source_relpath'],
                        chapter_sha256=chapter['chapter_sha256'])))
                for unit in units:
                    if self.fid(function+'_signature') in unit.get('fact_refs',[]):
                        unit.setdefault('supplemental_source_refs',[]).append(source_id)
                        unit['rationale']='SELECT expression仅为消费者；SUM/MIN/MAX/AVG/COUNT各自类型、身份与结果依据对应M2.5.11精确正文区间，不由SELECT语法或其他模式推导。'
            if any(f['id']==self.fid('approximate_source_types') for f in self.facts):
                types_corpus=ROOT/'work/pdf_tiered_2026_09_07/batch_19/corpus'
                types_catalog=json.loads((types_corpus/'catalog.json').read_text())
                types_chapter=next(c for c in types_catalog['chapters'] if c['section_number']=='2.6')
                assert types_catalog['parent_pdf_sha256']==self.catalog['parent_pdf_sha256']
                assert hashlib.sha256((types_corpus/types_chapter['source_relpath']).read_bytes()).hexdigest()==types_chapter['chapter_sha256']
                source_id='m_select_approximate_types_source'
                ledger['supplemental_sources'].append(dict(id=source_id,
                    document='2.6.7.4 M 浮点数数值类型',version=types_catalog['product_version'],
                    retrieval_date='2026-09-10',source_anchor='L1160-1229',catalog_chapter_ref=dict(
                        document_id=types_catalog['document_id'],source_relpath=types_chapter['source_relpath'],
                        chapter_sha256=types_chapter['chapter_sha256'])))
                for unit in units:
                    if self.fid('approximate_source_types') in unit.get('fact_refs',[]):
                        unit.setdefault('supplemental_source_refs',[]).append(source_id)
                        unit['rationale']='SELECT expression为消费者；聚合签名来自M2.5.11，实际FLOAT/DOUBLE源列声明来自M2.6.7.4，两个来源不能互相替代。'
        if self.id in ('m_insert','m_update'):
            from scripts.m_string_package import attach_string_sources
            attach_string_sources(self, self.files[self.id+'.source.yaml'])
        return self.files


BASE = 'fixture_m_create_table_source'
VIEW = 'fixture_m_create_view_direct'
SRC = 'm_b01_source'
V = 'm_b01_view'


def create_table():
    p = Package('CREATE TABLE', 'DDL')
    p.fact('authority','environment','被授予CREATE ANY TABLE权限的用户可在PUBLIC和用户模式创建表。',
           '被授予CREATE ANY TABLE权限的用户',2)
    p.fact('syntax','syntax','普通列定义与 LIKE 是不同顶层产生式。','CREATE [ [LOCAL',14)
    p.fact('default','syntax','表列缺省可为常量；缺省表达式在省略赋值时使用。','●   DEFAULT default_expr',14)
    p.fact('generated','constraint','生成列不能指定 DEFAULT 缺省属性。','● 不支持为生成列指定默认值。')
    p.fact('generated_storage','syntax','生成列可显式使用 STORED/VIRTUAL。','●   [GENERATED ALWAYS]',7)
    p.fact('generated_recompute','behavior_oracle','插入或更新元组时，由生成表达式计算存储生成列的列值。',
           '–   STORED：创建存储生成列',2)
    p.fact('row_only','constraint','M 表不支持列存 ORIENTATION=column。','● 不支持WITH (ORIENTATION = column)')
    p.fact('inline_unique','constraint','列级 UNIQUE 为该字段建立独立唯一约束，UNIQUE KEY 语义相同。',566,3)
    p.fact('inline_primary_key','constraint','主键字段唯一且非NULL；一张表只能有一个主键。',584,5)
    p.fact('comment','syntax','表级 COMMENT 可使用等号。','●   COMMENT [ = ]',4)
    p.fact('like','lifecycle','LIKE 建表后源表修改不传播给新表。','新表与源表之间',2)
    p.fact('if_exists_conflict','open_question','示例导语写表不存在，与正文及后续已存在示例矛盾；不提升导语为规则。',
           '使用该关键字，表不存在时报NOTICE',2,'needs_verification')
    p.exports = [p.fid('default'),p.fid('generated'),p.fid('generated_storage'),p.fid('generated_recompute'),
                 p.fid('inline_unique'),p.fid('inline_primary_key'),p.fid('authority'),p.fid('syntax')]
    p.dim('form',[('columns',''),('like','')])
    p.dim('persistence',[('regular',''),('temporary','TEMPORARY'),('local','LOCAL TEMPORARY')])
    p.dim('if_exists',[('none',''),('yes','IF NOT EXISTS')])
    p.dim('columns',[
        ('plain','',dict(items=['id INT','qty INT DEFAULT 9'])),
        ('stored','',dict(items=['id INT','qty INT','g INT GENERATED ALWAYS AS (id + qty) STORED'])),
        ('virtual','',dict(items=['id INT','qty INT','g INT GENERATED ALWAYS AS (id + qty) VIRTUAL'])),
    ])
    p.dim('comment',[('none',''),('text',"COMMENT = 'M pilot'")],'comment')
    p.dim('orientation',[('none',''),('row',"WITH (orientation = row)"),('column',"WITH (orientation = column)")],'row_only')
    p.dims['orientation']['classes'][2]['values'][0]['validity']='invalid'
    p.rule('row_only',f"orientation != '{p.vid('orientation','column')}'",'row_only')
    p.ast = dict(kind='choice',selector='form',branches={
        p.vid('form','columns'):seq('CREATE ',slot('persistence'),' TABLE ',slot('if_exists'),
            ' m_b01_created (',repeat('columns'),') ',slot('comment'),' ',slot('orientation')),
        p.vid('form','like'):seq('CREATE ',slot('persistence'),' TABLE ',slot('if_exists'),
            ' m_b01_created LIKE m_b01_like_source')})
    p.fixture('source',[(SRC,['id','qty'])],
        [f'CREATE TABLE {SRC} (id INT DEFAULT 7, qty INT DEFAULT 9);',
         f'INSERT INTO {SRC} (id,qty) VALUES (1,10),(2,20),(3,30);'],[f'DROP TABLE {SRC};'])
    target = p.fixture('target_lifecycle',[('m_b01_like_source',['id','qty'])],
        ['CREATE TABLE m_b01_like_source (id INT, qty INT DEFAULT 9);'],
        ['DROP TABLE IF EXISTS m_b01_created;','DROP TABLE m_b01_like_source;'])
    p.manifest('columns',dict(form=['columns'],persistence=['regular','temporary','local'],
        if_exists=['none','yes'],columns=['plain','stored','virtual'],comment=['none','text'],orientation=['none','row']),[target])
    p.manifest('like',dict(form=['like'],persistence=['regular','temporary','local'],if_exists=['none','yes']),[target])
    p.manifest('column_storage_negative',dict(orientation=['column']),[target],negative='row_only')
    p.scenario('like_independence',['like'],[target],
        [dict(sql='CREATE TABLE m_b01_created LIKE m_b01_like_source;'),
         dict(sql='INSERT INTO m_b01_like_source VALUES (1,2);')],
        [dict(kind='result_set',sql='SELECT * FROM m_b01_created;',expected=[])])
    p.scenario('generated_default_attribute',['generated'],[],
        [dict(sql='CREATE TABLE m_b01_invalid (id INT, g INT GENERATED ALWAYS AS (id + 1) STORED DEFAULT 9);')],
        [dict(kind='target_error', expected='拒绝生成列 DEFAULT 属性；目标 SQLSTATE 待校准')])
    p.scenario('generated_recompute',['generated_recompute'],[target],
        [dict(sql='CREATE TABLE m_b01_created(id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);'),
         dict(sql='INSERT INTO m_b01_created(id,qty) VALUES (2,9);'),
         dict(sql='UPDATE m_b01_created SET qty=10 WHERE id=2;')],
        [dict(kind='result_set',sql='SELECT id,qty,g FROM m_b01_created ORDER BY id;',expected=[[2,10,12]])])
    return p


def create_view():
    p = Package('CREATE VIEW','DDL')
    p.fact('authority','environment','被授予CREATE ANY TABLE权限的用户可以在public和用户模式创建视图。',
           '被授予CREATE ANY TABLE权限的用户')
    p.fact('syntax','syntax','CREATE VIEW 有 OR REPLACE、TEMPORARY、FORCE、列名、选项及 CHECK OPTION。','CREATE [ OR REPLACE',4)
    p.fact('updatable_column','constraint','可更新列直接引用基表用户列，不是系统列或 whole-row reference。','●    可更新列：')
    p.fact('check','behavior_oracle','CHECK OPTION 拒绝视图定义不可见的新行。','控制更新视图的行为',5)
    p.fact('security','syntax','security_barrier 选项接受 true/false。','目前view_option_name支持',3)
    p.fact('force','lifecycle','FORCE 允许缺依赖或查询权限时创建；创建成功不证明可用。','可选。指定FORCE后',2)
    p.fact('precision','environment','精度传递选项影响视图定义中受限类型的计算。','当不开启精度传递开关',6)
    p.exports = [p.fid('updatable_column'),p.fid('authority')]
    p.dim('replace',[('none',''),('yes','OR REPLACE')])
    p.dim('temporary',[('none',''),('yes','TEMPORARY')])
    p.dim('force',[('none',''),('yes','FORCE')])
    p.dim('labels',[('none',''),('two','(c1,c2)')])
    p.dim('security',[('none',''),('on','WITH (security_barrier = true)'),('off','WITH (security_barrier = false)')],'security')
    p.matrix_dim('query', [('direct',f'SELECT id,qty FROM {SRC}',dict(output_column_count=2,source_tables=[SRC],source_columns=['id','qty'])),
                          ('filtered',f'SELECT id,qty FROM {SRC} WHERE id > 0',dict(output_column_count=2,source_tables=[SRC],source_columns=['id','qty']))])
    p.dim('check',[('none',''),('default','WITH CHECK OPTION'),('local','WITH LOCAL CHECK OPTION'),('cascaded','WITH CASCADED CHECK OPTION')])
    p.ast = seq('CREATE ',slot('replace'),' ',slot('temporary'),' ',slot('force'),
                ' VIEW m_b01_created_view ',slot('labels'),' ',slot('security'),' AS ',slot('query'),' ',slot('check'))
    view_source = 'm_b01_view_source'
    for profile in p.files['matrices/query.matrix.yaml']['profiles']:
        profile['render'] = profile['render'].replace(SRC, view_source)
        profile['properties']['source_tables'] = [view_source]
    target=p.fixture('target_lifecycle',[(view_source,['id','qty'])],
        [f'CREATE TABLE {view_source} (id INT, qty INT);',
         f'INSERT INTO {view_source} VALUES (1,10),(2,20);'],
        ['DROP VIEW IF EXISTS m_b01_created_view;',f'DROP TABLE {view_source};'])
    # This fixture is a dependency for M DML; it owns the actual direct view.
    p.fixture('direct',[],[f'CREATE VIEW {V} AS SELECT id,qty FROM {SRC};'],[f'DROP VIEW {V};'],[BASE])
    p.manifest('basic',dict(replace=['none','yes'],temporary=['none','yes'],force=['none','yes'],
        labels=['none','two'],security=['none','on','off'],query=['direct','filtered'],
        check=['none','default','local','cascaded']),[target])
    p.scenario('check_visibility',['check'],[BASE],
        [dict(sql=f'CREATE VIEW m_b01_checked AS SELECT id,qty FROM {SRC} WHERE id > 0 WITH CHECK OPTION;'),
         dict(sql='INSERT INTO m_b01_checked VALUES (-1,2);')],
        [dict(kind='target_error',expected='视图可见性检查错误；SQLSTATE 待校准',stage='target')])
    p.scenario('force_lifecycle',['force'],[],
        [dict(action='ensure_missing_dependency_in_isolated_schema'),
         dict(sql='CREATE FORCE VIEW m_b01_force AS SELECT id FROM m_b01_missing;')],
        [dict(kind='metadata',expected='无效视图；不是可查询成功')])
    p.scenario('direct_column_lineage',['updatable_column'],[VIEW],
        [dict(sql=f'UPDATE {V} SET qty=99 WHERE id=2;')],
        [dict(kind='result_set',sql=f'SELECT qty FROM {SRC} WHERE id=2;',expected=[[99]])])
    p.scenario('precision_gate',['precision'],[],
        [dict(action='建立不同精度传递配置下的受限类型计算视图；需先补具体类型 fixture')],
        [dict(kind='target_error',expected='按精度配置分别校准受限类型创建结果，不与 INT 直投影混用')])
    return p


def insert():
    p=Package('INSERT','DML')
    p.fact('syntax','syntax','M INSERT 分 VALUES/VALUE、SET、query，INTO 可省略；表和视图分别列出。','INSERT [/*+ plan_hint */]',31)
    p.fact('default','syntax','DEFAULT 表示目标列默认值，没有默认值为 NULL。','●   DEFAULT',2)
    p.fact('generated_write','constraint','生成列不能赋具体值，但可指定 DEFAULT。','生成列不能被直接写入',2)
    p.fact('view_duplicate','constraint','视图不支持 ON DUPLICATE KEY UPDATE。','6. 不支持ON DUPLICATE KEY UPDATE功能。')
    p.fact('duplicate_effect','behavior_oracle','带唯一键的表遇冲突更新已有行；VALUES(qty)引用输入行，不是旧值。','对于带有唯一约束',3)
    p.fact('duplicate_authority','environment','ON DUPLICATE KEY UPDATE需要INSERT、UPDATE及被更新列SELECT权限。','如果使用ON DUPLICATE KEY UPDATE',2)
    p.fact('column_input','constraint','省略列列表的输入按前 N 列关联。','如果value子句和query中只提供了N个字段',2)
    p.fact('view_column','constraint','插入视图的列须为直接基表用户列。','1. 只有直接引用基表用户列的列可插入。')
    p.dim('into',[('yes','INTO'),('none','')])
    targets=[('table',SRC,dict(generated=False,is_view=False)),('view',V,dict(generated=False,is_view=True)),
             ('generated','m_b01_generated',dict(generated=True,is_view=False)),
             ('upsert','m_b01_upsert',dict(generated=False,is_view=False))]
    for _,_,props in targets:
        n=3 if props['generated'] else 2
        props.update(target_column_count=n,target_types=['INTEGER']*n,explicit_columns=False,
                     available_column_count=n,available_types=['INTEGER']*n)
        if not props['generated'] and not props['is_view']:
            props['target_column_contract'] = 'fixture_ordinary_columns'
        elif props['is_view']:
            props['target_column_contract'] = 'fixture_direct_view_columns'
        else:
            props['target_column_contract'] = 'fixture_generated_columns'
            props['generated_columns'] = ['g']
    p.matrix_dim('target_profile',targets)
    next(v for v in p.files['matrices/target_profile.matrix.yaml']['profiles']
         if v['id']==p.vid('target_profile','view'))['fact_refs'].append(p.fid('view_column'))
    next(v for v in p.files['matrices/target_profile.matrix.yaml']['profiles']
         if v['id']==p.vid('target_profile','generated'))['fact_refs'].append(p.fid('generated_write'))
    sources=[('values','',dict(items=['(7,9)'],output_types=['INTEGER']*2)),
             ('many','',dict(items=['(7,9)','(8,10)'],output_types=['INTEGER']*2)),
             ('default','',dict(items=['(7,DEFAULT)'],output_types=['INTEGER','DEFAULT'])),
             ('set','',dict(items=['id = 7','qty = DEFAULT'],output_types=['INTEGER','DEFAULT'])),
             ('query',f'SELECT id,qty FROM {SRC} WHERE id = 1',dict(output_types=['INTEGER']*2,source_tables=[SRC],source_columns=['id','qty'],query_output_contract='fixture_direct_columns')),
             ('generated_default','',dict(items=['(7,9,DEFAULT)'],output_types=['INTEGER','INTEGER','DEFAULT'])),
             ('generated_literal','',dict(items=['(7,9,16)'],output_types=['INTEGER']*3,generated_explicit=True)),
             ('generated_null','',dict(items=['(7,9,NULL)'],output_types=['INTEGER','INTEGER','NULL'],generated_explicit=True))]
    for _,_,props in sources:
        props.setdefault('items', [])
        props.update(output_column_count=len(props['output_types']),source_kind='finite_input')
        props.setdefault('generated_explicit',False)
    p.matrix_dim('source_profile',sources)
    for suffix in ('generated_literal','generated_null'):
        explicit_profile=next(v for v in p.files['matrices/source_profile.matrix.yaml']['profiles'] if v['id']==p.vid('source_profile',suffix))
        explicit_profile['validity']='invalid'
        explicit_profile['fact_refs'].append(p.fid('generated_write'))
    p.dim('values_keyword',[('values','VALUES'),('value','VALUE')])
    p.dim('duplicate',[('none',''),('yes','ON DUPLICATE KEY UPDATE qty = VALUES(qty)')])
    p.rule('generated_write','target_profile.properties.generated == True => source_profile.properties.generated_explicit == False','generated_write')
    p.rule('view_duplicate',f"target_profile.properties.is_view == True => duplicate == '{p.vid('duplicate','none')}'",'view_duplicate')
    p.checks=[dict(id=p.id+'_struct_input',kind='insert_input_contract',fact_refs=[p.fid('column_input')])]
    p.syntax_fact_refs = [p.fid('syntax'), p.fid('default'), p.fid('column_input')]
    p.ast=seq('INSERT ',slot('into'),' ',slot('target_profile'),' ',dict(kind='choice',selector='source_profile',branches={
        p.vid('source_profile',k): (seq('SET ',repeat('source_profile')) if k=='set' else
                                  slot('source_profile') if k=='query' else seq(slot('values_keyword'),' ',repeat('source_profile')))
        for k,_,_ in sources}),' ',slot('duplicate'))
    generated=p.fixture('generated',[('m_b01_generated',['id','qty','g'])],
        ['CREATE TABLE m_b01_generated(id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);'],
        ['DROP TABLE m_b01_generated;'])
    p.fixtures += [BASE,VIEW]
    # A VALUES spelling cannot cover an interaction in a SET/query branch.
    # Keep the six source/target productions in separate manifest domains.
    p.manifest('table',dict(into=['yes','none'],target_profile=['table'],source_profile=['values','many','default'],values_keyword=['values','value']),[BASE])
    p.manifest('view',dict(into=['yes','none'],target_profile=['view'],source_profile=['values','default'],values_keyword=['values','value']),[VIEW])
    for target_name, fixture_ref in (('table',BASE),('view',VIEW)):
        for source_name in ('set','query'):
            p.manifest(target_name+'_'+source_name,dict(into=['yes','none'],
                target_profile=[target_name],source_profile=[source_name]),[fixture_ref])
    p.manifest('generated',dict(target_profile=['generated'],source_profile=['generated_default']),[generated])
    p.manifest('generated_negative',dict(target_profile=['generated'],source_profile=['generated_literal']),[generated],negative='generated_write')
    p.manifest('generated_null_negative',dict(target_profile=['generated'],source_profile=['generated_null']),[generated],negative='generated_write')
    p.manifest('generated_omitted_values',dict(target_profile=['generated'],source_profile=['values']),[generated])
    p.manifest('generated_omitted_query',dict(target_profile=['generated'],source_profile=['query']),[BASE,generated])
    for suffix, sql, expected_rows, fixtures in (
        ('generated_default_result','INSERT INTO m_b01_generated VALUES(7,9,DEFAULT);',[[7,9,16]],[generated]),
        ('generated_omitted_values_result','INSERT INTO m_b01_generated VALUES(7,9);',[[7,9,16]],[generated]),
        ('generated_omitted_query_result',f'INSERT INTO m_b01_generated SELECT id,qty FROM {SRC} WHERE id=1;',[[1,10,11]],[BASE,generated]),
    ):
        p.scenario(suffix,['generated_write','column_input'],fixtures,[dict(sql=sql)],
            [dict(kind='result_set',sql='SELECT id,qty,g FROM m_b01_generated ORDER BY id;',expected=expected_rows)])
        p.files['scenarios/'+suffix+'.scenario.yaml']['fact_refs'].append(
            'm_create_table::m_create_table_fact_generated_recompute')
    p.scenario('generated_null_write',['generated_write'],[generated],
        [dict(id='target_write',sql='INSERT INTO m_b01_generated VALUES(7,9,NULL);',expected='error')],
        [dict(kind='target_error',step_ref='target_write',expected=dict(error_category='generated_write'),
              calibration_status='needs_verification',sqlstates=[],
              note='只接受目标INSERT的生成列写入错误；setup/权限/对象缺失不通过。')])
    p.manifest('view_duplicate_negative',dict(target_profile=['view'],duplicate=['yes']),[VIEW],negative='view_duplicate')
    upsert=p.fixture('upsert',[('m_b01_upsert',['id','qty'])],
        ['CREATE TABLE m_b01_upsert (id INT PRIMARY KEY, qty INT DEFAULT 9);',
         'INSERT INTO m_b01_upsert VALUES (7,3);'],['DROP TABLE m_b01_upsert;'])
    p.files['fixtures/upsert.fixture.yaml']['provides']['tables'][0]['columns'][0]['nullable']=False
    p.manifest('upsert_conflict',dict(into=['yes','none'],target_profile=['upsert'],source_profile=['values'],
        values_keyword=['values','value'],duplicate=['yes']),[upsert])
    p.files['manifests/upsert_conflict.manifest.yaml']['environment_requirements'].append(dict(
        key='target_authority',allowed_values=['fixture_table_creator_with_insert_update_select'],fact_refs=[p.fid('duplicate_authority')]))
    p.scenario('upsert_result',['duplicate_effect','duplicate_authority'],[upsert],
        [dict(sql='INSERT INTO m_b01_upsert VALUES (7,9) ON DUPLICATE KEY UPDATE qty = VALUES(qty);')],
        [dict(kind='result_set',sql='SELECT id,qty FROM m_b01_upsert ORDER BY id;',expected=[[7,9]])])
    p.scenario('default_result',['default'],[BASE],[dict(sql=f'INSERT INTO {SRC} VALUES (7,DEFAULT);')],
        [dict(kind='result_set',sql=f'SELECT qty FROM {SRC} WHERE id=7;',expected=[[9]])])
    p.scenario('view_column_lineage',['view_column'],[VIEW],
        [dict(sql=f'INSERT INTO {V} VALUES (7,9);')],
        [dict(kind='result_set',sql=f'SELECT id,qty FROM {SRC} WHERE id=7;',expected=[[7,9]])])
    p.files['scenarios/view_column_lineage.scenario.yaml']['fact_refs'].append('m_create_view::m_create_view_fact_updatable_column')
    p.files['matrices/source_profile.matrix.yaml']['fact_refs'].append('m_create_table::m_create_table_fact_default')
    from scripts.m_string_package import add_string_cases
    add_string_cases(p)
    return p


def update():
    p=Package('UPDATE','DML')
    p.fact('syntax','syntax','单表 UPDATE 支持 WITH、目标、SET、WHERE、ORDER、LIMIT。','●      单表更新：',16)
    p.fact('default','syntax','UPDATE DEFAULT 填对应列默认值；没有默认值则 NULL。','●   DEFAULT',3)
    p.fact('generated_write','constraint','生成列不能赋具体值，但可指定 DEFAULT。','生成列不能被直接写入',2)
    p.fact('multi_view','constraint','M多表UPDATE不支持以视图作为目标；不能由单表可更新性推导多表可更新。',
           '对于多表更新语法，暂时不支持对视图进行多表更新。')
    p.fact('only','syntax','ONLY 与星号保留语法，功能不支持。','ONLY和增加*选项保留语法',1)
    p.fact('s2_order','environment','s2 单表多赋值按从左到右使用更新后值。','设置GUC兼容性参数m_format_dev_version',6)
    p.fact('view_column','constraint','视图/子查询只更新直接基表用户列。','● 只有直接引用基表用户列的列可进行UPDATE操作。')
    generated_table='m_b01_update_generated'
    p.dim('target',[('table',SRC),('view',V),('derived',f'(SELECT id,qty FROM {SRC})'),
                    ('generated',generated_table)])
    p.dim('assignments',[('literal','',dict(items=['qty = 99'])),('default','',dict(items=['qty = DEFAULT'])),
                         ('two','',dict(items=['id = 8','qty = DEFAULT'])),
                         ('generated_default','',dict(items=['g = DEFAULT'])),
                         ('generated_literal','',dict(items=['g = 99'])),
                         ('generated_null','',dict(items=['g = NULL']))],'default')
    p.dim('where',[('none',''),('id','WHERE id = 2')])
    p.dim('order',[('none',''),('asc','ORDER BY id ASC'),('desc','ORDER BY id DESC')])
    p.dim('limit',[('none',''),('one','LIMIT 1')])
    p.ast=seq('UPDATE ',slot('target'),' SET ',repeat('assignments'),' ',slot('where'),' ',slot('order'),' ',slot('limit'))
    p.fixtures += [BASE,VIEW]
    p.manifest('table',dict(target=['table'],assignments=['literal','default','two'],where=['none','id'],order=['none','asc','desc'],limit=['none','one']),[BASE])
    p.manifest('view_derived',dict(target=['view','derived'],assignments=['literal','default'],where=['none','id']),[VIEW])
    invalid_generated=[p.vid('assignments','generated_literal'),p.vid('assignments','generated_null')]
    p.rule('generated_write',f"target == '{p.vid('target','generated')}' => assignments not in {invalid_generated!r}",
           'generated_write')
    generated=p.fixture('generated',[(generated_table,['id','qty','g'])],
        [f'CREATE TABLE {generated_table}(id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED);',
         f'INSERT INTO {generated_table}(id,qty) VALUES (2,9);'],[f'DROP TABLE {generated_table};'])
    p.files['fixtures/generated.fixture.yaml']['seed']=dict(required=True,rows=[dict(id=2,qty=9)])
    p.manifest('generated_default',dict(target=['generated'],assignments=['generated_default'],where=['id']),[generated])
    p.manifest('generated_negative',dict(target=['generated'],assignments=['generated_literal','generated_null'],where=['id']),
               [generated],negative='generated_write')
    p.scenario('default_result',['default'],[BASE],[dict(sql=f'UPDATE {SRC} SET qty=DEFAULT WHERE id=2;')],
        [dict(kind='result_set',sql=f'SELECT qty FROM {SRC} WHERE id=2;',expected=[[9]])])
    p.scenario('view_column_lineage',['view_column'],[VIEW],
        [dict(sql=f'UPDATE {V} SET qty=99 WHERE id=2;')],
        [dict(kind='result_set',sql=f'SELECT qty FROM {SRC} WHERE id=2;',expected=[[99]])])
    p.files['scenarios/view_column_lineage.scenario.yaml']['fact_refs'].append('m_create_view::m_create_view_fact_updatable_column')
    multi_base='m_b01_update_multi_base';multi_aux='m_b01_update_multi_aux';multi_view='m_b01_update_multi_view'
    multi=p.fixture('multi_view',[(multi_base,['id','qty']),(multi_aux,['id','qty'])],
        [f'CREATE TABLE {multi_base} (id INT, qty INT);',f'INSERT INTO {multi_base} VALUES (1,10);',
         f'CREATE TABLE {multi_aux} (id INT, qty INT);',f'INSERT INTO {multi_aux} VALUES (1,20);',
         f'CREATE VIEW {multi_view} AS SELECT id,qty FROM {multi_base};'],
        [f'DROP VIEW {multi_view};',f'DROP TABLE {multi_aux} PURGE;',f'DROP TABLE {multi_base} PURGE;'])
    p.scenario('multi_view_rejected',['multi_view'],[multi],
        [dict(id='control',sql=f'UPDATE {multi_base} AS b,{multi_aux} AS a SET b.qty=11 WHERE b.id=a.id;',expected='success'),
         dict(id='control_rows',sql=f'SELECT id,qty FROM {multi_base} ORDER BY id;'),
         dict(id='target',sql=f'UPDATE {multi_view} AS v,{multi_aux} AS a SET v.qty=99 WHERE v.id=a.id;',expected='error')],
        [dict(kind='result_set',step_id='control_rows',expected=[[1,11]]),
         dict(kind='target_error',step_id='target',stage='target',expected='error',
              error_category='multi_table_view',oracle_status='needs_verification',sqlstates=[])])
    multi_scenario=p.files['scenarios/multi_view_rejected.scenario.yaml']
    multi_scenario['description']='完整M多表UPDATE形状，无单表ORDER/LIMIT尾部；真实普通表控制与视图负例分开。不能以setup/权限/任意错误满足目标Oracle，SQLSTATE仍待校准。'
    multi_scenario['execution_requirements'] += ['isolated_connection','fixture_object_creator',
                                                'per_step_oracle','ownership_scoped_cleanup']
    p.scenario('generated_default_result',['generated_write'],[generated],
        [dict(id='target_default',sql=f'UPDATE {generated_table} SET g=DEFAULT WHERE id=2;',expected='success')],
        [dict(kind='result_set',sql=f'SELECT id,qty,g FROM {generated_table} ORDER BY id;',expected=[[2,9,11]])])
    p.files['scenarios/generated_default_result.scenario.yaml']['fact_refs'].append(
        'm_create_table::m_create_table_fact_generated_recompute')
    for suffix, rhs in (('generated_write','99'),('generated_null_write','NULL')):
        p.scenario(suffix,['generated_write'],[generated],
            [dict(id='target_write',sql=f'UPDATE {generated_table} SET g={rhs} WHERE id=2;',expected='error')],
            [dict(kind='target_error',step_ref='target_write',expected=dict(error_category='generated_write'),
                  calibration_status='needs_verification',sqlstates=[],
                  note='仅目标 UPDATE 的生成列写入错误可匹配；setup/权限/对象缺失错误不通过。')])
    p.scenario('s2_assignment_order',['s2_order'],[BASE],
        [dict(action='仅在确认 m_format_dev_version=s2 后执行'),dict(sql=f'UPDATE {SRC} SET id=id+1, qty=id WHERE id=2;')],
        [dict(kind='result_set',sql=f'SELECT qty FROM {SRC} WHERE id=3 ORDER BY qty;',expected=[[3],[30]])])
    for c in p.dims['assignments']['classes']:
        value=c['values'][0]
        if value['id'] in [p.vid('assignments',s) for s in ('generated_default','generated_literal','generated_null')]:
            value['fact_refs']=[p.fid('generated_write')]
            if value['id'] in invalid_generated:
                value['validity']='invalid'
        else:
            value['fact_refs'].append('m_create_table::m_create_table_fact_default')
    from scripts.m_string_package import add_string_cases
    add_string_cases(p)
    return p


def delete():
    p=Package('DELETE','DML')
    p.fact('syntax','syntax','单表 DELETE 支持 WITH、FROM、WHERE、ORDER、LIMIT。','[ WITH [ RECURSIVE ] with_query',5)
    p.fact('where','behavior_oracle','没有 WHERE 时删除所有行，保留表结构。','DELETE从指定的表里',2)
    p.fact('multi_view','constraint','视图不支持多表删除。','对于多表删除语法',1)
    p.fact('view_column','constraint','视图必须至少有一个可更新列。','● 视图必须至少包含一个可更新列',1)
    p.fact('s2_match','environment','s2 要求多表目标和 using_list 唯一匹配。','设置GUC兼容性参数m_format_dev_version',3)
    p.dim('target',[('table',SRC),('view',V)])
    p.dim('where',[('none',''),('id','WHERE id = 2')])
    p.dim('order',[('none',''),('asc','ORDER BY id ASC'),('desc_null','ORDER BY id DESC NULLS LAST')])
    p.dim('limit',[('none',''),('one','LIMIT 1')])
    p.ast=seq('DELETE FROM ',slot('target'),' ',slot('where'),' ',slot('order'),' ',slot('limit'))
    p.fixtures += [BASE,VIEW]
    p.manifest('table',dict(target=['table'],where=['none','id'],order=['none','asc','desc_null'],limit=['none','one']),[BASE])
    p.manifest('view',dict(target=['view'],where=['none','id']),[VIEW])
    p.scenario('where_result',['where'],[BASE],[dict(sql=f'DELETE FROM {SRC} WHERE id=2;')],
        [dict(kind='result_set',sql=f'SELECT id FROM {SRC} ORDER BY id;',expected=[[1],[3]])])
    p.scenario('view_delete',['view_column'],[VIEW],
        [dict(sql=f'DELETE FROM {V} WHERE id=2;')],
        [dict(kind='result_set',sql=f'SELECT id FROM {SRC} ORDER BY id;',expected=[[1],[3]])])
    p.files['scenarios/view_delete.scenario.yaml']['fact_refs'].append('m_create_view::m_create_view_fact_updatable_column')
    p.scenario('multi_view_rejected',['multi_view'],[VIEW],
        [dict(action='补独立第二张表及多表 DELETE 产生式，不使用拼接占位符')],
        [dict(kind='target_error',expected='视图多表删除被拒绝；目标 SQLSTATE 待校准')])
    p.scenario('s2_target_resolution',['s2_match'],[],
        [dict(action='补 s2 gate 和同名跨 schema 表，分别检查唯一匹配与歧义')],
        [dict(kind='target_error',expected='只有目标不能唯一匹配时报告目标解析错误')])
    return p


def select():
    p=Package('SELECT','DML')
    p.fact('syntax','syntax','M SELECT 的重复投影、FROM、WHERE、ORDER、LIMIT 主产生式。','[ WITH [ RECURSIVE ] with_query',22)
    p.fact('from_optional','syntax','M SELECT的FROM子句可省略；本消费者只取单个常量投影，不推导任意子查询基数。',
           '[FROM from_item [,...]]',1)
    p.fact('distinct','syntax','DISTINCT 与 DISTINCTROW 去除重复结果行。','●   DISTINCT | DISTINCTROW',2)
    p.fact('cache','syntax','SQL_CACHE/SQL_NO_CACHE 仅语法兼容，无缓存功能。','●   SQL_CACHE | SQL_NO_CACHE',2)
    p.fact('limit','syntax','LIMIT 支持 count、offset,count 与 count OFFSET offset。','[[LIMIT {[offset,] row_count',1)
    p.fact('from','syntax','FROM 可使用有限嵌套 SELECT。','其中指定查询源from_item为',8)
    p.fact('set','constraint','集合查询列数和类型必须兼容。','包含复合运算符的查询',2)
    p.fact('lock','constraint','FOR UPDATE/SHARE 不能和集合、DISTINCT、GROUP/HAVING 一起用。','● SELECT FOR UPDATE、SELECT FOR SHARE不支持',2)
    p.fact('group_mode','environment','ONLY_FULL_GROUP_BY 改变分组合法条件。','若sql_mode中包含ONLY_FULL_GROUP_BY选项。',15)
    p.fact('subquery_ambiguity','open_question','“子查询不能多列”说明与 FROM 多列派生查询示例范围需区分，不推广为全局禁止。',
           'M-Compatibility模式数据库不支持子查询结果包含多列',5,'needs_verification')
    p.fact('projection_expression','syntax','SELECT投影可使用expression并指定AS输出别名。',
           'expression [ [AS] output_name ]',1)
    p.exports=[p.fid('from_optional'),p.fid('projection_expression')]
    for suffix,kind,statement,status in [
        ('sum_signature','constraint','条件M内建SUM：INT/DECIMAL输入返回DECIMAL，FLOAT/DOUBLE返回DOUBLE；不套用一般或用户函数。','confirmed'),
        ('sum_identity','environment','2.5.11所述返回类型合同的作用域是该M章节定义的SUM函数；此文档范围事实不证明运行期解析身份。','confirmed'),
        ('sum_result','behavior_oracle','M内建SUM返回非NULL输入值的和；该用例使用明确的整数种子行。','confirmed'),
    ]:
        p.fact(suffix,kind,statement,'expression [ [AS] output_name ]',1,status)
        p.facts[-1]['source_anchor'] = f"2.5.11 L952-965；SELECT expression消费者见{p.chapter['section_number']} L43"
    p.dim('statement_form',[('select','',dict(uses_select_contract=True))])
    p.dim('select_modifier',[('none',''),('all','ALL',dict(distinct=False)),('distinct','DISTINCT',dict(distinct=True)),('distinctrow','DISTINCTROW',dict(distinct=True))],'distinct')
    p.dim('cache',[('none',''),('cache','SQL_CACHE'),('no_cache','SQL_NO_CACHE')],'cache')
    for_dim=[('id','',dict(items=['id'],output_columns=['id'],output_types=['INTEGER'],referenced_columns=['id'],nonaggregate_columns=['id'])),
             ('two','',dict(items=['id','qty'],output_columns=['id','qty'],output_types=['INTEGER','INTEGER'],referenced_columns=['id','qty'],nonaggregate_columns=['id','qty']))]
    sum_values = [(f'sum_{column}','',dict(items=[f'SUM({column}) AS total'],
        output_columns=['total'], output_types=['DECIMAL'], referenced_columns=[column],
        nonaggregate_columns=[], has_aggregate=True, function_output_contract='m_builtin_sum',
        source_tables=[SRC], source_columns=[column], source_columns_by_table={SRC:[column]}))
        for column in ('id','qty')]
    p.dim('target_list',for_dim+sum_values)
    for value_class in p.dims['target_list']['classes'][-2:]:
        value_class['values'][0]['fact_refs'] = [p.fid('sum_signature')]
    p.dim('source_form',[('table','',dict(available_columns=['id','qty'],available_types=['INTEGER','INTEGER'])),
                         ('nested','',dict(available_columns=['id','qty'],available_types=['INTEGER','INTEGER']))],'from')
    p.dim('where_clause',[('none',''),('id','WHERE id > 1',dict(referenced_columns=['id']))])
    p.dim('group_by_list',[('none','',dict(active=False))])
    p.dim('order_by_list',[('none',''),('asc','ORDER BY id ASC',dict(columns=['id'])),('desc','ORDER BY id DESC',dict(columns=['id']))])
    p.dim('limit',[('none',''),('count','LIMIT 2'),('comma','LIMIT 1,2'),('offset','LIMIT 2 OFFSET 1')],'limit')
    p.dim('set_operator',[('none','',dict(active=False)),('union','UNION',dict(active=True)),('all','UNION ALL',dict(active=True)),('except','EXCEPT',dict(active=True))],'set')
    p.dim('right_target_list',for_dim)
    p.dim('lock_clause',[('none','',dict(active=False))])
    p.checks=[dict(id=p.id+'_struct_query',kind='select_expression_contract',fact_refs=[p.fid('set'),p.fid('sum_signature')])]
    p.ast=seq(dict(kind='ref',ref='query'),dict(kind='optional',selector='set_operator',
        enabled_values=[p.vid('set_operator',x) for x in ('union','all','except')],
        item=seq(' ',slot('set_operator'),' SELECT ',repeat('right_target_list'),f' FROM {SRC}')),
        ' ',slot('order_by_list'),' ',slot('limit'),' ',slot('lock_clause'))
    p.subgrammars={'query':seq('SELECT ',slot('select_modifier'),' ',slot('cache'),' ',repeat('target_list'),
        ' FROM ',dict(kind='choice',selector='source_form',branches={
            p.vid('source_form','table'):lit(SRC),
            p.vid('source_form','nested'):seq('(',dict(kind='ref',ref='inner'),') AS m_nested')}),
        ' ',slot('where_clause')),
        'inner':seq(f'SELECT id,qty FROM {SRC}')}
    # Selectors consumed by structural checks also need an AST identity node.
    p.ast=seq(slot('statement_form'),p.ast,slot('group_by_list'))
    p.fixtures += [BASE]
    p.manifest('core',dict(select_modifier=['none','all','distinct','distinctrow'],cache=['none','cache','no_cache'],
        target_list=['id','two'],source_form=['table','nested'],where_clause=['none','id'],order_by_list=['none','asc','desc'],limit=['none','count','comma','offset']),[BASE])
    p.manifest('set',dict(target_list=['id','two'],right_target_list=['id','two'],set_operator=['union','all','except']),[BASE])
    p.manifest('sum_builtin',dict(target_list=['sum_id','sum_qty']),[BASE])
    p.files['manifests/sum_builtin.manifest.yaml']['environment_requirements'].append(dict(
        key='function_resolution',allowed_values=['m_builtin_sum'],fact_refs=[p.fid('sum_identity')]))
    p.scenario('sum_result',['sum_result'],[BASE],
        [dict(sql=f'SELECT SUM(qty) AS total FROM {SRC};')],
        [dict(kind='result_set',expected=[[60]])])
    p.files['scenarios/sum_result.scenario.yaml']['preconditions'].append('function_resolution=m_builtin_sum；实际函数身份待环境验证')
    p.scenario('limit_result',['limit'],[BASE],[dict(sql=f'SELECT id FROM {SRC} ORDER BY id LIMIT 1,2;')],
        [dict(kind='result_set',expected=[[2],[3]])])
    p.scenario('lock_incompatibility',['lock'],[BASE],
        [dict(sql=f'SELECT DISTINCT id FROM {SRC} FOR UPDATE;')],
        [dict(kind='target_error',expected='DISTINCT 与行锁不兼容；目标 SQLSTATE 待校准')])
    p.scenario('group_mode',['group_mode'],[BASE],
        [dict(action='显式区分 ONLY_FULL_GROUP_BY 开关；补函数依赖和分组列合同')],
        [dict(kind='result_set',expected='非分组投影的合法性按 M 模式条件判断，不沿用通用模式一律拒绝')])
    add_extrema_consumers(p)
    add_approximate_aggregate_sources(p)
    add_avg_consumers(p)
    add_count_consumers(p)
    return p


def add_extrema_consumers(p):
    """Two existing integer columns consume precise M MIN/MAX signatures."""
    for function,span,result in (('max','L574-591',30),('min','L635-652',10)):
        name=function.upper()
        definitions=[
            ('signature','constraint',f'条件M内建{name}表字段：FLOAT返回DOUBLE，其他字段返回输入类型；当前合同只支持裸INT及FLOAT/DOUBLE字段，不能套到非字段表达式。','confirmed'),
            ('identity','environment',f'返回类型合同仅来自M2.5.11内建{name}；实际函数解析身份须在执行环境独立核实。','confirmed'),
            ('result','behavior_oracle',f'M内建{name}取非NULL输入的'+('最大值' if function=='max' else '最小值')+'，全NULL返回NULL；本代表仅使用已有三个明确整数seed行。','confirmed'),
            ('gap','open_question',f'{name}仅两个已有整数表字段；其他类型/集合/字符串排序、非字段表达式、窗口、全NULL及空表行为待独立fixture和Oracle，不因四条候选推断完整。','needs_verification')]
        for suffix,kind,statement,status in definitions:
            p.fact(function+'_'+suffix,kind,statement,'expression [ [AS] output_name ]',1,status)
            p.facts[-1]['source_anchor']=f'2.5.11 {span}；SELECT expression消费者见{p.chapter["section_number"]} L43'
        for column in ('id','qty'):
            identity=p.vid('target_list',f'{function}_{column}')
            properties=dict(items=[f'{name}({column}) AS result'],output_columns=['result'],
                output_types=['INTEGER'],referenced_columns=[column],nonaggregate_columns=[],has_aggregate=True,
                function_output_contract='m_builtin_'+function,source_tables=[SRC],source_columns=[column],
                source_columns_by_table={SRC:[column]})
            p.dims['target_list']['classes'].append(dict(id=identity+'_class',meaning=f'{function}_{column}',
                values=[dict(id=identity,render='',representative=True,validity='valid',properties=properties,
                             fact_refs=[p.fid(function+'_signature')])]))
        p.checks[0]['fact_refs'].append(p.fid(function+'_signature'))
        p.manifest(function+'_builtin',dict(target_list=[function+'_id',function+'_qty']),[BASE])
        p.files[f'manifests/{function}_builtin.manifest.yaml']['environment_requirements'].append(dict(
            key='function_resolution',allowed_values=['m_builtin_'+function],fact_refs=[p.fid(function+'_identity')]))
        p.scenario(function+'_result',[function+'_result',function+'_gap'],[BASE],
            [dict(sql=f'SELECT {name}(qty) AS result FROM {SRC};')],
            [dict(kind='result_set',expected=[[result]])])
        p.files[f'scenarios/{function}_result.scenario.yaml']['preconditions'].append(
            f'function_resolution=m_builtin_{function}；实际函数身份与驱动返回类型待环境验证')


def add_approximate_aggregate_sources(p):
    """Actual M FLOAT/DOUBLE DDL consumers; no write/default type expansion."""
    p.fact('approximate_source_types','syntax',
           'M2.6.7.4支持FLOAT/DOUBLE列声明；本fixture只用无typmod的两个拼写，不从REAL或精度形式推导默认行为。',
           'expression [ [AS] output_name ]',1)
    p.facts[-1]['source_anchor']='2.6.7.4 L1160-1229；SELECT expression消费者见2.4.2.16.2 L43'
    p.fact('approximate_source_gap','open_question',
           '近似数值这里只作M聚合读源声明：DEFAULT、NOT NULL、精度/舍入/范围、REAL_AS_FLOAT、FLOAT4/8别名和一般模式读写语义尚未接入；驱动结果类型待校准。',
           'expression [ [AS] output_name ]',1,'needs_verification')
    p.facts[-1]['source_anchor']='2.6.7.4 L1188-1229；SELECT expression消费者见2.4.2.16.2 L43'
    source_branch=next(item for item in p.subgrammars['query']['items'] if item.get('selector')=='source_form')
    ns='m_select_approximate_ns'
    for typ in ('float','double'):
        table=f'{ns}.{typ}_source'
        fx=p.fixture(typ+'_source',[(table,['qty'])],
            [f'CREATE SCHEMA {ns};',f'CREATE TABLE {table} (qty {typ.upper()});',
             f'INSERT INTO {table} (qty) VALUES (1.5),(2.5);'],
            [f'DROP TABLE {table} RESTRICT;',f'DROP SCHEMA {ns};'])
        obj=p.files[f'fixtures/{typ}_source.fixture.yaml']
        obj['provides']['tables'][0]['columns'][0]['type']=typ.upper()
        obj['execution']['note']=(
            '仅已授权M物理数据库中的独占新模式/连接；模式事前不存在、非系统且非同名用户模式。'
            '实际声明裸'+typ.upper()+'，不靠provides假报INTEGER；两个seed为有限1.5/2.5，不测舍入或越界。'
            '只按创建成功及实际归属记录逆序清理本case空模式/表，无CASCADE或DROP OWNED，不依赖DDL回滚。'
            '失败时不能继续目标或按名称删除他人对象；模式不再拥有本case之外对象才允许DROP。'
            '真实函数解析、数据插入/元数据与驱动结果仍待授权执行校准。')
        source_id=p.vid('source_form',typ)
        source_refs=[p.fid('approximate_source_types'),'m_create_table::m_create_table_fact_syntax']
        p.dims['source_form']['classes'].append(dict(id=source_id+'_class',meaning=typ,values=[
            dict(id=source_id,render='',representative=True,validity='valid',
                 properties=dict(available_columns=['qty'],available_types=[typ.upper()]),fact_refs=source_refs)]))
        source_branch['branches'][source_id]=lit(table)
        steps,oracles=[],[]
        for fn,result in (('sum',4.0),('min',1.5),('max',2.5)):
            identity=p.vid('target_list',fn+'_'+typ)
            props=dict(items=[f'{fn.upper()}(qty) AS result'],output_columns=['result'],output_types=['DOUBLE'],
                referenced_columns=['qty'],nonaggregate_columns=[],has_aggregate=True,
                function_output_contract='m_builtin_'+fn,source_tables=[table],source_columns=['qty'],
                source_columns_by_table={table:['qty']})
            p.dims['target_list']['classes'].append(dict(id=identity+'_class',meaning=fn+'_'+typ,values=[
                dict(id=identity,render='',representative=True,validity='valid',properties=props,
                     fact_refs=[p.fid(fn+'_signature'),p.fid('approximate_source_types')])]))
            p.manifest(fn+'_'+typ,dict(target_list=[fn+'_'+typ],source_form=[typ]),[fx])
            m=p.files[f'manifests/{fn}_{typ}.manifest.yaml']
            m['environment_requirements'] += [
                dict(key='function_resolution',allowed_values=['m_builtin_'+fn],fact_refs=[p.fid(fn+'_identity')]),
                dict(key='namespace_create_authority',allowed_values=['database_create'],
                     fact_refs=['m_create_schema::m_create_schema_fact_authority']),
                dict(key='table_create_authority',allowed_values=['create_any_table_in_owned_schema'],
                     fact_refs=['m_create_table::m_create_table_fact_authority']),
                dict(key='namespace_identity',allowed_values=['fresh_non_system_non_user_named_owned_schema'],
                     fact_refs=['m_create_schema::m_create_schema_fact_namespace','m_create_schema::m_create_schema_fact_same_name_owner']),
                dict(key='namespace_drop_authority',allowed_values=['actual_case_schema_owner'],
                     fact_refs=['m_drop_schema::m_drop_schema_fact_authority'])]
            steps.append(dict(id=fn,sql=f'SELECT {fn.upper()}(qty) AS result FROM {table};'))
            oracles += [dict(kind='result_set',step_id=fn,expected=[[result]]),
                        dict(kind='manual_assertion',step_id=fn,
                             expected=f'在已核实M内建{fn.upper()}身份下，返回列声明类型为DOUBLE；目录/驱动类型接口待校准，不以Python数值类型替代。')]
        p.scenario(typ+'_aggregates',['sum_result','min_result','max_result','approximate_source_gap'],[fx],steps,oracles)
        s=p.files[f'scenarios/{typ}_aggregates.scenario.yaml']
        s['execution_requirements'] += ['isolated_connection','close_case_connection','per_step_oracle']
        s['preconditions'] += ['每一步实际函数身份分别核为M内建SUM/MIN/MAX；实际FLOAT/DOUBLE源列元数据已核验。']


def add_avg_consumers(p):
    """AVG reuses existing integer and approximate source fixtures unchanged."""
    for suffix,kind,statement,status in (
        ('signature','constraint','M内建AVG：INT/DECIMAL输入返回DECIMAL，FLOAT/DOUBLE返回DOUBLE；这里只绑定已审裸字段与基础声明类型。','confirmed'),
        ('identity','environment','AVG返回类型规则只用于M2.5.11对应内建函数身份；执行前需核对实际解析身份，不能借用一般模式或同名用户函数。','confirmed'),
        ('result','behavior_oracle','M内建AVG取非NULL输入平均值；ALL或省略修饰词保留重复非NULL值，DISTINCT取不同值，全NULL返回NULL。','confirmed'),
        ('gap','open_question','当前仅两个INTEGER字段及FLOAT/DOUBLE各一字段；全NULL、空表、重复值DISTINCT、窗口、其他整数类型、精度/舍入/溢出及驱动结果元数据未完成验证。','needs_verification')):
        p.fact('avg_'+suffix,kind,statement,'expression [ [AS] output_name ]',1,status)
        p.facts[-1]['source_anchor']='2.5.11 L72-87；SELECT expression消费者见2.4.2.16.2 L43'
    p.checks[0]['fact_refs'].append(p.fid('avg_signature'))
    for suffix,source_form,table,columns,output,fixture in (
        ('builtin','table',SRC,('id','qty'),'DECIMAL',BASE),
        ('float','float','m_select_approximate_ns.float_source',('qty',),'DOUBLE','fixture_m_select_float_source'),
        ('double','double','m_select_approximate_ns.double_source',('qty',),'DOUBLE','fixture_m_select_double_source')):
        targets,steps,oracles=[],[],[]
        for column in columns:
            target='avg_'+column if suffix=='builtin' else 'avg_'+suffix
            targets.append(target)
            identity=p.vid('target_list',target)
            props=dict(items=[f'AVG({column}) AS result'],output_columns=['result'],output_types=[output],
                referenced_columns=[column],nonaggregate_columns=[],has_aggregate=True,
                function_output_contract='m_builtin_avg',source_tables=[table],source_columns=[column],
                source_columns_by_table={table:[column]})
            p.dims['target_list']['classes'].append(dict(id=identity+'_class',meaning=target,values=[
                dict(id=identity,render='',representative=True,validity='valid',properties=props,
                     fact_refs=[p.fid('avg_signature')])]))
            steps.append(dict(id=column,sql=f'SELECT AVG({column}) AS result FROM {table};'))
            result=(2 if column=='id' else 20) if suffix=='builtin' else 2.0
            oracles += [dict(kind='result_set',step_id=column,expected=[[result]]),
                        dict(kind='manual_assertion',step_id=column,
                             expected=f'实际解析M内建AVG，输出列类型应为{output}；须校准目录/驱动元数据，不以Python值类型代替。')]
        p.manifest('avg_'+suffix,dict(target_list=targets,source_form=[source_form]),[fixture])
        m=p.files[f'manifests/avg_{suffix}.manifest.yaml']
        # Reuse only matching fixture authority gates, not SUM's identity fact.
        original=p.files[f'manifests/sum_{suffix}.manifest.yaml']['environment_requirements']
        m['environment_requirements']=[copy.deepcopy(g) for g in original if g['key']!='function_resolution']
        m['environment_requirements'].append(dict(key='function_resolution',allowed_values=['m_builtin_avg'],
                                                fact_refs=[p.fid('avg_identity')]))
        p.scenario('avg_'+suffix,['avg_result','avg_gap'],[fixture],steps,oracles)
        s=p.files[f'scenarios/avg_{suffix}.scenario.yaml']
        s['execution_requirements'] += ['isolated_connection','close_case_connection','per_step_oracle']
        s['preconditions'] += ['function_resolution=m_builtin_avg；实际源列和种子须与fixture一致，真实类型元数据待校准。']


def add_count_consumers(p):
    """Bare-field COUNT and a distinct row-count form on real nullable seeds."""
    for suffix,kind,statement,status in (
        ('signature','constraint','M内建普通COUNT/ALL和DISTINCT返回BIGINT；本有限合同只接普通表的单个INTEGER字段及独立COUNT(*)计行分支，不把任意表达式纳入已检查。','confirmed'),
        ('identity','environment','COUNT类型与计数规则仅绑定M2.5.11内建函数；实际解析身份执行前另核，不继承其他模式或用户函数。','confirmed'),
        ('result','behavior_oracle','普通COUNT和COUNT(ALL expr)计非NULL值，DISTINCT计不同非NULL值；全NULL字段返回0；COUNT(*)另计所有行。','confirmed'),
        ('gap','open_question','目前六个单字段、一个COUNT(*)及四个全NULL字段对照代表；多参DISTINCT、窗口、空表、非INTEGER字段输入、溢出及所有运行期值/元数据仍未验证。','needs_verification')):
        p.fact('count_'+suffix,kind,statement,'expression [ [AS] output_name ]',1,status)
        p.facts[-1]['source_anchor']='2.5.11 L338-388；SELECT expression消费者见2.4.2.16.2 L43'
    p.checks[0]['fact_refs'].append(p.fid('count_signature'))
    ns='m_select_count_ns';table=ns+'.source_table'
    rows=[dict(id=i,qty=q) for i,q in ((1,None),(1,1),(1,2),(1,2),(2,None),(2,None))]
    fx=p.fixture('count_source',[(table,['id','qty'])],
        [f'CREATE SCHEMA {ns};',f'CREATE TABLE {table} (id INTEGER, qty INTEGER);',
         f'INSERT INTO {table} (id,qty) VALUES (1,NULL),(1,1),(1,2),(1,2),(2,NULL),(2,NULL);'],
        [f'DROP TABLE {table} RESTRICT;',f'DROP SCHEMA {ns};'])
    obj=p.files['fixtures/count_source.fixture.yaml']
    obj['seed']=dict(required=True,rows=rows)
    obj['execution']['note']=(
        '仅已授权M物理数据库中的独占新模式/隔离连接；模式初始不存在、非系统非用户同名。'
        '两个真实INTEGER可空列与六行seed逐项一致；不把缺失字段、NULL常量或空结果集当成列计数。'
        '只按实际创建成功与归属记录逆序清理本case表和空模式；setup失败阻止目标和盲目teardown。'
        '不用CASCADE、DROP OWNED、吞异常或DDL回滚兜底；不能清理他人对象。'
        '实际seed内容、函数解析及BIGINT驱动元数据仍须授权验证，本fixture不是执行许可。')
    source_id=p.vid('source_form','count_nullable')
    p.dims['source_form']['classes'].append(dict(id=source_id+'_class',meaning='count_nullable',values=[
        dict(id=source_id,render='',representative=True,validity='valid',
             properties=dict(available_columns=['id','qty'],available_types=['INTEGER','INTEGER']),
             fact_refs=['m_create_table::m_create_table_fact_syntax',p.fid('count_signature')])]))
    source_branch=next(item for item in p.subgrammars['query']['items'] if item.get('selector')=='source_form')
    source_branch['branches'][source_id]=lit(table)
    targets,steps,oracles=[],[],[]
    for column in ('id','qty'):
        for modifier,prefix in (('plain',''),('all','ALL '),('distinct','DISTINCT ')):
            target='count_'+column+'_'+modifier;targets.append(target)
            identity=p.vid('target_list',target);item=f'COUNT({prefix}{column}) AS result'
            props=dict(items=[item],output_columns=['result'],output_types=['BIGINT'],
                referenced_columns=[column],nonaggregate_columns=[],has_aggregate=True,
                function_output_contract='m_builtin_count',source_tables=[table],source_columns=[column],
                source_columns_by_table={table:[column]})
            p.dims['target_list']['classes'].append(dict(id=identity+'_class',meaning=target,values=[
                dict(id=identity,render='',representative=True,validity='valid',properties=props,
                     fact_refs=[p.fid('count_signature')])]))
            steps.append(dict(id=target,sql=f'SELECT {item} FROM {table};'))
            result=2 if modifier=='distinct' else 6 if column=='id' else 3
            oracles += [dict(kind='result_set',step_id=target,expected=[[result]]),
                        dict(kind='manual_assertion',step_id=target,
                             expected='实际解析M内建COUNT，输出列类型应为BIGINT；须校准目录/驱动类型接口，不能以Python整数类型代替。')]
    p.manifest('count_nullable',dict(target_list=targets,source_form=['count_nullable']),[fx])
    m=p.files['manifests/count_nullable.manifest.yaml']
    m['environment_requirements']=[copy.deepcopy(g) for g in
        p.files['manifests/sum_float.manifest.yaml']['environment_requirements'] if g['key']!='function_resolution']
    m['environment_requirements'].append(dict(key='function_resolution',allowed_values=['m_builtin_count'],
                                            fact_refs=[p.fid('count_identity')]))
    p.scenario('count_nullable',['count_result','count_gap'],[fx],steps,oracles)
    s=p.files['scenarios/count_nullable.scenario.yaml']
    s['execution_requirements'] += ['isolated_connection','close_case_connection','per_step_oracle','ownership_scoped_cleanup']
    s['preconditions'] += ['function_resolution=m_builtin_count；六行实际seed及两列INTEGER元数据先核验，再逐步对照NULL与重复值计数。']
    target='count_star';identity=p.vid('target_list',target)
    p.dims['target_list']['classes'].append(dict(id=identity+'_class',meaning=target,values=[
        dict(id=identity,render='',representative=True,validity='valid',
             properties=dict(items=['COUNT(*) AS result'],output_columns=['result'],output_types=['BIGINT'],
                referenced_columns=[],nonaggregate_columns=[],has_aggregate=True,
                function_output_contract='m_builtin_count',source_tables=[table],source_columns=[],
                source_columns_by_table={table:[]}),fact_refs=[p.fid('count_signature'),p.fid('count_result')])]))
    p.manifest('count_star',dict(target_list=[target],source_form=['count_nullable']),[fx])
    p.files['manifests/count_star.manifest.yaml']['environment_requirements']=copy.deepcopy(m['environment_requirements'])
    p.scenario('count_star',['count_result','count_gap'],[fx],
        [dict(id=target,sql=f'SELECT COUNT(*) AS result FROM {table};')],
        [dict(kind='result_set',step_id=target,expected=[[6]]),
         dict(kind='manual_assertion',step_id=target,
              expected='实际M内建COUNT(*)输出BIGINT；须校准驱动/目录类型及六行seed，含NULL行不能按COUNT(qty)=3计算。')])
    star=p.files['scenarios/count_star.scenario.yaml']
    star['execution_requirements'] += ['isolated_connection','close_case_connection','per_step_oracle','ownership_scoped_cleanup']
    star['preconditions'] += ['function_resolution=m_builtin_count；复用六行含NULL/重复值源表，只验证独立COUNT(*)，不推导ALL *、DISTINCT *或窗口形式。']
    # Alternative fresh seed, not a wrapper with an unproved DELETE transition.
    null_fx='fixture_'+p.id+'_count_all_null_source'
    null_source=copy.deepcopy(obj)
    null_source['id']=null_fx
    null_source['name']=null_fx
    null_source['seed']=dict(required=True,rows=[dict(id=2,qty=None),dict(id=2,qty=None)])
    null_source['execution']['setup_sqls'][-1]=f'INSERT INTO {table} (id,qty) VALUES (2,NULL),(2,NULL);'
    null_source['execution']['note']=(
        '与六行count_source互斥的独占新模式/隔离连接fixture，不同时组合。两列真实INTEGER可空，'
        '只有两行(id=2,qty=NULL)的完整literal seed；不是空表，不解释DELETE/WHERE后的状态。'
        '仅M物理数据库授权后执行，模式初始不存在且非系统非用户同名；实际创建者记录归属。'
        'setup失败阻止目标和盲目teardown，只逆序清理本case实际创建成功的表及空模式。'
        '无CASCADE/DROP OWNED/吞异常/DDL回滚兜底，实际计数和BIGINT元数据仍须校准。')
    p.files['fixtures/count_all_null_source.fixture.yaml']=null_source;p.fixtures.append(null_fx)
    null_targets=['count_qty_plain','count_qty_all','count_qty_distinct','count_star']
    p.manifest('count_all_null',dict(target_list=null_targets,source_form=['count_nullable']),[null_fx])
    p.files['manifests/count_all_null.manifest.yaml']['environment_requirements']=copy.deepcopy(m['environment_requirements'])
    null_steps=[];null_oracles=[]
    for target,argument,result in zip(null_targets,('qty','ALL qty','DISTINCT qty','*'),(0,0,0,2)):
        null_steps.append(dict(id=target,sql=f'SELECT COUNT({argument}) AS result FROM {table};'))
        null_oracles += [dict(kind='result_set',step_id=target,expected=[[result]]),
            dict(kind='manual_assertion',step_id=target,
                 expected='实际M内建COUNT输出BIGINT；两行qty均NULL不是空表，星号计2、字段计0，驱动/目录类型仍须校准。')]
    p.scenario('count_all_null',['count_result','count_gap'],[null_fx],null_steps,null_oracles)
    null_s=p.files['scenarios/count_all_null.scenario.yaml']
    null_s['execution_requirements'] += ['isolated_connection','close_case_connection','per_step_oracle','ownership_scoped_cleanup']
    null_s['preconditions'] += ['function_resolution=m_builtin_count；先核两行完整seed为(2,NULL),(2,NULL)，不得借六行或空表结果。']


BUILDERS = {f.__name__: f for f in (create_table,create_view,insert,update,delete,select)}


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command',choices=BUILDERS)
    parser.add_argument('--update', action='store_true', help='Emit diffs for these curated pilot files only')
    args=parser.parse_args()
    p=BUILDERS[args.command]()
    print('*** Begin Patch')
    for name,obj in p.finish().items():
        path=ROOT/'specs'/p.category.lower()/p.id/name
        rendered = yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110)
        if path.exists():
            if not args.update:
                raise FileExistsError(path)
            previous = path.read_text()
            if previous == rendered:
                continue
            print('*** Update File: '+str(path))
            for line in list(difflib.unified_diff(previous.splitlines(),rendered.splitlines(),lineterm=''))[2:]:
                print('@@' if line.startswith('@@') else line)
        else:
            print('*** Add File: '+str(path))
            for line in rendered.splitlines():
                print('+'+line)
    print('*** End Patch')


if __name__=='__main__':
    main()
