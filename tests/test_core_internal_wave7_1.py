"""Internal, cache and recovery Wave 7-1 extraction is source-bound."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_internal_wave7_1_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_internal_wave7_1_v1/manifest.json'


class CoreInternalWave71Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_internal_cache_recovery_sections(self):
        self.assertEqual(self.manifest['kind'], 'core_internal_wave7_1_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 3)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 16)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 918)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 953)
        self.assertEqual(self.manifest['scope']['sections'], ['1.6.39', '1.6.40', '1.6.42'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 20)
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
                self.assertTrue(all(ref.startswith('w7_1_1_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'internal_wave7_1_scope',
            'internal_wave7_1_selectivity_stats_sort',
            'internal_wave7_1_type_conversion',
            'internal_wave7_1_aggregate',
            'internal_wave7_1_hash_btree',
            'internal_wave7_1_index_families',
            'internal_wave7_1_plpgsql_collection_foreign',
            'internal_wave7_1_remote_standby_helpers',
            'internal_wave7_1_ledger_ai_other',
            'internal_wave7_1_txn_snapshot_boundary',
            'gsc_wave7_1_table_detail',
            'gsc_wave7_1_catalog_detail',
            'gsc_wave7_1_clean',
            'gsc_wave7_1_dbstat_info',
            'gsc_wave7_1_performance_hint',
            'gsc_wave7_1_multitenant_boundary',
            'multixact_wave7_1_vacuum',
            'multixact_wave7_1_constraints',
            'multixact_wave7_1_global_temp_boundary',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_three_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 3)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_internal_wave7_1.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
