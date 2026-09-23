"""SHUTDOWN uses three static mode syntax representatives without execution."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_shutdown_fresh_default'


class ShutdownFreshDefaultTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_all_three_mode_syntax_candidates_are_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),3)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{'SHUTDOWN;','SHUTDOWN FAST;','SHUTDOWN IMMEDIATE;'})
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only' for c in cases))

    def test_no_fixture_or_execution_is_attached(self):
        cases,_=self.cases()
        case=cases[0]
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])
        self.assertFalse(case.environment_requirements == [])
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['shutdown_privilege']['allowed_values'],['admin'])
        self.assertIn('shutdown_fact_privilege',gates['shutdown_privilege']['fact_refs'])

    def test_syntax_feature_is_covered_without_node_shutdown_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_shutdown_coverage'].documented_features}
        feature=features['shutdown_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['shutdown_mode_default','shutdown_mode_fast','shutdown_mode_immediate'])
        audit=FactorCoverageAuditor(self.r).audit('shutdown')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('shutdown_feature_node_shutdown',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
