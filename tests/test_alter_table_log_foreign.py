"""Foreign-table RLS negative is archived, not published as an unverified candidate."""
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_alter_table_log_foreign_rls_negative'
ARCHIVE = ROOT / 'archive/spec_reviews/20260923/generated_sql/alter_table' / f'{MID}.sql'


class AlterTableLogForeignTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()

    def test_unverified_negative_is_not_active(self):
        self.assertNotIn(MID, self.registry.manifests)
        self.assertNotIn(MID, self.registry.factors['alter_table'].manifest_refs)

    def test_historical_sql_is_preserved_for_review(self):
        text = ARCHIVE.read_text()
        self.assertIn('ALTER TABLE g_a3_at_log_ns.foreign_table ENABLE ROW LEVEL SECURITY;', text)
        self.assertIn('static_only: true', text)
        self.assertIn('expected: error', text)

    def test_documented_boundary_stays_environment_confirmed(self):
        fact = next(f for f in self.registry.factors['alter_table'].facts
                    if f.id == 'at_open_external_table_fixture')
        self.assertEqual(fact.type, 'environment')
        self.assertEqual(fact.status, 'confirmed')


if __name__ == '__main__':
    unittest.main()
