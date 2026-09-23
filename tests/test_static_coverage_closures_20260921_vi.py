"""ALTER RESOURCE LABEL adds one finite TABLE static representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureXIIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def test_remove_table_candidate_is_generated(self):
        cases, report = self.g.generate_with_report(
            self.r.manifests["manifest_alter_resource_label_remove"]
        )
        self.assertTrue(report.pairwise_complete)
        self.assertIn(
            "ALTER RESOURCE LABEL b9_rl_change REMOVE TABLE (b9_rl_source_two);",
            [case.sql for case in cases],
        )
        table_case = next(
            case for case in cases
            if case.params["items"] == "alter_resource_label_items_table"
        )
        self.assertEqual(table_case.expected_scope, "syntax_only")
        self.assertIn(
            "CREATE RESOURCE LABEL b9_rl_change ADD COLUMN(b9_rl_source.col_1, b9_rl_source.col_2), TABLE(b9_rl_source_two);",
            table_case.setup_sqls,
        )

    def test_alter_resource_label_closes_static_without_behavior(self):
        self.g.generate_with_report(
            self.r.manifests["manifest_alter_resource_label_add"]
        )
        self.g.generate_with_report(
            self.r.manifests["manifest_alter_resource_label_remove"]
        )
        audit = self.auditor.audit("alter_resource_label")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
