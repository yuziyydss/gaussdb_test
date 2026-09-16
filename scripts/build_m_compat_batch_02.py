#!/usr/bin/env python3
"""Curated M batch 02: emit patches, not regex-converted PDF grammar.

18 finite chapter models. Unmodelled branches and atomicity remain explicit
source gaps. No execution and no changes to general-mode packages.
"""
import argparse
import difflib
from pathlib import Path
import sys
import yaml

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from scripts.build_m_compat_pilot import Package, BASE, SRC, seq, slot, repeat

CORPUS = ROOT/'work/m_compat_batch_02/corpus'


def package(command, category, anchor, count=1):
    p = Package(command, category, CORPUS)
    p.fact('syntax','syntax','本章语法的有限代表分支；未选择的完整语法保留 source 缺口。',anchor,count)
    start, end, _ = p.spans[-1]
    p.facts[-1]['statement'] = '原文语法片段（仅此来源区间，不等同完整生成能力）：' + ' '.join(
        line.strip() for line in p.lines[start-1:end] if not line.startswith('[[PDF_PAGE'))
    return p


def all_bindings(p):
    return {k:[c['values'][0]['id'].removeprefix(p.id+'_'+k+'_') for c in v['classes']]
            for k,v in p.dims.items()}


def planned(p, suffix, statement, anchor, fixture, steps, expected, count=1):
    p.fact(suffix,'behavior_oracle',statement,anchor,count)
    p.scenario(suffix,[suffix],[fixture],steps,[dict(
        kind='result_set' if isinstance(expected,list) else 'manual_assertion',expected=expected)])


def namespace_create(command):
    p = package(command,'DDL','CREATE {DATABASE | SCHEMA}',7)
    p.fact('namespace','environment','M DATABASE 与 SCHEMA 同义；不是物理建库流程。','DATABASE与SCHEMA是同义词')
    if command=='CREATE SCHEMA':
        p.fact('authority','environment','当前数据库CREATE权限允许创建模式。',
               '只要用户对当前数据库有CREATE权限')
        p.fact('same_name_owner','environment','管理员在普通用户同名模式创建的对象归该同名用户，而非管理员。',
               '系统管理员在普通用户同名模式Schema',2)
        p.exports=[p.fid('namespace'),p.fid('authority'),p.fid('same_name_owner'),p.fid('syntax')]
    target = p.id+'_new'
    anchor = p.id+'_anchor'
    p.dim('keyword',[('database','DATABASE'),('schema','SCHEMA')])
    p.dim('if_missing',[('none',''),('yes','IF NOT EXISTS')])
    p.ast = seq('CREATE ',slot('keyword'),' ',slot('if_missing'),' '+target)
    fx = p.fixture('isolated_namespace',[],[f'CREATE SCHEMA {anchor};',f'USE {anchor};'],
        ['USE public;',f'DROP SCHEMA IF EXISTS {target};',f'DROP SCHEMA {anchor};'])
    p.manifest('finite',all_bindings(p),[fx])
    p.files['manifests/finite.manifest.yaml']['environment_requirements'][0]['fact_refs'].append(p.fid('namespace'))
    planned(p,'use_created','创建后可 USE 新模式并在其中创建对象。','USE test1;',fx,
        [dict(sql=f'CREATE SCHEMA {target};'),dict(sql=f'USE {target};'),dict(sql='SELECT database();')],[[target]])
    p.fact('charset_description','open_question','字符集/字符序参数说明需与库级章节交叉复核；本批不猜测取值。',
        '字符集。例如',2,'needs_verification')
    return p


