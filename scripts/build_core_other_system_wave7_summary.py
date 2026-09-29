#!/usr/bin/env python3
"""Build and verify the Other System Functions Wave 7 summary for 1.6.60."""
from __future__ import annotations
import argparse, hashlib, json, re, sys
from collections import Counter
from pathlib import Path
from typing import Any
import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path: sys.path.insert(0, str(ROOT))
CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
OUTPUT_PATH = ROOT / 'generated/core_other_system_wave7_summary_v1/summary.json'
SECTION = '1.6.60'
WAVE_SUFFIXES = ('9', '10')

def sha256(path: Path) -> str: return hashlib.sha256(path.read_bytes()).hexdigest()
WAVE_IDS = {
    '9': 'core_other_system_pg_compat_wave7_9_v1',
    '10': 'core_other_system_internal_wave7_10_v1',
}

def wave_id(suffix: str) -> str: return WAVE_IDS[suffix]
def manifest_path(wave: str) -> Path: return ROOT / 'generated' / wave / 'manifest.json'

def build_summary() -> dict[str, Any]:
    catalog_payload = json.loads(CATALOG_PATH.read_text(encoding='utf-8'))
    chapters = [c for c in catalog_payload['chapters'] if c.get('section_number') == SECTION]
    if len(chapters) != 1: raise ValueError(f'expected one catalog chapter for {SECTION}')
    chapter = chapters[0]
    catalog_start, catalog_end = int(chapter['physical_page_start']), int(chapter['physical_page_end'])
    required_pages = set(range(catalog_start, catalog_end + 1))
    waves=[]; all_fact_ids=[]; all_oq_ids=[]; fact_types=Counter(); fact_status=Counter(); oq_status=Counter()
    covered=set(); catalog_hashes=set(); chapter_hashes=set()
    for suffix in WAVE_SUFFIXES:
        wid=wave_id(suffix); path=manifest_path(wid)
        if not path.is_file(): raise FileNotFoundError(f'missing manifest: {path}')
        manifest=json.loads(path.read_text(encoding='utf-8'))
        if manifest.get('id') != wid: raise ValueError(f'unexpected id in {path}')
        catalog_hashes.add(manifest.get('catalog',{}).get('sha256'))
        scope=manifest['scope']; start=int(scope['physical_page_start']); end=int(scope['physical_page_end_exclusive'])-1
        covered.update(range(start,end+1))
        fs=manifest.get('facts_source',{}); facts_path=ROOT/fs.get('path','')
        if not facts_path.is_file() or fs.get('sha256') != sha256(facts_path): raise ValueError(f'facts hash drift: {wid}')
        payload=yaml.safe_load(facts_path.read_text(encoding='utf-8'))
        facts=payload.get('facts',[]); oqs=payload.get('open_questions',[])
        fact_ids=[x['id'] for x in facts]; oq_ids=[x['id'] for x in oqs]
        all_fact_ids.extend(fact_ids); all_oq_ids.extend(oq_ids)
        fact_types.update(x['type'] for x in facts); fact_status.update(x['status'] for x in facts); oq_status.update(x['status'] for x in oqs)
        source_ok=True; chapter_hashes.update(s.get('chapter_sha256') for s in manifest.get('sources',[]))
        for source in manifest.get('sources',[]):
            rp=ROOT/source.get('resolved_relpath','')
            if not rp.is_file() or source.get('resolved_sha256') != sha256(rp): source_ok=False
        s=manifest.get('summary',{})
        if (s.get('fact_count')!=len(facts) or s.get('open_question_count')!=len(oqs) or manifest.get('fact_ids')!=fact_ids or s.get('all_sources_resolved') is not True or s.get('all_facts_bound_to_scope') is not True or not source_ok):
            raise ValueError(f'integrity check failed: {wid}')
        waves.append({'wave':f'7-{suffix}','manifest_id':wid,'manifest_relpath':path.relative_to(ROOT).as_posix(),'facts_relpath':facts_path.relative_to(ROOT).as_posix(),'physical_page_start':start,'physical_page_end_inclusive':end,'physical_page_count':end-start+1,'subsection_label':scope.get('subsection'),'source_count':len(manifest.get('sources',[])),'source_resolved':source_ok,'fact_count':len(facts),'open_question_count':len(oqs)})
    missing=sorted(required_pages-covered); extra=sorted(covered-required_pages)
    overlaps=sorted(p for p,c in Counter(p for w in waves for p in range(w['physical_page_start'],w['physical_page_end_inclusive']+1)).items() if c>1)
    if len(catalog_hashes)!=1 or None in catalog_hashes: raise ValueError('manifests do not share one catalog hash')
    if len(chapter_hashes)!=1 or None in chapter_hashes: raise ValueError('manifests do not share one chapter hash')
    if chapter_hashes!={chapter['chapter_sha256']}: raise ValueError('chapter hash differs from catalog')
    if missing or extra: raise ValueError(f'coverage mismatch: missing={missing}, extra={extra}')
    if len(all_fact_ids)!=len(set(all_fact_ids)): raise ValueError('duplicate fact ids')
    if len(all_oq_ids)!=len(set(all_oq_ids)): raise ValueError('duplicate open question ids')
    return {'schema_version':1,'kind':'core_other_system_wave7_summary','id':'core_other_system_wave7_summary_v1','name':'Other System Functions Wave 7 Summary','description':'1.6.60其他系统函数Wave 7-9与7-10页面覆盖与facts汇总。','catalog':{'path':CATALOG_PATH.relative_to(ROOT).as_posix(),'sha256':sha256(CATALOG_PATH),'document_id':catalog_payload['document_id'],'document_version':catalog_payload['document_version'],'section_number':SECTION,'title':chapter['title'],'chapter_sha256':chapter['chapter_sha256'],'physical_page_start':catalog_start,'physical_page_end_inclusive':catalog_end,'physical_page_count':len(required_pages)},'coverage':{'mode':'page_union','covered_page_count':len(covered),'required_page_count':len(required_pages),'missing_pages':missing,'extra_pages':extra,'overlap_page_count':len(overlaps),'overlap_pages':overlaps,'complete':not missing and not extra},'summary':{'wave_count':len(waves),'source_chapter_count':1,'fact_count':len(all_fact_ids),'unique_fact_id_count':len(set(all_fact_ids)),'open_question_count':len(all_oq_ids),'unique_open_question_id_count':len(set(all_oq_ids)),'fact_type_counts':dict(sorted(fact_types.items())),'confirmed_fact_count':fact_status.get('confirmed',0),'open_question_count_by_status':dict(sorted(oq_status.items())),'all_sources_resolved':all(w['source_resolved'] for w in waves),'all_fact_ids_unique':len(all_fact_ids)==len(set(all_fact_ids)),'all_open_question_ids_unique':len(all_oq_ids)==len(set(all_oq_ids)),'page_coverage_complete':not missing and not extra,'database_executed':False,'runtime_verified':False},'waves':waves}

def main(argv=None) -> int:
    parser=argparse.ArgumentParser(); parser.add_argument('--check',action='store_true'); args=parser.parse_args(argv)
    current=build_summary(); rendered=json.dumps(current,ensure_ascii=False,indent=2)+'\n'
    if args.check and OUTPUT_PATH.exists() and OUTPUT_PATH.read_text(encoding='utf-8')!=rendered:
        print('Other System Functions Wave 7 summary check failed: artifact drift'); return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True,exist_ok=True); OUTPUT_PATH.write_text(rendered,encoding='utf-8')
    s=current['summary']; c=current['coverage']; print(f"Other System Functions Wave 7 summary written: {OUTPUT_PATH} waves={s['wave_count']} pages={c['covered_page_count']}/{c['required_page_count']} facts={s['fact_count']} open_questions={s['open_question_count']}")
    return 0
if __name__=='__main__': raise SystemExit(main())
