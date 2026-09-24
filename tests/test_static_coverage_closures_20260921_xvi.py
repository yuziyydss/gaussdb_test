"""Global and recovery commands close static syntax coverage."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "drop_resource_label": (
        "manifest_drop_resource_label_existing",
        "drop_resource_label_fact_policy_dependency",
        4,
    ),
    "drop_weak_password_dictionary": (
        "manifest_drop_weak_password_dictionary_fresh_syntax",
        "drop_weak_password_dictionary_fact_global_security_restore",
        1,
    ),
    "refresh_system_object": (
        "manifest_refresh_system_object_fresh_syntax",
        "refresh_system_object_fact_internal_execution_contract",
        1,
    ),
    "timecapsule_database": (
        "manifest_timecapsule_database_fresh_syntax",
        "timecapsule_database_fact_runtime_contract",
        1,
    ),
}


class StaticCoverageClosureXXIIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def test_finite_syntax_only_candidates_are_preserved(self):
        for factor_id, (manifest_id, _, case_count) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                cases, report = self.g.generate_with_report(
                    self.r.manifests[manifest_id]
                )
                self.assertEqual(len(cases), case_count)
                self.assertTrue(report.pairwise_complete)
                self.assertTrue(all(case.expected == "success" for case in cases))
                self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))

    def test_runtime_limits_are_confirmed_environment_facts(self):
        for factor_id, (_, runtime_fact, _) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                fact = next(
                    fact for fact in self.r.get_factor(factor_id).facts
                    if fact.id == runtime_fact
                )
                self.assertEqual((fact.type, fact.status), ("environment", "confirmed"))

    def test_four_packages_close_static_without_behavior(self):
        for factor_id, (manifest_id, _, _) in PACKAGES.items():
            self.g.generate_with_report(self.r.manifests[manifest_id])
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
