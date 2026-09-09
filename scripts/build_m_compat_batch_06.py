#!/usr/bin/env python3
"""Curated final M batch from the local PDF; emit patches, never execute SQL."""
import argparse
import difflib
from pathlib import Path
import sys
import yaml

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from scripts.build_m_compat_pilot import Package,seq,slot,repeat
from scripts.build_m_compat_batch_04 import gate

CORPUS=ROOT/'work/m_compat_batch_06/corpus'
RANGE_SOURCE='m_b06_range_source'
SUB_SOURCE='m_b06_sub_source'
RANGE_FIXTURE='fixture_m_create_table_partition_range_source'
SUB_FIXTURE='fixture_m_create_table_subpartition_range_hash_source'
HINT_TABLES=['m_autohint_left','m_autohint_right']
HINT_QUERIES={
    'all':'SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id',
    'filtered':'SELECT MIN(l.qty) AS minimum_qty FROM m_autohint_left AS l, m_autohint_right AS r WHERE l.id = r.id AND r.qty > 10',
}


def hint_fixture(p,history=False):
    setup=[f'CREATE TABLE {t} (id INTEGER, qty INTEGER);' for t in HINT_TABLES]
    setup += [f'INSERT INTO {t} VALUES (1,10),(2,20),(3,30);' for t in HINT_TABLES]
    if history:
        setup += ['AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) '+q+';' for q in HINT_QUERIES.values()]
    # Never use global PURGE as fixture cleanup. Exact per-query deletion is separate from table cleanup.
    teardown=['AUTOHINT DROP '+q+';' for q in HINT_QUERIES.values()]
    teardown += [f'DROP TABLE {t};' for t in reversed(HINT_TABLES)]
    fx=p.fixture('history' if history else 'query_sources',[(t,['id','qty']) for t in HINT_TABLES],setup,teardown)
    p.files['fixtures/'+('history' if history else 'query_sources')+'.fixture.yaml']['execution']['note'] += (
        ' AUTOHINT历史模型创建数量不是静态已验证事实；未来检查前置实际输出。'
        '模型删除0条的提示不自动视作SQL错误或删除成功；仅本case查询签名，禁止PURGE兜底。')
    return fx


def hint_query_dim(p):
    p.matrix_dim('query',[(key,q,dict(source_tables=HINT_TABLES,source_columns=['id','qty'],
        source_columns_by_table={HINT_TABLES[0]:['id','qty'],HINT_TABLES[1]:['id','qty'] if key=='filtered' else ['id']},
        output_columns=['minimum_qty'],output_types=['INTEGER'])) for key,q in HINT_QUERIES.items()])


def autohint():
    p=Package('AUTOHINT','UTILITY',CORPUS)
    p.fact('syntax','syntax','AUTOHINT可含括号选项，目标必须为SELECT；本批为真实整数表连接聚合查询。','AUTOHINT [ ( option',9)
    p.fact('authority','environment','仅支持SELECT且使用者须有管理员权限。','仅支持SELECT语句，并且需要使用者拥有管理员权限',1)
    p.fact('parentheses','constraint','除ANALYZE之外的选项必须位于括号内。','除ANALYZE选项外',2)
    p.fact('analyze','lifecycle','ANALYZE TRUE默认先探索；FALSE直接依赖历史探索记录。','在进行智能Hint推荐前',6)
    p.fact('verbose','behavior_oracle','VERBOSE控制额外信息输出，默认TRUE。','显示Hint探索与智能Hint推荐过程',4)
    p.fact('patch','behavior_oracle','SQLPATCH默认TRUE表示输出SQL PATCH指令，不据此推断已经执行指令或安装补丁。','推荐Hint后输出相应的SQL PATCH指令',5)
    p.fact('test','behavior_oracle','TEST默认TRUE实际执行原始与推荐查询并输出计划时间，FALSE不进行结果验证。','分别执行初始查询以及应用智能Hint后的查询',6)
    p.fact('debug','behavior_oracle','DEBUG默认TRUE输出计划树、时间和探索图等详细信息。','输出相对于VERBOSE选项更多的细节信息',7)
    p.fact('existing_hint','behavior_oracle','已有Hint将被忽略，从无Hint查询重新推荐。','若SQL语句中已含有Hint',5)
    p.exports=[p.fid(x) for x in ('syntax','authority','analyze')]
    hint_query_dim(p)
    p.dim('analyze',[('explore','TRUE'),('history','FALSE')])
    p.dim('verbose',[('off','FALSE'),('on','TRUE')])
    p.dim('debug',[('off','FALSE'),('on','TRUE')])
    p.ast=seq('AUTOHINT (ANALYZE ',slot('analyze'),', VERBOSE ',slot('verbose'),
        ', SQLPATCH FALSE, TEST FALSE, DEBUG ',slot('debug'),') ',slot('query'))
    # All candidates have exact-query history provisioned, so ANALYZE FALSE has a real producer.
    fx=hint_fixture(p,history=True)
    p.manifest('finite',dict(query=['all','filtered'],analyze=['explore','history'],verbose=['off','on'],debug=['off','on']),[fx])
    gate(p,'actor_authority',['sysadmin'],[p.fid('authority')])
    gate(p,'hint_history_scope',['exclusive_disposable_database_and_query_signatures'],[p.fid('authority')])
    p.scenario('recommendation',['parentheses','analyze','verbose','patch','test','debug','existing_hint'],[fx],
        [dict(action='先校验前置探索是否产生目标查询模型，再比较推荐输出。当前显式TEST/SQLPATCH FALSE，不安装输出的SQL PATCH；探索本身可能执行查询。')],
        [dict(kind='manual_assertion',expected='历史模型数量、具体Hint、时间、性能提升、默认选项和已有Hint忽略行为均尚未验证')])
    return p


def autohint_drop():
    p=Package('AUTOHINT DROP','UTILITY',CORPUS)
    p.fact('syntax','syntax','AUTOHINT DROP后跟完整SELECT，删除该SQL历史推荐。','AUTOHINT DROP statement',1)
    p.fact('authority','environment','仅SELECT并要求管理员。','仅支持SELECT语句，并且需要使用者拥有管理员权限',1)
    p.fact('removed','behavior_oracle','示例显示1 MODEL REMOVED；无历史显示0 MODELS REMOVE，不等同已校准SQLSTATE。','--删除成功',4)
    hint_query_dim(p);p.ast=seq('AUTOHINT DROP ',slot('query'))
    fx=hint_fixture(p,history=True)
    p.manifest('existing_history',dict(query=['all','filtered']),[fx])
    gate(p,'actor_authority',['sysadmin'],[p.fid('authority')])
    gate(p,'hint_history_scope',['exclusive_disposable_database_and_query_signatures'],[p.fid('authority')])
    p.scenario('history_result',['removed'],[fx],[dict(action='前置AUTOHINT探索须证明目标模型已产生；删除后检查精确模型和二次删除0条的消息/成功状态，不设任意错误为通过。')],
        [dict(kind='manual_assertion',expected='模型存在性、删除数量、缺失历史的协议状态需实机校准')])
    p.files['scenarios/history_result.scenario.yaml']['fact_refs'].append('m_autohint::m_autohint_fact_analyze')
    return p


