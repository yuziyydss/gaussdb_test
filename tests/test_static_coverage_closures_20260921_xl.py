"""SAVEPOINT, M SELECT, and text-search static closures."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "savepoint": (
        [
            "savepoint_fact_error_identity",
            "savepoint_fact_failure_setup_gap",
        ],
        1,
        {"syntax_and_semantics"},
    ),
    "m_select": (
        [
            "m_select_fact_subquery_ambiguity",
            "m_select_fact_max_gap",
            "m_select_fact_min_gap",
            "m_select_fact_approximate_source_gap",
            "m_select_fact_avg_gap",
            "m_select_fact_count_gap",
        ],
        50,
        {"syntax_only"},
    ),
    "alter_text_search_configuration": (
        [
            "alter_text_search_configuration_fact_referenced_profile",
            "alter_text_search_configuration_fact_owner_profile",
            "alter_text_search_configuration_fact_plan_cache_profile",
        ],
        12,
        {"syntax_only"},
    ),
    "alter_text_search_dictionary": (
        [
            "alter_text_search_dictionary_fact_template_profiles",
            "alter_text_search_dictionary_fact_owner_profile",
            "alter_text_search_dictionary_fact_dummy_profile",
        ],
        5,
        {"syntax_only"},
    ),
}


class StaticCoverageClosureXLTests(unittest.TestCase):
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

    def test_existing_finite_candidates_are_preserved(self):
        for factor_id, (_, case_count, scopes) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                cases = self.generated(factor_id)
                self.assertEqual(len(cases), case_count)
                self.assertTrue(all(case.expected == "success" for case in cases))
                self.assertEqual({case.expected_scope for case in cases}, scopes)

    def test_runtime_and_source_limits_are_confirmed_facts(self):
        for factor_id, (fact_ids, _, _) in PACKAGES.items():
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
