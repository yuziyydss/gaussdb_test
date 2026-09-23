"""SET SESSION AUTHORIZATION keeps role switching syntax-only."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
MID = "manifest_set_session_authorization_fresh_switch"
SQL = "SET SESSION SESSION AUTHORIZATION set_session_auth_fresh PASSWORD 'SetSessionAuth_2026_Aa9';"


class SetSessionAuthorizationFreshSwitchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def test_one_switch_candidate_is_generated(self):
        self.assertIn(MID, self.r.manifests)
        cases, report = self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual([case.sql for case in cases], [SQL])
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].expected, "success")
        self.assertEqual(cases[0].expected_scope, "syntax_only")

    def test_admin_gate_and_non_secret_fixture_boundary_are_preserved(self):
        cases, _ = self.g.generate_with_report(self.r.manifests[MID])
        case = cases[0]
        self.assertEqual(case.setup_sqls, [
            "CREATE ROLE set_session_auth_fresh LOGIN PASSWORD 'SetSessionAuth_2026_Aa9';",
        ])
        self.assertEqual(case.teardown_sqls, [
            "RESET SESSION AUTHORIZATION;",
            "DROP ROLE IF EXISTS set_session_auth_fresh;",
        ])
        gates = {gate["key"]: gate for gate in case.environment_requirements}
        self.assertEqual(
            gates["isolated_session"]["allowed_values"],
            ["dedicated_non_production_initial_admin_session"],
        )
        self.assertEqual(gates["initial_session_user"]["allowed_values"], ["sysadmin"])
        self.assertEqual(
            gates["password_contract"]["allowed_values"],
            ["static_non_secret_fixture_literal"],
        )
        fixture = self.r.fixtures["fixture_set_session_authorization_fresh_switch"]
        self.assertIn("不是秘密", fixture.execution.note)
        self.assertIn("不验证会话用户", fixture.execution.note)

    def test_switch_closes_static_model_without_behavior_claim(self):
        self.g.generate_with_report(self.r.manifests[MID])
        audit = FactorCoverageAuditor(self.r).audit("set_session_authorization")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["values"]["coverage_gaps"], [])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
