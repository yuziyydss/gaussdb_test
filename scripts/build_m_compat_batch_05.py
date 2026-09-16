#!/usr/bin/env python3
"""Curated fifth M batch: local source-backed specifications, never SQL execution."""
import argparse
import difflib
import hashlib
from pathlib import Path
import sys
import yaml

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from scripts.build_m_compat_pilot import Package,BASE,SRC,seq,slot,repeat
from scripts.build_m_compat_batch_04 import gate,role_gates,ROLE_SHARED,ROLE_EXISTING,ROLE_SECOND
from scripts.build_m_compat_batch_03 import index_dependency,INDEX
from core.m_compat_environment import MEnvironment,guard

CORPUS=ROOT/'work/m_compat_batch_05/corpus'


def domain(p):
    return {k:[c['values'][0]['id'].removeprefix(p.id+'_'+k+'_') for c in d['classes']]
            for k,d in p.dims.items() if 'classes' in d}


def analyze():
    p=Package('ANALYZE','UTILITY',CORPUS)
    p.fact('syntax','syntax','普通表 ANALYZE 可选 VERBOSE、单层括号列列表。','ANALYZE [ VERBOSE ]',2)
    p.fact('multi','syntax','手动多列统计采用双层括号列列表。','table_name (( column_1_name',1)
    p.fact('column_exists','constraint','ANALYZE 指定列必须是已有列。','取值范围：已有的列名',1)
    p.fact('owner','environment','ANALYZE 需要表所有者或表 ANALYZE 权限，本批为 fixture 表创建者。','要对一个表进行ANALYZE',5)
    p.fact('transaction','environment','普通 ANALYZE 可在事务/PREPARE 中执行，不包括 VERIFY。','ANALYZE操作（不包含ANALYZE VERIFY）',2)
    p.fact('row_storage','environment','ANALYZE 收集统计信息目前仅支持行存表。','对于ANALYZE收集统计信息，目前仅支持行存表。')
    p.exports=[p.fid('owner'),p.fid('transaction'),p.fid('row_storage')]
    p.fact('rollback','behavior_oracle','PG_CLASS/PG_PARTITION 和相关统计函数字段不支持统计回滚。','不支持对PG_CLASS和PG_PARTITION',7)
    p.fact('multi_limits','constraint','多列统计根据 enable_functional_dependency 最多4或32列；系统表、全局临时表不支持。','如果关闭GUC参数enable_functional_dependency',4)
    p.fact('verify','environment','ANALYZE VERIFY 用于异常检测，需要 RELEASE 版本；不混入普通统计清单。','ANALYZE VERIFY操作处理的大多',3)
    p.dim('verbose',[('none',''),('yes','VERBOSE')])
    p.dim('columns',[('all',''),('id','(id)'),('two','(id, qty)'),('multi','((id, qty))'),('missing','(missing_col)')])
    p.dims['columns']['classes'][3]['values'][0]['fact_refs']=[p.fid('multi')]
    p.dims['columns']['classes'][-1]['values'][0].update(validity='invalid',fact_refs=[p.fid('column_exists')])
    p.rule('column_exists',f"columns != '{p.vid('columns','missing')}'",'column_exists')
    p.ast=seq('ANALYZE ',slot('verbose'),' '+SRC+' ',slot('columns'))
    p.manifest('ordinary',dict(verbose=['none','yes'],columns=['all','id','two','multi']),[BASE])
    p.manifest('missing_column',dict(columns=['missing']),[BASE],negative='column_exists')
    gate(p,'table_authority',['fixture_table_creator'],[p.fid('owner')])
    gate(p,'execution_context',['top_level_autocommit'],[p.fid('transaction')])
    p.scenario('statistics',['rollback','multi_limits','row_storage'],[BASE],[dict(action='只对本case行存表查询 pg_statistic/pg_statistic_ext，区分统计回滚边界与多列统计；不按语法成功推断统计值完整。')],
        [dict(kind='manual_assertion',expected='统计内容/回滚/4或32列上限仍待行为验证')])
    p.scenario('verify_environment',['verify'],[],[dict(action='另配 RELEASE 版本与目标表文件检测场景；不扫描全库或损坏真实数据。')],
        [dict(kind='manual_assertion',expected='VERIFY 与普通 ANALYZE 分阶段，尚未建模')])
    return p


def vacuum():
    p=Package('VACUUM','UTILITY',CORPUS)
    p.fact('syntax','syntax','VACUUM 有无括号普通形式、固定顺序 ANALYZE 形式以及括号选项列表。','VACUUM [ ( { FULL',12)
    p.fact('transaction','environment','VACUUM 不能在事务块内执行。','VACUUM不能在事务块内执行',1)
    p.fact('owner','environment','仅处理显式指定的本 case 表，由表创建者进行维护。','要对一个表进行VACUUM',5)
    p.fact('columns','constraint','列列表需要 ANALYZE 选项。','需要配合analyze选项使用',2)
    p.fact('order','syntax','括号选项顺序任意，无括号时必须遵循语法顺序。','当含有带括号的选项列表时',2)
    p.fact('partial','lifecycle','VACUUM ANALYZE 列名错误时可能已完成 VACUUM，不能认为失败意味着没有副作用。','column_name错误时',3)
    p.fact('full','behavior_oracle','FULL 重建表释放空间且施加排他锁；空间效果不是简单 DELETE 后立即可验证。','执行DELETE后立即执行VACUUM FULL',3)
    p.dim('form',[('plain',''),('analyze',''),('options','')])
    p.dim('full',[('none',''),('yes','FULL')])
    p.dim('freeze',[('none',''),('yes','FREEZE')])
    p.dim('verbose',[('none',''),('yes','VERBOSE')])
    p.dim('options',[('analyze','ANALYZE'),('verbose','VERBOSE'),('verbose_analyze','VERBOSE, ANALYZE'),
        ('analyze_verbose','ANALYZE, VERBOSE'),('freeze_analyze','FREEZE, ANALYZE'),('full_analyze','FULL, ANALYZE')],'order')
    p.dim('columns',[('all',''),('id','(id)'),('two','(id, qty)')])
    rule=(f"columns == '{p.vid('columns','all')}' or form == '{p.vid('form','analyze')}' or "
          f"(form == '{p.vid('form','options')}' and options != '{p.vid('options','verbose')}')")
    p.rule('columns_require_analyze',rule,'columns')
    t='m_vacuum_source';plain=seq('VACUUM ',slot('full'),' ',slot('freeze'),' ',slot('verbose'))
    p.ast=dict(kind='choice',selector='form',branches={p.vid('form','plain'):seq(plain,' '+t),
        p.vid('form','analyze'):seq(plain,' ANALYZE '+t+' ',slot('columns')),
        p.vid('form','options'):seq('VACUUM (',slot('options'),') '+t+' ',slot('columns'))})
    fx=p.fixture('dead_rows',[(t,['id','qty'])],[f'CREATE TABLE {t} (id INTEGER, qty INTEGER);',
        f'INSERT INTO {t} VALUES (1,10),(2,20),(3,30);',f'DELETE FROM {t} WHERE id = 1;'],[f'DROP TABLE {t};'])
    p.manifest('plain',dict(form=['plain'],full=['none','yes'],freeze=['none','yes'],verbose=['none','yes'],columns=['all']),[fx])
    p.manifest('analyze',dict(form=['analyze'],full=['none','yes'],freeze=['none','yes'],verbose=['none','yes'],columns=['all','id','two']),[fx])
    p.manifest('options',dict(form=['options'],options=['analyze','verbose','verbose_analyze','analyze_verbose','freeze_analyze','full_analyze'],columns=['all','id','two']),[fx])
    p.manifest('columns_without_analyze',dict(form=['options'],options=['verbose'],columns=['id']),[fx],negative='columns_require_analyze')
    gate(p,'execution_context',['top_level_autocommit'],[p.fid('transaction')]);gate(p,'table_authority',['fixture_table_creator'],[p.fid('owner')])
    p.scenario('physical_effects',['full','partial'],[fx],[dict(action='分别检查维护阶段、副作用与空间恢复时机；禁止把错误自动当回滚或对共享表做维护。')],
        [dict(kind='manual_assertion',expected='物理空间、锁与失败阶段尚未实机验证')])
    return p


