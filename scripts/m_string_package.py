"""Curated M INSERT/UPDATE consumers of the reviewed UTF8 storage contract.

Used by the existing pilot builder. Emits definitions only, never executes SQL.
"""
import copy
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SAMPLES = [('empty', ''), ('ascii_short', 'a'), ('ascii_edge', 'ab'),
           ('han_short', '中'), ('han_edge', '中文'), ('four_byte', '😀好'), ('quote', "a'")]
CONTRACT = 'm_utf8_string_storage'


def quoted(value):
    return "'" + value.replace("'", "''") + "'"


def add_string_cases(p):
    """One fresh two-column fixture per case; not a general type system."""
    anchor = '●   DEFAULT'
    storage = p.fact('string_storage', 'constraint',
        'M VARCHAR(n)按字符计长且受65532字节存储限制；本批只用VARCHAR(2)与同列类型匹配的完整字面量/常量DEFAULT。', anchor)
    p.facts[-1]['source_anchor'] = '2.6.4 L188-217；本章DEFAULT行为为消费者，非字符串类型规则的来源'
    encoding = p.fact('string_encoding', 'environment',
        'M字符集区分server/client/connection/schema/results；未指定字符集的表和列逐级继承。'
        '本批限定UTF8/utf8mb4同编码、当前独占schema、无表列覆盖，条件仍须实机确认。', anchor)
    p.facts[-1]['source_anchor'] = '2.3 L7-35、L129-164、L258-266、L313-325'
    gap = p.fact('string_remaining', 'open_question',
        '尚未承诺CHAR补空格、VARCHAR(0)、TEXT(n)、跨schema、编码转换、动态DEFAULT。'
        '严格/宽松超长的目标SQLSTATE及实际结果、空串与NULL区分、驱动Unicode返回值待校准；不能以任意错误通过。',
        anchor, status='needs_verification')
    p.facts[-1]['source_anchor'] = '2.6.4 L194-219；2.3 L129-164；DEFAULT消费者与输入结果待独立数据库验证'
    table = p.id+'_utf8_source'
    setup = [f'CREATE TABLE {table} (id INT PRIMARY KEY, note VARCHAR(2) DEFAULT \'默认\');']
    if p.id == 'm_update':
        setup.append(f"INSERT INTO {table} VALUES (2,'旧');")
    fixture = p.fixture('string_utf8', [(table, ['id', 'note'])], setup, [f'DROP TABLE {table} RESTRICT;'])
    fx = p.files['fixtures/string_utf8.fixture.yaml']
    fx['provides']['tables'][0]['columns'][0]['nullable'] = False
    fx['provides']['tables'][0]['columns'][1]['type'] = 'VARCHAR(2)'
    fx['seed'] = dict(required=p.id=='m_update', rows=[dict(id=2, note='旧')] if p.id=='m_update' else [])
    fx['execution']['note'] += (' 当前schema必须独占且UTF8；不要借用其他schema的字符集。'
                              '每个case独立建表，UPDATE的seed必须先成功；只清理本case已成功创建的表。')

    variants = [(suffix, quoted(value), value) for suffix, value in SAMPLES] + [('default', 'DEFAULT', '默认')]
    if p.id == 'm_insert':
        target = dict(id=p.vid('target_profile', 'string_utf8'), render=table, validity='valid',
            properties=dict(generated=False, is_view=False, target_column_count=2,
                target_types=['INTEGER','VARCHAR'], explicit_columns=False, available_column_count=2,
                available_types=['INTEGER','VARCHAR'], target_column_contract='fixture_ordinary_columns',
                required_write_contract=CONTRACT), fact_refs=[storage, encoding, p.fid('column_input')])
        p.files['matrices/target_profile.matrix.yaml']['profiles'].append(target)
        sources = p.files['matrices/source_profile.matrix.yaml']['profiles']
        branch = next(x for x in p.ast['items'] if x.get('selector') == 'source_profile')
        values_branch = copy.deepcopy(branch['branches'][p.vid('source_profile','values')])
        variants.append(('omitted', None, '默认'))
        for suffix, literal, _ in variants:
            identity = p.vid('source_profile', 'string_'+suffix)
            types = ['INTEGER'] if literal is None else ['INTEGER','DEFAULT' if literal=='DEFAULT' else 'VARCHAR']
            sources.append(dict(id=identity, render='', validity='valid', properties=dict(
                items=['(7)' if literal is None else f'(7,{literal})'], output_types=types,
                output_column_count=len(types), source_kind='finite_input', generated_explicit=False),
                fact_refs=[storage, p.fid('default'), p.fid('column_input')]))
            branch['branches'][identity] = copy.deepcopy(values_branch)
        p.manifest('string_utf8', dict(target_profile=['string_utf8'],
            source_profile=['string_'+s for s,_,_ in variants]), [fixture])
        input_dim = 'source_profile'
    else:
        identity = p.vid('target', 'string_utf8')
        p.dims['target']['classes'].append(dict(id=identity+'_class', meaning='string_utf8', values=[dict(
            id=identity, render=table, representative=True, validity='valid',
            properties=dict(required_write_contract=CONTRACT), fact_refs=[storage, encoding])]))
        for suffix, literal, _ in variants:
            identity = p.vid('assignments','string_'+suffix)
            p.dims['assignments']['classes'].append(dict(id=identity+'_class', meaning='string_'+suffix,
                values=[dict(id=identity, render='', representative=True, validity='valid',
                    properties=dict(items=[f'note = {literal}']), fact_refs=[storage,p.fid('default')])]))
        p.manifest('string_utf8', dict(target=['string_utf8'], assignments=['string_'+s for s,_,_ in variants],
                                     where=['id']), [fixture])
        input_dim = 'assignments'

    # Pairing belongs to this manifest's bindings/fixture, not to SQL legality.
    # The rendered target/seed contract guards actual storage. Do not invent a
    # database error rule (and hence a negative SQL Oracle) for test asset IDs.
    manifest = p.files['manifests/string_utf8.manifest.yaml']
    for key, value in (('server_encoding','UTF8'), ('client_encoding','UTF8'),
                       ('character_set_connection','utf8mb4'), ('character_set_database','utf8mb4'),
                       ('character_set_results','utf8mb4')):
        manifest['environment_requirements'].append(dict(key=key, allowed_values=[value], fact_refs=[encoding]))
    manifest['description'] = '有限M UTF8字符串存储候选；必须消费共享合同，仍非实机通过或完整语义证明。'

    for suffix, literal, expected in variants:
        key = 7 if p.id=='m_insert' else 2
        p.scenario('string_'+suffix, ['string_storage','string_encoding','default','string_remaining'],
            [fixture], [dict(id='target', candidate=dict(manifest_ref=manifest['id'],
                params={input_dim: p.vid(input_dim, 'string_'+suffix)}))],
            [dict(kind='result_set', step_id='target', sql=f'SELECT id,note FROM {table} ORDER BY id;',
                  expected=[[key,expected]])])
        scenario = p.files['scenarios/string_'+suffix+'.scenario.yaml']
        scenario['preconditions'] += [
            '先完成generated/m_compat_environment/plan.json的物理M数据库创建或授权复用、重连和模式核验。',
            '当前schema独占且UTF8；server_encoding/client_encoding=UTF8；connection/database/results字符集=utf8mb4。',
            '每个场景单独fixture；NULL、空字符串与Unicode必须由驱动准确区分，结果Oracle仍待实机校准。']
        scenario['execution_requirements'] += ['isolated_connection','per_step_oracle','ownership_scoped_cleanup']


