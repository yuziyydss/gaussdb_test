#!/usr/bin/env python3
"""Build and verify the aggregate System Information Functions Wave 5 summary."""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from collections import Counter
from pathlib import Path
from typing import Any

import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
OUTPUT_PATH = ROOT / 'generated/core_system_info_wave5_summary_v1/summary.json'
SECTION = '1.6.26'
WAVE_SUFFIXES = ('1', '2', '3', '4')


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def wave_id(suffix: str) -> str:
    return f'core_system_info_wave5_{suffix}_v1'


def manifest_path(wave: str) -> Path:
    return ROOT / 'generated' / wave / 'manifest.json'


def build_summary() -> dict[str, Any]:
    catalog_payload = json.loads(CATALOG_PATH.read_text(encoding='utf-8'))
    chapters = [c for c in catalog_payload['chapters'] if c.get('section_number') == SECTION]
    if len(chapters) != 1:
        raise ValueError(f'expected one catalog chapter for {SECTION}, got {len(chapters)}')
    chapter = chapters[0]
    catalog_start = int(chapter['physical_page_start'])
    catalog_end = int(chapter['physical_page_end'])
    required_pages = set(range(catalog_start, catalog_end + 1))

    waves: list[dict[str, Any]] = []
    all_fact_ids: list[str] = []
    all_open_question_ids: list[str] = []
    fact_types: Counter[str] = Counter()
    fact_statuses: Counter[str] = Counter()
    open_question_statuses: Counter[str] = Counter()
    covered_pages: set[int] = set()
    catalog_hashes: set[str] = set()
    chapter_hashes: set[str] = set()

    for suffix in WAVE_SUFFIXES:
        wid = wave_id(suffix)
        path = manifest_path(wid)
        if not path.is_file():
            raise FileNotFoundError(f'missing System Information Wave 5 manifest: {path}')
        manifest = json.loads(path.read_text(encoding='utf-8'))
        if manifest.get('id') != wid:
            raise ValueError(f'unexpected manifest id in {path}: {manifest.get("id")}')
        catalog_hashes.add(manifest.get('catalog', {}).get('sha256'))
        scope = manifest['scope']
        page_start = int(scope['physical_page_start'])
        page_end_inclusive = int(scope['physical_page_end_exclusive']) - 1
        covered_pages.update(range(page_start, page_end_inclusive + 1))

        facts_source = manifest.get('facts_source', {})
        facts_path = ROOT / facts_source.get('path', '')
        if not facts_path.is_file() or facts_source.get('sha256') != sha256(facts_path):
            raise ValueError(f'facts source hash drift for {wid}')
        facts_payload = yaml.safe_load(facts_path.read_text(encoding='utf-8'))
        facts = facts_payload.get('facts', [])
        open_questions = facts_payload.get('open_questions', [])
        fact_ids = [item['id'] for item in facts]
        open_question_ids = [item['id'] for item in open_questions]
        all_fact_ids.extend(fact_ids)
        all_open_question_ids.extend(open_question_ids)
        fact_types.update(item['type'] for item in facts)
        fact_statuses.update(item['status'] for item in facts)
        open_question_statuses.update(item['status'] for item in open_questions)

        source_ok = True
        for source in manifest.get('sources', []):
            chapter_hashes.add(source.get('chapter_sha256'))
            resolved_path = ROOT / source.get('resolved_relpath', '')
            if not resolved_path.is_file() or source.get('resolved_sha256') != sha256(resolved_path):
                source_ok = False
        summary = manifest.get('summary', {})
        if (
            summary.get('fact_count') != len(facts)
            or summary.get('open_question_count') != len(open_questions)
            or summary.get('fact_ids') is not None and summary.get('fact_ids') != fact_ids
            or summary.get('all_sources_resolved') is not True
            or summary.get('all_facts_bound_to_scope') is not True
            or not source_ok
        ):
            raise ValueError(f'System Information Wave 5 manifest integrity check failed: {wid}')

        waves.append({
            'wave': f'5-{suffix}',
            'manifest_id': wid,
            'manifest_relpath': path.relative_to(ROOT).as_posix(),
            'facts_relpath': facts_path.relative_to(ROOT).as_posix(),
            'physical_page_start': page_start,
            'physical_page_end_inclusive': page_end_inclusive,
            'physical_page_count': page_end_inclusive - page_start + 1,
            'subsection_label': scope.get('subsection'),
            'source_count': len(manifest.get('sources', [])),
            'source_resolved': source_ok,
            'fact_count': len(facts),
            'open_question_count': len(open_questions),
        })

    missing_pages = sorted(required_pages - covered_pages)
    extra_pages = sorted(covered_pages - required_pages)
    duplicate_pages = sorted(page for page, count in Counter(
        page for wave in waves
        for page in range(wave['physical_page_start'], wave['physical_page_end_inclusive'] + 1)
    ).items() if count > 1)
    if len(catalog_hashes) != 1 or None in catalog_hashes:
        raise ValueError('System Information Wave 5 manifests do not share one catalog hash')
    if len(chapter_hashes) != 1 or None in chapter_hashes:
        raise ValueError('System Information Wave 5 manifests do not share one chapter hash')
    if chapter_hashes != {chapter['chapter_sha256']}:
        raise ValueError('System Information Wave 5 chapter hash differs from catalog')
    if missing_pages or extra_pages:
        raise ValueError(f'page coverage mismatch: missing={missing_pages}, extra={extra_pages}')
    if len(all_fact_ids) != len(set(all_fact_ids)):
        raise ValueError('duplicate fact ids across System Information Wave 5')
    if len(all_open_question_ids) != len(set(all_open_question_ids)):
        raise ValueError('duplicate open question ids across System Information Wave 5')

    return {
        'schema_version': 1,
        'kind': 'core_system_info_wave5_summary',
        'id': 'core_system_info_wave5_summary_v1',
        'name': 'System Information Functions Wave 5 Summary',
        'description': '1.6.26系统信息函数Wave 5-1至5-4页面覆盖与facts汇总。',
        'catalog': {
            'path': CATALOG_PATH.relative_to(ROOT).as_posix(),
            'sha256': sha256(CATALOG_PATH),
            'document_id': catalog_payload['document_id'],
            'document_version': catalog_payload['document_version'],
            'section_number': SECTION,
            'title': chapter['title'],
            'chapter_sha256': chapter['chapter_sha256'],
            'physical_page_start': catalog_start,
            'physical_page_end_inclusive': catalog_end,
            'physical_page_count': len(required_pages),
        },
        'coverage': {
            'mode': 'page_union',
            'covered_page_count': len(covered_pages),
            'required_page_count': len(required_pages),
            'missing_pages': missing_pages,
            'extra_pages': extra_pages,
            'overlap_page_count': len(duplicate_pages),
            'overlap_pages': duplicate_pages,
            'complete': not missing_pages and not extra_pages,
        },
        'summary': {
            'wave_count': len(waves),
            'source_chapter_count': 1,
            'fact_count': len(all_fact_ids),
            'unique_fact_id_count': len(set(all_fact_ids)),
            'open_question_count': len(all_open_question_ids),
            'unique_open_question_id_count': len(set(all_open_question_ids)),
            'fact_type_counts': dict(sorted(fact_types.items())),
            'confirmed_fact_count': fact_statuses.get('confirmed', 0),
            'open_question_count_by_status': dict(sorted(open_question_statuses.items())),
            'all_sources_resolved': all(item['source_resolved'] for item in waves),
            'all_fact_ids_unique': len(all_fact_ids) == len(set(all_fact_ids)),
            'all_open_question_ids_unique': len(all_open_question_ids) == len(set(all_open_question_ids)),
            'page_coverage_complete': not missing_pages and not extra_pages,
            'database_executed': False,
            'runtime_verified': False,
        },
        'waves': waves,
    }


def main(argv=None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args(argv)
    current = build_summary()
    rendered = json.dumps(current, ensure_ascii=False, indent=2) + '\n'
    if args.check and OUTPUT_PATH.exists():
        if OUTPUT_PATH.read_text(encoding='utf-8') != rendered:
            print('System Information Functions Wave 5 summary check failed: artifact drift')
            return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding='utf-8')
    summary = current['summary']
    coverage = current['coverage']
    print(
        f"System Information Functions Wave 5 summary written: {OUTPUT_PATH} "
        f"waves={summary['wave_count']} pages={coverage['covered_page_count']}/{coverage['required_page_count']} "
        f"facts={summary['fact_count']} open_questions={summary['open_question_count']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
