"""System Information Functions Wave 5-4 final slice is traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_info_wave5_4_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_info_wave5_4_v1/manifest.json'


class CoreSystemInfoWave54Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_final_system_info_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_system_info_wave5_4_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 586)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 593)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 7)
        self.assertIn('1.6.26 系统信息函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 31)
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
                self.assertEqual(fact['source_refs'], ['w5_4_1_6_26'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sysinfo_wave5_4_txid_snapshot_model',
            'sysinfo_wave5_4_pgxc_is_committed',
            'sysinfo_wave5_4_pgxc_is_committed_bucketid',
            'sysinfo_wave5_4_txid_current',
            'sysinfo_wave5_4_oldestxmin',
            'sysinfo_wave5_4_txid_current_snapshot',
            'sysinfo_wave5_4_txid_snapshot_extractors',
            'sysinfo_wave5_4_txid_visible_in_snapshot',
            'sysinfo_wave5_4_local_prepared_xact',
            'sysinfo_wave5_4_remote_prepared_xacts',
            'sysinfo_wave5_4_global_clean_prepared_xacts',
            'sysinfo_wave5_4_next_xid_csn',
            'sysinfo_wave5_4_control_state',
            'sysinfo_wave5_4_pv_builtin_functions',
            'sysinfo_wave5_4_pv_thread_memory_detail',
            'sysinfo_wave5_4_relation_compression',
            'sysinfo_wave5_4_stat_file_recursive',
            'sysinfo_wave5_4_shared_memory_detail',
            'sysinfo_wave5_4_gtm_lite_status',
            'sysinfo_wave5_4_wlm_plan_operator_info',
            'sysinfo_wave5_4_partition_hot_updated',
            'sysinfo_wave5_4_session_memory_detail_tp',
            'sysinfo_wave5_4_thread_memory_detail',
            'sysinfo_wave5_4_wlm_session_iostat',
            'sysinfo_wave5_4_adm_hist_snapshot_func',
            'sysinfo_wave5_4_adm_hist_snapshot_fields',
            'sysinfo_wave5_4_current_compile_mode',
            'sysinfo_wave5_4_kernel_info',
            'sysinfo_wave5_4_kernel_info_xact_undo_names',
            'sysinfo_wave5_4_kernel_info_lock_sql_names',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.26')
        self.assertEqual(source['physical_page_start'], 586)
        self.assertEqual(source['physical_page_end'], 593)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_info_wave5_4.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
