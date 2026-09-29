"""Statistics Functions Wave 4-1 extraction is source-bound and traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_statistics_wave4_1_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_statistics_wave4_1_v1/manifest.json'


class CoreStatisticsWave41Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_first_statistics_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_statistics_wave4_1_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 812)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 822)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertIn('1.6.29 统计信息函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 33)
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
                self.assertEqual(fact['source_refs'], ['w4_1_1_6_29'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_statistic_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'stats_wave4_1_scope_model',
            'stats_wave4_1_recovery_conflict_functions',
            'stats_wave4_1_recovery_conflict_semantics',
            'stats_wave4_1_recovery_conflict_pdb',
            'stats_wave4_1_control_group_config',
            'stats_wave4_1_db_stat_reset_time',
            'stats_wave4_1_function_total_time',
            'stats_wave4_1_xact_basic_stats',
            'stats_wave4_1_lock_status',
            'stats_wave4_1_lwlock_status',
            'stats_wave4_1_xact_function_stats',
            'stats_wave4_1_wal_senders',
            'stats_wave4_1_wal_senders_fields',
            'stats_wave4_1_paxos_replication_info',
            'stats_wave4_1_dcf_replication_fields',
            'stats_wave4_1_dcf_roles_modes',
            'stats_wave4_1_stream_replications',
            'stats_wave4_1_db_activity_stats',
            'stats_wave4_1_db_io_tuple_stats',
            'stats_wave4_1_db_block_time',
            'stats_wave4_1_db_conflict_deadlock',
            'stats_wave4_1_numscans',
            'stats_wave4_1_role_name',
            'stats_wave4_1_table_tuple_stats',
            'stats_wave4_1_live_dead_tuples',
            'stats_wave4_1_table_block_stats',
            'stats_wave4_1_xact_tuple_stats',
            'stats_wave4_1_vacuum_analyze_stats',
            'stats_wave4_1_vacuum_analyze_manual_auto',
            'stats_wave4_1_total_autovac_tuples',
            'stats_wave4_1_total_autovac_ustore_boundary',
            'stats_wave4_1_gsi_autovac_unsupported',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.29')
        self.assertEqual(source['physical_page_start'], 812)
        self.assertEqual(source['physical_page_end'], 822)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_statistics_wave4_1.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
