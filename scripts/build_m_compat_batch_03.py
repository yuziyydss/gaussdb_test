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
    p.fact('min_ambiguity','open_question','递减最小值的排版/符号边界需复核；有限候选只用显式小整数范围。','递减序列的缺省值',2,'needs_verification')
    p.fact('restart','open_question','RESTART 出现在语法但无参数语义说明；不猜测 CREATE 时与 START 的优先级。','[ RESTART',1,'needs_verification')
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
                  'alter_relation':'本包仅覆盖ALTER TABLE新增一个可空INTEGER列代表，ALTER VIEW和INDEX仍待补。',
                  'set':'本包仅覆盖SET SESSION TIME ZONE PRC代表，不推断用户变量或其他参数可预备。',
                  'commit':'本包仅预备同会话COMMIT；解析不提交，实际执行与回滚阶段由独立场景验证。'
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
    return p


def execute():
    p=Package('EXECUTE','UTILITY',CORPUS)
    p.fact('syntax','syntax','M EXECUTE 的正文语法只有预备语句名。','EXECUTE name;')
    p.fact('same_session','environment','必须在当前会话前面已 PREPARE，不能跨连接复用。','必须是在当前会话',1)
    p.fact('parameter_gap','open_question','参数说明提到兼容参数，但语法未给 USING/参数列表；本批只无参数执行。','如果创建预备语句时',2,'needs_verification')
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
    p.fact('parameter_grammar','open_question','通用参数产生式 FROM CURRENT 的归属及多余右花括号需复核，不自动转义后直接输出。','{config_parameter',1,'needs_verification')
    p.fact('user_variable','syntax','用户变量支持 SET @var_name := expr 与 SET @var_name = expr。',
           '●   设置自定义用户变量。',3)
    p.fact('user_variable_types','constraint','用户变量允许存储字符类型及NULL；此fixture不推断其他类型转换行为。',
           '● 自定义变量只会存储数值类型',1)
    p.fact('user_variable_profile_gap','open_question',
           '已有单变量字符串/NULL和两种赋值符号的有限代表；数值/二进制/其他类型转换、多变量列表、连续赋值及子查询表达式仍缺合同，实际读回未验证。',
           '●   设置自定义用户变量。',3,'needs_verification')
    variable_matrix='matrix_m_set_user_variable_coverage'
    p.files['matrices/user_variable_coverage.matrix.yaml']=p.entity('matrix',variable_matrix,
        profiles=[],documented_features=[dict(id='m_set_feature_user_variable_assignment',
            status='covered',coverage_mode='representative',
            value_refs=[p.vid('assignment_operator','colon'),p.vid('assignment_operator','equals'),
                        p.vid('variable_value','string'),p.vid('variable_value','null')],
            fact_refs=[p.fid('user_variable'),p.fid('user_variable_types')]),
            dict(id='m_set_feature_user_variable_extended_domain',status='needs_profile',
                 fact_refs=[p.fid('user_variable'),p.fid('user_variable_profile_gap')])])
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
    p.dim('form',[('timezone',''),('user_variable','')])
    p.dims['form']['classes'][1]['values'][0]['fact_refs']=[p.fid('user_variable')]
    p.dim('assignment_operator',[('colon',':='),('equals','=')],'user_variable')
    p.dim('variable_value',[('string',"'factor value'"),('null','NULL')],'user_variable_types')
    p.ast=dict(kind='choice',selector='form',branches={
        p.vid('form','timezone'):timezone_ast,
        p.vid('form','user_variable'):seq('SET @m_set_value ',slot('assignment_operator'),' ',slot('variable_value'))})
    variable_fx=p.fixture('user_variable',[],["SET @m_set_value := 'initial value';"],
                          ['SET @m_set_value := NULL;'])
    p.files['fixtures/user_variable.fixture.yaml']['execution']['note']=(
        '只用于独占新M连接且本case拥有@m_set_value；不借用时区事务、不假定ROLLBACK能恢复变量。'
        '目标后清为NULL并关闭case连接；变量赋值不清理表、不改变全局参数。')
    p.manifest('user_variable',dict(form=['user_variable'],assignment_operator=['colon','equals'],
                                   variable_value=['string','null']),[variable_fx])
    session_gate(p,'session')
    p.files['manifests/user_variable.manifest.yaml']['environment_requirements'].append(
        dict(key='variable_lifecycle',allowed_values=['close_case_connection'],fact_refs=[p.fid('session')]))
    p.scenario('user_variable_values',['user_variable_types','user_variable_profile_gap'],[variable_fx],
        [dict(id='string',sql="SET @m_set_value = 'factor value';"),dict(id='null',sql='SET @m_set_value := NULL;')],
        [dict(kind='result_set',step_id='string',sql='SELECT @m_set_value;',expected=[['factor value']]),
         dict(kind='result_set',step_id='null',sql='SELECT @m_set_value;',expected=[[None]])])
    p.files['scenarios/user_variable_values.scenario.yaml']['execution_requirements'] += [
        'isolated_connection','close_case_connection','per_step_oracle']
    p.scenario('local_rollback',['local','session'],[fx],
        [dict(action='先记录会话 TimeZone，再 SET LOCAL TIME ZONE PRC，ROLLBACK 后与原值比较；不将原值猜成固定 PRC。')],
        [dict(kind='manual_assertion',expected='事务结束恢复事前会话 TimeZone；状态采集与 Oracle 待执行适配')])
    p.scenario('separate_capabilities',['global','charset','schema_absent'],[],
        [dict(action='独立建模 @@global 拒绝、SET NAMES 字符集匹配、缺失 CURRENT_SCHEMA 的空值；不把任意错误算通过。')],
        [dict(kind='manual_assertion',expected='各分支需要自己的环境与预期，不由时区有限模型推导覆盖')])
    return p


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
    p.fact('combined_gap','open_question','物理页2277语法将隔离级别与访问模式列为选择，但示例连写；组合形式留待复核，本批一次选一项。','SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY',1,'needs_verification')
    p.dim('scope',[('local','LOCAL'),('session','SESSION')],'local_session')
    p.dim('characteristic',[('committed','ISOLATION LEVEL READ COMMITTED'),('uncommitted','ISOLATION LEVEL READ UNCOMMITTED'),
        ('serializable','ISOLATION LEVEL SERIALIZABLE'),('repeatable','ISOLATION LEVEL REPEATABLE READ'),
        ('write','READ WRITE'),('read','READ ONLY')])
    p.ast=seq('SET ',slot('scope'),' TRANSACTION ',slot('characteristic'))
    fx=p.fixture('fresh_transaction',[],['START TRANSACTION;'],['ROLLBACK;'])
    p.files['fixtures/fresh_transaction.fixture.yaml']['execution']['note']='必须在首条数据查询/修改前；setup/目标/ROLLBACK 同一独占连接。会话默认特性可能改变，case 完成后必须关闭连接，不仅依赖事务回滚。GLOBAL 与 s2 无修饰分支不在当前清单。'
    p.manifest('session',bindings(p),[fx]);session_gate(p,'local_session')
    p.files['manifests/session.manifest.yaml']['environment_requirements'].append(dict(
        key='transaction_stage',allowed_values=['before_first_data_statement'],fact_refs=[p.fid('before_data')]))
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
    p.fact('metadata_gap','open_question','SHOW TABLE STATUS 的全部目录字段映射、版本和精度开关尚未接入精确 Oracle。','表 2-28 SHOW TABLE STATUS',1,'needs_verification')
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
    p.scenario('metadata',['definition','version','tables','key'],[VIEW],
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