def namespace_drop(command):
    is_schema = command == 'DROP SCHEMA'
    p = package(command,'DDL', 'DROP SCHEMA [' if is_schema else 'DROP DATABASE [')
    if is_schema:
        p.fact('authority','environment','仅模式所有者、持有模式DROP权限用户可删除；三权分立关闭时系统管理员默认有权。',
               '只有模式的所有者或者被授予了模式DROP权限',2)
        p.exports=[p.fid('syntax'),p.fid('authority')]
    a,b = p.id+'_a',p.id+'_b'
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('targets',[('one','',dict(items=[a]))]+([('two','',dict(items=[a,b]))] if is_schema else []))
    p.ast = seq(command+' ',slot('if_exists'),' ',repeat('targets'))
    fx = p.fixture('owned_namespaces',[],[f'CREATE SCHEMA {a};',f'CREATE SCHEMA {b};'],
        [f'DROP SCHEMA IF EXISTS {a};',f'DROP SCHEMA IF EXISTS {b};'])
    p.manifest('finite',all_bindings(p),[fx])
    planned(p,'missing_notice','IF EXISTS 对缺失模式发 NOTICE 而不是错误。','notice',fx,
        [dict(sql=command+' IF EXISTS '+p.id+'_absent;')],
        '命令成功并产生 NOTICE；真实消息与 SQLSTATE 待执行校准')
    return p


def use():
    p = package('USE','UTILITY','USE schema_name')
    a,b = p.id+'_a',p.id+'_b'
    p.dim('target',[('a',a),('b',b)])
    p.ast = seq('USE ',slot('target'))
    fx = p.fixture('owned_namespaces',[],[f'CREATE SCHEMA {a};',f'CREATE SCHEMA {b};'],
        ['USE public;',f'DROP SCHEMA {a};',f'DROP SCHEMA {b};'])
    p.manifest('finite',all_bindings(p),[fx])
    planned(p,'verify_switch','USE 不报错不保证切换成功，必须核对 database()。','不会产生错误信息提示',fx,
        [dict(sql=f'USE {a};'),dict(sql='SELECT database();')],[[a]],2)
    p.fact('usage','environment','切换必须有目标模式 USAGE 权限。','USAGE权限',3)
    p.scenario('missing_usage',['usage'],[],
        [dict(action='隔离低权限角色，无目标模式 USAGE，执行 USE 后调用 database()')],
        [dict(kind='target_error',expected='USE 可能不报错，但 database() 提示无当前模式；待校准')])
    return p


def drop_object(command):
    table = command == 'DROP TABLE'
    p = package(command,'DDL','DROP [TEMPORARY]' if table else 'DROP VIEW [',2)
    p.fact('authority','environment',
        '对象所有者、所在模式所有者、持有对象DROP权限或DROP ANY TABLE权限的用户可删除；三权分立关闭时系统管理员默认有权。',
        '表的所有者、表所在模式' if table else '视图的所有者、视图所在模式',3)
    p.exports=[p.fid('syntax'),p.fid('authority')]
    if table:
        p.fact('purge','lifecycle','PURGE直接物理删除表，不把表放入回收站；不是删除其他对象的授权。',
               '该参数表示即使开启回收站功能',2)
        p.exports.append(p.fid('purge'))
    a,b = p.id+'_a',p.id+'_b'
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('targets',[('one','',dict(items=[a])),('two','',dict(items=[a,b]))])
    p.dim('dependency',[('none',''),('cascade','CASCADE'),('restrict','RESTRICT')])
    if table:
        p.dim('temporary',[('none',''),('yes','TEMPORARY')])
        p.dim('purge',[('none',''),('yes','PURGE')])
        p.ast=seq('DROP ',slot('temporary'),' TABLE ',slot('if_exists'),' ',repeat('targets'),' ',slot('dependency'),' ',slot('purge'))
        for suffix,modifier,temp_value in [('regular','', 'none'),('temporary','TEMPORARY ','yes')]:
            fx=p.fixture(suffix,[(a,['id']),(b,['id'])],
                [f'CREATE {modifier}TABLE {a} (id INT);',f'CREATE {modifier}TABLE {b} (id INT);'],
                [f'DROP TABLE IF EXISTS {a};',f'DROP TABLE IF EXISTS {b};'])
            if suffix=='temporary':
                for t in p.files['fixtures/temporary.fixture.yaml']['provides']['tables']:
                    t['persistence']='temporary'
            bindings=all_bindings(p); bindings['temporary']=[temp_value]
            p.manifest(suffix,bindings,[fx])
    else:
        p.ast=seq('DROP VIEW ',slot('if_exists'),' ',repeat('targets'),' ',slot('dependency'))
        fx=p.fixture('views',[],[f'CREATE VIEW {a} AS SELECT id FROM {SRC};',f'CREATE VIEW {b} AS SELECT id FROM {SRC};'],
                     [f'DROP VIEW IF EXISTS {a};',f'DROP VIEW IF EXISTS {b};'],requires=[BASE])
        p.manifest('finite',all_bindings(p),[fx])
    p.fact('dependency_version','environment','s1 及以上 CASCADE/RESTRICT 仅语法支持，不能宣称级联行为。','该属性',2)
    p.scenario('dependency_behavior',['dependency_version'],[fx],
        [dict(action='在已核验 m_format_dev_version 的隔离环境创建真实依赖视图，验证依赖删除')],
        [dict(kind='target_error',expected='s1+ 不能把 CASCADE 当作依赖删除保证；需目标错误校准')])
    return p


