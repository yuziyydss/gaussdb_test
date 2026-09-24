#!/usr/bin/env python3
"""Compile a bounded offline review batch. There is deliberately no execute flag."""
import argparse
import hashlib
import json
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.execution_preparation import prepare_unit
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.m_compat_environment import MEnvironment


# Explicit manifest/scenario identities, not a batch-wide guessed SQL rewrite.
SELECTION = (
    ('scenario_insert_pg_tuple_fresh', ('manifest_insert_pg_tuple_fresh',)),
    ('scenario_create_index_comment_short_b', ('manifest_create_index_comment_b_fresh',)),
    ('scenario_create_index_visibility_fresh', ('manifest_create_index_visibility_a_fresh',)),
    ('scenario_m_select_count_all_null', ('manifest_m_select_count_all_null',)),
    ('scenario_m_insert_generated_default_result', ('manifest_m_insert_generated',)),
    ('scenario_m_update_generated_default_result', ('manifest_m_update_generated_default',)),
)

SEMANTIC_SELECTION = (
    ('scenario_insert_partial_index_conflict', ('manifest_insert_partial_index_fresh',)),
    ('scenario_insert_partial_index_new_key', ('manifest_insert_partial_index_fresh',)),
    ('scenario_insert_partial_index_outside', ('manifest_insert_partial_index_fresh',)),
    ('scenario_alter_table_log_foreign_rls', ('manifest_alter_table_log_foreign_rls_negative',)),
    ('scenario_insert_pg_tuple_fresh', ('manifest_insert_pg_tuple_fresh',)),
    ('scenario_m_insert_generated_default_result', ('manifest_m_insert_generated',)),
)
FOREIGN_OPTION_SELECTION = (
    ('scenario_alter_foreign_table_log_implicit', ('manifest_alter_foreign_table_log_implicit',)),
    ('scenario_alter_foreign_table_log_options', ('manifest_alter_foreign_table_log_add',)),
    ('scenario_alter_foreign_table_log_set', ('manifest_alter_foreign_table_log_set',)),
    ('scenario_alter_foreign_table_log_drop', ('manifest_alter_foreign_table_log_drop',)),
)
M_STRING_SELECTION = tuple(
    ('scenario_' + factor + '_string_' + suffix, ('manifest_' + factor + '_string_utf8',))
    for factor in ('m_insert', 'm_update')
    for suffix in ('empty', 'ascii_short', 'ascii_edge', 'han_short', 'han_edge',
                   'four_byte', 'quote', 'default') + (('omitted',) if factor == 'm_insert' else ())
)
INSERT_KEY_SELECTION = tuple(
    ('scenario_insert_same_key_' + branch, ('manifest_insert_same_key_tuple',))
    for branch in ('conflict', 'new', 'filtered')
)
FILE_FDW_SELECTION = tuple(
    ('scenario_create_foreign_table_file_' + fmt,
     ('manifest_create_foreign_table_file_' + fmt,))
    for fmt in ('text', 'csv')
)
PROFILES = {'baseline': SELECTION, 'semantic_contracts': SEMANTIC_SELECTION,
            'foreign_options': FOREIGN_OPTION_SELECTION, 'm_string_storage': M_STRING_SELECTION,
            'insert_same_key': INSERT_KEY_SELECTION, 'file_fdw_options': FILE_FDW_SELECTION}


def inputs_snapshot():
    # Includes cross-package dependencies and actual fixture bytes, not just
    # YAML source_path strings. Review notes are not execution inputs.
    paths = list((ROOT / 'core').glob('*.py')) + [Path(__file__)]
    for directory in (ROOT / 'specs', ROOT / 'core'):
        if directory.is_symlink():
            raise ValueError('Execution input directory symlinks need identity review')
    for path in (ROOT / 'specs').rglob('*'):
        if path.is_symlink():
            raise ValueError('Execution input symlinks need identity review')
        if path.is_file() and (path.suffix == '.yaml' or 'assets' in path.relative_to(ROOT / 'specs').parts):
            paths.append(path)
    if any(p.is_symlink() for p in paths):
        raise ValueError('Execution input symlinks need identity review')
    return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(set(paths))}


