"""Connection, database, rule, and M SET static closures."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "clean_connection": (
        [
            "clean_connection_fact_nodes_profile",
            "clean_connection_fact_scope_profile",
            "clean_connection_fact_user_profile",
        ],
        4,
    ),
    "alter_database": (
        [
            "alter_database_fact_ilm_name_ambiguity",
            "alter_database_fact_owner_membership",
            "alter_database_fact_private_oracle",
            "alter_database_fact_schema_wording",
            "alter_database_fact_tablespace_profile",
            "alter_database_fact_timezone_profile",
        ],
        18,
    ),
    "create_rule": (
        [
            "create_rule_fact_condition_profile",
            "create_rule_fact_replace_profile",
            "create_rule_fact_returning_profile",
            "create_rule_fact_select_profile",
        ],
        19,
    ),
    "m_set": (
        [
            "m_set_fact_parameter_grammar",
            "m_set_fact_schema_profile_gap",
            "m_set_fact_user_variable_profile_gap",
        ],
        42,
    ),
}


class StaticCoverageClosureXLVIITests(unittest.TestCase):
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
