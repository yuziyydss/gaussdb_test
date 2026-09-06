#!/usr/bin/env python3
"""Separate finite DELETE evidence; never relabel the original write audit."""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from core.finite_delete_contract import inspect_delete, LIMITS
from core.finite_sql_contract import inspect_lifecycle


def audit_report(report):
    seen, rows = set(), []
    for mid, manifest in report['manifests'].items():
        for case in manifest['cases']:
            if case['case_id'] in seen:
                raise ValueError('Duplicate case ID: '+case['case_id'])
            seen.add(case['case_id'])
            if case['factor_id'] != 'delete':
                continue
            contract = inspect_delete(case['sql'], case['setup_sqls'])
            rows.append({
                'case_id': case['case_id'], 'manifest_id': mid, 'factor_id': 'delete',
                'expected': case['expected'], 'sql': case['sql'],
                'complete_case_sha256': hashlib.sha256(json.dumps(case, ensure_ascii=False, sort_keys=True).encode()).hexdigest(),
                'delete_contract': contract,
                'lifecycle': inspect_lifecycle(case['setup_sqls'], case['teardown_sqls']),
                'target_error_verified': False,
            })
    return {
        'scope': 'finite_delete_shape_only', 'database_executed': False,
        'summary': {
            'generation_population': len(seen), 'delete_population': len(rows),
            'outside_delete_scope': len(seen)-len(rows),
            'delete_contract': dict(Counter(row['delete_contract']['status'] for row in rows)),
            'positive_rejected': sum(row['expected'] == 'success' and row['delete_contract']['status'] == 'rejected' for row in rows),
        },
        'cases': rows,
        'limits': LIMITS+['This separate selected population does not change any original write-contract statuses.',
                          'Neither a negative unknown nor a contradiction verifies the target error Oracle.'],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generation-report', type=Path, default=ROOT/'generated/factor_packages/generation_report.json')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    raw = args.generation_report.read_bytes()
    result = audit_report(json.loads(raw))
    result['generation_report_sha256'] = hashlib.sha256(raw).hexdigest()
    result['checker_files_sha256'] = {
        name: hashlib.sha256((ROOT/name).read_bytes()).hexdigest()
        for name in ('core/finite_delete_contract.py', 'core/finite_sql_contract.py', 'core/shared_column_contract.py')
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x', encoding='utf-8') as target:
        json.dump(result, target, ensure_ascii=False, indent=2)
        target.write('\n')
    print(json.dumps(result['summary']))
    return int(result['summary']['positive_rejected'] > 0)


if __name__ == '__main__':
    raise SystemExit(main())
