"""Cross-chapter system-function extraction summary checks totals and coverage."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SUMMARY_PATH = ROOT / 'generated/core_system_function_extraction_summary_v1/summary.json'


class CoreSystemFunctionExtractionSummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.summary = json.loads(SUMMARY_PATH.read_text(encoding='utf-8'))

    def test_summary_identity_and_catalog(self):
        self.assertEqual(self.summary['kind'], 'core_system_function_extraction_summary')
        self.assertEqual(self.summary['id'], 'core_system_function_extraction_summary_v1')
        self.assertEqual(
            self.summary['catalog']['section_numbers'],
            ['1.6.26', '1.6.27', '1.6.28', '1.6.29'],
        )
        self.assertRegex(self.summary['catalog']['sha256'], r'[0-9a-f]{64}')

    def test_cross_chapter_page_union_is_complete(self):
        coverage = self.summary['coverage']
        self.assertEqual(coverage['mode'], 'cross_chapter_page_union')
        self.assertEqual(coverage['physical_page_start'], 560)
        self.assertEqual(coverage['physical_page_end_inclusive'], 900)
        self.assertEqual(coverage['required_page_count'], 341)
        self.assertEqual(coverage['covered_page_count'], 341)
        self.assertEqual(coverage['chapter_page_slice_count'], 344)
        self.assertEqual(coverage['boundary_overlap_page_count'], 3)
        self.assertEqual(coverage['boundary_overlap_pages'], [592, 804, 812])
        self.assertEqual(coverage['missing_pages'], [])
        self.assertEqual(coverage['extra_pages'], [])
        self.assertTrue(coverage['complete'])

    def test_totals_and_unique_ids(self):
        summary = self.summary['summary']
        self.assertEqual(summary['chapter_count'], 4)
        self.assertEqual(summary['source_artifact_count'], 4)
        self.assertEqual(summary['wave_count'], 31)
        self.assertEqual(summary['fact_count'], 811)
        self.assertEqual(summary['unique_fact_id_count'], 811)
        self.assertEqual(summary['open_question_count'], 63)
        self.assertEqual(summary['unique_open_question_id_count'], 63)
        self.assertEqual(summary['fact_type_counts'], {
            'behavior_oracle': 98,
            'constraint': 271,
            'environment': 42,
            'syntax': 400,
        })
        self.assertEqual(summary['confirmed_fact_count'], 811)
        self.assertEqual(summary['open_question_count_by_status'], {'open': 63})
        self.assertTrue(summary['all_fact_ids_unique'])
        self.assertTrue(summary['all_open_question_ids_unique'])
        self.assertTrue(summary['page_coverage_complete'])
        self.assertFalse(summary['database_executed'])
        self.assertFalse(summary['runtime_verified'])

    def test_chapter_rows_are_complete(self):
        chapters = self.summary['chapters']
        self.assertEqual(
            [item['section_number'] for item in chapters],
            ['1.6.26', '1.6.27', '1.6.28', '1.6.29'],
        )
        self.assertEqual([item['title'] for item in chapters], [
            '系统信息函数',
            '系统管理函数',
            'SPM计划管理函数',
            '统计信息函数',
        ])
        self.assertEqual([item['wave_count'] for item in chapters], [4, 16, 1, 10])
        self.assertEqual([item['fact_count'] for item in chapters], [122, 378, 21, 290])
        self.assertEqual([item['open_question_count'] for item in chapters], [8, 33, 2, 20])
        self.assertEqual(sum(item['physical_page_count'] for item in chapters), 344)
        self.assertTrue(all(item['coverage_complete'] for item in chapters))
        self.assertEqual(chapters[0]['physical_page_start'], 560)
        self.assertEqual(chapters[-1]['physical_page_end_inclusive'], 900)

    def test_written_summary_is_current(self):
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_function_extraction_summary.py'), '--check'],
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
