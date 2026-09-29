#!/usr/bin/env python3
"""Build and verify the master summary for core function extraction waves."""
from __future__ import annotations
import argparse, hashlib, json, sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any
import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path: sys.path.insert(0, str(ROOT))
CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
OUTPUT_PATH = ROOT / 'generated/core_function_extraction_master_summary_v1/summary.json'

def sha256(path: Path) -> str: return hashlib.sha256(path.read_bytes()).hexdigest()

def build_summary() -> dict[str, Any]:
    catalog = json.loads(CATALOG_PATH.read_text(encoding='utf-8'))
    catalog_by_section = {c.get('section_number'): c for c in catalog['chapters']}
    manifest_paths = sorted((ROOT / 'generated').glob('core_*_v1/manifest.json'))
    if not manifest_paths: raise ValueError('no extraction manifests found')
    artifacts=[]; all_fact_ids=[]; all_oq_ids=[]; fact_types=Counter(); fact_status=Counter(); oq_status=Counter()
    section_pages=defaultdict(set); source_slice_count=0; source_count=0
    for path in manifest_paths:
        manifest=json.loads(path.read_text(encoding='utf-8'))
        artifact_id=manifest.get('id'); 
        if not artifact_id: raise ValueError(f'missing id: {path}')
        facts_source=manifest.get('facts_source',{}); facts_rel=facts_source.get('path'); 
        if not facts_rel: raise ValueError(f'missing facts path: {path}')
        facts_path=ROOT/facts_rel
        if not facts_path.is_file() or facts_source.get('sha256') != sha256(facts_path):
            raise ValueError(f'facts hash drift: {artifact_id}')
        payload=yaml.safe_load(facts_path.read_text(encoding='utf-8'))
        facts=payload.get('facts',[]); oqs=payload.get('open_questions',[])
        fact_ids=[x['id'] for x in facts]
        all_fact_ids.extend(fact_ids); all_oq_ids.extend(x['id'] for x in oqs)
        fact_types.update(x['type'] for x in facts); fact_status.update(x['status'] for x in facts)
        oq_status.update(x['status'] for x in oqs)
        if manifest.get('summary',{}).get('fact_count') != len(facts): raise ValueError(f'fact count mismatch: {artifact_id}')
        if manifest.get('summary',{}).get('open_question_count') != len(oqs): raise ValueError(f'open question mismatch: {artifact_id}')
        if manifest.get('fact_ids') not in (None, fact_ids): raise ValueError(f'fact_ids mismatch: {artifact_id}')
        source_count += len(manifest.get('sources',[]))
        source_slice_count += sum(int(s.get('physical_page_end',0))-int(s.get('physical_page_start',0)) for s in manifest.get('sources',[]))
        for source in manifest.get('sources',[]):
            section=source.get('section_number'); start=int(source.get('physical_page_start',0)); end=int(source.get('physical_page_end',0))
            if not section or end < start: continue
            section_pages[section].update(range(start,end))
            catalog_ch=catalog_by_section.get(section)
            if catalog_ch and 'chapter_sha256' in source and source.get('chapter_sha256') != catalog_ch.get('chapter_sha256'):
                raise ValueError(f'chapter hash mismatch for {section} in {artifact_id}')
        artifacts.append({'artifact_id':artifact_id,'manifest_relpath':path.relative_to(ROOT).as_posix(),'facts_relpath':facts_rel,'fact_count':len(facts),'open_question_count':len(oqs),'source_count':len(manifest.get('sources',[]))})
    if len(all_fact_ids)!=len(set(all_fact_ids)): raise ValueError('duplicate fact ids across extraction waves')
    if len(all_oq_ids)!=len(set(all_oq_ids)): raise ValueError('duplicate open question ids across extraction waves')

    sections=[]; full_sections=0
    for section in sorted(section_pages, key=lambda s: [int(x) if x.isdigit() else 0 for x in s.split('.')]):
        covered=section_pages[section]; catalog_ch=catalog_by_section.get(section)
        if not catalog_ch: continue
        start=int(catalog_ch['physical_page_start']); end=int(catalog_ch['physical_page_end'])
        required=set(range(start,end+1)); missing=sorted(required-covered); extra=sorted(covered-required)
        complete=not missing and not extra; full_sections += int(complete)
        sections.append({'section_number':section,'title':catalog_ch.get('title',''),'physical_page_start':start,'physical_page_end_inclusive':end,'required_page_count':len(required),'covered_page_count':len(covered & required),'missing_pages':missing,'extra_pages':extra,'coverage_complete':complete})
    covered_pages=set().union(*section_pages.values()) if section_pages else set()
    required_pages=set()
    for section in section_pages:
        ch=catalog_by_section.get(section)
        if ch: required_pages.update(range(int(ch['physical_page_start']),int(ch['physical_page_end'])+1))
    return {'schema_version':1,'kind':'core_function_extraction_master_summary','id':'core_function_extraction_master_summary_v1','name':'Core Function Extraction Master Summary','description':'Master aggregation of core function extraction manifests and facts.','catalog':{'path':CATALOG_PATH.relative_to(ROOT).as_posix(),'sha256':sha256(CATALOG_PATH),'document_id':catalog['document_id'],'document_version':catalog['document_version']},'summary':{'artifact_count':len(artifacts),'source_count':source_count,'source_page_slice_count':source_slice_count,'unique_page_count':len(covered_pages),'section_count':len(sections),'full_section_count':full_sections,'fact_count':len(all_fact_ids),'unique_fact_id_count':len(set(all_fact_ids)),'open_question_count':len(all_oq_ids),'unique_open_question_id_count':len(set(all_oq_ids)),'fact_type_counts':dict(sorted(fact_types.items())),'confirmed_fact_count':fact_status.get('confirmed',0),'open_question_count_by_status':dict(sorted(oq_status.items())),'all_fact_ids_unique':len(all_fact_ids)==len(set(all_fact_ids)),'all_open_question_ids_unique':len(all_oq_ids)==len(set(all_oq_ids)),'database_executed':False,'runtime_verified':False},'coverage':{'mode':'included_extraction_artifacts','covered_page_count':len(covered_pages & required_pages),'required_page_count':len(required_pages),'missing_pages':sorted(required_pages-covered_pages),'extra_pages':sorted(covered_pages-required_pages),'complete':not (required_pages-covered_pages) and not (covered_pages-required_pages),'sections':sections},'artifacts':artifacts}

def main(argv=None) -> int:
    parser=argparse.ArgumentParser(); parser.add_argument('--check',action='store_true'); args=parser.parse_args(argv)
    current=build_summary(); rendered=json.dumps(current,ensure_ascii=False,indent=2)+'\n'
    if args.check and OUTPUT_PATH.exists() and OUTPUT_PATH.read_text(encoding='utf-8')!=rendered:
        print('Core function extraction master summary check failed: artifact drift'); return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True,exist_ok=True); OUTPUT_PATH.write_text(rendered,encoding='utf-8')
    s=current['summary']; c=current['coverage']; print(f"Core function extraction master summary written: {OUTPUT_PATH} artifacts={s['artifact_count']} facts={s['fact_count']} sections={s['section_count']} full_sections={s['full_section_count']} pages={c['covered_page_count']}/{c['required_page_count']}")
    return 0
if __name__=='__main__': raise SystemExit(main())