def autohint_purge():
    p=Package('AUTOHINT PURGE','UTILITY',CORPUS)
    p.fact('syntax','syntax','AUTOHINT PURGE无SQL过滤参数，清除全部历史推荐。','AUTOHINT PURGE;',1)
    p.fact('authority','environment','清除全部历史推荐要求管理员。','需要使用者拥有管理员权限',1)
    p.fact('scope','lifecycle','作用于所有历史推荐结果，不能当作按Schema隔离的清理。','删除智能Hint推荐的所有历史推荐结果',1)
    p.fact('result','behavior_oracle','示例输出删除12条或无模型时0条；这不是固定预期计数。','--删除成功',4)
    p.ast=seq('AUTOHINT PURGE');fx=hint_fixture(p,history=True)
    p.manifest('dedicated_history',{},[fx])
    gate(p,'actor_authority',['sysadmin'],[p.fid('authority')])
    gate(p,'instance_effect_scope',['dedicated_disposable_instance_no_foreign_hint_models'],[p.fid('authority')])
    p.scenario('global_history',['scope','result'],[fx],[dict(action='未来先检查整个隔离实例不存在其他用户历史模型，再建立本case模型、核对前置实际数量，授权后才能执行PURGE；Schema不足以隔离全局历史。')],
        [dict(kind='manual_assertion',expected='全局历史数量、清空结果与0条协议状态未验证；实例条件不满足时禁止运行')])
    p.files['scenarios/global_history.scenario.yaml']['fact_refs'].append('m_autohint::m_autohint_fact_analyze')
    return p


def purge():
    p=Package('PURGE','UTILITY',CORPUS)
    p.fact('syntax','syntax','PURGE TABLE可指定Schema限定的回收站表；INDEX和RECYCLEBIN为其他分支。','PURGE { TABLE',4)
    p.fact('authority','environment','PURGE TABLE需要对象所有者和Schema USAGE权限。','PURGE TABLE：用户必须是表的所有者',2)
    p.fact('recyclebin','environment','必须启用回收站，并在对象保留时间内执行。','开启enable_recyclebin参数',3)
    p.fact('global','environment','管理员关闭三权分立时可清理回收站所有对象，不能用RECYCLEBIN代替指定表清理。','PURGE RECYCLEBIN：普通用户',3)
    p.fact('index_example','open_question','示例PURGE INDEX后结果仍列出index_t1，不能据示例生成固定删除数量Oracle。','-- PURGE清除索引',10,'needs_verification')
    p.fact('released','behavior_oracle','从回收站清除表或索引并释放空间；静态语句不能验证空间释放。','从回收站中清理表或索引',1)
    ns='m_purge_namespace';target=ns+'.source'
    p.ast=seq('PURGE TABLE '+target)
    fx=p.fixture('dropped_table',[],[f'CREATE SCHEMA {ns};',f'CREATE TABLE {target} (id INTEGER, qty INTEGER);',
        f'INSERT INTO {target} VALUES (1,10),(2,20);',f'DROP TABLE {target};'],[f'DROP SCHEMA {ns};'])
    p.files['fixtures/dropped_table.fixture.yaml']['execution']['note'] += ' setup后表已入回收站，不声明为仍可查询的provides.tables。目标失败后需核验本case回收站残留，不允许扩大清理范围。'
    p.manifest('owned_table',{},[fx])
    gate(p,'actor_authority',['fixture_table_and_schema_creator'],[p.fid('authority')])
    gate(p,'enable_recyclebin',['on'],[p.fid('recyclebin')])
    gate(p,'recyclebin_state',['new_case_namespace_no_name_collision_retention_not_expired'],[p.fid('recyclebin')])
    p.scenario('effects',['released','global','index_example'],[fx],[dict(action='前置DROP后查询gs_recyclebin确认精确Schema/原始名/对象身份，再检查目标PURGE仅删除该对象及空间效果；INDEX和全局RECYCLEBIN不进入当前manifest。')],
        [dict(kind='manual_assertion',expected='回收站条目、空间释放、失败残留与索引示例冲突未实机验证')])
    return p


def timecapsule_table():
    p=Package('TIMECAPSULE TABLE','UTILITY',CORPUS)
    p.fact('syntax','syntax','TIMECAPSULE TABLE支持BEFORE DROP可选RENAME、BEFORE TRUNCATE和版本点分支。',next(i+1 for i,l in enumerate(p.lines) if l.strip()=='TIMECAPSULE TABLE'),3)
    p.fact('storage','environment','TO CSN/TIMESTAMP仅Ustore；回收站DROP/TRUNCATE支持Ustore与Astore。','通过TO TIMESTAMP或TO CSN',6)
    p.fact('authority','environment','DROP闪回要求Schema CREATE/USAGE及Schema或对象所有者；TRUNCATE另需TRUNCATE权限。','执行闪回DROP操作',5)
    p.fact('switches','environment','回收站必须开启，非维护/不支持升级场景，保留期内目标仍存在。','回收站关闭场景enable_recyclebin',12)
    p.fact('unsupported','constraint','临时/UNLOGGED/系统等表不支持；本批仅普通永久整数表。','目前不支持闪回表的对象类型',2)
    p.fact('single','constraint','一次删除或截断多个对象不支持闪回回收站。','多对象删除场景',2)
    p.fact('ddl_gap','constraint','TRUNCATE与恢复间影响结构或物理文件的DDL/DCL/VACUUM FULL导致失败。','TRUNCATE表和闪回TRUNCATE操作之间',3)
    p.fact('rename','constraint','RENAME TO只支持DROP恢复，不支持TRUNCATE。','RENAME TO仅支持DROP闪回操作',2)
    p.fact('names','lifecycle','同原始名选择最新回收对象，系统生成名唯一；本批专用Schema避免重名历史。','如果指定了用户指定的名称',4)
    p.fact('dependents','behavior_oracle','DROP恢复只还原基表名，不恢复序列/函数DEFAULT或已级联删除的视图。','恢复DROP表时',7)
    p.fact('statistics','metadata_oracle','TRUNCATE恢复后统计仍为0，不代表数据没有恢复。','TRUNCATE闪回后，统计信息无变化',2)
    p.fact('version_point','environment','历史版本依赖保留的UNDO，必须运行时取得真实CSN/时间点，不能照抄示例。','需要设置undo_retention_time参数',2)
    p.fact('cleanup','syntax','恢复后DROP TABLE ... PURGE物理删除本case表与相关回收站数据，避免再次入回收站。','-- 删除表（添加PURGE参数',2)
    ns='m_timecapsule_namespace';target=ns+'.source';renamed='restored'
    p.dim('operation',[('drop','DROP'),('truncate','TRUNCATE')])
    p.dim('rename',[('none',''),('yes','RENAME TO '+renamed)],'rename')
    p.rule('rename_only_drop',f"operation == '{p.vid('operation','drop')}' or rename == '{p.vid('rename','none')}'",'rename')
    p.ast=seq('TIMECAPSULE TABLE '+target+' TO BEFORE ',slot('operation'),' ',slot('rename'))
    for operation in ['drop','truncate']:
        fx=p.fixture(operation,[(target,['id','qty'])] if operation=='truncate' else [],
            [f'CREATE SCHEMA {ns};',f'CREATE TABLE {target} (id INTEGER, qty INTEGER);',
             f'INSERT INTO {target} VALUES (1,10),(2,20);',f'{operation.upper()} TABLE {target};'],
            [f'DROP TABLE IF EXISTS {target} PURGE;',f'DROP TABLE IF EXISTS {ns}.{renamed} PURGE;',f'DROP SCHEMA {ns};'])
        p.dims['operation']['classes'][0 if operation=='drop' else 1]['values'][0]['fixture_refs']=[fx]
        p.files['fixtures/'+operation+'.fixture.yaml']['execution']['note'] += ' 仅普通永久整数表；两个候选名称在setup前均须不存在，DROP后不声明活表。失败时另报精确回收站残留，不用PURGE RECYCLEBIN兜底。'
    p.manifest('drop',dict(operation=['drop'],rename=['none','yes']),[])
    p.manifest('truncate',dict(operation=['truncate'],rename=['none']),[])
    p.manifest('truncate_rename_negative',dict(operation=['truncate'],rename=['yes']),[],negative='rename_only_drop')
    gate(p,'actor_authority',['fixture_table_and_schema_creator_with_truncate'],[p.fid('authority')])
    gate(p,'table_storage',['verified_ordinary_permanent_astore_or_ustore'],[p.fid('storage')])
    gate(p,'enable_recyclebin',['on'],[p.fid('switches')]);gate(p,'xc_maintenance_mode',['off'],[p.fid('switches')])
    gate(p,'recyclebin_state',['new_case_namespace_retained_object_supported_baseline_no_intervening_ddl'],[p.fid('switches')])
    p.scenario('restored_rows',['unsupported','single','ddl_gap','names','dependents','statistics','cleanup'],[],
        [dict(action='独占Schema中先造两行，再单表DROP/TRUNCATE，核对回收站对象；恢复后验证(id,qty)=(1,10),(2,20)、改名和统计。负向只接受RENAME/TRUNCATE目标错误，SQLSTATE待校准。')],
        [dict(kind='manual_assertion',expected='数据恢复、名称、依赖/DEFAULT缺失、统计、精确清理及SQLSTATE尚未执行')])
    p.scenario('runtime_restore_point',['version_point'],[],[dict(action='未来运行器必须运行时捕获并传递CSN/时间点和UNDO保留条件；本批不填历史示例25391或2024时间戳。')],
        [dict(kind='manual_assertion',expected='CSN/TIMESTAMP、旧版本回收和约3秒时间偏差另行建模')])
    return p


