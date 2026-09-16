#!/usr/bin/env python3
"""Replay declared common-type contracts against current generated candidates.

Independent output-type evidence; never upgrades finite-write or runtime status.
No database connection. Report candidates must exactly match fresh generation.
"""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.common_type_contract import CONTRACT_MODES, check_common_type_query
from core.factor_package_generator import FactorPackageSQLGenerator
from core.finite_sql_contract import Contradiction, ReviewNeeded, inspect_write
from core.spec_generator import GenerationValidationError


def audit_report(report, registry):
    rows, seen, resolved, generated = [], set(), {}, {}
    generator = FactorPackageSQLGenerator(registry)
    population = 0
    for mid, entry in report['manifests'].items():
        manifest = registry.manifests.get(mid)
        factor = registry.factors.get(manifest.factor_ref) if manifest else None
        for case in entry['cases']:
            population += 1
            cid = case['case_id']
            if cid in seen:
                raise ValueError('Duplicate case_id: '+cid)
            seen.add(cid)
            if factor is None:
                raise ValueError('Unknown manifest or factor: '+mid)
            if factor.id not in resolved:
                resolved[factor.id] = registry.resolve_dimension_values(factor.id)
            contracts = []
            for dimension in ('source_profile', 'query_profile'):
                value = resolved[factor.id].get(dimension, {}).get(case.get('params', {}).get(dimension))
                if value and value.attributes.get(dimension+'.properties.common_type_contract'):
                    contracts.append((dimension, value))
            if not contracts:
                continue
            write = inspect_write(case['sql'], case['setup_sqls'],
                                  environment_requirements=case.get('environment_requirements'))
            # SELECT output typing is not a write and must not inflate the
            # finite INSERT/UPDATE backlog with unrelated needs_review rows.
            if factor.id != 'insert':
                write = {'status': 'not_applicable'}
            row = dict(case_id=cid, manifest_id=mid, factor_id=factor.id,
                       type_status='needs_review', type_evidence=[], issues=[],
                       finite_write_status=write['status'], full_write_proven=False,
                       runtime_proven=False,
                       complete_case_sha256=hashlib.sha256(json.dumps(case, sort_keys=True,
                           ensure_ascii=False).encode()).hexdigest())
            rows.append(row)
            try:
                if mid not in generated:
                    fresh, _ = generator.generate_with_report(manifest)
                    generated[mid] = {c.case_id:c.to_dict() for c in fresh}
                if generated[mid].get(cid) != case:
                    raise ReviewNeeded('candidate_identity_mismatch',
                                       'SQL, fixture, mode, expectation and provenance must match current generation')
                for dimension, value in contracts:
                    contract = value.attributes[dimension+'.properties.common_type_contract']
                    mode = CONTRACT_MODES.get(contract)
                    modes = [g.allowed_values for g in manifest.environment_requirements
                             if g.key == 'compatibility_mode']
                    chapter = factor.source.catalog_chapter_ref
                    if (mode is None or modes != [[mode]] or not chapter
                            or not chapter.source_relpath.startswith('general/')
                            or dimension not in case.get('consumed_dimension_ids', [])):
                        raise ReviewNeeded('common_type_scope_unknown', 'Explicit mode, source and consumed profile required')
                    evidence = check_common_type_query(case['sql'], case['setup_sqls'], mode=mode,
                        contract=contract, output_types=value.attributes.get(dimension+'.properties.output_types'))
                    row['type_evidence'].append(dict(evidence, contract=contract, mode=mode,
                                                     profile_id=value.id, fact_refs=value.fact_refs))
                row['type_status'] = 'checked_types'
            except (Contradiction, ReviewNeeded, GenerationValidationError) as exc:
                row['type_evidence'] = []
                row['issues'].append({'code': getattr(exc, 'code', 'generation_validation_failed'),
                                      'detail': getattr(exc, 'detail', str(exc))})
    return {'database_executed': False,
            'limits': ['Type evidence is not full write correctness, row-result proof or error-oracle verification.',
                       'Only currently declared common-type profiles are selected; all other candidates are outside this audit.',
                       'Matching candidates and environment gates are static prerequisites, not observed database state.'],
            'summary': {'generation_population': population, 'selected_cases': len(rows),
                        'outside_contract_scope': population-len(rows),
                        'type_status': dict(Counter(r['type_status'] for r in rows)),
                        'selected_finite_write_status': dict(Counter(r['finite_write_status'] for r in rows))},
            'cases': rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generation-report', type=Path, default=ROOT/'generated/factor_packages/generation_report.json')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    from core.factor_package_model import FactorPackageRegistry
    registry = FactorPackageRegistry(ROOT/'specs'); registry.load_all()
    raw = args.generation_report.read_bytes()
    result = audit_report(json.loads(raw), registry)
    result['generation_report_sha256'] = hashlib.sha256(raw).hexdigest()
    result['checker_files_sha256'] = {name:hashlib.sha256((ROOT/name).read_bytes()).hexdigest()
        for name in ('scripts/audit_common_type_evidence.py', 'core/common_type_contract.py',
                     'core/query_output_contract.py', 'core/factor_package_generator.py',
                     'core/finite_sql_contract.py', 'core/shared_column_contract.py')}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(result['summary'], ensure_ascii=False))
    return int(any(r['type_status'] != 'checked_types' for r in result['cases']))


if __name__ == '__main__':
    raise SystemExit(main())
