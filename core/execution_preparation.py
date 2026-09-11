"""Offline, finite scenario preparation. No connection or execution entry point.

Plans describe required evidence; they do not confer ownership, authorize a
database, calibrate an Oracle, or validate arbitrary SQL safety.
"""
import copy
import re

from .candidate_identity import setup_signature
from .m_compat_environment import BOOTSTRAP_PATH
from .factor_package_model import CandidateScenarioStepDef
from .log_fdw_catalog_contract import check_log_fdw_option_seed


def sql_identity(sql):
    """Token identity only: preserve quoted text, ignore spacing/keyword case."""
    if not isinstance(sql, str) or not sql.strip():
        raise ValueError('Nonempty SQL required')
    tokens = re.findall(r"'(?:''|[^'])*'|\"(?:\"\"|[^\"])*\"|[\w]+|<>|<=|>=|!=|::|[^\s]", sql)
    if any(t in ("'", '"') for t in tokens):
        raise ValueError('Unbalanced quote')
    if any(tokens[i:i+2] in (['-', '-'], ['/', '*']) for i in range(len(tokens)-1)):
        raise ValueError('Comments require separate identity review')
    if tokens[-1:] == [';']:
        tokens.pop()
    if ';' in tokens or not tokens:
        raise ValueError('One statement required')
    return tuple(t if t.startswith(("'", '"')) else t.lower() for t in tokens)


def _m_plain_server_input(case, setup, assets):
    """One reviewed input identity, not a general M LOAD DATA interpreter.

    Source: M LOAD DATA L8-20, L61-73, L95, L125-127. The original
    candidate uses actual LF, all columns and no conflict/SET/skip modifiers.
    """
    required = {'compatibility_mode': ['M'], 'actor_authority': ['sysadmin'],
                'enable_copy_server_files': ['on'],
                'server_file_access': ['deployed_hash_verified_and_allowlisted']}
    if any([g['allowed_values'] for g in case.environment_requirements if g['key'] == key] != [value]
           for key, value in required.items()):
        return False
    sql = ("LOAD DATA INFILE '/tmp/m_factor_assets/load_data/two_int.tsv' "
           "INTO TABLE m_load_data_empty LINES TERMINATED BY '\n';")
    ddl = 'CREATE TABLE m_load_data_empty (id INTEGER PRIMARY KEY, qty INTEGER DEFAULT 9);'
    return (case.factor_id == 'm_load_data' and len(assets) == 1
            and assets[0]['fixture_id'] == 'fixture_m_load_data_empty'
            and assets[0]['sha256'] == '5e643e0ce7adfae177574b7202df193081bc5c8cfe50192935ff1a3beb357e01'
            and sql_identity(case.sql) == sql_identity(sql)
            and setup_signature(setup) == setup_signature([ddl])
            and setup_signature(case.teardown_sqls) == setup_signature(['DROP TABLE m_load_data_empty;']))


