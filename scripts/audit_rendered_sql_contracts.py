#!/usr/bin/env python3
"""Audit rendered write shapes and lifecycle risks without database execution."""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.finite_sql_contract import inspect_write, inspect_lifecycle


def audit_report(report):
    rows = []
    for mid, entry in report['manifests'].items():
        for case in entry['cases']:
            write = inspect_write(case['sql'], case['setup_sqls'])
            # M writes share the finite checker, not a guarantee that every M
            # dialect form is supported. Preserve its needs_review/rejected
            # evidence instead of erasing it based on the package prefix.
            if case['factor_id'] not in {'update', 'insert', 'insert_all', 'replace',
                                         'm_update', 'm_insert', 'm_replace'}:
                write = {'status': 'not_applicable', 'checks': [], 'issues': []}
            rows.append({'case_id': case['case_id'], 'manifest_id': mid,
                         'factor_id': case['factor_id'], 'expected': case['expected'],
                         'write_contract': write,
                         'lifecycle': inspect_lifecycle(case['setup_sqls'], case['teardown_sqls'])})
    return {'database_executed': False,
            'limits': ['checked means finite write shape only, not full SQL correctness or execution success',
                       'needs_review is not pass; unsupported dialect/expressions/casts stay explicit',
                       'negative contradictions do not prove the target error oracle',
                       'transaction_scoped is a static shape, not shared-database safety approval'],
            'summary': {'cases': len(rows),
                        'write_contract': dict(Counter(r['write_contract']['status'] for r in rows)),
                        'positive_rejected': sum(r['expected'] == 'success' and r['write_contract']['status'] == 'rejected' for r in rows),
                        'lifecycle': dict(Counter(r['lifecycle']['status'] for r in rows))},
            'cases': rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--generation-report', type=Path, default=ROOT / 'generated/factor_packages/generation_report.json')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    raw = args.generation_report.read_bytes()
    result = audit_report(json.loads(raw))
    result['generation_report_sha256'] = hashlib.sha256(raw).hexdigest()
    result['checker_files_sha256'] = {
        name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
        for name in ('core/finite_sql_contract.py', 'core/shared_column_contract.py')
    }
    result['checker_sha256'] = hashlib.sha256(
        json.dumps(result['checker_files_sha256'], sort_keys=True).encode()).hexdigest()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(result['summary'], ensure_ascii=False))
    return int(result['summary']['positive_rejected'] > 0)


if __name__ == '__main__':
    raise SystemExit(main())
