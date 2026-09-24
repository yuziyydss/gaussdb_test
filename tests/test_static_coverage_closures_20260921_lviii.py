"""CREATE CLIENT MASTER KEY static closure via the documented user_token branch."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
ALGORITHMS = [
    "AES_256_CBC",
    "AES_256_GCM",
    "SM4",
    "SM4_HMAC_SM3",
    "SM4_CTR_HMAC_SM3",
]


class StaticCoverageClosureLVIIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["create_client_master_key"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_documented_user_token_algorithms_are_preserved(self):
        cases = self.generated()
        self.assertEqual(len(cases), len(ALGORITHMS))
        self.assertTrue(all(case.expected == "success" for case in cases))
        self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))
        expected = {
            f"CREATE CLIENT MASTER KEY g_create_client_master_key "
            f"WITH (KEY_STORE = user_token, ALGORITHM = {algorithm});"
            for algorithm in ALGORITHMS
        }
        self.assertEqual({case.sql for case in cases}, expected)
        for case in cases:
            self.assertNotIn("KEY_PATH", case.sql)
            gates = {gate["key"]: gate for gate in case.environment_requirements}
            self.assertEqual(
                gates["encrypted_query_driver"]["allowed_values"], ["true"]
            )
            self.assertEqual(
                gates["key_store_available"]["allowed_values"], ["user_token"]
            )

    def test_external_manager_branches_and_runtime_secrets_stay_unknown(self):
        factor = self.r.get_factor("create_client_master_key")
        values = {
            value.id: value
            for dimension in factor.dimensions.values()
            for equivalence_class in dimension.classes
            for value in equivalence_class.values
        }
        self.assertEqual(
            values["create_client_master_key_key_store_hcs_kms"].validity, "unknown"
        )
        self.assertEqual(
            values["create_client_master_key_key_store_sdf_kms"].validity, "unknown"
        )
        self.assertEqual(
            values["create_client_master_key_algorithm_aes_256"].validity, "unknown"
        )
        facts = {fact.id: fact for fact in factor.facts}
        for fact_id in (
            "create_client_master_key_fact_runtime_credentials",
            "create_client_master_key_fact_capability_matrix",
        ):
            with self.subTest(fact=fact_id):
                self.assertEqual(facts[fact_id].status, "confirmed")
                self.assertEqual(facts[fact_id].type, "environment")

    def test_create_client_master_key_closes_static_without_behavior(self):
        self.generated()
        audit = self.auditor.audit("create_client_master_key")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])
        self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])


if __name__ == "__main__":
    unittest.main()
