"""Client-only encoding negatives are archived pending runtime Oracle identity."""
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_create_database_client_encoding_negative'
ARCHIVE = ROOT / 'archive/spec_reviews/20260923/generated_sql/create_database' / f'{MID}.sql'


class CreateDatabaseEncodingNegativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()

    def test_unverified_negative_is_not_active(self):
        self.assertNotIn(MID, self.registry.manifests)
        self.assertNotIn(MID, self.registry.factors['create_database'].manifest_refs)

    def test_historical_sql_is_preserved_for_review(self):
        text = ARCHIVE.read_text()
        self.assertIn('static_only: true', text)
        self.assertIn('expected: error', text)
        self.assertIn('ENCODING', text)

    def test_static_closure_keeps_runtime_boundary_false(self):
        from core.factor_coverage_auditor import FactorCoverageAuditor
        audit = FactorCoverageAuditor(self.registry).audit('create_database')
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(audit['manifests']['unresolved_error_oracles'], [])


if __name__ == '__main__':
    unittest.main()
