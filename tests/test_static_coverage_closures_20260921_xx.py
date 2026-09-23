"""M upgrade, DO, partition projection, and masking policy static closures."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "m_generated_update_system": (
        "m_generated_update_system_fact_om_contract",
        "m_generated_update_system_fact_artifact_contract",
        1,
    ),
    "do": ("do_fact_other_languages", None, 4),
    "create_table_partition_subpartition_as": (
        "create_table_partition_subpartition_as_fact_query_and_storage",
        None,
        7,
    ),
    "drop_masking_policy": (
        "drop_masking_policy_fact_multiple_conflict",
        "drop_masking_policy_fact_wrong_noun",
        2,
    ),
}


class StaticCoverageClosureXXVIITests(unittest.TestCase):
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
        for factor_id, (_, _, case_count) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                cases = self.generated(factor_id)
                self.assertEqual(len(cases), case_count)
                self.assertTrue(all(case.expected == "success" for case in cases))
                self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))

    def test_runtime_or_source_limits_are_confirmed_facts(self):
        for factor_id, (fact_id, second_fact_id, _) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                fact_ids = [fact_id] + ([second_fact_id] if second_fact_id else [])
                for current_id in fact_ids:
                    fact = next(
                        fact for fact in self.r.get_factor(factor_id).facts
                        if fact.id == current_id
                    )
                    self.assertEqual(fact.status, "confirmed")
                    self.assertIn(fact.type, {"environment", "constraint"})

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
