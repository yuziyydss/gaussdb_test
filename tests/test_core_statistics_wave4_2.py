"""Statistics Functions Wave 4-2 extraction is source-bound and traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_statistics_wave4_2_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_statistics_wave4_2_v1/manifest.json'


class CoreStatisticsWave42Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_second_statistics_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_statistics_wave4_2_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 821)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 835)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 14)
        self.assertIn('1.6.29 统计信息函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 45)
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
                self.assertEqual(fact['source_refs'], ['w4_2_1_6_29'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_statistic_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'stats_wave4_2_autovac_status',
            'stats_wave4_2_autovac_status_fields',
            'stats_wave4_2_autovac_timeout',
            'stats_wave4_2_get_last_data_changed_time',
            'stats_wave4_2_set_last_data_changed_time',
            'stats_wave4_2_get_last_updated',
            'stats_wave4_2_backend_pid',
            'stats_wave4_2_stat_get_activity',
            'stats_wave4_2_stat_get_activity_fields',
            'stats_wave4_2_stat_get_activity_semantics',
            'stats_wave4_2_activity_with_conninfo',
            'stats_wave4_2_activity_with_conninfo_fields',
            'stats_wave4_2_get_explain',
            'stats_wave4_2_get_explain_collection',
            'stats_wave4_2_function_call_stats',
            'stats_wave4_2_backend_idset',
            'stats_wave4_2_backend_identity_stats',
            'stats_wave4_2_backend_activity_stats',
            'stats_wave4_2_backend_waiting_xact',
            'stats_wave4_2_backend_start',
            'stats_wave4_2_backend_client_info',
            'stats_wave4_2_bgwriter_checkpoint_stats',
            'stats_wave4_2_bgwriter_buffer_stats',
            'stats_wave4_2_bgwriter_pdb_defaults',
            'stats_wave4_2_stat_snapshot_reset',
            'stats_wave4_2_stat_reset_scope',
            'stats_wave4_2_fenced_udf_process',
            'stats_wave4_2_total_cpu_memory',
            'stats_wave4_2_nodegroup_cgroup_info',
            'stats_wave4_2_bad_block',
            'stats_wave4_2_bad_block_clear',
            'stats_wave4_2_respool_exception_info',
            'stats_wave4_2_control_group_info',
            'stats_wave4_2_prepared_statements',
            'stats_wave4_2_cgroup_and_memory_views',
            'stats_wave4_2_blackbox_dump',
            'stats_wave4_2_blackbox_show',
            'stats_wave4_2_blackbox_show_fields',
            'stats_wave4_2_blackbox_list',
            'stats_wave4_2_plan_trace_delete',
            'stats_wave4_2_plan_trace_watch',
            'stats_wave4_2_plan_trace_watch_cycle',
            'stats_wave4_2_plan_trace_show_sqlids',
            'stats_wave4_2_standby_read_delay',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.29')
        self.assertEqual(source['physical_page_start'], 821)
        self.assertEqual(source['physical_page_end'], 835)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_statistics_wave4_2.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