def file_preparation_plan(scenario, bound_cases, setup, generator):
    """Recheck local bytes for bound steps; never deploy or prove remote state.

    Existing general LOAD DATA and one plain M input are reviewed here.
    LOCAL location/protocol, complex M variants and outputs need other contracts.
    """
    assets, blockers, needed = {}, [], False
    declared = any(generator.registry.get_fixture(ref).provides.files
                   for ref in generator._ordered_fixture_refs(scenario.fixture_refs))
    for sid, case in bound_cases.items():
        if not (case.file_assets or declared or re.match(r'\s*LOAD\s+DATA\b', case.sql, re.I)):
            continue
        needed = True
        try:
            tokens = sql_identity(case.sql)
            actual = generator._compile_fixture_files(scenario.fixture_refs, case.sql, setup)
        except ValueError:
            blockers.append('file_asset_identity:' + sid)
            continue
        if not actual or actual != case.file_assets:
            blockers.append('file_asset_identity:' + sid)
            continue
        modes = [gate['allowed_values'] for gate in case.environment_requirements
                 if gate['key'] == 'compatibility_mode']
        general_input = case.factor_id == 'load_data' and modes == [['B']]
        m_plain = _m_plain_server_input(case, setup, actual) if case.factor_id == 'm_load_data' else False
        if (not (general_input or m_plain)
                or tokens[:3] != ('load', 'data', 'infile') or len(actual) != 1
                or tokens[3] != "'" + actual[0]['target_path'] + "'"):
            blockers.append('file_location_contract_unreviewed:' + sid)
            continue
        for asset in actual:
            path = asset['target_path']
            if path in assets:
                if assets[path]['asset'] != asset:
                    blockers.append('file_target_conflict:' + sid)
                    continue
                assets[path]['required_by_steps'].append(sid)
                continue
            assets[path] = {
                'asset': copy.deepcopy(asset), 'required_by_steps': [sid],
                'location': 'database_server', 'runtime_ownership_proven': False,
                'required_receipts': ['explicit_file_deployment_authorization',
                    'server_and_database_identity', 'exclusive_path_no_preexisting_file',
                    'server_file_sha256', 'server_file_readability', 'safe_data_path_allowlist',
                    'deployment_owner_receipt'],
                'cleanup_required_receipts': ['deployment_owner_receipt',
                    'server_file_identity_and_hash_recheck', 'owned_file_cleanup_and_residue_check'],
                'cleanup_policy': 'only_this_run_owned_file_after_identity_and_hash_recheck',
            }
            if m_plain:
                # The table does not exist during file deployment. Verify its
                # privileges only after setup succeeds, before the target step.
                assets[path]['target_required_receipts'] = ['table_insert_delete_privileges']
    if not needed:
        return None, blockers
    return {'assets': list(assets.values()), 'deployment_authorized': False,
            'runtime_verified': False, 'phase': 'after_environment_before_setup',
            'limits': ['Local bytes and SQL path identity do not prove server deployment.',
                       'No file transfer, remote read, overwrite or cleanup is implemented.']}, blockers


