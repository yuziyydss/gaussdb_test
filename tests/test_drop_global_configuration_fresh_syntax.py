"""DROP GLOBAL CONFIGURATION uses one- and two-key static syntax representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_global_configuration_fresh_syntax'
EXPECTED={
    'DROP GLOBAL CONFIGURATION g_drop_global_config_syntax;',
    'DROP GLOBAL CONFIGURATION b8_test_key_a, b8_test_key_b;',
}


class DropGlobalConfigurationFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_and_two_key_syntax_candidates_are_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),2)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED)
        self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_initial_user_gate_and_no_global_key_deletion(self):
        cases,_=self.cases()
        for case in cases:
            gates={g['key']:g for g in case.environment_requirements}
            self.assertEqual(gates['global_configuration_privilege']['allowed_values'],['initial_user'])
            self.assertEqual(case.setup_sqls,[])
            self.assertEqual(case.teardown_sqls,[])
            self.assertNotIn('weak_password',case.sql)
            self.assertNotIn('undostoragetype',case.sql)

    def test_syntax_feature_is_covered_without_key_lifecycle_claim(self):
        self.cases()
        feature={f.id:f for f in self.r.matrices['matrix_drop_global_configuration_coverage'].documented_features}['drop_global_configuration_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'drop_global_configuration_names_one',
            'drop_global_configuration_names_two',
        ])
        audit=FactorCoverageAuditor(self.r).audit('drop_global_configuration')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('drop_global_configuration_feature_drop_existing_keys',audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
