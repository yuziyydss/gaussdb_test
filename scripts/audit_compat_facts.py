#!/usr/bin/env python3
"""Inventory reference facts without promoting document review to SQL coverage.

Qualified IDs are file-stem::fact-id. Bare collisions are review items, not an
invitation to silently overwrite one statement with another.
"""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path
import re
import yaml


def audit(directory):
    directory = Path(directory)
    records, errors, by_id, inputs = [], [], defaultdict(list), {}
    files = sorted(directory.glob('*.yaml'))
    if not files:
        errors.append({'error': 'no_reference_fact_files', 'directory': str(directory)})
    for path in files:
        raw = path.read_bytes()
        inputs[path.name] = hashlib.sha256(raw).hexdigest()
        try:
            data = yaml.safe_load(raw)
        except yaml.YAMLError as exc:
            errors.append({'file': path.name, 'error': 'invalid_yaml', 'detail': str(exc)})
            continue
        if not isinstance(data, dict) or not isinstance(data.get('facts'), list):
            errors.append({'file': path.name, 'error': 'facts_list_required'})
            continue
        seen = set()
        for index, fact in enumerate(data['facts']):
            if not isinstance(fact, dict):
                errors.append({'file': path.name, 'index': index, 'error': 'fact_mapping_required'})
                continue
            fid = fact.get('id')
            if not isinstance(fid, str) or not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', fid):
                errors.append({'file': path.name, 'index': index, 'error': 'valid_id_required'})
                fid = f'<missing:{index}>'
            qualified = path.stem + '::' + fid
            if qualified in seen:
                errors.append({'file': path.name, 'id': fid, 'error': 'duplicate_qualified_id'})
            seen.add(qualified)
            missing = [k for k in ('type', 'statement', 'source_anchor', 'status') if not fact.get(k)]
            missing += [k for k in ('document', 'version', 'parent_pdf_sha256') if not data.get(k)]
            if missing:
                errors.append({'file': path.name, 'id': fid, 'error': 'missing_provenance', 'fields': missing})
            if not re.fullmatch(r'[0-9a-f]{64}', str(data.get('parent_pdf_sha256', ''))):
                errors.append({'file': path.name, 'id': fid, 'error': 'invalid_pdf_hash'})
            record = {'qualified_id': qualified, 'source_file': path.name,
                      'id': fid, 'type': fact.get('type'), 'statement': fact.get('statement'),
                      'source_anchor': fact.get('source_anchor'), 'document': data.get('document'),
                      'parent_pdf_sha256': data.get('parent_pdf_sha256'),
                      'document_review_status': fact.get('status'),
                      'verification_method': fact.get('verification_method'),
                      'source_physical_pages': fact.get('source_physical_pages'),
                      'evaluation_phase': fact.get('evaluation_phase'),
                      'applicability_conditions': fact.get('applicability_conditions'),
                      'mode': fact.get('compatibility_mode'),
                      'mode_review_required': not bool(fact.get('compatibility_mode')),
                      'runtime_verified': False, 'generator_integration': 'not_established_by_inventory'}
            records.append(record)
            by_id[fid].append(qualified)
    duplicates = {fid: refs for fid, refs in sorted(by_id.items()) if len(refs) > 1}
    return {'summary': {'yaml_files': len(files), 'fact_records': len(records),
                        'qualified_ids': len({r['qualified_id'] for r in records}),
                        'bare_ids': len(by_id), 'duplicate_bare_ids': len(duplicates),
                        'document_review_status': dict(Counter(r['document_review_status'] for r in records)),
                        'mode_review_required': sum(r['mode_review_required'] for r in records),
                        'errors': len(errors)},
            'input_sha256': inputs, 'duplicate_bare_ids': duplicates,
            'errors': errors, 'records': records,
            'limits': ['confirmed means source review only, not runtime validation or generator consumption.',
                       'Mode must be reviewed from the exact statement and conditions, not guessed from an ID.',
                       'Duplicate IDs remain separate qualified records until semantic reconciliation.',
                       'This inventory checks provenance fields, not whether every statement is faithful to the PDF.']}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--directory', type=Path, default=Path(__file__).resolve().parents[1]/'docs/compat_facts')
    p.add_argument('--output', type=Path)
    args = p.parse_args()
    report = audit(args.directory)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(json.dumps(report['summary'], ensure_ascii=False, indent=2))
    return 1 if report['errors'] else 0


if __name__ == '__main__':
    raise SystemExit(main())
