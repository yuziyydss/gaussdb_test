"""DROP IF EXISTS missing-object forms stay static syntax-only."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureXTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self, manifest_id):
        return self.g.generate_with_report(self.r.manifests[manifest_id])

    def test_drop_audit_policy_missing_if_exists_is_static(self):
        cases, report = self.generated("manifest_drop_audit_policy_missing_if_exists")
        self.assertEqual([case.sql for case in cases], [
            "DROP AUDIT POLICY IF EXISTS b10_audit_missing;",
        ])
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].expected_scope, "syntax_only")
        self.assertEqual(cases[0].setup_sqls, [])
        self.assertEqual(cases[0].teardown_sqls, [])

    def test_drop_directory_missing_if_exists_is_static(self):
        cases, report = self.generated("manifest_drop_directory_missing_if_exists")
        self.assertEqual([case.sql for case in cases], [
            "DROP DIRECTORY IF EXISTS dir_b7_missing;",
        ])
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].expected_scope, "syntax_only")
        self.assertEqual(cases[0].setup_sqls, [])
        self.assertEqual(cases[0].teardown_sqls, [])

    def test_drop_event_missing_if_exists_is_static(self):
        cases, report = self.generated("manifest_drop_event_missing_if_exists")
        self.assertEqual([case.sql for case in cases], [
            "DROP EVENT IF EXISTS fp_cs_one.b10_event_missing;",
        ])
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].expected_scope, "syntax_only")
        self.assertEqual(cases[0].setup_sqls, [])
        self.assertEqual(cases[0].teardown_sqls, [])

    def test_existing_object_forms_are_preserved(self):
        expected = {
            "manifest_drop_audit_policy_existing": [
                "DROP AUDIT POLICY b10_audit_existing;",
                "DROP AUDIT POLICY IF EXISTS b10_audit_existing;",
            ],
            "manifest_drop_directory_existing": [
                "DROP DIRECTORY dir_b7;",
                "DROP DIRECTORY IF EXISTS dir_b7;",
            ],
            "manifest_drop_event_existing": [
                "DROP EVENT fp_cs_one.b10_event_existing;",
                "DROP EVENT IF EXISTS fp_cs_one.b10_event_existing;",
            ],
        }
        for manifest_id, sqls in expected.items():
            with self.subTest(manifest=manifest_id):
                cases, report = self.generated(manifest_id)
                self.assertEqual([case.sql for case in cases], sqls)
                self.assertTrue(report.pairwise_complete)

    def test_three_packages_close_static_without_behavior(self):
        for manifest_id in (
            "manifest_drop_audit_policy_existing",
            "manifest_drop_audit_policy_missing_if_exists",
            "manifest_drop_directory_existing",
            "manifest_drop_directory_missing_if_exists",
            "manifest_drop_event_existing",
            "manifest_drop_event_missing_if_exists",
        ):
            self.g.generate_with_report(self.r.manifests[manifest_id])
        for factor_id in ("drop_audit_policy", "drop_directory", "drop_event"):
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
