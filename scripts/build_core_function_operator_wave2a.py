#!/usr/bin/env python3
"""Build and verify the Core Function & Operator Wave 2A extraction manifest."""
from __future__ import annotations
import argparse
import hashlib
import json
import sys
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
FACTS_PATH = ROOT / 'docs/compat_facts/core_function_operator_wave2a_v1.yaml'
OUTPUT_PATH = ROOT / 'generated/core_function_operator_wave2a_v1/manifest.json'
SEARCH_ROOTS = (
    ROOT / 'work/pdf_foundations_2026_09_07',
    ROOT / 'work/pdf_tiered_2026_09_07',
)
EXACT_SECTIONS = {
    '1.6.10', '1.6.11', '1.6.12', '1.6.15', '1.6.20', '1.6.23', '1.6.24',
    '1.6.26', '1.6.31', '1.6.43', '1.6.44', '1.6.50', '1.6.58',
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_ref(section: str) -> str:
    return 'w2a_' + section.replace('.', '_')


def selected_chapters():
    catalog = json.loads(CATALOG_PATH.read_text(encoding='utf-8'))
    rows = []
    for chapter in catalog['chapters']:
        section = chapter.get('section_number') or ''
        if section in EXACT_SECTIONS:
            rows.append((section, chapter))
    return catalog, sorted(rows, key=lambda pair: tuple(int(x) for x in pair[0].split('.')))


def hash_cache():
    cache = {}
    for root in SEARCH_ROOTS:
        for path in root.rglob('*.txt'):
            try:
                cache.setdefault(hashlib.sha256(path.read_bytes()).hexdigest(), []).append(path)
            except OSError:
                pass
    return cache


def build_manifest() -> dict:
    catalog, chapters = selected_chapters()
    hashes = hash_cache()
    facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
    facts = facts_payload.get('facts', [])
    fact_ids = [item.get('id') for item in facts]
    if len(fact_ids) != len(set(fact_ids)):
        raise ValueError('duplicate fact ids in Wave 2A manifest')
    selected_refs = {source_ref(section): section for section, _ in chapters}
    used_refs = set()
    for fact in facts:
        refs = fact.get('source_refs', [])
        if not refs:
            raise ValueError(f"fact {fact.get('id')} has no source_refs")
        for ref in refs:
            if ref not in selected_refs:
                raise ValueError(f"fact {fact.get('id')} references unknown source {ref}")
            used_refs.add(ref)
    sources = []
    for section, chapter in chapters:
        digest = chapter['chapter_sha256']
        candidates = hashes.get(digest, [])
        if not candidates:
            raise ValueError(f'cannot resolve chapter source for {section}: {digest}')
        path = sorted(candidates, key=lambda item: (len(item.parts), str(item)))[0]
        lines = path.read_text(encoding='utf-8').splitlines()
        sources.append({
            'source_ref': source_ref(section),
            'section_number': section,
            'title': ' > '.join(chapter['outline_path']),
            'physical_page_start': chapter['physical_page_start'],
            'physical_page_end': chapter['physical_page_end'],
            'printed_page_start': chapter['printed_page_start'],
            'printed_page_end': chapter['printed_page_end'],
            'catalog_source_relpath': chapter['source_relpath'],
            'resolved_relpath': path.relative_to(ROOT).as_posix(),
            'chapter_sha256': digest,
            'resolved_sha256': sha256(path),
            'line_count': len(lines),
            'fact_count': sum(source_ref(section) in fact.get('source_refs', []) for fact in facts),
        })
    uncovered = sorted(set(selected_refs) - used_refs)
    if uncovered:
        raise ValueError(f'selected chapters without facts: {uncovered}')
    return {
        'schema_version': 1,
        'kind': 'core_function_operator_wave2a_extraction_manifest',
        'id': 'core_function_operator_wave2a_v1',
        'name': 'Core Function & Operator Wave 2A Extraction Manifest',
        'description': '1.6剩余高价值函数与操作符13章的结构化facts清单；不执行SQL。',
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
            'physical_page_count': sum(item['physical_page_end'] - item['physical_page_start'] for item in sources),
            'includes': sorted(EXACT_SECTIONS),
            'excludes': ['1.6.27/1.6.29/1.6.60大函数章节后续按函数族拆抽'],
        },
        'summary': {
            'fact_count': len(facts),
            'open_question_count': len(facts_payload.get('open_questions', [])),
            'source_chapter_count': len(sources),
            'source_line_count': sum(item['line_count'] for item in sources),
            'all_sources_resolved': True,
            'all_chapters_have_facts': True,
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
            print('Core function & operator Wave 2A check failed: artifact drift')
            return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding='utf-8')
    summary = current['summary']
    print(
        f"Core function & operator Wave 2A manifest written: {OUTPUT_PATH} "
        f"chapters={summary['source_chapter_count']} pages={current['scope']['physical_page_count']} "
        f"facts={summary['fact_count']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
