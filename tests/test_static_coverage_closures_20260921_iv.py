"""DROP CAST and DROP RLS POLICY close static coverage with missing targets."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureXITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self, manifest_id):
        return self.g.generate_with_report(self.r.manifests[manifest_id])

    def test_drop_cast_missing_if_exists_is_static(self):
        cases, report = self.generated("manifest_drop_cast_missing_if_exists")
        self.assertEqual([case.sql for case in cases], [
            "DROP CAST IF EXISTS (drop_cast_missing_source AS drop_cast_missing_target);",
        ])
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].expected_scope, "syntax_only")
        self.assertEqual(cases[0].setup_sqls, [])
        self.assertEqual(cases[0].teardown_sqls, [])

    def test_drop_cast_existing_forms_are_preserved(self):
        cases, report = self.generated("manifest_drop_cast_owned_conversion")
        self.assertEqual(len(cases), 6)
        self.assertTrue(report.pairwise_complete)
        sqls = {case.sql for case in cases}
        self.assertIn(
            "DROP CAST (double precision AS timestamp with time zone);",
            sqls,
        )
        self.assertIn(
            "DROP CAST IF EXISTS (double precision AS timestamp with time zone) CASCADE;",
            sqls,
        )
        self.assertIn(
            "DROP CAST (double precision AS timestamp with time zone) RESTRICT;",
            sqls,
        )

    def test_drop_rls_missing_if_exists_is_static(self):
        cases, report = self.generated(
            "manifest_drop_row_level_security_policy_missing_if_exists"
        )
        self.assertEqual([case.sql for case in cases], [
            "DROP POLICY IF EXISTS b10_rls_missing ON b10_rls_source;",
        ])
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].expected_scope, "syntax_only")
        self.assertEqual(cases[0].setup_sqls, [])
        self.assertEqual(cases[0].teardown_sqls, [])

    def test_drop_rls_existing_forms_are_preserved(self):
        cases, report = self.generated(
            "manifest_drop_row_level_security_policy_existing"
        )
        self.assertEqual(len(cases), 6)
        self.assertTrue(report.pairwise_complete)
        sqls = {case.sql for case in cases}
        self.assertIn("DROP POLICY b10_rls_existing ON b10_rls_source;", sqls)
        self.assertIn(
            "DROP ROW LEVEL SECURITY POLICY IF EXISTS b10_rls_existing ON b10_rls_source;",
            sqls,
        )

    def test_two_packages_close_static_without_behavior(self):
        for manifest_id in (
            "manifest_drop_cast_owned_conversion",
            "manifest_drop_cast_missing_if_exists",
            "manifest_drop_row_level_security_policy_existing",
            "manifest_drop_row_level_security_policy_missing_if_exists",
        ):
            self.g.generate_with_report(self.r.manifests[manifest_id])
        for factor_id in ("drop_cast", "drop_row_level_security_policy"):
            with self.subTest(factor=factor_id):
                audit = self.auditor.audit(factor_id)
                self.assertTrue(audit["conclusions"]["source_extraction_complete"])
                self.assertTrue(audit["conclusions"]["generation_model_complete"])
                self.assertTrue(audit["conclusions"]["static_coverage_complete"])
                self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
                self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
                self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