def reindex():
    p=Package('REINDEX','DDL',CORPUS)
    p.fact('syntax','syntax','REINDEX 的 INDEX/TABLE 指定对象形式可选 CONCURRENTLY 和 FORCE。','REINDEX { INDEX | [INTERNAL] TABLE | DATABASE',2)
    p.fact('online','environment','CONCURRENTLY 不可在事务内执行，只支持普通/分区 B-tree/UB-tree，排除 PCR ubtree 等。','CONCURRENTLY时，在线重建当前数据库',6)
    p.fact('force','behavior_oracle','FORCE 只为语法兼容，无实际含义。','仅为语法兼容，并无实际含义',1)
    p.fact('invalid','constraint','TABLE 不会重建已被 alter unusable 失效的索引。','如果表上有索引已经被alter unusable',1)
    p.fact('failure','lifecycle','在线重建故障可能留下非法索引和临时表，需按确切对象识别清理，不猜后缀广泛删除。','系统无法自动清理失败新',6)
    p.fact('partition','open_question','partition_name 参数说明写索引/表名称，与分区产生式存在歧义；当前不生成分区。','需要重建索引的索引名称或者表名称',5,'needs_verification')
    p.dim('target',[('index','INDEX '+INDEX),('table','TABLE '+SRC)])
    p.dim('online',[('off',''),('on','CONCURRENTLY')])
    p.dim('force',[('none',''),('yes','FORCE')])
    p.ast=dict(kind='choice',selector='target',branches={
        p.vid('target','index'):seq('REINDEX INDEX ',slot('online'),' '+INDEX+' ',slot('force')),
        p.vid('target','table'):seq('REINDEX TABLE ',slot('online'),' '+SRC+' ',slot('force'))})
    fx=index_dependency(p);p.manifest('ordinary',dict(target=['index','table'],online=['off'],force=['none','yes']),[fx])
    p.manifest('online',dict(target=['index','table'],online=['on'],force=['none','yes']),[fx])
    for key,vals in [('execution_context',['top_level_autocommit']),('index_storage',['verified_non_pcr_btree_or_ubtree'])]:
        p.files['manifests/online.manifest.yaml']['environment_requirements'].append(dict(key=key,allowed_values=vals,fact_refs=[p.fid('online')]))
    p.scenario('physical',['force','invalid','failure'],[fx],[dict(action='检查有效索引、真实重建结果与在线失败的确切残留；不把 FORCE 当作强制修复或扫描系统目录重建。')],
        [dict(kind='manual_assertion',expected='物理重建/失败恢复保留待验证，不默认运行全库或系统重建')])
    return p


def lock():
    p=Package('LOCK','UTILITY',CORPUS)
    p.fact('syntax','syntax','LOCK 可选 TABLE/TABLES，支持表列表、READ/WRITE/IN ACCESS SHARE MODE 和 NOWAIT。','LOCK [ TABLE | TABLES ]',10)
    p.fact('transaction','environment','LOCK 必须在事务块内，事务结束释放锁；没有 UNLOCK TABLE。','LOCK TABLE只能在一个事务块的内部',5)
    p.fact('supported_modes','constraint','M 不支持显式 LOCK 获取 ROW SHARE/ROW EXCLUSIVE 等其余锁模式。','M-Compatibility模式数据库下暂不支持使用LOCK',1)
    p.fact('order','behavior_oracle','表列表顺序就是加锁顺序。','LOCK TABLE命令中声明的表的顺序',1)
    p.fact('nowait','behavior_oracle','NOWAIT 遇到冲突立即报错，不指定则等待。','声明LOCK TABLE不去等待',4)
    p.fact('access_share_conflict','open_question','ACCESS SHARE 文字称禁止修改，但表2-27仅与WRITE冲突；已核对物理页2231，不直接推导并发写 Oracle。','ACCESS SHARE锁只允许对表进行读取',3,'needs_verification')
    p.dim('keyword',[('none',''),('table','TABLE'),('tables','TABLES')])
    p.dim('count',[('one',''),('two','')])
    p.dim('mode',[('default',''),('read','READ'),('write','WRITE'),('access','IN ACCESS SHARE MODE'),('unsupported','IN ROW SHARE MODE')])
    p.dims['mode']['classes'][-1]['values'][0].update(validity='invalid',fact_refs=[p.fid('supported_modes')])
    p.dim('nowait',[('none',''),('yes','NOWAIT')])
    p.rule('supported_modes',f"mode != '{p.vid('mode','unsupported')}'",'supported_modes')
    first=seq('m_lock_one ',slot('mode'))
    p.ast=seq('LOCK ',slot('keyword'),' ',dict(kind='choice',selector='count',branches={
        p.vid('count','one'):first,p.vid('count','two'):seq(first,', m_lock_two ',slot('mode'))}),' ',slot('nowait'))
    fx=p.fixture('transaction',[('m_lock_one',['id']),('m_lock_two',['id'])],
        ['CREATE TABLE m_lock_one (id INTEGER);','CREATE TABLE m_lock_two (id INTEGER);','START TRANSACTION;'],
        ['ROLLBACK;','DROP TABLE m_lock_two;','DROP TABLE m_lock_one;'])
    values=domain(p);values['mode'].remove('unsupported');p.manifest('finite',values,[fx])
    p.manifest('unsupported_mode',dict(mode=['unsupported']),[fx],negative='supported_modes')
    gate(p,'execution_context',['same_explicit_transaction'],[p.fid('transaction')])
    p.scenario('concurrency',['order','nowait'],[fx],[dict(action='需要两个会话分别申请冲突锁并验证 NOWAIT/等待和顺序；当前两表采用同一锁模式，不代表所有混合模式。')],
        [dict(kind='manual_assertion',expected='跨会话锁冲突尚未执行')])
    return p


def select_into():
    p=Package('SELECT INTO','DML',CORPUS)
    p.fact('syntax','syntax','生成 SELECT 投影 INTO [TABLE] 新表 FROM 源表的前置 INTO 分支。',
        next(i+1 for i,line in enumerate(p.lines) if line.strip()=='SELECT'),5)
    p.fact('output','metadata_oracle','新表字段名称和类型与 SELECT 输出字段相同；数据不返回客户端。','数据并不返回给客户端',2)
    p.fact('duplicate_into','open_question','跨页语法块两次列出 INTO，未标选择关系；仅采用前置INTO且与本章示例一致，不复制两次。','[LIMIT {[offset,] row_count',3,'needs_verification')
    p.fact('temporary','lifecycle','GLOBAL 临时表元数据跨会话保留、数据隔离；LOCAL 会话结束删除，当前只生成永久目标。','全局临时表的元数据对所有会话可见',13)
    p.fact('other_parameters','syntax','SELECT INTO 其他参数引用 SELECT；本批仅直接整数列/WHERE，复杂查询保留后续。','SELECT INTO的其他参数说明',1)
    t='m_select_into_source';target='m_select_into_new'
    p.dim('modifier',[('none',''),('all','ALL'),('distinct','DISTINCT'),('distinctrow','DISTINCTROW')])
    p.dim('cache',[('none',''),('off','SQL_NO_CACHE')])
    p.dim('table_keyword',[('none',''),('yes','TABLE')])
    p.matrix_dim('projection',[(name,'',dict(items=cols,source_tables=[t],source_columns=cols,
        output_columns=cols,output_types=['INTEGER']*len(cols),output_column_count=len(cols),direct_columns=True))
        for name,cols in [('id',['id']),('two',['id','qty']),('reverse',['qty','id'])]])
    p.dim('where',[('none',''),('positive','WHERE id > 1')])
    p.ast=seq('SELECT ',slot('modifier'),' ',slot('cache'),' ',repeat('projection'),' INTO ',slot('table_keyword'),
        ' '+target+' FROM '+t+' ',slot('where'))
    fx=p.fixture('source',[(t,['id','qty'])],[f'CREATE TABLE {t} (id INTEGER, qty INTEGER);',
        f'INSERT INTO {t} VALUES (1,10),(2,20),(3,30);'],[f'DROP TABLE IF EXISTS {target};',f'DROP TABLE {t};'])
    values=domain(p);values['projection']=['id','two','reverse'];p.manifest('direct_columns',values,[fx])
    p.scenario('output_contract',['output'],[fx],[dict(action='根据所选投影检查新表列顺序/名称/INTEGER类型与复制行；不额外推导 DEFAULT/NOT NULL 继承。')],
        [dict(kind='manual_assertion',expected='列元数据和复制结果尚未实机验证')])
    p.scenario('temporary_lifetime',['temporary'],[],[dict(action='另外配置真实 GLOBAL/LOCAL 多会话临时表生命周期，禁止清理系统临时 Schema。')],
        [dict(kind='manual_assertion',expected='临时目标当前未生成，保持真实缺口')])
    return p


