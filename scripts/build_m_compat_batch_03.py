#!/usr/bin/env python3
"""Curated third M batch. Emits patches; does not execute or regex-convert SQL."""
import argparse
import difflib
from pathlib import Path
import sys
import yaml

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from scripts.build_m_compat_pilot import Package, seq, slot, repeat, BASE, SRC, VIEW, V

CORPUS=ROOT/'work/m_compat_batch_03/corpus'
EXISTING='m_b03_existing_seq'
SECOND='m_b03_existing_seq_two'
OWNER='m_b03_sequence_owner'
SHARED='fixture_m_create_sequence_existing'


def wrap_existing(p):
    fid='fixture_'+p.id+'_shared_sequence'
    p.files['fixtures/shared_sequence.fixture.yaml']=p.entity('fixture',fid,
        requires_fixture_refs=[SHARED],provides=dict(tables=[]),seed=dict(required=False,rows=[]),
        execution=dict(status='ready',mode='auto',note='展开 CREATE SEQUENCE 包的真实序列/表前置状态，不复制 DDL。'))
    p.fixtures.append(fid)
    return fid


def bindings(p):
    return {k:[c['values'][0]['id'].removeprefix(p.id+'_'+k+'_') for c in v['classes']]
            for k,v in p.dims.items()}


def create_sequence():
    p=Package('CREATE SEQUENCE','DDL',CORPUS)
    p.fact('authority','environment','被授予CREATE ANY SEQUENCE权限的用户可在public和用户模式创建序列。',
           '被授予CREATE ANY SEQUENCE权限的用户',2)
    p.fact('syntax','syntax','创建序列的增量、边界、起点、缓存、循环、重启与归属语法。','CREATE SEQUENCE name',6)
    p.fact('direction','syntax','正增量递增，负增量递减，缺省为 1。','指定序列的步长',3)
    p.fact('owned','lifecycle','OWNED BY 关联同一用户、同一模式的列，删列或表时关联序列被删除。','将序列和一个表的指定字段',3)
    p.fact('not_default','behavior_oracle','OWNED BY 不自动给列添加自增赋值。','仅仅是建立了表的',2)
    p.fact('no_cycle','behavior_oracle','NO CYCLE 到达上限后再次 nextval 报错；NOCYCLE 与 NO CYCLE 等价。','如果声明了NO CYCLE',3)
    p.fact('min_ambiguity','environment','原文递减最小值排版为-263-1，符号边界存在歧义；当前模型只用显式小整数范围，不生成默认边界。','递减序列的缺省值',2)
    p.fact('restart','environment','RESTART出现在语法但无参数语义说明；当前模型不生成RESTART，不推断CREATE时与START的优先级。','[ RESTART',1)
    p.facts[-1]['source_anchor']='2.4.2.8.15 L22-L27'
    p.exports=[p.fid('owned'),p.fid('not_default'),p.fid('authority')]
    p.dim('increment',[('up','INCREMENT BY 1'),('down','INCREMENT -1'),('step','INCREMENT BY 2')],'direction')
    p.dim('start',[('negative','START WITH -1'),('positive','START 1')])
    p.dim('cache',[('default',''),('one','CACHE 1'),('four','CACHE 4')])
    p.dim('cycle',[('default',''),('cycle','CYCLE'),('no','NO CYCLE'),('compact','NOCYCLE')])
    p.dim('owned',[('default',''),('none','OWNED BY NONE'),('column','OWNED BY m_create_sequence_owner.id')])
    p.ast=seq('CREATE SEQUENCE m_create_sequence_new ',slot('increment'),
        ' MINVALUE -10 MAXVALUE 10 ',slot('start'),' ',slot('cache'),' ',slot('cycle'),' ',slot('owned'))
    fx=p.fixture('new_target',[('m_create_sequence_owner',['id'])],
        ['CREATE TABLE m_create_sequence_owner (id INT);'],
        ['DROP SEQUENCE IF EXISTS m_create_sequence_new;','DROP TABLE m_create_sequence_owner;'])
    p.manifest('finite',bindings(p),[fx])
    p.fixture('existing',[(OWNER,['id'])],
        [f'CREATE TABLE {OWNER} (id INT);',
         f'CREATE SEQUENCE {EXISTING} MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;',
         f'CREATE SEQUENCE {SECOND} MINVALUE 1 MAXVALUE 100 START 5 CACHE 1;',
         f"SELECT nextval('{EXISTING}');"],
        [f'DROP SEQUENCE IF EXISTS {SECOND};',f'DROP SEQUENCE IF EXISTS {EXISTING};',f'DROP TABLE {OWNER};'])
    p.scenario('owned_lifecycle',['owned','not_default'],[fx],
        [dict(sql='CREATE SEQUENCE m_create_sequence_new OWNED BY m_create_sequence_owner.id;'),
         dict(sql='INSERT INTO m_create_sequence_owner VALUES (NULL);'),
         dict(sql='SELECT id FROM m_create_sequence_owner;')],
        [dict(kind='result_set',expected=[[None]])])
    p.scenario('exhaustion',['no_cycle'],[fx],
        [dict(sql='CREATE SEQUENCE m_create_sequence_new MINVALUE 1 MAXVALUE 2 START 2 NO CYCLE;'),
         dict(sql="SELECT nextval('m_create_sequence_new');"),dict(sql="SELECT nextval('m_create_sequence_new');")],
        [dict(kind='target_error',expected='第二次 nextval 超上限；错误身份需校准')])
    return p


def alter_sequence():
    p=Package('ALTER SEQUENCE','DDL',CORPUS)
    p.fact('syntax','syntax','MAXVALUE 分支与 CACHE 分支互斥且可省略，可后接 OWNED BY；OWNER TO 为独立分支。','ALTER SEQUENCE [',9)
    p.fact('authority','environment','序列所有者、获序列ALTER权限或ALTER ANY SEQUENCE权限的用户可修改序列。',
           '序列的所有者或者被授予了序列ALTER权限',2)
    p.fact('limited','constraint','当前只支持拥有者、归属列、最大值和 CACHE；不从 CREATE 复制其他参数。','当前版本仅支持修改',2)
    p.fact('cache_range','constraint','普通序列 CACHE 取值范围从 1 开始至 2^63-1。','取值范围：[1,',1)
    p.fact('outside_transaction','environment','修改 MAXVALUE 不支持事务、函数和存储过程上下文。','MAXVALUE不支持在事务',1)
    p.fact('bound_conflict','open_question','参数要求新 MAXVALUE 大于 last_value，但示例设置为已返回的 101；相等边界待核实。','新修改的最大值必须大于',2,'needs_verification')
    p.fact('large_diagram','open_question','PDF 物理页 2029 语法图含 LARGE，而相邻文本语法未列出；保留差异，本批只生成普通序列。','ALTER SEQUENCE [',1,'needs_verification')
    p.fact('cache_clear','lifecycle','修改 MAXVALUE 清空所有会话的序列 cache。','会清空该序列',1)
    p.fact('owned','lifecycle','OWNED BY NONE 解除关联，新的列关联替换旧关联。','使用这个选项后新的关联关系',3)
    p.fact('association_scope','environment','关联的表和序列必须由同一用户拥有，且处于同一模式。',
           '关联的表和序列的所有者必须是同一个用户',1)
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('change',[('max','MAXVALUE 200'),('no_max','NO MAXVALUE'),('compact','NOMAXVALUE'),
        ('cache_one','CACHE 1'),('cache_four','CACHE 4'),('cache_zero','CACHE 0')])
    p.dims['change']['classes'][-1]['values'][0]['validity']='invalid'
    p.dims['change']['classes'][-1]['values'][0]['fact_refs']=[p.fid('cache_range')]
    # Keep old candidate domain and default stable; the empty branch is used
    # only by the explicitly scoped detach manifest below.
    p.dims['change']['classes'].append(dict(id=p.vid('change','unchanged')+'_class',meaning='unchanged',
        values=[dict(id=p.vid('change','unchanged'),render='',representative=True,validity='valid',
                     properties={},fact_refs=[p.fid('syntax')])]))
    p.dim('owned',[('unchanged',''),('none','OWNED BY NONE'),('column',f'OWNED BY {OWNER}.id')])
    p.rule('cache_range',f"change != '{p.vid('change','cache_zero')}'",'cache_range')
    p.ast=seq('ALTER SEQUENCE ',slot('if_exists'),' '+EXISTING+' ',slot('change'),' ',slot('owned'))
    fx=wrap_existing(p)
    domain=bindings(p);domain['change'].remove('cache_zero');domain['change'].remove('unchanged')
    p.manifest('finite',domain,[fx])
    p.manifest('cache_zero',dict(change=['cache_zero'],owned=['unchanged'],if_exists=['none']),[fx],negative='cache_range')
    for obj in p.files.values():
        if obj['kind']=='manifest':
            obj['environment_requirements'].append(dict(key='execution_context',allowed_values=['top_level_autocommit'],
                fact_refs=[p.fid('outside_transaction')]))
    owned_fx=p.fixture('owned_source',[(OWNER,['id'])],
        [f'CREATE TABLE {OWNER} (id INT);',
         f'CREATE SEQUENCE {EXISTING} MINVALUE 1 MAXVALUE 100 START 5 CACHE 1 OWNED BY {OWNER}.id;'],
        [f'DROP SEQUENCE IF EXISTS {EXISTING};',f'DROP TABLE IF EXISTS {OWNER};'])
    p.manifest('detach_owned',dict(change=['unchanged'],owned=['none'],if_exists=['none']),[owned_fx])
    detach=p.files['manifests/detach_owned.manifest.yaml']
    detach['local_rules']=[dict(expression=f"change == '{p.vid('change','unchanged')}' and "
        f"owned == '{p.vid('owned','none')}' and if_exists == '{p.vid('if_exists','none')}'",
        rationale='本有限清单仅解除既有关联，不混入MAXVALUE/CACHE或缺失对象分支；不是产品全域禁止其他组合。',
        fact_refs=[p.fid('syntax'),p.fid('owned')])]
    detach['environment_requirements'].extend([
        dict(key='namespace',allowed_values=['isolated_user_schema'],fact_refs=[p.fid('association_scope')]),
        dict(key='object_authority',allowed_values=['case_object_owner'],fact_refs=[p.fid('authority')]),
        dict(key='sequence_creation_authority',allowed_values=['create_any_sequence'],
             fact_refs=['m_create_sequence::m_create_sequence_fact_authority']),
        dict(key='table_creation_authority',allowed_values=['create_any_table'],
             fact_refs=['m_create_table::m_create_table_fact_authority'])])
    p.scenario('cache_invalidation',['cache_clear'],[fx],
        [dict(action='两个独立会话预取序列 cache，再 ALTER MAXVALUE；检查其他会话重新取号')],
        [dict(kind='manual_assertion',expected='跨会话缓存被清空，序列行为不是单次 DDL 成功')])
    p.scenario('limited_attributes',['limited'],[fx],
        [dict(action='对未支持的 INCREMENT/START/RESTART 属性另建负向场景并校准目标错误')],
        [dict(kind='target_error',expected='不接受未支持属性；错误身份尚未确认')])
    p.scenario('association',['owned'],[owned_fx],
        [dict(sql=f'ALTER SEQUENCE {EXISTING} OWNED BY NONE;'),dict(sql=f'DROP TABLE {OWNER};'),
         dict(id='after_owner_drop',sql=f"SELECT nextval('{EXISTING}');")],
        [dict(kind='result_set',step_id='after_owner_drop',expected=[[5]])])
    association=p.files['scenarios/association.scenario.yaml']
    association['fact_refs'].append('m_create_sequence::m_create_sequence_fact_owned')
    association['preconditions'].append('同一创建者在独占用户Schema中创建两个全新对象；未提前调用nextval，START为5；禁止并发使用该序列。')
    return p


def drop_sequence():
    p=Package('DROP SEQUENCE','DDL',CORPUS)
    p.fact('syntax','syntax','DROP SEQUENCE 允许 IF EXISTS、多序列列表和 CASCADE/RESTRICT。','DROP [ LARGE ] SEQUENCE',1)
    p.fact('large','environment','LARGE 不能直接 CREATE LARGE SEQUENCE；只能由 AUTO_INCREMENT 自动生成。','当前不支持用户直接',2)
    p.fact('notice','behavior_oracle','IF EXISTS 遇到缺失序列发 notice，不是错误。','发出一个notice',1)
    p.fact('restrict','constraint','存在依赖时 RESTRICT 拒绝删除；CASCADE 删除依赖。','如果存在任何依赖',1)
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('targets',[('one','',dict(items=[EXISTING])),('two','',dict(items=[EXISTING,SECOND]))])
    p.dim('dependency',[('default',''),('cascade','CASCADE'),('restrict','RESTRICT')])
    p.ast=seq('DROP SEQUENCE ',slot('if_exists'),' ',repeat('targets'),' ',slot('dependency'))
    fx=wrap_existing(p)
    p.manifest('finite',bindings(p),[fx])
    p.scenario('absent_notice',['notice'],[fx],
        [dict(sql='DROP SEQUENCE IF EXISTS m_drop_sequence_absent;')],
        [dict(kind='manual_assertion',expected='成功并产生 notice；不是任意错误通过')])
    p.scenario('dependent_default',['restrict'],[fx],
        [dict(action='创建 DEFAULT nextval 依赖列，分别验证 RESTRICT 拒绝与 CASCADE 依赖处置')],
        [dict(kind='target_error',expected='目标依赖错误待校准；不在正向空依赖 fixture 中宣称覆盖')])
    p.scenario('large_identity',['large'],[],
        [dict(action='从 M AUTO_INCREMENT 原文建立隐式 LARGE 序列的发现与定向删除契约')],
        [dict(kind='manual_assertion',expected='仅删除本 case 创建的隐式 LARGE 序列，未实现该分支')])
    return p


