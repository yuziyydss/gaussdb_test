#!/usr/bin/env python3
"""Account for every baseline case and every package source, without promoting status."""
import argparse
from collections import Counter
import json
from pathlib import Path
import re
import sys
import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from scripts.manage_extraction_queue import load_source_catalog, sha256_file


FOLLOWUP = {
    'fixture_unknown': '先核对实际 setup DDL 时序、ALTER/DROP 后的对象状态与定义歧义；若为 VIEW/派生表，再检查投影和可更新性，不能仅凭同名列判可写。',
    'query_unknown': '补可独立验证的查询投影/名称解析契约；数据修改 CTE 还需 RETURNING 和状态顺序证据。',
    'input_unknown': '明确 DEFAULT VALUES 的模式、列默认值与生成列语义，再校准结果；不假定所有缺省都可写。',
    'default_unknown': '核对实际 DDL 默认值、空值约束及兼容模式；需要运行时的默认表达式保留待校准。',
    'implicit_defaults_unknown': '验证前 N 列映射及尾部列的系统/显式默认值、非空约束和模式。',
    'cte_unknown': '递归/名称作用域需有限递归输出契约，不能把递归关键字剥去当普通 SELECT。',
    'statement_not_supported': '需要视图/派生写入目标或其他顶层产生式契约，不代表数据库不支持该语法。',
    'syntax_unknown': '对照本章 AST、合法/有意非法目标规则逐条核对；负向错误身份仍需校准。',
    'partition_routing_unknown': '核对 PARTITION/FOR 选择器与输入键的实际路由，不以合法列数替代分区匹配。',
    'branch_unknown': '补分支解析和独立列映射证据；条件选择行为需场景 Oracle。',
    'target_unknown': '补多表、ONLY/继承、派生目标与别名的作用域契约；不得猜测名称解析。',
    'self_from_requires_alias': '已识别文档明示的自连接 FROM 缺别名矛盾；仍须单独校准目标错误 Oracle，不等于数据库执行通过。',
    'partition_alias_form_not_supported': '已识别文档明示的无 AS 别名与指定分区组合矛盾；目标错误 Oracle 仍须单独校准，不能算执行通过。',
}


def case_index(report):
    result = {}
    for case in report['cases']:
        if case['case_id'] in result:
            raise ValueError('Duplicate case ID in audit: ' + case['case_id'])
        result[case['case_id']] = case
    return result


