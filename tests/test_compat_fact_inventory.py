import unittest
import yaml
from pathlib import Path
from unittest.mock import patch
from scripts.audit_compat_facts import audit


class CompatFactInventoryTests(unittest.TestCase):
    def test_reviewed_collisions_preserve_mode_phase_and_exact_pdf_pages(self):
        directory = Path(__file__).resolve().parents[1]/'docs/compat_facts'
        pages = {
            'm_dt_int_union_length': [3293, 3294],
            'm_dt_precision_truncate': [3296],
            'm_dt_time_negative_zero': [3296],
            'm_dt_timestamp_explicit_defaults': [3295, 3296],
            'm_dt_year_display': [3296],
            'm_op_null_compare_unconvertible': [3379, 3380],
            'm_op_null_display': [3379],
            'm_op_string_to_double_error': [3379],
        }
        selected = {}
        for path in directory.glob('*.yaml'):
            for fact in yaml.safe_load(path.read_text())['facts']:
                if fact['id'] in pages:
                    selected.setdefault(fact['id'], []).append(fact)
                    self.assertEqual(fact.get('compatibility_mode'), 'M', (path, fact['id']))
                    self.assertEqual(fact.get('source_physical_pages'), pages[fact['id']])
                    self.assertTrue(fact.get('evaluation_phase'))
                    self.assertTrue(fact.get('applicability_conditions'))
        self.assertEqual({k: len(v) for k, v in selected.items()}, dict.fromkeys(pages, 2))
        for facts in selected.values():
            self.assertEqual(facts[0]['evaluation_phase'], facts[1]['evaluation_phase'])
            self.assertEqual(facts[0]['applicability_conditions'], facts[1]['applicability_conditions'])

    def test_real_inventory_has_unique_qualified_ids_and_does_not_claim_runtime(self):
        report = audit(Path(__file__).resolve().parents[1]/'docs/compat_facts')
        self.assertEqual(report['errors'], [])
        self.assertEqual(report['summary']['fact_records'], report['summary']['qualified_ids'])
        self.assertTrue(report['records'])
        self.assertTrue(all(not r['runtime_verified'] for r in report['records']))

    def test_invalid_yaml_or_missing_fact_id_cannot_be_silently_skipped(self):
        directory = Path(__file__).resolve().parents[1]/'docs/compat_facts'
        for content in (b'facts: [', b'facts:\n- type: syntax\n  statement: sample\n'):
            with patch.object(Path, 'read_bytes', return_value=content):
                self.assertTrue(audit(directory)['errors'])
