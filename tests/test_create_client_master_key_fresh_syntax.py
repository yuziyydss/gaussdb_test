"""CREATE CLIENT MASTER KEY uses one static user_token syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_create_client_master_key_fresh_syntax'
KEY='g_create_client_master_key'


class CreateClientMasterKeyFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_five_user_token_algorithm_candidates_are_generated(self):
        cases,report=self.cases()
        algorithms=['AES_256_CBC','AES_256_GCM','SM4','SM4_HMAC_SM3','SM4_CTR_HMAC_SM3']
        expected={
            f'CREATE CLIENT MASTER KEY {KEY} '
            f'WITH (KEY_STORE = user_token, ALGORITHM = {algorithm});'
            for algorithm in algorithms
        }
        self.assertEqual(len(cases),5)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},expected)
        self.assertTrue(all(case.expected=='success' for case in cases))
        self.assertTrue(all(case.expected_scope=='syntax_only' for case in cases))

    def test_user_token_omits_key_path_and_uses_documented_gates(self):
        cases,_=self.cases()
        case=cases[0]
        self.assertNotIn('KEY_PATH',case.sql)
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['encrypted_query_driver']['allowed_values'],['true'])
        self.assertIn('create_client_master_key_fact_driver',
                      gates['encrypted_query_driver']['fact_refs'])
        self.assertEqual(gates['key_store_available']['allowed_values'],['user_token'])
        self.assertIn('create_client_master_key_fact_key_managers',
                      gates['key_store_available']['fact_refs'])
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_driver_or_manager_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_create_client_master_key_coverage'].documented_features}
        feature=features['create_client_master_key_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        audit=FactorCoverageAuditor(self.r).audit('create_client_master_key')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('create_client_master_key_feature_driver',
                         audit['documented_features']['coverage_gaps'])
        self.assertNotIn('create_client_master_key_feature_manager_capabilities',
                         audit['documented_features']['coverage_gaps'])


if __name__=='__main__':unittest.main()
