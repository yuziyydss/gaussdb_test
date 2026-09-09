#!/usr/bin/env python3
"""Fresh cumulative M finite-model audit, scoped to the frozen 93-command list.

No database executor is imported. Missing/unmodelled commands remain pending.
Does not mutate the loop queue: its derived acceptance is an evidence report.
"""
import hashlib
import itertools
import json
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.generator import validate_sql_syntax
from core.m_compat_environment import BOOTSTRAP_PATH,requires_m
from scripts.generate_factor_package_sql import render_sql_snapshot
from scripts.generate_m_compat_review_only import FACTOR_ID as REVIEW_FACTOR,OUTPUT as REVIEW_OUTPUT,build_review,render_review_sql


def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def pairs(combo,keys):return {(a,combo[a],b,combo[b]) for a,b in itertools.combinations(keys,2)}


def source_catalog_paths(registry):
    catalogs=set((ROOT/'work').glob('m_compat_batch_*/corpus/catalog.json'))
    refs={s.catalog_chapter_ref.source_relpath
          for ledger in registry.source_ledgers.values() for s in ledger.supplemental_sources
          if s.catalog_chapter_ref is not None}
    # This is the real dependency of M SUM, not every chapter of the full book.
    # main() still checks unique reference, document ID, body hash and parent PDF.
    if 'm_compat/utility/section_2_5_11.txt' in refs:
        catalogs.add(ROOT/'work/pdf_tiered_2026_09_07/batch_22/corpus/catalog.json')
    return sorted(catalogs)


def verify_general_snapshots(before, registry, generator, approved_additions, *, root=ROOT):
    """Keep the M startup baseline immutable; reconcile only explicit additions.

    The additions ledger is reviewed evidence, not automatically inferred from
    whatever files happen to exist. Hash, ownership, full rendered snapshot and
    exact case IDs must all agree. Changes/removal of old snapshots still fail.
    """
    after={str(p.relative_to(root)):sha(p)
           for p in (root/'generated/factor_packages').glob('*/*.sql')
           if not p.parent.name.startswith('m_')}
    for path,digest in before.items():
        assert after.get(path)==digest,('frozen general snapshot changed or missing',path)
    additions={};expected_paths=set();seen_ids=set()
    for mid,entry in approved_additions.items():
        assert set(entry)=={'factor_ref','snapshot_sha256','case_ids'},('addition evidence fields',mid)
        fid=entry['factor_ref']
        assert mid in registry.manifests and fid in registry.factors,('addition ownership',mid,fid)
        manifest=registry.manifests[mid]
        assert (not fid.startswith('m_') and manifest.factor_ref==fid and
                mid in registry.factors[fid].manifest_refs),('addition ownership',mid,fid)
        assert Path(mid).name==mid and Path(fid).name==fid,('addition path',mid,fid)
        path=f'generated/factor_packages/{fid}/{mid}.sql'
        assert path not in before,('cannot reapprove a frozen general snapshot',path)
        expected_paths.add(path)
        assert after.get(path)==entry['snapshot_sha256'],('addition hash or missing snapshot',path)
        cases,report=generator.generate_with_report(manifest)
        assert cases and report.pairwise_complete,('addition generation coverage',mid)
        case_ids=[case.case_id for case in cases]
        assert case_ids==entry['case_ids'],('addition case IDs drift',mid)
        assert len(set(case_ids))==len(case_ids) and not seen_ids.intersection(case_ids),('duplicate addition case IDs',mid)
        seen_ids.update(case_ids)
        assert (root/path).read_text()==render_sql_snapshot(mid,cases),('addition render drift',mid)
        additions[mid]=entry
    assert set(after)-set(before)==expected_paths,('unapproved general snapshots',sorted(set(after)-set(before)-expected_paths))
    return after,additions


