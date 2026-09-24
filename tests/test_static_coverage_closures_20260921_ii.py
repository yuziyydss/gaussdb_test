"""ALTER DIRECTORY and ALTER OPERATOR close static coverage with dedicated roles."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureVIIIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def test_alter_directory_owner_role_is_provisioned(self):
        cases, report = self.g.generate_with_report(
            self.r.manifests["manifest_alter_directory_owner"]
        )
        self.assertEqual([case.sql for case in cases], [
            "ALTER DIRECTORY dir_b7 OWNER TO b7_directory_owner;",
        ])
        self.assertTrue(report.pairwise_complete)
        case = cases[0]
        self.assertIn(
            "CREATE ROLE b7_directory_owner NOLOGIN PASSWORD DISABLE;",
            case.setup_sqls,
        )
        self.assertIn("GRANT b7_directory_owner TO CURRENT_USER;", case.setup_sqls)
        self.assertIn("ROLLBACK;", case.teardown_sqls)
        self.assertEqual(case.expected_scope, "syntax_only")

    def test_alter_directory_closes_static_without_behavior(self):
        self.g.generate_with_report(self.r.manifests["manifest_alter_directory_owner"])
        audit = self.auditor.audit("alter_directory")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])

    def test_alter_operator_owner_candidate_is_generated(self):
        cases, report = self.g.generate_with_report(
            self.r.manifests["manifest_alter_operator_owner"]
        )
        self.assertEqual([case.sql for case in cases], [
            "ALTER OPERATOR @#@ (INTEGER, INTEGER) OWNER TO b7_operator_owner;",
        ])
        self.assertTrue(report.pairwise_complete)
        case = cases[0]
        self.assertIn(
            "CREATE ROLE b7_operator_owner NOLOGIN PASSWORD DISABLE;",
            case.setup_sqls,
        )
        self.assertIn("GRANT b7_operator_owner TO CURRENT_USER;", case.setup_sqls)
        self.assertIn("ROLLBACK;", case.teardown_sqls)
        gates = {gate["key"]: gate for gate in case.environment_requirements}
        self.assertEqual(
            gates["operator_owner_static_profile"]["allowed_values"],
            ["dedicated_nologin_fixture_role"],
        )
        self.assertEqual(case.expected_scope, "syntax_only")

    def test_alter_operator_existing_schema_forms_are_preserved(self):
        cases, report = self.g.generate_with_report(
            self.r.manifests["manifest_alter_operator_schema"]
        )
        self.assertEqual([case.sql for case in cases], [
            "ALTER OPERATOR @#@ (INTEGER, INTEGER) SET SCHEMA op_b7_target;",
            "ALTER OPERATOR @#@ (NONE, INTEGER) SET SCHEMA op_b7_target;",
            "ALTER OPERATOR @#@ (INTEGER, NONE) SET SCHEMA op_b7_target;",
        ])
        self.assertTrue(report.pairwise_complete)
        self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))

    def test_alter_operator_closes_static_without_behavior(self):
        self.g.generate_with_report(self.r.manifests["manifest_alter_operator_schema"])
        self.g.generate_with_report(self.r.manifests["manifest_alter_operator_owner"])
        audit = self.auditor.audit("alter_operator")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
