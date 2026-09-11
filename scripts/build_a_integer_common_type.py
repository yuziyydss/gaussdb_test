"""Emit a curated, mode-bound A integer increment; never connect to a database."""
import argparse
import difflib
import hashlib
import json
import re
import yaml

from scripts.build_common_type_batch import ROOT, DOCUMENT, PDF_SHA, SOURCES, dump, entity

CONTRACT = 'a_integer_union_case_v1'
ENV = 'select_fact_a_integer_environment'
RULE = 'select_fact_a_integer_common'
QUERIES = [
    ('union_small_int', 'SELECT lo FROM a_common_source UNION SELECT mid FROM a_common_source', 'INTEGER'),
    ('union_int_small', 'SELECT mid FROM a_common_source UNION SELECT lo FROM a_common_source', 'INTEGER'),
    ('case_small_big', 'SELECT CASE WHEN TRUE THEN lo ELSE hi END AS result FROM a_common_source', 'BIGINT'),
    ('case_big_small', 'SELECT CASE WHEN TRUE THEN hi ELSE lo END AS result FROM a_common_source', 'BIGINT'),
]


def planned_files():
    changes = {}
    def read(path): return changes.get(path, (ROOT/path).read_text())
    def prepend(path, key, items):
        text = read(path); obj = yaml.safe_load(text); fresh = []
        for item in items:
            old = next((x for x in obj.get(key, []) if isinstance(item, dict) and x['id'] == item['id']), None)
            if old is not None:
                assert old == item, (path, item['id'])
            elif item not in obj.get(key, []): fresh.append(item)
        if not fresh: return
        block = '\n'.join('  '+line for line in dump(fresh).rstrip().splitlines())+'\n'
        token = key+':\n'
        if token in text: text = text.replace(token, token+block, 1)
        elif key+': []' in text: text = text.replace(key+': []', token+block.rstrip(), 1)
        else:
            assert key not in obj, path
            text += '\n'+token+block
        changes[path] = text
    def new(path, obj):
        if not (ROOT/path).exists() or yaml.safe_load((ROOT/path).read_text()) != obj: changes[path] = dump(obj)
    def make(kind, id, factor, **values):
        values.setdefault('description', 'A兼容表1-309的int2/int4/int8有限子集；未执行数据库，不代表全章覆盖。')
        return entity(kind, id, factor, **values)

    fp = 'specs/dml/select/select.factor.yaml'
    prepend(fp, 'facts', [
        dict(id=ENV, type='environment', statement='表1-309明确适用A兼容模式；本合同仅在显式物理A门下消费，不外推PG/M/C。', status='confirmed', source_anchor='1.9.5 L28-L34'),
        dict(id=RULE, type='constraint', statement='A模式表1-309中int2/int4/int8九个有序输入对，结果为二者中较宽整数类型；仅共同结果类型，不是存储赋值或任意转换表。', status='confirmed', source_anchor='1.9.5 L37-L52'),
    ])
    prepend(fp, 'exported_fact_refs', [ENV, RULE])
    base, rel, sha, section = SOURCES['common']
    sid = 'select_type_a_integer_source'
    sp = 'specs/dml/select/select.source.yaml'
    prepend(sp, 'supplemental_sources', [dict(id=sid, document='1.9.5 A模式整数结果类型子集',version='V2.0-10.0.0',
        catalog_chapter_ref=dict(document_id=DOCUMENT,source_relpath=rel,chapter_sha256=sha),
        source_anchor='L28-L52',retrieval_date='2026-09-11')])
    text = read(sp); unit = next(u for u in yaml.safe_load(text)['units'] if u['id']=='select_src_028')
    if sid not in unit.get('supplemental_source_refs', []):
        match = re.search(r'(?m)^(?P<indent> *)- id: select_src_028\n.*?(?=^ *- (?:\{)?id: |\Z)',text,re.S)
        assert match
        unit['fact_refs'] += [ENV,RULE]; unit['supplemental_source_refs'].append(sid)
        unit['independent_claim_count'] = len(unit['fact_refs'])
        block = '\n'.join(match['indent']+line for line in dump([unit]).rstrip().splitlines())+'\n'
        changes[sp] = text[:match.start()]+block+text[match.end():]
    for f in ('select','insert'):
        path=f'specs/dml/{f}/{f}.factor.yaml'
        prepend(path,'manifest_refs',[f'manifest_{f}_common_type_a_integer'])
        prepend(path,'fixture_refs',[f'fixture_{f}_common_type_a_integer'])

    new('specs/dml/select/fixtures/common_type_a_integer.fixture.yaml',make('fixture','fixture_select_common_type_a_integer','select',
        provides=dict(tables=[dict(name='a_common_source',persistence='permanent',table_kind='regular',
            columns=[dict(name=n,type=t,nullable=True) for n,t in [('lo','SMALLINT'),('mid','INTEGER'),('hi','BIGINT')]])]),
        seed=dict(required=True,rows=[dict(lo=1,mid=10,hi=100),dict(lo=2,mid=20,hi=200)]),
        execution=dict(status='ready',mode='explicit',setup_sqls=[
            'CREATE TABLE a_common_source (lo SMALLINT, mid INTEGER, hi BIGINT);',
            'INSERT INTO a_common_source VALUES (1,10,100),(2,20,200);'],teardown_sqls=['DROP TABLE a_common_source;'],
            note='显式A环境、新独占schema，名称须不存在；仅清理本轮成功创建对象。未获数据库执行授权。')))
    new('specs/dml/insert/fixtures/common_type_a_integer.fixture.yaml',make('fixture','fixture_insert_common_type_a_integer','insert',
        requires_fixture_refs=['fixture_select_common_type_a_integer'],
        provides=dict(tables=[dict(name='a_common_target',persistence='permanent',table_kind='regular',columns=[dict(name='result',type='BIGINT',nullable=True)])]),
        seed=dict(required=False,rows=[]),execution=dict(status='ready',mode='explicit',
            setup_sqls=['CREATE TABLE a_common_target (result BIGINT);'],teardown_sqls=['DROP TABLE a_common_target;'],
            note='来源依赖先创建，逆序清理；不扩大为BIGINT向INTEGER隐式存储转换。')))
    select_profiles = [dict(id='select_common_a_'+suffix,render=query,validity='valid',
        fixture_refs=['fixture_select_common_type_a_integer'],fact_refs=[RULE],
        properties=dict(common_type_contract=CONTRACT,output_types=[typ],output_column_count=1,
                        source_tables=['a_common_source'],features=['finite_a_integer_common_type'])) for suffix,query,typ in QUERIES]
    insert_profiles = [dict(id='insert_source_common_a_'+suffix,render=query,validity='valid',
        fact_refs=['insert_fact_storage_exact','insert_fact_query_source','select::'+RULE],
        properties=dict(common_type_contract=CONTRACT,source_kind='query',output_types=[typ],output_column_count=1,
                        source_tables=['a_common_source'],source_columns=['lo','hi']))
        for suffix,query,typ in QUERIES if suffix.startswith('case_')]
    prepend('specs/dml/select/matrices/query_profiles.matrix.yaml','profiles',select_profiles)
    prepend('specs/dml/insert/matrices/source_profiles.matrix.yaml','profiles',insert_profiles)
    prepend('specs/dml/insert/matrices/target_profiles.matrix.yaml','profiles',[dict(id='insert_target_common_a_integer',
        render='a_common_target (result)',validity='valid',fixture_refs=['fixture_insert_common_type_a_integer'],
        fact_refs=['insert_fact_storage_exact','insert_fact_column_mapping'],properties=dict(target_kind='table',explicit_columns=True,
        target_column_count=1,target_types=['BIGINT'],available_column_count=1,available_types=['BIGINT']))])
    insert_bindings=dict(target_profile=['insert_target_common_a_integer'],source_profile=[p['id'] for p in insert_profiles],
        with_clause=['insert_with_none'],ignore_modifier=['insert_ignore_none'],conflict_clause=['insert_conflict_none'],returning_clause=['insert_returning_none'])
    for f in ('select','insert'):
        new(f'specs/dml/{f}/manifests/common_type_a_integer.manifest.yaml',make('manifest',f'manifest_{f}_common_type_a_integer',f,
            syntax_ref='syntax_'+f+'_v1',suite_type='positive',strategy='full_cartesian',fixture_refs=[],identifier_policy={},
            bindings={'query_profile':[p['id'] for p in select_profiles]} if f=='select' else insert_bindings,
            environment_requirements=[dict(key='compatibility_mode',allowed_values=['A'],fact_refs=[
                'create_database::create_database_fact_compatibility_environment',ENV if f=='select' else 'select::'+ENV])],
            expected=dict(default='success',scope='syntax_only'),coverage_requirements=dict(strength=2,require_all_feasible_pairs=True)))
    scenario='scenario_insert_common_a_integer'
    new('specs/dml/insert/scenarios/common_a_integer.scenario.yaml',make('scenario',scenario,'insert',
        fixture_refs=['fixture_insert_common_type_a_integer'],fact_refs=['insert_fact_storage_exact','select::'+RULE],
        steps=[dict(id='target',candidate=dict(manifest_ref='manifest_insert_common_type_a_integer',
            params={k:v[0] for k,v in insert_bindings.items()}))],
        oracles=[dict(kind='result_set',step_id='target',sql='SELECT result FROM a_common_target ORDER BY result;',expected=[[1],[2]]),
                 dict(kind='manual_assertion',step_id='target',expected='实机校准共同结果类型及目标错误类别；当前不承诺SQLSTATE。')],
        execution_requirements=['database_authorization','physical_a_connection','target_oracle_calibration','owned_asset_cleanup']))
    prepend('specs/dml/insert/insert.factor.yaml','scenario_refs',[scenario])
    return {p:t for p,t in changes.items() if not (ROOT/p).exists() or (ROOT/p).read_text()!=t}


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--check',action='store_true');args=parser.parse_args()
    assert hashlib.sha256((ROOT/'gaussdb-rf-cent.pdf').read_bytes()).hexdigest()==PDF_SHA
    base,rel,sha,section=SOURCES['common']
    catalog=json.loads((ROOT/base/'catalog.json').read_text())
    assert catalog['document_id']==DOCUMENT and catalog['parent_pdf_sha256']==PDF_SHA
    assert next(c for c in catalog['chapters'] if c['section_number']==section)['chapter_sha256']==sha
    assert hashlib.sha256((ROOT/base/rel).read_bytes()).hexdigest()==sha
    changes=planned_files()
    if args.check:
        assert not changes, sorted(changes)
        print('A integer curated increment and source hashes match; no execution.');return
    print('*** Begin Patch')
    for path,content in changes.items():
        if not (ROOT/path).exists():
            print('*** Add File: '+str(ROOT/path));print('\n'.join('+'+line for line in content.splitlines()))
        else:
            print('*** Update File: '+str(ROOT/path))
            lines=list(difflib.unified_diff((ROOT/path).read_text().splitlines(),content.splitlines(),n=3))[2:]
            print('\n'.join('@@' if line.startswith('@@') else line for line in lines))
    print('*** End Patch')


if __name__=='__main__': main()