LABEL_SCHEMA='m_label_namespace'
LABEL_TABLE=LABEL_SCHEMA+'.source'
LABEL_VIEW=LABEL_SCHEMA+'.source_view'
LABEL_RESOURCES='fixture_m_create_resource_label_resources'
AUDIT_LABEL='m_b05_audit_label'


def label_assets(p,suffix,cleanup_labels=()):
    return p.fixture(suffix,[(LABEL_TABLE,['id','qty'])],[f'CREATE SCHEMA {LABEL_SCHEMA};',
        f'CREATE TABLE {LABEL_TABLE} (id INTEGER, qty INTEGER);',
        f'CREATE VIEW {LABEL_VIEW} AS SELECT id, qty FROM {LABEL_TABLE};'],
        [f'DROP RESOURCE LABEL IF EXISTS {n};' for n in cleanup_labels]+
        [f'DROP VIEW {LABEL_VIEW};',f'DROP TABLE {LABEL_TABLE};',f'DROP SCHEMA {LABEL_SCHEMA};'])


def resource_label(command):
    p=Package(command,'DDL',CORPUS);create=command=='CREATE RESOURCE LABEL';alter=command=='ALTER RESOURCE LABEL'
    p.fact('authority','environment','仅 POLADMIN、SYSADMIN 或初始用户可以操作资源标签；本批限定 SYSADMIN 创建自身测试资源。',
        '仅POLADMIN、SYSADMIN或初始用户',1)
    if create:
        p.fact('syntax','syntax','CREATE RESOURCE LABEL 可选 IF NOT EXISTS，ADD 后支持资源种类与路径列表。','CREATE RESOURCE LABEL [IF NOT EXISTS]',1)
        p.fact('types','syntax','可标记 TABLE、COLUMN、SCHEMA、VIEW、FUNCTION；当前仅前四类，函数资源需要内部接口审阅。','{ TABLE | COLUMN | SCHEMA | VIEW | FUNCTION }',1)
        p.fact('unique','constraint','资源标签名必须唯一。','资源标签名称，必须确保其唯一性',1)
        p.fact('notice','behavior_oracle','IF NOT EXISTS 对已存在标签发 NOTICE，不报错误。','如果指定的资源标签存在',1)
    elif alter:
        p.fact('syntax','syntax','ALTER RESOURCE LABEL 通过 ADD 或 REMOVE 修改资源列表。','ALTER RESOURCE LABEL label_name',2)
        p.fact('types','syntax','标记路径支持 TABLE、COLUMN、SCHEMA、VIEW、FUNCTION。','TABLE | COLUMN | SCHEMA | VIEW | FUNCTION',1)
        p.fact('membership','lifecycle','示例先创建 id 标签，ADD 另一列，再 REMOVE 原有列；修改测试需明确初始资源成员。','将col2添加至资源标签',7)
    else:
        p.fact('syntax','syntax','DROP RESOURCE LABEL 可选 IF EXISTS 并接受多个标签名。','DROP RESOURCE LABEL [IF EXISTS]',1)
        p.fact('notice','behavior_oracle','IF EXISTS 遇到不存在标签发 NOTICE，不报错误。','如果指定的资源标签不存在',1)
    if create or alter:
        resources=[('table',f'TABLE ({LABEL_TABLE})'),('column',f'COLUMN ({LABEL_TABLE}.qty)'),
            ('schema',f'SCHEMA ({LABEL_SCHEMA})'),('view',f'VIEW ({LABEL_VIEW})')]
        if create:resources += [('columns',f'COLUMN ({LABEL_TABLE}.id, {LABEL_TABLE}.qty)'),
            ('mixed',f'TABLE ({LABEL_TABLE}), VIEW ({LABEL_VIEW})')]
        p.dim('resources',resources,'types')
    if create:
        target='m_create_resource_label_new';p.dim('if_not_exists',[('none',''),('yes','IF NOT EXISTS')])
        p.ast=seq('CREATE RESOURCE LABEL ',slot('if_not_exists'),' '+target+' ADD ',slot('resources'))
        fx=label_assets(p,'creation',[target]);label_assets(p,'resources')
        p.fixture('audit_label',[],[f'CREATE RESOURCE LABEL {AUDIT_LABEL} ADD TABLE ({LABEL_TABLE});'],
            [f'DROP RESOURCE LABEL IF EXISTS {AUDIT_LABEL};'],requires=[LABEL_RESOURCES])
        p.manifest('finite',domain(p),[fx])
        p.scenario('collision',['unique','notice'],[],[dict(action='在专用已存在标签上比较有/无IF NOT EXISTS，需目标重名错误与NOTICE校准。')],
            [dict(kind='manual_assertion',expected='存在状态与错误/NOTICE尚未执行')])
    elif alter:
        target='m_alter_resource_label_existing';p.dim('action',[('add','ADD'),('remove','REMOVE')])
        p.ast=seq('ALTER RESOURCE LABEL '+target+' ',slot('action'),' ',slot('resources'))
        for action in ('add','remove'):
            initial=f'COLUMN ({LABEL_TABLE}.id)'
            if action=='remove':initial+=', '+', '.join(render for _,render in resources)
            fx=p.fixture(action,[],[f'CREATE RESOURCE LABEL {target} ADD {initial};'],
                [f'DROP RESOURCE LABEL IF EXISTS {target};'],requires=[LABEL_RESOURCES])
            p.manifest(action,dict(action=[action],resources=[k for k,_ in resources]),[fx])
        p.scenario('members',['membership'],[],[dict(action='检查ADD前未包含、REMOVE前包含目标资源；REMOVE后仍保留id列，避免空标签状态混入。')],
            [dict(kind='manual_assertion',expected='资源成员变化与底层对象仍存在需独立Oracle')])
    else:
        one='m_drop_resource_label_one';two='m_drop_resource_label_two'
        p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
        p.dim('targets',[('one','',dict(items=[one])),('two','',dict(items=[one,two]))])
        p.ast=seq('DROP RESOURCE LABEL ',slot('if_exists'),' ',repeat('targets'))
        fx=p.fixture('labels',[],[f'CREATE RESOURCE LABEL {one} ADD TABLE ({LABEL_TABLE});',f'CREATE RESOURCE LABEL {two} ADD VIEW ({LABEL_VIEW});'],
            [f'DROP RESOURCE LABEL IF EXISTS {two};',f'DROP RESOURCE LABEL IF EXISTS {one};'],requires=[LABEL_RESOURCES])
        p.manifest('finite',domain(p),[fx])
        p.scenario('missing_notice',['notice'],[],[dict(sql='DROP RESOURCE LABEL IF EXISTS m_drop_resource_label_absent;')],
            [dict(kind='manual_assertion',expected='缺失标签只NOTICE，尚未执行')])
    gate(p,'actor_authority',['sysadmin'],[p.fid('authority')])
    return p


