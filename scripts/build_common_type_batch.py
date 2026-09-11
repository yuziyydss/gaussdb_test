"""Curated PDF 1.9.4/1.9.5 increment; emit a reviewable patch, never execute SQL."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import re
import yaml

ROOT=Path(__file__).resolve().parents[1]
DOCUMENT='gaussdb_v2_0_10_0_0_centralized_reference_01'
PDF_SHA='716ab36bb4410cb823c76cd331d06f06a43ae81ce6b3a267ffe17085b3d3acbe'
SOURCES={
    'storage': ('work/pdf_foundations_2026_09_07/corpus', 'general/utility/section_1_9_4.txt',
                '93883538f465c79e914c90abeb956be314c286661e08956d7845c91b889ea9aa','1.9.4'),
    'common': ('work/pdf_foundations_2026_09_07/foundation_batch_05/corpus','general/utility/union_case.txt',
               '9f169c91b5e9056010d430d1efddff1cdf165e77a0bc9ce352ce51ec88a6244d','1.9.5')}
RULES=[
    ('storage_exact','storage',5,5,'精确匹配目标字段类型优先。','finite_consumer'),
    ('storage_conversion','storage',6,8,'跨类型需注册转换；unknown文本还需内容转换。','deferred'),
    ('storage_typmod','storage',9,15,'存储前另有长度/atttypmod转换，不能由类型相同推导长度安全。','deferred'),
    ('common_positions','common',3,7,'共同类型算法逐输出列应用；CASE等构造也解析结果类型。','finite_consumer'),
    ('common_same','common',11,11,'所有输入类型相同且非unknown时解析为该类型。','finite_consumer'),
    ('common_all_unknown','common',12,13,'所有输入为unknown时解析为text。','finite_consumer'),
    ('common_unknown_input','common',12,23,'选择类型时忽略unknown，但仍须验证输入向结果类型的转换。','finite_consumer'),
    ('common_category','common',14,14,'排除unknown后，不同类型范畴不能匹配。','finite_guard'),
    ('common_preference','common',15,34,'混合类型首选类型、隐式转换及解析次序需分构造和模式解释。','deferred'),
    ('storage_a_table','storage',17,78,'表1-308明确限于A兼容模式，不能作为PG/M通用赋值转换表。','deferred')]
SF=[f'select_fact_{r[0]}' for r in RULES if r[0].startswith('common_') and r[5]!='deferred']
IF='insert_fact_storage_exact'
CONTRACT='pg_scalar_union_case_v1'
QUERIES=[
    ('case_integer','SELECT CASE WHEN flag THEN id ELSE qty END AS result FROM g_common_source',['INTEGER'],[[1],[20],[None]]),
    ('case_null','SELECT CASE WHEN TRUE THEN id ELSE NULL END AS result FROM g_common_source',['INTEGER'],[[1],[2],[3]]),
    ('union_integer','SELECT id FROM g_common_source UNION SELECT qty FROM g_common_source',['INTEGER'],None),
    ('union_null','SELECT id FROM g_common_source UNION ALL SELECT NULL',['INTEGER'],None),
    ('union_unknown','SELECT NULL UNION SELECT NULL',['TEXT'],[[None]]),
    ('union_text',"SELECT 'a' UNION SELECT 'b'",['TEXT'],None),
    ('union_columns','SELECT id, note FROM g_common_source UNION SELECT qty, NULL FROM g_common_source',['INTEGER','TEXT'],None)]


def dump(obj): return yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110)


def entity(kind,id,factor,**values):
    values.setdefault('description','有限PG类型解析与真实资产；不承诺全章覆盖或数据库结果。')
    return dict(schema_version=1,kind=kind,id=id,name=id,status='planned' if kind=='scenario' else 'needs_review',factor_ref=factor,**values)


def planned_files():
    changes={}
    def read(path): return changes.get(path,(ROOT/path).read_text())
    def prepend(path,key,items):
        text=read(path);obj=yaml.safe_load(text)
        existing=obj.get(key,[])
        fresh=[]
        for item in items:
            if isinstance(item,dict):
                old=next((o for o in existing if o.get('id')==item['id']),None)
                if old is not None:
                    assert old==item,(path,item['id']);continue
            elif item in existing: continue
            fresh.append(item)
        if fresh:
            token=key+':\n'
            block='\n'.join('  '+line for line in dump(fresh).rstrip().splitlines())+'\n'
            if token not in text:
                if key+': []' in text: text=text.replace(key+': []',key+':\n'+block.rstrip(),1)
                else:
                    assert key not in obj,path
                    text+='\n'+key+':\n'+block
            else: text=text.replace(token,token+block,1)
            changes[path]=text
    def new(path,obj):
        if not (ROOT/path).exists() or yaml.safe_load((ROOT/path).read_text())!=obj:
            changes[path]=dump(obj)
    def supplement(factor,key,facts,consumer_id):
        base,rel,sha,section=SOURCES[key]
        sid=f'{factor}_type_{key}_source'
        source=dict(id=sid,document=section+' 类型解析',version='V2.0-10.0.0',
            catalog_chapter_ref=dict(document_id=DOCUMENT,source_relpath=rel,chapter_sha256=sha),
            source_anchor='L5-L15' if key=='storage' else 'L3-L34',retrieval_date='2026-09-11')
        path=f'specs/dml/{factor}/{factor}.source.yaml'
        prepend(path,'supplemental_sources',[source])
        text=read(path);ledger=yaml.safe_load(text)
        unit=next(u for u in ledger['units'] if u['id']==consumer_id)
        if sid in unit.get('supplemental_source_refs',[]): return
        old=re.search(r'(?m)^(?P<indent> *)- (?:\{)?id: '+re.escape(consumer_id)+r'(?:,|\n).*?(?=^ *- (?:\{)?id: |\Z)',text,re.S)
        assert old,consumer_id
        unit['fact_refs']+=facts
        unit.setdefault('supplemental_source_refs',[]).append(sid)
        unit['atomicity']='grouped';unit['independent_claim_count']=len(unit['fact_refs'])
        unit.pop('atomicity_rationale',None)
        unit['rationale']='本章行段仅为消费者位置；新增类型规则来自独立补充正文，不计作该补充章全文精审。'
        block='\n'.join(old['indent']+line for line in dump([unit]).rstrip().splitlines())+'\n'
        changes[path]=text[:old.start()]+block+text[old.end():]

    for factor,key in [('select','common'),('insert','storage')]:
        facts=[]
        for name,source,start,end,statement,status in RULES:
            if source==key and status in ('finite_consumer','finite_guard'):
                facts.append(dict(id=f'{factor}_fact_{name}',type='constraint',statement=statement,
                                  status='confirmed',source_anchor=f'{SOURCES[key][3]} L{start}-L{end}'))
        path=f'specs/dml/{factor}/{factor}.factor.yaml'
        prepend(path,'facts',facts)
        prepend(path,'manifest_refs',[f'manifest_{factor}_common_type_pg'])
        prepend(path,'fixture_refs',[f'fixture_{factor}_common_type'])
        prepend(path,'source_only_fact_refs',['create_database::create_database_fact_compatibility_environment'])
        supplement(factor,key,[f['id'] for f in facts],'select_src_028' if factor=='select' else 'insert_v10_115')
    prepend('specs/dml/select/select.factor.yaml','exported_fact_refs',SF)

    setup='CREATE TABLE g_common_source (id INTEGER, qty INTEGER, note TEXT, flag BOOLEAN);'
    seed="INSERT INTO g_common_source VALUES (1,10,'a',TRUE),(2,20,'b',FALSE),(3,NULL,NULL,NULL);"
    fx=entity('fixture','fixture_select_common_type','select',
        provides=dict(tables=[dict(name='g_common_source',persistence='permanent',table_kind='regular',columns=[dict(name=n,type=t,nullable=True)
        for n,t in [('id','INTEGER'),('qty','INTEGER'),('note','TEXT'),('flag','BOOLEAN')]])]),
        seed=dict(required=True,rows=[dict(id=1,qty=10,note='a',flag=True),dict(id=2,qty=20,note='b',flag=False),dict(id=3,qty=None,note=None,flag=None)]),
        execution=dict(status='ready',mode='explicit',setup_sqls=[setup,seed],teardown_sqls=['DROP TABLE g_common_source;'],
            note='独占新schema、名称须不存在；仅清理本轮确认创建对象。当前不执行数据库。'))
    new('specs/dml/select/fixtures/common_type.fixture.yaml',fx)
    new('specs/dml/insert/fixtures/common_type.fixture.yaml',entity('fixture','fixture_insert_common_type','insert',
        requires_fixture_refs=['fixture_select_common_type'],
        provides=dict(tables=[dict(name='g_common_target',persistence='permanent',table_kind='regular',columns=[dict(name='result',type='INTEGER',nullable=True)])]),
        seed=dict(required=False,rows=[]),execution=dict(status='ready',mode='explicit',
            setup_sqls=['CREATE TABLE g_common_target (result INTEGER);'],teardown_sqls=['DROP TABLE g_common_target;'],
            note='独占新目标表；先展开来源fixture，逆序清理且只处理本轮成功创建对象。')))
    profiles=[]
    for suffix,query,types,rows in QUERIES:
        profiles.append(dict(id='select_common_'+suffix,render=query,validity='valid',fixture_refs=['fixture_select_common_type'],
            properties=dict(common_type_contract=CONTRACT,output_types=types,output_column_count=len(types),
                source_tables=['g_common_source'] if 'FROM' in query else [],features=['finite_common_type']),fact_refs=SF))
    prepend('specs/dml/select/matrices/query_profiles.matrix.yaml','profiles',profiles)
    prepend('specs/dml/insert/matrices/target_profiles.matrix.yaml','profiles',[dict(id='insert_target_common_type',
        render='g_common_target (result)',validity='valid',fixture_refs=['fixture_insert_common_type'],fact_refs=[IF,'insert_fact_column_mapping'],
        properties=dict(target_kind='table',explicit_columns=True,target_column_count=1,target_types=['INTEGER'],available_column_count=1,available_types=['INTEGER']))])
    insert_profiles=[dict(id='insert_source_common_'+suffix,render=query,validity='valid',
        properties=dict(source_kind='query',output_column_count=1,output_types=types,common_type_contract=CONTRACT,
            source_tables=['g_common_source'],source_columns=['id','qty','flag'] if suffix=='case_integer' else ['id','qty']),
        fact_refs=[IF,'insert_fact_query_source']+['select::'+r for r in SF])
        for suffix,query,types,rows in QUERIES if suffix in ('case_integer','union_integer')]
    prepend('specs/dml/insert/matrices/source_profiles.matrix.yaml','profiles',insert_profiles)
    for f in ('select','insert'):
        bindings=({'query_profile':[p['id'] for p in profiles]} if f=='select' else
            dict(target_profile=['insert_target_common_type'],source_profile=[p['id'] for p in insert_profiles],
                 with_clause=['insert_with_none'],ignore_modifier=['insert_ignore_none'],
                 conflict_clause=['insert_conflict_none'],returning_clause=['insert_returning_none']))
        new(f'specs/dml/{f}/manifests/common_type_pg.manifest.yaml',entity('manifest',f'manifest_{f}_common_type_pg',f,
            description='仅PG有限同类型/unknown/CASE与UNION输入；非通用转换、长度或运行验证。',syntax_ref='syntax_'+f+'_v1',
            suite_type='positive',strategy='full_cartesian',fixture_refs=[],identifier_policy={},bindings=bindings,
            environment_requirements=[dict(key='compatibility_mode',allowed_values=['PG'],fact_refs=['create_database::create_database_fact_compatibility_environment'])],
            expected=dict(default='success',scope='syntax_only'),coverage_requirements=dict(strength=2,require_all_feasible_pairs=True)))
    for f,suffix,query,expected in [
        ('select','union_unknown',None,[[None]]),
        ('insert','case_integer','SELECT result FROM g_common_target ORDER BY result NULLS LAST',[[1],[20],[None]])]:
        sid=f'scenario_{f}_common_{suffix}'
        params=({'query_profile':'select_common_'+suffix} if f=='select' else
                dict(target_profile='insert_target_common_type',source_profile='insert_source_common_'+suffix,
                     with_clause='insert_with_none',ignore_modifier='insert_ignore_none',conflict_clause='insert_conflict_none',returning_clause='insert_returning_none'))
        oracle=dict(kind='result_set',step_id='target',expected=expected)
        if query: oracle['sql']=query+';'
        new(f'specs/dml/{f}/scenarios/common_{suffix}.scenario.yaml',entity('scenario',sid,f,
            fixture_refs=[f'fixture_{f}_common_type'],fact_refs=SF if f=='select' else [IF],
            steps=[dict(id='target',candidate=dict(manifest_ref=f'manifest_{f}_common_type_pg',params=params))],
            oracles=[oracle,dict(kind='manual_assertion',step_id='target',expected='校准真实输出类型/目标错误；当前没有数据库证据。')],
            execution_requirements=['database_authorization','physical_pg_connection','target_oracle_calibration','owned_asset_cleanup']))
        prepend(f'specs/dml/{f}/{f}.factor.yaml','scenario_refs',[sid])
    record=dict(stage='reviewed_finite_increment',parent_pdf_sha256=PDF_SHA,sources={k:dict(corpus=b,path=r,sha256=h,section=s) for k,(b,r,h,s) in SOURCES.items()},
        rules=[dict(id=n,source=k,line_start=a,line_end=b,statement=t,disposition=d) for n,k,a,b,t,d in RULES],
        limits=['10 rule groups, not complete chapters.','Same category mixed types, typmods, A/C/M and DECODE remain deferred.',
                'A rule-level rejection is not a calibrated negative SQLSTATE.'],database_executed=False)
    path='docs/data/common_type_batch_01.json';content=json.dumps(record,ensure_ascii=False,indent=2)+'\n'
    if (ROOT/path).exists(): assert (ROOT/path).read_text()==content,path
    else: changes[path]=content
    return {p:t for p,t in changes.items() if not (ROOT/p).exists() or (ROOT/p).read_text()!=t}


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--check',action='store_true');args=parser.parse_args()
    assert hashlib.sha256((ROOT/'gaussdb-rf-cent.pdf').read_bytes()).hexdigest()==PDF_SHA
    for base,rel,sha,section in SOURCES.values():
        c=json.loads((ROOT/base/'catalog.json').read_text())
        assert c['parent_pdf_sha256']==PDF_SHA and c['document_id']==DOCUMENT
        assert next(x for x in c['chapters'] if x['section_number']==section)['chapter_sha256']==sha
        assert hashlib.sha256((ROOT/base/rel).read_bytes()).hexdigest()==sha
    changes=planned_files()
    if args.check:
        assert not changes,sorted(changes)
        print('Source hashes and curated increment match; no database execution.');return
    print('*** Begin Patch')
    for path,new in changes.items():
        if not (ROOT/path).exists():
            print('*** Add File: '+str(ROOT/path));print('\n'.join('+'+line for line in new.splitlines()))
        else:
            print('*** Update File: '+str(ROOT/path))
            lines=list(difflib.unified_diff((ROOT/path).read_text().splitlines(),new.splitlines(),n=3))[2:]
            print('\n'.join('@@' if line.startswith('@@') else line for line in lines))
    print('*** End Patch')


if __name__=='__main__':main()
