#!/usr/bin/env python3
"""Build and verify the integration/tools Wave 6-7 extraction manifest."""
from __future__ import annotations
import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple
import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
FACTS_PATH = ROOT / 'docs/compat_facts/core_integration_tools_wave6_7_v1.yaml'
OUTPUT_PATH = ROOT / 'generated/core_integration_tools_wave6_7_v1/manifest.json'
SOURCE_ROOTS = (
    ROOT / 'work/pdf_tiered_2026_09_07',
    ROOT / 'work/pdf_foundations_2026_09_07',
)
SECTIONS = (
    ('1.6.53', 1039, 1044),
    ('1.6.54', 1043, 1049),
    ('1.6.55', 1048, 1051),
    ('1.6.56', 1050, 1053),
    ('1.6.57', 1052, 1056),
    ('1.6.58', 1055, 1057),
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def selected_chapters() -> Tuple[dict, List[Tuple[str, dict, int, int]]]:
    catalog = json.loads(CATALOG_PATH.read_text(encoding='utf-8'))
    by_section = {c.get('section_number'): c for c in catalog['chapters']}
    selected = []
    for section, start, end_exclusive in SECTIONS:
        if section not in by_section:
            raise ValueError(f'missing catalog chapter {section}')
        selected.append((section, by_section[section], start, end_exclusive))
    return catalog, selected


def resolved_source(chapter: dict) -> Path:
    digest = chapter['chapter_sha256']
    matches = []
    for root in SOURCE_ROOTS:
        for path in root.rglob('*.txt'):
            try:
                if hashlib.sha256(path.read_bytes()).hexdigest() == digest:
                    matches.append(path)
            except OSError:
                pass
    if not matches:
        raise ValueError(f"cannot resolve source for {chapter.get('section_number')}: {digest}")
    return sorted(matches, key=lambda p: (len(p.parts), str(p)))[0]


def page_lines(path: Path, start: int, end_exclusive: int):
    current_page = None
    for line in path.read_text(encoding='utf-8').splitlines():
        match = re.search(r'physical=(\d+)', line)
        if match:
            current_page = int(match.group(1))
        if current_page is not None and start <= current_page < end_exclusive:
            yield line


def build_manifest() -> dict:
    catalog, selected = selected_chapters()
    facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
    facts = facts_payload.get('facts', [])
    fact_ids = [item.get('id') for item in facts]
    if len(fact_ids) != len(set(fact_ids)):
        raise ValueError('duplicate fact ids in integration/tools Wave 6-7 manifest')
    allowed_refs = {f'w6_7_{section.replace(".", "_")}' for section, _, _ in SECTIONS}
    for fact in facts:
        refs = set(fact.get('source_refs', []))
        if not refs or not refs.issubset(allowed_refs):
            raise ValueError(f"fact {fact.get('id')} is not bound to allowed Wave 6-7 refs: {sorted(refs)}")
    sources = []
    for section, chapter, start, end_exclusive in selected:
        path = resolved_source(chapter)
        lines = list(page_lines(path, start, end_exclusive))
        sources.append({
            'source_ref': f'w6_7_{section.replace(".", "_")}',
            'section_number': section,
            'title': ' > '.join(chapter['outline_path']),
            'physical_page_start': start,
            'physical_page_end': end_exclusive,
            'catalog_physical_page_start': chapter['physical_page_start'],
            'catalog_physical_page_end': chapter['physical_page_end'],
            'catalog_source_relpath': chapter['source_relpath'],
            'resolved_relpath': path.relative_to(ROOT).as_posix(),
            'chapter_sha256': chapter['chapter_sha256'],
            'resolved_sha256': sha256(path),
            'page_line_count': len(lines),
        })
    page_set = {page for _, start, end in SECTIONS for page in range(start, end)}
    return {
        'schema_version': 1,
        'kind': 'core_integration_tools_wave6_7_extraction_manifest',
        'id': 'core_integration_tools_wave6_7_v1',
        'name': 'Integration and Tools Wave 6-7 Extraction Manifest',
        'description': '1.6.53至1.6.58系统函数facts清单。',
        'catalog': {
            'path': CATALOG_PATH.relative_to(ROOT).as_posix(),
            'sha256': sha256(CATALOG_PATH),
            'document_id': catalog['document_id'],
            'document_version': catalog['document_version'],
            'parent_pdf_sha256': catalog['parent_pdf_sha256'],
        },
        'facts_source': {
            'path': FACTS_PATH.relative_to(ROOT).as_posix(),
            'sha256': sha256(FACTS_PATH),
        },
        'scope': {
            'chapter_count': len(sources),
            'source_chapter_count': len(sources),
            'physical_page_count': len(page_set),
            'physical_page_start': min(start for _, start, _ in SECTIONS),
            'physical_page_end_exclusive': max(end for _, _, end in SECTIONS),
            'sections': [section for section, _, _ in SECTIONS],
            'excludes': facts_payload['scope'].get('excludes', []),
        },
        'summary': {
            'fact_count': len(facts),
            'open_question_count': len(facts_payload.get('open_questions', [])),
            'source_chapter_count': len(sources),
            'source_page_line_count': sum(item['page_line_count'] for item in sources),
            'all_sources_resolved': True,
            'all_facts_bound_to_scope': True,
        },
        'sources': sources,
        'fact_ids': fact_ids,
    }


def main(argv=None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args(argv)
    current = build_manifest()
    rendered = json.dumps(current, ensure_ascii=False, indent=2) + '\n'
    if args.check and OUTPUT_PATH.exists():
        if OUTPUT_PATH.read_text(encoding='utf-8') != rendered:
            print('Integration/tools Wave 6-7 check failed: artifact drift')
            return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding='utf-8')
    summary = current['summary']
    print(
        f"Integration/tools Wave 6-7 manifest written: {OUTPUT_PATH} "
        f"chapters={summary['source_chapter_count']} pages={current['scope']['physical_page_count']} "
        f"facts={summary['fact_count']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
