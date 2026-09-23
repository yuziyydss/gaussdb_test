"""CREATE OPERATOR CLASS static closure via a finite FUNCTION facet."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureLVTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["create_operator_class"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_fresh_function_candidate_is_preserved(self):
        cases = self.generated()
        self.assertEqual(len(cases), 1)
        case = cases[0]
        self.assertEqual(case.expected, "success")
        self.assertEqual(case.expected_scope, "syntax_only")
        self.assertEqual(
            case.sql,
            "CREATE OPERATOR CLASS g_create_opclass_ns.g_create_opclass "
            "FOR TYPE INTEGER USING btree AS FUNCTION 1 "
            "g_create_opclass_ns.compare_integer(INTEGER, INTEGER);",
        )

    def test_conditional_syntax_slots_have_finite_facet_representatives(self):
        factor = self.r.get_factor("create_operator_class")
        values = {
            value.id: value
            for dimension in factor.dimensions.values()
            for equivalence_class in dimension.classes
            for value in equivalence_class.values
        }
        representations = {
            "create_operator_class_class_name_fresh": "create_operator_class_class_name_candidate",
            "create_operator_class_default_modifier_nondefault": "create_operator_class_default_modifier_none",
            "create_operator_class_data_type_integer": "create_operator_class_data_type_array",
            "create_operator_class_method_btree_fresh": "create_operator_class_method_btree",
            "create_operator_class_family_implicit": "create_operator_class_family_none",
            "create_operator_class_members_fresh_function": "create_operator_class_members_example",
        }
        for fresh, original in representations.items():
            with self.subTest(fresh=fresh):
                self.assertEqual(
                    values[fresh].properties["original_value_ref"], original
                )

    def test_index_and_operand_boundaries_are_confirmed_without_behavior(self):
        facts = {fact.id: fact for fact in self.r.get_factor("create_operator_class").facts}
        self.assertEqual(facts["create_operator_class_fact_index_contract"].type, "environment")
        self.assertEqual(facts["create_operator_class_fact_index_contract"].status, "confirmed")
        self.assertEqual(facts["create_operator_class_fact_operand_ambiguity"].type, "constraint")
        self.assertEqual(facts["create_operator_class_fact_operand_ambiguity"].status, "confirmed")
        self.generated()
        audit = self.auditor.audit("create_operator_class")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
