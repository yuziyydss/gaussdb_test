"""Master summary and non-sql inventory tests are value-verified."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]

class MasterSummaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.summary = json.loads(
            (ROOT / 'generated/core_function_extraction_master_summary_v1/summary.json')
            .read_text(encoding='utf-8'))

    def test_identity_and_totals(self):
        s = self.summary
        self.assertEqual(s['kind'], 'core_function_extraction_master_summary')
        self.assertEqual(s['id'], 'core_function_extraction_master_summary_v1')
        self.assertRegex(s['catalog']['sha256'], r'[0-9a-f]{64}')
        sm = s['summary']
        self.assertEqual(sm['artifact_count'], 233)
        self.assertEqual(sm['source_count'], 581)
        self.assertEqual(sm['source_page_slice_count'], 4247)
        self.assertEqual(sm['unique_page_count'], 3678)
        self.assertEqual(sm['section_count'], 498)
        self.assertEqual(sm['full_section_count'], 446)
        self.assertEqual(sm['fact_count'], 5078)
        self.assertEqual(sm['open_question_count'], 290)
        self.assertEqual(sm['confirmed_fact_count'], 5078)
        self.assertEqual(sm['fact_type_counts'], {
            'behavior_oracle': 589,
            'constraint': 1949,
            'environment': 160,
            'syntax': 2380,
        })
        self.assertEqual(sm['open_question_count_by_status'], {'open': 290})
        self.assertTrue(sm['all_fact_ids_unique'])
        self.assertTrue(sm['all_open_question_ids_unique'])
        self.assertFalse(sm['database_executed'])
        self.assertFalse(sm['runtime_verified'])

    def test_coverage_mode(self):
        c = self.summary['coverage']
        self.assertEqual(c['mode'], 'included_extraction_artifacts')
        self.assertEqual((c['covered_page_count'], c['required_page_count']),
                         (3678, 3813))
        self.assertEqual(len(c['sections']), 498)
        self.assertEqual(sum(x['coverage_complete'] for x in c['sections']),
                         446)
        self.assertEqual(sum(len(x['missing_pages']) for x in c['sections']),
                         186)

    def test_artifact_rows(self):
        arts = self.summary['artifacts']
        self.assertEqual(len(arts), 233)
        self.assertEqual(sum(x['fact_count'] for x in arts), 5078)
        self.assertEqual(sum(x['open_question_count'] for x in arts), 290)
        self.assertEqual(sum(x['source_count'] for x in arts), 581)

    def test_written_summary_is_current(self):
        import subprocess, sys
        result = subprocess.run(
            [sys.executable,
             str(ROOT / 'scripts/build_core_function_extraction_master_summary.py'),
             '--check'], cwd=ROOT, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


class NonSqlReferenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.non_sql_reference import NonSqlReferenceRegistry
        cls.inventory = NonSqlReferenceRegistry(ROOT).load_all()

    def test_summary_counts(self):
        s = self.inventory.summary
        self.assertEqual(s.source_file_count, 300)
        self.assertEqual(s.fact_count, 6095)
        self.assertEqual(s.fact_status_counts, {'confirmed': 6092, 'needs_verification': 3})
        self.assertEqual(s.fact_type_counts, {'behavior_oracle': 866, 'constraint': 2060, 'environment': 363, 'lifecycle': 2, 'metadata_oracle': 103, 'syntax': 2701})
        self.assertEqual(s.category_counts, {'compatibility': 257, 'log_reference': 2, 'report': 1, 'runtime_parameters': 12, 'schema': 2, 'stored_procedure': 17, 'system_catalog': 6, 'tool_reference': 3})
        self.assertEqual(s.category_fact_counts, {'compatibility': 5407, 'log_reference': 32, 'report': 6, 'runtime_parameters': 174, 'schema': 30, 'stored_procedure': 372, 'system_catalog': 53, 'tool_reference': 21})

    def test_unresolved_ids(self):
        s = self.inventory.summary
        self.assertEqual(s.duplicate_bare_fact_id_count, 8)
        self.assertEqual(len(s.unresolved_fact_ids), 3)

    def test_written_inventory_is_current(self):
        import subprocess, sys
        from core.non_sql_reference import NonSqlReferenceRegistry
        fresh = NonSqlReferenceRegistry(ROOT).load_all()
        self.assertEqual(fresh.summary.fact_count, 6095)
        self.assertEqual(fresh.summary.source_file_count, 300)


if __name__ == '__main__':
    unittest.main()
