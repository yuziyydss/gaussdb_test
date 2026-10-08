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
        self.assertEqual(s['summary']['artifact_count'], 153)
        self.assertEqual(s['summary']['source_count'], 396)
        self.assertEqual(s['summary']['source_page_slice_count'], 2807)
        self.assertEqual(s['summary']['unique_page_count'], 2424)
        self.assertEqual(s['summary']['section_count'], 349)
        self.assertEqual(s['summary']['full_section_count'], 299)
        self.assertEqual(s['summary']['fact_count'], 3476)
        self.assertEqual(s['summary']['unique_fact_id_count'], 3476)
        self.assertEqual(s['summary']['open_question_count'], 210)
        self.assertEqual(s['summary']['unique_open_question_id_count'], 210)
        self.assertEqual(s['summary']['fact_type_counts'], {
            'behavior_oracle': 389, 'constraint': 1317,
            'environment': 157, 'syntax': 1613,
        })
        self.assertEqual(s['summary']['confirmed_fact_count'], 3476)
        self.assertEqual(s['summary']['open_question_count_by_status'], {'open': 210})
        self.assertTrue(s['summary']['all_fact_ids_unique'])
        self.assertTrue(s['summary']['all_open_question_ids_unique'])
        self.assertFalse(s['summary']['database_executed'])
        self.assertFalse(s['summary']['runtime_verified'])

    def test_coverage_mode_and_partial_sections(self):
        c = self.summary['coverage']
        self.assertEqual(c['mode'], 'included_extraction_artifacts')
        self.assertEqual((c['covered_page_count'], c['required_page_count']), (2424, 2424))
        self.assertEqual(c['missing_pages'], [])
        self.assertEqual(c['extra_pages'], [])
        self.assertTrue(c['complete'])
        self.assertEqual(len(c['sections']), 349)
        self.assertEqual(sum(x['coverage_complete'] for x in c['sections']), 299)
        self.assertEqual(sum(len(x['missing_pages']) for x in c['sections']), 50)

    def test_artifact_rows_and_facts_align(self):
        arts = self.summary['artifacts']
        self.assertEqual(len(arts), 153)
        self.assertEqual(sum(x['fact_count'] for x in arts), 3476)
        self.assertEqual(sum(x['open_question_count'] for x in arts), 210)
        self.assertEqual(sum(x['source_count'] for x in arts), 396)

    def test_written_summary_is_current(self):
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_function_extraction_master_summary.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(SUMMARY_PATH.read_text(encoding='utf-8')), self.summary)

if __name__ == '__main__':
    unittest.main()
