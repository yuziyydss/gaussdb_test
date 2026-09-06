import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor


class RollbackPackageTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / "specs")
        cls.registry.load_all()

    def test_all_three_documented_forms_without_fake_pairs(self):
        generator = FactorPackageSQLGenerator(self.registry)
        cases, report = generator.generate_with_report(self.registry.manifests["manifest_rollback_positive"])
        self.assertEqual({case.sql for case in cases}, {
            "ROLLBACK;", "ROLLBACK WORK;", "ROLLBACK TRANSACTION;",
        })
        self.assertEqual(len({case.case_id for case in cases}), 3)
        self.assertEqual(report.feasible_pair_count, 0)

    def test_source_complete_does_not_claim_executed_behavior(self):
        report = FactorCoverageAuditor(self.registry).audit("rollback")
        self.assertTrue(report["conclusions"]["source_extraction_complete"])
        self.assertTrue(report["conclusions"]["generation_model_complete"])
        self.assertFalse(report["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(self.registry.factors["rollback"].status, "needs_review")

    def test_lifecycle_examples_and_notices_remain_planned(self):
        factor = self.registry.factors["rollback"]
        self.assertEqual(len(factor.scenario_refs), 3)
        self.assertTrue(all(self.registry.scenarios[ref].status == "planned" for ref in factor.scenario_refs))
        manifest = self.registry.manifests["manifest_rollback_positive"]
        self.assertEqual(manifest.expected.scope, "syntax_only")


if __name__ == "__main__":
    unittest.main()
