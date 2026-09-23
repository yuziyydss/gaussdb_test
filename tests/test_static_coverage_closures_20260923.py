"""Static closures for packages whose invalid domains lack error identities."""
from pathlib import Path
import unittest

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry

ROOT = Path(__file__).resolve().parents[1]
FACTORS = (
    "m_alter_default_privileges",
    "m_alter_index",
    "m_alter_table_partition",
    "m_analyze",
    "m_create_function",
    "m_create_group",
    "m_create_role",
    "m_create_table_subpartition",
    "m_create_user",
    "m_drop_function",
    "m_reset",
    "m_vacuum",
    "close",
    "m_alter_database",
    "m_alter_role",
    "m_alter_schema",
    "m_alter_user",
    "m_create_table",
    "m_create_table_partition",
    "m_drop_index",
    "m_load_data",
    "m_lock",
    "m_update",
    "release_savepoint",
    "rollback_to_savepoint",
)


class StaticCoverageClosure20260923Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.auditor = FactorCoverageAuditor(cls.registry)

    def test_single_oracle_gaps_are_closed_without_guessing_errors(self):
        for factor_id in FACTORS:
            with self.subTest(factor=factor_id):
                audit = self.auditor.audit(factor_id)
                conclusions = audit["conclusions"]
                self.assertTrue(conclusions["source_extraction_complete"])
                self.assertTrue(conclusions["generation_model_complete"])
                self.assertTrue(conclusions["static_coverage_complete"])
                self.assertFalse(conclusions["behavior_coverage_complete"])
                self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])
                self.assertEqual(audit["values"]["coverage_gaps"], [])
                self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
                self.assertEqual(audit["facts"]["unresolved"], [])

    def test_uncalibrated_negative_suites_are_not_published(self):
        for factor_id in FACTORS:
            with self.subTest(factor=factor_id):
                factor = self.registry.get_factor(factor_id)
                manifests = [self.registry.manifests[mid] for mid in factor.manifest_refs]
                self.assertFalse(any(m.suite_type == "negative" for m in manifests))
                self.assertTrue(factor.manifest_refs)


class FinalStaticClosureBoundaryTests(unittest.TestCase):
    """The last two manifest-backed static closures keep evidence, not guesses."""

    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.auditor = FactorCoverageAuditor(cls.registry)

    def assert_closed(self, factor_id):
        audit = self.auditor.audit(factor_id)
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["values"]["coverage_gaps"], [])
        self.assertEqual(audit["rules"]["gaps"], [])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])
        self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])
        return audit

    def test_update_keeps_uncalibrated_facets_out_of_static_candidates(self):
        audit = self.assert_closed("update")
        resolved = self.registry.resolve_dimension_values("update")
        unknown = {
            "update_multi_targets_view_invalid",
            "update_set_finite_generated_literal",
            "update_set_finite_generated_null",
            "update_set_tuple_subquery_order_limit_invalid",
            "update_from_self_unaliased_invalid",
            "update_predicate_current_of",
        }
        actual_unknown = {
            value_id
            for dimension in resolved.values()
            for value_id, value in dimension.items()
            if value.validity == "unknown"
        }
        self.assertTrue(unknown <= actual_unknown)
        self.assertGreater(audit["manifests"]["generated_case_count"], 0)

    def test_grant_matches_privilege_allowed_targets(self):
        audit = self.assert_closed("grant")
        manifests = [
            self.registry.manifests[mid]
            for mid in self.registry.factors["grant"].manifest_refs
        ]
        object_manifests = [m for m in manifests if m.bindings.get("object_target")]
        self.assertTrue(object_manifests)
        for manifest in object_manifests:
            rules = [rule.expression for rule in manifest.local_rules]
            self.assertIn(
                "object_target.properties.target_kind in "
                "object_privilege.properties.allowed_target_kinds",
                rules,
            )
        cases = []
        for manifest in manifests:
            generated, report = self.generator.generate_with_report(manifest)
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        self.assertEqual(len({case.sql for case in cases}), len(cases))
        self.assertFalse(audit["manifests"]["duplicate_sql"])


if __name__ == "__main__":
    unittest.main()
