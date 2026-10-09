"""Non-SQL reference facts are typed, categorized, and hash-bound."""
import unittest
from pathlib import Path
from core.non_sql_reference import NonSqlReferenceRegistry

ROOT = Path(__file__).resolve().parents[1]

class NonSqlReferenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.inventory = NonSqlReferenceRegistry(ROOT).load_all()

    def test_counts(self):
        s = self.inventory.summary
        self.assertEqual(s.source_file_count, 300)
        self.assertEqual(s.fact_count, 6095)
        self.assertEqual(s.fact_status_counts, {'confirmed': 6092, 'needs_verification': 3})
        self.assertEqual(s.fact_type_counts, {'behavior_oracle': 866, 'constraint': 2060, 'environment': 363, 'lifecycle': 2, 'metadata_oracle': 103, 'syntax': 2701})
        self.assertEqual(s.category_counts, {'compatibility': 257, 'log_reference': 2, 'report': 1, 'runtime_parameters': 12, 'schema': 2, 'stored_procedure': 17, 'system_catalog': 6, 'tool_reference': 3})
        self.assertEqual(s.category_fact_counts, {'compatibility': 5407, 'log_reference': 32, 'report': 6, 'runtime_parameters': 174, 'schema': 30, 'stored_procedure': 372, 'system_catalog': 53, 'tool_reference': 21})

    def test_unresolved(self):
        s = self.inventory.summary
        self.assertEqual(s.duplicate_bare_fact_id_count, 8)
        self.assertEqual(len(s.unresolved_fact_ids), 3)

if __name__ == '__main__':
    unittest.main()