def prepare():
    p=Package('PREPARE','UTILITY',CORPUS)
    p.fact('syntax','syntax','M 使用 PREPARE name FROM 字符串，而不是通用 AS 形式。','PREPARE name FROM')
    p.fact('bodies','syntax','预备 SQL 字符串允许 SELECT/INSERT/UPDATE/DELETE。','–    SELECT',4)
    # Documented body families are source facts, not executable SQL profiles.
    # Their nested alternatives still need individual fixtures and coverage.
    for suffix, body in (
        ('alter_database', 'ALTER [SCHEMA|DATABASE]'),
        ('alter_relation', 'ALTER [TABLE|VIEW|INDEX]'),
        ('alter_user', 'ALTER USER'), ('create_table', 'CREATE TABLE'),
        ('create_user', 'CREATE USER'), ('create_database', 'CREATE [SCHEMA|DATABASE]'),
        ('drop_relation', 'DROP [TABLE|VIEW|INDEX|SCHEMA|DATABASE]'),
        ('drop_user', 'DROP USER'), ('privilege', '[GRANT|REVOKE]'),
        ('create_index', 'CREATE INDEX'), ('commit', 'COMMIT'),
        ('truncate', 'TRUNCATE TABLE'), ('set', 'SET'),
        ('create_view', 'CREATE VIEW'), ('analyze', 'ANALYZE'),
    ):
        p.fact('body_'+suffix, 'syntax', '预备 SQL 字符串支持 '+body+' 语句族；'
               + {'analyze':'本包仅覆盖指定普通行存表的 ANALYZE 代表，不包含 VERIFY 或全库分析。',
                  'truncate':'本包仅覆盖指定普通单表的 TRUNCATE TABLE PURGE 代表，不包含分区、继承或CASCADE。',
                  'create_index':'本包仅覆盖普通表单个整数直接键BTREE代表，不包括分区、表达式或算法锁语义。',
                  'create_view':'本包仅覆盖普通表两列直接投影的新视图代表，不包括替换、FORCE或检查选项。',
                  'create_table':'本包仅覆盖专属新模式下两INTEGER列普通新表的预备代表；不含IF NOT EXISTS、临时、分区或约束分支。',
                  'create_database':'本包仅覆盖CREATE SCHEMA创建新命名空间的预备代表；不含DATABASE拼写、IF NOT EXISTS、字符集或字符序选项，不是物理建库。',
                  'alter_relation':'本包仅覆盖ALTER TABLE新增一个可空INTEGER列代表，ALTER VIEW和INDEX仍待补。',
                  'set':'本包仅覆盖SET SESSION TIME ZONE PRC代表，不推断用户变量或其他参数可预备。',
                  'commit':'本包仅预备同会话COMMIT；解析不提交，实际执行与回滚阶段由独立场景验证。',
                  'drop_relation':'本包仅覆盖独占新模式内普通TABLE PURGE、VIEW、INDEX及独占空SCHEMA的预备代表；不含DATABASE拼写、在线、级联或其他删除形态。'
                 }.get(suffix,'尚无本包有限代表测试。'),
               '–    '+body)
    p.fact('database_owner_limit','constraint',
           '预备 ALTER SCHEMA/DATABASE 支持修改数据库字符集字符序，不支持修改数据库所有者。',
           '支持修改数据库字符集字符序')
    p.fact('prepare_phase','lifecycle','PREPARE 阶段解析、分析、重写查询，不等于已经执行预备 SQL。',
           '预备语句是服务端的对象',2)
    p.fact('execute_phase','lifecycle','随后 EXECUTE 阶段对预备语句进行规划和执行。',
           '查询被解析、分析、重写',2)
    p.fact('body_profile_gap','open_question',
           '原文明示额外语句族受支持，但各子分支的真实前置条件、有限代表与目标预期尚未建模；不是判为不支持。',
           '–    ALTER [SCHEMA|DATABASE]',1,'needs_verification')
    p.fact('session','environment','预备语句会话内存活，回滚不删除；DEALLOCATE 或会话结束才释放。','PREPARE语句创建后',5)
    p.fact('duplicate','constraint','不支持同名 PREPARE。','不支持创建同名')
    p.fact('variable','constraint','FROM 不支持用户变量 @var_name。','不支持使用用户变量')
    p.exports=[p.fid('session')]
    # Only implemented bodies belong to the finite AST, not every documented family.
    p.syntax_fact_refs=[p.fid('syntax'),p.fid('bodies'),p.fid('body_analyze'),p.fid('body_truncate'),
                       p.fid('body_create_index'),p.fid('body_create_view'),p.fid('body_alter_relation'),p.fid('body_set'),p.fid('body_commit'),p.fid('body_create_table')]
    t='m_prepare_data'; name='m_prepare_stmt'
    ddl_representatives=[
        ('create_index',f'CREATE INDEX m_prepare_created_idx USING BTREE ON {t} (id)',
         'm_create_index','create_any_index',['id']),
        ('create_view',f'CREATE VIEW m_prepare_created_view AS SELECT id,qty FROM {t}',
         'm_create_view','create_any_table',['id','qty']),
        ('alter_relation',f'ALTER TABLE {t} ADD COLUMN extra INTEGER',
         'm_alter_table','fixture_table_creator',[])]
    p.matrix_dim('body',[
        ('select',f"'SELECT id,qty FROM {t} WHERE id=1'",dict(source_tables=[t],source_columns=['id','qty'],output_column_count=2)),
        ('insert',f"'INSERT INTO {t} (id,qty) VALUES (3,30)'",dict(source_tables=[t],source_columns=['id','qty'])),
        ('update',f"'UPDATE {t} SET qty=11 WHERE id=1'",dict(source_tables=[t],source_columns=['id','qty'])),
        ('delete',f"'DELETE FROM {t} WHERE id=2'",dict(source_tables=[t],source_columns=['id']))],'bodies')
    p.files['matrices/body.matrix.yaml']['documented_features'] = [
        dict(id=p.id+'_feature_'+fact['id'].removeprefix(p.id+'_fact_'),
             status='needs_profile', fact_refs=[fact['id'],p.fid('body_profile_gap')]
             + ([p.fid('database_owner_limit')] if fact['id']==p.fid('body_alter_database') else []))
        for fact in p.facts if fact['id'].startswith(p.fid('body_'))
        and fact['type']=='syntax'
    ]
    matrix=p.files['matrices/body.matrix.yaml']
    matrix['profiles'].append(dict(id=p.vid('body','analyze'),render=f"'ANALYZE {t}'",validity='valid',
        properties=dict(source_tables=[t],source_columns=['id','qty']),fact_refs=[p.fid('body_analyze')]))
    matrix['profiles'].append(dict(id=p.vid('body','truncate'),render=f"'TRUNCATE TABLE {t} PURGE'",validity='valid',
        properties=dict(source_tables=[t],source_columns=['id','qty']),fact_refs=[p.fid('body_truncate')]))
    for suffix,sql,provider,authority,columns in ddl_representatives:
        matrix['profiles'].append(dict(id=p.vid('body',suffix),render="'"+sql+"'",validity='valid',
            properties=dict(source_tables=[t],source_columns=columns),fact_refs=[p.fid('body_'+suffix)]))
    set_body="'SET SESSION TIME ZONE ''PRC'''"
    matrix['profiles'].append(dict(id=p.vid('body','set_timezone'),render=set_body,validity='valid',
        properties=dict(source_tables=[],source_columns=[]),
        fact_refs=[p.fid('body_set'),'m_set::m_set_fact_timezone']))
    matrix['profiles'].append(dict(id=p.vid('body','commit'),render="'COMMIT'",validity='valid',
        properties=dict(source_tables=['m_commit_data'],source_columns=['id']),
        fact_refs=[p.fid('body_commit'),'m_commit::m_commit_fact_syntax']))
    ct_ns='m_prepare_ct_namespace';ct_table=ct_ns+'.created_table'
    ct_body="'CREATE TABLE "+ct_table+" (id INTEGER, qty INTEGER)'"
    matrix['profiles'].append(dict(id=p.vid('body','create_table'),render=ct_body,validity='valid',
        properties=dict(source_tables=[],source_columns=[]),
        fact_refs=[p.fid('body_create_table'),'m_create_table::m_create_table_fact_syntax',
                   'm_create_table::m_create_table_fact_authority']))
    for feature in matrix['documented_features']:
        if feature['id'] in {p.id+'_feature_body_'+s for s in ('analyze','truncate','create_index','create_view','alter_relation','commit','create_table')}:
            suffix=feature['id'].removeprefix(p.id+'_feature_body_')
            feature.update(status='covered',coverage_mode='representative',
                           profile_refs=[p.vid('body',suffix)],fact_refs=[p.fid('body_'+suffix)])
        elif feature['id']==p.id+'_feature_body_set':
            feature.update(status='covered',coverage_mode='representative',
                profile_refs=[p.vid('body','set_timezone')],fact_refs=[p.fid('body_set')])
    p.ast=seq('PREPARE '+name+' FROM ',slot('body'))
    fx=p.fixture('target',[(t,['id','qty'])],[f'CREATE TABLE {t} (id INT,qty INT);',f'INSERT INTO {t} VALUES (1,10),(2,20);'],
        [f'DEALLOCATE PREPARE {name};',f'DROP TABLE {t};'])
    p.manifest('finite',dict(body=['select','insert','update','delete']),[fx])
    p.files['manifests/finite.manifest.yaml']['environment_requirements'].append(dict(key='session_lifecycle',
        allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]))
    analyze_fx=p.fixture('analyze_row_target',[(t,['id','qty'])],
        [f'CREATE TABLE {t} (id INT,qty INT) WITH (ORIENTATION = ROW);',
         f'INSERT INTO {t} VALUES (1,10),(2,20);'],
        [f'DEALLOCATE PREPARE {name};',f'DROP TABLE {t};'])
    p.manifest('analyze',dict(body=['analyze']),[analyze_fx])
    p.files['manifests/analyze.manifest.yaml']['environment_requirements'] += [
        dict(key='session_lifecycle',allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]),
        dict(key='table_authority',allowed_values=['fixture_table_creator'],
             fact_refs=['m_analyze::m_analyze_fact_owner']),
        dict(key='execution_context',allowed_values=['ordinary_analyze_prepare'],
             fact_refs=['m_analyze::m_analyze_fact_transaction']),
        dict(key='table_storage',allowed_values=['row'],
             fact_refs=['m_analyze::m_analyze_fact_row_storage'])]
    p.manifest('truncate',dict(body=['truncate']),[fx])
    p.files['manifests/truncate.manifest.yaml']['environment_requirements'] += [
        dict(key='session_lifecycle',allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]),
        dict(key='table_authority',allowed_values=['fixture_table_creator'],
             fact_refs=['m_truncate::m_truncate_fact_owner'])]
    for suffix,sql,provider,authority,columns in ddl_representatives:
        p.manifest(suffix,dict(body=[suffix]),[fx])
        manifest=p.files['manifests/'+suffix+'.manifest.yaml']
        manifest['description']='仅PREPARE，不EXECUTE；实际执行需重新建立目标对象及清理契约。新索引/视图名必须未占用；独占public或用户测试模式，不能访问系统模式或既有对象。'
        manifest['environment_requirements'] += [
            dict(key='session_lifecycle',allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]),
            dict(key='ddl_authority',allowed_values=[authority],fact_refs=[provider+'::'+provider+'_fact_authority'])]
        if suffix in ('create_index','create_view'):
            manifest['environment_requirements'].append(dict(key='namespace_scope',
                allowed_values=['isolated_public_or_user_schema'],fact_refs=[provider+'::'+provider+'_fact_authority']))
    p.scenario('truncate_execution',['session','prepare_phase','execute_phase'],[fx],
        [dict(id='prepare',sql=f"PREPARE {name} FROM 'TRUNCATE TABLE {t} PURGE';"),
         dict(id='before_execute',sql=f'SELECT COUNT(*) FROM {t};'),
         dict(id='execute',sql=f'EXECUTE {name};'),
         dict(id='after_execute',sql=f'SELECT COUNT(*) FROM {t};')],
        [dict(kind='result_set',step_id='before_execute',expected=[[2]]),
         dict(kind='result_set',step_id='after_execute',expected=[[0]])])
    scenario=p.files['scenarios/truncate_execution.scenario.yaml']
    scenario['fact_refs'] += ['m_truncate::m_truncate_fact_owner','m_truncate::m_truncate_fact_rows_removed',
                             'm_truncate::m_truncate_fact_purge']
    scenario['execution_requirements'] += ['isolated_connection','fixture_table_creator','actual_cleanup_evidence']
    scenario['description']='PREPARE之后两行仍在，EXECUTE后才清空；只使用本case新表与PURGE，不碰既有表或回收站。仍planned、未执行。'
    set_fx=p.fixture('set_timezone',[],['SHOW TimeZone;'],[f'DEALLOCATE PREPARE {name};'],
        requires=['fixture_m_set_transaction'])
    p.files['fixtures/set_timezone.fixture.yaml']['execution']['note']=(
        '先展开M SET的START TRANSACTION，再SHOW TimeZone验证当前会话参数可读；本包只PREPARE，不提前执行SET。'
        '清理先DEALLOCATE再由共享Fixture ROLLBACK，最后关闭独占连接；预备语句不会靠ROLLBACK释放。')
    p.manifest('set_timezone',dict(body=['set_timezone']),[set_fx])
    set_manifest=p.files['manifests/set_timezone.manifest.yaml']
    set_manifest['description']='仅预备SESSION时区PRC语句，不EXECUTE；不推广至用户变量、其他配置或编码。实际时区结果待独立阶段Oracle验证。'
    set_manifest['environment_requirements'].append(dict(key='session_lifecycle',
        allowed_values=['isolated_connection'],fact_refs=[p.fid('session'),'m_set::m_set_fact_session']))
    p.scenario('set_phase',['session','prepare_phase','execute_phase'],[set_fx],
        [dict(id='baseline',sql='SHOW TimeZone;'),
         dict(id='prepare',sql=f'PREPARE {name} FROM {set_body};'),
         dict(id='after_prepare',sql='SHOW TimeZone;'),
         dict(id='execute',sql=f'EXECUTE {name};'),
         dict(id='after_execute',sql='SHOW TimeZone;')],
        [dict(kind='manual_assertion',expected='after_prepare与baseline一致；after_execute为PRC对应的时区语义。'
              '不要猜测SHOW的返回规范化拼写；清理ROLLBACK恢复事前参数，但仍必须显式释放预备语句。')])
    set_scenario=p.files['scenarios/set_phase.scenario.yaml']
    set_scenario['fact_refs'].append('m_set::m_set_fact_session')
    set_scenario['execution_requirements'] += ['isolated_connection','per_step_oracle','close_case_connection']
    commit_fx=p.fixture('commit',[],['SELECT COUNT(*) FROM m_commit_data;'],
        [f'DEALLOCATE PREPARE {name};'],requires=['fixture_m_commit_transaction'])
    p.files['fixtures/commit.fixture.yaml']['execution']['note']=(
        '依赖COMMIT包真实建表/种子/BEGIN/未提交INSERT，COUNT记录前置行数，不代替结果断言。'
        '目标只PREPARE；先DEALLOCATE，再逆序由依赖ROLLBACK、DROP自己的表。须独占同会话、事务创建者，setup失败不授权清理。')
    p.manifest('commit',dict(body=['commit']),[commit_fx])
    p.files['manifests/commit.manifest.yaml']['description']='只PREPARE COMMIT，不在setup或目标阶段EXECUTE或COMMIT；真实提交效果由planned阶段场景验证。'
    p.files['manifests/commit.manifest.yaml']['environment_requirements'] += [
        dict(key='session_lifecycle',allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]),
        dict(key='transaction_authority',allowed_values=['transaction_creator'],fact_refs=['m_commit::m_commit_fact_authority'])]
    p.scenario('commit_phase',['session','prepare_phase','execute_phase'],[commit_fx],
        [dict(id='prepare',sql=f"PREPARE {name} FROM 'COMMIT';"),
         dict(id='rollback_prepared',sql='ROLLBACK;'),
         dict(id='after_prepare_rollback',sql='SELECT id FROM m_commit_data ORDER BY id;'),
         dict(id='new_transaction',sql='BEGIN;'),dict(id='new_write',sql='INSERT INTO m_commit_data VALUES (1);'),
         dict(id='execute',sql=f'EXECUTE {name};'),dict(id='rollback_after_execute',sql='ROLLBACK;'),
         dict(id='after_execute_rollback',sql='SELECT id FROM m_commit_data ORDER BY id;')],
        [dict(kind='result_set',step_id='after_prepare_rollback',expected=[[0]]),
         dict(kind='result_set',step_id='after_execute_rollback',expected=[[0],[1]])])
    commit_scenario=p.files['scenarios/commit_phase.scenario.yaml']
    commit_scenario['fact_refs'] += ['m_commit::m_commit_fact_row_state','m_commit::m_commit_fact_authority']
    commit_scenario['execution_requirements'] += ['isolated_connection','transaction_creator','per_step_oracle','close_case_connection']
    commit_scenario['description']='PREPARE后回滚应撤销1而保留0；同一预备语句EXECUTE提交第二次写入后，ROLLBACK不能撤销。记录无活动事务ROLLBACK消息，不把预期WARNING当目标错误。仍planned，未执行。'
    ct_fx=p.fixture('create_table_namespace',[],[f'CREATE SCHEMA {ct_ns};'],
        [f'DEALLOCATE PREPARE {name};',f'DROP SCHEMA {ct_ns};'])
    p.files['fixtures/create_table_namespace.fixture.yaml']['execution']['note']=(
        '只创建独占新模式，不预建目标表；模式名不得与任何用户同名，避免对象归属偏移。'
        '只PREPARE的用例清理预备语句和空模式，不DROP尚未创建的表。若目标失败须确认prepared归属，'
        '若未来EXECUTE场景中途失败须记录实际创建阶段，只清理本case拥有资产；不得CASCADE或DROP OWNED兜底。')
    p.manifest('create_table',dict(body=['create_table']),[ct_fx])
    ct_manifest=p.files['manifests/create_table.manifest.yaml']
    ct_manifest['description']='仅PREPARE专属模式两INTEGER列普通新表，目标表尚不存在；创建行为、行值和对象目录由独立planned场景检查。'
    ct_manifest['environment_requirements'] += [
        dict(key='session_lifecycle',allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]),
        dict(key='namespace_authority',allowed_values=['database_create_non_user_named_fresh_schema'],
             fact_refs=['m_create_schema::m_create_schema_fact_authority','m_create_schema::m_create_schema_fact_namespace',
                        'm_create_schema::m_create_schema_fact_same_name_owner']),
        dict(key='ddl_authority',allowed_values=['create_any_table'],fact_refs=['m_create_table::m_create_table_fact_authority'])]
    p.scenario('create_table_phase',['session','prepare_phase','execute_phase','body_create_table'],[ct_fx],
        [dict(id='prepare',sql=f'PREPARE {name} FROM {ct_body};'),
         dict(id='before_execute',action='读取目标模式的真实表目录：created_table应不存在；目录查询接口须先校准，不用SELECT不存在表触发错误代替。'),
         dict(id='execute',sql=f'EXECUTE {name};'),
         dict(id='seed',sql=f'INSERT INTO {ct_table} VALUES (1,10),(2,20);'),
         dict(id='read_rows',sql=f'SELECT id,qty FROM {ct_table} ORDER BY id;'),
         dict(id='drop_target',sql=f'DROP TABLE {ct_table};')],
        [dict(kind='manual_assertion',step_id='before_execute',expected='预备后目标表不存在；实际目录方法待校准。'),
         dict(kind='result_set',step_id='read_rows',expected=[[1,10],[2,20]])])
    ct_scenario=p.files['scenarios/create_table_phase.scenario.yaml']
    ct_scenario['fact_refs'] += ['m_create_schema::m_create_schema_fact_namespace',
        'm_create_schema::m_create_schema_fact_authority','m_create_schema::m_create_schema_fact_same_name_owner',
        'm_create_table::m_create_table_fact_authority']
    ct_scenario['execution_requirements'] += ['isolated_connection','per_step_oracle','ownership_scoped_cleanup']
    ct_scenario['description']='PREPARE不等于建表；EXECUTE后才INSERT/SELECT，最后先清理实际创建的目标表再释放prepared和空模式。任何中途失败都必须按实际资产归属收尾。仍planned，未执行。'
    p.scenario('rollback_survival',['session','prepare_phase','execute_phase'],[fx],
        [dict(sql='BEGIN;'),dict(sql=f"PREPARE {name} FROM 'SELECT id FROM {t} ORDER BY id';"),
         dict(sql='ROLLBACK;'),dict(sql=f'EXECUTE {name};')],
        [dict(kind='result_set',expected=[[1],[2]])])
    duplicate=p.fixture('duplicate_prepared',[],
        ["PREPARE m_prepare_duplicate FROM 'SELECT 1';"],
        ['DEALLOCATE PREPARE m_prepare_duplicate;'])
    variable='fixture_m_prepare_prepare_string'
    p.files['fixtures/prepare_string.fixture.yaml']=p.entity('fixture',variable,
        requires_fixture_refs=['fixture_m_set_prepare_string'],provides=dict(tables=[]),
        seed=dict(required=False,rows=[]),execution=dict(status='ready',mode='auto',
            note='借用M SET的真实字符串变量前置；目标名必须不存在。无论目标结果如何均关闭本case独占连接；'
                 '不能对预计不存在的预备语句无条件DEALLOCATE，也不能复用残留连接。'))
    p.fixtures.append(variable)
    for suffix, fact, fixture, sql, category in (
        ('duplicate_and_variable','duplicate',duplicate,
         "PREPARE m_prepare_duplicate FROM 'SELECT 2';",'duplicate_prepared_statement'),
        ('variable_from','variable',variable,
         'PREPARE m_prepare_variable FROM @m_prepare_sql;','prepare_user_variable'),
    ):
        p.scenario(suffix,[fact,'session'],[fixture],
            [dict(id='target',sql=sql,expected='error')],
            [dict(kind='target_error',step_id='target',stage='target',expected='error',
                  error_category=category,oracle_status='needs_verification',sqlstates=[])])
        scenario=p.files['scenarios/'+suffix+'.scenario.yaml']
        scenario['execution_requirements'] += ['isolated_connection','close_case_connection']
        scenario['description']='只接受目标步骤对应错误，setup失败不能代替；SQLSTATE/类别匹配尚未校准，仍未执行。'
    p.files['scenarios/duplicate_and_variable.scenario.yaml']['name']='同名 PREPARE 负例（保留历史场景ID）'
    p.files['scenarios/variable_from.scenario.yaml']['fact_refs'].append('m_set::m_set_fact_user_variable_types')
    add_prepared_drop_profiles(p)
    add_prepared_create_namespace_profile(p)
    add_prepared_drop_namespace_profile(p)
    return p


