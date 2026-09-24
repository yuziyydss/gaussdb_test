"""DROP PROCEDURE gates its finite static owner representative explicitly."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureXIVTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def test_existing_procedure_has_initial_owner_environment_gate(self):
        cases, report = self.g.generate_with_report(
            self.r.manifests["manifest_drop_procedure_existing"]
        )
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(len(cases), 2)
        gates = {
            gate["key"]: gate
            for case in cases
            for gate in case.environment_requirements
        }
        self.assertEqual(gates["procedure_owner"]["allowed_values"], ["initial_user"])
        self.assertEqual(gates["session_user"]["allowed_values"], ["initial_user"])
        self.assertIn("drop_procedure_fact_initial", gates["procedure_owner"]["fact_refs"])
        self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))

    def test_drop_procedure_closes_static_without_behavior(self):
        self.g.generate_with_report(
            self.r.manifests["manifest_drop_procedure_existing"]
        )
        self.g.generate_with_report(
            self.r.manifests["manifest_drop_procedure_missing"]
        )
        audit = self.auditor.audit("drop_procedure")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
