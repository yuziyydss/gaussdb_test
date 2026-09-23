"""Utility recovery and event commands close static syntax coverage."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
PACKAGES = {
    "purge": (
        ["manifest_purge_table", "manifest_purge_index"],
        "purge_fact_global_and_acl",
        2,
    ),
    "reassign_owned": (
        ["manifest_reassign_owned_dedicated_tables"],
        "reassign_owned_fact_shared_scope",
        2,
    ),
    "show_events": (
        ["manifest_show_events_empty_schema"],
        "show_events_fact_runtime_rows",
        9,
    ),
    "timecapsule_table": (
        [
            "manifest_timecapsule_table_drop",
            "manifest_timecapsule_table_drop_rename",
            "manifest_timecapsule_table_truncate",
        ],
        "timecapsule_table_fact_runtime_point",
        3,
    ),
}


class StaticCoverageClosureXXIVTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self, manifest_ids):
        cases = []
        for manifest_id in manifest_ids:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_finite_syntax_only_candidates_are_preserved(self):
        for factor_id, (manifest_ids, _, case_count) in PACKAGES.items():
            with self.subTest(factor=factor_id):
                cases = self.generated(manifest_ids)
                self.assertEqual(len(cases), case_count)
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
        for factor_id, (manifest_ids, _, _) in PACKAGES.items():
            self.generated(manifest_ids)
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