def truncate():
    p=package('TRUNCATE','DDL','TRUNCATE [ TABLE ]',2)
    p.fact('owner','environment','表所有者、持有TRUNCATE或TRUNCATE ANY TABLE权限的用户可执行；三权分立关闭时系统管理员默认有权。',
        '表的所有者、被授予了表的TRUNCATE权限',3)
    p.fact('purge','behavior_oracle','默认将表数据放入回收站；PURGE直接清理。',
        '默认将表数据放入回收站中，PURGE直接清理')
    p.exports=[p.fid('owner'),p.fid('rows_removed'),p.fid('purge')]
    a,b=p.id+'_a',p.id+'_b'
    p.dim('table_word',[('none',''),('yes','TABLE')])
    p.dim('targets',[('one','',dict(items=[a])),('two','',dict(items=[a,b]))])
    p.dim('purge',[('none',''),('yes','PURGE')])
    p.ast=seq('TRUNCATE ',slot('table_word'),' ',repeat('targets'),' ',slot('purge'))
    fx=p.fixture('seeded',[(a,['id']),(b,['id'])],
        [f'CREATE TABLE {a} (id INT);',f'CREATE TABLE {b} (id INT);',f'INSERT INTO {a} VALUES (1),(2);',f'INSERT INTO {b} VALUES (3);'],
        [f'DROP TABLE {a};',f'DROP TABLE {b};'])
    p.manifest('finite',all_bindings(p),[fx])
    planned(p,'rows_removed','TRUNCATE 删除内容但保留表定义。','删除内容，释放空间，但不删除定义',fx,
        [dict(sql=f'TRUNCATE TABLE {a};'),dict(sql=f'SELECT COUNT(*) FROM {a};')],[[0]])
    p.files['scenarios/rows_removed.scenario.yaml']['fact_refs'] += [p.fid('owner'),p.fid('purge')]
    p.fact('source_conflict','open_question','主语法多余闭合花括号，且依赖选项参数误写视图；不生成该括号、不推导级联规则。',
        '[CASCADE | RESTRICT][ PURGE ]}',1,'needs_verification')
    p.fact('only','environment','ONLY 与星号仅保留语法、功能不支持；本批普通表不宣称继承行为。','目前ONLY和增加*选项',1)
    p.scenario('partition_and_inheritance',['only'],[],[dict(action='另建分区/继承契约并核验版本后补场景')],
        [dict(kind='result_set',expected='待分区行集合与全局索引 Oracle 接入')])
    return p


