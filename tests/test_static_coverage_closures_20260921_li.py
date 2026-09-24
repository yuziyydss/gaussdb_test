"""REVOKE static closure."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
FACT_IDS = [
    "revoke_fact_acl_oracle",
    "revoke_fact_profile_sequences",
    "revoke_fact_profile_database",
    "revoke_fact_profile_domain",
    "revoke_fact_profile_master_key",
    "revoke_fact_profile_column_key",
    "revoke_fact_profile_directory",
    "revoke_fact_profile_fdw",
    "revoke_fact_profile_server",
    "revoke_fact_profile_function",
    "revoke_fact_profile_procedure",
    "revoke_fact_profile_language",
    "revoke_fact_profile_schema",
    "revoke_fact_profile_tablespace",
    "revoke_fact_profile_type",
    "revoke_fact_profile_package",
    "revoke_fact_profile_sysadmin",
    "revoke_fact_profile_any",
    "revoke_fact_profile_database_link",
    "revoke_fact_profile_public_synonym",
]


class StaticCoverageClosureLITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["revoke"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_existing_finite_candidates_are_preserved(self):
        cases = self.generated()
        self.assertEqual(len(cases), 28)
        self.assertTrue(all(case.expected == "success" for case in cases))
        self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))

    def test_runtime_and_source_limits_are_confirmed_facts(self):
        facts = {fact.id: fact for fact in self.r.get_factor("revoke").facts}
        for fact_id in FACT_IDS:
            with self.subTest(fact=fact_id):
                self.assertEqual(facts[fact_id].status, "confirmed")
                self.assertEqual(facts[fact_id].type, "environment")

    def test_revoke_closes_static_without_behavior(self):
        self.generated()
        audit = self.auditor.audit("revoke")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
