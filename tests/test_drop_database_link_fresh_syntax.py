"""DROP DATABASE LINK covers finite visibility and IF EXISTS syntax forms."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_database_link_fresh_syntax'
LINK='g_drop_database_link'
EXPECTED={
    f'DROP DATABASE LINK {LINK};',
    f'DROP DATABASE LINK IF EXISTS {LINK};',
    f'DROP PUBLIC DATABASE LINK {LINK};',
    f'DROP PUBLIC DATABASE LINK IF EXISTS {LINK};',
}


class DropDatabaseLinkFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_four_visibility_and_if_exists_candidates_are_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED)
        self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_a_mode_and_non_initial_user_gates(self):
        cases,_=self.cases()
        for case in cases:
            gates={g['key']:g for g in case.environment_requirements}
            self.assertEqual(gates['compatibility_mode']['allowed_values'],['A'])
            self.assertEqual(gates['executor']['allowed_values'],['non_initial_user'])
            self.assertEqual(case.setup_sqls,[])
            self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_runtime_claim(self):
        self.cases()
        feature={f.id:f for f in self.r.matrices['matrix_drop_database_link_coverage'].documented_features}['drop_database_link_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'drop_database_link_visibility_private',
            'drop_database_link_visibility_public',
            'drop_database_link_if_exists_none',
            'drop_database_link_if_exists_yes',
            'drop_database_link_link_name_fresh',
        ])
        audit=FactorCoverageAuditor(self.r).audit('drop_database_link')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('drop_database_link_feature_runtime',audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
