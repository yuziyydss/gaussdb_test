"""Wave 2B-5B closes logical replication extraction with traceable admin facts."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_admin_wave2b5b_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_admin_wave2b5b_v1/manifest.json'


class CoreSystemAdminWave2B5BTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_remaining_logical_replication_subfamilies(self):
        self.assertEqual(self.manifest['kind'], 'core_system_admin_wave2b5b_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 661)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 675)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 14)
        self.assertEqual(
            self.manifest['scope']['subsection'],
            '1.6.27.10 逻辑复制函数（replication origin、分布式解码状态、逻辑字典、SQL apply、回放跳过）',
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
                self.assertEqual(fact['source_refs'], ['w2b5b_1_6_27'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'wave2b5b_origin_create_drop_oid',
            'wave2b5b_origin_session_setup_reset',
            'wave2b5b_origin_xact_setup_reset',
            'wave2b5b_origin_show_status',
            'wave2b5b_distributed_decode_status_unsupported',
            'wave2b5b_logical_dictionary_baseline',
            'wave2b5b_logical_dictionary_disabled',
            'wave2b5b_inter_cluster_version_info',
            'wave2b5b_sqlapply_start_stop',
            'wave2b5b_sqlapply_failover_states',
            'wave2b5b_change_slot_plugin',
            'wave2b5b_logicalstandby_skip_object',
            'wave2b5b_logicalstandby_skip_txn',
            'wave2b5b_logicalstandby_skip_err',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.27')
        self.assertEqual(source['physical_page_start'], 661)
        self.assertEqual(source['physical_page_end'], 675)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_admin_wave2b5b.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