def main():
    queue_path=ROOT/'work/m_compat_remaining_69_20260908/queue.json'
    queue=json.loads(queue_path.read_text())
    baseline_path=ROOT/queue['baseline_report']
    assert sha(baseline_path)==queue['baseline_sha256'],'startup baseline changed; do not silently redefine targets'
    baseline=json.loads(baseline_path.read_text())
    assert len(queue['commands'])==69 and len({x['factor_id'] for x in queue['commands']})==69
    expected_ids={'m_'+e['title'].lower().replace(' ','_') for e in baseline['entries']}
    assert len(expected_ids)==93
    assert {c['factor_id'] for c in queue['commands']} == {
        'm_'+e['title'].lower().replace(' ','_') for e in baseline['entries'] if e['stage']=='initial_source_only'},'target set changed'
    r=FactorPackageRegistry(ROOT/'specs');r.load_all()
    g=FactorPackageSQLGenerator(r);auditor=FactorCoverageAuditor(r)
    sources={};source_catalogs={}
    for catalog in source_catalog_paths(r):
        data=json.loads(catalog.read_text())
        for c in data['chapters']:
            sources[(c['section_number'],c['chapter_sha256'])]=(catalog.parent/c['source_relpath'],data['parent_pdf_sha256'])
            source_catalogs[(c['section_number'],c['chapter_sha256'])]=catalog
    parent=sha(ROOT/'gaussdb-rf-cent.pdf')
    results={};unaccepted={};ids=set();all_cases=0;tracked={baseline_path}
    manifests={}
    for fid in sorted(expected_ids & set(r.factors)):
        f=r.factors[fid]
        key=next((k for k in sources if k[1]==f.source.artifact_sha256 and k[0] in f.source.document),None)
        assert key is not None,('missing source',fid)
        source,pdf=sources[key]
        assert pdf==parent==f.source.parent_pdf_sha256 and sha(source)==f.source.artifact_sha256,fid
        tracked.add(source)
        tracked.add(source_catalogs[key])
        ledger=r.source_ledgers[f.source_ledger_ref]
        for supplement in ledger.supplemental_sources:
            ref=supplement.catalog_chapter_ref
            assert ref is not None,('M audit requires local PDF supplemental evidence',fid,supplement.id)
            matches=[k for k,(path,_) in sources.items() if k[1]==ref.chapter_sha256 and
                path.as_posix().endswith('/'+ref.source_relpath)]
            assert len(matches)==1,('missing/ambiguous supplemental chapter',fid,supplement.id)
            extra,extra_pdf=sources[matches[0]]
            extra_catalog=source_catalogs[matches[0]]
            assert sha(extra)==ref.chapter_sha256 and extra_pdf==parent,(fid,supplement.id)
            assert json.loads(extra_catalog.read_text())['document_id']==ref.document_id,(fid,supplement.id)
            tracked.update([extra,extra_catalog])
        lines=[n for u in ledger.units for n in range(u.line_start,u.line_end+1)]+[i.line for i in ledger.ignored_lines]
        assert sorted(lines)==list(range(1,len(source.read_text().splitlines())+1)),fid
        tracked.update((ROOT/'specs'/f.category.lower()/fid).rglob('*.yaml'))
        if not f.manifest_refs:
            audit=auditor.audit(fid)
            assert not audit['manifests']['errors'] and not audit['facts']['wrong_consumer_type'],fid
            assert not audit['conclusions']['generation_model_complete'],fid
            unaccepted[fid]=dict(status='registered_without_generation_acceptance',cases=0,
                source_sha256=sha(source),conclusions=audit['conclusions'],
                pending_fixture_refs=[ref for ref in f.fixture_refs if r.fixtures[ref].execution.status!='ready'],
                planned_scenario_refs=[ref for ref in f.scenario_refs if r.scenarios[ref].status=='planned'])
            if fid==REVIEW_FACTOR:
                review=build_review(r)
                assert json.loads((REVIEW_OUTPUT/'review.json').read_text())==review,fid
                assert (REVIEW_OUTPUT/'review.sql').read_text()==render_review_sql(review),fid
                tracked.update([REVIEW_OUTPUT/'review.json',REVIEW_OUTPUT/'review.sql'])
                unaccepted[fid]['review_only_sql_path']=str((REVIEW_OUTPUT/'review.sql').relative_to(ROOT))
            print(fid,'registered, NOT finite-static verified; ordinary cases=0',flush=True)
            continue
        count=0;own_sql=set();required=0;restricted_applicability=set()
        assert f.manifest_refs,('no manifests',fid)
        for mid in f.manifest_refs:
            m=r.manifests[mid];cases,report=g.generate_with_report(m)
            for requirement in m.environment_requirements:
                if requirement.key=='command_applicability':
                    restricted_applicability.update(requirement.allowed_values)
            again,_=g.generate_with_report(m)
            assert cases and report.pairwise_complete,mid
            assert [c.to_dict() for c in cases]==[c.to_dict() for c in again],mid
            resolved=r.resolve_dimension_values(fid);domain=g.build_param_space(f,m)
            varying=[k for k,v in domain.items() if len(v)>1]
            solver=g._build_solver(f,m,resolved)
            feasible=set();observed=set();viable_values={k:set() for k in domain}
            # This independent oracle is intentionally bounded, never silently
            # falls back to sampling and never enumerates billion-size spaces.
            size=1
            for values in domain.values():size*=len(values)
            assert size<=100000,('split manifest or add solver-backed audit',mid,size)
            for values in itertools.product(*domain.values()):
                combo=dict(zip(domain,values))
                if solver.is_valid(combo)[0]:
                    feasible.update(pairs(combo,varying))
                    for key,value in combo.items():viable_values[key].add(value)
            for dim,values in m.bindings.items():
                observed_values={c.params[dim] for c in cases}
                # A value ruled infeasible must not be counted as covered.
                viable=viable_values[dim]
                assert observed_values==viable,(mid,dim,viable-observed_values)
            for c in cases:
                assert c.case_id not in ids and c.sql not in own_sql,mid
                ids.add(c.case_id);own_sql.add(c.sql)
                assert requires_m(c) and set(varying)<=set(c.consumed_dimension_ids),mid
                assert solver.is_valid(c.params)[0],c.case_id
                assert c.setup_sqls and c.teardown_sqls and 'SELECT 1;' not in c.setup_sqls,c.case_id
                for asset in getattr(c,'file_assets',[]):
                    asset_path=ROOT/asset['repository_source_path']
                    assert sha(asset_path)==asset['sha256'],(c.case_id,'file asset SHA')
                    assert asset['deployment_required'] and not asset['deployed'],c.case_id
                    tracked.add(asset_path)
                for sql in [c.sql]+c.setup_sqls+c.teardown_sqls:
                    assert validate_sql_syntax(sql)[0],(c.case_id,sql)
                observed.update(pairs(c.params,varying))
            assert observed==feasible,(mid,feasible-observed)
            path=ROOT/'generated/factor_packages'/fid/(mid+'.sql')
            text=render_sql_snapshot(mid,cases)
            assert path.read_text()==text and BOOTSTRAP_PATH in text,path
            tracked.add(path)
            count+=len(cases);required+=len(feasible)
            manifests[mid]=dict(cases=len(cases),required_pairs=len(feasible),covered_pairs=len(observed),missing_pairs=[],
                snapshot_sha256=sha(path),cases_sha256=hashlib.sha256(json.dumps([c.to_dict() for c in cases],sort_keys=True).encode()).hexdigest())
        audit=auditor.audit(fid)
        assert not audit['manifests']['errors'] and not audit['facts']['wrong_consumer_type'],fid
        results[fid]=dict(status='finite_static_verified',cases=count,required_pairs=required,
            restricted_applicability=sorted(restricted_applicability),
            source_sha256=sha(source),conclusions=audit['conclusions'],
            source_unmapped=len(audit['source_units']['unmapped']),atomicity_gaps=len(audit['source_units']['atomicity']['gaps']),
            unresolved_error_oracles=audit['manifests']['unresolved_error_oracles'],
            planned_scenarios=sum(r.scenarios[s].status=='planned' for s in f.scenario_refs))
        all_cases+=count
        tracked.update((ROOT/'specs'/f.category.lower()/fid).rglob('*.yaml'))
        print(fid,count,'finite-static, not whole-chapter or database verified',flush=True)
    frozen_path=ROOT/'generated/m_compat_batch_01/non_m_snapshot_comparison.json'
    before=json.loads(frozen_path.read_text())['before_file_sha256']
    additions_path=ROOT/'generated/general_snapshot_additions.json'
    approved_additions=json.loads(additions_path.read_text()) if additions_path.exists() else {}
    after,general_additions=verify_general_snapshots(before,r,g,approved_additions)
    tracked.add(frozen_path)
    if additions_path.exists():tracked.add(additions_path)
    tracked.update(ROOT/path for path in after)
    tracked.update((ROOT/'core').glob('*.py'))
    tracked.update((ROOT/'scripts').glob('*m_compat*.py'))
    tracked.update((ROOT/'tests').glob('test_m_compat*.py'))
    targets={c['factor_id'] for c in queue['commands']}
    done=targets & set(results)
    output=dict(total_commands=93,registered_finite_packages=len(results),total_m_cases=all_cases,
        registered_packages=len(results)+len(unaccepted),
        missing_package_ids=sorted(expected_ids-set(results)-set(unaccepted)),
        registered_unaccepted_packages=unaccepted,
        target_count=69,target_finite_verified=len(done),remaining_target_ids=sorted(targets-done),
        target_registered=len(targets & (set(results)|set(unaccepted))),
        all_69_finite_complete=len(done)==69,database_executed=False,
        restricted_finite_package_ids=sorted(fid for fid,data in results.items() if data['restricted_applicability']),
        whole_chapter_coverage_claimed=False,non_m_snapshot_count=len(after),non_m_snapshot_changes=[],
        non_m_frozen_snapshot_count=len(before),non_m_snapshot_additions=general_additions,
        parent_pdf_sha256=parent,packages=results,manifests=manifests,
        input_fingerprints={str(p.relative_to(ROOT)):sha(p) for p in sorted(tracked)},
        limitations='Finite-domain generation audit only. Planned scenarios, unreviewed source units and uncalibrated Oracles stay open.')
    directory=ROOT/'generated/m_compat_remaining';directory.mkdir(exist_ok=True,parents=True)
    (directory/'progress.json').write_text(json.dumps(output,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({k:v for k,v in output.items() if k not in ('packages','manifests','input_fingerprints')},ensure_ascii=False))


if __name__=='__main__':main()
