"""Statistics Functions Wave 4-6 flamegraph and shaking extraction is traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_statistics_wave4_6_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_statistics_wave4_6_v1/manifest.json'


class CoreStatisticsWave46Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_sixth_statistics_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_statistics_wave4_6_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 864)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 875)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 11)
        self.assertIn('1.6.29 统计信息函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 23)
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
                self.assertEqual(fact['source_refs'], ['w4_6_1_6_29'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_perf_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'stats_wave4_6_perf_query',
            'stats_wave4_6_perf_query_boundary',
            'stats_wave4_6_perf_query_general',
            'stats_wave4_6_perf_query_general_precision',
            'stats_wave4_6_perf_query_detail',
            'stats_wave4_6_perf_query_detail_precision',
            'stats_wave4_6_perf_report',
            'stats_wave4_6_perf_clean',
            'stats_wave4_6_start_shaking_collect',
            'stats_wave4_6_start_shaking_collect_result',
            'stats_wave4_6_shaking_service_precondition',
            'stats_wave4_6_shaking_frontend_timeout_boundary',
            'stats_wave4_6_shaking_restart_init',
            'stats_wave4_6_do_shaking_collect',
            'stats_wave4_6_do_shaking_collect_timeout',
            'stats_wave4_6_do_shaking_collect_result',
            'stats_wave4_6_close_shaking_collect',
            'stats_wave4_6_close_shaking_collect_result',
            'stats_wave4_6_shaking_collect_result',
            'stats_wave4_6_shaking_collect_result_fields',
            'stats_wave4_6_shaking_collect_status',
            'stats_wave4_6_shaking_collect_status_values',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.29')
        self.assertEqual(source['physical_page_start'], 864)
        self.assertEqual(source['physical_page_end'], 875)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_statistics_wave4_6.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