def audit_policy(command):
    p=Package(command,'DDL',CORPUS);create=command=='CREATE AUDIT POLICY';alter=command=='ALTER AUDIT POLICY'
    authority='审计策略的创建与维护' if create else '审计策略的维护' if alter else '仅POLADMIN、SYSADMIN'
    p.fact('authority','environment','仅 POLADMIN、SYSADMIN 或初始用户；本批限定 SYSADMIN 和专用测试资源。',authority,2 if create or alter else 1)
    if create or alter:
        p.fact('security_on','environment','本批要求已由环境管理者确认 enable_security_policy=on，不在 fixture 中切换配置。',
            '在创建审计策略之前' if create else '仅在打开enable_security_policy',2 if create else 1)
    if create:
        p.exports=[p.fid('security_on')]
        p.fact('syntax','syntax','CREATE AUDIT POLICY 可选 IF NOT EXISTS，PRIVILEGES/ACCESS 子句及过滤、启停选项。','CREATE AUDIT POLICY [ IF NOT EXISTS ]',2)
        p.fact('operations','syntax','PRIVILEGES 和 ACCESS 各有独立操作类型；当前选取 ALTER/ANALYZE 与 SELECT/UPDATE。','{ ALTER | ANALYZE | COMMENT',8)
        p.fact('filters','syntax','FILTER ON 支持 APP、ROLES、IP，可列举多个过滤项。','FILTER ON { FILTER_TYPE',1)
        p.fact('enabled','behavior_oracle','不写 ENABLE/DISABLE 时策略默认 ENABLE。','若不指定，默认为ENABLE',1)
        p.fact('analyze','behavior_oracle','ANALYZE 审计类型同时审计 ANALYZE 和 VACUUM。','取值为ANALYZE时',1)
        p.fact('notice','behavior_oracle','IF NOT EXISTS 遇到已有同名策略只 NOTICE。','如果指定的审计策略存在',1)
        p.fact('multi_ambiguity','open_question','多操作示例后续 INSERT/DELETE 未重复 ACCESS，且 DELETE 未指定标签；当前只建模单操作，不推定重复前缀规则。',
            'adt3 ACCESS SELECT ON LABEL',2,'needs_verification')
        p.fact('wording','open_question','审计策略前置开关段落称脱敏策略生效；保留文案差异，不推导脱敏能力。','置GUC参数enable_security_policy',1,'needs_verification')
        p.dim('if_not_exists',[('none',''),('yes','IF NOT EXISTS')])
        p.dim('operation',[('alter','PRIVILEGES ALTER'),('analyze','PRIVILEGES ANALYZE'),('select','ACCESS SELECT'),('update','ACCESS UPDATE')],'operations')
        p.dim('filter',[('none',''),('ip',"FILTER ON IP('127.0.0.1')"),('app','FILTER ON APP(gsql)'),
            ('combined',"FILTER ON APP(gsql), IP('127.0.0.1', '127.0.0.0/24')")],'filters')
        p.dim('enabled',[('default',''),('enable','ENABLE'),('disable','DISABLE')])
        target='m_create_audit_policy_new'
        p.ast=seq('CREATE AUDIT POLICY ',slot('if_not_exists'),' '+target+' ',slot('operation'),
            ' ON LABEL ('+AUDIT_LABEL+') ',slot('filter'),' ',slot('enabled'))
        # This case owns a fresh label; its cleanup must drop the target policy
        # before dropping that label. No dependency wrapper may discard SQL.
        fx=p.fixture('creation',[],[f'CREATE RESOURCE LABEL {AUDIT_LABEL} ADD TABLE ({LABEL_TABLE});'],
            [f'DROP AUDIT POLICY IF EXISTS {target};',f'DROP RESOURCE LABEL IF EXISTS {AUDIT_LABEL};'],requires=[LABEL_RESOURCES])
        p.manifest('finite',domain(p),[fx])
        p.scenario('behavior',['enabled','analyze','notice'],[],[dict(action='校准默认启用、ANALYZE/VACUUM审计事件、重名NOTICE；语法生成不证明日志行为。')],
            [dict(kind='manual_assertion',expected='目录状态、审计日志、NOTICE和目标错误尚待独立执行')])
    elif alter:
        p.fact('syntax','syntax','ADD/REMOVE 的 PRIVILEGES/ACCESS 子句使用括号，与 CREATE 不同。','ALTER AUDIT POLICY [ IF EXISTS ] policy_name { ADD',2)
        p.fact('modify','syntax','MODIFY 以括号包围 FILTER ON 子句。','policy_name MODIFY ( filter_group_clause )',1)
        p.fact('drop_filter','syntax','DROP FILTER 删除已有过滤条件。','policy_name DROP FILTER',1)
        p.fact('comments','syntax','COMMENTS 后接策略描述文本。','policy_name COMMENTS',1)
        p.fact('enabled','syntax','ENABLE/DISABLE 切换策略状态。','policy_name { ENABLE | DISABLE }',1)
        p.fact('membership','lifecycle','示例先创建 CREATE 审计，再 ADD DROP，最后 REMOVE DROP；移除前操作必须已存在。','-- 添加adt1审计策略中的DROP',6)
        p.fact('filter_ambiguity','open_question','ROLES 示例比 FILTER ON 主语法多一层括号；当前生成主语法的 IP/APP，不采用该示例括号。','MODIFY (FILTER ON (ROLES',1,'needs_verification')
        changes=[('add_drop',f'ADD PRIVILEGES (DROP ON LABEL ({AUDIT_LABEL}))'),
            ('add_alter',f'ADD PRIVILEGES (ALTER ON LABEL ({AUDIT_LABEL}))'),
            ('remove_drop',f'REMOVE PRIVILEGES (DROP ON LABEL ({AUDIT_LABEL}))'),
            ('remove_alter',f'REMOVE PRIVILEGES (ALTER ON LABEL ({AUDIT_LABEL}))'),
            ('modify_ip',"MODIFY (FILTER ON IP('127.0.0.1'))"),('modify_app','MODIFY (FILTER ON APP(gsql))'),
            ('drop_filter','DROP FILTER'),('comments',"COMMENTS 'M finite audit policy'"),('enable','ENABLE'),('disable','DISABLE')]
        p.dim('change',changes);p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
        for c in p.dims['change']['classes']:
            v=c['values'][0];key=v['id'].removeprefix(p.id+'_change_')
            fact='modify' if key.startswith('modify') else key if key in ('drop_filter','comments') else 'enabled' if key in ('enable','disable') else 'syntax'
            v['fact_refs']=[p.fid(fact)]
        target='m_alter_audit_policy_existing';p.ast=seq('ALTER AUDIT POLICY ',slot('if_exists'),' '+target+' ',slot('change'))
        for group,keys in [('add',['add_drop','add_alter']),('remove',['remove_drop','remove_alter']),
                ('modify',['modify_ip','modify_app']),('drop_filter',['drop_filter']),('comments',['comments']),('enable',['enable']),('disable',['disable'])]:
            initial='ENABLE' if group=='disable' else 'DISABLE'
            setup=[f'CREATE AUDIT POLICY {target} PRIVILEGES CREATE ON LABEL ({AUDIT_LABEL}) FILTER ON IP(\'127.0.0.1\') {initial};']
            if group=='remove':setup += [f'ALTER AUDIT POLICY {target} ADD PRIVILEGES ({op} ON LABEL ({AUDIT_LABEL}));' for op in ('DROP','ALTER')]
            fx=p.fixture(group,[],setup,[f'DROP AUDIT POLICY IF EXISTS {target};'],requires=['fixture_m_create_resource_label_audit_label'])
            p.manifest(group,dict(change=keys,if_exists=['none','yes']),[fx])
        p.scenario('state',['membership'],[],[dict(action='校准目录成员ADD/REMOVE、启停前后值、过滤器及COMMENTS；REMOVE后保留CREATE审计项。')],
            [dict(kind='manual_assertion',expected='前置状态已静态检查，状态变化尚未实机验证')])
    else:
        p.fact('syntax','syntax','DROP AUDIT POLICY 可选 IF EXISTS，只接受单个已有策略名。','DROP AUDIT POLICY [IF EXISTS]',1)
        p.fact('notice','behavior_oracle','IF EXISTS 遇到缺失策略只 NOTICE。','如果指定的审计策略不存在',1)
        target='m_drop_audit_policy_existing';p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
        p.ast=seq('DROP AUDIT POLICY ',slot('if_exists'),' '+target)
        fx=p.fixture('existing',[],[f'CREATE AUDIT POLICY {target} ACCESS SELECT ON LABEL ({AUDIT_LABEL}) DISABLE;'],
            [f'DROP AUDIT POLICY IF EXISTS {target};'],requires=['fixture_m_create_resource_label_audit_label'])
        p.manifest('finite',domain(p),[fx])
        p.scenario('missing_notice',['notice'],[],[dict(sql='DROP AUDIT POLICY IF EXISTS m_drop_audit_policy_absent;')],
            [dict(kind='manual_assertion',expected='缺失策略NOTICE及不带IF EXISTS的目标错误需校准')])
    gate(p,'actor_authority',['sysadmin'],[p.fid('authority')])
    gate(p,'enable_security_policy',['on'],[p.fid('security_on')] if create or alter else ['m_create_audit_policy::m_create_audit_policy_fact_security_on'])
    return p