def create_table_partition():
    p=Package('CREATE TABLE PARTITION','DDL',CORPUS)
    p.fact('syntax','syntax','M行存分区表支持RANGE、LIST、HASH/KEY主产生式；表定义先于分区子句。','CREATE TABLE [ IF NOT EXISTS ]',18)
    p.fact('hash_key','constraint','HASH仅支持一个分区键；KEY语义同HASH但不支持表达式。','目前哈希分区仅支持单列',1)
    p.fact('bounds','constraint','LESS THAN上边界必须同键类型、升序且不可用表达式；裸MAXVALUE仅单列。','每个分区都需要指定一个上边界',6)
    p.fact('start_end','constraint','START小于END，相邻END/START相等；不得与LESS THAN混用。','2. START END语法需要遵循以下限制',13)
    p.fact('implicit','metadata_oracle','首个START会额外创建MINVALUE到START的分区，名称为前缀加_0。','若该定义是第一个分区定义',6)
    p.fact('list','constraint','LIST普通列最多16列，表达式或二级分区时限单列；单分区最多64个键值。','对于partition_key，当使用表达式时',6)
    p.fact('partitions','constraint','显式PARTITIONS数需匹配定义数；HASH/KEY可自动命名，无定义无数量则单分区。','integer为分区数',9)
    p.fact('count_wording','open_question','PARTITIONS说明先称只能RANGE/LIST随后又明示HASH/KEY，示例证实HASH PARTITIONS 3。按分支与示例建模，保留文案矛盾。','只能在RANGE和LIST分区后指定此子句',1,'needs_verification')
    p.fact('row','environment','M仅行存；Ustore还要求track_counts/track_activities；本批显式ASTORE避免隐含存储假设。','决定了表的数据的存储方式',4)
    p.fact('storage','syntax','STORAGE_TYPE允许USTORE/ASTORE且设置后不支持修改。','指定存储引擎类型',10)
    p.fact('fillfactor','constraint','FILLFACTOR范围10至100，本批取两个端点。','取值范围：10~100',1)
    p.fact('columns_alias','syntax','RANGE COLUMNS与RANGE、LIST COLUMNS与LIST语义相同。','“PARTITION BY RANGE COLUMNS”',1)
    p.fact('routing','behavior_oracle','RANGE记录不能映射到已创建分区时返回错误。','范围分区策略：最常用的分区策略',3)
    p.fact('key_types','constraint','BLOB/TEXT/BIT等不能作为一级/二级分区键，本批仅INTEGER。','不支持如下数据类型作为分区键',3)
    p.exports=[p.fid(x) for x in ('syntax','bounds','partitions','storage','hash_key')]
    p.dim('form',[(s,'') for s in ('range_less','range_start','list','hash_named','hash_auto')])
    p.dim('if_exists',[('none',''),('yes','IF NOT EXISTS')])
    p.dim('columns',[('none',''),('yes','COLUMNS')],'columns_alias')
    p.dim('count',[('none',''),('three','PARTITIONS 3')],'partitions')
    p.dim('method',[('hash','HASH'),('key','KEY')],'syntax')
    p.dim('in',[('none',''),('yes','IN')],'list')
    p.dim('fillfactor',[('low','10'),('high','100')],'fillfactor')
    p.dim('bounds',[
        ('ascending','',dict(items=['PARTITION p1 VALUES LESS THAN (10)','PARTITION p2 VALUES LESS THAN (20)','PARTITION pmax VALUES LESS THAN (MAXVALUE)'],upper_bounds=[10,20,'MAXVALUE'],key_types=['INTEGER'])),
        ('descending','',dict(items=['PARTITION p1 VALUES LESS THAN (20)','PARTITION p2 VALUES LESS THAN (10)','PARTITION pmax VALUES LESS THAN (MAXVALUE)'],upper_bounds=[20,10,'MAXVALUE'],key_types=['INTEGER']))], 'bounds')
    p.dims['bounds']['classes'][1]['values'][0]['validity']='invalid'
    p.rule('ascending_bounds',f"form != '{p.vid('form','range_less')}' or bounds != '{p.vid('bounds','descending')}'",'bounds')
    ns='m_create_partition_namespace';table=ns+'.created'
    start='(PARTITION p1 START(0) END(10), PARTITION p2 START(10) END(20), PARTITION pmax START(20) END(MAXVALUE))'
    branches={
        'range_less':seq('RANGE ',slot('columns'),' (id) ',slot('count'),' (',repeat('bounds'),')'),
        'range_start':seq('RANGE ',slot('columns'),' (id) '+start),
        'list':seq('LIST ',slot('columns'),' (id) ',slot('count'),' (PARTITION p1 VALUES ',slot('in'),' (1, 2), PARTITION p2 VALUES ',slot('in'),' (3, 4), PARTITION pdefault VALUES ',slot('in'),' (DEFAULT))'),
        'hash_named':seq(slot('method'),' (id) ',slot('count'),' (PARTITION p1, PARTITION p2, PARTITION p3)'),
        'hash_auto':seq(slot('method'),' (id) ',slot('count')),
    }
    p.ast=seq('CREATE TABLE ',slot('if_exists'),' '+table+' (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = ',slot('fillfactor'),') PARTITION BY ',
        dict(kind='choice',selector='form',branches={p.vid('form',k):v for k,v in branches.items()}))
    fx=p.fixture('target_namespace',[],[f'CREATE SCHEMA {ns};'],[f'DROP TABLE IF EXISTS {table} PURGE;',f'DROP SCHEMA {ns};'])
    base=dict(if_exists=['none','yes'],fillfactor=['low','high'])
    p.manifest('range_less',dict(base,form=['range_less'],columns=['none','yes'],count=['none','three'],bounds=['ascending']),[fx])
    p.manifest('range_start',dict(base,form=['range_start'],columns=['none','yes']),[fx])
    p.manifest('list',dict(base,form=['list'],columns=['none','yes'],count=['none','three'],**{'in':['none','yes']}),[fx])
    p.manifest('hash_named',dict(base,form=['hash_named'],method=['hash','key'],count=['none','three']),[fx])
    p.manifest('hash_auto',dict(base,form=['hash_auto'],method=['hash','key'],count=['three']),[fx])
    p.files['manifests/hash_auto.manifest.yaml']['local_rules']=[dict(
        expression=f"form != '{p.vid('form','hash_auto')}' or count == '{p.vid('count','three')}'",
        rationale='原auto_count是本manifest选择三分区的取值策略，不是产品禁止省略数量；原文明确省略时为一个分区，另有hash_implicit正向用例。',
        fact_refs=[p.fid('partitions')])]
    p.manifest('hash_implicit',dict(base,form=['hash_auto'],method=['hash','key'],count=['none']),[fx])
    p.manifest('descending_negative',dict(form=['range_less'],bounds=['descending']),[fx],negative='ascending_bounds')
    gate(p,'storage_environment',['M_row_store_astore_available'],[p.fid('row')])
    p.scenario('routing_and_metadata',['implicit','routing','key_types','start_end','list','hash_key','count_wording'],[fx],
        [dict(action='CREATE后再seed边界行并检查pg_partition与分区路由；START(0)额外产生第4分区，不能按声明项3个断言实际3个。列表DEFAULT、HASH自动名和失败上边界须独立核验。')],
        [dict(kind='manual_assertion',expected='有限INTEGER模型；分区数/路由/负向SQLSTATE未执行。多列、表达式、生成列、外键/索引、表空间、全类型尚未建模')])
    p.scenario('hash_implicit_count',['partitions'],[fx],[dict(action='HASH/KEY既不指定数量也不列出定义时，应自动创建一个分区；不能当作auto_count的产品错误。')],
        [dict(kind='manual_assertion',expected='目标表对应的实际分区数为1；当前仅生成合法候选，目录断言尚未执行。')])
    source=p.fixture('range_source',[(RANGE_SOURCE,['id','qty'])],[f'CREATE TABLE {RANGE_SOURCE} (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) (PARTITION p_low VALUES LESS THAN (10), PARTITION p_mid VALUES LESS THAN (20), PARTITION p_high VALUES LESS THAN (30));',
        f'INSERT INTO {RANGE_SOURCE} VALUES (1,10),(11,20),(21,30);'],[f'DROP TABLE {RANGE_SOURCE} PURGE;'])
    p.files['fixtures/range_source.fixture.yaml']['provides']['tables'][0]['table_kind']='range_partitioned'
    p.files['scenarios/routing_and_metadata.scenario.yaml']['fixture_refs'].append(source)
    return p


