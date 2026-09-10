"""Offline, finite scenario preparation. No connection or execution entry point.

Plans describe required evidence; they do not confer ownership, authorize a
database, calibrate an Oracle, or validate arbitrary SQL safety.
"""
import copy
import re

from .candidate_identity import setup_signature
from .m_compat_environment import BOOTSTRAP_PATH
from .factor_package_model import CandidateScenarioStepDef


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


def ownership_plan(setup, teardown):
    """Track simple created table/schema names, never assume they were created."""
    name = r'[a-z_][a-z0-9_]*(?:\.[a-z_][a-z0-9_]*)?'
    creates, drops, blockers, known = [], [], [], {}
    for index, sql in enumerate(setup):
        try:
            sql_identity(sql)
        except ValueError:
            blockers.append(f'setup_identity:{index}')
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
            insert = re.match(rf'^\s*INSERT\s+INTO\s+({name})(?=\s|\()', sql, re.I)
            if not insert or known.get(insert[1].lower()) != 'table':
                blockers.append(f'unreviewed_setup:{index}')
    remaining = dict(known)
    for index, sql in enumerate(teardown):
        match = re.fullmatch(rf'\s*DROP\s+(TABLE|SCHEMA)\s+({name})(?:\s+RESTRICT)?\s*;?\s*', sql, re.I)
        if not match:
            blockers.append(f'unreviewed_cleanup:{index}')
            continue
        kind, obj = match[1].lower(), match[2].lower()
        if remaining.get(obj) != kind:
            blockers.append(f'cleanup_without_create:{obj}')
        elif kind == 'schema' and any(n.startswith(obj+'.') for n in remaining):
            blockers.append(f'cleanup_order:{obj}')
        else:
            remaining.pop(obj)
        drops.append({'object': obj, 'kind': kind, 'teardown_index': index,
                      'execute_only_with_matching_create_receipt': True})
    blockers.extend('missing_cleanup:'+obj for obj in remaining)
    return {'creates': creates, 'cleanup': drops, 'blockers': blockers,
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
    generated = {}
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
        if oracle.get('kind') == 'manual_assertion' or oracle.get('calibration_status') == 'needs_verification':
            calibration.append({'step_id': targets[0]['step_id'], 'oracle_index': index, 'kind': oracle.get('kind')})
        elif oracle.get('kind') not in ('result_set', 'target_error'):
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
    return {
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