def default_privileges():
    p=Package('ALTER DEFAULT PRIVILEGES','DCL',CORPUS)
    p.fact('syntax','syntax','默认权限按可选目标角色、Schema与GRANT/REVOKE子句修改。',next(i+1 for i,line in enumerate(p.lines) if line.strip()=='ALTER DEFAULT PRIVILEGES'),4)
    p.fact('object_scope','constraint','当前只支持表（含视图）和序列；表与序列的权限集合不同。','目前只支持表',1)
    p.fact('tables','syntax','表默认权限支持 SELECT、INSERT 等及再授权。','GRANT { { SELECT | INSERT',6)
    p.fact('sequences','syntax','序列默认权限支持 SELECT、USAGE 等及再授权。','GRANT { { SELECT | UPDATE | USAGE',5)
    p.fact('table_privileges','constraint','表默认权限枚举中不包含USAGE。','GRANT { { SELECT | INSERT',4)
    p.fact('sequence_privileges','constraint','序列默认权限枚举中不包含INSERT。','GRANT { { SELECT | UPDATE | USAGE',3)
    p.fact('revoke','syntax','回收可指定 GRANT OPTION FOR 与缺省/RESTRICT；当前不生成级联。','REVOKE [ GRANT OPTION FOR ]',7)
    p.fact('owner','environment','未指定 FOR ROLE/USER 时目标为当前角色；本批不修改其他创建者的默认ACL。','则默认为当前角色/用户',1)
    p.fact('schema','environment','目标Schema必须存在，目标创建者需有其CREATE权限；本批由Schema创建者操作。','target_role对象必须拥有schema_name的CREATE权限',1)
    p.fact('existing','behavior_oracle','默认权限修改不影响既有对象已分配的权限。','此操作不会影响已分配给现有对象',2)
    p.fact('cleanup','lifecycle','删除受权角色前需恢复修改的默认权限；本批只做专用Schema定向恢复，不使用DROP OWNED。','如果要删除一个被赋予了默认权限的角色',2)
    p.dim('action',[('grant','GRANT'),('revoke','REVOKE')])
    p.dim('object',[('tables','TABLES'),('sequences','SEQUENCES')])
    p.dim('privilege',[('select','SELECT'),('insert','INSERT'),('usage','USAGE')],'tables')
    p.dims['privilege']['classes'][-1]['values'][0]['fact_refs']=[p.fid('sequences')]
    p.dim('grant_option',[('none',''),('yes','WITH GRANT OPTION')],'tables')
    p.dim('revoke_option',[('none',''),('yes','GRANT OPTION FOR')],'revoke')
    p.dim('behavior',[('default',''),('restrict','RESTRICT')],'revoke')
    p.rule('privilege_domain',f"(object == '{p.vid('object','tables')}' and privilege != '{p.vid('privilege','usage')}') or (object == '{p.vid('object','sequences')}' and privilege != '{p.vid('privilege','insert')}')",'table_privileges')
    p.rules[-1]['fact_refs'].append(p.fid('sequence_privileges'))
    ns='m_default_privilege_namespace';prefix='ALTER DEFAULT PRIVILEGES IN SCHEMA '+ns+' '
    p.ast=seq(prefix,dict(kind='choice',selector='action',branches={
        p.vid('action','grant'):seq('GRANT ',slot('privilege'),' ON ',slot('object'),' TO '+ROLE_EXISTING+' ',slot('grant_option')),
        p.vid('action','revoke'):seq('REVOKE ',slot('revoke_option'),' ',slot('privilege'),' ON ',slot('object'),' FROM '+ROLE_EXISTING+' ',slot('behavior'))}))
    basic=[f'CREATE SCHEMA {ns};',f'GRANT USAGE ON SCHEMA {ns} TO {ROLE_EXISTING};']
    clean=[prefix+f'REVOKE ALL PRIVILEGES ON {kind} FROM {ROLE_EXISTING} RESTRICT;' for kind in ('TABLES','SEQUENCES')]+[f'DROP SCHEMA {ns};']
    fx=p.fixture('new_scope',[],basic,clean,requires=[ROLE_SHARED])
    for scope,privileges in [('tables',['select','insert']),('sequences',['select','usage'])]:
        granted=', '.join(x.upper() for x in privileges)
        rfx=p.fixture('granted_'+scope,[],basic+[prefix+f'GRANT {granted} ON {scope.upper()} TO {ROLE_EXISTING} WITH GRANT OPTION;'],clean,requires=[ROLE_SHARED])
        p.manifest('grant_'+scope,dict(action=['grant'],object=[scope],privilege=privileges,grant_option=['none','yes']),[fx])
        p.manifest('revoke_'+scope,dict(action=['revoke'],object=[scope],privilege=privileges,revoke_option=['none','yes'],behavior=['default','restrict']),[rfx])
    p.manifest('table_usage_negative',dict(action=['grant'],object=['tables'],privilege=['usage']),[fx],negative='privilege_domain')
    role_gates(p);gate(p,'default_acl_creator',['same_schema_creating_session'],[p.fid('owner'),p.fid('schema')])
    p.scenario('before_after',['existing','cleanup','object_scope'],[],[dict(action='隔离Schema中分别在授权前后创建表、视图和序列，用非管理员目标身份检查ACL；最后恢复默认ACL再删除角色。')],
        [dict(kind='manual_assertion',expected='已有对象不追溯变更，后建对象按默认ACL；未执行，不能用管理员访问成功证明受权角色权限')])
    return p


EXTENSION='security_plugin'
EXTENSION_SCHEMA='m_extension_namespace'
EXTENSION_FIXTURE='fixture_m_create_extension_installed'


def extension(command):
    p=Package(command,'DDL',CORPUS);create=command=='CREATE EXTENSION';alter=command=='ALTER EXTENSION'
    p.fact('internal','environment','本章明确不支持普通用户使用，仅内部高级包/扩展接口；候选需要内部工具审阅。',
        '修改插件扩展。当前不支持用户' if alter else '当前不支持用户使用此语法',2)
    if create:
        p.fact('syntax','syntax','CREATE EXTENSION 可选IF NOT EXISTS、WITH、已存在Schema、版本和旧式升级。','CREATE EXTENSION [ IF NOT EXISTS ]',4)
        p.fact('files','environment','必须预装并审阅真实扩展支持文件；当前仅使用本章示例security_plugin，不假定本机已安装。','必须先安装好该扩展的支',2)
        p.fact('enabled','environment','数据库禁止直接创建扩展，必须预先允许enable_extension；不在fixture切换配置。','数据库禁止直接创建扩展',3)
        p.fact('authority','environment','创建者需有创建扩展脚本组件的权限，且成为扩展所有者。','安装扩展需要有和创建他的组件对象',3)
        p.fact('schema','environment','指定Schema须存在；支持文件的Schema配置与指定安装位置必须先审阅一致。','指定的模式必须已',3)
        p.fact('collision','constraint','同名扩展组件已存在会导致创建失败。','数据库中存在与EXTENSION内同名',3)
        p.fact('notice','behavior_oracle','IF NOT EXISTS不保证已安装扩展与当前脚本内容相同。','不保证系统存在的扩展和现在脚本创建的扩展相同',1)
        p.fact('example','example','文档给出security_plugin安装/删除示例，名称仅为有限样本，不是安装状态证明。','例如安装security_plugin',3)
        p.exports=[p.fid(x) for x in ('files','enabled','authority','schema')]
        p.dim('if_not_exists',[('none',''),('yes','IF NOT EXISTS')]);p.dim('with_keyword',[('none',''),('yes','WITH')])
        p.ast=seq('CREATE EXTENSION ',slot('if_not_exists'),' '+EXTENSION+' ',slot('with_keyword'),' SCHEMA '+EXTENSION_SCHEMA)
        fx=p.fixture('creation',[],[f'CREATE SCHEMA {EXTENSION_SCHEMA};'],
            [f'DROP EXTENSION IF EXISTS {EXTENSION} RESTRICT;',f'DROP SCHEMA {EXTENSION_SCHEMA};'])
        p.fixture('installed',[],[f'CREATE SCHEMA {EXTENSION_SCHEMA};',f'CREATE EXTENSION {EXTENSION} SCHEMA {EXTENSION_SCHEMA};'],
            [f'DROP EXTENSION IF EXISTS {EXTENSION} RESTRICT;',f'DROP SCHEMA {EXTENSION_SCHEMA};'])
        p.manifest('internal_finite',domain(p),[fx])
        p.scenario('assets',['files','schema','collision','notice','example'],[],[dict(action='审批并核验security_plugin.control、默认版本脚本、组件清单、Schema适配和目标库未安装；不安装/下载支持文件，不用IF NOT EXISTS掩盖版本差异。')],
            [dict(kind='manual_assertion',expected='外部支持文件可用性未验证，版本/旧式FROM/碰撞与已存在NOTICE未建模')])
    elif alter:
        p.fact('syntax','syntax','ALTER EXTENSION ADD/DROP添加或解除真实成员对象；本批只使用TABLE成员。','ALTER EXTENSION name { ADD | DROP }',1)
        p.fact('enabled','environment','ALTER EXTENSION接口要求support_extended_features=true。','support_extended_features为true',1)
        p.fact('authority','environment','需要扩展所有权及ADD/DROP对象所有权；本批同一创建者。','您必须拥有扩展来使用',2)
        p.fact('detached','behavior_oracle','DROP member仅从扩展分离对象，不删除对象。','只是从扩展里分开了',1)
        p.fact('upgrade','environment','UPDATE需要可用更新脚本，SET SCHEMA要求扩展可重定位；当前不捏造版本或relocatable能力。','这个扩展必须满足一个适用的更新脚本',5)
        p.fact('member_conflict','open_question','参数描述列出函数等更多成员种类，主产生式只列较小集合；不自动扩充语法。','包含表、聚合',2,'needs_verification')
        p.dim('action',[('add','ADD'),('drop','DROP')]);member=EXTENSION_SCHEMA+'.member_table'
        p.ast=seq('ALTER EXTENSION '+EXTENSION+' ',slot('action'),' TABLE '+member)
        for action in ('add','drop'):
            setup=[f'CREATE TABLE {member} (id INTEGER);']
            if action=='drop':setup.append(f'ALTER EXTENSION {EXTENSION} ADD TABLE {member};')
            # ADD target makes the extension own the table. Drop the extension
            # before dropping a possible detached table; never cascade outward.
            fx=p.fixture(action,[(member,['id'])],setup,
                [f'DROP EXTENSION IF EXISTS {EXTENSION} RESTRICT;',f'DROP TABLE IF EXISTS {member};'],requires=[EXTENSION_FIXTURE])
            p.manifest('internal_'+action,dict(action=[action]),[fx])
        gate(p,'support_extended_features',['true'],[p.fid('enabled')])
        p.scenario('members',['detached','upgrade'],[],[dict(action='检查成员目录与DROP后表仍存在；版本更新/移动模式待真实脚本和relocatable证据，不操作系统默认plpgsql。')],
            [dict(kind='manual_assertion',expected='成员、更新与重定位尚未实机验证')])
    else:
        p.fact('syntax','syntax','DROP EXTENSION 支持IF EXISTS、多扩展与CASCADE/RESTRICT，当前只删除本case创建的security_plugin。','DROP EXTENSION [ IF EXISTS ]',1)
        p.fact('authority','environment','只有扩展所有者可删除扩展。','必须是扩展的拥有者',1)
        p.fact('members','lifecycle','DROP EXTENSION会一起删除扩展组件；不能用作共享数据库清理。','构成',2)
        p.fact('restrict','constraint','RESTRICT为缺省，有扩展外部依赖时拒绝删除。','如果有依赖于扩展的对象',2)
        p.dim('if_exists',[('none',''),('yes','IF EXISTS')]);p.dim('behavior',[('default',''),('restrict','RESTRICT')])
        p.ast=seq('DROP EXTENSION ',slot('if_exists'),' '+EXTENSION+' ',slot('behavior'))
        fx=p.fixture('owned_instance',[],[f'CREATE SCHEMA {EXTENSION_SCHEMA};',f'CREATE EXTENSION {EXTENSION} SCHEMA {EXTENSION_SCHEMA};'],
            [f'DROP EXTENSION IF EXISTS {EXTENSION} RESTRICT;',f'DROP SCHEMA {EXTENSION_SCHEMA};'])
        p.manifest('internal_finite',domain(p),[fx])
        p.scenario('dependencies',['members','restrict'],[],[dict(action='扩展组件清单和外部依赖需独立核验；不删除默认plpgsql，不生成CASCADE清理。')],
            [dict(kind='manual_assertion',expected='组件随扩展删除、外部依赖阻止RESTRICT尚待Oracle')])
    prefix='' if create else 'm_create_extension::'
    for key,values,refs in [('command_applicability',['m_internal_extension_tool_reviewed'],[p.fid('internal')]),
        ('extension_asset',['security_plugin_support_files_and_component_inventory_reviewed'],[prefix+'m_create_extension_fact_files']),
        ('enable_extension',['true'],[prefix+'m_create_extension_fact_enabled']),
        ('extension_schema_contract',['security_plugin_installable_in_m_extension_namespace'],[prefix+'m_create_extension_fact_schema']),
        ('extension_creator',['same_authorized_component_creator'],[prefix+'m_create_extension_fact_authority']),
        ('database_isolation',['disposable_database_security_plugin_absent_before_case'],[p.fid('internal')])]:gate(p,key,values,refs)
    if not create:gate(p,'extension_owner',['fixture_creator'],[p.fid('authority')])
    return p