def create_table_subpartition():
    p=Package('CREATE TABLE SUBPARTITION','DDL',CORPUS)
    p.fact('syntax','syntax','二级建表：RANGE/LIST一级和HASH/KEY二级，两个层级各单列键。','CREATE TABLE [ IF NOT EXISTS ]',19)
    p.fact('combinations','constraint','M只支持Range-Hash、Range-Key、List-Hash、List-Key四种组合。','二级分区表组合方案在M-Compatibility',2)
    p.fact('single_key','constraint','一级分区键和二级分区键各自仅一列。','二级分区表有两个分区键',1)
    p.fact('root_count','constraint','一级显式PARTITIONS值必须等于分区定义数。','当在RANGE和LIST分区后指定此子句时',2)
    p.fact('sub_count','constraint','显式二级数量必须与SUBPARTITIONS相等，自动生成在每个父分区分别进行。','若不列出各个二级分区定义',10)
    p.fact('implicit','metadata_oracle','未列出二级定义且未指定数量时，每个父分区自动一个子分区。','若既不列出每个二级分区定义',2)
    p.fact('row','environment','仅行存，不支持密态/账本库等；本批普通隔离M库。','二级分区表只支持行存',8)
    p.fact('storage','syntax','STORAGE_TYPE可显式ASTORE，本批不依赖默认USTORE及其开关。','指定存储引擎类型',10)
    p.fact('lookup','behavior_oracle','指定分区查询的PARTITION/SUBPARTITION写错可能变别名，不可只依无错误推导正确选区。','关键字partition和subpartition注意不要写错',2)
    p.fact('key_types','constraint','两层键类型约束与一级分区相同，COLUMNS只用于RANGE/LIST，表达式不能同时用COLUMNS。','对于partition_key，分区策略的分区键仅支持1列',10)
    p.exports=[p.fid(x) for x in ('syntax','combinations','single_key','sub_count','storage')]
    p.dim('root',[('range','RANGE'),('list','LIST')])
    p.dim('sub',[('hash','HASH'),('key','KEY')])
    p.dim('columns',[('none',''),('yes','COLUMNS')])
    p.dim('if_exists',[('none',''),('yes','IF NOT EXISTS')])
    p.dim('root_count',[('none',''),('two','PARTITIONS 2')],'root_count')
    p.dim('layout',[('explicit',''),('automatic',''),('implicit','')])
    p.dim('sub_count',[('none',''),('two','SUBPARTITIONS 2'),('wrong','SUBPARTITIONS 3')],'sub_count')
    p.dims['sub_count']['classes'][2]['values'][0]['validity']='invalid'
    p.rule('sub_count_matches',f"sub_count != '{p.vid('sub_count','wrong')}'",'sub_count')
    branches={}
    for root in ('range','list'):
        bounds=['VALUES LESS THAN (10)','VALUES LESS THAN (MAXVALUE)'] if root=='range' else ['VALUES IN (1,2)','VALUES IN (3,4)']
        variants={}
        for layout in ('explicit','automatic','implicit'):
            items=[]
            for number,bound in enumerate(bounds,1):
                item=f'PARTITION p{number} {bound}'
                if layout=='explicit':item+=f' (SUBPARTITION p{number}_a, SUBPARTITION p{number}_b)'
                items.append(item)
            variants[p.vid('layout',layout)]=seq('('+', '.join(items)+')')
        branches[p.vid('root',root)]=dict(kind='choice',selector='layout',branches=variants)
    ns='m_create_subpartition_namespace';target=ns+'.created'
    p.ast=seq('CREATE TABLE ',slot('if_exists'),' '+target+' (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY ',slot('root'),' ',slot('columns'),' (id) ',slot('root_count'),
        ' SUBPARTITION BY ',slot('sub'),' (qty) ',slot('sub_count'),' ',dict(kind='choice',selector='root',branches=branches))
    fx=p.fixture('target_namespace',[],[f'CREATE SCHEMA {ns};'],[f'DROP TABLE IF EXISTS {target} PURGE;',f'DROP SCHEMA {ns};'])
    base=dict(root=['range','list'],sub=['hash','key'],columns=['none','yes'],if_exists=['none','yes'],root_count=['none','two'])
    p.manifest('explicit',dict(base,layout=['explicit'],sub_count=['none','two']),[fx])
    p.manifest('automatic',dict(base,layout=['automatic'],sub_count=['two']),[fx])
    p.manifest('implicit',dict(base,layout=['implicit'],sub_count=['none']),[fx])
    for layout,count in [('automatic','two'),('implicit','none')]:
        p.files['manifests/'+layout+'.manifest.yaml']['local_rules']=[dict(
            expression=f"layout != '{p.vid('layout',layout)}' or sub_count == '{p.vid('sub_count',count)}'",
            rationale='原'+layout+'_count限定本manifest的profile标签：automatic表示自动两个，implicit表示省略数量一个；相反标签不是数据库错误，不能据此造负向用例。',
            fact_refs=[p.fid('sub_count')])]
    p.manifest('wrong_count_negative',dict(layout=['explicit'],sub_count=['wrong']),[fx],negative='sub_count_matches')
    gate(p,'database_features',['ordinary_m_no_encryption_no_ledger_row_store'],[p.fid('row')])
    shared=p.fixture('range_hash_source',[(SUB_SOURCE,['id','qty'])],[f'CREATE TABLE {SUB_SOURCE} (id INTEGER, qty INTEGER) WITH (storage_type = ASTORE) PARTITION BY RANGE (id) SUBPARTITION BY HASH (qty) (PARTITION p_low VALUES LESS THAN (10) (SUBPARTITION s_low), PARTITION p_high VALUES LESS THAN (MAXVALUE) (SUBPARTITION s_high));',
        f'INSERT INTO {SUB_SOURCE} VALUES (1,10),(2,20),(11,30);'],[f'DROP TABLE {SUB_SOURCE} PURGE;'])
    p.files['fixtures/range_hash_source.fixture.yaml']['provides']['tables'][0]['table_kind']='range_hash_subpartitioned'
    p.scenario('hierarchy',['combinations','single_key','implicit','storage','lookup','key_types'],[shared],
        [dict(action='目录分别统计一级与叶子节点；显式/自动每父2子，隐式每父1子。共享维护表每父单个HASH子，真实seed可确定s_low内有2行，不猜hash桶分配。')],
        [dict(kind='manual_assertion',expected='层级名称/数量、四种组合、查询选区及目标数量错误Oracle未实机验证')])
    return p


