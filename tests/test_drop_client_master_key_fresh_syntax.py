"""DROP CLIENT MASTER KEY covers all finite IF EXISTS and behavior tokens."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_client_master_key_fresh_syntax'
KEY='g_drop_client_master_key'
EXPECTED={
    f'DROP CLIENT MASTER KEY {KEY};',
    f'DROP CLIENT MASTER KEY IF EXISTS {KEY};',
    f'DROP CLIENT MASTER KEY {KEY} CASCADE;',
    f'DROP CLIENT MASTER KEY {KEY} RESTRICT;',
    f'DROP CLIENT MASTER KEY IF EXISTS {KEY} CASCADE;',
    f'DROP CLIENT MASTER KEY IF EXISTS {KEY} RESTRICT;',
}


class DropClientMasterKeyFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_six_syntax_candidates_are_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),6)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED)
        self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_privilege_gate_and_no_key_deletion_fixture(self):
        cases,_=self.cases()
        for case in cases:
            gates={g['key']:g for g in case.environment_requirements}
            self.assertEqual(gates['cmk_drop_privilege']['allowed_values'],['cmk_owner_or_drop_privilege'])
            self.assertEqual(case.setup_sqls,[])
            self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_key_lifecycle_claim(self):
        self.cases()
        feature={f.id:f for f in self.r.matrices['matrix_drop_client_master_key_coverage'].documented_features}['drop_client_master_key_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'drop_client_master_key_if_exists_none',
            'drop_client_master_key_if_exists_yes',
            'drop_client_master_key_key_names_fresh',
            'drop_client_master_key_behavior_v0',
            'drop_client_master_key_behavior_v1',
            'drop_client_master_key_behavior_v2',
        ])
        audit=FactorCoverageAuditor(self.r).audit('drop_client_master_key')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('drop_client_master_key_feature_keys',audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