def copy_stdout():
    p=Package('COPY','DML',CORPUS)
    p.fact('syntax','syntax','COPY表/列或括号查询结果到STDOUT；本批只导出真实INTEGER源表。','把一个表的数据复制到一个文件',9)
    p.fact('query','syntax','COPY query必须用圆括号包围SELECT或VALUES。','一个必须用圆括弧包围的SELECT或VALUES命令',1)
    p.fact('styles','constraint','括号option与原生copy_option语法不兼容，不能拼到同一目标中。','上述语法中copy_option与option语法不兼容',1)
    p.fact('formats','syntax','FORMAT支持CSV、TEXT、BINARY，缺省TEXT；当前不生成二进制流。','取值范围：CSV、TEXT、BINARY',1)
    p.fact('header','constraint','HEADER只能用于CSV；导出开启时需要fileheader，当前仅明确关闭的候选。','header只能用于CSV格式',5)
    p.fact('authority','environment','COPY TO需要源表SELECT权限；本批为源表创建者。','COPY TO需要读取的表的SELECT权限',2)
    p.fact('stream','environment','STDOUT打印标准输出，不需要服务端导出文件；未来运行器需COPY流协议支持。','声明输出打印到标准输出',1)
    p.fact('files','environment','文件路径需服务端可访问且受safe_data_path与enable_copy_server_files限制；当前不生成文件路径。','数据库管理员可以通过GUC参数safe_data_path',4)
    p.fact('generated','constraint','COPY列列表不能含生成列，未指定列表导出时也跳过生成列。','生成列不能出现在指定列的列表',3)
    p.fact('null_conflict','open_question','注意事项将\\N称为空字符串、option默认TEXT空值写\\n，而原生参数写\\N；当前无NULL输入，保留原文冲突。','COPY FROM中\\N为空字符串',1,'needs_verification')
    p.dim('target',[('table',''),('query','')]);p.dim('style',[('legacy',''),('options','')])
    p.dim('columns',[('all',''),('id','(id)'),('two','(id, qty)')])
    p.matrix_dim('projection',[(key,'',dict(items=cols,source_tables=[SRC],source_columns=cols,output_columns=cols,output_types=['INTEGER']*len(cols),output_column_count=len(cols),direct_columns=True))
        for key,cols in [('id',['id']),('two',['id','qty']),('reverse',['qty','id'])]],'query')
    p.dim('legacy',[('default',''),('csv','CSV'),('pipe',"DELIMITER '|'")])
    p.dim('with_keyword',[('none',''),('yes','WITH')])
    p.dim('options',[('text',"FORMAT 'text'"),('csv',"FORMAT 'csv'"),('text_pipe',"FORMAT 'text', DELIMITER '|'"),
        ('csv_pipe',"FORMAT 'csv', DELIMITER '|'"),('csv_noheader',"FORMAT 'csv', HEADER FALSE")],'formats')
    target=dict(kind='choice',selector='target',branches={p.vid('target','table'):seq(SRC+' ',slot('columns')),
        p.vid('target','query'):seq('(SELECT ',repeat('projection'),' FROM '+SRC+' ORDER BY id)')})
    options=dict(kind='choice',selector='style',branches={p.vid('style','legacy'):slot('legacy'),
        p.vid('style','options'):seq(slot('with_keyword'),' (',slot('options'),')')})
    p.ast=seq('COPY ',target,' TO STDOUT ',options)
    for target_name in ('table','query'):
        bindings=dict(target=[target_name]);bindings['columns' if target_name=='table' else 'projection']=['all','id','two'] if target_name=='table' else ['id','two','reverse']
        p.manifest(target_name+'_legacy',dict(bindings,style=['legacy'],legacy=['default','csv','pipe']),[BASE])
        p.manifest(target_name+'_options',dict(bindings,style=['options'],with_keyword=['none','yes'],options=['text','csv','text_pipe','csv_pipe','csv_noheader']),[BASE])
    gate(p,'table_authority',['fixture_table_creator'],[p.fid('authority')]);gate(p,'result_transport',['copy_out_stream_runner_required'],[p.fid('stream')])
    p.scenario('protocol_and_formats',['styles','header','generated','files'],[],[dict(action='验证COPY流与普通结果集分离；补STDIN载荷协议、文件生命周期、生成列排除及HEADER/fileheader关系后才扩域。')],
        [dict(kind='manual_assertion',expected='STDOUT候选非普通cursor.fetchall结果；实际字节与导入行为尚未验证')])
    return p


