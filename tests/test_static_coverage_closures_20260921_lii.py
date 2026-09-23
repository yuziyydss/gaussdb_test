"""CLUSTER static closure with a source-confirmed missing-index error."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureLIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["cluster"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_existing_candidates_and_source_error_are_preserved(self):
        cases = self.generated()
        self.assertEqual(len(cases), 6)
        self.assertEqual(sum(case.expected == "success" for case in cases), 5)
        negative = [case for case in cases if case.expected == "error"]
        self.assertEqual(len(negative), 1)
        self.assertEqual(negative[0].sql, "CLUSTER t_cluster_unset;")
        self.assertEqual(negative[0].expected_oracle_status, "confirmed")
        self.assertEqual(
            negative[0].expected_error_regex,
            'there is no previously clustered index for table ".*"',
        )

    def test_runtime_limits_are_confirmed_facts(self):
        facts = {fact.id: fact for fact in self.r.get_factor("cluster").facts}
        for fact_id in (
            "cluster_fact_partition_profile",
            "cluster_fact_all_profile",
            "cluster_fact_index_profile",
        ):
            with self.subTest(fact=fact_id):
                self.assertEqual(facts[fact_id].status, "confirmed")
                self.assertEqual(facts[fact_id].type, "environment")
        self.assertEqual(
            facts["cluster_fact_missing_index_error"].type, "behavior_oracle"
        )
        self.assertEqual(facts["cluster_fact_missing_index_error"].status, "confirmed")

    def test_cluster_closes_static_without_behavior(self):
        self.generated()
        audit = self.auditor.audit("cluster")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])
        self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])


if __name__ == "__main__":
    unittest.main()