def rename_table():
    p=package('RENAME TABLE','UTILITY','RENAME { TABLE | TABLES }')
    a,b,x,y=[p.id+'_'+s for s in ('a','b','x','y')]
    p.dim('keyword',[('table','TABLE'),('tables','TABLES')])
    p.dim('renames',[('one','',dict(items=[a+' TO '+x])),('two','',dict(items=[a+' TO '+x,b+' TO '+y]))])
    p.ast=seq('RENAME ',slot('keyword'),' ',repeat('renames'))
    fx=p.fixture('owned_tables',[(a,['id']),(b,['id'])],
        [f'CREATE TABLE {a} (id INT);',f'CREATE TABLE {b} (id INT);',f'INSERT INTO {a} VALUES (7);'],
        [f'DROP TABLE IF EXISTS {n};' for n in (x,y,a,b)])
    p.manifest('finite',all_bindings(p),[fx])
    planned(p,'preserve_rows','重命名不影响数据。','不会影响所存储的数据',fx,
        [dict(sql=f'RENAME TABLE {a} TO {x};'),dict(sql=f'SELECT id FROM {x};')],[[7]])
    return p


def transaction(command):
    anchors={'BEGIN':'BEGIN [','START TRANSACTION':'START TRANSACTION', 'COMMIT':'COMMIT [',
        'ROLLBACK':'ROLLBACK [','SAVEPOINT':'SAVEPOINT savepoint_name',
        'RELEASE SAVEPOINT':'RELEASE [','ROLLBACK TO SAVEPOINT':'ROLLBACK ['}
    # START first occurrence is prose; use a line number from the inspected chapter.
    p=package(command,'TCL',10 if command=='START TRANSACTION' else anchors[command],
              16 if command=='START TRANSACTION' else 7 if command=='BEGIN' else 1)
    t=p.id+'_data'; sp1=p.id+'_sp1'; sp2=p.id+'_sp2'
    setup=[f'CREATE TABLE {t} (id INT);',f'INSERT INTO {t} VALUES (0);']
    opening=command in ('BEGIN','START TRANSACTION')
    if not opening:
        setup += ['BEGIN;',f'INSERT INTO {t} VALUES (1);']
    if command in ('RELEASE SAVEPOINT','ROLLBACK TO SAVEPOINT'):
        setup += [f'SAVEPOINT {sp1};',f'INSERT INTO {t} VALUES (2);',f'SAVEPOINT {sp2};',f'INSERT INTO {t} VALUES (3);']
    fx=p.fixture('transaction',[(t,['id'])],setup,['ROLLBACK;',f'DROP TABLE {t};'])
    if opening:
        p.dim('isolation',[('default',''),('committed','ISOLATION LEVEL READ COMMITTED'),
            ('uncommitted','ISOLATION LEVEL READ UNCOMMITTED'),('repeatable','ISOLATION LEVEL REPEATABLE READ'),
            ('serializable','ISOLATION LEVEL SERIALIZABLE')])
        p.dim('access',[('default',''),('write','READ WRITE'),('read','READ ONLY')])
        p.dim('work',[('none',''),('work','WORK'),('transaction','TRANSACTION')])
        begin=seq('BEGIN ',slot('work'),' ',slot('isolation'),' ',slot('access'))
        if command=='BEGIN':
            p.ast=begin
            p.manifest('finite',all_bindings(p),[fx])
        else:
            p.dim('form',[('start',''),('begin','')])
            p.dim('snapshot',[('none',''),('yes','WITH CONSISTENT SNAPSHOT')])
            p.ast=dict(kind='choice',selector='form',branches={p.vid('form','start'):
                seq('START TRANSACTION ',slot('isolation'),' ',slot('access'),' ',slot('snapshot')),p.vid('form','begin'):begin})
            bindings=all_bindings(p); bindings.update(form=['start'],work=['none'])
            p.manifest('start',bindings,[fx])
            bindings=all_bindings(p); bindings.update(form=['begin'],snapshot=['none'])
            p.manifest('begin',bindings,[fx])
            planned(p,'snapshot_warning','非可重复读级别的快照子句被忽略并告警，不是语法错误。','并产生告警',fx,
                [dict(sql='START TRANSACTION WITH CONSISTENT SNAPSHOT ISOLATION LEVEL READ COMMITTED;')],
                '成功并产生 ignored WARNING；目标消息待执行校准')
        planned(p,'isolation_alias','SERIALIZABLE 映射 REPEATABLE READ，而非真正可串行化隔离。',
            'SERIALIZABLE：',fx,[dict(action='分别开启别名隔离级别，读取实际隔离级别并验证并发可见性')],
            '语法成功不代表支持真正的 SERIALIZABLE 隔离',2)
        p.fact('uncommitted_alias','behavior_oracle','READ UNCOMMITTED 的行为等同 READ COMMITTED。','READ UNCOMMITTED：',2)
        p.files['scenarios/isolation_alias.scenario.yaml']['fact_refs'].append(p.fid('uncommitted_alias'))
    elif command in ('COMMIT','ROLLBACK'):
        p.dim('work',[('none',''),('work','WORK'),('transaction','TRANSACTION')])
        p.ast=seq(command+' ',slot('work'))
        p.manifest('finite',all_bindings(p),[fx])
        planned(p,'row_state','验证本事务写入是否保留，而不是只验证事务命令返回成功。',5,fx,
            [dict(sql=command+';'),dict(sql=f'SELECT id FROM {t} ORDER BY id;')],
            [[0],[1]] if command=='COMMIT' else [[0]],2)
        if command=='COMMIT':
            p.fact('authority','environment','提交者须为事务创建者或系统管理员；有限预备消费者仅采用同会话事务创建者。',8,2)
            p.exports=[p.fid('syntax'),p.fid('row_state'),p.fid('authority')]
    else:
        p.dim('name',[('first',sp1),('second',sp2)])
        if command=='SAVEPOINT':
            p.ast=seq('SAVEPOINT ',slot('name'))
        else:
            p.dim('savepoint_word',[('none',''),('yes','SAVEPOINT')])
            if command=='RELEASE SAVEPOINT':
                p.ast=seq('RELEASE ',slot('savepoint_word'),' ',slot('name'))
            else:
                p.dim('work',[('none',''),('work','WORK'),('transaction','TRANSACTION')])
                p.ast=seq('ROLLBACK ',slot('work'),' TO ',slot('savepoint_word'),' ',slot('name'))
        p.manifest('finite',all_bindings(p),[fx])
        if command=='SAVEPOINT':
            steps=[dict(sql=f'SAVEPOINT {sp1};'),dict(sql=f'INSERT INTO {t} VALUES (2);'),
                   dict(sql=f'ROLLBACK TO SAVEPOINT {sp1};'),dict(sql=f'SELECT id FROM {t} ORDER BY id;')]
            expected=[[0],[1]]
        else:
            target=f'RELEASE SAVEPOINT {sp1};' if command=='RELEASE SAVEPOINT' else f'ROLLBACK TO SAVEPOINT {sp1};'
            steps=[dict(sql=target),dict(sql=f'SELECT id FROM {t} ORDER BY id;')]
            expected=[[0],[1],[2],[3]] if command=='RELEASE SAVEPOINT' else [[0],[1]]
        planned(p,'savepoint_state','保存点操作必须在同一连接的事务中验证行集合。',5,fx,steps,expected,3)
    if command in ('START TRANSACTION','ROLLBACK'):
        p.exports=[p.fid('syntax')]
    return p


