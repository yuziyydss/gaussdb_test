"""DROP TABLE keeps its unbounded list as a finite two-table representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureXVTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def test_two_table_representative_is_generated(self):
        cases, report = self.g.generate_with_report(
            self.r.manifests["manifest_drop_table_basic_positive"]
        )
        self.assertTrue(report.pairwise_complete)
        two_table = [
            case for case in cases
            if case.params["table_profile"] == "dt_table_two"
        ]
        self.assertTrue(two_table)
        self.assertTrue(all("t_dt_one, t_dt_two" in case.sql for case in two_table))

    def test_drop_table_closes_static_without_behavior(self):
        for manifest_id in (
            "manifest_drop_table_basic_positive",
            "manifest_drop_table_cascade_positive",
            "manifest_drop_table_restrict_negative",
        ):
            self.g.generate_with_report(self.r.manifests[manifest_id])
        audit = self.auditor.audit("drop_table")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])


if __name__ == "__main__":
    unittest.main()