def add_prepared_drop_namespace_profile(p):
    """A finite empty namespace, distinct from relation or physical DB assets."""
    name='m_prepare_stmt'; ns='m_prepare_drop_namespace'
    body='DROP SCHEMA '+ns
    matrix=p.files['matrices/body.matrix.yaml']
    matrix['profiles'].append(dict(id=p.vid('body','drop_namespace'),render="'"+body+"'",validity='valid',
        properties=dict(source_tables=[],source_columns=[]),
        fact_refs=[p.fid('body_drop_relation'),'m_drop_schema::m_drop_schema_fact_syntax']))
    feature=next(f for f in matrix['documented_features'] if f['id']==p.id+'_feature_body_drop_relation')
    feature['profile_refs'].append(p.vid('body','drop_namespace'))
    fx=p.fixture('drop_namespace',[],['SHOW search_path;',f'CREATE SCHEMA {ns};'],
        [f'DEALLOCATE PREPARE {name};',f'DROP SCHEMA IF EXISTS {ns};'])
    p.files['fixtures/drop_namespace.fixture.yaml']['execution']['note']=(
        '仅在已授权M物理测试数据库独占连接内新建目标空模式，名称初始不存在、非系统名、非任何用户同名且不在search_path中。'
        '真实setup不创建表，不提前PREPARE或EXECUTE；全程不USE此模式。目标只PREPARE，所以模式应仍存在且为空。'
        '清理必须先确认本case资产归属与实际阶段；prepared仅成功创建后释放。仅本case新建且仍为空、非当前、无外部依赖的模式可清理。'
        'IF EXISTS不是归属证明，不得清理同名外部或并发重建的模式；setup失败不能盲目执行teardown。'
        '场景EXECUTE成功后模式已消失则跳过该清理，不把任意异常当已删除；关闭专属连接，ROLLBACK不能释放prepared。')
    p.manifest('drop_namespace',dict(body=['drop_namespace']),[fx])
    manifest=p.files['manifests/drop_namespace.manifest.yaml']
    manifest['description']='只PREPARE本case独占空模式的DROP SCHEMA，不EXECUTE；不是物理数据库删除，不覆盖DATABASE同义拼写或非空模式。'
    manifest['environment_requirements'] += [
        dict(key='session_lifecycle',allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]),
        dict(key='namespace_authority',allowed_values=['database_create_non_user_named_fresh_schema'],
             fact_refs=['m_create_schema::m_create_schema_fact_authority',
                        'm_create_schema::m_create_schema_fact_namespace',
                        'm_create_schema::m_create_schema_fact_same_name_owner']),
        dict(key='drop_authority',allowed_values=['fixture_namespace_creator'],
             fact_refs=['m_drop_schema::m_drop_schema_fact_authority']),
        dict(key='asset_scope',allowed_values=['fresh_non_system_non_user_namespace_outside_search_path'],
             fact_refs=['m_create_schema::m_create_schema_fact_namespace',
                        'm_create_schema::m_create_schema_fact_same_name_owner'])]
    p.scenario('drop_namespace_phase',['session','prepare_phase','execute_phase','body_drop_relation'],[fx],
        [dict(id='before_prepare',action='校准目录确认setup确实新建本case所有的空模式，非当前模式、无同名用户、不在search_path中；保存物理数据库及非目标模式身份。'),
         dict(id='prepare',sql=f"PREPARE {name} FROM '{body}';"),
         dict(id='after_prepare',action='同一校准目录确认目标空模式仍存在且归属不变；再次排除并发、当前模式和外部依赖，满足后才可EXECUTE。'),
         dict(id='execute',sql=f'EXECUTE {name};'),
         dict(id='after_execute',action='校准目录确认仅目标模式消失，物理数据库和其他模式不变；若目标已消失跳过模式清理，只释放本case prepared并关闭连接。')],
        [dict(kind='manual_assertion',step_id='before_prepare',expected='setup新建空模式且资产身份/权限满足；目录方法尚待校准。'),
         dict(kind='manual_assertion',step_id='after_prepare',expected='PREPARE后目标仍存在且为空；不得把预备成功当已删除。'),
         dict(kind='manual_assertion',step_id='after_execute',expected='EXECUTE后仅目标模式消失，物理数据库及非目标模式保持；不得以任意报错替代目录结果。')])
    scenario=p.files['scenarios/drop_namespace_phase.scenario.yaml']
    scenario['fact_refs'] += ['m_create_schema::m_create_schema_fact_namespace',
        'm_create_schema::m_create_schema_fact_authority','m_create_schema::m_create_schema_fact_same_name_owner',
        'm_drop_schema::m_drop_schema_fact_authority']
    scenario['execution_requirements'] += ['isolated_connection','per_step_oracle','ownership_scoped_cleanup',
        'actual_catalog_calibration','close_case_connection']
    scenario['preconditions'] += ['独占测试库和连接；新模式无同名用户、非系统名、不在search_path中；不允许并发重建。',
        'CREATE/DROP权限与真实归属先确认；目录接口先校准，任意阶段失败均阻止后续目标及盲目清理。']
    scenario['description']='planned：只处理本case新建空SCHEMA，PREPARE后仍在、EXECUTE后才消失。目录Oracle未校准、未执行；不授权物理数据库或共享模式删除。'


def add_prepared_create_namespace_profile(p):
    """One new namespace body, with preparation separate from namespace DDL."""
    name='m_prepare_stmt'; ns='m_prepare_created_namespace'
    body='CREATE SCHEMA '+ns
    matrix=p.files['matrices/body.matrix.yaml']
    p.syntax_fact_refs.append(p.fid('body_create_database'))
    matrix['profiles'].append(dict(id=p.vid('body','create_namespace'),render="'"+body+"'",validity='valid',
        properties=dict(source_tables=[],source_columns=[]),
        fact_refs=[p.fid('body_create_database'),'m_create_schema::m_create_schema_fact_syntax']))
    feature=next(f for f in matrix['documented_features'] if f['id']==p.id+'_feature_body_create_database')
    feature.update(status='covered',coverage_mode='representative',
        profile_refs=[p.vid('body','create_namespace')],fact_refs=[p.fid('body_create_database')])
    fx=p.fixture('create_namespace',[],['SHOW search_path;'],[f'DEALLOCATE PREPARE {name};'])
    p.files['fixtures/create_namespace.fixture.yaml']['execution']['note']=(
        '在已授权的M物理数据库独占连接内记录search_path；不提前创建目标模式，不用SELECT 1充当前置。'
        '目标模式须不存在、非系统名、不与任何用户同名且不在search_path中，以免创建后隐式成为当前模式。'
        '本候选只PREPARE，不DROP尚未创建的模式；prepared仅成功创建后按本case归属释放。'
        'setup或目标失败须记录实际阶段，不盲目清理；关闭本case连接，不靠ROLLBACK恢复预备语句。')
    p.manifest('create_namespace',dict(body=['create_namespace']),[fx])
    manifest=p.files['manifests/create_namespace.manifest.yaml']
    manifest['description']='只PREPARE新命名空间的CREATE SCHEMA；不是物理数据库创建，也不提前EXECUTE。CREATE DATABASE同义拼写及其他子分支仍未选择。'
    manifest['environment_requirements'] += [
        dict(key='session_lifecycle',allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]),
        dict(key='namespace_authority',allowed_values=['database_create_non_user_named_fresh_schema'],
             fact_refs=['m_create_schema::m_create_schema_fact_authority',
                        'm_create_schema::m_create_schema_fact_namespace',
                        'm_create_schema::m_create_schema_fact_same_name_owner']),
        dict(key='asset_scope',allowed_values=['fresh_non_system_non_user_namespace_outside_search_path'],
             fact_refs=['m_create_schema::m_create_schema_fact_namespace',
                        'm_create_schema::m_create_schema_fact_same_name_owner'])]
    p.scenario('create_namespace_phase',['session','prepare_phase','execute_phase','body_create_database'],[fx],
        [dict(id='before_prepare',action='通过校准的模式目录确认目标不存在且非当前模式；保存连接、数据库身份及search_path，确认无同名用户。'),
         dict(id='prepare',sql=f"PREPARE {name} FROM '{body}';"),
         dict(id='after_prepare',action='通过同一校准目录确认目标模式仍不存在；不能用查询不存在对象的任意错误代替。'),
         dict(id='execute',sql=f'EXECUTE {name};'),
         dict(id='after_execute',action='通过校准目录确认目标模式已创建、归本case执行主体、为空且不是current_schema；物理数据库身份保持。'),
         dict(id='before_cleanup',action='再次确认仅本case创建的目标模式仍为空、不是current_schema、无并发或外部依赖；否则阻止DROP并记录。'),
         dict(id='drop_target',sql=f'DROP SCHEMA {ns};'),
         dict(id='after_cleanup',action='通过校准目录确认目标模式消失，原物理数据库和其他模式保持；随后fixture释放本case预备语句并关闭连接。')],
        [dict(kind='manual_assertion',step_id='before_prepare',expected='目标模式不存在；专属M连接、名称唯一性及归属前置满足。'),
         dict(kind='manual_assertion',step_id='after_prepare',expected='PREPARE后仍不存在；不是建库或模式执行成功证据。'),
         dict(kind='manual_assertion',step_id='after_execute',expected='EXECUTE后才创建空模式；归属正确且物理数据库未变。'),
         dict(kind='manual_assertion',step_id='before_cleanup',expected='目标确由本case创建、为空、非当前模式；否则不运行清理。'),
         dict(kind='manual_assertion',step_id='after_cleanup',expected='只删除目标模式；其他模式和物理数据库保持。目录接口与结果均待实机校准。')])
    scenario=p.files['scenarios/create_namespace_phase.scenario.yaml']
    scenario['fact_refs'] += ['m_create_schema::m_create_schema_fact_namespace',
        'm_create_schema::m_create_schema_fact_authority','m_create_schema::m_create_schema_fact_same_name_owner',
        'm_drop_schema::m_drop_schema_fact_authority']
    scenario['execution_requirements'] += ['isolated_connection','per_step_oracle','ownership_scoped_cleanup',
        'actual_catalog_calibration','close_case_connection']
    scenario['preconditions'] += ['目标不存在且非系统名、非任何用户名、不在search_path中；全程不切换到目标模式。',
        '具备当前数据库CREATE权限及新模式DROP权限；目录接口先校准，任何前置或阶段失败须阻止后续目标和盲目清理。']
    scenario['description']='独立planned阶段验证：PREPARE前后不存在，EXECUTE才创建，再按归属清理。所有目录检查尚待校准，不能自动执行人工步骤或用任意错误当通过；不授权物理建库或共享模式清理。'


def add_prepared_drop_profiles(p):
    """Three ordinary owned-object bodies, never execute nested DDL in setup."""
    name='m_prepare_stmt'
    matrix=p.files['matrices/body.matrix.yaml']
    p.syntax_fact_refs.append(p.fid('body_drop_relation'))
    for kind in ('table','view','index'):
        suffix='drop_'+kind
        ns='m_prepare_'+suffix+'_ns'
        table=ns+'.base_table'
        target=table if kind=='table' else ns+'.target_'+kind
        provider='m_drop_'+kind
        refs=[p.fid('body_drop_relation'),provider+'::'+provider+'_fact_syntax',
              provider+'::'+provider+'_fact_authority']
        body='DROP '+kind.upper()+' '+target+(' PURGE' if kind=='table' else '')
        matrix['profiles'].append(dict(id=p.vid('body',suffix),render="'"+body+"'",validity='valid',
            properties=dict(source_tables=[table],source_columns=['id','qty']),fact_refs=refs))
        setup=[f'CREATE SCHEMA {ns};',f'CREATE TABLE {table} (id INTEGER, qty INTEGER);',
               f'INSERT INTO {table} VALUES (1,10),(2,20);']
        teardown=[f'DEALLOCATE PREPARE {name};']
        if kind=='view':
            setup.append(f'CREATE VIEW {target} AS SELECT id,qty FROM {table};')
            teardown.append(f'DROP VIEW IF EXISTS {target};')
        elif kind=='index':
            setup.append(f'CREATE INDEX {target} USING BTREE ON {table} (id);')
            teardown.append(f'DROP INDEX IF EXISTS {target};')
        teardown += [f'DROP TABLE IF EXISTS {table} PURGE;',f'DROP SCHEMA {ns};']
        fx=p.fixture(suffix,[(table,['id','qty'])],setup,teardown)
        p.files['fixtures/'+suffix+'.fixture.yaml']['execution']['note']=(
            '仅使用此case新建专属模式及对象，模式不得与用户同名。提供表声明，视图/索引身份由真实setup和阶段审阅确认，'
            '不伪装为表。目标只PREPARE，不能提前执行内层DROP。无并发、无外部依赖、无CASCADE/DROP OWNED兜底。'
            '只有确认本case创建成功且归属明确的资产才允许清理，失败须记录实际阶段；prepared仅成功创建后释放。'
            '表清理使用PURGE避免回收站残留；最后清理空模式，关闭专属连接。未执行，不构成共享数据库安全授权。')
        p.manifest(suffix,dict(body=[suffix]),[fx])
        manifest=p.files['manifests/'+suffix+'.manifest.yaml']
        manifest['description']='仅PREPARE本case新建对象的DROP，不EXECUTE；删除结果与实际资产清理由独立planned阶段场景验证。'
        manifest['environment_requirements'] += [
            dict(key='session_lifecycle',allowed_values=['isolated_connection'],fact_refs=[p.fid('session')]),
            dict(key='namespace_authority',allowed_values=['database_create_non_user_named_fresh_schema'],
                 fact_refs=['m_create_schema::m_create_schema_fact_authority',
                            'm_create_schema::m_create_schema_fact_namespace',
                            'm_create_schema::m_create_schema_fact_same_name_owner']),
            dict(key='ddl_authority',allowed_values=['create_any_table'],
                 fact_refs=['m_create_table::m_create_table_fact_authority']),
            dict(key='drop_authority',allowed_values=['fixture_object_creator'],
                 fact_refs=[provider+'::'+provider+'_fact_authority']),
            dict(key='cleanup_authority',allowed_values=['fixture_table_and_namespace_creator'],
                 fact_refs=['m_drop_table::m_drop_table_fact_authority',
                            'm_drop_schema::m_drop_schema_fact_authority']),
            dict(key='asset_scope',allowed_values=['fresh_owned_objects_no_external_dependencies'],
                 fact_refs=['m_create_schema::m_create_schema_fact_namespace',
                            'm_create_schema::m_create_schema_fact_same_name_owner'])]
        if kind in ('view','index'):
            manifest['environment_requirements'].append(dict(key='nested_object_create_authority',
                allowed_values=['create_any_table' if kind=='view' else 'create_any_index'],
                fact_refs=[f'm_create_{kind}::m_create_{kind}_fact_authority']))
        steps=[dict(id='prepare',sql=f"PREPARE {name} FROM '{body}';")]
        if kind=='index':
            steps.append(dict(id='before_execute',action='使用已校准目录接口，确认专属模式中target_index仍存在；PREPARE尚未执行DROP。'))
            before=dict(kind='manual_assertion',step_id='before_execute',expected='索引存在；目录查询接口与归属需校准。')
        else:
            steps.append(dict(id='before_execute',sql=f'SELECT id,qty FROM {target} ORDER BY id;'))
            before=dict(kind='result_set',step_id='before_execute',expected=[[1,10],[2,20]])
        steps += [dict(id='execute',sql=f'EXECUTE {name};'),
                  dict(id='after_execute',action='使用已校准目录接口，断言仅目标对象消失；同case其他资产仍存在。不得用任意查询报错替代目录Oracle。')]
        p.scenario(suffix+'_phase',['session','prepare_phase','execute_phase','body_drop_relation'],[fx],steps,
            [before,dict(kind='manual_assertion',step_id='after_execute',
                expected='目标对象消失且非目标资产保持；目录接口和每步结果待校准，不是已执行Oracle。')])
        scenario=p.files['scenarios/'+suffix+'_phase.scenario.yaml']
        # Cross-package scenario consumers take lifecycle/environment evidence;
        # nested syntax stays on the corresponding body profile.
        scenario['fact_refs'] += [provider+'::'+provider+'_fact_authority',
                                 'm_drop_table::m_drop_table_fact_purge']
        scenario['execution_requirements'] += ['isolated_connection','per_step_oracle','ownership_scoped_cleanup',
                                               'actual_catalog_calibration','close_case_connection']
        scenario['description']='验证PREPARE与EXECUTE的对象生命周期差异；只操作新建专属对象，仍planned且未执行。'
    feature=next(f for f in matrix['documented_features'] if f['id']==p.id+'_feature_body_drop_relation')
    feature.update(status='covered',coverage_mode='representative',
        profile_refs=[p.vid('body','drop_'+k) for k in ('table','view','index')],
        fact_refs=[p.fid('body_drop_relation')])