def attach_string_sources(p, ledger):
    """Record actual dependency chapters; do not replace existing source units."""
    for name, directory, section, anchor in (
        ('types', 'work/pdf_tiered_2026_09_07/batch_19/corpus', '2.6', 'L188-219'),
        ('charset', 'work/m_compat_batch_04_charset/corpus', '2.3', 'L7-35; L129-164; L258-266; L313-325'),
    ):
        corpus = ROOT/directory
        catalog = json.loads((corpus/'catalog.json').read_text())
        chapter = next(c for c in catalog['chapters'] if c['section_number']==section)
        assert catalog['parent_pdf_sha256']==p.catalog['parent_pdf_sha256']
        assert hashlib.sha256((corpus/chapter['source_relpath']).read_bytes()).hexdigest()==chapter['chapter_sha256']
        sid=p.id+'_string_'+name+'_source'
        ledger.setdefault('supplemental_sources',[]).append(dict(id=sid, document=section+' M 字符串合同来源',
            version=catalog['product_version'], retrieval_date='2026-09-15', source_anchor=anchor,
            catalog_chapter_ref=dict(document_id=catalog['document_id'],source_relpath=chapter['source_relpath'],
                                     chapter_sha256=chapter['chapter_sha256'])))
    for unit in ledger['units']:
        if p.fid('default') in unit.get('fact_refs',[]):
            for suffix in ('string_storage','string_encoding','string_remaining'):
                if p.fid(suffix) not in unit['fact_refs']:
                    unit['fact_refs'].append(p.fid(suffix))
            unit.setdefault('supplemental_source_refs',[]).extend(
                p.id+'_string_'+name+'_source' for name in ('types','charset'))
            unit['rationale']='本行是DEFAULT消费者；类型/编码条件来自精确补充来源，不将跨章规则冒充本行原文。'