def reconcile_cases(before, after):
    # Identity fields alone do not bind SQL, setup/teardown or error Oracles.
    # Legacy audits remain readable, but absence cannot prove unchanged inputs.
    digests = []
    for report in (before, after):
        digest = report.get('generation_report_sha256')
        if 'generation_report_sha256' in report and (
                not isinstance(digest, str) or not re.fullmatch(r'[0-9a-f]{64}', digest)):
            raise ValueError('Invalid generation report SHA-256 in audit')
        digests.append(digest)
    available = all(digest is not None for digest in digests)
    unchanged = digests[0] == digests[1] if available else None
    generation_evidence = {
        'status': ('same_report_hash' if unchanged else 'different_report_hash')
                  if available else 'unavailable',
        'before_sha256': digests[0], 'after_sha256': digests[1],
        'reported_inputs_unchanged': unchanged,
        'database_verified': False,
        'limits': 'Compares hashes recorded by the audits; it does not independently '
                  're-read generation inputs or prove SQL correctness.'}
    old, new = case_index(before), case_index(after)
    if set(old) != set(new):
        raise ValueError('Case population changed; cannot silently replace baseline cases')
    rows, state_changes = [], []
    lifecycle_changes = []
    lifecycle_counts = {'before': Counter(), 'after': Counter()}

    def lifecycle_status(case):
        if 'lifecycle' not in case:
            return 'unavailable'  # Legacy audit did not establish this evidence.
        lifecycle = case['lifecycle']
        if (not isinstance(lifecycle, dict) or
                lifecycle.get('status') not in ('transaction_scoped', 'needs_review')):
            raise ValueError('Invalid lifecycle status: ' + case['case_id'])
        return lifecycle['status']

    allowed_statuses = {'needs_review', 'checked', 'rejected', 'not_applicable'}
    for cid, row in old.items():
        current = new[cid]
        for key in ('factor_id', 'manifest_id', 'expected'):
            if row[key] != current[key]:
                raise ValueError(f'Case identity changed: {cid}/{key}')
        old_lifecycle, new_lifecycle = lifecycle_status(row), lifecycle_status(current)
        lifecycle_counts['before'][old_lifecycle] += 1
        lifecycle_counts['after'][new_lifecycle] += 1
        if old_lifecycle != new_lifecycle:
            lifecycle_changes.append({'case_id': cid, 'factor_id': row['factor_id'],
                'manifest_id': row['manifest_id'], 'expected': row['expected'],
                'before_status': old_lifecycle, 'after_status': new_lifecycle,
                'database_verified': False})
        before_status = row['write_contract']['status']
        after_status = current['write_contract']['status']
        if before_status not in allowed_statuses or after_status not in allowed_statuses:
            raise ValueError(f'Unknown write-contract status: {cid}')
        if before_status != after_status:
            state_changes.append({'case_id': cid, 'factor_id': row['factor_id'],
                'manifest_id': row['manifest_id'], 'expected': row['expected'],
                'before_status': before_status, 'after_status': after_status,
                'database_verified': False})
        if before_status != 'needs_review':
            continue
        contract = current['write_contract']
        codes = [i['code'] for i in contract['issues']]
        rows.append({'case_id': cid, 'factor_id': row['factor_id'], 'manifest_id': row['manifest_id'],
            'before': row['write_contract'], 'after': contract,
            'disposition': 'finite_shape_evidence_added' if contract['status'] == 'checked' else 'still_requires_review',
            'next_action': [FOLLOWUP.get(code, '人工核对该有限检查器不支持的契约：' + code) for code in codes],
            'database_verified': False})
    return {'baseline_population': len(old), 'baseline_review_count': len(rows),
        'generation_evidence': generation_evidence,
        'identity_checked_cases': len(old),
        'population_status_counts': {
            'before': dict(Counter(r['write_contract']['status'] for r in old.values())),
            'after': dict(Counter(r['write_contract']['status'] for r in new.values()))},
        'state_changes': state_changes,
        'withdrawn_evidence_case_ids': [r['case_id'] for r in state_changes
                                      if r['before_status'] == 'checked' and r['after_status'] != 'checked'],
        'lifecycle': {'scope': 'static_lifecycle_shape_only',
            'population_status_counts': {k: dict(v) for k, v in lifecycle_counts.items()},
            'state_changes': lifecycle_changes,
            'withdrawn_evidence_case_ids': [r['case_id'] for r in lifecycle_changes
                                          if r['before_status'] == 'transaction_scoped' and
                                          r['after_status'] != 'transaction_scoped']},
        'dispositions': dict(Counter(r['disposition'] for r in rows)),
        'remaining_by_code': dict(Counter(i['code'] for r in rows for i in r['after']['issues'])),
        'rows': rows}


