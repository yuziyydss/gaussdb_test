"""Procedure, operator, text-search dictionary, and synonym static closures."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "alter_procedure": (
        [
            "alter_procedure_fact_owner_schema",
            "alter_procedure_fact_schema_profile",
            "alter_procedure_fact_null_handling",
            "alter_procedure_fact_security_modes",
            "alter_procedure_fact_set_rows",
            "alter_procedure_fact_repeat_actions",
        ],
        17,
    ),
    "create_operator": (
        [
            "create_operator_fact_commutator_profile",
            "create_operator_fact_negator_profile",
            "create_operator_fact_restrict_profile",
            "create_operator_fact_join_profile",
            "create_operator_fact_hash_profile",
            "create_operator_fact_merge_profile",
        ],
        6,
    ),
    "create_text_search_dictionary": (
        [
            "create_text_search_dictionary_fact_authorized_profile",
            "create_text_search_dictionary_fact_synonym_spelling",
            "create_text_search_dictionary_fact_template_profiles",
        ],
        3,
    ),
    "create_synonym": (
        [
            "create_synonym_fact_object_profiles",
            "create_synonym_fact_public_profile",
            "create_synonym_fact_public_search_ambiguity",
            "create_synonym_fact_remote_gap",
        ],
        11,
    ),
}


class StaticCoverageClosureXLVIIITests(unittest.TestCase):
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
