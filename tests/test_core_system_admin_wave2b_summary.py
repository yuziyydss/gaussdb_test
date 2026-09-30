"""Aggregate Wave 2B summary checks page and subsection coverage."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SUMMARY_PATH = ROOT / 'generated/core_system_admin_wave2b_summary_v1/summary.json'


class CoreSystemAdminWave2BSummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.summary = json.loads(SUMMARY_PATH.read_text(encoding='utf-8'))

    def test_summary_identity_and_catalog(self):
        self.assertEqual(self.summary['kind'], 'core_system_admin_wave2b_summary')
        self.assertEqual(self.summary['id'], 'core_system_admin_wave2b_summary_v1')
        self.assertEqual(self.summary['catalog']['section_number'], '1.6.27')
        self.assertEqual(self.summary['catalog']['physical_page_start'], 592)
        self.assertEqual(self.summary['catalog']['physical_page_end_inclusive'], 804)
        self.assertRegex(self.summary['catalog']['chapter_sha256'], r'[0-9a-f]{64}')

    def test_page_union_is_complete(self):
        coverage = self.summary['coverage']
        self.assertEqual(coverage['mode'], 'page_union')
        self.assertEqual(coverage['covered_page_count'], 213)
        self.assertEqual(coverage['required_page_count'], 213)
        self.assertEqual(coverage['missing_pages'], [])
        self.assertEqual(coverage['extra_pages'], [])
        self.assertTrue(coverage['complete'])
        self.assertEqual(coverage['overlap_page_count'], 11)
        self.assertEqual(
            coverage['overlap_pages'],
            [627, 628, 629, 641, 642, 661, 674, 746, 777, 788, 795],
        )

    def test_all_subsections_are_covered(self):
        coverage = self.summary['coverage']
        self.assertEqual(coverage['subsection_count'], 17)
        self.assertEqual(coverage['missing_subsections'], [])
        self.assertTrue(coverage['all_subsections_covered'])
        self.assertEqual(
            coverage['subsection_numbers'],
            [f'1.6.27.{number}' for number in range(1, 18)],
        )

    def test_totals_and_unique_ids(self):
        summary = self.summary['summary']
        self.assertEqual(summary['wave_count'], 16)
        self.assertEqual(summary['source_chapter_count'], 1)
        self.assertEqual(summary['fact_count'], 378)
        self.assertEqual(summary['unique_fact_id_count'], 378)
        self.assertEqual(summary['open_question_count'], 33)
        self.assertEqual(summary['unique_open_question_id_count'], 33)
        self.assertEqual(summary['fact_type_counts'], {
            'behavior_oracle': 42,
            'constraint': 108,
            'environment': 20,
            'syntax': 208,
        })
        self.assertEqual(summary['confirmed_fact_count'], 378)
        self.assertEqual(summary['open_question_count_by_status'], {'open': 33})
        self.assertTrue(summary['all_sources_resolved'])
        self.assertTrue(summary['all_fact_ids_unique'])
        self.assertTrue(summary['all_open_question_ids_unique'])
        self.assertTrue(summary['page_coverage_complete'])
        self.assertTrue(summary['all_subsections_covered'])
        self.assertFalse(summary['database_executed'])
        self.assertFalse(summary['runtime_verified'])

    def test_wave_rows_are_complete(self):
        waves = self.summary['waves']
        self.assertEqual([item['wave'] for item in waves], [
            '2B-1', '2B-2', '2B-3', '2B-4', '2B-5A', '2B-5B', '2B-6', '2B-7',
            '2B-8', '2B-9', '2B-10', '2B-11', '2B-12', '2B-13', '2B-14', '2B-15',
        ])
        self.assertEqual(sum(item['fact_count'] for item in waves), 378)
        self.assertEqual(sum(item['open_question_count'] for item in waves), 33)
        self.assertTrue(all(item['source_resolved'] for item in waves))
        self.assertEqual(waves[0]['physical_page_start'], 592)
        self.assertEqual(waves[-1]['physical_page_end_inclusive'], 804)

    def test_written_summary_is_current(self):
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_admin_wave2b_summary.py'), '--check'],
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
