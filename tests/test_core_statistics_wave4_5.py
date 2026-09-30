"""Statistics Functions Wave 4-5 extraction is source-bound and traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_statistics_wave4_5_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_statistics_wave4_5_v1/manifest.json'


class CoreStatisticsWave45Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_fifth_statistics_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_statistics_wave4_5_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 853)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 865)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 12)
        self.assertIn('1.6.29 统计信息函数', self.manifest['scope']['subsection'])
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
                self.assertEqual(fact['source_refs'], ['w4_5_1_6_29'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'stats_wave4_5_local_redo_time_count',
            'stats_wave4_5_local_redo_time_operations',
            'stats_wave4_5_local_redo_time_thread_fields',
            'stats_wave4_5_local_redo_time_mode_steps',
            'stats_wave4_5_local_redo_time_log_type_sampling',
            'stats_wave4_5_local_redo_time_log_type_steps',
            'stats_wave4_5_local_xlog_redo_statics',
            'stats_wave4_5_local_xlog_redo_statics_extra',
            'stats_wave4_5_shared_memctx_detail',
            'stats_wave4_5_session_memctx_detail',
            'stats_wave4_5_memory_detail_accumulation',
            'stats_wave4_5_history_memory_detail',
            'stats_wave4_5_stack',
            'stats_wave4_5_perf_service_precondition',
            'stats_wave4_5_perf_start_oncpu',
            'stats_wave4_5_perf_start_offcpu',
            'stats_wave4_5_perf_start_detail',
            'stats_wave4_5_perf_start_all',
            'stats_wave4_5_perf_list',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.29')
        self.assertEqual(source['physical_page_start'], 853)
        self.assertEqual(source['physical_page_end'], 865)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_statistics_wave4_5.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
