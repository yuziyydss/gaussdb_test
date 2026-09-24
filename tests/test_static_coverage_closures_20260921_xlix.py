"""Procedure, M PREPARE, function, and VACUUM static closures."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "create_procedure": (
        [
            "create_procedure_fact_output_modes",
            "create_procedure_fact_attributes",
            "create_procedure_fact_leakproof_null",
            "create_procedure_fact_definer",
            "create_procedure_fact_cost_set",
            "create_procedure_fact_indirect_type",
            "create_procedure_fact_named_end_profile",
            "create_procedure_fact_nested_call_profile",
        ],
        9,
    ),
    "m_prepare": (
        ["m_prepare_fact_body_profile_gap"],
        17,
    ),
    "create_function": (
        [
            "create_function_fact_advanced_profiles",
            "create_function_fact_body_link",
            "create_function_fact_cost_boundary",
            "create_function_fact_out_ambiguity",
            "create_function_fact_package_ambiguity",
            "create_function_fact_replace_ambiguity",
        ],
        20,
    ),
    "vacuum": (
        [
            "vacuum_fact_bucket_profile",
            "vacuum_fact_catchup_profile",
            "vacuum_fact_column_negative",
            "vacuum_fact_full_database",
            "vacuum_fact_online_profile",
            "vacuum_fact_parallel_profile",
            "vacuum_fact_partitions",
            "vacuum_fact_subpartitions",
        ],
        23,
    ),
}


class StaticCoverageClosureXLIXTests(unittest.TestCase):
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
