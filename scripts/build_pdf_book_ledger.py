#!/usr/bin/env python3
"""Inventory every frozen bookmark without claiming full-text/semantic coverage.

Read-only against PDF, catalogs and specs; writes a new local report directory.
Parent/child bookmark ranges overlap and must never be summed as page coverage.
"""
import argparse
from collections import Counter, defaultdict
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
import yaml
from scripts.manage_extraction_queue import load_source_catalog, sha256_file


def within(number, prefix):
    return number == prefix or number.startswith(prefix+'.')


def classify(entry):
    number = entry.get('section_number') or ''
    route = entry['content_route']
    if route.endswith('_sql_statement'):
        return 'sql_command', 'factor_package'
    if route.endswith('_sql_statement_subsection'):
        return 'sql_command_subsection', 'parent_command_evidence'
    for prefixes, kind, asset in [
        (('1.3', '2.6'), 'data_type', 'type_contract'),
        (('1.5',), 'literal_macro', 'literal_contract'),
        (('1.6', '2.5'), 'function_operator', 'expression_contract'),
        (('1.7', '2.8'), 'expression', 'expression_contract'),
        (('1.9', '2.7'), 'type_conversion', 'conversion_contract'),
        (('1.4', '2.3'), 'charset_collation', 'capability_and_expression'),
        (('1.11',), 'transaction', 'scenario'),
    ]:
        if any(within(number, p) for p in prefixes):
            return kind, asset
    mapping = {
        'stored_procedure_reference': ('stored_procedure', 'scenario_and_grammar'),
        'compatibility_reference': ('compatibility', 'capability_matrix'),
        'configuration_reference': ('configuration', 'environment_scenario'),
        'metadata_catalog_reference': ('metadata', 'metadata_oracle'),
        'm_compat_metadata_catalog_reference': ('metadata', 'metadata_oracle'),
        'schema_reference': ('schema_catalog', 'metadata_oracle_or_function'),
        'm_compat_schema_reference': ('schema_catalog', 'metadata_oracle_or_function'),
        'tool_reference': ('tool', 'non_sql_scenario'),
        'log_reference': ('log', 'observability_oracle'),
        'report_reference': ('diagnostic_report', 'non_sql_oracle'),
        'document_navigation': ('navigation', 'source_inventory'),
        'general_sql_navigation': ('navigation', 'source_inventory'),
        'm_compat_sql_navigation': ('navigation', 'source_inventory'),
    }
    return mapping.get(route, ('reference_review', 'needs_content_review'))


def build_rows(outline, extracted, bindings, pilot):
    paths = [tuple(e['outline_path']) for e in outline]
    if len(set(paths)) != len(paths):
        raise ValueError('duplicate outline path')
    missing = set(pilot) - {e.get('section_number') for e in outline}
    if missing:
        raise ValueError('Unknown pilot sections: '+str(sorted(missing)))
    parents = {p[:i] for p in paths for i in range(1, len(p))}
    rows = []
    for e, path in zip(outline, paths):
        kind, asset = classify(e)
        source = extracted.get(path)
        selected = pilot.get(e.get('section_number'))
        rows.append({
            'node_id': 'bookmark::'+' / '.join(path),
            'section_number': e.get('section_number'), 'title': e['title'],
            'outline_path': list(path),
            'parent_node_id': 'bookmark::'+' / '.join(path[:-1]) if len(path)>1 else None,
            'node_kind': 'container_with_possible_own_text' if path in parents else 'leaf',
            'variant': 'm_compat' if any('M-Compatibility' in p for p in path) else e['variant'],
            'content_type': kind, 'suggested_asset': asset,
            'classification_basis': 'outline_route_and_section_prefix',
            'classification_review': 'needs_body_review',
            'start_destination': e['start_destination'], 'end_destination': e['end_destination'],
            'cataloged': True, 'source': source,
            'text_extracted_fresh': bool(source and source['fresh']),
            'bound_packages': bindings.get(path, []),
            'semantic_extraction': 'not_audited', 'static_coverage': None, 'runtime_verified': None,
            'pilot_selected': selected is not None,
            'planned_dependency_edges': [
                {'consumer': c, 'provider_section': e['section_number'],
                 'status': 'planned_not_registry_bound', 'reason': selected['reason']}
                for c in (selected.get('planned_consumers', []) if selected else [])],
        })
    return rows


