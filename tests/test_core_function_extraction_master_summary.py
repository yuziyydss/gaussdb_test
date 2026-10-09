"""Master summary and non-sql inventory tests are value-verified."""
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class MasterSummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        import json
        cls.s = json.loads((ROOT / 'generated/core_function_extraction_master_summary_v1/summary.json').read_text(encoding='utf-8'))

    def test_identity(self):
        s = self.s
        self.assertEqual(s['kind'], 'core_function_extraction_master_summary')
        self.assertEqual(s['id'], 'core_function_extraction_master_summary_v1')

    def test_totals(self):
        sm = self.s['summary']
        self.assertEqual(sm['artifact_count'], 238)
        self.assertEqual(sm['source_count'], 586)
        self.assertEqual(sm['source_page_slice_count'], 4375)
        self.assertEqual(sm['unique_page_count'], 3803)
        self.assertEqual(sm['section_count'], 498)
        self.assertEqual(sm['full_section_count'], 446)
        self.assertEqual(sm['fact_count'], 5178)
        self.assertEqual(sm['open_question_count'], 295)
        self.assertEqual(sm['confirmed_fact_count'], 5178)
        self.assertEqual(sm['fact_type_counts'], {
            'behavior_oracle': 589,
            'constraint': 2004,
            'environment': 160,
            'syntax': 2425,
        })
        self.assertEqual(sm['open_question_count_by_status'], {'open': 295})
        self.assertTrue(sm['all_fact_ids_unique'])
        self.assertFalse(sm['database_executed'])

    def test_coverage(self):
        c = self.s['coverage']
        self.assertEqual((c['covered_page_count'], c['required_page_count']),
                         (3803, 3813))
        self.assertEqual(len(c['sections']), 498)
        self.assertEqual(sum(x['coverage_complete'] for x in c['sections']),
                         446)
        self.assertEqual(sum(len(x['missing_pages']) for x in c['sections']),
                         60)

    def test_artifacts(self):
        arts = self.s['artifacts']
        self.assertEqual(len(arts), 238)
        self.assertEqual(sum(x['fact_count'] for x in arts), 5178)
        self.assertEqual(sum(x['open_question_count'] for x in arts), 295)
        self.assertEqual(sum(x['source_count'] for x in arts), 586)

class NonSqlTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.non_sql_reference import NonSqlReferenceRegistry
        cls.inv = NonSqlReferenceRegistry(ROOT).load_all().summary

    def test_counts(self):
        self.assertEqual(self.inv.source_file_count, 305)
        self.assertEqual(self.inv.fact_count, 6195)
        self.assertEqual(self.inv.fact_status_counts, {'confirmed': 6192, 'needs_verification': 3})
        self.assertEqual(self.inv.fact_type_counts, {'behavior_oracle': 866, 'constraint': 2115, 'environment': 363, 'lifecycle': 2, 'metadata_oracle': 103, 'syntax': 2746})
        self.assertEqual(self.inv.category_counts, {'compatibility': 262, 'log_reference': 2, 'report': 1, 'runtime_parameters': 12, 'schema': 2, 'stored_procedure': 17, 'system_catalog': 6, 'tool_reference': 3})
        self.assertEqual(self.inv.category_fact_counts, {'compatibility': 5507, 'log_reference': 32, 'report': 6, 'runtime_parameters': 174, 'schema': 30, 'stored_procedure': 372, 'system_catalog': 53, 'tool_reference': 21})

if __name__ == '__main__':
    unittest.main()
