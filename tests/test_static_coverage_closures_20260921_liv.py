"""ALTER PACKAGE static closure with finite COMPILE syntax."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class StaticCoverageClosureLIVTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / "specs")
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.auditor = FactorCoverageAuditor(cls.r)

    def generated(self):
        cases = []
        for manifest_id in self.r.factors["alter_package"].manifest_refs:
            generated, report = self.g.generate_with_report(
                self.r.manifests[manifest_id]
            )
            self.assertTrue(report.pairwise_complete)
            cases.extend(generated)
        return cases

    def test_owner_and_compile_syntax_candidates_are_preserved(self):
        cases = self.generated()
        self.assertEqual(len(cases), 5)
        self.assertTrue(all(case.expected == "success" for case in cases))
        self.assertTrue(all(case.expected_scope == "syntax_only" for case in cases))
        sqls = {case.sql for case in cases}
        self.assertIn(
            "ALTER PACKAGE fp_cs_one.b10_package_existing OWNER TO b9_role_b;",
            sqls,
        )
        for suffix in (
            "COMPILE;",
            "COMPILE PACKAGE;",
            "COMPILE BODY;",
            "COMPILE SPECIFICATION;",
        ):
            self.assertIn(
                f"ALTER PACKAGE fp_cs_one.b10_package_existing {suffix}",
                sqls,
            )

    def test_source_conflict_and_owner_boundaries_are_confirmed(self):
        facts = {fact.id: fact for fact in self.r.get_factor("alter_package").facts}
        conflict = facts["alter_package_fact_support_conflict"]
        owner = facts["alter_package_fact_owner_profiles"]
        self.assertEqual(conflict.status, "confirmed")
        self.assertEqual(conflict.type, "environment")
        self.assertIn("不宣称产品支持", conflict.statement)
        self.assertEqual(owner.status, "confirmed")
        self.assertEqual(owner.type, "environment")

    def test_alter_package_closes_static_without_behavior(self):
        self.generated()
        audit = self.auditor.audit("alter_package")
        self.assertTrue(audit["conclusions"]["source_extraction_complete"])
        self.assertTrue(audit["conclusions"]["generation_model_complete"])
        self.assertTrue(audit["conclusions"]["static_coverage_complete"])
        self.assertFalse(audit["conclusions"]["behavior_coverage_complete"])
        self.assertEqual(audit["documented_features"]["coverage_gaps"], [])
        self.assertEqual(audit["facts"]["unresolved"], [])
        self.assertEqual(audit["manifests"]["unresolved_error_oracles"], [])


if __name__ == "__main__":
    unittest.main()