def execute():
    p=Package('EXECUTE','UTILITY',CORPUS)
    p.fact('syntax','syntax','M EXECUTE 的正文语法只有预备语句名。','EXECUTE name;')
    p.fact('same_session','environment','必须在当前会话前面已 PREPARE，不能跨连接复用。','必须是在当前会话',1)
    p.fact('parameter_gap','environment','本章语法仅给出EXECUTE name，未提供参数列表或USING形式；参数执行需外部合同。','如果创建预备语句时',5)
    p.facts[-1]['source_anchor']='2.4.2.10.1 L9-L13'
    p.extra_ignored_lines=[dict(line=11, rationale='排版空行或 PDF 页定位标记。')]
    t='m_execute_data';q='m_execute_read';u='m_execute_write'
    p.dim('name',[('read',q),('write',u)])
    p.ast=seq('EXECUTE ',slot('name'))
    fx=p.fixture('prepared',[(t,['id','qty'])],[f'CREATE TABLE {t} (id INT,qty INT);',
        f'INSERT INTO {t} VALUES (1,10),(2,20);',f"PREPARE {q} FROM 'SELECT id,qty FROM {t} ORDER BY id';",
        f"PREPARE {u} FROM 'UPDATE {t} SET qty=99 WHERE id=1';"],
        [f'DEALLOCATE PREPARE {q};',f'DEALLOCATE PREPARE {u};',f'DROP TABLE {t};'])
    p.manifest('finite',bindings(p),[fx])
    p.files['manifests/finite.manifest.yaml']['environment_requirements'].append(dict(key='session_lifecycle',
        allowed_values=['isolated_connection'],fact_refs=[p.fid('same_session'),'m_prepare::m_prepare_fact_session']))
    p.scenario('read_rows',['same_session'],[fx],[dict(sql=f'EXECUTE {q};')],
        [dict(kind='result_set',expected=[[1,10],[2,20]])])
    p.scenario('write_rows',['same_session'],[fx],[dict(sql=f'EXECUTE {u};')],
        [dict(kind='result_set',sql=f'SELECT id,qty FROM {t} ORDER BY id;',expected=[[1,99],[2,20]])])
    for suffix in ('read_rows', 'write_rows'):
        scenario=p.files['scenarios/'+suffix+'.scenario.yaml']
        scenario['fact_refs'].append('m_prepare::m_prepare_fact_session')
        scenario['execution_requirements'].append('isolated_connection')
    return p


def release_prepared(command):
    p=Package(command,'UTILITY' if command=='DEALLOCATE' else 'DDL',CORPUS)
    p.fact('syntax','syntax','M DEALLOCATE PREPARE 与 DROP PREPARE 是别名，目标必须存在于本会话。','{DEALLOCATE | DROP} PREPARE')
    p.fact('session','environment','未显式删除的预备语句在会话结束时删除。','会话结束的时候')
    t=p.id+'_data';q=p.id+'_stmt'
    p.dim('verb',[('deallocate','DEALLOCATE'),('drop','DROP')])
    p.ast=seq(slot('verb'),' PREPARE '+q)
    fx=p.fixture('one_prepared',[(t,['id'])],[f'CREATE TABLE {t} (id INT);',
        f"PREPARE {q} FROM 'SELECT id FROM {t}';"],[f'DROP TABLE {t};'])
    p.files['fixtures/one_prepared.fixture.yaml']['execution']['note'] += (
        ' 成功 target 已释放唯一预备语句，不能 teardown 再次 DEALLOCATE；'
        '目标失败时必须关闭此 case 独占会话释放残留，不能复用连接继续。')
    p.manifest('finite',bindings(p),[fx])
    p.files['manifests/finite.manifest.yaml']['environment_requirements'].append(dict(key='session_lifecycle',
        allowed_values=['isolated_connection'],fact_refs=[p.fid('session'),'m_prepare::m_prepare_fact_session']))
    p.scenario('statement_removed',['syntax'],[fx],
        [dict(sql=f'DEALLOCATE PREPARE {q};'),dict(sql=f'EXECUTE {q};')],
        [dict(kind='target_error',expected='执行刚释放的语句应拒绝，目标错误尚未校准')])
    return p


INDEX='m_b03_existing_index'
INDEX_TWO='m_b03_existing_index_two'
INDEX_SHARED='fixture_m_create_index_existing'


def index_dependency(p):
    fid='fixture_'+p.id+'_shared_indexes'
    execution=dict(status='ready',mode='auto',note='依赖真实建表/建索引；每 case 独占命名空间，禁止共享会话并行复用。')
    p.files['fixtures/shared_indexes.fixture.yaml']=p.entity('fixture',fid,
        requires_fixture_refs=[INDEX_SHARED],provides=dict(tables=[]),
        seed=dict(required=False,rows=[]),execution=execution)
    p.fixtures.append(fid)
    return fid


def create_index():
    p=Package('CREATE INDEX','DDL',CORPUS)
    p.fact('authority','environment','被授予CREATE ANY INDEX权限的用户可以在public和用户模式创建索引。',
           '被授予CREATE ANY INDEX权限的用户',2)
    p.fact('syntax','syntax','普通表索引：可选 UNIQUE/USING，非空键列表，WITH、TABLESPACE、index_option 与算法/锁尾部。','CREATE [ UNIQUE ] INDEX',6)
    p.fact('key','syntax','键可指定 ASC/DESC 与 NULLS FIRST/LAST，多键以逗号分隔。','key_part:',3)
    p.fact('comment','syntax','M index_option 允许行内 COMMENT；不套用通用模式的 COMMENT 处理。','index_option: {',4)
    p.fact('algorithm','syntax','ALGORITHM 的 DEFAULT/INPLACE/COPY 及 LOCK 的 DEFAULT/NONE/SHARED/EXCLUSIVE 语法。','algorithm_option:',5)
    p.fact('method','syntax','M 方法列表为 BTREE、UBTREE。','USING {BTREE | UBTREE}',1)
    p.fact('engine','behavior_oracle','BTREE 随主表存储引擎转换：ASTORE 为 BTREE，USTORE 为 UBTREE。','BTREE与表的存储类型',4)
    p.fact('unique','behavior_oracle','唯一索引在插入/更新造成重复记录时拒绝操作。','创建唯一性索引，每次添加数据',2)
    p.fact('fillfactor','constraint','索引填充因子范围为 10 至 100。','取值范围：10~100')
    p.fact('limits','constraint','普通索引最多 32 列，GLOBAL 最多 31 列。','普通表的索引支持最大列数',2)
    p.fact('key_source','constraint','直接列索引键必须引用目标表中存在的字段。','表中需要创建索引的列的名称',1)
    p.fact('prefix','constraint','前缀键只用于二进制或字符类型；正长度不超过 2676 和字段长度。','前缀键的字段的数据类型',5)
    p.fact('partition_gap','open_question','PDF 物理页 2102 分区产生式未列键列表且中间有分号，示例有 ON table(id) LOCAL；需要独立分区语法复核。','在分区表上创建索引。',12,'needs_verification')
    p.fact('algorithm_effect','open_question','本章只列 ALGORITHM/LOCK 语法，未说明各值效果和组合限制；本轮只取 DEFAULT，不宣称在线语义。','algorithm_option:',5,'needs_verification')
    p.exports=[p.fid('algorithm'),p.fid('method'),p.fid('authority')]
    p.dim('unique_modifier',[('none',''),('yes','UNIQUE')])
    p.dim('method',[('default',''),('btree','USING BTREE')],'method')
    p.dim('key_profile',[(key,'',dict(items=cols,key_column_count=len(cols),source_tables=[SRC],source_columns=cols))
        for key,cols in [('id',['id']),('qty',['qty']),('two',['id','qty'])]],'key')
    p.dim('sort_order',[('default',''),('asc','ASC'),('desc','DESC')],'key')
    p.dim('nulls',[('default',''),('first','NULLS FIRST'),('last','NULLS LAST')],'key')
    p.dim('storage',[('default',''),('min','WITH (fillfactor=10)'),('middle','WITH (fillfactor=70)'),
        ('max','WITH (fillfactor=100)'),('below','WITH (fillfactor=9)')],'fillfactor')
    p.dims['storage']['classes'][-1]['values'][0]['validity']='invalid'
    p.rule('fillfactor',f"storage != '{p.vid('storage','below')}'",'fillfactor')
    p.checks.append(dict(id='check_'+p.id+'_fillfactor',kind='index_fillfactor_contract',
                         fact_refs=[p.fid('fillfactor')]))
    p.checks.append(dict(id='check_'+p.id+'_key_source',kind='index_key_source_contract',
                         fact_refs=[p.fid('key_source'),p.fid('limits')]))
    p.dim('comment',[('none',''),('text',"COMMENT 'm finite index'")],'comment')
    p.dim('tail',[('none',''),('algorithm','ALGORITHM=DEFAULT'),('lock','LOCK DEFAULT')],'algorithm')
    # Ordering applies to the final key only; earlier keys deliberately use defaults.
    p.ast=seq('CREATE ',slot('unique_modifier'),' INDEX m_create_index_new ',slot('method'),
        ' ON '+SRC+' (',repeat('key_profile'),' ',slot('sort_order'),' ',slot('nulls'),') ',
        slot('storage'),' ',slot('comment'),' ',slot('tail'))
    fx='fixture_'+p.id+'_new_target'
    p.files['fixtures/new_target.fixture.yaml']=p.entity('fixture',fx,
        requires_fixture_refs=[BASE],provides=dict(tables=[]),seed=dict(required=False,rows=[]),
        execution=dict(status='ready',mode='auto',note='独占基表由依赖创建；目标索引随该基表删除，无占位 setup。'))
    p.fixtures.append(fx)
    domain=bindings(p);domain['storage'].remove('below')
    p.manifest('finite',domain,[fx])
    p.manifest('fillfactor_below',dict(storage=['below']),[fx],negative='fillfactor')
    p.fixture('existing',[],[f'CREATE INDEX {INDEX} ON {SRC}(id);',f'CREATE INDEX {INDEX_TWO} ON {SRC}(qty);'],
        [f'DROP INDEX IF EXISTS {INDEX_TWO};',f'DROP INDEX IF EXISTS {INDEX};'],requires=[BASE])
    p.scenario('unique_rejects_duplicate',['unique'],[fx],
        [dict(sql=f'CREATE UNIQUE INDEX m_create_index_new ON {SRC}(id);'),
         dict(sql=f'INSERT INTO {SRC}(id,qty) VALUES (1,99);')],
        [dict(kind='target_error',expected='只接受重复键目标错误；SQLSTATE 待校准')])
    p.scenario('method_resolution',['engine'],[fx],
        [dict(action='在显式 ASTORE/USTORE 两种真实表能力下分别创建 BTREE，并检查最终访问方法')],
        [dict(kind='manual_assertion',expected='ASTORE→BTREE、USTORE→UBTREE；本批默认存储表不宣称覆盖两种引擎')])
    p.scenario('prefix_and_limits',['prefix','limits'],[],
        [dict(action='补字符/二进制列和 31/32/33 键列专用 fixture，分别检验长度与 GLOBAL 边界')],
        [dict(kind='manual_assertion',expected='未建模边界不由当前两列整数 fixture 代替')])
    return p


def alter_index():
    p=Package('ALTER INDEX','DDL',CORPUS)
    p.fact('syntax','syntax','重命名为独立 ALTER INDEX 分支。','ALTER INDEX [ IF EXISTS ]',2)
    p.fact('unusable','syntax','ALTER INDEX UNUSABLE 设置索引不可用。','设置表索引不可用。',2)
    p.fact('set','syntax','SET 接受存储参数赋值列表。','修改表索引的存储参数。',3)
    p.fact('reset','syntax','RESET 接受存储参数名称列表。','重置表索引的存储参数。',3)
    p.fact('fillfactor','constraint','ALTER INDEX 当前列明的 FILLFACTOR 合法范围是 10 至 100。','取值范围：10~100')
    p.fact('rename','behavior_oracle','RENAME 只改索引名，不影响存储数据。','只改变索引的名称。')
    p.fact('notice','behavior_oracle','IF EXISTS 对缺失索引给 notice 而不是 error。','则发出一个notice')
    p.fact('rebuild','lifecycle','SET 不立即更新索引内容，可能需要 REINDEX。','不会对索引的内容进行立即更新',2)
    p.fact('partition','syntax','索引分区重命名需要真实分区索引。','重命名索引分区。',3)
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('action',[('rename','RENAME TO m_b03_renamed_index'),('unusable','UNUSABLE'),
        ('min','SET (fillfactor=10)'),('middle','SET (fillfactor=70)'),('max','SET (fillfactor=100)'),
        ('reset','RESET (fillfactor)'),('below','SET (fillfactor=9)')])
    for c in p.dims['action']['classes']:
        v=c['values'][0];suffix=v['id'].rsplit('_',1)[-1]
        v['fact_refs']=[p.fid({'unusable':'unusable','reset':'reset'}.get(suffix,'syntax' if suffix=='rename' else 'set'))]
    p.dims['action']['classes'][-1]['values'][0]['validity']='invalid'
    p.rule('fillfactor',f"action != '{p.vid('action','below')}'",'fillfactor')
    p.ast=seq('ALTER INDEX ',slot('if_exists'),' '+INDEX+' ',slot('action'))
    fx=index_dependency(p)
    domain=bindings(p);domain['action'].remove('below')
    p.manifest('finite',domain,[fx])
    p.manifest('fillfactor_below',dict(action=['below'],if_exists=['none']),[fx],negative='fillfactor')
    p.scenario('rename_data',['rename'],[fx],[dict(sql=f'ALTER INDEX {INDEX} RENAME TO m_b03_renamed_index;'),
        dict(sql=f'SELECT id,qty FROM {SRC} ORDER BY id;')],[dict(kind='result_set',expected=[[1,10],[2,20],[3,30]])])
    p.scenario('notice',['notice'],[fx],[dict(sql='ALTER INDEX IF EXISTS m_alter_index_absent RESET (fillfactor);')],
        [dict(kind='manual_assertion',expected='notice 非 error；不能用任意失败通过')])
    p.scenario('physical_rebuild',['rebuild'],[fx],[dict(action='SET/RESET 后分别检查目录参数和物理重建结果')],
        [dict(kind='manual_assertion',expected='语句成功不等于物理索引内容已立即变化')])
    p.scenario('partition_rename',['partition'],[],[dict(action='需要真实 M LOCAL 分区索引 fixture 后再生成分区改名场景')],
        [dict(kind='manual_assertion',expected='pg_partition 名称改变；普通索引不替代该前置条件')])
    return p


