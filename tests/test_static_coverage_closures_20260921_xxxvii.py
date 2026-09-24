"""Text search, partition, INSERT ALL, and COPY static closures."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "create_text_search_configuration": (
        [
            "create_text_search_configuration_fact_internal_validation",
            "create_text_search_configuration_fact_ngram_behavior",
        ],
        12,
    ),
    "create_table_partition": (
        [
            "create_table_partition_fact_large_and_extended",
            "create_table_partition_fact_interval_numeric_conflict",
        ],
        15,
    ),
    "insert_all": (
        [
            "insert_all_fact_negative_oracle",
            "insert_all_fact_else_not_formal",
        ],
        14,
    ),
    "copy": (
        [
            "copy_fact_stream_contract",
            "copy_fact_boundary_protocol",
            "copy_fact_freeze_text_conflict",
        ],
        21,
    ),
}


class StaticCoverageClosureXXXVIITests(unittest.TestCase):
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
                positives = [case for case in cases if case.expected == "success"]
                negatives = [case for case in cases if case.expected == "error"]
                self.assertTrue(positives)
                self.assertTrue(all(case.expected_scope == "syntax_only" for case in positives))
                for case in negatives:
                    self.assertEqual(case.expected_scope, "syntax_and_semantics")
                    self.assertEqual(case.expected_oracle_status, "confirmed")

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
