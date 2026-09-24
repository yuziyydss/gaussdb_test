"""ALTER DATABASE LINK static closure without credentials."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureLXTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["alter_database_link"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_two_nonsecret_visibility_candidates_are_preserved(self):
        cases = self.generated()
        self.assertEqual(len(cases), 2)
        self.assertEqual(
            {case.sql for case in cases},
            {
                "ALTER DATABASE LINK g_alter_dblink_static USING (time_out '0');",
                "ALTER PUBLIC DATABASE LINK g_alter_dblink_static USING (time_out '0');",
            },
        )
        for case in cases:
            self.assertEqual(case.expected, "success")
            self.assertEqual(case.expected_scope, "syntax_only")
            self.assertNotIn("IDENTIFIED BY", case.sql)
            self.assertNotIn("PASSWORD", case.sql.upper())
            gates = {gate["key"]: gate for gate in case.environment_requirements}
            self.assertEqual(
                gates["oracle_backend"]["allowed_values"], ["true"]
            )
            self.assertEqual(
                gates["existing_dblink"]["allowed_values"],
                ["oracle_dblink_owned_by_noninitial_principal"],
            )

    def test_runtime_boundary_is_confirmed_environment(self):
        facts = {
            fact.id: fact
            for fact in self.r.get_factor("alter_database_link").facts
        }
        runtime = facts["alter_database_link_fact_runtime_fixture"]
        oracle = facts["alter_database_link_fact_oracle_options"]
        self.assertEqual(runtime.status, "confirmed")
        self.assertEqual(runtime.type, "environment")
        self.assertEqual(oracle.status, "confirmed")
        self.assertEqual(oracle.type, "environment")

    def test_alter_database_link_closes_static_without_behavior(self):
        self.generated()
        audit = self.auditor.audit("alter_database_link")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])
        self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])


if __name__ == "__main__":
    unittest.main()
