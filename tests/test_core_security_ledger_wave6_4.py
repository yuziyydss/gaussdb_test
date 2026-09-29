"""Ledger, encrypted, SRF and overload Wave 6-4 extraction is source-bound."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_security_ledger_wave6_4_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_security_ledger_wave6_4_v1/manifest.json'


class CoreSecurityLedgerWave64Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_four_security_and_metadata_sections(self):
        self.assertEqual(self.manifest['kind'], 'core_security_ledger_wave6_4_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 4)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 20)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 534)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 554)
        self.assertEqual(
            self.manifest['scope']['sections'],
            ['1.6.21', '1.6.22', '1.6.23', '1.6.24'],
        )
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 29)
        self.assertEqual(self.manifest['summary']['open_question_count'], 3)
        self.assertTrue(self.manifest['summary']['all_sources_resolved'])
        self.assertTrue(self.manifest['summary']['all_facts_bound_to_scope'])

    def test_facts_are_unique_confirmed_and_traceable(self):
        ids = [item['id'] for item in self.facts]
        self.assertEqual(len(ids), len(set(ids)))
        for fact in self.facts:
            with self.subTest(fact=fact['id']):
                self.assertEqual(fact['status'], 'confirmed')
                self.assertIn(fact['type'], {'syntax', 'constraint', 'environment', 'behavior_oracle'})
                self.assertTrue(fact['source_refs'])
                self.assertTrue(all(ref.startswith('w6_4_1_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'ledger_wave6_4_hist_functions',
            'ledger_wave6_4_hist_archive',
            'ledger_wave6_4_gchain_functions',
            'ledger_wave6_4_hash_types',
            'encrypted_wave6_4_equalcol_io',
            'encrypted_wave6_4_withoutorder_io',
            'encrypted_wave6_4_compare',
            'encrypted_wave6_4_hll_hash',
            'encrypted_wave6_4_tee_order_like',
            'encrypted_wave6_4_tee_calculation_support',
            'encrypted_wave6_4_aggregates_supported',
            'encrypted_wave6_4_aggregates_unsupported',
            'encrypted_wave6_4_tee_internal',
            'encrypted_wave6_4_deterministic_encrypt',
            'encrypted_wave6_4_deterministic_decrypt',
            'encrypted_wave6_4_conversion_encrypt_decrypt',
            'encrypted_wave6_4_cek_validation',
            'srf_wave6_4_general_semantics',
            'srf_wave6_4_generate_series_numeric',
            'srf_wave6_4_generate_series_datetime',
            'srf_wave6_4_generate_series_boundary',
            'srf_wave6_4_search_function_by_name',
            'srf_wave6_4_generate_subscripts',
            'overload_wave6_4_function_query',
            'overload_wave6_4_function_query_boundary',
            'overload_wave6_4_syntax_mapping',
            'overload_wave6_4_operator_query',
            'overload_wave6_4_operator_query_boundary',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_four_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 4)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_security_ledger_wave6_4.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
