#!/usr/bin/env python3
"""Build and verify the XML Wave 7-8 extraction manifest."""
from __future__ import annotations
import argparse, hashlib, json, re, sys
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path: sys.path.insert(0, str(ROOT))
CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
FACTS_PATH = ROOT / 'docs/compat_facts/core_xml_wave7_8_v1.yaml'
OUTPUT_PATH = ROOT / 'generated/core_xml_wave7_8_v1/manifest.json'
SOURCE_ROOTS = (ROOT/'work/pdf_tiered_2026_09_07', ROOT/'work/pdf_foundations_2026_09_07')
SECTIONS = (('1.6.43',952,970), ('1.6.44',969,981))

def sha256(path): return hashlib.sha256(path.read_bytes()).hexdigest()

def selected_chapters():
    c=json.loads(CATALOG_PATH.read_text(encoding='utf-8')); by={x.get('section_number'):x for x in c['chapters']}
    return c, [(s,by[s],a,b) for s,a,b in SECTIONS]

def resolved_source(ch):
    d=ch['chapter_sha256']; matches=[]
    for root in SOURCE_ROOTS:
        for p in root.rglob('*.txt'):
            try:
                if hashlib.sha256(p.read_bytes()).hexdigest()==d: matches.append(p)
            except OSError: pass
    if not matches: raise ValueError(f"cannot resolve source for {ch['section_number']}")
    return sorted(matches,key=lambda p:(len(p.parts),str(p)))[0]

def page_lines(path,start,end):
    page=None
    for line in path.read_text(encoding='utf-8').splitlines():
        m=re.search(r'physical=(\d+)',line)
        if m: page=int(m.group(1))
        if page is not None and start<=page<end: yield line

def build_manifest():
    catalog, selected=selected_chapters(); payload=yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
    facts=payload.get('facts',[]); ids=[x.get('id') for x in facts]
    if len(ids)!=len(set(ids)): raise ValueError('duplicate ids')
    allowed={f'w7_8_{s.replace(".","_")}' for s,_,_ in SECTIONS}
    for fact in facts:
        refs=set(fact.get('source_refs',[]))
        if not refs or not refs.issubset(allowed): raise ValueError(f"bad refs {fact.get('id')}")
    sources=[]
    for section,ch,start,end in selected:
        path=resolved_source(ch); lines=list(page_lines(path,start,end))
        sources.append({'source_ref':f'w7_8_{section.replace(".","_")}','section_number':section,'title':' > '.join(ch['outline_path']),'physical_page_start':start,'physical_page_end':end,'catalog_physical_page_start':ch['physical_page_start'],'catalog_physical_page_end':ch['physical_page_end'],'catalog_source_relpath':ch['source_relpath'],'resolved_relpath':path.relative_to(ROOT).as_posix(),'chapter_sha256':ch['chapter_sha256'],'resolved_sha256':sha256(path),'page_line_count':len(lines)})
    page_set={p for _,s,e in SECTIONS for p in range(s,e)}
    return {'schema_version':1,'kind':'core_xml_wave7_8_extraction_manifest','id':'core_xml_wave7_8_v1','name':'XML Wave 7-8 Extraction Manifest','description':'1.6.43和1.6.44 XML函数facts清单。','catalog':{'path':CATALOG_PATH.relative_to(ROOT).as_posix(),'sha256':sha256(CATALOG_PATH),'document_id':catalog['document_id'],'document_version':catalog['document_version'],'parent_pdf_sha256':catalog['parent_pdf_sha256']},'facts_source':{'path':FACTS_PATH.relative_to(ROOT).as_posix(),'sha256':sha256(FACTS_PATH)},'scope':{'chapter_count':len(sources),'source_chapter_count':len(sources),'physical_page_count':len(page_set),'physical_page_start':min(s for _,s,_ in SECTIONS),'physical_page_end_exclusive':max(e for _,_,e in SECTIONS),'sections':[s for s,_,_ in SECTIONS],'excludes':payload['scope'].get('excludes',[])},'summary':{'fact_count':len(facts),'open_question_count':len(payload.get('open_questions',[])),'source_chapter_count':len(sources),'source_page_line_count':sum(x['page_line_count'] for x in sources),'all_sources_resolved':True,'all_facts_bound_to_scope':True},'sources':sources,'fact_ids':ids}

def main(argv=None):
    parser=argparse.ArgumentParser(); parser.add_argument('--check',action='store_true'); args=parser.parse_args(argv)
    current=build_manifest(); rendered=json.dumps(current,ensure_ascii=False,indent=2)+'\n'
    if args.check and OUTPUT_PATH.exists() and OUTPUT_PATH.read_text(encoding='utf-8')!=rendered:
        print('XML Wave 7-8 check failed: artifact drift'); return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True,exist_ok=True); OUTPUT_PATH.write_text(rendered,encoding='utf-8')
    s=current['summary']; print(f"XML Wave 7-8 manifest written: {OUTPUT_PATH} chapters={s['source_chapter_count']} pages={current['scope']['physical_page_count']} facts={s['fact_count']}")
    return 0
if __name__=='__main__': raise SystemExit(main())