def drop_index():
    p=Package('DROP INDEX','DDL',CORPUS)
    p.fact('syntax','syntax','DROP INDEX 有普通/在线形式，以及带 ON table 的独立 M 形式。','DROP INDEX [ CONCURRENTLY ]',4)
    p.fact('authority','environment','索引所有者、所在模式所有者、持有所在表INDEX权限或DROP ANY INDEX权限的用户可删除；三权分立关闭时系统管理员默认有权。',
           '索引的所有者、索引所在模式的所有者',3)
    p.exports=[p.fid('syntax'),p.fid('authority')]
    p.fact('online_single','constraint','CONCURRENTLY 只能删除一个索引，且不能 CASCADE。','只能指定一个索引的名称',2)
    p.fact('online_transaction','environment','在线删除不能处于事务内。','普通DROP INDEX命令可以在事务内执行',2)
    p.fact('notice','behavior_oracle','IF EXISTS 对缺失索引返回 notice 而非 ERROR。','则发出一个notice')
    p.fact('dependency','constraint','RESTRICT 在依赖存在时拒绝删除，且为缺省；CASCADE 允许级联。','CASCADE：表示允许',3)
    p.fact('tail','syntax','ON table 分支的算法/锁选项引用 M CREATE INDEX。','algorithm_option',1)
    p.fact('temp','environment','其他会话不能删除已初始化全局临时表的索引。','对于全局临时表',3)
    p.fact('failure','lifecycle','在线删除故障可能留下非法状态索引，需定向清理。','可能造成在线删除索引',4)
    p.dim('form',[('ordinary',''),('on_table','')])
    p.dim('online',[('off',''),('on','CONCURRENTLY')])
    p.dim('if_exists',[('none',''),('yes','IF EXISTS')])
    p.dim('targets',[('one','',dict(items=[INDEX])),('two','',dict(items=[INDEX,INDEX_TWO]))])
    p.dim('dependency',[('default',''),('cascade','CASCADE'),('restrict','RESTRICT')])
    p.dim('tail',[('none',''),('algorithm','ALGORITHM=DEFAULT'),('lock','LOCK DEFAULT')],'tail')
    for c in p.dims['tail']['classes']:
        c['values'][0]['fact_refs'].append('m_create_index::m_create_index_fact_algorithm')
    p.rule('online_single',f"online == '{p.vid('online','on')}' => targets == '{p.vid('targets','one')}'",'online_single')
    p.rule('online_cascade',f"online == '{p.vid('online','on')}' => dependency != '{p.vid('dependency','cascade')}'",'online_single')
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','ordinary'):seq('DROP INDEX ',slot('online'),' ',slot('if_exists'),' ',repeat('targets'),' ',slot('dependency')),
        p.vid('form','on_table'):seq('DROP INDEX ',repeat('targets'),' ',slot('dependency'),' ON '+SRC+' ',slot('tail'))})
    fx=index_dependency(p)
    p.manifest('ordinary',dict(form=['ordinary'],online=['off'],if_exists=['none','yes'],targets=['one','two'],
        dependency=['default','cascade','restrict'],tail=['none']),[fx])
    p.manifest('on_table',dict(form=['on_table'],online=['off'],if_exists=['none'],targets=['one','two'],
        dependency=['default','cascade','restrict'],tail=['none','algorithm','lock']),[fx])
    p.manifest('online',dict(form=['ordinary'],online=['on'],if_exists=['none','yes'],targets=['one'],
        dependency=['default','restrict'],tail=['none']),[fx])
    for suffix,targets,dependency in [('online_single',['two'],['restrict']),('online_cascade',['one'],['cascade'])]:
        p.manifest(suffix,dict(form=['ordinary'],online=['on'],if_exists=['none'],targets=targets,
            dependency=dependency,tail=['none']),[fx],negative=suffix)
    for name,obj in p.files.items():
        if name.startswith('manifests/online'):
            obj['environment_requirements'].append(dict(key='execution_context',allowed_values=['top_level_autocommit'],
                fact_refs=[p.fid('online_transaction')]))
    p.scenario('notice',['notice'],[fx],[dict(sql='DROP INDEX IF EXISTS m_drop_index_absent;')],
        [dict(kind='manual_assertion',expected='成功及 notice，非任意错误')])
    p.scenario('dependent_objects',['dependency'],[],[dict(action='构造真实依赖对象后分开验证 CASCADE/RESTRICT')],
        [dict(kind='target_error',expected='只接受依赖对象错误，不接受缺索引或语法错误')])
    p.scenario('concurrent_failures',['temp','failure'],[],[dict(action='专用多会话 fixture 校准全局临时表和在线删除失败状态')],
        [dict(kind='manual_assertion',expected='未执行；仅清理本 case 创建的确切索引')])
    return p


def create_table_select():
    p=Package('CREATE TABLE SELECT','DDL',CORPUS)
    p.fact('syntax','syntax','CREATE TABLE SELECT 含自定义列、表选项、WITH 和可选 AS 后的查询。','CREATE [ TEMPORARY | UNLOGGED ]',11)
    p.fact('order','behavior_oracle','自定义独有列排在前面，其他列依 SELECT 输出顺序。','只出现在自定义列中字段',1)
    p.fact('same_name','behavior_oracle','同名列不区分大小写；采用自定义类型并保留 SELECT 列名大小写。','列名相同但大小写不同',2)
    p.fact('inherit','behavior_oracle','未自定义的直接表列继承原 NULL/NOT NULL、DEFAULT、ON UPDATE、CHARSET、COLLATE。','并且未自定义该字段',3)
    p.fact('nullability','constraint','NOT NULL禁止NULL；允许NULL是普通字段的缺省可空性。','字段值不允许为NULL',3)
    p.fact('default_on_omission','constraint','缺省表达式用于未明确指定值的字段；不能用默认值替换显式NULL。','为字段指定缺省表达式default_expr',2)
    p.checks.append(dict(id='check_'+p.id+'_fixture_write',kind='fixture_write_contract',
                         fact_refs=[p.fid('nullability'),p.fid('default_on_omission')]))
    p.fact('precision','environment','表达式、常量和 UNION 等非直接列需要 enable_precision_decimal；本轮只直接整数列。','如果需要使用完整的功能',4)
    p.fact('row_only','constraint','不支持 WITH (ORIENTATION=column)。','不支持WITH (ORIENTATION = column)')
    p.fact('prepare','constraint','不支持 PREPARE 中嵌套 CREATE TABLE AS。','不支持PREPARE语句中嵌套')
    p.fact('cte','syntax','查询首部含 CTE 时，需要括号包住 query。','若SELECT语句首部带有CTE结构')
    p.fact('comment','syntax','表选项 COMMENT 可带等号。',"COMMENT [=] 'string'",1)
    p.fact('index_conflict','open_question','本章称不支持 USTORE 建 BTREE，M CREATE INDEX 称自动转 UBTREE；未确定适用边界，暂不生成内联索引。','目前只支持索引方法为btree',1,'needs_verification')
    p.fact('optional_columns','open_question','语法格式自定义列外围花括号未明确可选，但本章无自定义列示例与功能描述支持省略；保留文本记法差异。','{({ column_name',1,'needs_verification')
    t='m_ctas_source';target='m_ctas_new'
    p.dim('if_not_exists',[('none',''),('yes','IF NOT EXISTS')])
    p.dim('custom_columns',[('none',''),('extra','(extra INT DEFAULT 5)'),('override','(qty INT)')])
    p.matrix_dim('projection',[(suffix,'',dict(items=cols,source_tables=[t],source_columns=cols,
        output_columns=cols,output_types=['INTEGER']*len(cols),output_column_count=len(cols),direct_columns=True))
        for suffix,cols in [('id',['id']),('two',['id','qty']),('reverse',['qty','id'])]])
    p.dim('as_keyword',[('none',''),('as','AS')])
    p.dim('comment',[('none',''),('text',"COMMENT='m finite copy'")],'comment')
    p.dim('storage',[('default',''),('row','WITH (orientation=row)'),('column','WITH (orientation=column)')],'row_only')
    p.dims['storage']['classes'][-1]['values'][0]['validity']='invalid'
    p.rule('row_only',f"storage != '{p.vid('storage','column')}'",'row_only')
    p.subgrammars['direct_query']=seq('SELECT ',repeat('projection'),' FROM '+t)
    p.ast=seq('CREATE TABLE ',slot('if_not_exists'),' '+target+' ',slot('custom_columns'),' ',
        slot('comment'),' ',slot('storage'),' ',slot('as_keyword'),' ',dict(kind='ref',ref='direct_query'))
    fx=p.fixture('source',[(t,['id','qty'])],
        [f'CREATE TABLE {t} (id INT NOT NULL DEFAULT 7, qty INT DEFAULT 9);',
         f'INSERT INTO {t}(id,qty) VALUES (1,10),(2,NULL);'],
        [f'DROP TABLE IF EXISTS {target};',f'DROP TABLE {t};'])
    p.files['fixtures/source.fixture.yaml']['provides']['tables'][0]['columns'][0]['nullable']=False
    domain={k:[c['values'][0]['id'].removeprefix(p.id+'_'+k+'_') for c in d['classes']]
            for k,d in p.dims.items() if 'classes' in d}
    domain['projection']=['id','two','reverse'];domain['storage'].remove('column')
    p.manifest('direct_columns',domain,[fx])
    p.manifest('column_storage',dict(storage=['column'],projection=['two']),[fx],negative='row_only')
    p.scenario('extra_column_order',['order','nullability','default_on_omission'],[fx],
        [dict(sql=f'CREATE TABLE {target}(extra INT DEFAULT 5) AS SELECT qty,id FROM {t};'),
         dict(sql=f'SELECT * FROM {target} ORDER BY id;')],
        [dict(kind='result_set',expected=[[5,10,1],[5,None,2]])])
    p.scenario('inherited_default',['inherit'],[fx],
        [dict(sql=f'CREATE TABLE {target} AS SELECT id,qty FROM {t};'),
         dict(sql=f'INSERT INTO {target}(id,qty) VALUES (DEFAULT,DEFAULT);'),
         dict(sql=f'SELECT id,qty FROM {target} WHERE id=7;')],
        [dict(kind='result_set',expected=[[7,9]])])
    p.scenario('override_column',['same_name'],[fx],
        [dict(sql=f'CREATE TABLE {target}(qty INT) AS SELECT id,qty FROM {t};'),
         dict(sql=f'SELECT * FROM {target} ORDER BY id;')],
        [dict(kind='result_set',expected=[[1,10],[2,None]])])
    p.scenario('precision_and_cte',['precision','cte'],[],
        [dict(action='先绑定 enable_precision_decimal 环境，再补有输出类型合同的表达式/UNION/带括号 CTE')],
        [dict(kind='manual_assertion',expected='本轮无该类可执行候选，不将基础直接列测试视为类型推导全覆盖')])
    p.scenario('prepared_rejection',['prepare'],[],
        [dict(action='独立 PREPARE 负向需目标错误身份及会话 fixture，不合并进 CTAS 正向')],
        [dict(kind='target_error',expected='应拒绝预备 CREATE TABLE AS，错误身份待校准')])
    return p


def comment():
    p=Package('COMMENT','DDL',CORPUS)
    p.fact('syntax','syntax','COMMENT ON 支持表、表/视图列、视图、索引、序列等独立对象。','COMMENT ON',15)
    p.fact('null_token','syntax','删除注释用 NULL 代替文本字符串。','在文本字符串的位置写上NULL',1)
    p.fact('replace','behavior_oracle','每个对象只保留一条注释，后写替换前写。','每个对象只存储一条注释',2)
    p.fact('drop','lifecycle','删除对象时注释自动删除。','对象时，注释自动被删除。')
    p.fact('visible','environment','注释不保护敏感信息；共享对象注释跨库全局可见。','目前注释浏览没有安全机制',4)
    p.fact('owner','environment','多数对象需所有者或 COMMENT 权限，系统管理员默认有权。','对大多数对象',2)
    p.dim('object',[('table','TABLE '+SRC,dict(source_tables=[SRC])),
        ('column','COLUMN '+SRC+'.id',dict(source_tables=[SRC],source_columns=['id'])),
        ('view','VIEW '+V),('index','INDEX '+INDEX),('sequence','SEQUENCE '+EXISTING)])
    p.dim('text',[('basic',"'m finite comment'"),('unicode',"'测试注释'"),('clear','NULL')])
    p.dims['text']['classes'][-1]['values'][0]['fact_refs']=[p.fid('null_token')]
    p.ast=seq('COMMENT ON ',slot('object'),' IS ',slot('text'))
    index_fx=index_dependency(p);seq_fx=wrap_existing(p)
    for name,objects,fx in [('table',['table','column'],BASE),('view',['view'],VIEW),
                            ('index',['index'],index_fx),('sequence',['sequence'],seq_fx)]:
        p.manifest(name,dict(object=objects,text=['basic','unicode','clear']),[fx])
        p.files['manifests/'+name+'.manifest.yaml']['environment_requirements'].append(dict(
            key='object_authority',allowed_values=['case_object_owner'],fact_refs=[p.fid('owner')]))
    p.scenario('replace_and_clear',['replace','null_token'],[BASE],
        [dict(sql=f"COMMENT ON TABLE {SRC} IS 'first';"),dict(sql=f"COMMENT ON TABLE {SRC} IS 'second';"),
         dict(sql=f'COMMENT ON TABLE {SRC} IS NULL;')],
        [dict(kind='manual_assertion',expected='依次检查唯一注释为 first、second、无注释；目录 Oracle 待接入')])
    p.scenario('drop_clears',['drop'],[BASE],[dict(action='记录本 case 表 OID、注释，删除表后检查注释记录不存在')],
        [dict(kind='manual_assertion',expected='只检查本 case OID，不扫描删除其他对象注释')])
    p.scenario('shared_objects',['visible'],[],[dict(action='数据库/角色/表空间等共享对象必须独立授权并隔离；不在本批默认清单生成')],
        [dict(kind='manual_assertion',expected='验证可见性；不在注释中保存密钥和身份凭据')])
    return p


