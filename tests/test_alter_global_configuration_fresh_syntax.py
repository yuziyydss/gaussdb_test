"""ALTER GLOBAL CONFIGURATION uses two static key/value syntax representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_alter_global_configuration_fresh_syntax'
EXPECTED={
    "ALTER GLOBAL CONFIGURATION WITH (g_alter_global_config_syntax = 'static_only');",
    "ALTER GLOBAL CONFIGURATION WITH (b8_test_key_a = 'true', b8_test_key_b = 'false');",
}


class AlterGlobalConfigurationFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_and_two_entry_syntax_candidates_are_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),2)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED)
        self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_initial_user_gate_and_no_global_state_change(self):
        cases,_=self.cases()
        for case in cases:
            gates={g['key']:g for g in case.environment_requirements}
            self.assertEqual(gates['global_configuration_privilege']['allowed_values'],['initial_user'])
            self.assertEqual(case.setup_sqls,[])
            self.assertEqual(case.teardown_sqls,[])
            self.assertNotIn('weak_password',case.sql)
            self.assertNotIn('undostoragetype',case.sql)

    def test_syntax_feature_is_covered_without_upsert_claim(self):
        self.cases()
        feature={f.id:f for f in self.r.matrices['matrix_alter_global_configuration_coverage'].documented_features}['alter_global_configuration_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'alter_global_configuration_entries_one',
            'alter_global_configuration_entries_two',
        ])
        audit=FactorCoverageAuditor(self.r).audit('alter_global_configuration')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('alter_global_configuration_feature_global_upsert',audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