def describe():
    p=package('DESCRIBE','UTILITY','{DESCRIBE | DESC}',2)
    view=p.id+'_view'
    p.dim('keyword',[('describe','DESCRIBE'),('desc','DESC')])
    p.dim('target',[('table',SRC),('view',view)])
    p.dim('column',[('all',''),('id','id'),('wild_percent',"'i%'"),('wild_one',"'q_y'")])
    p.ast=seq(slot('keyword'),' ',slot('target'),' ',slot('column'))
    fx=p.fixture('view',[],[f'CREATE VIEW {view} AS SELECT id,qty FROM {SRC};'],[f'DROP VIEW {view};'],requires=[BASE])
    p.manifest('finite',all_bindings(p),[fx])
    planned(p,'column_metadata','DESCRIBE 默认展示全部列，也可按名称和通配符筛选。','默认情况下',fx,
        [dict(sql=f'DESCRIBE {SRC} id;')],
        '仅 id 列；核验 Field/Type/Null/Default，索引及生成列表现另设 fixture',3)
    return p


def table():
    p=package('TABLE','UTILITY',22,17)
    p.dim('order',[('none',''),('asc','ORDER BY id ASC'),('desc','ORDER BY 1 DESC')])
    p.dim('limit',[('none',''),('count','LIMIT 2'),('comma','LIMIT 1,2'),('offset','LIMIT 2 OFFSET 1')])
    p.dim('form',[('query',''),('set','')])
    p.dim('operator',[('union','UNION'),('all','UNION ALL'),('except','EXCEPT')])
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','query'):seq('TABLE '+SRC+' ',slot('order'),' ',slot('limit')),
        p.vid('form','set'):seq('TABLE '+SRC+' ',slot('operator'),' TABLE '+SRC)})
    p.fixtures.append(BASE)
    p.manifest('query',dict(form=['query'],order=['none','asc','desc'],limit=['none','count','comma','offset']),[BASE])
    p.manifest('set',dict(form=['set'],operator=['union','all','except']),[BASE])
    planned(p,'pagination','TABLE 等价 SELECT *；本批 ORDER/LIMIT 使用整数列与种子行。','TABLE table_name与SELECT',BASE,
        [dict(sql=f'TABLE {SRC} ORDER BY id LIMIT 1,2;')],[[2,20],[3,30]])
    p.fact('set_contract','constraint','集合运算左右列数相同、类型兼容；本批仅同一已知两整数列表自集合。',
        '参加集合操作的各查询结果的列数',2)
    p.scenario('heterogeneous_set',['set_contract'],[BASE],
        [dict(action='待接入共享输出列合同后，扩展不同表、不同列数/类型的正负向集合用例')],
        [dict(kind='target_error',expected='不兼容输出拒绝，目标错误尚未校准')])
    p.fact('scalar_scope','open_question','子查询示例的单列限制不可泛化为所有子查询都不能多列；需限定标量/IN上下文。',
        'M-Compatibility模式数据库不支持子查询结果包含多列',2,'needs_verification')
    return p