def explain():
    p=Package('EXPLAIN','UTILITY',CORPUS)
    p.fact('syntax','syntax','括号选项无顺序要求；另有 ANALYZE 后 VERBOSE 的顺序形式。','EXPLAIN [ ( option',21)
    p.fact('executes','behavior_oracle','ANALYZE 实际执行目标语句；DML 会改变数据。','在指定ANALYZE选项时',5)
    p.fact('buffers','constraint','BUFFERS 需要结合 ANALYZE。','包括缓冲区的使用情况',1)
    p.fact('format','syntax','输出格式可为 TEXT/XML/JSON/YAML。','指定输出格式。',3)
    p.fact('distributed','environment','DETAIL/NODES/NUM_NODES 是分布式功能，集中式禁止。','由于参数DETAIL',2)
    p.fact('plan','constraint','PLAN 开启时不能与其他选项同时使用。','因此该选项为on时',2)
    p.fact('opteval','constraint','OPTEVAL 只能与 COSTS/VERBOSE/FORMAT 共存。','仅仅可',2)
    p.fact('opteval_syntax','syntax','OPTEVAL 接受可选布尔参数。','OPTEVAL [ boolean ]')
    p.fact('performance_gap','open_question','参数说明有 PERFORMANCE，但本章产生式未列出；不猜测可执行拼写。','●    PERFORMANCE',1,'needs_verification')
    p.fact('normal','example','本章 JSON/YAML 示例在 explain_perf_mode=normal 下展示。','SET explain_perf_mode=normal;')
    p.dim('form',[('options',''),('ordered',''),('opteval',''),('opteval_disallowed','')])
    p.dims['form']['classes'][2]['values'][0]['fact_refs']=[p.fid('opteval_syntax')]
    p.dims['form']['classes'][3]['values'][0].update(validity='invalid',fact_refs=[p.fid('opteval')])
    p.dim('analyze',[('off','ANALYZE FALSE'),('on','ANALYZE TRUE')])
    p.dim('verbose',[('off','VERBOSE FALSE'),('on','VERBOSE TRUE')])
    p.dim('costs',[('off','COSTS FALSE'),('on','COSTS TRUE')])
    p.dim('buffers',[('off','BUFFERS FALSE'),('on','BUFFERS TRUE')],'buffers')
    p.dim('format',[(s.lower(),'FORMAT '+s) for s in ['TEXT','XML','JSON','YAML']],'format')
    p.dim('ordered',[('none',''),('verbose','VERBOSE'),('analyze','ANALYZE'),('both','ANALYZE VERBOSE')])
    bodies=[('query',f'SELECT id,qty FROM {SRC} WHERE id=1',['id','qty']),
        ('insert',f'INSERT INTO {SRC}(id,qty) VALUES (4,40)',['id','qty']),
        ('update',f'UPDATE {SRC} SET qty=99 WHERE id=1',['id','qty']),
        ('delete',f'DELETE FROM {SRC} WHERE id=2',['id'])]
    p.matrix_dim('body',[(s,sql,dict(source_tables=[SRC],source_columns=cols,read_only=s=='query')) for s,sql,cols in bodies])
    p.rule('buffers',f"buffers == '{p.vid('buffers','on')}' => analyze == '{p.vid('analyze','on')}'",'buffers')
    p.rule('opteval_options',f"form != '{p.vid('form','opteval_disallowed')}'",'opteval')
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','options'):seq('EXPLAIN (',slot('analyze'),', ',slot('verbose'),', ',slot('costs'),', ',slot('buffers'),', ',slot('format'),') ',slot('body')),
        p.vid('form','ordered'):seq('EXPLAIN ',slot('ordered'),' ',slot('body')),
        p.vid('form','opteval'):seq('EXPLAIN (OPTEVAL TRUE, ',slot('verbose'),', ',slot('costs'),', ',slot('format'),') ',slot('body')),
        p.vid('form','opteval_disallowed'):seq('EXPLAIN (OPTEVAL TRUE, ANALYZE FALSE) ',slot('body'))})
    p.manifest('query_options',dict(form=['options'],analyze=['off','on'],verbose=['off','on'],costs=['off','on'],
        buffers=['off','on'],format=['text','xml','json','yaml'],body=['query']),[BASE])
    p.manifest('query_ordered',dict(form=['ordered'],ordered=['none','verbose','analyze','both'],body=['query']),[BASE])
    p.manifest('dml_plan_only',dict(form=['options'],analyze=['off'],verbose=['off'],costs=['on'],
        buffers=['off'],format=['text','json'],body=['insert','update','delete']),[BASE])
    p.manifest('buffers_without_analyze_negative',dict(form=['options'],analyze=['off'],verbose=['off'],
        costs=['on'],buffers=['on'],format=['text'],body=['query']),[BASE],negative='buffers')
    p.manifest('opteval_query',dict(form=['opteval'],verbose=['off','on'],costs=['off','on'],
        format=['text','xml','json','yaml'],body=['query']),[BASE])
    p.manifest('opteval_option_negative',dict(form=['opteval_disallowed'],body=['query']),[BASE],negative='opteval_options')
    p.files['manifests/opteval_option_negative.manifest.yaml']['expected']['error_category']='opteval_option_not_allowed'
    p.scenario('dml_analyze',['executes'],[BASE],[dict(sql='START TRANSACTION;'),
        dict(sql=f'EXPLAIN ANALYZE UPDATE {SRC} SET qty=99 WHERE id=1;'),dict(sql='ROLLBACK;'),
        dict(sql=f'SELECT qty FROM {SRC} WHERE id=1;')],[dict(kind='result_set',expected=[[10]])])
    p.scenario('unsupported_nodes',['distributed'],[BASE],[dict(action='仅在集中式门禁命中时单独测试 NODES/NUM_NODES/DETAIL 目标拒绝')],
        [dict(kind='target_error',expected='与分布式/版本绑定的目标错误需单独校准')])
    p.scenario('plan_and_opteval',['plan','opteval'],[BASE],[dict(action='独立 suite 验证 PLAN 排他和 OPTEVAL 白名单，不混入默认选项组合')],
        [dict(kind='manual_assertion',expected='OPTEVAL已有固定TRUE与三可共存选项的有限候选，实际计划块及目标错误未验证；PLAN的plan_table前置与生命周期仍缺失。')])
    return p


def replace():
    p=Package('REPLACE','UTILITY',CORPUS)
    p.fact('syntax','syntax','REPLACE 值形式允许省略INTO，VALUES/VALUE、显式列列表和多行输入。',83,6)
    p.fact('query_syntax','syntax','REPLACE 查询形式通过 query 提供输入，INTO和列列表可省略。',93,7)
    p.fact('set_syntax','syntax','REPLACE SET 使用有序列赋值列表，INTO可省略。',102,7)
    p.fact('conflict','behavior_oracle','主键/唯一键冲突时先删除旧行再插入新行；无冲突直接插入。','主键/唯一键不冲突',2)
    p.fact('count','behavior_oracle','REPLACE 0 X 中 X 是删除和插入的操作数。','REPLACE操作返回格式')
    p.fact('arity','constraint','SELECT 输出列数应与显式目标字段数一致。','select_list列数必须')
    p.fact('default','syntax','DEFAULT 对应字段缺省值；无缺省则 NULL。','DEFAULT：表示对应字段名')
    p.fact('left_to_right','behavior_oracle','SET 后赋值读取前面已设置列；未设置的列取默认值。','后面设置的col_name依赖',3)
    p.fact('deferrable','constraint','不支持 DEFERRABLE 唯一或主键约束。','不支持延迟生效')
    p.fact('multi_conflict','behavior_oracle','多个唯一约束冲突会删除所有冲突行，再插入新行。','如果表中存在多个唯一约束',3)
    p.fact('permissions','environment','执行 REPLACE 同时需要 DELETE 和 INSERT 权限。','用户需要有表的DELETE和INSERT权限')
    t='m_replace_target';s='m_replace_source';multi='m_replace_multi'
    p.dim('into',[('none',''),('yes','INTO')])
    p.matrix_dim('target_profile',[('explicit',t+' (id,qty)',dict(target_column_count=2,target_types=['INTEGER','INTEGER'],
        explicit_columns=True,available_column_count=2,available_types=['INTEGER','INTEGER'],source_tables=[t],source_columns=['id','qty'])),
        ('implicit',t,dict(target_column_count=2,target_types=['INTEGER','INTEGER'],explicit_columns=False,
        available_column_count=2,available_types=['INTEGER','INTEGER'],source_tables=[t],source_columns=['id','qty'])),
        ('multiple_unique',multi+' (id,qty)',dict(target_column_count=2,target_types=['INTEGER','INTEGER'],
        explicit_columns=True,available_column_count=2,available_types=['INTEGER','INTEGER'],
        source_tables=[multi],source_columns=['id','qty'],replace_conflict_contract='fixture_two_inline_integer_keys',
        required_inline_keys={'id':'PRIMARY KEY','qty':'UNIQUE'}))])
    p.files['matrices/target_profile.matrix.yaml']['profiles'][-1]['fact_refs'] += [
        'm_create_table::m_create_table_fact_inline_unique','m_create_table::m_create_table_fact_inline_primary_key']
    entries=[('new','',dict(items=['(4,40)'],output_types=['INTEGER','INTEGER'])),
        ('conflict','',dict(items=['(1,99)'],output_types=['INTEGER','INTEGER'])),
        ('default','',dict(items=['(1,DEFAULT)'],output_types=['INTEGER','DEFAULT'])),
        ('many','',dict(items=['(1,99)','(4,40)'],output_types=['INTEGER','INTEGER'])),
        ('query',f'SELECT id,qty FROM {s}',dict(source_tables=[s],source_columns=['id','qty'],output_types=['INTEGER','INTEGER'])),
        ('set_literal','',dict(items=['id=1','qty=99'],output_types=['INTEGER','INTEGER'])),
        ('set_default','',dict(items=['id=1','qty=DEFAULT'],output_types=['INTEGER','DEFAULT'])),
        ('set_chain','',dict(items=['id=id+1','qty=id'],output_types=['INTEGER','INTEGER'])),
        ('multiple_conflict','',dict(items=['(1,20)'],output_types=['INTEGER','INTEGER'],expected_conflict_rows=2)),
        ('multiple_control','',dict(items=['(3,30)'],output_types=['INTEGER','INTEGER'],expected_conflict_rows=0))]
    for _,_,props in entries:
        props.setdefault('items',[])  # Query branch uses render, never the repeat node.
        props.update(output_column_count=2,source_kind='finite_input')
    p.matrix_dim('source_profile',entries)
    for profile in p.files['matrices/source_profile.matrix.yaml']['profiles']:
        suffix=profile['id'].removeprefix(p.id+'_source_profile_')
        if suffix=='query':profile['fact_refs']=[p.fid('query_syntax')]
        elif suffix.startswith('set_'):profile['fact_refs']=[p.fid('set_syntax')]
    p.dim('values_keyword',[('values','VALUES'),('value','VALUE')])
    p.checks=[dict(id=p.id+'_struct_input',kind='insert_input_contract',fact_refs=[p.fid('arity')])]
    p.ast=seq('REPLACE ',slot('into'),' ',slot('target_profile'),' ',dict(kind='choice',selector='source_profile',branches={
        p.vid('source_profile',name):(seq('SET ',repeat('source_profile')) if name.startswith('set_') else
            slot('source_profile') if name=='query' else seq(slot('values_keyword'),' ',repeat('source_profile')))
        for name,_,_ in entries}))
    fx=p.fixture('conflict',[(t,['id','qty']),(s,['id','qty'])],
        [f'CREATE TABLE {t}(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9);',
         f'INSERT INTO {t}(id,qty) VALUES (1,10),(2,20);',f'CREATE TABLE {s}(id INT,qty INT);',
         f'INSERT INTO {s}(id,qty) VALUES (1,99),(4,40);'],[f'DROP TABLE {s};',f'DROP TABLE {t};'])
    p.files['fixtures/conflict.fixture.yaml']['provides']['tables'][0]['columns'][0]['nullable']=False
    p.manifest('values',dict(into=['none','yes'],target_profile=['explicit','implicit'],
        source_profile=['new','conflict','default','many'],values_keyword=['values','value']),[fx])
    p.manifest('query',dict(into=['none','yes'],target_profile=['explicit','implicit'],source_profile=['query']),[fx])
    p.manifest('set',dict(into=['none','yes'],target_profile=['implicit'],source_profile=['set_literal','set_default','set_chain']),[fx])
    multi_fx=p.fixture('multiple_unique',[(multi,['id','qty'])],
        [f'CREATE TABLE {multi} (id INT PRIMARY KEY, qty INT UNIQUE);',
         f'INSERT INTO {multi} (id,qty) VALUES (1,10),(2,20);'],[f'DROP TABLE {multi};'])
    multi_fixture=p.files['fixtures/multiple_unique.fixture.yaml']
    multi_fixture['provides']['tables'][0]['columns'][0]['nullable']=False
    multi_fixture['seed']=dict(required=True,rows=[dict(id=1,qty=10),dict(id=2,qty=20)])
    p.manifest('multiple_unique',dict(into=['yes'],target_profile=['multiple_unique'],
        source_profile=['multiple_conflict','multiple_control'],values_keyword=['values']),[multi_fx])
    for obj in p.files.values():
        if obj['kind']=='manifest':obj['environment_requirements'].append(dict(key='object_authority',
            allowed_values=['case_object_owner'],fact_refs=[p.fid('permissions')]))
    p.scenario('conflict_rows',['conflict','count'],[fx],[dict(sql=f'REPLACE INTO {t}(id,qty) VALUES (1,99);'),
        dict(sql=f'SELECT id,qty FROM {t} ORDER BY id;')],
        [dict(kind='result_set',expected=[[1,99],[2,20]]),dict(kind='manual_assertion',expected='目标命令标签 REPLACE 0 2，不是仅 INSERT 1 行')])
    p.scenario('set_default_lineage',['left_to_right'],[fx],[dict(sql=f'REPLACE INTO {t} SET id=id+1,qty=id;'),
        dict(sql=f'SELECT id,qty FROM {t} WHERE id=3;')],[dict(kind='result_set',expected=[[3,3]])])
    p.scenario('default_value',['default'],[fx],[dict(sql=f'REPLACE INTO {t} VALUES (1,DEFAULT);'),
        dict(sql=f'SELECT qty FROM {t} WHERE id=1;')],[dict(kind='result_set',expected=[[9]])])
    for suffix,row,expected,tag in [('multiple_unique','(1,20)',[[1,20]],'REPLACE 0 3'),
                                    ('multiple_unique_control','(3,30)',[[1,10],[2,20],[3,30]],'REPLACE 0 1')]:
        target=f'REPLACE INTO {multi} (id,qty) VALUES {row};'
        result=f'SELECT id,qty FROM {multi} ORDER BY id;'
        p.scenario(suffix,['multi_conflict','conflict','count'],[multi_fx],
            [dict(id='replace_row',sql=target),dict(id='read_rows',sql=result)],
            [dict(kind='result_set',step_id='read_rows',sql=result,expected=expected),
             dict(kind='manual_assertion',step_id='replace_row',expected='目标命令标签 '+tag+'；待实机校准，不能只数新插入行。')])
    p.scenario('deferrable_unsupported',['deferrable'],[],
        [dict(action='先证明专用DEFERRABLE唯一约束前置可建立，再独立验证REPLACE目标拒绝；当前前置和错误身份待核实。')],
        [dict(kind='manual_assertion',expected='不得把建表失败当作REPLACE目标错误，不填猜测SQLSTATE。')])
    return p


def session_gate(p, fact, extra_facts=()):
    for obj in p.files.values():
        if obj['kind']=='manifest':
            obj['environment_requirements'].append(dict(key='session_lifecycle',
                allowed_values=['isolated_connection'],fact_refs=[p.fid(fact),*extra_facts]))