def partition_dependency(p,reference):
    fid='fixture_'+p.id+'_shared_partition'
    p.files['fixtures/shared_partition.fixture.yaml']=p.entity('fixture',fid,requires_fixture_refs=[reference],
        provides=dict(tables=[]),seed=dict(required=False,rows=[]),execution=dict(status='ready',mode='auto',
            note='复用创建分区包的真实表与seed；按依赖拓扑setup、逆序定向teardown，不复制前置或全局清理。'))
    p.fixtures.append(fid)
    return fid


def alter_table_partition():
    p=Package('ALTER TABLE PARTITION','DDL',CORPUS)
    p.fact('syntax','syntax','ALTER TABLE可选IF EXISTS，后跟分区维护动作；此有限批单动作。','ALTER TABLE [ IF EXISTS ]',2)
    p.fact('authority','environment','分区表所有者或ALTER授权者可以维护分区。','只有分区表的所有者',2)
    p.fact('add_bound','constraint','新增RANGE上界必须大于当前末分区上界，类型一致且名称不重复。','添加分区的名称不能',4)
    p.fact('hash','constraint','HASH不支持增删、切割、合并；本批只用真实RANGE表。','哈希分区表不支持切割',1)
    p.fact('last','constraint','只有一个分区时不能删除，本fixture起始3分区。','当分区表只有一个分区时',1)
    p.fact('global_index','lifecycle','分区维护可能令GLOBAL索引失效，enable_gpi_auto_update或s4改变自动更新行为；本批未创建索引。','删除、切割、合并、清空、交换分区',7)
    p.fact('add','syntax','ADD PARTITION包含括号内新分区定义。','ADD PARTITION({partition_less_than_item',5)
    p.fact('truncate','syntax','TRUNCATE PARTITION支持名称列表、ALL或FOR常量值。','TRUNCATE PARTITION { { ALL',2)
    p.fact('analyze','syntax','ANALYZE PARTITION可指定名称/列表/ALL，示例补充主语法未闭合括号。','m_db=# ALTER TABLE sales ANALYZE PARTITION p0;',4)
    p.fact('rename','syntax','RENAME PARTITION名称或FOR值到新名。','RENAME PARTITION { partition_name',1)
    p.fact('split','constraint','RANGE切割点必须在目标范围内部，指定AT时分为两个新分区。','切割点的大小要位于',2)
    p.fact('merge','constraint','RANGE合并源需连续递增；本批ASTORE，不套用Ustore事务限制。','对于范围分区，MERGE分区要求',6)
    p.fact('exchange','constraint','交换要求列、物理删除列、约束、索引、存储等严格一致；当前不提供交换清单。','普通表和分区的列数相同',14)
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    actions=[('add','ADD PARTITION (PARTITION p_new VALUES LESS THAN (40))'),
        ('drop','DROP PARTITION p_low'),('truncate','TRUNCATE PARTITION p_low'),
        ('truncate_for','TRUNCATE PARTITION FOR (11)'),('analyze','ANALYZE PARTITION p_mid'),
        ('rename','RENAME PARTITION p_mid TO p_renamed'),('rename_for','RENAME PARTITION FOR (11) TO p_renamed'),
        ('split','SPLIT PARTITION p_mid AT (15) INTO (PARTITION p_mid_a, PARTITION p_mid_b)'),
        ('merge','MERGE PARTITIONS p_low, p_mid INTO PARTITION p_merged'),
        ('bad_add','ADD PARTITION (PARTITION p_new VALUES LESS THAN (15))')]
    p.dim('action',actions)
    facts={'add':'add','drop':'syntax','truncate':'truncate','truncate_for':'truncate','analyze':'analyze',
           'rename':'rename','rename_for':'rename','split':'split','merge':'merge','bad_add':'add_bound'}
    for c,(name,_) in zip(p.dims['action']['classes'],actions):c['values'][0]['fact_refs']=[p.fid(facts[name])]
    p.dims['action']['classes'][-1]['values'][0]['validity']='invalid'
    p.rule('add_above_last',f"action != '{p.vid('action','bad_add')}'",'add_bound')
    p.ast=seq('ALTER TABLE ',slot('if_exists'),' '+RANGE_SOURCE+' ',slot('action'))
    fx=partition_dependency(p,RANGE_FIXTURE)
    p.manifest('maintenance',dict(if_exists=['none','yes'],action=[x[0] for x in actions[:-1]]),[fx])
    p.manifest('bad_add_negative',dict(action=['bad_add']),[fx],negative='add_above_last')
    gate(p,'actor_authority',['fixture_table_creator'],[p.fid('authority')])
    p.scenario('metadata_data',['hash','last','global_index','exchange'],[fx],
        [dict(action='检查3个真实起始分区与每分区一行；ADD上界40、SPLIT点15、连续合并和改名逐case验证。没有全局索引时不声明验证索引维护。交换另需完整契约。')],
        [dict(kind='manual_assertion',expected='分区数据、名称/数量、统计、目标错误及索引行为待验证')])
    p.files['scenarios/metadata_data.scenario.yaml']['fact_refs'].append('m_create_table_partition::m_create_table_partition_fact_bounds')
    return p


