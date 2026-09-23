"""REFRESH SYSTEM OBJECT uses one fixed static syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_refresh_system_object_fresh_syntax'


class RefreshSystemObjectFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_fixed_command_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,'REFRESH SYSTEM OBJECT;')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_upgrade_context_mode_and_executor_gates(self):
        cases,_=self.cases()
        case=cases[0]
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['upgrade_context']['allowed_values'],
                         ['authoritative_pre_507_upgrade'])
        self.assertIn('refresh_system_object_fact_upgrade_context',
                      gates['upgrade_context']['fact_refs'])
        self.assertEqual(gates['upgrade_mode']['allowed_values'],['nonzero'])
        self.assertIn('refresh_system_object_fact_upgrade_mode',
                      gates['upgrade_mode']['fact_refs'])
        self.assertEqual(gates['executor']['allowed_values'],['initial_user'])
        self.assertIn('refresh_system_object_fact_initial_user',
                      gates['executor']['fact_refs'])
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_upgrade_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_refresh_system_object_coverage'].documented_features}
        feature=features['refresh_system_object_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['refresh_system_object_command_fixed'])
        audit=FactorCoverageAuditor(self.r).audit('refresh_system_object')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('refresh_system_object_feature_internal_upgrade',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