def audit_sources(factors, catalog_paths):
    # Validate the denominator before binding any source. A duplicated package
    # is invalid input, not two independently established pieces of evidence.
    root = ROOT.resolve()
    seen_ids, seen_paths = set(), set()
    for item in factors:
        if not isinstance(item, dict) or any(not isinstance(item.get(k), str) or not item[k]
                                             for k in ('factor_id', 'file')):
            raise ValueError('Invalid factor audit identity/path')
        path = (root / item['file']).resolve()
        if item['factor_id'] in seen_ids or path in seen_paths:
            raise ValueError('Duplicate factor ID or file in source audit: ' + item['factor_id'])
        seen_ids.add(item['factor_id'])
        seen_paths.add(path)

    catalogs = [load_source_catalog(p) for p in catalog_paths]
    index = {}
    for catalog in catalogs:
        for relpath, chapter in catalog['chapters'].items():
            key = (catalog['document_id'], relpath, chapter['chapter_sha256'])
            index.setdefault(key, (catalog, chapter))  # Canonical catalog first.

    def check(ref, version, parent_sha):
        key = (ref['document_id'], ref['source_relpath'], ref['chapter_sha256'])
        if key not in index:
            raise ValueError('Unresolved catalog/body reference: ' + str(key))
        catalog, chapter = index[key]
        root = Path(catalog['path']).parent.resolve()
        path = (root / ref['source_relpath']).resolve()
        if Path(ref['source_relpath']).is_absolute() or not path.is_relative_to(root):
            raise ValueError('Source escapes corpus')
        actual = sha256_file(path)
        if actual != ref['chapter_sha256'] or version != catalog['product_version'] or parent_sha != catalog['parent_pdf_sha256']:
            raise ValueError('Body/version/PDF drift: ' + str(path))
        return {'source_path': str(path), 'sha256': actual, 'catalog_path': catalog['path'],
                'parent_pdf_sha256': parent_sha}

    rows = []
    for item in factors:
        row = {'factor_id': item['factor_id'], 'main': None, 'supplemental': [], 'errors': []}
        try:
            path = (root / item['file']).resolve()
            if not path.is_relative_to(root):
                raise ValueError('Factor path escapes project')
            factor = yaml.safe_load(path.read_text())
            if not isinstance(factor, dict) or factor.get('id') != item['factor_id']:
                raise ValueError('Backlog/factor identity mismatch or invalid factor mapping')
            ledger_paths = list(path.parent.glob('*.source.yaml'))
            if len(ledger_paths) != 1:
                raise ValueError('Expected one source ledger')
            ledger_path = ledger_paths[0].resolve()
            if not ledger_path.is_relative_to(root):
                raise ValueError('Ledger path escapes project')
            ledger = yaml.safe_load(ledger_path.read_text())
            if not isinstance(ledger, dict) or ledger.get('factor_ref') != item['factor_id']:
                raise ValueError('Ledger/factor identity mismatch or invalid ledger mapping')
            source = factor['source']
            if ledger['artifact_sha256'] != source['artifact_sha256'] or source['artifact_sha256'] != source['catalog_chapter_ref']['chapter_sha256']:
                raise ValueError('Factor/ledger/catalog hash mismatch')
            row['main'] = check(source['catalog_chapter_ref'], source['version'], source['parent_pdf_sha256'])
            for supplement in ledger.get('supplemental_sources', []):
                row['supplemental'].append(check(supplement['catalog_chapter_ref'], supplement['version'], source['parent_pdf_sha256']))
        except (OSError, ValueError, KeyError, TypeError, yaml.YAMLError) as exc:
            row['errors'].append(str(exc))
        rows.append(row)
    return {'factor_count': len(rows), 'bound': sum(not r['errors'] for r in rows),
            'supplemental_edges': sum(len(r['supplemental']) for r in rows), 'rows': rows,
            'limits': 'Hash binding verifies provenance, not semantic completeness of extraction.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--before', type=Path, required=True)
    parser.add_argument('--after', type=Path, required=True)
    parser.add_argument('--backlog', type=Path, required=True)
    parser.add_argument('--catalog', action='append', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--require-same-generation', action='store_true',
                        help='Fail unless both audits record the same generation-report SHA-256')
    args = parser.parse_args()
    result = {'database_executed': False,
        'cases': reconcile_cases(json.loads(args.before.read_text()), json.loads(args.after.read_text())),
        'sources': audit_sources(json.loads(args.backlog.read_text())['factors'], args.catalog),
        'inputs': {str(p): sha256_file(p) for p in [args.before, args.after, args.backlog, *args.catalog]}}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'case_dispositions': result['cases']['dispositions'],
                      'generation_evidence': result['cases']['generation_evidence'],
                      'population_status_counts': result['cases']['population_status_counts'],
                      'withdrawn_evidence_case_ids': result['cases']['withdrawn_evidence_case_ids'],
                      'lifecycle': result['cases']['lifecycle'],
                      'sources': {k: v for k, v in result['sources'].items() if k != 'rows'}}, ensure_ascii=False))
    return int(result['sources']['bound'] != result['sources']['factor_count'] or
               (args.require_same_generation and
                result['cases']['generation_evidence']['reported_inputs_unchanged'] is not True))


if __name__ == '__main__':
    raise SystemExit(main())
