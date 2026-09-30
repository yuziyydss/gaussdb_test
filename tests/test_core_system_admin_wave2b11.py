"""Wave 2B-11 second other-functions slice is source-bound and complete."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_admin_wave2b11_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_admin_wave2b11_v1/manifest.json'


class CoreSystemAdminWave2B11Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_second_other_functions_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_system_admin_wave2b11_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 756)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 765)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 9)
        self.assertIn('1.6.27.17 其它函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 35)
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
                self.assertEqual(fact['source_refs'], ['w2b11_1_6_27'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'wave2b11_pagewriter_accumulate_stat',
            'wave2b11_dirty_queue_advance_stat',
            'wave2b11_single_flush_dw_stat',
            'wave2b11_pagewriter_stat',
            'wave2b11_buffer_scale_state',
            'wave2b11_buffer_io_state',
            'wave2b11_redo_stat',
            'wave2b11_recovery_status',
            'wave2b11_wlm_node_recover',
            'wave2b11_cgroup_functions',
            'wave2b11_comm_client_info',
            'wave2b11_flush_lsns',
            'wave2b11_global_full_sql',
            'wave2b11_global_slow_sql',
            'wave2b11_statement_detail_decode',
            'wave2b11_pgxc_get_csn',
            'wave2b11_control_state',
            'wave2b11_recovery_pending_region_slot',
            'wave2b11_running_xacts',
            'wave2b11_variable_info',
            'wave2b11_xidlimit',
            'wave2b11_relation_compression',
            'wave2b11_stat_file_recursive',
            'wave2b11_activity_functions',
            'wave2b11_cgroup_info',
            'wave2b11_realtime_info_unavailable',
            'wave2b11_test_err_contain_err',
            'wave2b11_global_user_transaction',
            'wave2b11_collation_for',
            'wave2b11_sp_database_locks',
            'wave2b11_copy_error_log_compat',
            'wave2b11_copy_error_func',
            'wave2b11_copy_error_insert',
            'wave2b11_copy_summary_func',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.27')
        self.assertEqual(source['physical_page_start'], 756)
        self.assertEqual(source['physical_page_end'], 765)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_admin_wave2b11.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
