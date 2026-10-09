"""Non-SQL reference tests."""
import unittest
from pathlib import Path
from core.non_sql_reference import NonSqlReferenceRegistry

ROOT = Path(__file__).resolve().parents[1]

class NonSqlReferenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.summary = NonSqlReferenceRegistry(ROOT).load_all().summary

    def test_counts(self):
        s = self.summary
        self.assertEqual(s.source_file_count, 306)
        self.assertEqual(s.fact_count, 6215)
        self.assertEqual(s.fact_status_counts, {'confirmed': 6212, 'needs_verification': 3})
        self.assertEqual(s.fact_type_counts, {'behavior_oracle': 866, 'constraint': 2119, 'environment': 363, 'lifecycle': 2, 'metadata_oracle': 103, 'syntax': 2762})
        self.assertEqual(s.category_counts, {'compatibility': 263, 'log_reference': 2, 'report': 1, 'runtime_parameters': 12, 'schema': 2, 'stored_procedure': 17, 'system_catalog': 6, 'tool_reference': 3})
        self.assertEqual(s.category_fact_counts, {'compatibility': 5527, 'log_reference': 32, 'report': 6, 'runtime_parameters': 174, 'schema': 30, 'stored_procedure': 372, 'system_catalog': 53, 'tool_reference': 21})

if __name__ == '__main__':
    unittest.main()