def checkpoint():
    p=Package('CHECKPOINT','UTILITY',CORPUS)
    p.fact('syntax','syntax','CHECKPOINT没有参数。','CHECKPOINT;',1)
    p.fact('authority','environment','只有系统管理员和运维管理员可调用CHECKPOINT。','只有系统管理员和运维管理员',1)
    p.fact('scope','environment','检查点涉及所有数据文件刷新，不能用Schema隔离其实例级副作用。','所有数据文件都在该点被更新',2)
    p.fact('effect','behavior_oracle','CHECKPOINT强制立即检查，而不是等待下次调度。','CHECKPOINT强制立即进行检查',1)
    p.dim('command',[('plain','CHECKPOINT')]);p.ast=seq(slot('command'));p.manifest('isolated_instance',domain(p),[BASE])
    gate(p,'actor_authority',['sysadmin_or_operations_admin'],[p.fid('authority')])
    gate(p,'instance_effect_scope',['disposable_instance_checkpoint_explicitly_reviewed'],[p.fid('scope')])
    p.scenario('wal',['effect','scope'],[BASE],[dict(action='在另行授权的独占可丢弃实例上确认WAL/脏页与检查点；DDL teardown不能撤销已发生的实例级刷新。')],
        [dict(kind='manual_assertion',expected='仅有限SQL生成，未执行CHECKPOINT或改检查点配置')])
    return p


def drop_owned():
    p=Package('DROP OWNED','DDL',CORPUS)
    p.fact('syntax','syntax','DROP OWNED BY角色列表，可选CASCADE/RESTRICT；本批仅缺省或RESTRICT。','DROP OWNED BY name',1)
    p.fact('scope','environment','会影响角色在当前数据库和共享对象上的权限，不能用作公共角色兜底清理。','所有该角色在当前数据库里和共享对象',2)
    p.fact('cascade','constraint','CASCADE可能递归删除其他用户拥有的依赖对象；本批禁止共享依赖与级联。','使用CASCADE选项可能导致',1)
    p.fact('shared_owned','behavior_oracle','角色拥有的数据库、表空间不会被移除。','角色所拥有的数据库、表空间',1)
    p.dim('roles',[('one','',dict(items=[ROLE_EXISTING])),('two','',dict(items=[ROLE_EXISTING,ROLE_SECOND]))])
    p.dim('behavior',[('default',''),('restrict','RESTRICT')]);p.ast=seq('DROP OWNED BY ',repeat('roles'),' ',slot('behavior'))
    ns='m_drop_owned_namespace';table=ns+'.source'
    fx=p.fixture('granted_objects',[(table,['id'])],[f'CREATE SCHEMA {ns};',f'CREATE TABLE {table} (id INTEGER);',f'INSERT INTO {table} VALUES (1);',
        f'GRANT USAGE ON SCHEMA {ns} TO {ROLE_EXISTING}, {ROLE_SECOND};',f'GRANT SELECT ON TABLE {table} TO {ROLE_EXISTING}, {ROLE_SECOND};'],
        [f'DROP TABLE {table};',f'DROP SCHEMA {ns};'],requires=[ROLE_SHARED])
    p.manifest('scoped_revocation',domain(p),[fx]);role_gates(p)
    gate(p,'drop_owned_target_isolation',['fresh_case_roles_no_external_ownership_or_grants'],[p.fid('scope')])
    p.scenario('effect',['scope','cascade','shared_owned'],[fx],[dict(action='仅在新建专用无登录角色上验证撤销真实表权限；所有权删除、跨库/共享对象及级联必须另审，不作为任何fixture cleanup。')],
        [dict(kind='manual_assertion',expected='本批只覆盖角色被授予的真实权限；更广所有权/共享对象行为未生成未执行')])
    return p


LOAD_PAYLOAD='1\t10\n2\t20\n3\t30\n'
LOAD_PATH='/tmp/m_factor_assets/load_data/two_int.tsv'


class LoadDataPackage(Package):
    def finish(self):
        files = super().finish()
        # This reviewed unit includes the following layout heading, not its
        # independent restrictions (which remain in the next unmapped unit).
        unit = next(u for u in files[self.id+'.source.yaml']['units']
                    if u['id'] == 'm_load_data_su_125')
        unit.update(statement='输入列列表可选；如果没有声明字段列表，将使用所有字段。', atomicity='atomic')
        return files


def load_data():
    p=LoadDataPackage('LOAD DATA','UTILITY',CORPUS)
    p.fact('syntax','syntax','LOAD DATA INFILE指定文件，INTO TABLE指定真实目标表；支持冲突模式和字段子句。',next(i+1 for i,line in enumerate(p.lines) if line.strip()=='LOAD DATA'),12)
    p.fact('columns','syntax','可指定输入列列表，SET指定表达式或DEFAULT。','[(col_name_or_user_var',2)
    p.fact('all_columns','constraint','输入列列表可省略；未声明字段列表时使用所有字段。有限空表两列输入由真实TSV与列序对齐，不套用SET或跳行行为。',125,4)
    p.facts[-1]['source_anchor'] = '2.4.2.13.1 L125-127'
    p.fact('authority','environment','LOAD DATA需要INSERT/DELETE；enable_copy_server_files打开时SYSADMIN可用文件导入。','LOAD DATA语法需要具有表的INSERT和DELETE权限',6)
    p.fact('path','environment','文件路径必须位于safe_data_path白名单内；本批只声明专用部署路径，不修改白名单。','数据库管理员可以通过GUC参数safe_data_path',4)
    p.fact('server','environment','未指定LOCAL从服务端导入；相对路径使用数据目录，本批只用绝对路径。','不指定LOCAL时，则从服务端所在环境中导入数据',2)
    p.fact('local','environment','LOCAL是否从客户端导入取决于enable_load_data_remote_transmission，并有单语句执行要求。','若指定LOCAL参数',11)
    p.fact('tab','syntax','字段分隔符缺省为TAB，可用FIELDS或COLUMNS的TERMINATED BY指定。','指定两列之间分隔符',1)
    p.fact('line','syntax','LINES TERMINATED BY指定行分隔，本批SQL字面值使用真实LF，不依赖反斜杠转义开关。','指定导入数据文件换行符样式',1)
    p.fact('no_column_expr','constraint','SET表达式不支持引用列名。','表达式中不支持列名',1)
    p.fact('assignment_type','constraint','SET结果必须可隐式赋值给对应列；本批仅INTEGER常量与目标列DEFAULT。','若表达式结果类型与被赋值列对应类型之间',1)
    p.fact('collision_error','constraint','非LOCAL且未指定REPLACE/IGNORE时，数据与既有行冲突会报错。','不指定LOCAL选项时，当导入数据与表中原有数据冲突时报错',2)
    p.fact('replace_ignore','behavior_oracle','REPLACE替换冲突行，IGNORE跳过；当前只准备真实冲突，不宣称行为已验证。','指定REPLACE选项',7)
    p.fact('format_match','constraint','导出/导入FIELDS、LINES、CHARACTER SET必须一致；不把COPY TO格式当作等价输入。','语句子句必须匹配',3)
    p.fact('skip','syntax','IGNORE number LINES/ROWS跳过输入前若干行。','指定数据导入时，跳过数据文件的前 number行',1)
    fixtures=[]
    for suffix in ('empty','conflict'):
        table='m_load_data_'+suffix
        setup=[f'CREATE TABLE {table} (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);']
        if suffix=='conflict':setup.append(f'INSERT INTO {table} VALUES (2,99);')
        fx=p.fixture(suffix,[(table,['id','qty'])],setup,[f'DROP TABLE {table};']);fixtures.append(fx)
        p.files['fixtures/'+suffix+'.fixture.yaml']['provides']['tables'][0]['columns'][0]['nullable']=False
        p.files['fixtures/'+suffix+'.fixture.yaml']['provides']['files']=[dict(id='two_int',source_path='assets/two_int.tsv',
            sha256=hashlib.sha256(LOAD_PAYLOAD.encode()).hexdigest(),target_path=LOAD_PATH,format='integer_tsv',column_count=2,row_count=3,
            deployment='manual_copy_and_verify',cleanup='remove_only_owned_deployed_file_after_hash_check',fact_refs=[p.fid('server'),p.fid('tab'),p.fid('line')])]
    p.dim('table',[('empty','m_load_data_empty'),('conflict','m_load_data_conflict')])
    for c,fx in zip(p.dims['table']['classes'],fixtures):c['values'][0]['fixture_refs']=[fx]
    p.dim('conflict_mode',[('none',''),('replace','REPLACE'),('ignore','IGNORE')])
    p.dim('fields',[('default',''),('fields',"FIELDS TERMINATED BY '\t'"),('columns',"COLUMNS TERMINATED BY '\t'")],'tab')
    p.dim('column_list',[('default',''),('explicit','(id, qty)')],'columns')
    p.dim('skip',[('none',''),('one','IGNORE 1 LINES')],'skip')
    p.dim('assignment',[('none',''),('default','SET qty = DEFAULT'),('integer','SET qty = 40'),('column','SET qty = id')],'columns')
    p.dims['assignment']['classes'][-1]['values'][0].update(validity='invalid',fact_refs=[p.fid('no_column_expr')])
    p.rule('no_column_expr',f"assignment != '{p.vid('assignment','column')}'",'no_column_expr')
    p.rule('collision_error',f"table != '{p.vid('table','conflict')}' or conflict_mode != '{p.vid('conflict_mode','none')}'",'collision_error')
    p.ast=seq("LOAD DATA INFILE '"+LOAD_PATH+"' ",slot('conflict_mode'),' INTO TABLE ',slot('table'),
        ' ',slot('fields')," LINES TERMINATED BY '\n' ",slot('skip'),' ',slot('column_list'),' ',slot('assignment'))
    for table,modes in [('empty',['none','replace','ignore']),('conflict',['replace','ignore'])]:
        p.manifest(table,dict(table=[table],conflict_mode=modes,fields=['default','fields','columns'],column_list=['default','explicit'],skip=['none','one'],assignment=['none','default','integer']),[])
    p.manifest('duplicate_negative',dict(table=['conflict'],conflict_mode=['none']),[],negative='collision_error')
    p.manifest('column_expr_negative',dict(table=['empty'],assignment=['column']),[],negative='no_column_expr')
    gate(p,'actor_authority',['sysadmin'],[p.fid('authority')]);gate(p,'enable_copy_server_files',['on'],[p.fid('authority')])
    gate(p,'server_file_access',['deployed_hash_verified_and_allowlisted'],[p.fid('path'),p.fid('server')])
    p.scenario('results',['replace_ignore','assignment_type','format_match'],[],[dict(action='校准3行真实TSV导入、已存在id=2的替换/忽略、qty DEFAULT=9和常量40，错误只匹配目标规则；文件部署与SQL成功不同阶段。')],
        [dict(kind='manual_assertion',expected='实际行值、冲突、SQLSTATE与文件部署尚未实机验证')])
    p.scenario('local_protocol',['local'],[],[dict(action='另审LOCAL远程传输开关、客户端路径及单语句协议，当前只生成服务端INFILE分支。')],
        [dict(kind='manual_assertion',expected='LOCAL、分区、用户变量、特殊字符与类型转换边界尚未建模')])
    p.syntax_fact_refs = [p.fid(x) for x in ('syntax','columns','tab','line','skip')]
    p.scenario('plain_rows',['mode','authority','path','server','tab','line','all_columns'],[fixtures[0]],
        [dict(id='load_plain',candidate=dict(manifest_ref='manifest_m_load_data_empty',params={
            key:p.vid(key,value) for key,value in [('table','empty'),('conflict_mode','none'),
            ('fields','default'),('column_list','default'),('skip','none'),('assignment','none')]}))],
        [dict(kind='result_set',step_id='load_plain',sql='SELECT id,qty FROM m_load_data_empty ORDER BY id;',
              expected=[[1,10],[2,20],[3,30]])])
    p.files['scenarios/plain_rows.scenario.yaml'].update(
        name='M非LOCAL空表两列三行输入',
        description='唯一选择已生成的无冲突修饰/无SET/不跳行候选。使用缺省TAB与真实LF，省略列列表对应全部两列；不承诺LOCAL或冲突处理行为。',
        preconditions=['已授权并核实的物理M数据库连接，SYSADMIN、enable_copy_server_files=on，具有目标表INSERT/DELETE权限。',
            '独占新表与服务器专属部署路径；文件未部署，先取得路径不存在、服务器身份、SHA256、读取权限、safe_data_path白名单与部署归属回执。'],
        execution_requirements=['database_authorization','isolated_connection','explicit_file_deployment',
                                'target_only_oracle','owned_asset_cleanup'])
    return p


