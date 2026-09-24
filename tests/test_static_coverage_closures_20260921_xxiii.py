"""Audit, RLS, server, and directory commands close static coverage."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "alter_audit_policy": (
        ["alter_audit_policy_fact_parenthesis_conflict", "alter_audit_policy_fact_all_actions"],
        12,
    ),
    "alter_row_level_security_policy": (
        ["alter_row_level_security_policy_fact_empty_alter", "alter_row_level_security_policy_fact_role_profiles"],
        8,
    ),
    "create_server": (
        ["create_server_fact_connection_profiles", "create_server_fact_tuple_keyword_review"],
        3,
    ),
    "create_directory": (
        ["create_directory_fact_special_characters", "create_directory_fact_filesystem_profiles"],
        2,
    ),
}


class StaticCoverageClosureXXXTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self, factor_id):
        cases = []
        for manifest_id in self.r.factors[factor_id].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_finite_syntax_only_candidates_are_preserved(self):
        for factor_id, (_, case_count) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                cases = self.generated(factor_id)
                self.assertEqual(len(cases), case_count)
                self.assertTrue(all(case.expected == "success" for case in cases))
                self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))

    def test_runtime_and_source_limits_are_confirmed_facts(self):
        for factor_id, (fact_ids, _) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                facts = {fact.id: fact for fact in self.r.get_factor(factor_id).facts}
                for fact_id in fact_ids:
                    self.assertEqual(facts[fact_id].status, "confirmed")
                    self.assertIn(facts[fact_id].type, {"environment", "constraint"})

    def test_four_packages_close_static_without_behavior(self):
        for factor_id in PACKAGES:
            self.generated(factor_id)
        for factor_id in PACKAGES:
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