def ownership_plan(setup, teardown):
    """Track finite names/dependencies, never assume runtime creation/ownership."""
    name = r'[a-z_][a-z0-9_]*(?:\.[a-z_][a-z0-9_]*)?'
    creates, drops, blockers, known = [], [], [], {}
    index_tables = {}
    foreign_parents = {}
    option_seeds, mutations = set(), []
    catalog_name = r'g_a3_[a-z0-9_]+'
    server_shape = rf'\s*CREATE\s+SERVER\s+({catalog_name})\s+FOREIGN\s+DATA\s+WRAPPER\s+log_fdw\s*;?\s*'
    foreign_shape = (rf'\s*CREATE\s+FOREIGN\s+TABLE\s+({catalog_name})\.([a-z_][a-z0-9_]*)'
                     rf'\s*\(\s*col1\s+TEXT\s*\)\s+SERVER\s+({catalog_name})'
                     r"\s+OPTIONS\s*\(\s*logtype\s+'(?-i:gs_log)'\s*\)\s*;?\s*")
    column = r'[a-z_][a-z0-9_]*'
    key = rf'(?:{column}|\(\s*{column}\s*\+\s*[0-9]+\s*\))'
    index_shape = (rf'\s*CREATE\s+(?:UNIQUE\s+)?INDEX\s+({name})\s+ON\s+({name})'
                   rf'(?:\s+USING\s+btree)?\s*\(\s*{key}(?:\s*,\s*{key})*\s*\)'
                   rf'(?:\s+WHERE\s+{column}\s*>\s*[0-9]+)?\s*;?\s*')
    for index, sql in enumerate(setup):
        try:
            sql_identity(sql)
        except ValueError:
            blockers.append(f'setup_identity:{index}')
            continue
        server_create = re.fullmatch(server_shape, sql, re.I)
        foreign_create = re.fullmatch(foreign_shape, sql, re.I)
        if server_create or foreign_create:
            if server_create:
                obj, kind, parents = server_create[1].lower(), 'server', []
            else:
                schema, table, server = (x.lower() for x in foreign_create.groups())
                obj, kind, parents = schema+'.'+table, 'foreign_table', [schema,server]
                if known.get(schema) != 'schema' or known.get(server) != 'server':
                    blockers.append(f'foreign_parents_not_owned:{index}')
                    continue
            if obj in known:
                blockers.append(f'duplicate_create:{obj}')
                continue
            known[obj] = kind
            if parents:
                foreign_parents[obj] = parents
            creates.append({'object': obj, 'kind': kind, 'setup_index': index,
                            'depends_on': parents, 'namespace_scope': 'database' if kind == 'server' else 'schema',
                            'requires_success_receipt': True, 'require_absent_before_run': True})
            continue
        option_seed = re.match(rf'^\s*ALTER\s+FOREIGN\s+TABLE\s+({name})\s+OPTIONS\b', sql, re.I)
        if option_seed:
            obj = option_seed[1].lower()
            try:
                check_log_fdw_option_seed(sql, obj)
            except ValueError:
                blockers.append(f'unreviewed_setup:{index}')
                continue
            if known.get(obj) != 'foreign_table':
                blockers.append(f'foreign_option_target_not_owned:{index}')
            elif obj in option_seeds:
                blockers.append(f'foreign_option_already_present:{index}')
            else:
                # The finite CREATE shape has only logtype; latest_files starts
                # absent. These are conditional requirements, not SQL results.
                option_seeds.add(obj)
                mutations.append({'object': obj, 'setup_index': index,
                                  'operation': 'add_foreign_option', 'option': 'latest_files',
                                  'required_before': None, 'planned_after': '2',
                                  'execute_only_with_matching_create_receipt': True,
                                  'requires_success_receipt': True, 'runtime_state_proven': False})
            continue
        create = re.match(rf'^\s*CREATE\s+(SCHEMA|TABLE)\s+({name})(?=\s|\(|;|$)', sql, re.I)
        if create and create[2].lower() not in ('if', 'public', 'pg_catalog'):
            kind, obj = create[1].lower(), create[2].lower()
            if obj in known:
                blockers.append(f'duplicate_create:{obj}')
            known[obj] = kind
            creates.append({'object': obj, 'kind': kind, 'setup_index': index,
                            'requires_success_receipt': True, 'require_absent_before_run': True})
        else:
            index_create = re.fullmatch(index_shape, sql, re.I)
            if index_create:
                obj, table = (v.lower() for v in index_create.groups())
                schema = table.rsplit('.', 1)[0] if '.' in table else ''
                if '.' not in obj and schema:
                    obj = schema + '.' + obj
                obj_schema = obj.rsplit('.', 1)[0] if '.' in obj else ''
                if known.get(table) != 'table' or obj_schema != schema:
                    blockers.append(f'index_table_not_owned:{index}')
                elif obj in known:
                    blockers.append(f'duplicate_create:{obj}')
                else:
                    known[obj] = 'index'
                    index_tables[obj] = table
                    creates.append({'object': obj, 'kind': 'index', 'setup_index': index,
                                    'depends_on': [table], 'requires_success_receipt': True,
                                    'require_absent_before_run': True})
                continue
            insert = re.match(rf'^\s*INSERT\s+INTO\s+({name})(?=\s|\()', sql, re.I)
            if not insert or known.get(insert[1].lower()) != 'table':
                blockers.append(f'unreviewed_setup:{index}')
    remaining = dict(known)
    for index, sql in enumerate(teardown):
        match = re.fullmatch(rf'\s*DROP\s+(TABLE|SCHEMA|INDEX|SERVER|FOREIGN\s+TABLE)\s+({name})(?:\s+RESTRICT)?\s*;?\s*', sql, re.I)
        if not match:
            blockers.append(f'unreviewed_cleanup:{index}')
            continue
        kind, obj = re.sub(r'\s+', '_', match[1].lower()), match[2].lower()
        dependent_indexes = []
        if remaining.get(obj) != kind:
            blockers.append(f'cleanup_without_create:{obj}')
        elif any(obj in parents and child in remaining for child, parents in foreign_parents.items()):
            blockers.append(f'cleanup_order:{obj}')
        elif kind == 'schema' and any(n.startswith(obj+'.') for n in remaining):
            blockers.append(f'cleanup_order:{obj}')
        else:
            if kind == 'table':
                dependent_indexes = sorted(n for n, table in index_tables.items()
                                           if table == obj and remaining.get(n) == 'index')
                for dependent in dependent_indexes:
                    remaining.pop(dependent)
            remaining.pop(obj)
        drops.append({'object': obj, 'kind': kind, 'teardown_index': index,
                      'execute_only_with_matching_create_receipt': True})
        if kind == 'table':
            drops[-1].update(dependent_indexes=dependent_indexes,
                             requires_dependency_inventory_check=True)
    blockers.extend('missing_cleanup:'+obj for obj in remaining)
    return {'creates': creates, 'cleanup': drops, 'blockers': blockers,
            **({'setup_mutations': mutations} if mutations else {}),
            'runtime_ownership_proven': False,
            'limits': ['Name/order check only; not a general DDL parser or runtime cleanup authorization.']}


