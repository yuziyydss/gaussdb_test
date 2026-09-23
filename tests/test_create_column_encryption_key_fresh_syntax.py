"""CREATE COLUMN ENCRYPTION KEY covers all source-listed finite algorithms."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]; MID='manifest_create_column_encryption_key_fresh_syntax'
KEY='g_create_column_encryption_key'; CMK='g_create_client_master_key'; ALGORITHMS=['AEAD_AES_256_CBC_HMAC_SHA256','AEAD_AES_128_CBC_HMAC_SHA256','AEAD_AES_256_CTR_HMAC_SHA256','AES_256_GCM','SM4_HMAC_SM3','SM4_CTR_HMAC_SM3','SM4_SM3']
EXPECTED={f'CREATE COLUMN ENCRYPTION KEY {KEY} WITH VALUES (CLIENT_MASTER_KEY = {CMK}, ALGORITHM = {algorithm} );' for algorithm in ALGORITHMS}


class CreateColumnEncryptionKeyFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests);return self.g.generate_with_report(self.r.manifests[MID])

    def test_seven_algorithm_candidates_are_generated(self):
        cases,report=self.cases();self.assertEqual(len(cases),7);self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED);self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_omits_encrypted_value_and_uses_documented_gates(self):
        cases,_=self.cases()
        for case in cases:
            self.assertNotIn('ENCRYPTED_VALUE',case.sql);gates={g['key']:g for g in case.environment_requirements}
            self.assertEqual(gates['encrypted_query_driver']['allowed_values'],['true']);self.assertEqual(gates['database_mode']['allowed_values'],['encrypted_only'])
            self.assertEqual(case.setup_sqls,[]);self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_driver_or_manager_claim(self):
        self.cases();feature={f.id:f for f in self.r.matrices['matrix_create_column_encryption_key_coverage'].documented_features}['create_column_encryption_key_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['create_column_encryption_key_key_name_fresh','create_column_encryption_key_cmk_name_fresh','create_column_encryption_key_encrypted_value_none',*['create_column_encryption_key_algorithm_'+x for x in ['aead_aes_256_cbc_hmac_sha256','aead_aes_128_cbc_hmac_sha256','aead_aes_256_ctr_hmac_sha256','aes_256_gcm','sm4_hmac_sm3','sm4_ctr_hmac_sm3','sm4_sm3']]])
        audit=FactorCoverageAuditor(self.r).audit('create_column_encryption_key');self.assertFalse(audit['conclusions']['behavior_coverage_complete']);self.assertTrue(audit['conclusions']['static_coverage_complete'])
        for feature_id in ('create_column_encryption_key_feature_driver','create_column_encryption_key_feature_manager','create_column_encryption_key_feature_length'):self.assertNotIn(feature_id,audit['documented_features']['coverage_gaps'])


if __name__=='__main__':unittest.main()
