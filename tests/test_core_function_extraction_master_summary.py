"""Master function extraction summary checks totals, IDs and coverage mode."""
import json, subprocess, sys, unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SUMMARY_PATH = ROOT / 'generated/core_function_extraction_master_summary_v1/summary.json'

class CoreFunctionExtractionMasterSummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.summary = json.loads(SUMMARY_PATH.read_text(encoding='utf-8'))

    def test_identity_and_totals(self):
        s = self.summary
        self.assertEqual(s['kind'], 'core_function_extraction_master_summary')
        self.assertEqual(s['id'], 'core_function_extraction_master_summary_v1')
        self.assertRegex(s['catalog']['sha256'], r'[0-9a-f]{64}')
        self.assertEqual(s['summary']['artifact_count'], 64)
        self.assertEqual(s['summary']['source_count'], 165)
        self.assertEqual(s['summary']['source_page_slice_count'], 1426)
        self.assertEqual(s['summary']['unique_page_count'], 1243)
        self.assertEqual(s['summary']['section_count'], 118)
        self.assertEqual(s['summary']['full_section_count'], 68)
        self.assertEqual(s['summary']['fact_count'], 1696)
        self.assertEqual(s['summary']['unique_fact_id_count'], 1696)
        self.assertEqual(s['summary']['open_question_count'], 121)
        self.assertEqual(s['summary']['unique_open_question_id_count'], 121)
        self.assertEqual(s['summary']['fact_type_counts'], {
            'behavior_oracle': 190, 'constraint': 462,
            'environment': 134, 'syntax': 910,
        })
        self.assertEqual(s['summary']['confirmed_fact_count'], 1696)
        self.assertEqual(s['summary']['open_question_count_by_status'], {'open': 121})
        self.assertTrue(s['summary']['all_fact_ids_unique'])
        self.assertTrue(s['summary']['all_open_question_ids_unique'])
        self.assertFalse(s['summary']['database_executed'])
        self.assertFalse(s['summary']['runtime_verified'])

    def test_coverage_mode_and_partial_sections(self):
        c = self.summary['coverage']
        self.assertEqual(c['mode'], 'included_extraction_artifacts')
        self.assertEqual((c['covered_page_count'], c['required_page_count']), (1243, 1243))
        self.assertEqual(c['missing_pages'], [])
        self.assertEqual(c['extra_pages'], [])
        self.assertTrue(c['complete'])
        self.assertEqual(len(c['sections']), 118)
        self.assertEqual(sum(x['coverage_complete'] for x in c['sections']), 68)
        self.assertEqual(sum(len(x['missing_pages']) for x in c['sections']), 50)

    def test_artifact_rows_and_facts_align(self):
        arts = self.summary['artifacts']
        self.assertEqual(len(arts), 64)
        self.assertEqual(sum(x['fact_count'] for x in arts), 1696)
        self.assertEqual(sum(x['open_question_count'] for x in arts), 121)
        self.assertEqual(sum(x['source_count'] for x in arts), 165)

    def test_written_summary_is_current(self):
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_function_extraction_master_summary.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(SUMMARY_PATH.read_text(encoding='utf-8')), self.summary)

if __name__ == '__main__':
    unittest.main()
