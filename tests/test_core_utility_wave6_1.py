"""Utility Functions Wave 6-1 extraction is source-bound and complete."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_utility_wave6_1_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_utility_wave6_1_v1/manifest.json'


class CoreUtilityWave61Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_five_small_utility_sections(self):
        self.assertEqual(self.manifest['kind'], 'core_utility_wave6_1_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 5)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 900)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 910)
        self.assertEqual(
            self.manifest['scope']['sections'],
            ['1.6.30', '1.6.31', '1.6.32', '1.6.33', '1.6.34'],
        )
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 22)
        self.assertEqual(self.manifest['summary']['open_question_count'], 2)
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
                self.assertTrue(all(ref.startswith('w6_1_1_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'utility_wave6_1_triggerdef',
            'utility_wave6_1_triggerdef_pretty',
            'utility_wave6_1_suppress_redundant_updates',
            'utility_wave6_1_ora_hash',
            'utility_wave6_1_ora_hash_precondition',
            'utility_wave6_1_hash_array',
            'utility_wave6_1_hash_numeric_range',
            'utility_wave6_1_hash_bpchar_char',
            'utility_wave6_1_hash_enum',
            'utility_wave6_1_hash_floats',
            'utility_wave6_1_hash_inet',
            'utility_wave6_1_hash_int1_int2',
            'utility_wave6_1_report_application_error',
            'utility_wave6_1_gtt_relstats',
            'utility_wave6_1_gtt_statistics',
            'utility_wave6_1_gtt_attached_pid',
            'utility_wave6_1_global_sql_by_timestamp',
            'utility_wave6_1_statement_detail_decode',
            'utility_wave6_1_gtt_relfrozenxids',
            'utility_wave6_1_fault_inject_unsupported',
            'utility_wave6_1_fault_inject_params',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_five_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 5)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_utility_wave6_1.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
