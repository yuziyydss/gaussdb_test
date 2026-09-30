"""Deprecated Functions Wave 6-8 extraction is source-bound and complete."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_deprecated_wave6_8_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_deprecated_wave6_8_v1/manifest.json'


class CoreDeprecatedWave68Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_deprecated_functions(self):
        self.assertEqual(self.manifest['kind'], 'core_deprecated_wave6_8_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1114)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1118)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 4)
        self.assertIn('1.6.61 废弃函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 7)
        self.assertEqual(self.manifest['summary']['open_question_count'], 1)
        self.assertTrue(self.manifest['summary']['all_sources_resolved'])
        self.assertTrue(self.manifest['summary']['all_facts_bound_to_scope'])

    def test_facts_are_unique_confirmed_and_traceable(self):
        ids = [item['id'] for item in self.facts]
        self.assertEqual(len(ids), len(set(ids)))
        for fact in self.facts:
            with self.subTest(fact=fact['id']):
                self.assertEqual(fact['status'], 'confirmed')
                self.assertIn(fact['type'], {'syntax', 'constraint', 'environment', 'behavior_oracle'})
                self.assertEqual(fact['source_refs'], ['w6_8_1_6_61'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_deprecated_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'deprecated_wave6_8_scope',
            'deprecated_wave6_8_wlm_resource_list',
            'deprecated_wave6_8_pgxc_distributed_list',
            'deprecated_wave6_8_query_replication_list',
            'deprecated_wave6_8_storage_memory_list',
            'deprecated_wave6_8_obs_misc_list',
            'deprecated_wave6_8_mot_gtm_imcu_list',
        }
        self.assertEqual(expected, ids)

    def test_high_value_deprecated_names_are_listed(self):
        text = '\n'.join(item['statement'] for item in self.facts)
        for name in (
            'gs_wlm_get_session_info',
            'pgxc_is_committed',
            'remote_rto_stat',
            'table_skewness(text)',
            'gs_redis_set_bucketxid',
            'track_memory_context',
            'populate_record',
            'mot_global_memory_detail',
            'gs_imcu_slot_status',
        ):
            self.assertIn(name, text)

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.61')
        self.assertEqual(source['physical_page_start'], 1114)
        self.assertEqual(source['physical_page_end'], 1118)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_deprecated_wave6_8.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
