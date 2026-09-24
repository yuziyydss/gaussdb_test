"""EXPLAIN AUTOHINT static closure with source-confirmed user-call errors."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureLIIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["explain_autohint"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_kernel_syntax_and_source_user_call_errors_are_preserved(self):
        cases = self.generated()
        self.assertEqual(len(cases), 3)
        positive = [case for case in cases if case.expected == "success"]
        negative = [case for case in cases if case.expected == "error"]
        self.assertEqual(len(positive), 1)
        self.assertEqual(positive[0].expected_scope, "syntax_only")
        self.assertEqual(
            positive[0].sql,
            "EXPLAIN AUTOHINT 1 PLAN '[]' FOR SELECT 1;",
        )
        self.assertEqual(len(negative), 2)
        self.assertTrue(
            all(case.expected_oracle_status == "confirmed" for case in negative)
        )
        self.assertTrue(
            all(
                case.expected_error_regex
                == "Can not get exploration cache for cache id: 2"
                for case in negative
            )
        )
        self.assertTrue(any("PLAN" in case.sql for case in negative))
        self.assertTrue(any("EXECUTE" in case.sql for case in negative))

    def test_runtime_boundary_is_confirmed_environment(self):
        facts = {fact.id: fact for fact in self.r.get_factor("explain_autohint").facts}
        runtime = facts["explain_autohint_fact_runtime_contract"]
        error = facts["explain_autohint_fact_user_call_error"]
        self.assertEqual(runtime.status, "confirmed")
        self.assertEqual(runtime.type, "environment")
        self.assertEqual(error.status, "confirmed")
        self.assertEqual(error.type, "behavior_oracle")

    def test_explain_autohint_closes_static_without_behavior(self):
        self.generated()
        audit = self.auditor.audit("explain_autohint")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])
        self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])


if __name__ == "__main__":
    unittest.main()
