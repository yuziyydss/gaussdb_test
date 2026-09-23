"""CREATE GROUP and DROP OPERATOR close static syntax coverage."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureXIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def test_create_group_nologin_is_explicit_legacy_option(self):
        cases, report = self.g.generate_with_report(
            self.r.manifests["manifest_create_group_disabled_password"]
        )
        self.assertEqual(len(cases), 4)
        self.assertTrue(report.pairwise_complete)
        self.assertTrue(all(" NOLOGIN " in case.sql for case in cases))
        self.assertEqual(
            {case.sql for case in cases},
            {
                "CREATE GROUP b9_group_new NOLOGIN PASSWORD DISABLE;",
                "CREATE GROUP b9_group_new NOLOGIN IDENTIFIED BY DISABLE;",
                "CREATE GROUP b9_group_new WITH NOLOGIN PASSWORD DISABLE;",
                "CREATE GROUP b9_group_new WITH NOLOGIN IDENTIFIED BY DISABLE;",
            },
        )
        self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))

    def test_create_group_closes_static_without_behavior(self):
        self.g.generate_with_report(
            self.r.manifests["manifest_create_group_disabled_password"]
        )
        audit = self.auditor.audit("create_group")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])

    def test_drop_operator_behavior_syntax_forms_are_preserved(self):
        cases, report = self.g.generate_with_report(
            self.r.manifests["manifest_drop_operator_existing"]
        )
        self.assertGreaterEqual(len(cases), 6)
        self.assertTrue(report.pairwise_complete)
        sqls = {case.sql for case in cases}
        self.assertIn("DROP OPERATOR @#@ (INTEGER, INTEGER);", sqls)
        self.assertIn("DROP OPERATOR @#@ (NONE, INTEGER) CASCADE;", sqls)
        self.assertIn("DROP OPERATOR @#@ (INTEGER, NONE) RESTRICT;", sqls)
        self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))

    def test_drop_operator_closes_static_without_behavior(self):
        self.g.generate_with_report(
            self.r.manifests["manifest_drop_operator_existing"]
        )
        audit = self.auditor.audit("drop_operator")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