def build_batch(registry, generator, *, profile='baseline'):
    if profile not in PROFILES:
        raise ValueError('Unknown preparation profile: ' + str(profile))
    selection = PROFILES[profile]
    cases_by_manifest, reports = {}, {}
    for _, mids in selection:
        for mid in mids:
            if mid not in registry.manifests:
                continue
            if mid not in cases_by_manifest:
                cases, report = generator.generate_with_report(registry.manifests[mid])
                cases_by_manifest[mid] = cases
                reports[mid] = report.to_dict()
    cases = [case for group in cases_by_manifest.values() for case in group]
    ids = [c.case_id for c in cases]
    if len(set(ids)) != len(ids):
        raise ValueError('Duplicate candidate IDs in selected manifests')
    units = [prepare_unit(registry.scenarios[sid],
                          [c for mid in mids if mid in cases_by_manifest for c in cases_by_manifest[mid]], generator)
             for sid, mids in selection]
    bound = {s['case_id'] for u in units for s in u['steps'] if s['case_id']}
    unbound = sorted(set(ids) - bound)
    for unit in units:
        unit['preparation_status'] = (
            'blocked' if unit['static_blockers'] else
            'oracle_calibration_pending' if unit['oracle_calibration_pending'] else
            'offline_bound_awaiting_authorization_and_runtime_checks')
    return {
        'kind': 'offline_execution_preparation_batch', 'schema_version': 1,
        'profile': profile,
        'database_executed': False, 'execution_authorized': False,
        'summary': {
            'packages': len({c.factor_id for c in cases}), 'manifests': len(cases_by_manifest),
            'candidates': len(cases), 'scenario_sequences': len(units),
            'bound_candidate_ids': len(bound), 'unbound_candidate_ids': unbound,
            'unit_status_counts': dict(Counter(u['preparation_status'] for u in units)),
            'physical_modes': sorted({m for u in units for m in u['environment_requirements'].get('compatibility_mode', [])}),
            'runtime_verified': 0,
        },
        'mode_isolation': 'Each physical mode requires its own verified connection; one search_path cannot change compatibility.',
        'unit_isolation': 'Each scenario gets its own fresh fixture lifecycle; steps within it share state. Never concatenate unit SQL.',
        'required_target_inventory': 'Record successful target CREATE identities separately before cleanup; setup name checks do not prove target ownership.',
        'm_environment_plan': MEnvironment().plan(),
        'generation_reports': reports,
        'candidates': [c.to_dict() for c in cases],
        'units': units,
        'limitations': [
            'No runtime state machine or database driver is invoked by this compiler.',
            'No SQLSTATE, catalog column, SQL name substitution or environment capability is guessed.',
            'A zero static blocker count does not prove SQL safety, semantic validity or actual execution success.',
            'Fixed names require exclusive approved namespaces; no automatic existing-object deletion or renaming.',
            'Unbound candidates and uncalibrated Oracles remain gaps, not skipped passing cases.',
        ],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--profile', choices=sorted(PROFILES), default='baseline')
    parser.add_argument('--output', type=Path, required=True, help='New JSON artifact; existing paths are never overwritten')
    args = parser.parse_args()
    if args.output.exists():
        parser.error('Output already exists; select a new path to preserve review evidence')
    before = inputs_snapshot()
    registry = FactorPackageRegistry(ROOT / 'specs')
    registry.load_all()
    batch = build_batch(registry, FactorPackageSQLGenerator(registry), profile=args.profile)
    if inputs_snapshot() != before:
        raise RuntimeError('Inputs changed while preparing; discard in-memory result and retry after work settles')
    batch['input_sha256'] = before
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x', encoding='utf-8') as stream:
        json.dump(batch, stream, ensure_ascii=False, indent=2)
        stream.write('\n')
    print(json.dumps({'output': str(args.output.resolve()), 'summary': batch['summary'],
                      'sha256': hashlib.sha256(args.output.read_bytes()).hexdigest()}, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