def set_command():
    p=Package('SET','UTILITY',CORPUS)
    p.fact('syntax','syntax','TIME ZONE 接受 SESSION/LOCAL 与具体时区、LOCAL、DEFAULT。','SET [ SESSION | LOCAL ] TIME ZONE',1)
    p.fact('session','environment','SET 缺省 SESSION；会话参数在事务回滚时撤销，提交后持续到会话结束。','声明的参数只对当前会话起作用。如果SESSION',4)
    p.fact('local','lifecycle','SET LOCAL 只到当前事务结束；COMMIT/ROLLBACK 后恢复会话级设置。','声明的参数只在当前事务中有效',6)
    p.fact('timezone','syntax','TIME ZONE 使用有效本地时区，文档给出 PRC 缺省值。','用于指定当前会话的本地时区',3)
    p.fact('global','constraint','不支持用 @@global 语法修改参数值。','2. GaussDB中仅支持',2)
    p.fact('charset','constraint','SET NAMES 暂不支持与数据库字符集不同的 charset_name。','取值范围：M-compatibility兼容模式下支持',2)
    p.fact('schema_absent','behavior_oracle','不存在的模式使 CURRENT_SCHEMA 为空，不从此推断应报错。','取值范围：已存在模式名称',2)
    p.fact('parameter_grammar','constraint','静态域不生成通用参数FROM CURRENT分支；产生式归属与多余右花括号保留为来源限制。','{config_parameter',1)
    p.fact('user_variable','syntax','用户变量支持 SET @var_name := expr 与 SET @var_name = expr。',
           '●   设置自定义用户变量。',3)
    p.fact('user_variable_types','constraint','用户变量允许存储字符类型及NULL；此fixture不推断其他类型转换行为。',
           '● 自定义变量只会存储数值类型',1)
    p.fact('user_variable_integer','syntax',
           '用户变量表达式支持可直接或间接转为整型的表达式；本代表只选择7/-7整数文字，不推断全部类型转换、整数边界或驱动返回类型。',
           '表达式，支持可直接或间接转为整型',1)
    p.fact('user_variable_chain','constraint',
           '连续赋值首位允许:=或=，后续赋值位只能用:=；中间的=表示比较，不是赋值。本代表只取两个变量及字符串/NULL。',
           '● 对于连续赋值的场景',4)
    p.fact('user_variable_profile_gap','constraint',
           '静态域仅保留现有字符串/NULL、整数、有限列表、赋值链和单列无FROM子查询代表；更长组合、其他类型、多行/关联子查询和实际读回保留为来源限制。',
           '●   设置自定义用户变量。',3)
    variable_matrix='matrix_m_set_user_variable_coverage'
    p.files['matrices/user_variable_coverage.matrix.yaml']=p.entity('matrix',variable_matrix,
        profiles=[],documented_features=[dict(id='m_set_feature_user_variable_assignment',
            status='covered',coverage_mode='any',
            value_refs=[p.vid('assignment_operator','colon'),p.vid('assignment_operator','equals'),
                        p.vid('variable_value','string'),p.vid('variable_value','null')],
            fact_refs=[p.fid('user_variable'),p.fid('user_variable_types')]),
            dict(id='m_set_feature_user_variable_list',status='covered',coverage_mode='any',
                 value_refs=[p.vid('form','user_variable_list')],fact_refs=[p.fid('user_variable')]),
            dict(id='m_set_feature_user_variable_extended_domain',status='covered',coverage_mode='any',
                 value_refs=[p.vid('variable_value','string'),p.vid('variable_value','null'),
                             p.vid('variable_value','integer_positive'),p.vid('variable_value','integer_negative')],
                 fact_refs=[p.fid('user_variable'),p.fid('user_variable_profile_gap')]),
            dict(id='m_set_feature_user_variable_chain',status='covered',coverage_mode='any',
                 value_refs=[p.vid('form','user_variable_chain')],fact_refs=[p.fid('user_variable_chain')]),
            dict(id='m_set_feature_user_variable_integer',status='covered',coverage_mode='any',
                 value_refs=[p.vid('variable_value','integer_positive'),p.vid('variable_value','integer_negative')],
                 fact_refs=[p.fid('user_variable_integer')])])
    p.matrices.append(variable_matrix)
    p.exports=[p.fid('session'),p.fid('user_variable_types'),p.fid('timezone')]
    p.syntax_fact_refs=[p.fid('syntax'),p.fid('timezone'),p.fid('user_variable')]
    variable=p.fixture('prepare_string',[],["SET @m_prepare_sql := 'SELECT 1';"],
                       ['SET @m_prepare_sql := NULL;'])
    p.files['fixtures/prepare_string.fixture.yaml']['execution']['note']=(
        '仅用于新鲜M独占连接；创建本case字符串变量，清理为NULL后关闭连接。'
        '不改全局参数，不对他人会话或已有变量执行恢复猜测。')
    p.scenario('prepare_string_value',['user_variable_types'],[variable],
        [dict(sql='SELECT @m_prepare_sql;')],
        [dict(kind='result_set',sql='SELECT @m_prepare_sql;',expected=[['SELECT 1']])])
    p.files['scenarios/prepare_string_value.scenario.yaml']['execution_requirements'] += [
        'isolated_connection','close_case_connection']
    p.dim('scope',[('default',''),('session','SESSION'),('local','LOCAL')])
    p.dim('timezone',[('prc',"'PRC'"),('local','LOCAL'),('default','DEFAULT')],'timezone')
    p.ast=seq('SET ',slot('scope'),' TIME ZONE ',slot('timezone'))
    fx=p.fixture('transaction',[],['START TRANSACTION;'],['ROLLBACK;'])
    p.files['fixtures/transaction.fixture.yaml']['execution']['note']='真实事务前置；SET/SET LOCAL 在回滚后撤销。连接须独占并在 case 后关闭，不能复用未知状态。无占位表。'
    p.manifest('timezone',bindings(p),[fx])
    # Keep the old explicit timezone domain; new defaults change its identity,
    # not its SQL/fixture. The reviewed nine-case migration is recorded separately.
    timezone_ast=p.ast
    p.dim('form',[('timezone',''),('user_variable',''),('user_variable_list',''),('user_variable_chain','')])
    p.dims['form']['classes'][1]['values'][0]['fact_refs']=[p.fid('user_variable')]
    p.dims['form']['classes'][2]['values'][0]['fact_refs']=[p.fid('user_variable')]
    p.dims['form']['classes'][3]['values'][0]['fact_refs']=[p.fid('user_variable_chain')]
    p.dim('assignment_operator',[('colon',':='),('equals','=')],'user_variable')
    p.dim('variable_value',[('string',"'factor value'"),('null','NULL'),
                            ('integer_positive','7'),('integer_negative','-7')],'user_variable_types')
    for cls in p.dims['variable_value']['classes'][2:]:
        cls['values'][0]['fact_refs']=[p.fid('user_variable_integer')]
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','timezone'):timezone_ast,
        p.vid('form','user_variable'):seq('SET @m_set_value ',slot('assignment_operator'),' ',slot('variable_value')),
        p.vid('form','user_variable_list'):seq('SET @m_set_first ',slot('assignment_operator'),
            " 'first value', @m_set_second ",slot('assignment_operator'),' ',slot('variable_value')),
        p.vid('form','user_variable_chain'):seq('SET @m_set_chain_left ',slot('assignment_operator'),
            ' @m_set_chain_right := ',slot('variable_value'))})
    variable_fx=p.fixture('user_variable',[],["SET @m_set_value := 'initial value';"],
                          ['SET @m_set_value := NULL;'])
    p.files['fixtures/user_variable.fixture.yaml']['execution']['note']=(
        '只用于独占新M连接且本case拥有@m_set_value；不借用时区事务、不假定ROLLBACK能恢复变量。'
        '目标后清为NULL并关闭case连接；变量赋值不清理表、不改变全局参数。')
    p.manifest('user_variable',dict(form=['user_variable'],assignment_operator=['colon','equals'],
                                   variable_value=['string','null']),[variable_fx])
    p.manifest('user_variable_integer',dict(form=['user_variable'],assignment_operator=['colon','equals'],
                                           variable_value=['integer_positive','integer_negative']),[variable_fx])
    list_fx=p.fixture('user_variable_list',[],
        ["SET @m_set_first := 'initial first';","SET @m_set_second := 'initial second';"],
        ['SET @m_set_first := NULL;','SET @m_set_second := NULL;'])
    p.files['fixtures/user_variable_list.fixture.yaml']['execution']['note']=(
        '仅用于独占新M连接中的两个case专属变量，逐个初始化并清为NULL后关闭连接。'
        '不能复用用户原有变量，不假定ROLLBACK能恢复变量，不改变全局参数。'
        '两个表达式独立且无互相读取，不推断连续赋值、列表求值顺序或类型转换。')
    p.manifest('user_variable_list',dict(form=['user_variable_list'],assignment_operator=['colon','equals'],
                                       variable_value=['string','null']),[list_fx])
    chain_fx=p.fixture('user_variable_chain',[],
        ["SET @m_set_chain_left := 'initial left';","SET @m_set_chain_right := 'initial right';"],
        ['SET @m_set_chain_left := NULL;','SET @m_set_chain_right := NULL;'])
    p.files['fixtures/user_variable_chain.fixture.yaml']['execution']['note']=(
        '只用于独占新M连接中的本case两个变量，初始化为不同值，目标后逐个清NULL并关闭连接。'
        '不使用ROLLBACK假定恢复变量，不改全局参数，不复用用户原有变量。'
        '连续赋值与逗号列表分开，只有首位运算符可选=，第二位固定:=；更长链和类型转换未覆盖。')
    p.manifest('user_variable_chain',dict(form=['user_variable_chain'],assignment_operator=['colon','equals'],
                                        variable_value=['string','null']),[chain_fx])
    add_user_variable_subquery(p)
    add_schema_selection(p)
    session_gate(p,'session')
    for name in ('user_variable','user_variable_list','user_variable_chain','user_variable_integer','user_variable_subquery'):
        p.files['manifests/'+name+'.manifest.yaml']['environment_requirements'].append(
            dict(key='variable_lifecycle',allowed_values=['close_case_connection'],fact_refs=[p.fid('session')]))
    p.scenario('user_variable_values',['user_variable_types','user_variable_profile_gap'],[variable_fx],
        [dict(id='string',sql="SET @m_set_value = 'factor value';"),dict(id='null',sql='SET @m_set_value := NULL;')],
        [dict(kind='result_set',step_id='string',sql='SELECT @m_set_value;',expected=[['factor value']]),
         dict(kind='result_set',step_id='null',sql='SELECT @m_set_value;',expected=[[None]])])
    p.files['scenarios/user_variable_values.scenario.yaml']['execution_requirements'] += [
        'isolated_connection','close_case_connection','per_step_oracle']
    p.scenario('user_variable_integer_values',['user_variable_integer','user_variable_profile_gap'],[variable_fx],
        [dict(id='positive',sql='SET @m_set_value = 7;'),dict(id='negative',sql='SET @m_set_value := -7;')],
        [dict(kind='result_set',step_id='positive',sql='SELECT @m_set_value;',expected=[[7]]),
         dict(kind='result_set',step_id='negative',sql='SELECT @m_set_value;',expected=[[-7]])])
    p.files['scenarios/user_variable_integer_values.scenario.yaml']['execution_requirements'] += [
        'isolated_connection','close_case_connection','per_step_oracle']
    p.files['scenarios/user_variable_integer_values.scenario.yaml']['description']=(
        '字符串初始值到正整数、再到负整数的有限逐步读回；每步Oracle必须在下一步赋值前读取。'
        '只比较数值，不由JSON数值推断服务端int8身份或驱动类型，实际返回表示待校准；不宣称全数值转换域。')
    p.scenario('user_variable_list_values',['user_variable','user_variable_types','user_variable_profile_gap'],[list_fx],
        [dict(id='strings',sql="SET @m_set_first = 'first value', @m_set_second = 'factor value';"),
         dict(id='null_second',sql="SET @m_set_first := 'first value', @m_set_second := NULL;")],
        [dict(kind='result_set',step_id='strings',sql='SELECT @m_set_first,@m_set_second;',
              expected=[['first value','factor value']]),
         dict(kind='result_set',step_id='null_second',sql='SELECT @m_set_first,@m_set_second;',
              expected=[['first value',None]])])
    p.files['scenarios/user_variable_list_values.scenario.yaml']['execution_requirements'] += [
        'isolated_connection','close_case_connection','per_step_oracle']
    p.scenario('user_variable_chain_values',['user_variable_chain','user_variable_types','user_variable_profile_gap'],[chain_fx],
        [dict(id='strings',sql="SET @m_set_chain_left = @m_set_chain_right := 'factor value';"),
         dict(id='nulls',sql='SET @m_set_chain_left := @m_set_chain_right := NULL;')],
        [dict(kind='result_set',step_id='strings',sql='SELECT @m_set_chain_left,@m_set_chain_right;',
              expected=[['factor value','factor value']]),
         dict(kind='result_set',step_id='nulls',sql='SELECT @m_set_chain_left,@m_set_chain_right;',
              expected=[[None,None]])])
    p.files['scenarios/user_variable_chain_values.scenario.yaml']['execution_requirements'] += [
        'isolated_connection','close_case_connection','per_step_oracle']
    p.scenario('local_rollback',['local','session'],[fx],
        [dict(action='先记录会话 TimeZone，再 SET LOCAL TIME ZONE PRC，ROLLBACK 后与原值比较；不将原值猜成固定 PRC。')],
        [dict(kind='manual_assertion',expected='事务结束恢复事前会话 TimeZone；状态采集与 Oracle 待执行适配')])
    p.scenario('separate_capabilities',['global','charset','schema_absent'],[],
        [dict(action='独立建模 @@global 拒绝、SET NAMES 字符集匹配、缺失 CURRENT_SCHEMA 的空值；不把任意错误算通过。')],
        [dict(kind='manual_assertion',expected='各分支需要自己的环境与预期，不由时区有限模型推导覆盖')])
    return p


def add_user_variable_subquery(p):
    """M SET L114-116; only one literal SELECT, not a scalar-query evaluator."""
    p.fact('user_variable_subquery','syntax',
           '用户变量expr可为子查询；此代表只取M SELECT单个常量投影且无FROM，不混入多行/关联查询。',
           '● 当expr为子查询表达式',3)
    p.fact('user_variable_subquery_result','behavior_oracle',
           'expr为子查询时，变量结果与直接查询结果一致；本场景逐步对照单列常量结果，运行期尚待校准。',
           '● 当expr为子查询表达式',3)
    sources=[p.fid('user_variable_subquery'),'m_select::m_select_fact_from_optional',
             'm_select::m_select_fact_projection_expression']
    identity=p.vid('form','user_variable_subquery')
    p.dims['form']['classes'].append(dict(id=identity+'_class',meaning='user_variable_subquery',values=[
        dict(id=identity,render='',representative=True,validity='valid',properties={},fact_refs=sources)]))
    p.ast['branches'][identity]=seq('SET @m_set_subquery_value ',slot('assignment_operator'),
                                    ' (',seq('SELECT ',slot('variable_value')),')')
    p.syntax_fact_refs += sources
    fx=p.fixture('user_variable_subquery',[],["SET @m_set_subquery_value := 'initial subquery value';"],
                 ['SET @m_set_subquery_value := NULL;'])
    p.files['fixtures/user_variable_subquery.fixture.yaml']['execution']['note']=(
        '仅在已授权M物理数据库的独占新连接内初始化本case变量，不创建或伪报表。'
        '目标只取单列无FROM的常量SELECT；实际运行前需确认M模式与专属连接。'
        '清理本变量为NULL后关闭连接，不用ROLLBACK假装恢复用户变量，不更改全局参数。')
    p.manifest('user_variable_subquery',dict(form=['user_variable_subquery'],
        assignment_operator=['colon','equals'],variable_value=['string','null','integer_positive','integer_negative']),[fx])
    p.files['manifests/user_variable_subquery.manifest.yaml']['description']=(
        'M SET单列单行无FROM常量子查询有限代表；不是任意子查询/类型转换的成功保证。')
    p.files['matrices/user_variable_coverage.matrix.yaml']['documented_features'].append(
        dict(id='m_set_feature_user_variable_subquery',status='covered',coverage_mode='any',
             value_refs=[identity],fact_refs=sources))
    steps,oracles=[],[]
    for label,literal,value in (('string',"'factor value'",'factor value'),('null','NULL',None),
                                ('positive','7',7),('negative','-7',-7)):
        direct,assign=label+'_direct',label+'_assign'
        steps += [dict(id=direct,sql=f'SELECT {literal};'),
                  dict(id=assign,sql=f'SET @m_set_subquery_value := (SELECT {literal});')]
        oracles += [dict(kind='result_set',step_id=direct,sql=f'SELECT {literal};',expected=[[value]]),
                    dict(kind='result_set',step_id=assign,sql='SELECT @m_set_subquery_value;',expected=[[value]])]
    p.scenario('user_variable_subquery_values',
        ['user_variable_subquery','user_variable_subquery_result','user_variable_profile_gap'],[fx],steps,oracles)
    scenario=p.files['scenarios/user_variable_subquery_values.scenario.yaml']
    scenario['execution_requirements'] += ['isolated_connection','close_case_connection','per_step_oracle']
    scenario['description']=(
        'planned：每种literal先直接SELECT再赋给变量，每一步Oracle在下一赋值之前运行。'
        'NULL是一行单列NULL，不是零行；只比较标量内容，不推断驱动类型或全部转换语义。'
        'FROM/关联/多行子查询、函数或任意表达式均未纳入此代表，未执行数据库。')


