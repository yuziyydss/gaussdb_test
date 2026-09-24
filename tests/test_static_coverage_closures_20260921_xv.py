"""DROP OWNED, PACKAGE, SERVER, and TYPE close static syntax coverage."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "drop_owned": (
        "manifest_drop_owned_dedicated_tables",
        "drop_owned_fact_shared_scope",
        4,
    ),
    "drop_package": (
        "manifest_drop_package_existing",
        "drop_package_fact_invalidation_oracle",
        4,
    ),
    "drop_server": (
        "manifest_drop_server_existing",
        "drop_server_fact_dependent_mapping",
        6,
    ),
    "drop_type": (
        "manifest_drop_type_unreferenced",
        "drop_type_fact_dependents_profile",
        9,
    ),
}


class StaticCoverageClosureXXIITests(unittest.TestCase):
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
