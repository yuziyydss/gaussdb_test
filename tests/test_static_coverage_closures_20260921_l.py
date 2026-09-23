"""Type, extension, comment, and table static closures."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "create_type": (
        [
            "create_type_fact_base_profile",
            "create_type_fact_indirect_types",
            "create_type_fact_collation_profile",
            "create_type_fact_unicode_limit",
            "create_type_fact_constructor_profile",
        ],
        9,
        {"syntax_only"},
    ),
    "alter_extension": (
        [
            "alter_extension_fact_scripts_review",
            "alter_extension_fact_member_profiles",
        ],
        5,
        {"syntax_only"},
    ),
    "comment": (
        [
            "comment_fact_object_profiles",
            "comment_fact_visibility_profile",
        ],
        124,
        {"syntax_only"},
    ),
    "create_table": (
        [
            "ct_open_error_identity_calibration",
            "ct_open_ilm_whitelist_source",
            "ct_open_table_element_repeat",
            "ct_open_storage_parameter_repeat",
            "ct_open_expression_domains",
            "ct_open_column_constraint_repeat",
            "ct_open_table_constraint_repeat",
            "ct_open_like_option_repeat",
            "ct_open_index_method_domain",
            "ct_open_identity_option_composition",
            "ct_open_ltt_ddl_wording",
            "ct_open_cross_chapter_behavior",
            "ct_open_data_type_domain",
            "ct_open_partition_clause_omitted",
            "ct_open_auto_increment_upper_bound",
            "ct_open_storage_environment_matrix",
            "ct_open_tde_setup",
            "ct_open_on_commit_support_conflict",
            "ct_open_on_update_compatibility_matrix",
            "ct_open_encryption_setup",
            "ct_open_if_not_exists_wording_conflict",
            "ct_open_like_all_enumeration_conflict",
        ],
        8,
        {"syntax_and_semantics"},
    ),
}


class StaticCoverageClosureLTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self, factor_id):
        cases = []
        for manifest_id in self.r.factors[factor_id].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_existing_finite_candidates_are_preserved(self):
        for factor_id, (_, case_count, scopes) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                cases = self.generated(factor_id)
                self.assertEqual(len(cases), case_count)
                self.assertTrue(all(case.expected == "success" for case in cases))
                self.assertEqual({case.expected_scope for case in cases}, scopes)

    def test_runtime_and_source_limits_are_confirmed_facts(self):
        for factor_id, (fact_ids, _, _) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                facts = {fact.id: fact for fact in self.r.get_factor(factor_id).facts}
                for fact_id in fact_ids:
                    self.assertEqual(facts[fact_id].status, "confirmed")
                    self.assertIn(facts[fact_id].type, {"environment", "constraint"})

    def test_four_packages_close_static_without_behavior(self):
        for factor_id in PACKAGES:
            self.generated(factor_id)
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
