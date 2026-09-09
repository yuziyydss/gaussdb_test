#!/usr/bin/env python3
"""Audit pilot claim provenance and explicitly report unprocessed source lines."""
import argparse
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from core.factor_package_model import FactDef, FactorSourceLedgerDef
from scripts.manage_extraction_queue import sha256_file, load_source_catalog


def audit_source_review(item, lines):
    """Use existing V1 source-unit validation without registering a fake package."""
    review = item['source_review']
    if set(review) != {'units', 'ignored_lines'}:
        raise ValueError('Unknown source_review fields')
    ledger = FactorSourceLedgerDef.model_validate({
        'schema_version': 1, 'kind': 'source_ledger', 'id': 'draft_review',
        'name': 'Foundation draft source review', 'status': 'needs_review',
        'description': 'Validation only, not a registered Factor Package',
        'factor_ref': 'unregistered_foundation_draft', 'artifact_sha256': item['sha256'],
        'source_line_count': len(lines), **review})
    claims = {c['id']: c for c in item['claims']}
    referenced, unit_ids, unmapped, questions = set(), set(), set(), set()
    for unit in ledger.units:
        if unit.id in unit_ids:
            raise ValueError('duplicate review unit')
        unit_ids.add(unit.id)
        if unit.source_anchor != f'L{unit.line_start}-L{unit.line_end}':
            raise ValueError('invalid review source anchor')
        for ref in unit.fact_refs:
            if ref not in claims:
                raise ValueError('Unknown review fact: '+ref)
            claim = claims[ref]
            if not unit.line_start <= claim['line_start'] <= claim['line_end'] <= unit.line_end:
                raise ValueError('Review unit does not contain claim anchor: '+ref)
            if unit.status == 'open_question' and claim['type'] != 'open_question':
                raise ValueError('open_question unit needs an open_question fact')
            if unit.status == 'mapped' and claim['type'] == 'open_question':
                raise ValueError('open_question fact cannot be mapped as resolved')
        referenced.update(unit.fact_refs)
        if unit.status == 'unmapped':
            unmapped.update(range(unit.line_start, unit.line_end+1))
        if unit.status == 'open_question':
            questions.update(range(unit.line_start, unit.line_end+1))
    if set(claims)-referenced:
        raise ValueError('Unreferenced review claims: '+str(sorted(set(claims)-referenced)))
    return {'source_lines_accounted': True, 'review_unit_count': len(unit_ids),
            'unmapped_lines': sorted(unmapped), 'open_question_lines': sorted(questions),
            'atomicity_unreviewed_units': [u.id for u in ledger.units if u.atomicity == 'unreviewed']}


def audit(catalog_path, draft_path):
    load_source_catalog(catalog_path)
    catalog = json.loads(catalog_path.read_text(encoding='utf-8'))
    draft = json.loads(draft_path.read_text(encoding='utf-8'))
    if draft['parent_pdf_sha256'] != catalog['parent_pdf_sha256']:
        raise ValueError('parent PDF mismatch')
    chapters = {c['section_number']: c for c in catalog['chapters']}
    selected = {c['section_number']: c for c in draft['chapters']}
    if len(selected) != len(draft['chapters']) or set(selected)-set(chapters):
        raise ValueError('Duplicate or unknown draft chapters')
    rows, ids = [], set()
    for number, chapter in chapters.items():
        path = (catalog_path.parent/chapter['source_relpath']).resolve()
        if not path.is_relative_to(catalog_path.parent.resolve()):
            raise ValueError('source outside corpus')
        if sha256_file(path) != chapter['chapter_sha256']:
            raise ValueError('source drift: '+number)
        lines = path.read_text(encoding='utf-8').splitlines()
        item = selected.get(number)
        claimed = set()
        if item:
            if item['sha256'] != chapter['chapter_sha256']:
                raise ValueError('draft hash mismatch: '+number)
            for claim in item['claims']:
                if claim['id'] in ids:
                    raise ValueError('duplicate claim')
                ids.add(claim['id'])
                FactDef.model_validate({k: claim[k] for k in ('id', 'type', 'statement', 'status', 'source_anchor')})
                start, end = claim['line_start'], claim['line_end']
                if not 1 <= start <= end <= len(lines) or claim['source_anchor'] != f'L{start}-L{end}':
                    raise ValueError('invalid source anchor')
                excerpt = '\n'.join(lines[start-1:end])
                if not claim['evidence_contains'] or any(t not in excerpt for t in claim['evidence_contains']):
                    raise ValueError('missing evidence text: '+claim['id'])
                claimed.update(range(start, end+1))
        review_report = (audit_source_review(item, lines) if item and 'source_review' in item else
                         {'source_lines_accounted': False, 'review_unit_count': 0,
                          'unmapped_lines': sorted(set(range(1, len(lines)+1))-claimed)})
        rows.append({'section_number': number, 'source_line_count': len(lines),
                     'claims': len(item['claims']) if item else 0,
                     **review_report,
                     'source_extraction_complete': False, 'generator_integrated': False,
                     'runtime_verified': None})
    return {'scope': 'partial_foundation_draft_provenance_only', 'claim_count': len(ids),
            'draft_sha256': sha256_file(draft_path), 'catalog_sha256': sha256_file(catalog_path),
            'semantic_truth_proved_by_this_check': False, 'rows': rows}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--catalog', type=Path, required=True)
    parser.add_argument('--draft', type=Path, default=ROOT/'docs/data/pdf_foundation_claims_draft.json')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    output = args.output.resolve()
    if not output.is_relative_to(ROOT/'work') or output.exists():
        raise ValueError('Use a new report under work/')
    report = audit(args.catalog.resolve(), args.draft)
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open('x', encoding='utf-8') as target:
        json.dump(report, target, ensure_ascii=False, indent=2)
    print(json.dumps({'claim_count': report['claim_count'], 'chapter_count': len(report['rows']),
                      'source_complete_chapters': 0, 'generator_integrated_chapters': 0}))