def packages():
    return ([namespace_create(c) for c in ('CREATE DATABASE','CREATE SCHEMA')]+
        [namespace_drop(c) for c in ('DROP DATABASE','DROP SCHEMA')]+[use()]+
        [drop_object(c) for c in ('DROP TABLE','DROP VIEW')]+[truncate(),rename_table()]+
        [transaction(c) for c in ('BEGIN','COMMIT','ROLLBACK','SAVEPOINT','RELEASE SAVEPOINT',
                                  'ROLLBACK TO SAVEPOINT','START TRANSACTION')]+[describe(),table()])


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--update',action='store_true')
    args=parser.parse_args()
    # Build and validate all local data before printing any patch.
    output=[]
    for p in packages():
        for name,obj in p.finish().items():
            path=ROOT/'specs'/p.category.lower()/p.id/name
            text=yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110)
            if path.exists():
                if not args.update: raise FileExistsError(path)
                old=path.read_text()
                if old==text: continue
                output.append('*** Update File: '+str(path))
                output.extend('@@' if line.startswith('@@') else line for line in
                    list(difflib.unified_diff(old.splitlines(),text.splitlines(),lineterm=''))[2:])
            else:
                output.append('*** Add File: '+str(path))
                output.extend('+'+line for line in text.splitlines())
    print('\n'.join(['*** Begin Patch']+output+['*** End Patch']))


if __name__=='__main__': main()