def alter_table_subpartition():
    p=Package('ALTER TABLE SUBPARTITION','DDL',CORPUS)
    p.fact('syntax','syntax','二级维护主语法后跟单个或多个动作，本批只生成单个TRUNCATE或RENAME。','ALTER TABLE { table_name',2)
    p.fact('authority','environment','只有表所有者或ALTER授权者、管理员可修改。','只有分区表的所有者',2)
    p.fact('hash_limits','constraint','HASH/KEY子分区禁止直接增删切合；有限模型不声称支持这些动作。','SUBPARTITION只支持HASH/KEY分区',4)
    p.fact('truncate','syntax','TRUNCATE SUBPARTITION指定子名或FOR两级键，父分区TRUNCATE可用名称/ALL。','TRUNCATE SUBPARTITION { subpartition_name',2)
    p.fact('rename','syntax','RENAME SUBPARTITION支持名称或FOR到新名，重命名语法允许IF EXISTS。','RENAME SUBPARTITION { subpartition_name',2)
    p.fact('for_keys','constraint','SUBPARTITION FOR需要同时提供一级和二级键值，数量顺序一一对应。','一级分区键值和二级分区键值',5)
    p.fact('index','lifecycle','清空/交换可能使GLOBAL索引失效；s4或enable_gpi_auto_update改变行为。','删除、切割、清空、交换分区',7)
    p.fact('exchange','constraint','交换要求普通表与子分区完整列/约束/索引/存储一致，包含物理已删除列。','普通表和分区的列数目相同',13)
    p.dim('form',[('truncate',''),('rename','')])
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('selector',[('name','s_low'),('for','FOR (1, 10)')],'for_keys')
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','truncate'):seq('ALTER TABLE '+SUB_SOURCE+' TRUNCATE SUBPARTITION ',slot('selector')),
        p.vid('form','rename'):seq('ALTER TABLE ',slot('if_exists'),' '+SUB_SOURCE+' RENAME SUBPARTITION ',slot('selector'),' TO s_renamed')})
    fx=partition_dependency(p,SUB_FIXTURE)
    p.manifest('truncate',dict(form=['truncate'],selector=['name','for']),[fx])
    p.manifest('rename',dict(form=['rename'],if_exists=['none','yes'],selector=['name','for']),[fx])
    gate(p,'actor_authority',['fixture_table_creator'],[p.fid('authority')])
    p.scenario('subtree',['truncate','rename','hash_limits','index','exchange'],[fx],
        [dict(action='共享表两个RANGE父节点，每父1个HASH子，s_low确定含(1,10)/(2,20)；FOR(1,10)同时定位两级。检查改名或精确清空，不验证未创建的GLOBAL索引。')],
        [dict(kind='manual_assertion',expected='数据/目录结果、两级选区和错误Oracle待独立实机验证')])
    p.files['scenarios/subtree.scenario.yaml']['fact_refs'].append('m_create_table_subpartition::m_create_table_subpartition_fact_single_key')
    return p