def add_schema_selection(p):
    """Existing schema only; commit fixture DDL before the SET transaction."""
    p.fact('schema_syntax','syntax',
           '设置模式支持CURRENT_SCHEMA TO/=标识符及SCHEMA字符串，并可选择SESSION/LOCAL；本代表只用已存在专属模式。',16,3)
    p.fact('schema_selected','behavior_oracle',
           'CURRENT_SCHEMA指定当前模式，SCHEMA字符串同义；已存在模式的选择与回滚恢复需逐步验证，不硬编码初始模式。',56,7)
    p.fact('schema_profile_gap','constraint',
           '静态域仅保留同一专属模式的三种拼写与三scope代表；DEFAULT、缺失模式、交错scope、引用域和元数据接口保留为来源限制。',16,3)
    ns='m_set_owned_namespace'
    source_refs=[p.fid('schema_syntax'),'m_create_schema::m_create_schema_fact_syntax',
                 'm_commit::m_commit_fact_syntax','m_start_transaction::m_start_transaction_fact_syntax',
                 'm_rollback::m_rollback_fact_syntax','m_drop_schema::m_drop_schema_fact_syntax']
    forms=[('schema_to',f'CURRENT_SCHEMA TO {ns}'),('schema_equals',f'CURRENT_SCHEMA = {ns}'),
           ('schema_string',f"SCHEMA '{ns}'")]
    for label,clause in forms:
        identity=p.vid('form',label)
        p.dims['form']['classes'].append(dict(id=identity+'_class',meaning=label,values=[
            dict(id=identity,render='',representative=True,validity='valid',properties={},fact_refs=source_refs)]))
        p.ast['branches'][identity]=seq('SET ',slot('scope'),' '+clause)
    p.syntax_fact_refs.append(p.fid('schema_syntax'))
    fx=p.fixture('schema',[],[f'CREATE SCHEMA {ns};','COMMIT;','START TRANSACTION;'],
                 ['ROLLBACK;',f'DROP SCHEMA {ns};','COMMIT;'])
    p.files['fixtures/schema.fixture.yaml']['execution']['note']=(
        '只用于已授权M物理数据库中的独占新连接，确认事前无事务且没有其他用户工作。'
        '专属模式须事前不存在、不在当前搜索路径、非系统模式、非同名用户模式；记录实际创建成功和对象归属。'
        'CREATE SCHEMA后显式COMMIT完成DDL阶段，再START TRANSACTION包围目标SET；不依赖DDL回滚。'
        '目标后ROLLBACK恢复事前会话模式，核验模式不再是当前模式且为空、归属仍为本case才DROP，再COMMIT完成清理。'
        '任一setup失败不得运行目标或按名称清理他人资产；恢复/身份不能确认时停止清理并报告，关闭case连接。'
        '目录身份/事务阶段执行适配仍待校准，此静态列表不是无条件安全执行许可。')
    p.manifest('schema',dict(form=[x[0] for x in forms],scope=['default','session','local']),[fx])
    m=p.files['manifests/schema.manifest.yaml']
    m['description']='M当前模式三种完整拼写与三scope，仅已存在专属模式；不包含DEFAULT或缺失模式预期。'
    m['environment_requirements'] += [
        dict(key='namespace_create_authority',allowed_values=['database_create'],
             fact_refs=['m_create_schema::m_create_schema_fact_authority']),
        dict(key='namespace_identity',allowed_values=['fresh_non_system_non_user_named_schema'],
             fact_refs=['m_create_schema::m_create_schema_fact_namespace','m_create_schema::m_create_schema_fact_same_name_owner']),
        dict(key='namespace_drop_authority',allowed_values=['actual_case_schema_owner'],
             fact_refs=['m_drop_schema::m_drop_schema_fact_authority']),
        dict(key='transaction_owner',allowed_values=['same_connection_transaction_creator'],
             fact_refs=['m_commit::m_commit_fact_authority']),
        dict(key='schema_lifecycle',allowed_values=['fresh_owned_non_current_namespace_restore_before_drop'],
             fact_refs=[p.fid('session')])]
    matrix='matrix_m_set_schema_coverage'
    p.matrices.append(matrix)
    p.files['matrices/schema_coverage.matrix.yaml']=p.entity('matrix',matrix,profiles=[],documented_features=[
        dict(id='m_set_feature_schema_existing',status='covered',coverage_mode='any',
             value_refs=[p.vid('form',x[0]) for x in forms],fact_refs=[p.fid('schema_syntax')]),
        dict(id='m_set_feature_schema_extended',status='covered',coverage_mode='any',
             value_refs=[p.vid('form',x[0]) for x in forms],
             fact_refs=[p.fid('schema_profile_gap'),p.fid('parameter_grammar')])])
    steps=[dict(id='baseline',action='在首次SET前采集当前模式及搜索路径，保存为本case事前基线；不假定public。')]
    oracles=[]
    for label,clause in forms:
        steps.append(dict(id=label,sql=f'SET LOCAL {clause};'))
        oracles.append(dict(kind='manual_assertion',step_id=label,
                            expected=f'当前模式为本case实际创建的{ns}；读取接口及结果表示待校准。'))
    steps.append(dict(id='restore',sql='ROLLBACK;'))
    oracles.append(dict(kind='manual_assertion',step_id='restore',
        expected='与保存的事前当前模式及搜索路径相等；验证专属模式已不再是当前模式，且仍存在、为空并由本case拥有，再清理。'))
    p.scenario('schema_restore',['schema_selected','local','session','schema_profile_gap'],[fx],steps,oracles)
    s=p.files['scenarios/schema_restore.scenario.yaml']
    s['execution_requirements'] += ['isolated_connection','close_case_connection','per_step_oracle',
        'capture_pre_target_schema_and_search_path','verify_owned_empty_namespace_before_drop','separate_ddl_and_target_transactions']
    s['description']='planned：先记录模式基线，再逐步验证三个LOCAL同义拼写及ROLLBACK恢复；SESSION提交持久性、交错设置和缺失模式不由本场景替代。'


def reset():
    p=Package('RESET','UTILITY',CORPUS)
    p.fact('syntax','syntax','当前 RESET 正式产生式只有 RESET ALL。','RESET ALL;',1)
    p.fact('only_all','constraint','当前版本不支持 RESET configuration_parameter，只支持 ALL。','当前版本不支持 RESET',1)
    p.fact('rollback','environment','RESET ALL 的事务影响能由 ROLLBACK 撤销。','RESET ALL的事务性行为',1)
    p.fact('defaults','behavior_oracle','RESET 缺省来自 gaussdb.conf 配置，不是测试硬编码值。','RESET将指定的运行时参数',2)
    p.fact('identity','behavior_oracle','RESET ALL 不恢复 role/session authorization。','RESET ALL不能对role',1)
    p.dim('target',[('all','ALL'),('named','TimeZone')],'only_all')
    p.dims['target']['classes'][1]['values'][0]['validity']='invalid'
    p.rule('only_all',f"target == '{p.vid('target','all')}'",'only_all')
    p.ast=seq('RESET ',slot('target'))
    fx=p.fixture('transaction',[],['START TRANSACTION;',"SET LOCAL TIME ZONE 'PRC';"],['ROLLBACK;'])
    p.files['fixtures/transaction.fixture.yaml']['execution']['note']='RESET ALL 可能重置 search_path 等会话状态；唯一清理 SQL 是 ROLLBACK，不访问未限定对象，结束后关闭独占连接。'
    p.manifest('all',dict(target=['all']),[fx])
    p.manifest('named_negative',dict(target=['named']),[fx],negative='only_all')
    session_gate(p,'rollback',['m_set::m_set_fact_session'])
    p.scenario('restore_and_identity',['defaults','identity','rollback'],[fx],
        [dict(action='记录配置缺省与调用前 role/session authorization/TimeZone/search_path；执行 RESET ALL；再回滚比较原会话状态。')],
        [dict(kind='manual_assertion',expected='重置按配置缺省；身份不被重置；回滚撤销变更。预期采集与执行尚未实现')])
    return p


def set_transaction():
    p=Package('SET TRANSACTION','UTILITY',CORPUS)
    p.fact('syntax','syntax','事务特性包括四种隔离级别以及 READ WRITE/READ ONLY。','{ SET [ LOCAL',3)
    p.fact('local_session','environment','SET TRANSACTION 的 LOCAL 等价 SESSION，仅对当前会话生效。','声明这个命令只对当前会话起作用。效果等价于SESSION',3)
    p.fact('before_data','environment','当前事务的隔离级别必须在首个 SELECT/INSERT/DELETE/UPDATE/COPY 前设置。','在事务中第一个数据修改语句',2)
    p.fact('global_reconnect','environment','GLOBAL 修改当前数据库全局会话特性，重新连接后生效。','设置当前数据库全局会话',1)
    p.fact('s2_next','environment','s2 的无修饰 SET TRANSACTION 设置下一个事务，不允许在当前事务内使用。',"m_format_dev_version='s2'参数时",3)
    p.fact('uncommitted_alias','behavior_oracle','READ UNCOMMITTED 行为同 READ COMMITTED，不承诺脏读。','–    READ UNCOMMITTED',2)
    p.fact('serializable_alias','behavior_oracle','SERIALIZABLE 功能等价 REPEATABLE READ，不当作语法不支持。','–    SERIALIZABLE',2)
    p.fact('combined_gap','syntax','示例确认LOCAL可在隔离级别后以空格连接READ ONLY；不推广为全组合矩阵。','SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY',1)
    p.syntax_fact_refs=[p.fid('syntax')]
    p.dim('scope',[('local','LOCAL'),('session','SESSION')],'local_session')
    p.dim('access_mode',[('none',''),('read_only',' READ ONLY')],'syntax')
    p.dims['access_mode']['description']='示例确认的第二事务属性'
    p.dims['access_mode']['classes'][1]['values'][0]['fact_refs']=[p.fid('combined_gap')]
    p.dims['access_mode']['default_value_id']=p.vid('access_mode','none')
    p.dim('characteristic',[('committed','ISOLATION LEVEL READ COMMITTED'),('uncommitted','ISOLATION LEVEL READ UNCOMMITTED'),
        ('serializable','ISOLATION LEVEL SERIALIZABLE'),('repeatable','ISOLATION LEVEL REPEATABLE READ'),
        ('write','READ WRITE'),('read','READ ONLY')])
    p.ast=seq('SET ',slot('scope'),' TRANSACTION ',slot('characteristic'),slot('access_mode'))
    fx=p.fixture('fresh_transaction',[],['START TRANSACTION;'],['ROLLBACK;'])
    p.files['fixtures/fresh_transaction.fixture.yaml']['execution']['note']='必须在首条数据查询/修改前；setup/目标/ROLLBACK 同一独占连接。会话默认特性可能改变，case 完成后必须关闭连接，不仅依赖事务回滚。GLOBAL 与 s2 无修饰分支不在当前清单。'
    p.manifest('session',dict(scope=['local','session'],characteristic=['committed','uncommitted','serializable','repeatable','write','read']),[fx]);session_gate(p,'local_session')
    p.files['manifests/session.manifest.yaml']['environment_requirements'].append(dict(
        key='transaction_stage',allowed_values=['before_first_data_statement'],fact_refs=[p.fid('before_data')]))
    p.manifest('combined_local',dict(scope=['local'],characteristic=['committed'],access_mode=['read_only']),[])
    p.files['manifests/combined_local.manifest.yaml']['name']='M SET TRANSACTION combined_local'
    p.files['manifests/combined_local.manifest.yaml']['description']='一个LOCAL隔离级别加READ ONLY的示例确认组合；不推广全组合矩阵。'
    p.files['manifests/combined_local.manifest.yaml'].pop('violates_rule_refs')
    p.scenario('isolation_aliases',['uncommitted_alias','serializable_alias'],[fx],
        [dict(action='在两个独立会话验证别名隔离级别的可见性，不以接受关键字证明 SERIALIZABLE 功能。')],
        [dict(kind='manual_assertion',expected='READ UNCOMMITTED≈READ COMMITTED；SERIALIZABLE≈REPEATABLE READ，待并发执行')])
    p.scenario('global_and_next',['global_reconnect','s2_next'],[],
        [dict(action='GLOBAL 需要获授权专用物理库和新连接；s2 next-transaction 另建无事务前置与目标错误场景。')],
        [dict(kind='manual_assertion',expected='当前有限清单不修改全局特性，不把 s2 next 与 SESSION 混为同一语义')])
    return p


def show():
    p=Package('SHOW','UTILITY',CORPUS)
    p.fact('syntax','syntax','SHOW 参数、列、定义、索引、表列表是不同顶层产生式。','SHOW [FULL] COLUMNS FROM',12)
    p.fact('parameters','syntax','SHOW 支持时区、事务隔离级别、会话身份与 ALL。','[VARIABLES LIKE] configuration_parameter',6)
    p.fact('columns','syntax','COLUMNS 适用表和视图，FULL 额外显示字符序、注释和权限；支持 LIKE/WHERE。','显示指定表中的列信息',7)
    p.fact('authority','environment','显示对象信息需要对象权限；列需所在 Schema USAGE 与表级或列级权限。','显示指定表中的列信息',4)
    p.fact('definition','syntax','SHOW CREATE TABLE 也适用于视图。','显示创建指定表的CREATE TABLE语句',2)
    p.fact('version','environment','SHOW CREATE TABLE 的结果格式随 m_format_dev_version=s2 改变。','参数m_format_dev_version为',2)
    p.fact('temporary','environment','临时表索引指定 db_name 时须使用实际临时 Schema。','显示索引信息。GaussDB中临时表',4)
    p.fact('tables','behavior_oracle','SHOW TABLES 不含临时表且升序输出。','查看指定数据库中的表或者视图',4)
    p.fact('key','behavior_oracle','Key 的 PRI/UNI/MUL 与是否主键及索引首列相关，普通列为 NULL。','–   Key：列是否被索引',10)
    p.fact('metadata_gap','environment','当前模型不接入SHOW TABLE STATUS完整目录字段、版本和精度开关Oracle，不宣称元数据结果。','表 2-28 SHOW TABLE STATUS',13)
    next(f for f in p.facts if f['id']==p.fid('metadata_gap'))['source_anchor']='2.4.2.16.8 L178-L190'
    p.extra_ignored_lines=[dict(line=n, rationale='排版空行或 PDF 页定位标记。') for n in (180,183,186,189)]
    forms=['parameters','columns','create_table','create_table_view','create_view','indexes','tables','table_status']
    p.dim('form',[(x,'') for x in forms])
    p.dim('parameter',[('timezone','TIME ZONE'),('isolation','TRANSACTION ISOLATION LEVEL'),
        ('identity','SESSION AUTHORIZATION'),('all','ALL')],'parameters')
    p.dim('target',[('table',SRC),('view',V)],'columns')
    p.dim('full',[('none',''),('yes','FULL')],'columns')
    p.dim('column_filter',[('none',''),('like',"LIKE 'id'"),('where',"WHERE Field = 'id'")],'columns')
    p.dim('index_keyword',[('index','INDEX'),('indexes','INDEXES'),('keys','KEYS')])
    p.dim('from_keyword',[('from','FROM'),('in','IN')])
    p.dim('table_filter',[('none',''),('like',"LIKE 'm_b01_%'")])
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','parameters'):seq('SHOW ',slot('parameter')),
        p.vid('form','columns'):seq('SHOW ',slot('full'),' COLUMNS FROM ',slot('target'),' ',slot('column_filter')),
        p.vid('form','create_table'):seq('SHOW CREATE TABLE '+SRC),
        p.vid('form','create_table_view'):seq('SHOW CREATE TABLE '+V),
        p.vid('form','create_view'):seq('SHOW CREATE VIEW '+V),
        p.vid('form','indexes'):seq('SHOW ',slot('index_keyword'),' ',slot('from_keyword'),' '+SRC),
        p.vid('form','tables'):seq('SHOW ',slot('full'),' TABLES ',slot('table_filter')),
        p.vid('form','table_status'):seq('SHOW TABLE STATUS ',slot('table_filter'))})
    fx=p.fixture('session_parameters',[],['START TRANSACTION;',"SET LOCAL TIME ZONE 'PRC';"],['ROLLBACK;'])
    p.manifest('parameters',dict(form=['parameters'],parameter=['timezone','isolation','identity','all']),[fx])
    p.files['manifests/parameters.manifest.yaml']['environment_requirements'].append(dict(key='session_lifecycle',
        allowed_values=['isolated_connection'],fact_refs=['m_set::m_set_fact_session']))
    p.manifest('table_columns',dict(form=['columns'],target=['table'],full=['none','yes'],column_filter=['none','like','where']),[BASE])
    p.manifest('view_columns',dict(form=['columns'],target=['view'],full=['none','yes'],column_filter=['none','like','where']),[VIEW])
    p.manifest('definitions',dict(form=['create_table','create_table_view','create_view']),[VIEW])
    indexes=index_dependency(p)
    p.manifest('indexes',dict(form=['indexes'],index_keyword=['index','indexes','keys'],from_keyword=['from','in']),[indexes])
    p.manifest('tables',dict(form=['tables'],full=['none','yes'],table_filter=['none','like']),[VIEW])
    p.manifest('table_status',dict(form=['table_status'],table_filter=['none','like']),[VIEW])
    for obj in p.files.values():
        if obj['kind']=='manifest' and obj['id']!='manifest_m_show_parameters':
            obj['environment_requirements'].append(dict(key='object_authority',allowed_values=['case_object_owner'],fact_refs=[p.fid('authority')]))
    p.scenario('metadata',['definition','version','tables','key','metadata_gap'],[VIEW],
        [dict(action='比较 SHOW FULL COLUMNS、SHOW CREATE 与实际 fixture 目录元数据；按版本归一化 DDL，不固定完整返回字符串。')],
        [dict(kind='manual_assertion',expected='列名/DEFAULT/可空性/索引身份与 fixture 一致；SHOW TABLES 有序且无临时表。待专用索引及临时表场景')])
    p.scenario('temporary_namespace',['temporary'],[],
        [dict(action='创建 case 独占临时表和索引，发现真实临时 Schema 后再绑定 SHOW INDEX FROM/IN')],
        [dict(kind='manual_assertion',expected='普通表索引 fixture 不算覆盖临时 Schema 路径')])
    return p


BUILDERS={f.__name__:f for f in (create_sequence,alter_sequence,drop_sequence,prepare,execute,
                               create_index,alter_index,drop_index,create_table_select,comment,explain,replace,
                               reset,set_transaction,show)}
BUILDERS['set']=set_command
BUILDERS.update(deallocate=lambda:release_prepared('DEALLOCATE'),drop_prepare=lambda:release_prepared('DROP PREPARE'))


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--update',action='store_true')
    args=parser.parse_args()
    out=[]
    for builder in BUILDERS.values():
        p=builder()
        for name,obj in p.finish().items():
            path=ROOT/'specs'/p.category.lower()/p.id/name
            content=yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110)
            if path.exists():
                if not args.update: raise FileExistsError(path)
                old=path.read_text()
                if old==content:continue
                out.append('*** Update File: '+str(path))
                # apply_patch has no numeric line addressing. Full context keeps
                # repeated YAML fragments from matching a different profile.
                out.extend('@@' if l.startswith('@@') else l for l in list(difflib.unified_diff(
                    old.splitlines(),content.splitlines(),n=max(len(old.splitlines()),len(content.splitlines())),lineterm=''))[2:])
            else:
                out.append('*** Add File: '+str(path));out.extend('+'+l for l in content.splitlines())
    print('\n'.join(['*** Begin Patch']+out+['*** End Patch']))


if __name__=='__main__':main()