def load_inputs(catalog_path, extras, specs):
    # Existing catalog validation also checks the actual parent PDF digest.
    load_source_catalog(catalog_path)
    catalog = json.loads(catalog_path.read_text(encoding='utf-8'))
    extracted, by_source = {}, {}
    for path in [catalog_path, *extras]:
        load_source_catalog(path)
        data = json.loads(path.read_text(encoding='utf-8'))
        for key in ('document_id', 'parent_pdf_sha256', 'extraction_rule_version', 'outline'):
            if data[key] != catalog[key]:
                raise ValueError(f'Catalog identity/outline mismatch: {path}: {key}')
        for chapter in data['chapters']:
            source = (path.parent / chapter['source_relpath']).resolve()
            if not source.is_relative_to(path.parent.resolve()):
                raise ValueError('Source outside corpus')
            fresh = source.is_file() and sha256_file(source) == chapter['chapter_sha256']
            outline_path = tuple(chapter['outline_path'])
            record = {'catalog_path': str(path.resolve()), 'source_relpath': chapter['source_relpath'],
                      'source_path': str(source), 'chapter_sha256': chapter['chapter_sha256'], 'fresh': fresh}
            if outline_path in extracted and extracted[outline_path]['chapter_sha256'] != chapter['chapter_sha256']:
                raise ValueError('Conflicting chapter hashes: '+str(outline_path))
            extracted[outline_path] = record
            by_source[(data['document_id'], chapter['source_relpath'], chapter['chapter_sha256'])] = outline_path
    bindings = defaultdict(list)
    for path in sorted(specs.rglob('*.factor.yaml')):
        data = yaml.safe_load(path.read_text(encoding='utf-8'))
        source = data.get('source', {})
        ref = source.get('catalog_chapter_ref') or {}
        key = (ref.get('document_id'), ref.get('source_relpath'), ref.get('chapter_sha256'))
        if key in by_source and source.get('parent_pdf_sha256') == catalog['parent_pdf_sha256']:
            bindings[by_source[key]].append({'factor_id': data['id'], 'path': str(path.resolve())})
    return catalog, extracted, bindings


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--catalog', type=Path, default=ROOT/'work/doc2spec/full_general_corpus/catalog.json')
    parser.add_argument('--extra-catalog', type=Path, action='append', default=[])
    parser.add_argument('--pilot', type=Path, default=ROOT/'docs/data/pdf_foundation_pilot.json')
    parser.add_argument('--output-dir', type=Path, required=True)
    args = parser.parse_args()
    output = args.output_dir.resolve()
    if not output.is_relative_to(ROOT/'work') or output == ROOT/'work' or output.exists():
        raise ValueError('Use a new directory under project work/; existing reports are preserved')
    catalog, extracted, bindings = load_inputs(args.catalog.resolve(), args.extra_catalog, ROOT/'specs')
    pilot = json.loads(args.pilot.read_text(encoding='utf-8'))['sections']
    if len({s['section_number'] for s in pilot}) != len(pilot):
        raise ValueError('Duplicate pilot section')
    rows = build_rows(catalog['outline'], extracted, bindings, {s['section_number']: s for s in pilot})
    for section in pilot:
        for consumer in section['planned_consumers']:
            if not any(b['factor_id'] == consumer for group in bindings.values() for b in group):
                raise ValueError('Unbound planned consumer: '+consumer)
    summary = {'bookmark_nodes': len(rows), 'leaf_nodes': sum(r['node_kind']=='leaf' for r in rows),
               'text_extracted_fresh_nodes': sum(r['text_extracted_fresh'] for r in rows),
               'package_bound_nodes': sum(bool(r['bound_packages']) for r in rows),
               'pilot_topics': len(pilot), 'by_content_type': dict(sorted(Counter(r['content_type'] for r in rows).items()))}
    report = {'schema_version': 1, 'document_id': catalog['document_id'],
              'parent_pdf_sha256': catalog['parent_pdf_sha256'],
              'catalog_sha256': sha256_file(args.catalog), 'pilot_sha256': sha256_file(args.pilot),
              'physical_page_count': catalog['parent_pdf_metadata']['page_count'],
              'scope_limits': ['Bookmark inventory is not atomic source-unit coverage.',
                               'Parent ranges overlap child ranges; do not sum page ranges.',
                               'Pages outside bookmarks, tables and unbookmarked claims need body review.',
                               'Classification and planned edges are not confirmed facts or runtime results.'],
              'summary': summary, 'rows': rows}
    output.mkdir(parents=True)
    (output/'book_ledger.json').write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    text = '# PDF全书书签台账\n\n'+json.dumps(summary, ensure_ascii=False, indent=2)+'\n\n'
    text += '目录分类未经过逐章正文复核；不代表语义/静态/实机覆盖。\n\n| 节号 | 标题 | 类型 | 新鲜正文 | 绑定包 |\n|---|---|---|---|---|\n'
    for r in rows:
        title = r['title'].replace('|', '\\|')
        text += f"| {r['section_number'] or '-'} | {title} | {r['content_type']} | {r['text_extracted_fresh']} | {','.join(b['factor_id'] for b in r['bound_packages'])} |\n"
    (output/'book_ledger.md').write_text(text, encoding='utf-8')
    print(json.dumps(summary, ensure_ascii=False))


if __name__ == '__main__':
    main()
