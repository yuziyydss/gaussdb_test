"""Reconcile active candidates and explicitly retained review history; no DB."""
import argparse
import hashlib
import json
from pathlib import Path
import sys
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from core.factor_package_model import FactorPackageRegistry
from scripts.generate_factor_package_sql import render_sql_snapshot


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def audit_inventory(registry, report, retirements, *, root=ROOT):
    entries = report['manifests']
    if set(entries) != set(registry.manifests):
        raise ValueError('Full active registry/report manifest set differs')
    active_paths, active_ids = set(), set()
    for mid, entry in entries.items():
        manifest = registry.manifests[mid]
        fid = manifest.factor_ref
        if mid not in registry.factors[fid].manifest_refs:
            raise ValueError('Active manifest ownership differs')
        path = f'generated/factor_packages/{fid}/{mid}.sql'
        expected = render_sql_snapshot(mid, [SimpleNamespace(**c) for c in entry['cases']])
        if not (root/path).is_file() or (root/path).read_text() != expected:
            raise ValueError('Active snapshot/report render differs: '+mid)
        active_paths.add(path)
        for case in entry['cases']:
            if case['factor_id'] != fid or case['case_id'] in active_ids:
                raise ValueError('Active case identity differs or is duplicated')
            active_ids.add(case['case_id'])
    retired_paths, retired_ids = audit_retained_snapshots(registry, entries, active_ids, retirements, root=root)
    files = {str(p.relative_to(root)) for p in (root/'generated/factor_packages').glob('*/*.sql')}
    if files != active_paths | retired_paths:
        raise ValueError('Snapshot inventory contains missing or unclassified files')
    return dict(database_executed=False, active_manifest_count=len(active_paths),
                active_case_count=len(active_ids), historical_review_snapshot_count=len(retired_paths),
                historical_review_case_count=len(retired_ids), physical_sql_file_count=len(files),
                retired_case_ids=sorted(retired_ids),
                limits=['Historical SQL is retained evidence, not an active suite or execution authorization.',
                        'Reconciliation proves identities and accounting, not SQL correctness or a runtime Oracle.'])


def audit_retained_snapshots(registry, entries, active_ids, retirements, *, root=ROOT):
    retired_paths, retired_ids = set(), set()
    for mid, entry in retirements.items():
        if set(entry) != {'factor_ref', 'scenario_ref', 'case_ids', 'original_case_sha256', 'snapshot_sha256', 'archived_manifest_sha256'}:
            raise ValueError('Retirement evidence fields differ')
        if mid in entries or mid in registry.manifests:
            raise ValueError('Retired candidate is still active')
        fid, sid = entry['factor_ref'], entry['scenario_ref']
        if any(Path(x).name != x or x in ('.', '..') for x in (mid, fid, sid)):
            raise ValueError('Unsafe retirement identity')
        factor = registry.factors.get(fid)
        scenario = registry.scenarios.get(sid)
        if (not factor or not scenario or sid not in factor.scenario_refs
                or scenario.factor_ref != fid or scenario.status != 'planned'):
            raise ValueError('Retirement must have an owned planned scenario')
        facts = {f.id: f for f in factor.facts}
        if not any(ref in facts and facts[ref].type == 'open_question'
                   and facts[ref].status == 'needs_verification' for ref in scenario.fact_refs):
            raise ValueError('Retirement needs an unresolved source question')
        path = f'generated/factor_packages/{fid}/{mid}.sql'
        cases = []
        for variant in scenario.variants:
            if not isinstance(variant, dict) or variant.get('historical_snapshot_path') != path:
                continue
            if variant.get('execution_allowed') is not False or variant.get('status') != 'needs_verification':
                raise ValueError('Retired variant must be explicitly non-executable and pending')
            original = variant.get('original_case', {})
            if original.get('factor_id') != fid or original.get('expected_oracle_status') != 'needs_verification':
                raise ValueError('Historical case ownership or pending oracle differs')
            archive = Path(variant.get('original_manifest_path', ''))
            if archive.is_absolute() or '..' in archive.parts or not archive.parts or archive.parts[0] != 'archive':
                raise ValueError('Archived manifest must stay in project archive')
            if not (root/archive).is_file() or digest(root/archive) != entry['archived_manifest_sha256']:
                raise ValueError('Archived manifest identity differs')
            cases.append(original)
        ids = [c.get('case_id') for c in cases]
        if not cases or ids != entry['case_ids'] or len(set(ids)) != len(ids):
            raise ValueError('Historical case IDs differ or are missing')
        actual_hashes = {c['case_id']: hashlib.sha256(json.dumps(c, ensure_ascii=False, sort_keys=True,
                         separators=(',', ':')).encode()).hexdigest() for c in cases}
        if actual_hashes != entry['original_case_sha256']:
            raise ValueError('Historical full case fields differ')
        if active_ids.intersection(ids) or retired_ids.intersection(ids):
            raise ValueError('Retired case overlaps an active or another retired case')
        if not (root/path).is_file() or digest(root/path) != entry['snapshot_sha256']:
            raise ValueError('Historical snapshot identity differs')
        if (root/path).read_text() != render_sql_snapshot(mid, [SimpleNamespace(**c) for c in cases]):
            raise ValueError('Historical scenario no longer preserves the full original case')
        retired_paths.add(path)
        retired_ids.update(ids)
    return retired_paths, retired_ids


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    registry = FactorPackageRegistry(ROOT/'specs')
    registry.load_all()
    base = ROOT/'generated/factor_packages'
    report = base/'generation_report.json'
    ledger = base/'candidate_retirements.json'
    result = audit_inventory(registry, json.loads(report.read_text()),
                             json.loads(ledger.read_text()) if ledger.exists() else {})
    result['input_sha256'] = {str(p.relative_to(ROOT)): digest(p) for p in (report, ledger, Path(__file__)) if p.exists()}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open('x') as output:
        json.dump(result, output, ensure_ascii=False, indent=2)
        output.write('\n')
    print(json.dumps({k: v for k, v in result.items() if k not in ('input_sha256', 'limits')}, ensure_ascii=False))


if __name__ == '__main__':
    main()
