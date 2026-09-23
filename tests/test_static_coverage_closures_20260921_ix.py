"""Fixed internal commands close static coverage without runtime claims."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "alter_async_encryption_key_rotation": (
        "manifest_alter_async_encryption_key_rotation_fresh_syntax",
        "ALTER ASYNC ENCRYPTION KEY ROTATION;",
    ),
    "autohint_purge": (
        "manifest_autohint_purge_fresh_syntax",
        "AUTOHINT PURGE;",
    ),
    "generated_update_system_object": (
        "manifest_generated_update_system_object_fresh_syntax",
        "GENERATED UPDATE SYSTEM OBJECT;",
    ),
    "impdp_pluggable_database_recover": (
        "manifest_impdp_pluggable_database_recover_fresh_syntax",
        "IMPDP PLUGGABLE DATABASE RECOVER;",
    ),
}


class StaticCoverageClosureXVITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def test_four_fixed_command_candidates_are_static_only(self):
        for factor_id, (manifest_id, sql) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                cases, report = self.g.generate_with_report(
                    self.r.manifests[manifest_id]
                )
                self.assertEqual([case.sql for case in cases], [sql])
                self.assertTrue(report.pairwise_complete)
                self.assertEqual(cases[0].expected, "success")
                self.assertEqual(cases[0].expected_scope, "syntax_only")
                self.assertEqual(cases[0].setup_sqls, [])
                self.assertEqual(cases[0].teardown_sqls, [])

    def test_runtime_limits_are_confirmed_environment_facts(self):
        runtime_fact_ids = {
            "alter_async_encryption_key_rotation":
                "alter_async_encryption_key_rotation_fact_tde_global_restore",
            "autohint_purge": "autohint_purge_fact_runtime_contract",
            "generated_update_system_object":
                "generated_update_system_object_fact_internal_execution_contract",
            "impdp_pluggable_database_recover":
                "impdp_pluggable_database_recover_fact_recovery_lifecycle",
        }
        for factor_id, fact_id in runtime_fact_ids.items():
            with self.subTest(factor=factor_id):
                fact = next(
                    fact for fact in self.r.get_factor(factor_id).facts
                    if fact.id == fact_id
                )
                self.assertEqual((fact.type, fact.status), ("environment", "confirmed"))

    def test_four_packages_close_static_without_behavior(self):
        for factor_id, (manifest_id, _) in PACKAGES.items():
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
