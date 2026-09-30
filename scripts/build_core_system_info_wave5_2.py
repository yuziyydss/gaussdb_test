#!/usr/bin/env python3
"""Build and verify the System Information Functions Wave 5-2 extraction manifest."""
from __future__ import annotations
import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_info_wave5_2_v1.yaml'
OUTPUT_PATH = ROOT / 'generated/core_system_info_wave5_2_v1/manifest.json'
SOURCE_ROOTS = (
    ROOT / 'work/pdf_tiered_2026_09_07',
    ROOT / 'work/pdf_foundations_2026_09_07',
)
SECTION = '1.6.26'
PAGE_START = 571
PAGE_END_EXCLUSIVE = 579


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def selected_chapters():
    catalog = json.loads(CATALOG_PATH.read_text(encoding='utf-8'))
    rows = [(c.get('section_number') or '', c) for c in catalog['chapters'] if c.get('section_number') == SECTION]
    return catalog, rows


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
        raise ValueError(f'cannot resolve source for {SECTION}: {digest}')
    return sorted(matches, key=lambda p: (len(p.parts), str(p)))[0]


def page_lines(path: Path):
    lines = path.read_text(encoding='utf-8').splitlines()
    current_page = None
    for line in lines:
        match = re.search(r'physical=(\d+)', line)
        if match:
            current_page = int(match.group(1))
        if current_page is not None and PAGE_START <= current_page < PAGE_END_EXCLUSIVE:
            yield line


def build_manifest() -> dict:
    catalog, chapters = selected_chapters()
    if not chapters:
        raise ValueError(f'missing catalog chapter {SECTION}')
    facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
    facts = facts_payload.get('facts', [])
    fact_ids = [item.get('id') for item in facts]
    if len(fact_ids) != len(set(fact_ids)):
        raise ValueError('duplicate fact ids in System Information Wave 5-2 manifest')
    selected_ref = 'w5_2_' + SECTION.replace('.', '_')
    for fact in facts:
        refs = fact.get('source_refs', [])
        if not refs or selected_ref not in refs:
            raise ValueError(f"fact {fact.get('id')} is not bound to {selected_ref}")
    sources = []
    for section, chapter in chapters:
        path = resolved_source(chapter)
        lines = list(page_lines(path))
        sources.append({
            'source_ref': selected_ref,
            'section_number': section,
            'title': ' > '.join(chapter['outline_path']),
            'physical_page_start': PAGE_START,
            'physical_page_end': PAGE_END_EXCLUSIVE,
            'catalog_physical_page_start': chapter['physical_page_start'],
            'catalog_physical_page_end': chapter['physical_page_end'],
            'catalog_source_relpath': chapter['source_relpath'],
            'resolved_relpath': path.relative_to(ROOT).as_posix(),
            'chapter_sha256': chapter['chapter_sha256'],
            'resolved_sha256': sha256(path),
            'page_line_count': len(lines),
            'fact_count': len(facts),
        })
    return {
        'schema_version': 1,
        'kind': 'core_system_info_wave5_2_extraction_manifest',
        'id': 'core_system_info_wave5_2_v1',
        'name': 'System Information Functions Wave 5-2 Extraction Manifest',
        'description': '1.6.26系统信息函数第二批facts清单。',
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
            'physical_page_count': PAGE_END_EXCLUSIVE - PAGE_START,
            'physical_page_start': PAGE_START,
            'physical_page_end_exclusive': PAGE_END_EXCLUSIVE,
            'subsection': facts_payload['scope']['subsection'],
            'excludes': facts_payload['scope']['excludes'],
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
            print('System Information Functions Wave 5-2 check failed: artifact drift')
            return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding='utf-8')
    summary = current['summary']
    print(
        f"System Information Functions Wave 5-2 manifest written: {OUTPUT_PATH} "
        f"chapters={summary['source_chapter_count']} pages={current['scope']['physical_page_count']} "
        f"facts={summary['fact_count']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
