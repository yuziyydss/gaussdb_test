"""Keep executable builder contracts while allowing additive source extraction.

Old one-shot builders are a regression baseline, not an instruction to overwrite
reviewed packages. Only added facts/scenario references and ledger partitioning
may differ; SQL, dimensions, rules, gates, fixtures and Oracles remain exact.
"""
import copy
import yaml


def assert_evolved_asset(case, actual, expected, label=''):
    actual = yaml.safe_load(actual) if isinstance(actual, str) else copy.deepcopy(actual)
    expected = yaml.safe_load(expected) if isinstance(expected, str) else copy.deepcopy(expected)
    kind = expected.get('kind') if isinstance(expected, dict) else None
    # Editorial batch naming differs in the two unchanged pilot packages.
    descriptions = {'M 首批有限模型；不承诺全章覆盖或实机成功。', 'M 有限模型；不承诺全章覆盖或实机成功。'}
    if kind and actual.get('description') in descriptions and expected.get('description') in descriptions:
        actual['description'] = expected['description']
    if kind == 'factor':
        for name, dim in actual.get('dimensions', {}).items():
            old_description = expected.get('dimensions', {}).get(name, {}).get('description')
            if dim.get('description') == name + '：首批有限代表域' and old_description == name + '：有限代表域':
                dim['description'] = old_description
        for key in ('facts', 'scenario_refs'):
            old, new = expected.get(key, []), actual.get(key, [])
            case.assertGreaterEqual(len(new), len(old), (label, key))
            for item in old:
                case.assertIn(item, new, (label, key, item))
            if key == 'facts':
                ids = [f['id'] for f in new]
                case.assertEqual(len(ids), len(set(ids)), (label, 'duplicate fact ID'))
            else:
                case.assertEqual(len(new), len(set(new)), (label, 'duplicate scenario ref'))
            actual[key] = old
    elif kind == 'source_ledger':
        units = actual.get('units', [])
        case.assertTrue(units, (label, 'missing source units'))
        ids = [u['id'] for u in units]
        case.assertEqual(len(ids), len(set(ids)), (label, 'duplicate source unit'))
        lines = [n for u in units for n in range(u['line_start'], u['line_end'] + 1)]
        lines += [item['line'] for item in actual.get('ignored_lines', [])]
        case.assertEqual(sorted(lines), list(range(1, actual['source_line_count'] + 1)),
                         (label, 'source line omission/overlap'))
        for unit in units:
            case.assertLessEqual(unit['line_start'], unit['line_end'], (label, unit['id']))
            if unit['status'] == 'mapped':
                case.assertTrue(unit.get('fact_refs'), (label, unit['id'], 'missing fact consumers'))
            elif unit['status'] == 'out_of_scope':
                case.assertTrue(unit.get('rationale'), (label, unit['id'], 'missing exclusion reason'))
        # A formerly mapped line must retain all its original fact consumers,
        # including after a source unit is split into smaller units.
        for old in expected['units']:
            if old['status'] != 'mapped':
                continue
            consumers = set()
            for new in units:
                if new['line_start'] <= old['line_end'] and old['line_start'] <= new['line_end']:
                    consumers.update(new.get('fact_refs', []))
            case.assertTrue(set(old.get('fact_refs', [])).issubset(consumers), (label, old['id']))
        actual['units'] = expected['units']
        previous_sources = expected.get('supplemental_sources', [])
        sources = actual.get('supplemental_sources', [])
        for source in previous_sources:
            case.assertIn(source, sources, (label, 'changed supplemental source'))
        source_ids = [source['id'] for source in sources]
        case.assertEqual(len(source_ids), len(set(source_ids)), (label, 'duplicate supplemental source'))
        for source in sources:
            case.assertTrue(source.get('source_anchor'), (label, source['id']))
            case.assertRegex(source.get('catalog_chapter_ref', {}).get('chapter_sha256', ''),
                             r'^[0-9a-f]{64}$', (label, source['id']))
        if 'supplemental_sources' in expected:
            actual['supplemental_sources'] = previous_sources
        else:
            actual.pop('supplemental_sources', None)
    case.assertEqual(actual, expected, label)
