"""Statistics Functions Wave 4-4 extraction is source-bound and traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_statistics_wave4_4_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_statistics_wave4_4_v1/manifest.json'


class CoreStatisticsWave44Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_fourth_statistics_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_statistics_wave4_4_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 843)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 853)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertIn('1.6.29 统计信息函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 55)
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
                self.assertEqual(fact['source_refs'], ['w4_4_1_6_29'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_statistic_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'stats_wave4_4_complex_runtime',
            'stats_wave4_4_memory_details',
            'stats_wave4_4_statio_all_indexes',
            'stats_wave4_4_stat_statio_all_tables',
            'stats_wave4_4_local_toast_mappings',
            'stats_wave4_4_statio_all_sequences',
            'stats_wave4_4_statio_sys_indexes',
            'stats_wave4_4_statio_sys_sequences_tables',
            'stats_wave4_4_statio_user_indexes',
            'stats_wave4_4_statio_user_sequences_tables',
            'stats_wave4_4_stat_all_indexes',
            'stats_wave4_4_stat_sys_tables_indexes',
            'stats_wave4_4_stat_user_tables_indexes',
            'stats_wave4_4_database_stats',
            'stats_wave4_4_xact_all_tables',
            'stats_wave4_4_xact_sys_tables',
            'stats_wave4_4_xact_user_tables',
            'stats_wave4_4_user_functions',
            'stats_wave4_4_global_bad_block',
            'stats_wave4_4_file_redo_iostat',
            'stats_wave4_4_file_iostat',
            'stats_wave4_4_global_locks',
            'stats_wave4_4_replication_slots',
            'stats_wave4_4_parallel_decode_status',
            'stats_wave4_4_parallel_decode_thread_info',
            'stats_wave4_4_bgwriter_stat',
            'stats_wave4_4_replication_stat',
            'stats_wave4_4_running_xacts',
            'stats_wave4_4_prepared_xacts',
            'stats_wave4_4_summary_statement',
            'stats_wave4_4_statement_count',
            'stats_wave4_4_config_settings',
            'stats_wave4_4_wait_events',
            'stats_wave4_4_response_percentile',
            'stats_wave4_4_summary_user_login',
            'stats_wave4_4_record_reset_time',
            'stats_wave4_4_standby_statement_history',
            'stats_wave4_4_standby_statement_history_notes',
            'stats_wave4_4_mem_mbytes_reserved',
            'stats_wave4_4_file_stat',
            'stats_wave4_4_redo_stat',
            'stats_wave4_4_thread_status',
            'stats_wave4_4_local_rel_iostat',
            'stats_wave4_4_global_rel_iostat',
            'stats_wave4_4_global_threadpool_status',
            'stats_wave4_4_plancache_stat',
            'stats_wave4_4_pv_os_session_stats',
            'stats_wave4_4_db_temp_bytes_files',
            'stats_wave4_4_remote_stats_unsupported',
            'stats_wave4_4_activity_timeout',
            'stats_wave4_4_activity_timeout_fields',
            'stats_wave4_4_user_resource_info',
            'stats_wave4_4_ondemand_waiting_queue',
            'stats_wave4_4_ondemand_waiting_queue_fields',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.29')
        self.assertEqual(source['physical_page_start'], 843)
        self.assertEqual(source['physical_page_end'], 853)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_statistics_wave4_4.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
