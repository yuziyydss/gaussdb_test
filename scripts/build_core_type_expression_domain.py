#!/usr/bin/env python3
"""Build and verify the Core Type & Expression Domain extraction manifest."""
from __future__ import annotations
import argparse, hashlib, json, sys
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
FACTS_PATH = ROOT / 'docs/compat_facts/core_type_expression_domain_v1.yaml'
OUTPUT_PATH = ROOT / 'generated/core_type_expression_domain_v1/manifest.json'
SEARCH_ROOT = ROOT / 'work/pdf_foundations_2026_09_07'
EXACT_SECTIONS = {
    '1.5', '1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.7.5', '1.7.6',
    '1.8', '1.9.1', '1.9.2', '1.9.3', '1.9.4', '1.9.5',
}
PREFIX_SECTIONS = ('1.3.',)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source_ref(section: str) -> str:
    return 'cte_' + section.replace('.', '_')


def selected_chapters():
    catalog = json.loads(CATALOG_PATH.read_text(encoding='utf-8'))
    rows = []
    for chapter in catalog['chapters']:
        section = chapter.get('section_number') or ''
        if section.startswith(PREFIX_SECTIONS) or section in EXACT_SECTIONS:
            rows.append((section, chapter))
    return catalog, sorted(rows, key=lambda pair: tuple(int(x) for x in pair[0].split('.')))


def _hash_cache() -> dict[str, list[Path]]:
    cache: dict[str, list[Path]] = {}
    for path in SEARCH_ROOT.rglob('*.txt'):
        try:
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
        except OSError:
            continue
        cache.setdefault(digest, []).append(path)
    return cache


def build_manifest() -> dict:
    catalog, chapters = selected_chapters()
    hashes = _hash_cache()
    facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
    facts = facts_payload.get('facts', [])
    fact_ids = [item.get('id') for item in facts]
    if len(fact_ids) != len(set(fact_ids)):
        raise ValueError('duplicate fact ids in core_type_expression_domain_v1.yaml')

    selected_refs = {source_ref(section): section for section, _ in chapters}
    used_refs: set[str] = set()
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
            raise ValueError(f"cannot resolve chapter source for {section}: {digest}")
        path = sorted(candidates, key=lambda item: (len(item.parts), str(item)))[0]
        relpath = path.relative_to(ROOT).as_posix()
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
            'resolved_relpath': relpath,
            'chapter_sha256': digest,
            'resolved_sha256': sha256(path),
            'line_count': len(lines),
            'fact_count': sum(
                source_ref(section) in fact.get('source_refs', [])
                for fact in facts
            ),
        })

    uncovered = sorted(selected_refs.keys() - used_refs)
    if uncovered:
        raise ValueError(f"selected chapters without facts: {uncovered}")
    physical_pages = sum(s['physical_page_end'] - s['physical_page_start'] for s in sources)

    return {
        'schema_version': 1,
        'kind': 'core_type_expression_domain_extraction_manifest',
        'id': 'core_type_expression_domain_v1',
        'name': 'Core Type & Expression Domain Extraction V1',
        'description': '1.3类型域、1.5常量宏、1.7表达式、1.8伪列、1.9类型转换的章节源文哈希对账与结构化facts清单。',
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
            'physical_page_count': physical_pages,
            'includes': ['1.3.*', '1.5', '1.7.*', '1.8', '1.9.*'],
            'excludes': ['1.6函数和操作符，后续Wave 1B'],
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
            print('Core type & expression manifest check failed: artifact drift')
            return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding='utf-8')
    summary = current['summary']
    print(
        f"Core type & expression manifest written: {OUTPUT_PATH} "
        f"chapters={summary['source_chapter_count']} pages={current['scope']['physical_page_count']} "
        f"facts={summary['fact_count']} open_questions={summary['open_question_count']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