def prepare_unit(scenario, cases, generator):
    """Bind reviewed scenario steps to actual candidates with identical setup.

    One setup serves the whole scenario sequence. It is incorrect to transplant
    the second step's result to a freshly initialized independent candidate.
    """
    source = scenario.model_dump()
    setup, teardown = generator._compile_fixture_lifecycle(scenario.fixture_refs)
    ownership = ownership_plan(setup, teardown)
    blockers, calibration, steps = list(ownership['blockers']), [], []
    if not scenario.steps:
        blockers.append('empty_sequence')
    cases = [c for c in cases if c.factor_id == scenario.factor_ref]
    generated, bound_cases = {}, {}
    for index, raw in enumerate(scenario.steps):
        if not isinstance(raw, dict) or ('candidate' not in raw and not isinstance(raw.get('sql'), str)):
            blockers.append(f'unrendered_step:{index}')
            continue
        sid = raw.get('id', f'step_{index+1}')
        if any(s['step_id'] == sid for s in steps):
            blockers.append(f'duplicate_step:{sid}')
        try:
            if 'candidate' in raw:
                binding = CandidateScenarioStepDef(**raw).candidate
                manifest = generator.registry.manifests.get(binding.manifest_ref)
                if manifest is None or manifest.factor_ref != scenario.factor_ref:
                    raise ValueError('Candidate manifest must belong to the same package')
                if any(value not in manifest.bindings.get(key, []) for key, value in binding.params.items()):
                    raise ValueError('Selector outside manifest bindings')
                if manifest.id not in generated:
                    generated[manifest.id] = generator.generate_with_report(manifest)[0]
                selected = [c.to_dict() for c in generated[manifest.id]
                            if all(c.params.get(k) == v for k, v in binding.params.items())]
                # Compare full records against actual generation, never infer a
                # manifest from an ID prefix or trust caller-supplied SQL.
                matches = [c for c in cases if c.to_dict() in selected]
                if len(selected) != 1:
                    blockers.append(f'candidate_selection:{sid}:matches={len(selected)}')
                    matches = []
            else:
                identity = sql_identity(raw['sql'])
                matches = [c for c in cases if sql_identity(c.sql) == identity]
            matches = [c for c in matches if setup_signature(c.setup_sqls) == setup_signature(setup)
                       and c.teardown_sqls == teardown]
        except ValueError:
            matches = []
        if len(matches) != 1:
            blockers.append(f'case_identity:{sid}:matches={len(matches)}')
        case = matches[0] if len(matches) == 1 else None
        if case:
            bound_cases[sid] = case
        if case and raw.get('expected', 'success') != case.expected:
            blockers.append(f'expected_mismatch:{sid}')
        steps.append({'step_id': sid, 'source_step': copy.deepcopy(raw),
                      'case_id': case.case_id if case else None,
                      'resolved_sql': case.sql if case else None, 'oracles': []})
    for index, oracle in enumerate(scenario.oracles):
        if not isinstance(oracle, dict):
            blockers.append(f'untyped_oracle:{index}')
            continue
        refs = {oracle[key] for key in ('step_id', 'step_ref') if oracle.get(key)}
        if not refs and len(steps) == 1:
            refs = {steps[0]['step_id']}
        targets = [s for s in steps if s['step_id'] in refs]
        if len(refs) != 1 or len(targets) != 1:
            blockers.append(f'oracle_step:{index}')
            continue
        targets[0]['oracles'].append(copy.deepcopy(oracle))
        if 'expected' not in oracle:
            blockers.append(f'missing_oracle_expected:{index}')
        if oracle.get('kind') == 'affected_rows':
            expected = oracle.get('expected')
            if type(expected) is not int or expected < 0:
                blockers.append(f'invalid_affected_rows_expected:{index}')
            if 'sql' in oracle:
                blockers.append(f'affected_rows_separate_query:{index}')
            target_case = bound_cases.get(targets[0]['step_id'])
            if (target_case is None or target_case.expected != 'success'
                    or sql_identity(target_case.sql)[0] not in ('insert', 'update', 'delete')):
                blockers.append(f'affected_rows_target_not_successful_dml:{index}')
            targets[0]['oracles'][-1]['measurement_source'] = 'target_command_affected_rows'
        if oracle.get('kind') == 'manual_assertion' or oracle.get('calibration_status') == 'needs_verification':
            calibration.append({'step_id': targets[0]['step_id'], 'oracle_index': index, 'kind': oracle.get('kind')})
        elif oracle.get('kind') not in ('result_set', 'target_error', 'affected_rows'):
            blockers.append(f'unreviewed_oracle_kind:{index}')
        if oracle.get('kind') == 'target_error' and not oracle.get('sqlstates'):
            if not any(item['oracle_index'] == index for item in calibration):
                calibration.append({'step_id': targets[0]['step_id'], 'oracle_index': index, 'kind': 'target_error'})
    for step in steps:
        if not step['oracles']:
            blockers.append('missing_oracle:'+step['step_id'])
    gates = {}
    for c in cases:
        for gate in c.environment_requirements:
            key, values = gate['key'], gate['allowed_values']
            if key in gates and gates[key] != values:
                blockers.append('inconsistent_environment_requirements')
            gates[key] = values
    if len(gates.get('compatibility_mode', [])) != 1:
        blockers.append('physical_mode_unresolved')
    file_plan, file_blockers = file_preparation_plan(scenario, bound_cases, setup, generator)
    blockers.extend(file_blockers)
    unit = {
        'unit_kind': 'scenario_sequence', 'scenario_ref': scenario.id, 'factor_ref': scenario.factor_ref,
        'execution_authorized': False, 'database_executed': False, 'source_scenario': source,
        'source_cases': [c.to_dict() for c in cases], 'setup_sqls': setup, 'teardown_sqls': teardown,
        'steps': steps, 'environment_requirements': gates, 'ownership_plan': ownership,
        'static_blockers': sorted(set(blockers)), 'oracle_calibration_pending': calibration,
        'm_environment_plan_ref': BOOTSTRAP_PATH if gates.get('compatibility_mode') == ['M'] else None,
        'required_runtime_evidence': ['explicit_database_authorization', 'actual_physical_database_mode',
                                      'isolated_connection_and_namespace', 'per_create_success_receipts',
                                      'per_step_target_and_oracle_results', 'owned_cleanup_and_residue_check'],
        'failure_policy': {'environment': 'stop_before_setup', 'setup': 'skip_target_retain_partial_inventory',
                           'target': 'preserve_original_error_do_not_accept_arbitrary_error',
                           'oracle': 'unresolved_oracle_is_pending_not_pass',
                           'cleanup': 'only_confirmed_owned_objects_preserve_all_prior_errors'},
        'limits': ['sequence_state_not_independent_case_oracle', 'token_identity_is_not_SQL_semantic_proof',
                   'This offline module never opens a connection or runs SQL.',
                   'A static plan is not an implemented runtime state machine.'],
    }
    if file_plan is not None:
        unit['file_preparation_plan'] = file_plan
        unit['required_runtime_evidence'].append('file_deployment_and_verification')
        unit['failure_policy']['file'] = 'stop_before_setup_and_target'
    return unit
