#!/usr/bin/env python3
"""Build and verify the cross-chapter system-function extraction summary."""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from collections import Counter
from pathlib import Path
from typing import Any

import yaml

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

CATALOG_PATH = ROOT / 'generated/full_document_catalog/catalog.json'
OUTPUT_PATH = ROOT / 'generated/core_system_function_extraction_summary_v1/summary.json'
SECTIONS = ('1.6.26', '1.6.27', '1.6.28', '1.6.29')


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_yaml(path: Path) -> dict[str, Any]:
    return yaml.safe_load(path.read_text(encoding='utf-8'))


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding='utf-8'))


def build_summary() -> dict[str, Any]:
    catalog_payload = load_json(CATALOG_PATH)
    chapters_by_section = {c.get('section_number'): c for c in catalog_payload['chapters']}
    missing = [section for section in SECTIONS if section not in chapters_by_section]
    if missing:
        raise ValueError(f'missing catalog chapters: {missing}')

    artifact_specs = {
        '1.6.26': {
            'artifact_relpath': 'generated/core_system_info_wave5_summary_v1/summary.json',
            'artifact_kind': 'core_system_info_wave5_summary',
        },
        '1.6.27': {
            'artifact_relpath': 'generated/core_system_admin_wave2b_summary_v1/summary.json',
            'artifact_kind': 'core_system_admin_wave2b_summary',
        },
        '1.6.28': {
            'artifact_relpath': 'generated/core_spm_plan_wave3_1_v1/manifest.json',
            'artifact_kind': 'core_spm_plan_wave3_1_extraction_manifest',
        },
        '1.6.29': {
            'artifact_relpath': 'generated/core_statistics_wave4_summary_v1/summary.json',
            'artifact_kind': 'core_statistics_wave4_summary',
        },
    }

    chapters: list[dict[str, Any]] = []
    fact_paths: list[Path] = []
    all_fact_ids: list[str] = []
    all_open_question_ids: list[str] = []
    fact_types: Counter[str] = Counter()
    fact_statuses: Counter[str] = Counter()
    open_question_statuses: Counter[str] = Counter()

    for section in SECTIONS:
        chapter = chapters_by_section[section]
        spec = artifact_specs[section]
        artifact_path = ROOT / spec['artifact_relpath']
        if not artifact_path.is_file():
            raise FileNotFoundError(f'missing source artifact: {artifact_path}')
        artifact = load_json(artifact_path)
        if artifact.get('kind') != spec['artifact_kind']:
            raise ValueError(f'unexpected artifact kind for {section}: {artifact.get("kind")}')
        if artifact.get('catalog', {}).get('sha256') != sha256(CATALOG_PATH):
            raise ValueError(f'catalog hash mismatch in {section} artifact')

        if section == '1.6.28':
            source_hash = artifact.get('sources', [{}])[0].get('chapter_sha256')
            page_start = int(artifact['scope']['physical_page_start'])
            page_end_inclusive = int(artifact['scope']['physical_page_end_exclusive']) - 1
            complete = (
                artifact.get('summary', {}).get('all_sources_resolved') is True
                and artifact.get('summary', {}).get('all_facts_bound_to_scope') is True
            )
            fact_paths.append(ROOT / artifact['facts_source']['path'])
        else:
            source_hash = artifact.get('catalog', {}).get('chapter_sha256')
            page_start = int(artifact['catalog']['physical_page_start'])
            page_end_inclusive = int(artifact['catalog']['physical_page_end_inclusive'])
            complete = artifact.get('coverage', {}).get('complete') is True
            for wave in artifact.get('waves', []):
                fact_paths.append(ROOT / wave['facts_relpath'])

        catalog_start = int(chapter['physical_page_start'])
        catalog_end = int(chapter['physical_page_end'])
        if source_hash != chapter['chapter_sha256']:
            raise ValueError(f'chapter hash mismatch for {section}')
        if (page_start, page_end_inclusive) != (catalog_start, catalog_end):
            raise ValueError(f'catalog page range mismatch for {section}')
        if not complete:
            raise ValueError(f'child extraction coverage is incomplete for {section}')

        fact_count = int(artifact['summary']['fact_count'])
        open_question_count = int(artifact['summary']['open_question_count'])
        wave_count = len(artifact.get('waves', [])) if section != '1.6.28' else 1

        chapters.append({
            'section_number': section,
            'title': chapter['title'],
            'chapter_sha256': chapter['chapter_sha256'],
            'physical_page_start': catalog_start,
            'physical_page_end_inclusive': catalog_end,
            'physical_page_count': catalog_end - catalog_start + 1,
            'artifact_relpath': spec['artifact_relpath'],
            'artifact_kind': spec['artifact_kind'],
            'artifact_sha256': sha256(artifact_path),
            'wave_count': wave_count,
            'fact_count': fact_count,
            'open_question_count': open_question_count,
            'coverage_complete': complete,
        })

    for facts_path in fact_paths:
        if not facts_path.is_file():
            raise FileNotFoundError(f'missing facts file: {facts_path}')
        payload = load_yaml(facts_path)
        facts = payload.get('facts', [])
        questions = payload.get('open_questions', [])
        all_fact_ids.extend(item['id'] for item in facts)
        fact_types.update(item['type'] for item in facts)
        fact_statuses.update(item['status'] for item in facts)
        all_open_question_ids.extend(item['id'] for item in questions)
        open_question_statuses.update(item['status'] for item in questions)

    if len(all_fact_ids) != len(set(all_fact_ids)):
        raise ValueError('duplicate fact ids across system-function extraction chapters')
    if len(all_open_question_ids) != len(set(all_open_question_ids)):
        raise ValueError('duplicate open-question ids across system-function extraction chapters')
    if len(all_fact_ids) != sum(item['fact_count'] for item in chapters):
        raise ValueError('fact total mismatch across child artifacts')

    required_pages = set(range(560, 901))
    chapter_pages: set[int] = set()
    page_occurrences: Counter[int] = Counter()
    for item in chapters:
        pages = range(item['physical_page_start'], item['physical_page_end_inclusive'] + 1)
        chapter_pages.update(pages)
        page_occurrences.update(pages)
    missing_pages = sorted(required_pages - chapter_pages)
    extra_pages = sorted(chapter_pages - required_pages)
    boundary_overlap_pages = sorted(page for page, count in page_occurrences.items() if count > 1)
    if missing_pages or extra_pages:
        raise ValueError(f'cross-chapter page coverage mismatch: missing={missing_pages}, extra={extra_pages}')
    if boundary_overlap_pages != [592, 804, 812]:
        raise ValueError(f'unexpected chapter boundary overlaps: {boundary_overlap_pages}')

    chapter_page_slice_count = sum(item['physical_page_count'] for item in chapters)
    covered_page_count = len(chapter_pages)
    required_page_count = len(required_pages)
    wave_count = sum(item['wave_count'] for item in chapters)

    return {
        'schema_version': 1,
        'kind': 'core_system_function_extraction_summary',
        'id': 'core_system_function_extraction_summary_v1',
        'name': 'Core System Function Extraction Summary',
        'description': '1.6.26系统信息函数、1.6.27系统管理函数、1.6.28 SPM计划管理函数和1.6.29统计信息函数的跨章节静态抽取汇总。',
        'catalog': {
            'path': CATALOG_PATH.relative_to(ROOT).as_posix(),
            'sha256': sha256(CATALOG_PATH),
            'document_id': catalog_payload['document_id'],
            'document_version': catalog_payload['document_version'],
            'section_numbers': list(SECTIONS),
        },
        'coverage': {
            'mode': 'cross_chapter_page_union',
            'physical_page_start': 560,
            'physical_page_end_inclusive': 900,
            'required_page_count': required_page_count,
            'covered_page_count': covered_page_count,
            'chapter_page_slice_count': chapter_page_slice_count,
            'boundary_overlap_page_count': len(boundary_overlap_pages),
            'boundary_overlap_pages': boundary_overlap_pages,
            'missing_pages': missing_pages,
            'extra_pages': extra_pages,
            'complete': not missing_pages and not extra_pages,
        },
        'summary': {
            'chapter_count': len(chapters),
            'source_artifact_count': len(chapters),
            'wave_count': wave_count,
            'fact_count': len(all_fact_ids),
            'unique_fact_id_count': len(set(all_fact_ids)),
            'open_question_count': len(all_open_question_ids),
            'unique_open_question_id_count': len(set(all_open_question_ids)),
            'fact_type_counts': dict(sorted(fact_types.items())),
            'confirmed_fact_count': fact_statuses.get('confirmed', 0),
            'open_question_count_by_status': dict(sorted(open_question_statuses.items())),
            'all_fact_ids_unique': len(all_fact_ids) == len(set(all_fact_ids)),
            'all_open_question_ids_unique': len(all_open_question_ids) == len(set(all_open_question_ids)),
            'page_coverage_complete': not missing_pages and not extra_pages,
            'database_executed': False,
            'runtime_verified': False,
        },
        'chapters': chapters,
    }


def main(argv=None) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args(argv)
    current = build_summary()
    rendered = json.dumps(current, ensure_ascii=False, indent=2) + '\n'
    if args.check and OUTPUT_PATH.exists():
        if OUTPUT_PATH.read_text(encoding='utf-8') != rendered:
            print('Core system-function extraction summary check failed: artifact drift')
            return 1
    if not args.check or not OUTPUT_PATH.exists():
        OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT_PATH.write_text(rendered, encoding='utf-8')
    summary = current['summary']
    coverage = current['coverage']
    print(
        f"Core system-function extraction summary written: {OUTPUT_PATH} "
        f"chapters={summary['chapter_count']} waves={summary['wave_count']} "
        f"pages={coverage['covered_page_count']}/{coverage['required_page_count']} "
        f"facts={summary['fact_count']} open_questions={summary['open_question_count']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