def alter_table():
    p=Package('ALTER TABLE','DDL',CORPUS)
    p.fact('syntax','syntax','ALTER TABLE表定义可跟动作列表，列子句包括ADD/MODIFY/CHANGE/DROP/ALTER DEFAULT。','ALTER TABLE { table_name',4)
    p.fact('authority','environment','普通修改需表所有者/ALTER权限；本批所有对象均由当前fixture创建者持有。','表的所有者、被授予了表ALTER权限',4)
    p.exports=[p.fid('authority')]
    p.fact('add','syntax','ADD COLUMN支持FIRST/AFTER位置，ADD括号可增加多列。','ADD [ COLUMN ] column_name data_type',3)
    p.fact('modify','syntax','MODIFY与CHANGE支持完整列定义和位置；CHANGE同时改名。','| MODIFY column_name',9)
    p.fact('change_syntax','syntax','M CHANGE可选COLUMN，显式提供原列名、新列名和新定义，可带字段约束及位置子句。',176,3)
    p.fact('change_name','constraint','CHANGE修改已存在字段的名称和定义，新名称不能是已有字段名。',179,1)
    p.fact('add_null','behavior_oracle','ADD列时原有行初始化为DEFAULT，未声明DEFAULT时为NULL。',147,2)
    p.fact('position','syntax','FIRST新增或修改列到第一位，AFTER在指定列之后。',596,5)
    p.fact('position_rules','constraint','有规则依赖的表不支持新增或修改导致的列位置变化。',603,1)
    p.fact('default','syntax','ALTER COLUMN可SET DEFAULT或DROP DEFAULT；本批INTEGER只用兼容常量。','| ALTER [ COLUMN ] column_name',1)
    p.fact('default_future','behavior_oracle','修改DEFAULT只影响随后INSERT，不回填现有行。','缺省值只应用于随后的INSERT命令',3)
    p.fact('null_check','constraint','新增CHECK/NOT NULL需验证所有已有行。','增加一个CHECK或NOT NULL约束将会扫描该表',1)
    p.fact('nextval','constraint','不支持ADD带nextval() DEFAULT的列；本批不生成此依赖分支。','不支持增加DEFAULT值中包含nextval()',1)
    p.fact('rename','syntax','RENAME表可选TO/AS/等号；重命名不改变数据。','ALTER TABLE table_name',2)
    # The first ALTER TABLE table_name below this heading is the rename production, not an example.
    p.fact('schema','syntax','SET SCHEMA使用独立产生式，可带IF EXISTS。','ALTER TABLE [ IF EXISTS ] table_name',2)
    p.fact('schema_authority','environment','迁移必须有目标Schema CREATE权限，只在用户Schema之间；本批新建两个专用Schema。','要修改一个表的模式，用户必须在新模式上拥有CREATE权限',5)
    p.fact('schema_sequence','constraint','拥有序列时须删除/重建/取消拥有关系才能迁移；本批无序列/自增列。','目前序列不支持改',3)
    p.fact('bundle','constraint','RENAME/SET SCHEMA不能混入多动作列表；本批两类独立manifest。','除了RENAME和SET SCHEMA之外',3)
    p.fact('check_null','open_question','本章CHECK说明仅真通过，CREATE TABLE说明真或未知；本批CHECK仅非NULL整数，不用此差异生成Oracle。','每次将要插入的新行或者将要被更新的行必须使表达式结果为真',3,'needs_verification')
    p.fact('rewrite','open_question','前文ADD DEFAULT满足条件可避免全表更新，后文称非空DEFAULT会重写；不自动判性能和物理重写。','用一个非空缺省值增加一个字段',2,'needs_verification')
    p.fact('only','behavior_oracle','ONLY和星号保留语法但不支持对应功能，本批不用它们表示继承隔离。','目前ONLY和增加*选项保留语法',2)
    p.fact('internal','environment','TO GROUP/NODE及增删节点属于内部扩缩容接口，不进入普通修改域。','此语法仅在扩展模式',8)
    p.fact('fillfactor','constraint','FILLFACTOR范围10至100，本批固定ASTORE并测试两个端点。','取值范围：10~100（百分比）',1)
    p.fact('drop','lifecycle','DROP列是逻辑不可见而非立即物理删除，CASCADE自s1仅语法支持。','DROP COLUMN命令并不是物理上',5)
    ns='m_alter_table_namespace';dest='m_alter_table_destination';t=ns+'.source'
    p.dim('form',[(x,'') for x in ('add','modify','change','default','drop','constraint','storage','comment','rename','schema')])
    p.dims['form']['classes'].append(dict(id=p.vid('form','change_fresh')+'_class',meaning='fresh ordinary same-definition CHANGE',values=[
        dict(id=p.vid('form','change_fresh'),render='m_at_change_fresh',representative=True,validity='valid',
             properties=dict(source_tables=['m_at_change_fresh'],source_columns=['qty'],
                 column_rename_contract=dict(kind='ordinary_same_definition',source_column='qty',target_column='amount')),
             fact_refs=[p.fid('change_syntax'),p.fid('change_name')])]))
    p.dims['form']['classes'].append(dict(id=p.vid('form','add_position_fresh')+'_class',meaning='fresh ordinary nullable INTEGER ADD position',values=[
        dict(id=p.vid('form','add_position_fresh'),render='m_at_add_position',representative=True,validity='valid',
             properties=dict(source_tables=['m_at_add_position'],source_columns=['id'],
                 column_add_contract=dict(kind='ordinary_nullable_integer',added_column='extra')),
             fact_refs=[p.fid('add'),p.fid('position'),p.fid('position_rules')])]))
    p.dim('column',[('none',''),('yes','COLUMN')])
    p.dim('position',[('none',''),('first','FIRST'),('after','AFTER id')],'add')
    p.dim('default_action',[('set','SET DEFAULT 7'),('null','SET DEFAULT NULL'),('drop','DROP DEFAULT')],'default')
    for cls in p.dims['default_action']['classes'][:2]:
        cls['values'][0]['fact_refs'].append('m_create_table::m_create_table_fact_default')
    p.dim('constraint_action',[('not_null','MODIFY qty NOT NULL'),('nullable','MODIFY qty NULL'),
        ('check','ADD CONSTRAINT m_at_positive CHECK (qty > 0)'),('bad_check','ADD CONSTRAINT m_at_negative CHECK (qty < 0)')])
    p.dims['constraint_action']['classes'][-1]['values'][0].update(validity='invalid',fact_refs=[p.fid('null_check')])
    p.rule('existing_rows_satisfy_check',f"form != '{p.vid('form','constraint')}' or constraint_action != '{p.vid('constraint_action','bad_check')}'",'null_check')
    p.dim('storage_action',[('low','SET (fillfactor = 10)'),('high','SET (fillfactor = 100)'),('reset','RESET (fillfactor)')],'fillfactor')
    p.dim('equals',[('none',''),('yes','=')])
    p.dim('rename_keyword',[('none',''),('to','TO'),('as','AS'),('equals','=')],'rename')
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')],'schema')
    branches={
        'add':seq('ADD ',slot('column'),' added INTEGER DEFAULT 7 ',slot('position')),
        'modify':seq('MODIFY ',slot('column'),' qty BIGINT DEFAULT 9 ',slot('position')),
        'change':seq('CHANGE ',slot('column'),' qty amount INTEGER DEFAULT 9 ',slot('position')),
        'default':seq('ALTER ',slot('column'),' qty ',slot('default_action')),
        'drop':seq('DROP ',slot('column'),' qty RESTRICT'),
        'constraint':seq(slot('constraint_action')),
        'storage':seq(slot('storage_action')),
        'comment':seq('COMMENT ',slot('equals')," 'M finite ALTER TABLE'")}
    p.ast=dict(kind='choice',selector='form',branches={
        **{p.vid('form',k):seq('ALTER TABLE '+t+' ',v) for k,v in branches.items()},
        p.vid('form','change_fresh'):seq('ALTER TABLE ',slot('form'),' CHANGE ',slot('column'),' qty amount INTEGER'),
        p.vid('form','add_position_fresh'):seq('ALTER TABLE ',slot('form'),' ADD ',slot('column'),' extra INTEGER ',slot('position')),
        p.vid('form','rename'):seq('ALTER TABLE '+t+' RENAME ',slot('rename_keyword'),' renamed'),
        p.vid('form','schema'):seq('ALTER TABLE ',slot('if_exists'),' '+t+' SET SCHEMA '+dest)})
    fx=p.fixture('integer_source',[(t,['id','qty'])],[f'CREATE SCHEMA {ns};',f'CREATE TABLE {t} (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE, fillfactor = 80);',
        f'INSERT INTO {t} VALUES (1,10),(2,20);'],[f'DROP TABLE IF EXISTS {t} PURGE;',f'DROP TABLE IF EXISTS {ns}.renamed PURGE;',f'DROP SCHEMA {ns};'])
    move=p.fixture('schema_target',[],[f'CREATE SCHEMA {dest};'],[f'DROP TABLE IF EXISTS {dest}.source PURGE;',f'DROP SCHEMA {dest};'],requires=[fx])
    for form in ('add','modify','change'):
        p.manifest(form,dict(form=[form],column=['none','yes'],position=['none','first','after']),[fx])
    p.manifest('default',dict(form=['default'],column=['none','yes'],default_action=['set','null','drop']),[fx])
    p.manifest('drop',dict(form=['drop'],column=['none','yes']),[fx])
    p.manifest('constraint',dict(form=['constraint'],constraint_action=['not_null','nullable','check']),[fx])
    p.manifest('negative_check',dict(form=['constraint'],constraint_action=['bad_check']),[fx],negative='existing_rows_satisfy_check')
    p.manifest('storage',dict(form=['storage'],storage_action=['low','high','reset']),[fx])
    p.manifest('comment',dict(form=['comment'],equals=['none','yes']),[fx])
    p.manifest('rename',dict(form=['rename'],rename_keyword=['none','to','as','equals']),[fx])
    p.manifest('schema',dict(form=['schema'],if_exists=['none','yes']),[move])
    fresh=p.fixture('change_fresh',[('m_at_change_fresh',['id','qty'])],
        ['CREATE TABLE m_at_change_fresh (id INTEGER, qty INTEGER);','INSERT INTO m_at_change_fresh VALUES (1,10),(2,20);'],
        ['DROP TABLE m_at_change_fresh;'])
    p.manifest('change_fresh',dict(form=['change_fresh'],column=['none','yes']),[fresh])
    p.files['manifests/change_fresh.manifest.yaml']['environment_requirements'].append(dict(
        key='source_creation_authority',allowed_values=['new_case_table_creator'],
        fact_refs=['m_create_table::m_create_table_fact_authority']))
    added=p.fixture('add_position_fresh',[('m_at_add_position',['id','qty','note'])],
        ['CREATE TABLE m_at_add_position (id INTEGER,qty INTEGER,note INTEGER);',
         'INSERT INTO m_at_add_position VALUES (1,10,100),(2,20,200);'],['DROP TABLE m_at_add_position;'])
    p.manifest('add_position_fresh',dict(form=['add_position_fresh'],column=['none','yes'],position=['first','after']),[added])
    p.files['manifests/add_position_fresh.manifest.yaml']['environment_requirements'].append(dict(
        key='source_creation_authority',allowed_values=['new_case_table_creator'],
        fact_refs=['m_create_table::m_create_table_fact_authority']))
    gate(p,'actor_authority',['fixture_table_creator'],[p.fid('authority')])
    p.files['manifests/schema.manifest.yaml']['environment_requirements'].append(dict(key='destination_schema_authority',allowed_values=['new_case_schema_creator'],fact_refs=[p.fid('schema_authority')]))
    p.scenario('columns_rows',['modify','default_future','nextval','schema_sequence','bundle','only','internal','drop','check_null','rewrite'],[fx],
        [dict(action='逐case验证新增DEFAULT=7回填、SET DEFAULT不回填、NULL兼容/已有正值CHECK、类型/名称/位置、表改名/迁移后对象定位。内部扩容、ONLY继承、nextval及物理重写不作为覆盖结果。')],
        [dict(kind='manual_assertion',expected='目录、已有行、后续INSERT、约束和准确错误Oracle均待独立执行；不以静态成功推断行为')])
    p.scenario('change_fresh',['change_syntax','change_name'],[fresh],
        [dict(id='change',manifest_ref='manifest_m_alter_table_change_fresh',action='在M隔离Schema中逐case执行一条候选，不叠加两个COLUMN拼写。'),
         dict(id='rows',sql='SELECT id, amount FROM m_at_change_fresh ORDER BY id;')],
        [dict(kind='result_set',step_id='rows',expected=[[1,10],[2,20]]),
         dict(kind='manual_assertion',expected='目录应确认qty改名amount，INTEGER、列序、可空及无DEFAULT保持；实际目录字段与结果需授权后校准。')])
    p.scenario('add_position_fresh',['add','add_null','position','position_rules'],[added],
        [dict(id='add',manifest_ref='manifest_m_alter_table_add_position_fresh',action='每case独立fixture，执行一条ADD；FIRST/AFTER不可叠加执行。'),
         dict(id='rows_first',sql='SELECT * FROM m_at_add_position ORDER BY id;',when_value_ref=p.vid('position','first')),
         dict(id='rows_after',sql='SELECT * FROM m_at_add_position ORDER BY id;',when_value_ref=p.vid('position','after'))],
        [dict(kind='result_set',step_id='rows_first',expected=[[None,1,10,100],[None,2,20,200]]),
         dict(kind='result_set',step_id='rows_after',expected=[[1,None,10,100],[2,None,20,200]]),
         dict(kind='manual_assertion',expected='目录新增extra为可空INTEGER无默认并处于目标位置；目录接口和实际原行NULL尚待授权校准。')])
    return p