def clean_connection():
    p=Package('CLEAN CONNECTION','UTILITY',CORPUS);env=MEnvironment();user='m_clean_connection_user'
    p.fact('syntax','syntax','M CLEAN CONNECTION仅TO ALL，可选CHECK/FORCE及数据库、用户过滤。',next(i+1 for i,line in enumerate(p.lines) if line.strip()=='CLEAN CONNECTION'),4)
    p.fact('nodes','constraint','M不支持指定节点，仅TO ALL。','M-Compatibility下不支持指定节点',1)
    p.fact('scope','environment','不指定dbname或username会扩大到全部数据库或全部用户，当前两个过滤均必需。','如果不指定，则删除所有数据库的连接',6)
    p.fact('check','behavior_oracle','CHECK发现其他会话连接访问时会报错；不能把CHECK等同于无副作用查询。','仅在节点列表为TO ALL时可以指定。如果指定该参数，会在清理连接之前检查数',3)
    p.fact('force','lifecycle','FORCE向匹配线程发送SIGTERM；本批不生成FORCE或终止其他连接。','所有和指定dbname和',2)
    p.fact('mapping','open_question','本章示例在M会话中CREATE DATABASE后按物理datname连接，与M命名空间语义需专项核验；当前绑定独立M建库计划物理名，不复制示例建库。','--创建数据库test_clean_connection',2,'needs_verification')
    p.dim('check',[('none',''),('yes','CHECK')]);p.ast=seq('CLEAN CONNECTION TO ALL ',slot('check'),' FOR DATABASE '+env.database+' TO USER '+user)
    fx=p.fixture('no_target_sessions',[],[guard(f"current_database() = '{env.database}'",'clean_physical_database_verified'),
        f'CREATE USER {user} NOLOGIN NOSYSADMIN PASSWORD DISABLE;'],[f'DROP SCHEMA {user};',f'DROP USER {user} RESTRICT;'])
    p.manifest('no_target_sessions',domain(p),[fx]);role_gates(p)
    gate(p,'connection_scope',['dedicated_physical_m_database_and_new_no_login_user_no_other_sessions'],[p.fid('scope')])
    p.scenario('sessions',['nodes','check','force'],[],[dict(action='当前仅无目标用户会话的语法候选，不声称成功清理连接；有目标会话、CHECK冲突和FORCE终止必须另行授权多会话运行器。')],
        [dict(kind='manual_assertion',expected='节点限制与活动会话/终止行为未执行，不能据空会话结果宣称清理功能覆盖')])
    p.files['scenarios/sessions.scenario.yaml']['fact_refs'].append('m_create_user::m_create_user_fact_schema')
    return p


BUILDERS=dict(analyze=analyze,vacuum=vacuum,reindex=reindex,lock=lock,select_into=select_into,
              create_resource_label=lambda:resource_label('CREATE RESOURCE LABEL'),
              alter_resource_label=lambda:resource_label('ALTER RESOURCE LABEL'),
              drop_resource_label=lambda:resource_label('DROP RESOURCE LABEL'),
              create_audit_policy=lambda:audit_policy('CREATE AUDIT POLICY'),
              alter_audit_policy=lambda:audit_policy('ALTER AUDIT POLICY'),
              drop_audit_policy=lambda:audit_policy('DROP AUDIT POLICY'),
              alter_default_privileges=default_privileges,
              create_extension=lambda:extension('CREATE EXTENSION'),
              alter_extension=lambda:extension('ALTER EXTENSION'),
              drop_extension=lambda:extension('DROP EXTENSION'),copy=copy_stdout,checkpoint=checkpoint,drop_owned=drop_owned,
              load_data=load_data,clean_connection=clean_connection)


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--update',action='store_true');args=parser.parse_args()
    out=[]
    for builder in BUILDERS.values():
        p=builder()
        artifacts=p.finish()
        if p.id=='m_load_data':artifacts['fixtures/assets/two_int.tsv']=LOAD_PAYLOAD
        for name,obj in artifacts.items():
            path=ROOT/'specs'/p.category.lower()/p.id/name
            content=obj if isinstance(obj,str) else yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110)
            if path.exists():
                if not args.update:raise FileExistsError(path)
                old=path.read_text()
                if old==content:continue
                out.append('*** Update File: '+str(path))
                out.extend('@@' if l.startswith('@@') else l for l in list(difflib.unified_diff(old.splitlines(),content.splitlines(),
                    n=max(len(old.splitlines()),len(content.splitlines())),lineterm=''))[2:])
            else:out.append('*** Add File: '+str(path));out.extend('+'+l for l in content.splitlines())
    print('\n'.join(['*** Begin Patch']+out+['*** End Patch']))


if __name__=='__main__':main()
