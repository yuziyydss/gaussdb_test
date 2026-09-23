"""CREATE RESOURCE POOL static closure with a gated MAX_DOP syntax facet."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureLVITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["create_resource_pool"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_ordinary_and_max_dop_candidates_are_preserved(self):
        cases = self.generated()
        self.assertEqual(len(cases), 18)
        self.assertTrue(all(case.expected == "success" for case in cases))
        self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))
        max_dop = [case for case in cases if "MAX_DOP = 1" in case.sql]
        self.assertEqual(len(max_dop), 1)
        self.assertEqual(
            max_dop[0].sql, "CREATE RESOURCE POOL b9_pool WITH (MAX_DOP = 1);"
        )
        gates = {gate["key"]: gate for gate in max_dop[0].environment_requirements}
        self.assertEqual(
            gates["max_dop_support_context"]["allowed_values"],
            ["expansion_or_authoritative_contract"],
        )

    def test_resource_pool_boundaries_are_confirmed_environment(self):
        facts = {fact.id: fact for fact in self.r.get_factor("create_resource_pool").facts}
        for fact_id in (
            "create_resource_pool_fact_io_threshold_conflict",
            "create_resource_pool_fact_additional_options",
            "create_resource_pool_fact_dop_centralized_conflict",
        ):
            with self.subTest(fact=fact_id):
                self.assertEqual(facts[fact_id].status, "confirmed")
                self.assertEqual(facts[fact_id].type, "environment")

    def test_create_resource_pool_closes_static_without_behavior(self):
        self.generated()
        audit = self.auditor.audit("create_resource_pool")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])
        self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])


if __name__ == "__main__":
    unittest.main()
