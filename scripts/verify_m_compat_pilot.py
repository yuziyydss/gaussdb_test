#!/usr/bin/env python3
"""Rebuild M pilot static evidence. Does not import a database executor."""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import sys
from collections import Counter

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.finite_sql_contract import inspect_write
from scripts.generate_factor_package_sql import render_sql_snapshot

PILOT = ('m_create_table','m_create_view','m_insert','m_update','m_delete','m_select')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def pairs(combo, dimensions):
    return {(a,combo[a],b,combo[b]) for a,b in itertools.combinations(dimensions,2)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--batch', choices=['01','02'], default='01')
    args = parser.parse_args()
    corpus = ROOT/f'work/m_compat_batch_{args.batch}/corpus'
    selected = PILOT if args.batch == '01' else tuple(
        'm_'+c['title'].lower().replace(' ','_')
        for c in json.loads((corpus/'catalog.json').read_text())['chapters'])
    r = FactorPackageRegistry(ROOT/'specs')
    r.load_all()
    pdf_sha = digest(ROOT/'gaussdb-rf-cent.pdf')
    g, auditor = FactorPackageSQLGenerator(r), FactorCoverageAuditor(r)
    output = ROOT/f'generated/m_compat_batch_{args.batch}'
    output.mkdir(parents=True,exist_ok=True)
    manifest_results, package_results, ids = {}, {}, set()
    for fid in selected:
        f = r.factors[fid]
        assert f.source.parent_pdf_sha256 == pdf_sha, fid
        src = corpus/f.source.catalog_chapter_ref.source_relpath
        assert digest(src) == f.source.artifact_sha256, fid
        own_sql = set()
        for mid in f.manifest_refs:
            m = r.manifests[mid]
            cases, report = g.generate_with_report(m)
            assert cases and report.pairwise_complete, mid
            resolved = r.resolve_dimension_values(fid)
            domain = g.build_param_space(f,m)
            solver = g._build_solver(f,m,resolved)
            varying = [key for key,values in domain.items() if len(values)>1]
            # Independently enumerate this bounded pilot's feasible domain,
            # not the greedy algorithm's internal covered-pair counter.
            feasible_pairs = set()
            feasible_count = 0
            for values in itertools.product(*domain.values()):
                combo = dict(zip(domain,values))
                if solver.is_valid(combo)[0]:
                    feasible_count += 1
                    feasible_pairs.update(pairs(combo,varying))
            observed = set()
            for c in cases:
                assert c.case_id not in ids and c.sql not in own_sql, mid
                ids.add(c.case_id)
                own_sql.add(c.sql)
                assert set(varying).issubset(c.consumed_dimension_ids), (mid,c.sql)
                observed.update(pairs(c.params,varying))
            assert observed == feasible_pairs, mid
            snapshot = render_sql_snapshot(mid,cases)
            canonical = ROOT/'generated/factor_packages'/fid/(mid+'.sql')
            assert canonical.read_text() == snapshot, str(canonical)
            case_dir = output/fid
            case_dir.mkdir(exist_ok=True)
            (case_dir/(mid+'.sql')).write_text(snapshot,encoding='utf-8')
            diagnostics = {c.case_id:inspect_write(c.sql,c.setup_sqls) for c in cases if c.expected=='success'}
            manifest_results[mid] = dict(
                factor_id=fid, cases=[c.to_dict() for c in cases], report=report.to_dict(),
                bounded_feasible_combinations=feasible_count,
                nonconstant_dimensions=varying,
                required_nonconstant_pairs=len(feasible_pairs), covered_nonconstant_pairs=len(observed),
                missing_nonconstant_pairs=[], rendered_write_diagnostics=diagnostics,
                note='独立枚举验证组合算法；仍依赖所抽规则，不证明规则完整/数据库语法正确。')
        audit = auditor.audit(fid)
        (output/fid/'coverage_audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n')
        package_results[fid] = dict(source_sha256=digest(src),
            source_lines=len(src.read_text().splitlines()), facts=len(f.facts),
            manifest_count=len(f.manifest_refs), scenarios=len(f.scenario_refs),
            case_count=sum(len(manifest_results[mid]['cases']) for mid in f.manifest_refs),
            source_unmapped=len(audit['source_units']['unmapped']),
            atomicity_gaps=len(audit['source_units']['atomicity']['gaps']),
            conclusions=audit['conclusions'],
            unresolved_error_oracles=audit['manifests']['unresolved_error_oracles'],
            fact_consumers_wrong=audit['facts']['wrong_consumer_type'],
            generation_errors=audit['manifests']['errors'])
        assert not package_results[fid]['generation_errors'], fid
        print(fid, package_results[fid])
    registry_graph = r.factor_dependency_graph()
    tracked = sorted({Path(path) for fid in selected for path in (ROOT/'specs'/r.factors[fid].category.lower()/fid).rglob('*.yaml')})
    tracked += sorted((ROOT/'core').rglob('*.py'))
    tracked += [Path(__file__),ROOT/'scripts/build_m_compat_pilot.py',
                ROOT/'scripts/generate_factor_package_sql.py',ROOT/'tests/test_m_compat_pilot.py']
    tracked += [ROOT/'core/m_compat_environment.py',ROOT/'scripts/prepare_m_compat_environment.py',
                ROOT/'tests/test_m_compat_environment.py']
    if args.batch == '02':
        tracked += [ROOT/'scripts/build_m_compat_batch_02.py',ROOT/'tests/test_m_compat_batch_02.py']
    result = dict(stage='finite_m_pilot_static_not_full_chapter', execution_authorized=False,
        database_executed=False, parent_pdf_sha256=pdf_sha,
        package_results=package_results, manifests=manifest_results,
        case_ids_unique=len(ids),
        dependencies={fid:sorted(registry_graph[fid]) for fid in selected},
        input_fingerprints={str(p.relative_to(ROOT)):digest(p) for p in tracked})
    (output/'generation_report.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    initial_path=ROOT/'work/pdf_tiered_2026_09_07/batch_28/initial_extraction_r1.json'
    initial=json.loads(initial_path.read_text())
    entries=[]
    for item in initial['chapters'][0]['entries']:
        if item['kind'] != 'm_command_source':
            continue
        section,title=item['heading'].split(' ',1)
        fid='m_'+title.lower().replace(' ','_')
        entries.append(dict(section=section,title=title,
            source_entry_id=item['entry_id'],source_span_sha256=item['source_block_until_next_entry']['span_sha256'],
            package_id=fid if fid in r.factors else None,
            stage=('finite_pilot_static' if fid in selected else
                   'package_registered_not_audited_by_this_batch' if fid in r.factors else 'initial_source_only'),
            database_verified=False))
    assert len(entries)==93 and sum(e['stage']=='finite_pilot_static' for e in entries)==len(selected)
    (output/'m_command_progress.json').write_text(json.dumps(dict(
        initial_index_sha256=digest(initial_path),parent_pdf_sha256=initial['parent_pdf_sha256'],
        total=93,stage_counts=dict(Counter(e['stage'] for e in entries)),entries=entries),ensure_ascii=False,indent=2)+'\n')
    print('Static evidence:',output/'generation_report.json','unique cases:',len(ids))
    if args.batch == '02':
        first_path = ROOT/'generated/m_compat_batch_01/generation_report.json'
        first = json.loads(first_path.read_text())
        assert all(digest(ROOT/path)==sha for path,sha in first['input_fingerprints'].items()), 'Batch 01 evidence stale; reverify first'
        for entry in entries:
            if entry['package_id'] in PILOT + selected:
                entry['stage'] = 'finite_model_static_verified'
        baseline = json.loads((ROOT/'generated/m_compat_batch_01/non_m_snapshot_comparison.json').read_text())['before_file_sha256']
        actual = {str(p.relative_to(ROOT)):digest(p) for p in (ROOT/'generated/factor_packages').glob('*/*.sql')
                  if not p.parent.name.startswith('m_')}
        comparison = dict(before=len(baseline),after=len(actual),
            changed=[p for p in baseline if p in actual and baseline[p]!=actual[p]],
            missing=sorted(set(baseline)-set(actual)), added=sorted(set(actual)-set(baseline)))
        assert not comparison['changed'] and not comparison['missing'] and not comparison['added'], comparison
        combined = dict(total_commands=93, finite_packages=len(PILOT)+len(selected),
            total_cases=first['case_ids_unique']+len(ids), database_executed=False,
            stage_counts=dict(Counter(e['stage'] for e in entries)), entries=entries,
            non_m_snapshot_comparison=comparison, evidence_reports=[str(first_path.relative_to(ROOT)),
                str((output/'generation_report.json').relative_to(ROOT))],
            limitations='有限模型的组合覆盖，不是全章语义覆盖；M 实机执行尚未授权和校准。')
        (output/'combined_progress.json').write_text(json.dumps(combined,ensure_ascii=False,indent=2)+'\n')


if __name__=='__main__':
    main()
