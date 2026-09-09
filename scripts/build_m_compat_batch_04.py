#!/usr/bin/env python3
"""Curated fourth M batch; emits reviewable patches and never executes SQL."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import sys
import yaml

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from scripts.build_m_compat_pilot import Package,BASE,SRC,seq,slot,repeat

CORPUS=ROOT/'work/m_compat_batch_04/corpus'
CHARSET_CORPUS=ROOT/'work/m_compat_batch_04_charset/corpus'
LIBRARY_CORPUS=ROOT/'work/m_compat_batch_04_dependencies/corpus'


def domain(p):
    return {k:[v['values'][0]['id'].removeprefix(p.id+'_'+k+'_') for v in d['classes']]
            for k,d in p.dims.items()}


def gate(p,key,values,refs):
    for obj in p.files.values():
        if obj['kind']=='manifest':obj['environment_requirements'].append(dict(key=key,allowed_values=values,fact_refs=refs))


def alter_namespace(command):
    p=Package(command,'DDL',CORPUS)
    p.fact('syntax','syntax','M ALTER DATABASE/SCHEMA 修改命名空间字符集、字符序；不是物理数据库参数。','ALTER {DATABASE | SCHEMA}',8)
    p.fact('namespace','environment','DATABASE 与 SCHEMA 在 M 中为同义词。','M-Compatibility中DATABASE和SCHEMA',2)
    p.fact('authority','environment','修改属性需要命名空间所有者或 ALTER 权限；本批限定 case 所有者并有当前库 CREATE 权限。','只有模式的所有者',4)
    p.fact('owner','environment','转移所有者另需当前用户为新所有者角色成员。','者，当前用户必须' if command=='ALTER DATABASE' else '或者系统管理员，且该用户',2)
    p.fact('description_conflict','open_question','本章 COLLATE/CHARSET 的字符集/字符分类描述混用；以本 PDF 2.3、2.3.2 关联表解释，保留本章术语差异。','可选。指定数据库（模式）使用的字符集',3,'needs_verification')
    if command=='ALTER DATABASE':
        p.fact('charset_domain','syntax','补充来源 2.3 表2-2/2-3：utf8 与 utf8mb4 同一字符集；utf8_bin/utf8mb4_bin 对应该字符集，gbk_chinese_ci 对应 gbk。','取值范围：请参见库级字符集和字符序',1)
        p.fact('charset_pair','constraint','补充来源 2.3.2：同时指定 charset 和 collation 必须对应，否则报错。','取值范围：请参见库级字符集和字符序',1)
        p.fact('encoding','environment','补充来源 2.3.2：SQL_ASCII 物理库不支持多字符集混用；本批限定 UTF8 物理库。','取值范围：请参见库级字符集和字符序',1)
        p.exports=[p.fid(x) for x in ('charset_domain','charset_pair','encoding')]
        value_ref=p.fid('charset_domain');rule_ref=p.fid('charset_pair');encoding_ref=p.fid('encoding')
    else:
        value_ref='m_alter_database::m_alter_database_fact_charset_domain'
        rule_ref='m_alter_database::m_alter_database_fact_charset_pair'
        encoding_ref='m_alter_database::m_alter_database_fact_encoding'
    p.dim('form',[('charset',''),('collation',''),('combined','')])
    p.dim('keyword',[('database','DATABASE'),('schema','SCHEMA')])
    p.dim('default',[('none',''),('yes','DEFAULT')])
    p.dim('equals',[('none',''),('yes','=')])
    p.dim('charset_keyword',[('long','CHARACTER SET'),('split','CHAR SET'),('short','CHARSET')])
    p.dim('charset',[('utf8','utf8'),('utf8mb4','utf8mb4'),('gbk','gbk')])
    p.dim('collation',[('utf8','utf8_bin'),('utf8mb4','utf8mb4_bin'),('gbk','gbk_chinese_ci')])
    for dim in ('charset','collation'):
        for cls in p.dims[dim]['classes']:cls['values'][0]['fact_refs']=[value_ref]
    match=(f"(charset in ['{p.vid('charset','utf8')}', '{p.vid('charset','utf8mb4')}'] and "
           f"collation in ['{p.vid('collation','utf8')}', '{p.vid('collation','utf8mb4')}']) or "
           f"(charset == '{p.vid('charset','gbk')}' and collation == '{p.vid('collation','gbk')}')")
    p.rules.append(dict(id=p.id+'_rule_charset_pair',kind='requires',expression=
        f"form != '{p.vid('form','combined')}' or ({match})",fact_refs=[rule_ref],severity='error'))
    target=p.id+'_namespace'
    charset=seq(slot('default'),' ',slot('charset_keyword'),' ',slot('equals'),' ',slot('charset'))
    collation=seq(slot('default'),' COLLATE ',slot('equals'),' ',slot('collation'))
    p.ast=seq('ALTER ',slot('keyword'),' '+target+' ',dict(kind='choice',selector='form',branches={
        p.vid('form','charset'):charset,p.vid('form','collation'):collation,
        p.vid('form','combined'):seq(charset,' ',collation)}))
    fx=p.fixture('owned_namespace',[],[f'CREATE SCHEMA {target} CHARSET utf8;'],[f'DROP SCHEMA {target};'])
    p.manifest('charset',dict(form=['charset'],keyword=['database','schema'],default=['none','yes'],
        equals=['none','yes'],charset_keyword=['long','split','short'],charset=['utf8','utf8mb4','gbk']),[fx])
    p.manifest('collation',dict(form=['collation'],keyword=['database','schema'],default=['none','yes'],
        equals=['none','yes'],collation=['utf8','utf8mb4','gbk']),[fx])
    p.manifest('combined',dict(form=['combined'],keyword=['database','schema'],default=['none','yes'],
        equals=['none','yes'],charset_keyword=['short'],charset=['utf8','utf8mb4','gbk'],collation=['utf8','utf8mb4','gbk']),[fx])
    p.manifest('mismatch',dict(form=['combined'],keyword=['database'],charset_keyword=['short'],
        charset=['utf8'],collation=['gbk']),[fx],negative='charset_pair')
    gate(p,'object_authority',['case_namespace_owner_with_create'],[p.fid('authority')])
    gate(p,'server_encoding',['UTF8'],[encoding_ref])
    for obj in p.files.values():
        if obj['kind']=='manifest':obj['environment_requirements'][0]['fact_refs'].append(p.fid('namespace'))
    p.scenario('owner_transfer',['owner'],[],[dict(action='另建 case 专用角色与成员关系后测试 OWNER TO，先删自身命名空间再删角色，不操作系统模式。')],
        [dict(kind='manual_assertion',expected='所有者身份与权限变化需独立校准，本批字符集清单不声称已覆盖')])
    return p


def alter_view():
    p=Package('ALTER VIEW','DDL',CORPUS)
    p.fact('syntax','syntax','ALTER VIEW 默认值、重命名、模式移动、定义与 COMPILE 是不同产生式。','ALTER VIEW [ IF EXISTS ] view_name',30)
    p.fact('authority','environment','执行 ALTER VIEW 需要视图所有者或 ALTER 权限。','只有视图的所有者',3)
    p.fact('move_authority','environment','移动视图需要所有者身份及新模式 CREATE 权限。','修改视图的模式',2)
    p.fact('defaults_noop','behavior_oracle','本章明确 SET/DROP DEFAULT 暂无实际意义，不能据此推导 INSERT DEFAULT 生效。','设置或删除一个列的缺省值',1)
    p.fact('definition','syntax','AS query 修改定义等价 CREATE OR REPLACE VIEW；支持检查选项。','ALTER VIEW view_name [ (',2)
    p.fact('check','behavior_oracle','CHECK OPTION 缺省 CASCADED，LOCAL 与 CASCADED 的下层检查范围不同。','设置控制更新视图的行为',5)
    p.fact('compile','lifecycle','COMPILE 手工重编译；失效流程需补开发指南前置条件。','使用这个选项，对视图',5)
    p.fact('missing','behavior_oracle','IF EXISTS 遇到不存在视图只提示，不产生错误。','使用这个选项，如果视图不存在',1)
    p.exports=[p.fid('defaults_noop')]
    v='m_alter_view_target';renamed='m_alter_view_renamed';ns='m_alter_view_destination'
    p.dim('form',[('default',''),('rename',''),('move',''),('definition',''),('compile','')])
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('column_keyword',[('none',''),('yes','COLUMN')])
    p.dim('default_change',[('set','SET DEFAULT 7'),('drop','DROP DEFAULT')])
    p.dim('columns',[('implicit',''),('explicit','(id,qty)')],'definition')
    p.matrix_dim('query', [('plain',f'SELECT id,qty FROM {SRC}',dict(source_tables=[SRC],source_columns=['id','qty'],output_column_count=2,output_types=['INTEGER','INTEGER'])),
        ('filter',f'SELECT id,qty FROM {SRC} WHERE id > 1',dict(source_tables=[SRC],source_columns=['id','qty'],output_column_count=2,output_types=['INTEGER','INTEGER']))],'definition')
    p.dim('check',[('none',''),('default','WITH CHECK OPTION'),('local','WITH LOCAL CHECK OPTION'),('cascaded','WITH CASCADED CHECK OPTION')],'definition')
    prefix=seq('ALTER VIEW ',slot('if_exists'),' '+v+' ')
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','default'):seq(prefix,'ALTER ',slot('column_keyword'),' id ',slot('default_change')),
        p.vid('form','rename'):seq(prefix,'RENAME TO '+renamed),
        p.vid('form','move'):seq(prefix,'SET SCHEMA '+ns),
        p.vid('form','definition'):seq('ALTER VIEW '+v+' ',slot('columns'),' AS ',slot('query'),' ',slot('check')),
        p.vid('form','compile'):seq('ALTER VIEW '+v+' COMPILE')})
    fx=p.fixture('view',[],[f'CREATE VIEW {v} AS SELECT id,qty FROM {SRC};'],
        [f'DROP VIEW IF EXISTS {renamed};',f'DROP VIEW IF EXISTS {v};'],requires=[BASE])
    moved=p.fixture('moved_view',[],[f'CREATE SCHEMA {ns};',f'CREATE VIEW {v} AS SELECT id,qty FROM {SRC};'],
        [f'DROP VIEW IF EXISTS {ns}.{v};',f'DROP VIEW IF EXISTS {v};',f'DROP SCHEMA {ns};'],requires=[BASE])
    p.manifest('defaults',dict(form=['default'],if_exists=['none','yes'],column_keyword=['none','yes'],default_change=['set','drop']),[fx])
    p.manifest('rename',dict(form=['rename'],if_exists=['none','yes']),[fx])
    p.manifest('move',dict(form=['move'],if_exists=['none','yes']),[moved])
    p.manifest('definition',dict(form=['definition'],columns=['implicit','explicit'],query=['plain','filter'],check=['none','default','local','cascaded']),[fx])
    p.manifest('compile_valid',dict(form=['compile']),[fx])
    gate(p,'object_authority',['case_view_owner'],[p.fid('authority')])
    p.files['manifests/move.manifest.yaml']['environment_requirements'].append(dict(key='destination_schema_authority',
        allowed_values=['case_owner_with_create'],fact_refs=[p.fid('move_authority')]))
    p.scenario('defaults_and_check',['defaults_noop','check'],[fx],
        [dict(action='独立验证 DEFAULT 的无实际意义和 CHECK OPTION DML 拒绝，不能从 ALTER 成功推导赋值行为。')],
        [dict(kind='manual_assertion',expected='保留与共享 DEFAULT 列合同之间的模式/命令边界；行为未执行')])
    p.scenario('invalid_compile',['compile'],[],[dict(action='补齐 enable_view_invalidation 的环境来源和删除依赖/补依赖/COMPILE 生命周期')],
        [dict(kind='manual_assertion',expected='当前 COMPILE 仅针对已有效视图；不等价失效重编译验证')])
    p.scenario('missing_notice',['missing'],[],[dict(sql='ALTER VIEW IF EXISTS m_alter_view_absent RENAME TO m_alter_view_unused;')],
        [dict(kind='manual_assertion',expected='成功并提示；目标身份与 notice 待校准')])
    return p


def alter_session():
    p=Package('ALTER SESSION','DDL',CORPUS)
    p.fact('syntax','syntax','ALTER SESSION 支持 SET TRANSACTION 与其他运行时参数分支。','ALTER SESSION SET TRANSACTION',14)
    p.fact('session','environment','参数修改影响当前会话，直到连接断开。','ALTER SESSION命令用于定义',2)
    p.fact('transaction','environment','事务参数前须 START TRANSACTION，否则隐式事务立即结束，看不到效果。','如果执行SET TRANSACTION之前',2)
    p.fact('timezone','syntax','时区取有效本地时区，文档给出 PRC 缺省。','用于指定当前会话的本地时区',3)
    p.fact('from_current','syntax','FROM CURRENT 取当前会话参数值。','取当前会话中的值',1)
    p.fact('alias','behavior_oracle','READ UNCOMMITTED 行为同 READ COMMITTED。','–   READ UNCOMMITTED',2)
    p.fact('schema_conflict','open_question','语法写 CURRENT_SCHEMA schema，示例含 TO；此分支不推断关键字可省略。','ALTER SESSION SET CURRENT_SCHEMA TO',1,'needs_verification')
    p.fact('transaction_braces','open_question','事务语法右花括号不配平；本批仅生成明确独立特性，不复制额外括号。','SERIALIZABLE} }',1,'needs_verification')
    p.dim('form',[('timezone',''),('parameter',''),('transaction','')])
    p.dim('timezone',[('prc',"'PRC'"),('default','DEFAULT')],'timezone')
    p.dim('parameter_change',[('set','TO DEFAULT'),('equals','= DEFAULT'),('current','FROM CURRENT')])
    p.dims['parameter_change']['classes'][-1]['values'][0]['fact_refs']=[p.fid('from_current')]
    p.dim('characteristic',[('read','READ ONLY'),('write','READ WRITE'),('committed','ISOLATION LEVEL READ COMMITTED'),
        ('uncommitted','ISOLATION LEVEL READ UNCOMMITTED'),('repeatable','ISOLATION LEVEL REPEATABLE READ'),('serializable','ISOLATION LEVEL SERIALIZABLE')])
    p.ast=seq('ALTER SESSION SET ',dict(kind='choice',selector='form',branches={
        p.vid('form','timezone'):seq('TIME ZONE ',slot('timezone')),
        p.vid('form','parameter'):seq('TimeZone ',slot('parameter_change')),
        p.vid('form','transaction'):seq('TRANSACTION ',slot('characteristic'))}))
    fx=p.fixture('transaction',[],['START TRANSACTION;'],['ROLLBACK;'])
    p.files['fixtures/transaction.fixture.yaml']['execution']['note']='setup/目标/ROLLBACK 使用同一独占连接，在任何数据查询前设置事务特性；case 结束关闭连接恢复会话边界，不承诺所有参数可回滚。'
    p.manifest('timezone',dict(form=['timezone'],timezone=['prc','default']),[fx])
    p.manifest('parameter',dict(form=['parameter'],parameter_change=['set','equals','current']),[fx])
    p.manifest('transaction',dict(form=['transaction'],characteristic=['read','write','committed','uncommitted','repeatable','serializable']),[fx])
    gate(p,'session_lifecycle',['isolated_connection'],[p.fid('session')])
    p.files['manifests/transaction.manifest.yaml']['environment_requirements'].append(dict(key='transaction_stage',
        allowed_values=['before_first_data_statement'],fact_refs=[p.fid('transaction')]))
    p.scenario('uncommitted_alias',['alias'],[fx],[dict(action='通过独立会话未提交数据验证隔离级别别名，不由语法接受推导脏读')],
        [dict(kind='manual_assertion',expected='READ UNCOMMITTED 行为同 READ COMMITTED；未执行')])
    return p


ROLE_PARENT='m_b04_role_parent'
ROLE_EXISTING='m_b04_role_existing'
ROLE_SECOND='m_b04_role_second'
ROLE_SHARED='fixture_m_create_role_existing'


def role_gates(p):
    prefix='' if p.id=='m_create_role' else 'm_create_role::'
    gate(p,'actor_authority',['sysadmin'],[prefix+'m_create_role_fact_disable_authority'])
    gate(p,'separation_of_duties',['off'],[prefix+'m_create_role_fact_creation_authority'])


def role_dependency(p):
    fid='fixture_'+p.id+'_shared_roles'
    p.files['fixtures/shared_roles.fixture.yaml']=p.entity('fixture',fid,requires_fixture_refs=[ROLE_SHARED],
        provides=dict(tables=[]),seed=dict(required=False,rows=[]),execution=dict(status='ready',mode='auto',
        note='依赖 CREATE ROLE 包的真实无登录角色；只允许本 case 创建的角色，不执行 DROP OWNED 或清理任何共享身份。'))
    p.fixtures.append(fid)
    return fid


def create_role():
    p=Package('CREATE ROLE','DDL',CORPUS)
    p.fact('syntax','syntax','CREATE ROLE 可选 WITH/角色选项；PASSWORD 或 IDENTIFIED BY 分支必需，可指定 DISABLE。','CREATE ROLE role_name',2)
    p.fact('disable_authority','environment','只有管理员能禁用密码；本批仅构造无登录、禁用密码的专用角色。','能通过外部认证来连接数据库',2)
    p.fact('creation_authority','environment','三权分立关闭时 SYSADMIN 可创建普通角色；开启时 SYSADMIN 无权创建用户。','三权分立关闭时，具有SYSADMIN',4)
    p.fact('connection_range','constraint','CONNECTION LIMIT 范围为 -1 至 2^31-1，-1 为无限制。','取值范围：[-1, 2^31-1]',1)
    p.fact('membership','syntax','IN ROLE 关联一个或多个已存在角色；IN GROUP 是旧拼法。','新角色立即拥有IN ROLE子句',4)
    p.fact('no_login','behavior_oracle','新角色缺省 NOLOGIN；只有 LOGIN 属性才可登录。','具有LOGIN属性的角色才可以登录',3)
    p.fact('name_limit','syntax','未引用角色名折为小写，最多63字符；本批固定安全短标识符。','若角色名称超过63个字符',3)
    p.fact('reserved','behavior_oracle','DEFAULT TABLESPACE 与 PROFILE 被忽略，不据此宣称有配置效果。','DEFAULT TABLESPACE子句将被忽略',4)
    p.exports=[p.fid(x) for x in ('disable_authority','creation_authority','connection_range','membership','name_limit')]
    p.dim('with_keyword',[('none',''),('yes','WITH')])
    p.dim('password_keyword',[('password','PASSWORD'),('identified','IDENTIFIED BY')])
    p.dim('membership_keyword',[('role','IN ROLE'),('group','IN GROUP')],'membership')
    p.dim('connection_limit',[('default',''),('unlimited','CONNECTION LIMIT -1'),('zero','CONNECTION LIMIT 0'),
        ('one','CONNECTION LIMIT 1'),('max','CONNECTION LIMIT 2147483647'),('below','CONNECTION LIMIT -2')],'connection_range')
    p.dims['connection_limit']['classes'][-1]['values'][0]['validity']='invalid'
    p.rule('connection_range',f"connection_limit != '{p.vid('connection_limit','below')}'",'connection_range')
    target='m_create_role_new'
    p.dim('name',[('plain',target)],'name_limit')
    p.ast=seq('CREATE ROLE ',slot('name'),' ',slot('with_keyword'),' NOLOGIN NOSYSADMIN NOCREATEDB NOCREATEROLE ',
        slot('membership_keyword'),' '+ROLE_PARENT+' ',slot('connection_limit'),' ',slot('password_keyword'),' DISABLE')
    parent=p.fixture('parent',[],[f'CREATE ROLE {ROLE_PARENT} NOLOGIN NOSYSADMIN PASSWORD DISABLE;'],
        [f'DROP ROLE IF EXISTS {target};',f'DROP ROLE {ROLE_PARENT};'])
    fx='fixture_'+p.id+'_new_lifecycle'
    # Dependency-only wrapper; the explicit parent lifecycle owns target cleanup.
    p.files['fixtures/new_lifecycle.fixture.yaml']=p.entity('fixture',fx,requires_fixture_refs=[parent],provides=dict(tables=[]),
        seed=dict(required=False,rows=[]),execution=dict(status='ready',mode='auto',
        note='目标名和父角色名预先不存在，逐 case 串行；仅删除成功创建的目标，随后逆序删除父角色。负向不以任何非目标错误通过。'))
    p.fixtures.append(fx)
    values=domain(p);values['connection_limit'].remove('below')
    p.manifest('finite',values,[fx])
    p.manifest('connection_below',dict(connection_limit=['below']),[fx],negative='connection_range')
    p.fixture('existing',[],[f'CREATE ROLE {ROLE_EXISTING} NOLOGIN NOSYSADMIN PASSWORD DISABLE;',
        f'CREATE ROLE {ROLE_SECOND} NOLOGIN NOSYSADMIN PASSWORD DISABLE;'],
        [f'DROP ROLE IF EXISTS {ROLE_SECOND};',f'DROP ROLE IF EXISTS {ROLE_EXISTING};'])
    role_gates(p)
    p.scenario('membership_and_login',['membership','no_login'],[fx],[dict(action='创建目标后检查 pg_roles.rolcanlogin 与成员关系；不尝试连接禁用登录的角色。')],
        [dict(kind='manual_assertion',expected='NOLOGIN 生效且属于指定父角色，目标 Oracle 尚未执行')])
    p.scenario('reserved_options',['reserved'],[],[dict(action='另建忽略 PROFILE/DEFAULT TABLESPACE 的对照，不从语法接受推断配置成功')],
        [dict(kind='manual_assertion',expected='保留选项被忽略的文档行为；无运行验证')])
    return p


def alter_role():
    p=Package('ALTER ROLE','DDL',CORPUS)
    p.fact('syntax','syntax','角色选项、RENAME、SET 参数和 RESET ALL 是不同产生式。','ALTER ROLE role_name [ [ WITH ]',1)
    p.fact('rename','syntax','支持 RENAME TO 新角色名。','RENAME TO new_name',1)
    p.fact('settings','syntax','SET 参数允许 TO/= DEFAULT 或 FROM CURRENT；RESET 只列 ALL。','SET configuration_parameter {{ TO',6)
    p.fact('account','syntax','ACCOUNT LOCK/UNLOCK 是账户状态选项。','ACCOUNT { LOCK | UNLOCK }',1)
    p.fact('next_session','lifecycle','ALTER ROLE 配置只在该角色下一次新会话生效。','设置角色的参数。ALTER ROLE中修改',2)
    p.fact('locked','behavior_oracle','ACCOUNT LOCK 禁止登录，UNLOCK 解除账户锁定；不等于赋予 LOGIN 属性。','ACCOUNT LOCK：锁定账户',2)
    p.fact('pguser','constraint','当前版本不允许修改 PGUSER 属性。','当前版本不允许修改角色的PGUSER',1)
    p.fact('pdb','environment','PDB 内不支持修改初始用户密码；本批不碰初始用户或明文密码。','不支持在PDB内修改初始用户密码',1)
    p.fact('database_scope','open_question','IN DATABASE 在 M 角色设置中的物理库/Schema 绑定需独立核验，本批省略。','表示修改角色在指定数据库上的参数',1,'needs_verification')
    p.dim('form',[('options',''),('rename',''),('set',''),('reset','')])
    p.dim('with_keyword',[('none',''),('yes','WITH')])
    p.dim('option',[('no_login','NOLOGIN'),('no_createdb','NOCREATEDB'),('no_createrole','NOCREATEROLE'),
        ('one','CONNECTION LIMIT 1'),('below','CONNECTION LIMIT -2'),('lock','ACCOUNT LOCK'),('unlock','ACCOUNT UNLOCK'),
        ('disable','PASSWORD DISABLE'),('identified_disable','IDENTIFIED BY DISABLE')])
    p.dims['option']['classes'][4]['values'][0].update(validity='invalid',fact_refs=['m_create_role::m_create_role_fact_connection_range'])
    p.rules.append(dict(id=p.id+'_rule_connection_range',kind='requires',expression=
        f"option != '{p.vid('option','below')}'",fact_refs=['m_create_role::m_create_role_fact_connection_range'],severity='error'))
    for i in (5,6):p.dims['option']['classes'][i]['values'][0]['fact_refs']=[p.fid('account')]
    p.dim('parameter_change',[('default','TO DEFAULT'),('equals','= DEFAULT'),('current','FROM CURRENT')],'settings')
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','options'):seq('ALTER ROLE '+ROLE_EXISTING+' ',slot('with_keyword'),' ',slot('option')),
        p.vid('form','rename'):seq('ALTER ROLE m_alter_role_before RENAME TO m_alter_role_renamed'),
        p.vid('form','set'):seq('ALTER ROLE '+ROLE_EXISTING+' SET TimeZone ',slot('parameter_change')),
        p.vid('form','reset'):seq('ALTER ROLE '+ROLE_EXISTING+' RESET ALL')})
    fx=role_dependency(p)
    rename_fx=p.fixture('rename',[],['CREATE ROLE m_alter_role_before NOLOGIN NOSYSADMIN PASSWORD DISABLE;'],
        ['DROP ROLE IF EXISTS m_alter_role_renamed;','DROP ROLE IF EXISTS m_alter_role_before;'])
    p.manifest('options',dict(form=['options'],with_keyword=['none','yes'],
        option=['no_login','no_createdb','no_createrole','one','lock','unlock','disable','identified_disable']),[fx])
    p.manifest('connection_below',dict(form=['options'],option=['below']),[fx],negative='connection_range')
    p.manifest('rename',dict(form=['rename']),[rename_fx]);p.manifest('set',dict(form=['set'],parameter_change=['default','equals','current']),[fx])
    p.manifest('reset',dict(form=['reset']),[fx]);role_gates(p)
    p.scenario('next_connection',['next_session','locked'],[fx],[dict(action='用额外有登录能力且获授权的隔离身份验证下次会话配置与锁定，不用本批 NOLOGIN 角色误测登录失败。')],
        [dict(kind='manual_assertion',expected='区分 NOLOGIN 与 ACCOUNT LOCK；连接和 Oracle 均未执行')])
    p.scenario('restricted_changes',['pguser','pdb'],[],[dict(action='PGUSER 变更目标错误需校准；初始用户/PDB 密码变化仅保留限制，不生成默认候选。')],
        [dict(kind='manual_assertion',expected='不触碰共享或初始身份，不通过环境错误倒推目标错误')])
    return p


def drop_role():
    p=Package('DROP ROLE','DDL',CORPUS)
    p.fact('syntax','syntax','DROP ROLE 允许 IF EXISTS 与多个角色名。','DROP ROLE [ IF EXISTS ]',1)
    p.fact('missing','behavior_oracle','IF EXISTS 遇到不存在角色发 NOTICE，不抛错误。','如果指定的角色不存在',1)
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('targets',[('one','',dict(items=[ROLE_EXISTING])),('two','',dict(items=[ROLE_EXISTING,ROLE_SECOND]))])
    p.ast=seq('DROP ROLE ',slot('if_exists'),' ',repeat('targets'))
    fx=role_dependency(p);p.manifest('finite',domain(p),[fx]);role_gates(p)
    p.scenario('missing_notice',['missing'],[],[dict(sql='DROP ROLE IF EXISTS m_drop_role_absent;')],
        [dict(kind='manual_assertion',expected='成功且 NOTICE；角色预先确认不存在，尚未执行')])
    return p


def create_group():
    p=Package('CREATE GROUP','DDL',CORPUS)
    p.fact('syntax','syntax','CREATE GROUP 是 CREATE ROLE 的非标准别名；密码分支必需，支持 DISABLE。','CREATE GROUP group_name',2)
    p.fact('alias','syntax','CREATE GROUP 等价于 CREATE ROLE，参数定义引用 CREATE ROLE。','CREATE GROUP是CREATE ROLE',2)
    p.fact('parameters','syntax','本章参数说明显式引用 CREATE ROLE，不复制其权限和连接范围。','请参见CREATE ROLE章节中的参数说明',1)
    p.dim('with_keyword',[('none',''),('yes','WITH')])
    p.dim('password_keyword',[('password','PASSWORD'),('identified','IDENTIFIED BY')])
    p.dim('inherit',[('yes','INHERIT'),('no','NOINHERIT')])
    p.dim('connection_limit',[('default',''),('zero','CONNECTION LIMIT 0'),('unlimited','CONNECTION LIMIT -1'),('below','CONNECTION LIMIT -2')])
    for cl in p.dims['connection_limit']['classes']:
        cl['values'][0]['fact_refs']=['m_create_role::m_create_role_fact_connection_range']
    p.dims['connection_limit']['classes'][-1]['values'][0]['validity']='invalid'
    p.rules.append(dict(id=p.id+'_rule_connection_range',kind='requires',expression=
        f"connection_limit != '{p.vid('connection_limit','below')}'",fact_refs=['m_create_role::m_create_role_fact_connection_range'],severity='error'))
    target='m_create_group_new';parent='m_create_group_parent'
    p.ast=seq('CREATE GROUP '+target+' ',slot('with_keyword'),' NOLOGIN NOSYSADMIN ',slot('inherit'),
        ' IN ROLE '+parent+' ',slot('connection_limit'),' ',slot('password_keyword'),' DISABLE')
    fx=p.fixture('parent',[],[f'CREATE ROLE {parent} NOLOGIN NOSYSADMIN PASSWORD DISABLE;'],
        [f'DROP ROLE IF EXISTS {target};',f'DROP ROLE {parent};'])
    values=domain(p);values['connection_limit'].remove('below')
    p.manifest('finite',values,[fx]);p.manifest('connection_below',dict(connection_limit=['below']),[fx],negative='connection_range')
    role_gates(p)
    return p


def alter_group():
    p=Package('ALTER GROUP','DDL',CORPUS)
    p.fact('syntax','syntax','ALTER GROUP 有 ADD USER、DROP USER 与 RENAME TO 三种产生式。','更改角色名称或者成员关系',1)
    p.fact('membership','behavior_oracle','ADD/DROP USER 等价于授予/回收成员关系，而非创建或删除成员角色。','其中ADD USER、DROP USER两个子句',3)
    p.fact('existing','environment','操作的组与成员必须是已存在的角色，本批由真实 fixture 提供初始状态。','现有角色名',6)
    p.fact('rename','syntax','RENAME TO 修改用户组名称。','RENAME TO new_name',1)
    p.dim('action',[('add','ADD USER'),('drop','DROP USER'),('rename','')])
    one='m_alter_group_member_one';two='m_alter_group_member_two';group='m_alter_group_existing'
    p.dim('members',[('one','',dict(items=[one])),('two','',dict(items=[one,two]))])
    member=seq('ALTER GROUP '+group+' ',slot('action'),' ',repeat('members'))
    p.ast=dict(kind='choice',selector='action',branches={p.vid('action','add'):member,p.vid('action','drop'):member,
        p.vid('action','rename'):seq('ALTER GROUP m_alter_group_before RENAME TO m_alter_group_after')})
    fxrefs=[]
    for action in ('add','drop'):
        membership=(' IN ROLE '+group) if action=='drop' else ''
        fx=p.fixture(action,[],[f'CREATE GROUP {group} NOLOGIN NOSYSADMIN PASSWORD DISABLE;']+
            [f'CREATE ROLE {name} NOLOGIN NOSYSADMIN{membership} PASSWORD DISABLE;' for name in (one,two)],
            [f'DROP ROLE IF EXISTS {name};' for name in (two,one,group)])
        fxrefs.append(fx)
        p.manifest(action,dict(action=[action],members=['one','two']),[fx])
    rename_fx=p.fixture('rename',[],['CREATE GROUP m_alter_group_before NOLOGIN NOSYSADMIN PASSWORD DISABLE;'],
        ['DROP ROLE IF EXISTS m_alter_group_after;','DROP ROLE IF EXISTS m_alter_group_before;'])
    p.manifest('rename',dict(action=['rename']),[rename_fx]);role_gates(p)
    gate(p,'group_member_state',['fixture_defined'],[p.fid('existing')])
    p.scenario('membership',['membership'],fxrefs,[dict(action='分别确认 ADD 前未入组、DROP 前已入组；执行后检查成员关系与成员角色仍存在。')],
        [dict(kind='manual_assertion',expected='只改变组成员关系，不删除成员；尚未执行')])
    return p


def drop_group():
    p=Package('DROP GROUP','DDL',CORPUS)
    p.fact('syntax','syntax','DROP GROUP 支持 IF EXISTS 与多个组名。','DROP GROUP [ IF EXISTS ]',1)
    p.fact('alias','syntax','DROP GROUP 是 DROP ROLE 的别名。','DROP GROUP是DROP ROLE',1)
    p.fact('management','environment','该命令是 M 管理工具封装接口，不建议用户直接使用，需管理接口场景审阅。','DROP GROUP是M-Compatibility管理工具',2)
    p.fact('missing','behavior_oracle','IF EXISTS 遇到不存在角色通知而不报错。','如果不存在该角色',1)
    one='m_drop_group_one';two='m_drop_group_two'
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('targets',[('one','',dict(items=[one])),('two','',dict(items=[one,two]))])
    p.ast=seq('DROP GROUP ',slot('if_exists'),' ',repeat('targets'))
    fx=p.fixture('groups',[],[f'CREATE GROUP {n} NOLOGIN NOSYSADMIN PASSWORD DISABLE;' for n in (one,two)],
        [f'DROP ROLE IF EXISTS {n};' for n in (two,one)])
    p.manifest('restricted_finite',domain(p),[fx]);role_gates(p)
    gate(p,'command_applicability',['m_management_tool_reviewed'],[p.fid('management')])
    p.scenario('missing_notice',['missing'],[],[dict(sql='DROP GROUP IF EXISTS m_drop_group_absent;')],
        [dict(kind='manual_assertion',expected='不存在目标的 NOTICE 需管理场景审阅后验证；不推导普通用户支持')])
    return p


USER_EXISTING='m_b04_user_existing'
USER_SHARED='fixture_m_create_user_existing'


def user_dependency(p):
    fid='fixture_'+p.id+'_shared_user'
    p.files['fixtures/shared_user.fixture.yaml']=p.entity('fixture',fid,requires_fixture_refs=[USER_SHARED],
        provides=dict(tables=[]),seed=dict(required=False,rows=[]),execution=dict(status='ready',mode='auto',
        note='依赖 CREATE USER 的真实普通用户与同名 Schema；逆序定向清理，不使用 CASCADE。'))
    p.fixtures.append(fid)
    return fid


def create_user():
    p=Package('CREATE USER','DDL',CORPUS)
    p.fact('syntax','syntax','CREATE USER 可选 WITH 与属性，PASSWORD/IDENTIFIED BY 分支必需并支持 DISABLE。','CREATE USER user_name',2)
    p.fact('schema','lifecycle','创建用户时自动在当前数据库创建同名 Schema。','通过CREATE USER创建用户的同时',2)
    p.fact('login','behavior_oracle','CREATE USER 缺省 LOGIN；本批显式 NOLOGIN 避免开放可登录账户。','通过CREATE USER创建的用户，默认具有LOGIN',1)
    p.fact('ownership','behavior_oracle','系统管理员在普通用户同名 Schema 创建对象，其所有者是该普通用户。','系统管理员在普通用户同名schema',2)
    p.fact('name','syntax','用户名称最多63字符；本批使用不含大写的短标识符，避免同名 Schema 大小写分歧。','用户名称需要为字母',7)
    p.fact('parameters','syntax','其他角色参数由 CREATE ROLE 定义，包括禁用密码权限与连接范围。','其他参数值介绍请参见CREATE ROLE',1)
    p.exports=[p.fid('schema'),p.fid('login'),p.fid('name')]
    p.dim('with_keyword',[('none',''),('yes','WITH')])
    p.dim('password_keyword',[('password','PASSWORD'),('identified','IDENTIFIED BY')])
    p.dim('inherit',[('yes','INHERIT'),('no','NOINHERIT')])
    p.dim('connection_limit',[('default',''),('zero','CONNECTION LIMIT 0'),('unlimited','CONNECTION LIMIT -1'),('below','CONNECTION LIMIT -2')])
    for cl in p.dims['connection_limit']['classes']:cl['values'][0]['fact_refs']=['m_create_role::m_create_role_fact_connection_range']
    p.dims['connection_limit']['classes'][-1]['values'][0]['validity']='invalid'
    p.rules.append(dict(id=p.id+'_rule_connection_range',kind='requires',expression=
        f"connection_limit != '{p.vid('connection_limit','below')}'",fact_refs=['m_create_role::m_create_role_fact_connection_range'],severity='error'))
    target='m_create_user_new';parent='m_create_user_parent'
    p.ast=seq('CREATE USER '+target+' ',slot('with_keyword'),' NOLOGIN NOSYSADMIN ',slot('inherit'),
        ' IN ROLE '+parent+' ',slot('connection_limit'),' ',slot('password_keyword'),' DISABLE')
    fx=p.fixture('parent',[],[f'CREATE ROLE {parent} NOLOGIN NOSYSADMIN PASSWORD DISABLE;'],
        [f'DROP SCHEMA IF EXISTS {target};',f'DROP USER IF EXISTS {target} RESTRICT;',f'DROP ROLE {parent};'])
    values=domain(p);values['connection_limit'].remove('below')
    p.manifest('finite',values,[fx]);p.manifest('connection_below',dict(connection_limit=['below']),[fx],negative='connection_range')
    p.fixture('existing',[],[f'CREATE USER {USER_EXISTING} NOLOGIN NOSYSADMIN PASSWORD DISABLE;'],
        [f'DROP SCHEMA IF EXISTS {USER_EXISTING};',f'DROP USER IF EXISTS {USER_EXISTING} RESTRICT;'])
    role_gates(p)
    p.scenario('implicit_schema',['schema','login'],[fx],[dict(action='创建目标后检查同名 Schema 与角色 NOLOGIN；不把 CREATE ROLE 的无 Schema 行为套用到 USER。')],
        [dict(kind='manual_assertion',expected='Schema 自动创建且归属可检查；NOLOGIN 是本 case 显式选择，不改变 LOGIN 缺省事实')])
    p.scenario('schema_owner',['ownership'],[],[dict(action='在独立普通用户同名 Schema 创建专用表并检查所有权，需另配定向表清理。')],
        [dict(kind='manual_assertion',expected='系统管理员所建对象属于普通用户；尚未执行')])
    return p


def alter_user():
    p=Package('ALTER USER','DDL',CORPUS)
    p.fact('syntax','syntax','ALTER USER 分属性修改、会话参数设置和 RESET ALL。','ALTER USER user_name [ [ WITH ]',5)
    p.fact('settings','syntax','SET 参数允许 TO/= DEFAULT 与 FROM CURRENT。','SET configuration_parameter { { TO',1)
    p.fact('account','syntax','账户支持 ACCOUNT LOCK/UNLOCK。','ACCOUNT { LOCK | UNLOCK }',1)
    p.fact('next_session','lifecycle','用户会话参数只针对指定用户，在下次会话中生效。','ALTER USER中修改的会话参数',1)
    p.fact('pguser','constraint','当前版本不允许修改 PGUSER 属性。','当前版本不允许修改用户的PGUSER',1)
    p.fact('pdb','environment','不支持在 PDB 修改初始用户密码。','不支持在PDB内修改初始用户密码',1)
    p.fact('password_production','open_question','参数说明出现新旧密码，但本章产生式未列出修改密码分支；不直接拼接 ALTER ROLE 的密码语法。','new_password',3,'needs_verification')
    p.dim('form',[('options',''),('set',''),('reset','')])
    p.dim('with_keyword',[('none',''),('yes','WITH')])
    p.dim('option',[('no_login','NOLOGIN'),('no_createdb','NOCREATEDB'),('no_createrole','NOCREATEROLE'),
        ('inherit','INHERIT'),('no_inherit','NOINHERIT'),('one','CONNECTION LIMIT 1'),('below','CONNECTION LIMIT -2'),
        ('lock','ACCOUNT LOCK'),('unlock','ACCOUNT UNLOCK')])
    for i in (5,6):p.dims['option']['classes'][i]['values'][0]['fact_refs']=['m_create_role::m_create_role_fact_connection_range']
    p.dims['option']['classes'][6]['values'][0]['validity']='invalid'
    for i in (7,8):p.dims['option']['classes'][i]['values'][0]['fact_refs']=[p.fid('account')]
    p.rules.append(dict(id=p.id+'_rule_connection_range',kind='requires',expression=
        f"option != '{p.vid('option','below')}'",fact_refs=['m_create_role::m_create_role_fact_connection_range'],severity='error'))
    p.dim('parameter_change',[('default','TO DEFAULT'),('equals','= DEFAULT'),('current','FROM CURRENT')],'settings')
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','options'):seq('ALTER USER '+USER_EXISTING+' ',slot('with_keyword'),' ',slot('option')),
        p.vid('form','set'):seq('ALTER USER '+USER_EXISTING+' SET TimeZone ',slot('parameter_change')),
        p.vid('form','reset'):seq('ALTER USER '+USER_EXISTING+' RESET ALL')})
    fx=user_dependency(p)
    p.manifest('options',dict(form=['options'],with_keyword=['none','yes'],
        option=['no_login','no_createdb','no_createrole','inherit','no_inherit','one','lock','unlock']),[fx])
    p.manifest('connection_below',dict(form=['options'],option=['below']),[fx],negative='connection_range')
    p.manifest('set',dict(form=['set'],parameter_change=['default','equals','current']),[fx])
    p.manifest('reset',dict(form=['reset']),[fx]);role_gates(p)
    p.scenario('next_session',['next_session'],[fx],[dict(action='另外在获授权、可登录的隔离账户检查下一会话 TimeZone，不拿本批 NOLOGIN 当作登录错误 Oracle。')],
        [dict(kind='manual_assertion',expected='目标会话参数生效边界仍待验证')])
    p.scenario('restricted',['pguser','pdb'],[],[dict(action='PGUSER 错误需校准；PDB 初始用户密码限制保留，不触碰初始身份。')],
        [dict(kind='manual_assertion',expected='未生成或执行高权限身份变更')])
    return p


def drop_user():
    p=Package('DROP USER','DDL',CORPUS)
    p.fact('syntax','syntax','DROP USER 支持 IF EXISTS、多个名称和 CASCADE/RESTRICT；本批只选缺省/RESTRICT。','DROP USER [ IF EXISTS ]',1)
    p.fact('schema','lifecycle','删除用户同时删除同名 Schema；本批先定向清空 Schema，自动删除行为留给独立场景。','删除用户，同时会删除同名的schema',1)
    p.fact('restrict','constraint','RESTRICT 为缺省，有依赖对象或被授予权限时拒绝删除。','RESTRICT：如果用户还有任何依赖',2)
    p.fact('dependency_free','environment','删除前应先删除所有自有对象和收回被授予权限；本批使用无显式授权、空 Schema 的测试用户。','在删除用户时，需要先删除该用户拥有',2)
    p.fact('cross_database','environment','DROP USER 不支持跨数据库级联；跨库同名 Schema 需先删除。','即DROP USER不支持跨数据库',4)
    p.fact('kill_query','behavior_oracle','enable_kill_query 控制 CASCADE 碰到锁定对象时杀线程或等待；本批不生成 CASCADE。','当参数enable_kill_query为on',4)
    p.fact('missing','behavior_oracle','IF EXISTS 对不存在用户发 NOTICE 而不抛错误。','如果指定的用户不存在',1)
    one='m_drop_user_one';two='m_drop_user_two'
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('targets',[('one','',dict(items=[one])),('two','',dict(items=[one,two]))])
    p.dim('behavior',[('default',''),('restrict','RESTRICT')])
    p.ast=seq('DROP USER ',slot('if_exists'),' ',repeat('targets'),' ',slot('behavior'))
    fx=p.fixture('users',[],[f'CREATE USER {n} NOLOGIN NOSYSADMIN PASSWORD DISABLE;' for n in (one,two)]+
        [f'DROP SCHEMA {n};' for n in (one,two)],
        [f'DROP USER IF EXISTS {n} RESTRICT;' for n in (two,one)])
    p.manifest('dependency_free',domain(p),[fx]);role_gates(p)
    gate(p,'user_dependencies',['none_after_explicit_schema_cleanup'],[p.fid('dependency_free')])
    gate(p,'identity_scope',['single_database_test_identity'],[p.fid('cross_database')])
    p.scenario('dependencies',['schema','restrict'],[],[dict(action='独立创建同名 Schema/目标对象，验证 RESTRICT 拒绝的目标错误与空 Schema 自动删除边界；不要任意错误即通过。')],
        [dict(kind='manual_assertion',expected='RESTRICT 目标错误及隐式 Schema 生命周期需校准')])
    p.scenario('cascade_lock',['kill_query'],[],[dict(action='仅保留锁/线程影响风险，不在本循环生成或执行 CASCADE 清理。')],
        [dict(kind='manual_assertion',expected='特殊环境行为未执行')])
    p.scenario('missing_notice',['missing'],[],[dict(sql='DROP USER IF EXISTS m_drop_user_absent RESTRICT;')],
        [dict(kind='manual_assertion',expected='缺失用户发 NOTICE，尚未执行')])
    return p


def set_identity(command):
    p=Package(command,'UTILITY',CORPUS)
    if command=='SET ROLE':
        p.fact('syntax','syntax','本批只生成文档明确的 SET ROLE = DEFAULT 重置分支。','SET ROLE = DEFAULT;',1)
        p.fact('reset','behavior_oracle','重置当前用户标识为当前会话用户标识。','重置当前用户标识为当前会话',1)
        p.fact('authority','environment','切换到指定角色需要成员资格，系统管理员可选任意角色；本批不切换指定身份。','当前会话的用户必须是指定',2)
        p.fact('scope','lifecycle','SESSION 是缺省会话范围，LOCAL 仅当前事务有效；这两个修饰符仅在指定身份分支列出。','声明这个命令只对当前会话',3)
        p.fact('password','environment','指定身份分支要求角色密码，不支持直接使用密文；密码凭证合同未接入。','角色的密码。要求符合密码',1)
        p.dim('reset_form',[('default','SET ROLE = DEFAULT')])
    else:
        p.fact('syntax','syntax','DEFAULT 重置支持 SET [SESSION|LOCAL] SESSION AUTHORIZATION 与 SESSION_AUTHORIZATION = DEFAULT。','{SET [ SESSION | LOCAL ] SESSION AUTHORIZATION DEFAULT',2)
        p.fact('reset','behavior_oracle','DEFAULT 将会话用户和当前用户标识重置为初始认证用户名。','重置会话和当前用户标识符为初始',1)
        p.fact('authority','environment','初始会话用户为管理员才能改变会话用户，否则只能指定认证用户名。','只有在初始会话用户有系统管理员',2)
        p.fact('scope','lifecycle','SESSION 为当前会话，LOCAL 仅当前事务有效。','声明这个命令只对当前会话',3)
        p.fact('password','environment','指定身份分支要求角色密码，不支持直接使用密文；密码凭证合同未接入。','角色的密码。要求符合密码',1)
        p.dim('reset_form',[('default','SET SESSION AUTHORIZATION DEFAULT'),('session','SET SESSION SESSION AUTHORIZATION DEFAULT'),
            ('local','SET LOCAL SESSION AUTHORIZATION DEFAULT'),('parameter','SET SESSION_AUTHORIZATION = DEFAULT')])
    p.ast=seq(slot('reset_form'))
    fx=p.fixture('transaction',[],['START TRANSACTION;'],['ROLLBACK;'])
    p.files['fixtures/transaction.fixture.yaml']['execution']['note']='在独占新连接的同一事务生成目标与 ROLLBACK；只重置默认身份，不切换至其他角色。结束关闭连接，不能复用业务会话。'
    p.manifest('reset_only',domain(p),[fx])
    p.files['manifests/reset_only.manifest.yaml']['description']='仅 DEFAULT 重置产生式的有限静态模型；不覆盖需要密码的指定身份切换。'
    # Implementation isolation is a harness precondition, not an invented product rule.
    p.files['manifests/reset_only.manifest.yaml']['environment_requirements'].append(
        dict(key='session_lifecycle',allowed_values=['isolated_new_connection'],fact_refs=[p.fid('mode')]))
    p.scenario('reset_identity',['reset','scope'],[fx],[dict(action='在已授权隔离连接记录 current_user/session_user，验证 DEFAULT 重置及事务结束的恢复边界。')],
        [dict(kind='manual_assertion',expected='按本命令的当前/会话/初始身份区别判定；尚未执行')])
    p.scenario('password_switch',['authority','password'],[],[dict(action='待安全运行时凭证绑定与日志脱敏合同接入，再设置目标身份并校验成员权限、SESSION/LOCAL 与恢复。不得在规格或快照内保存实际密码。')],
        [dict(kind='manual_assertion',expected='指定身份切换仍未生成/执行；不借重置用例宣称整个命令覆盖完成')])
    return p


GRANT_SCHEMA='m_grant_namespace'
GRANT_TABLE=GRANT_SCHEMA+'.source'


def object_privileges(command):
    p=Package(command,'DCL',CORPUS);grant=command=='GRANT'
    if grant:
        p.fact('syntax','syntax','对象授权包含表和列级权限、可选 TABLE/GROUP、多个接收角色及 WITH GRANT OPTION。','GRANT { { SELECT | INSERT',7)
        p.fact('columns','syntax','列权限允许 SELECT/INSERT/UPDATE/REFERENCES/COMMENT 的列列表。','GRANT { {{ SELECT | INSERT',5)
        p.fact('owner','environment','对象所有者缺省拥有对象权限及固有再授予权限；本批由对象创建者操作。','对象的所有者缺省具有',3)
        p.fact('schema_usage','environment','实际访问表还需要所属 Schema 的 USAGE；本批 fixture 显式授予专用 Schema USAGE。','用户如果想要对某张表',3)
        p.fact('column_access','behavior_oracle','表权限会覆盖全部列；验证仅列授权时应先撤销表权限。','如果拥有表的访问权限',2)
        p.fact('public_option','constraint','WITH GRANT OPTION 不能授予 PUBLIC。','这个选项不能赋予PUBLIC',2)
        p.fact('database_mapping','environment','ON DATABASE 是否指物理库由 grant_database_nomapping 决定，否则映射为 ON SCHEMA。','GUC参数m_format_behavior_compat_options开启grant_database_nomapping',5)
        p.fact('admin_bypass','environment','三权分立关闭的系统管理员绕过对象权限，不能用该身份判定被授权角色的访问 Oracle。','三权分立关闭时的数据库系统管理员',3)
        p.exports=[p.fid(x) for x in ('owner','schema_usage','column_access','admin_bypass')]
    else:
        p.fact('syntax','syntax','对象回收包括表/列权限、GRANT OPTION FOR、TABLE/GROUP 与 RESTRICT。','REVOKE [ GRANT OPTION FOR ]',8)
        p.fact('columns','syntax','列级回收允许按列列表撤销指定权限。','{ {{ SELECT | INSERT',5)
        p.fact('grant_option','behavior_oracle','GRANT OPTION FOR 只撤销再授权权力，不撤销权限本身。','指定GRANT OPTION FOR时',1)
        p.fact('grantor','environment','用户只能撤销自己直接赋予的权限；本批 setup 和目标使用同一对象创建者。','一个用户只能撤销由它自己直接赋予',5)
        p.fact('alternative_paths','behavior_oracle','撤销某一路授权不等于失去通过 PUBLIC 或其他角色继承的权限。','任何特定角色拥有的特权包括',6)
        p.fact('dependent_grants','constraint','存在下游依赖授权时必须 CASCADE；本批不创建下游授权，使用缺省/RESTRICT。','用户B持有的权限称为依赖性权限',2)
        p.fact('database_mapping','environment','ON DATABASE 是否映射到 ON SCHEMA 取决于 grant_database_nomapping。','GUC参数m_format_behavior_compat_options开启grant_database_nomapping',5)
    p.dim('scope',[('table',''),('columns','')])
    p.dim('table_privilege',[('select','SELECT'),('update','UPDATE'),('both','SELECT, UPDATE')])
    p.dim('column_privilege',[('select','SELECT (id)'),('update','UPDATE (qty)'),('both_columns','SELECT (id, qty)'),('mixed','SELECT (id), UPDATE (qty)')],'columns')
    p.dim('table_keyword',[('none',''),('yes','TABLE')])
    p.dim('group_keyword',[('none',''),('yes','GROUP')])
    p.dim('recipients',[('one','',dict(items=[ROLE_EXISTING])),('two','',dict(items=[ROLE_EXISTING,ROLE_SECOND]))])
    p.dim('grant_option',[('none',''),('yes','WITH GRANT OPTION' if grant else 'GRANT OPTION FOR')])
    if not grant:p.dim('behavior',[('default',''),('restrict','RESTRICT')])
    privilege=dict(kind='choice',selector='scope',branches={p.vid('scope','table'):slot('table_privilege'),p.vid('scope','columns'):slot('column_privilege')})
    suffix=seq(' ON ',slot('table_keyword'),' '+GRANT_TABLE+(' TO ' if grant else ' FROM '),slot('group_keyword'),' ',repeat('recipients'))
    p.ast=seq('GRANT ',privilege,suffix,' ',slot('grant_option')) if grant else seq('REVOKE ',slot('grant_option'),' ',privilege,suffix,' ',slot('behavior'))
    if grant:
        fx=p.fixture('objects',[(GRANT_TABLE,['id','qty'])],[f'CREATE SCHEMA {GRANT_SCHEMA};',f'CREATE TABLE {GRANT_TABLE} (id INTEGER, qty INTEGER);',
            f'GRANT USAGE ON SCHEMA {GRANT_SCHEMA} TO {ROLE_EXISTING}, {ROLE_SECOND};'],
            [f'DROP TABLE {GRANT_TABLE};',f'DROP SCHEMA {GRANT_SCHEMA};'],requires=[ROLE_SHARED])
        fxmap={'table':fx,'columns':fx}
    else:
        fxmap={}
        for scope,privs in [('table','SELECT, UPDATE'),('columns','SELECT (id, qty), UPDATE (id, qty)')]:
            fxmap[scope]=p.fixture(scope,[],[f'GRANT {privs} ON TABLE {GRANT_TABLE} TO {ROLE_EXISTING}, {ROLE_SECOND} WITH GRANT OPTION;'],
                [f'REVOKE {privs} ON TABLE {GRANT_TABLE} FROM {ROLE_EXISTING}, {ROLE_SECOND} RESTRICT;'],requires=['fixture_m_grant_objects'])
    for scope,key,values in [('table','table_privilege',['select','update','both']),('columns','column_privilege',['select','update','both_columns','mixed'])]:
        bindings=dict(scope=[scope],table_keyword=['none','yes'],group_keyword=['none','yes'],recipients=['one','two'],grant_option=['none','yes'])
        bindings[key]=values
        if not grant:bindings['behavior']=['default','restrict']
        p.manifest(scope,bindings,[fxmap[scope]])
    role_gates(p)
    owner=p.fid('owner') if grant else 'm_grant::m_grant_fact_owner'
    gate(p,'object_authority',['fixture_object_creator'],[owner])
    gate(p,'schema_usage',['fixture_granted'],[p.fid('schema_usage') if grant else 'm_grant::m_grant_fact_schema_usage'])
    if not grant:gate(p,'grantor_identity',['same_setup_and_target_session'],[p.fid('grantor')])
    p.scenario('effective_access',['column_access','admin_bypass'] if grant else ['grant_option','alternative_paths'],list(fxmap.values())[:1],
        [dict(action='用非管理员的专用受测身份查询/更新列，区分表级、列级、直接权限、继承权限和再授权能力；不能用 fixture 管理员身份假验权限。')],
        [dict(kind='manual_assertion',expected='当前只验证有限 SQL；有效权限与身份切换 Oracle 仍待校准')])
    p.scenario('special_restrictions',['public_option'] if grant else ['dependent_grants'],[],
        [dict(action='PUBLIC 再授权限制或下游依赖回收独立建模；不把系统权限、ANY、PUBLIC、CASCADE 放入默认对象候选。')],
        [dict(kind='manual_assertion',expected='受限分支保持未生成，目标错误不臆造')])
    p.scenario('database_mapping',['database_mapping'],[],[dict(action='分 grant_database_nomapping 环境验证物理库与 Schema 授权映射，不能统一假设。')],
        [dict(kind='manual_assertion',expected='数据库级授权仍未建模/执行')])
    return p


def internal_gate(p):
    gate(p,'command_applicability',['m_internal_tool_reviewed'],[p.fid('internal')])
    gate(p,'test_isolation',['dedicated_database_no_other_users'],[p.fid('internal')])
    for obj in p.files.values():
        if obj['kind']=='manifest':obj['description']='原文明示仅内部使用；有限离线候选，不表示普通用户支持。执行需另外授权与适用性审阅。'


def create_function():
    p=Package('CREATE FUNCTION','DDL',CORPUS)
    p.fact('internal','environment','内部使用功能，不支持用户使用；本批仅保留受限离线候选。','内部使用功能，不支持用户使用',1)
    p.fact('syntax','syntax','CREATE OR REPLACE FUNCTION 定义参数、返回类型、语言、属性和字符串函数体。','CREATE OR REPLACE FUNCTION function_name',19)
    p.fact('cost','constraint','COST 为 >=0 的数值。','execution_cost以cpu_operator_cost',2)
    p.fact('strict','behavior_oracle','STRICT 对 NULL 参数不执行函数而直接返回 NULL。','STRICT用于指定如果函数',3)
    p.fact('public','environment','新函数默认授予 PUBLIC 执行权限，调用还需要 Schema USAGE；独立隔离库，不生成共享模式函数。','新创建的函数默认会给PUBLIC',6)
    p.fact('return_type','behavior_oracle','创建时不检查函数体返回值类型，不能用创建成功证明返回契约。','在创建函数时，不会检查函数内返回值',1)
    p.fact('overload','constraint','仅参数名或默认值或返回类型不同不足以形成新重载。','不能创建仅形参名字不同',4)
    p.fact('defaults','syntax','参数默认表达式支持 DEFAULT、:= 和 =。','( [ { argname [ argmode ]',1)
    p.fact('current_user','syntax','AUTHID CURRENT_USER 使用调用者权限。','表明该函数将带着调用它的用户',1)
    p.dim('argmode',[('default',''),('in','IN')])
    p.dim('default_expr',[('none',''),('default','DEFAULT 1'),('assign',':= 1'),('equals','= 1')],'defaults')
    p.dim('volatility',[('immutable','IMMUTABLE'),('stable','STABLE'),('volatile','VOLATILE')])
    p.dim('strict',[('none',''),('yes','STRICT')])
    p.dim('cost',[('default',''),('zero','COST 0'),('one','COST 1'),('negative','COST -1')],'cost')
    p.dims['cost']['classes'][-1]['values'][0]['validity']='invalid'
    p.rule('nonnegative_cost',f"cost != '{p.vid('cost','negative')}'",'cost')
    ns='m_create_function_namespace';fn=ns+'.increment_value'
    p.ast=seq('CREATE OR REPLACE FUNCTION '+fn+' (i ',slot('argmode'),' INTEGER ',slot('default_expr'),
        ') RETURNS INTEGER LANGUAGE plpgsql ',slot('volatility'),' ',slot('strict'),' AUTHID CURRENT_USER ',slot('cost'),
        " AS 'BEGIN RETURN i + 1; END;'")
    fx=p.fixture('namespace',[],[f'CREATE SCHEMA {ns};'],[f'DROP FUNCTION IF EXISTS {fn}(INTEGER) RESTRICT;',f'DROP SCHEMA {ns};'])
    values=domain(p);values['cost'].remove('negative')
    p.manifest('restricted_finite',values,[fx]);p.manifest('negative_cost',dict(cost=['negative']),[fx],negative='nonnegative_cost')
    ens='m_function_existing_namespace';efn=ens+'.increment_value'
    p.fixture('existing',[],[f'CREATE SCHEMA {ens};',f"CREATE OR REPLACE FUNCTION {efn}(i INTEGER) RETURNS INTEGER LANGUAGE plpgsql AUTHID CURRENT_USER AS 'BEGIN RETURN i + 1; END;';"],
        [f'DROP FUNCTION IF EXISTS {efn}(INTEGER) RESTRICT;',f'DROP SCHEMA {ens};'])
    internal_gate(p);gate(p,'function_visibility',['isolated_schema_no_public_usage'],[p.fid('public')])
    p.scenario('function_result',['strict','return_type'],[fx],[dict(action='内部工具审阅后验证整数输入/NULL 返回；不从 CREATE 成功推导执行返回类型正确。')],
        [dict(kind='manual_assertion',expected='输入1预期2、STRICT NULL预期NULL，但尚未生成调用场景或执行')])
    p.scenario('overloads',['overload'],[],[dict(action='独立建模重载标识和类型、返回值、默认值冲突的目标错误；不在当前有限域声明覆盖。')],
        [dict(kind='manual_assertion',expected='重载冲突 Oracle 尚待校准')])
    return p


def drop_function():
    p=Package('DROP FUNCTION','DDL',CORPUS)
    p.fact('internal','environment','内部使用功能，不支持用户使用；只建受限离线候选。','内部使用功能，不支持用户使用',1)
    p.fact('syntax','syntax','DROP FUNCTION 可省略或指定签名；RESTRICT/CASCADE 随显式签名分支。','DROP FUNCTION [ IF EXISTS ] function_name',2)
    p.fact('owner','environment','删除需要函数所有者或 DROP 权限；本批由 fixture 创建者删除。','只有函数的所有者',2)
    p.fact('temporary','constraint','涉及临时表操作的函数无法用 DROP FUNCTION 删除；本批纯整数函数无表依赖。','如果函数中涉及对临时表',1)
    p.fact('overloads','constraint','同名重载删除时必须提供参数列表，否则报错。','如果存在同名函数',1)
    p.fact('restrict','behavior_oracle','RESTRICT 遇到依赖对象拒绝删除，本批不建立函数依赖者。','RESTRICT：如果有任何依赖对象',1)
    p.fact('missing','behavior_oracle','IF EXISTS 对缺失函数产出 NOTICE 而不报错。','表示如果函数存在则执行删除',2)
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('signature',[('omitted',''),('type','(INTEGER)'),('named','(i INTEGER)'),('explicit_in','(i IN INTEGER)')])
    p.dim('behavior',[('default',''),('restrict','RESTRICT')])
    p.rule('behavior_requires_signature',f"signature != '{p.vid('signature','omitted')}' or behavior == '{p.vid('behavior','default')}'",'syntax')
    p.ast=seq('DROP FUNCTION ',slot('if_exists'),' m_function_existing_namespace.increment_value ',slot('signature'),' ',slot('behavior'))
    fx='fixture_'+p.id+'_existing'
    p.files['fixtures/existing.fixture.yaml']=p.entity('fixture',fx,requires_fixture_refs=['fixture_m_create_function_existing'],provides=dict(tables=[]),
        seed=dict(required=False,rows=[]),execution=dict(mode='auto',status='ready',note='依赖唯一 INTEGER 函数，非重载；先定向清理函数，再清理 Schema。'))
    p.fixtures.append(fx);p.manifest('restricted_finite',domain(p),[fx])
    p.manifest('missing_signature_negative',dict(if_exists=['none'],signature=['omitted'],behavior=['restrict']),[fx],negative='behavior_requires_signature')
    internal_gate(p)
    gate(p,'function_authority',['fixture_function_creator'],[p.fid('owner')])
    p.scenario('restricted_targets',['temporary','overloads','restrict','missing'],[],[dict(action='另配临时表/重载/依赖函数及缺失对象场景，审阅内部工具适用性后校准目标错误与 NOTICE。')],
        [dict(kind='manual_assertion',expected='当前唯一无表依赖函数不足以证明这些特殊场景，仍待验证')])
    return p


def do_block():
    p=Package('DO','UTILITY',CORPUS)
    p.fact('internal','environment','该语法仅内部工具使用，本批只生成受限离线匿名块。','该语法仅内部工具使用',1)
    p.fact('syntax','syntax','DO code 的 code 为字符串形式程序语言代码。','DO code;',1)
    p.fact('language','environment','目前只支持 plpgsql 安装语言；非受信任语言需要 USAGE 或管理员权限。','目前只支持plpgsql安装语言',3)
    p.fact('execution','behavior_oracle','匿名块无参数、返回 void，解析和执行在同一时刻发生。','代码块被看作是没有参数',2)
    p.dim('operation',[('update','UPDATE '+SRC+' SET qty = qty + 1 WHERE id = 1;'),('insert','INSERT INTO '+SRC+' (id, qty) VALUES (4, 40);')])
    p.ast=seq("DO 'BEGIN ",slot('operation')," END;'")
    p.manifest('restricted_finite',domain(p),[BASE]);internal_gate(p)
    gate(p,'procedural_language',['plpgsql_available_and_authorized'],[p.fid('language')])
    p.scenario('effects',['execution'],[BASE],[dict(action='在内部工具场景审阅后验证匿名块修改 qty 或插入行；解析与执行同阶段，不能按普通 PREPARE 处理。')],
        [dict(kind='manual_assertion',expected='UPDATE id=1 后 qty=11；INSERT 增加(4,40)，均未执行')])
    return p


def rendered_files(p):
    files=p.finish()
    if p.id=='m_alter_database':
        ledger=files[p.id+'.source.yaml']
        refs=[]
        for corpus,section,anchor in [(CHARSET_CORPUS,'2.3','L7-12; L24-43 表2-2; L65-108 表2-3'),
                                      (LIBRARY_CORPUS,'2.3.2','L24-50：默认字符集/字符序对应与 SQL_ASCII 限制')]:
            catalog=json.loads((corpus/'catalog.json').read_text());ch=next(c for c in catalog['chapters'] if c['section_number']==section)
            assert catalog['parent_pdf_sha256']==p.catalog['parent_pdf_sha256']
            assert hashlib.sha256((corpus/ch['source_relpath']).read_bytes()).hexdigest()==ch['chapter_sha256']
            sid='m_charset_'+section.replace('.','_');refs.append(sid)
            ledger.setdefault('supplemental_sources',[]).append(dict(id=sid,document=section+' '+ch['title'],version=catalog['product_version'],
                retrieval_date='2026-09-08',source_anchor=anchor,catalog_chapter_ref=dict(document_id=catalog['document_id'],
                    source_relpath=ch['source_relpath'],chapter_sha256=ch['chapter_sha256'])))
        for unit in ledger['units']:
            if any(f in unit.get('fact_refs',[]) for f in [p.fid('charset_domain'),p.fid('charset_pair'),p.fid('encoding')]):
                unit['supplemental_source_refs']=refs
    return files


BUILDERS=dict(alter_database=lambda:alter_namespace('ALTER DATABASE'),alter_schema=lambda:alter_namespace('ALTER SCHEMA'),
              alter_view=alter_view,alter_session=alter_session,create_role=create_role,alter_role=alter_role,drop_role=drop_role,
              create_group=create_group,alter_group=alter_group,drop_group=drop_group,
              create_user=create_user,alter_user=alter_user,drop_user=drop_user,
              set_role=lambda:set_identity('SET ROLE'),set_session_authorization=lambda:set_identity('SET SESSION AUTHORIZATION'),
              grant=lambda:object_privileges('GRANT'),revoke=lambda:object_privileges('REVOKE'),
              create_function=create_function,drop_function=drop_function,do=do_block)


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--update',action='store_true');args=parser.parse_args()
    out=[]
    for builder in BUILDERS.values():
        p=builder()
        for name,obj in rendered_files(p).items():
            path=ROOT/'specs'/p.category.lower()/p.id/name
            content=yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110)
            if path.exists():
                if not args.update:raise FileExistsError(path)
                old=path.read_text()
                if old==content:continue
                out.append('*** Update File: '+str(path))
                out.extend('@@' if l.startswith('@@') else l for l in list(difflib.unified_diff(
                    old.splitlines(),content.splitlines(),n=max(len(old.splitlines()),len(content.splitlines())),lineterm=''))[2:])
            else:
                out.append('*** Add File: '+str(path));out.extend('+'+l for l in content.splitlines())
    print('\n'.join(['*** Begin Patch']+out+['*** End Patch']))


if __name__=='__main__':main()
