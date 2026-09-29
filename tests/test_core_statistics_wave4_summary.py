"""Aggregate Statistics Wave 4 summary checks page coverage and totals."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SUMMARY_PATH = ROOT / 'generated/core_statistics_wave4_summary_v1/summary.json'


class CoreStatisticsWave4SummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.summary = json.loads(SUMMARY_PATH.read_text(encoding='utf-8'))

    def test_summary_identity_and_catalog(self):
        self.assertEqual(self.summary['kind'], 'core_statistics_wave4_summary')
        self.assertEqual(self.summary['id'], 'core_statistics_wave4_summary_v1')
        self.assertEqual(self.summary['catalog']['section_number'], '1.6.29')
        self.assertEqual(self.summary['catalog']['physical_page_start'], 812)
        self.assertEqual(self.summary['catalog']['physical_page_end_inclusive'], 900)
        self.assertRegex(self.summary['catalog']['chapter_sha256'], r'[0-9a-f]{64}')

    def test_page_union_is_complete(self):
        coverage = self.summary['coverage']
        self.assertEqual(coverage['mode'], 'page_union')
        self.assertEqual(coverage['covered_page_count'], 89)
        self.assertEqual(coverage['required_page_count'], 89)
        self.assertEqual(coverage['missing_pages'], [])
        self.assertEqual(coverage['extra_pages'], [])
        self.assertTrue(coverage['complete'])
        self.assertEqual(coverage['overlap_page_count'], 5)
        self.assertEqual(coverage['overlap_pages'], [821, 834, 864, 874, 889])

    def test_totals_and_unique_ids(self):
        summary = self.summary['summary']
        self.assertEqual(summary['wave_count'], 10)
        self.assertEqual(summary['source_chapter_count'], 1)
        self.assertEqual(summary['fact_count'], 290)
        self.assertEqual(summary['unique_fact_id_count'], 290)
        self.assertEqual(summary['open_question_count'], 20)
        self.assertEqual(summary['unique_open_question_id_count'], 20)
        self.assertEqual(summary['fact_type_counts'], {
            'behavior_oracle': 36,
            'constraint': 130,
            'environment': 16,
            'syntax': 108,
        })
        self.assertEqual(summary['confirmed_fact_count'], 290)
        self.assertEqual(summary['open_question_count_by_status'], {'open': 20})
        self.assertTrue(summary['all_sources_resolved'])
        self.assertTrue(summary['all_fact_ids_unique'])
        self.assertTrue(summary['all_open_question_ids_unique'])
        self.assertTrue(summary['page_coverage_complete'])
        self.assertFalse(summary['database_executed'])
        self.assertFalse(summary['runtime_verified'])

    def test_wave_rows_are_complete(self):
        waves = self.summary['waves']
        self.assertEqual([item['wave'] for item in waves], [f'4-{n}' for n in range(1, 11)])
        self.assertEqual(sum(item['fact_count'] for item in waves), 290)
        self.assertEqual(sum(item['open_question_count'] for item in waves), 20)
        self.assertTrue(all(item['source_resolved'] for item in waves))
        self.assertEqual(waves[0]['physical_page_start'], 812)
        self.assertEqual(waves[-1]['physical_page_end_inclusive'], 900)

    def test_written_summary_is_current(self):
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_statistics_wave4_summary.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(
            json.loads(SUMMARY_PATH.read_text(encoding='utf-8')),
            self.summary,
        )


if __name__ == '__main__':
    unittest.main()
