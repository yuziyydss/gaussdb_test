"""CREATE SECURITY LABEL static closure with a source-confirmed error."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureLIXTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["create_security_label"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_source_confirmed_error_is_narrowed_to_empty_range(self):
        cases = self.generated()
        self.assertEqual(len(cases), 5)
        negative = [case for case in cases if case.expected == "error"]
        self.assertEqual(len(negative), 1)
        self.assertEqual(negative[0].sql, "CREATE SECURITY LABEL b9_sec_new 'L1:';")
        self.assertEqual(negative[0].expected_oracle_status, "confirmed")
        self.assertEqual(
            negative[0].expected_error_regex,
            'in label text ".*", there at least have one level and one group',
        )

    def test_other_invalid_content_shapes_stay_unknown(self):
        factor = self.r.get_factor("create_security_label")
        values = {
            value.id: value
            for dimension in factor.dimensions.values()
            for equivalence_class in dimension.classes
            for value in equivalence_class.values
        }
        for value_id in (
            "create_security_label_content_reverse_range",
            "create_security_label_content_zero_level",
            "create_security_label_content_lowercase",
        ):
            with self.subTest(value=value_id):
                self.assertEqual(values[value_id].validity, "unknown")

    def test_runtime_boundaries_are_confirmed_environment(self):
        facts = {fact.id: fact for fact in self.r.get_factor("create_security_label").facts}
        for fact_id in (
            "create_security_label_fact_name_profile",
            "create_security_label_fact_label_behavior",
        ):
            with self.subTest(fact=fact_id):
                self.assertEqual(facts[fact_id].status, "confirmed")
                self.assertEqual(facts[fact_id].type, "environment")

    def test_create_security_label_closes_static_without_behavior(self):
        self.generated()
        audit = self.auditor.audit("create_security_label")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])
        self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])


if __name__ == "__main__":
    unittest.main()