def generated_update_system():
    p=Package('GENERATED UPDATE SYSTEM','UTILITY',CORPUS)
    p.fact('syntax','syntax','M固定语法为GENERATED UPDATE SYSTEM，无OBJECT后缀，无可选参数。',14)
    p.fact('purpose','lifecycle','生成系统对象的升级回滚脚本文件，在升级回滚时由OM调用。',5,2)
    p.fact('internal','environment','内部语法，不建议用户使用；不能作为普通应用SQL。',5,2)
    p.fact('upgrade','environment','仅支持升级中通过OM调用；upgrade_mode非零且application_name为OM。',9,2)
    p.fact('initial_user','environment','只有初始用户有权限；不将普通SYSADMIN身份视为等价。',11)
    p.fact('om_contract','open_question','本章未提供可复现的OM升级阶段准备、初始身份核验及前置恢复合同；待权威OM集成测试规范，不能手工修改upgrade_mode伪造。',9,2,'needs_verification')
    p.fact('artifact_contract','open_question','本章未提供回滚脚本文件路径、命名、归属、内容Oracle和部分失败清理合同；不能猜测输出路径或自动删除文件。',5,2,'needs_verification')
    p.ast=seq('GENERATED UPDATE SYSTEM')
    fx='fixture_'+p.id+'_om_upgrade'
    p.fixtures.append(fx)
    p.files['fixtures/om_upgrade.fixture.yaml']=p.entity('fixture',fx,
        provides=dict(tables=[]),seed=dict(required=False,rows=[]),
        execution=dict(status='not_implemented',mode='auto',setup_sqls=[],teardown_sqls=[],
            note='阻塞声明，不是就绪空fixture。需要OM提供真实升级前置、初始用户验证及生成文件生命周期；禁止普通建表/SELECT 1占位、手工SET upgrade_mode或未知范围清理。'))
    p.files['fixtures/om_upgrade.fixture.yaml']['status']='planned'
    mid='matrix_'+p.id+'_coverage';p.matrices.append(mid)
    p.files['matrices/coverage.matrix.yaml']=p.entity('matrix',mid,profiles=[],documented_features=[
        dict(id=p.id+'_feature_om_upgrade',status='needs_profile',fact_refs=[p.fid(x) for x in ('mode','internal','upgrade','initial_user','om_contract')]),
        dict(id=p.id+'_feature_rollback_artifacts',status='needs_profile',fact_refs=[p.fid(x) for x in ('purpose','artifact_contract')])])
    p.scenario('om_rollback_artifacts',['mode','purpose','internal','upgrade','initial_user','om_contract','artifact_contract'],[fx],
        [dict(action='review_only_candidate',sql='GENERATED UPDATE SYSTEM;',execution_status='blocked_external_contract',
              note='仅审阅；没有ordinary manifest，不交给Smoke执行器。')],
        [dict(kind='manual_assertion',expected='待OM规范确定目标文件路径、内容和生命周期后实现精确Oracle；当前无已验证成功或错误预期。')])
    scenario=p.files['scenarios/om_rollback_artifacts.scenario.yaml']
    scenario['preconditions']=[
        dict(key='compatibility_mode',allowed_values=['M'],fact_refs=[p.fid('mode')]),
        dict(key='m_environment_preparation',reference='generated/m_compat_environment/plan.json',
             note='仅M建库与重连基础计划；不构成OM升级前置，不应直接用于真实升级库。'),
        dict(key='command_applicability',allowed_values=['internal_om_upgrade_only'],fact_refs=[p.fid('internal')]),
        dict(key='upgrade_context',requirement='actual_OM_upgrade AND upgrade_mode != 0 AND application_name == OM',fact_refs=[p.fid('upgrade')]),
        dict(key='actor_identity',requirement='initial_user',fact_refs=[p.fid('initial_user')])]
    scenario['execution_requirements'] += ['authoritative_om_upgrade_fixture','initial_user_identity_proof','rollback_file_oracle_and_cleanup_contract']
    return p


BUILDERS=dict(autohint=autohint,autohint_drop=autohint_drop,autohint_purge=autohint_purge,
              purge=purge,timecapsule_table=timecapsule_table,create_table_partition=create_table_partition,
              create_table_subpartition=create_table_subpartition,alter_table_partition=alter_table_partition,
              alter_table_subpartition=alter_table_subpartition,alter_table=alter_table,
              generated_update_system=generated_update_system)


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--update',action='store_true');args=parser.parse_args()
    out=[]
    for builder in BUILDERS.values():
        p=builder()
        for name,obj in p.finish().items():
            path=ROOT/'specs'/p.category.lower()/p.id/name
            content=yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110)
            if path.exists():
                if not args.update:raise FileExistsError(path)
                old=path.read_text()
                if old==content:continue
                out.append('*** Update File: '+str(path))
                out.extend('@@' if line.startswith('@@') else line for line in list(difflib.unified_diff(
                    old.splitlines(),content.splitlines(),n=max(len(old.splitlines()),len(content.splitlines())),lineterm=''))[2:])
            else:out.append('*** Add File: '+str(path));out.extend('+'+line for line in content.splitlines())
    print('\n'.join(['*** Begin Patch']+out+['*** End Patch']))


if __name__=='__main__':main()
