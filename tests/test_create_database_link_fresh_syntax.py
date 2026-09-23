"""CREATE DATABASE LINK uses secret-free static syntax representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_create_database_link_fresh_syntax'
EXPECTED={
    "CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER USING (host 'gaussdb-static-syntax.invalid');",
    "CREATE PUBLIC DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER USING (host 'gaussdb-static-syntax.invalid');",
    "CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER OCI USING (dbserver 'oracle-static-syntax.invalid');",
    "CREATE PUBLIC DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER OCI USING (dbserver 'oracle-static-syntax.invalid');",
}


class CreateDatabaseLinkFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_four_backend_and_visibility_syntax_candidates_are_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED)
        self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_no_secret_remote_ip_or_connection_fixture_is_attached(self):
        cases,_=self.cases()
        for case in cases:
            self.assertEqual(case.setup_sqls,[])
            self.assertEqual(case.teardown_sqls,[])
            self.assertNotIn('IDENTIFIED BY',case.sql)
            self.assertNotIn('PASSWORD',case.sql)
            self.assertNotIn('api_key',case.sql)
            self.assertIn('.invalid',case.sql)
        gates={gate['key']:gate for case in cases for gate in case.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['A'])
        self.assertEqual(gates['actor_identity']['allowed_values'],['non_initial'])

    def test_backend_mismatch_negative_targets_documented_rule(self):
        mid='manifest_create_database_link_backend_mismatch_negative'
        self.assertIn(mid,self.r.manifests)
        cases,report=self.g.generate_with_report(self.r.manifests[mid])
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        case=cases[0]
        self.assertEqual(case.sql,
                         "CREATE DATABASE LINK g_create_database_link CONNECT TO CURRENT_USER OCI USING (host 'gaussdb-static-syntax.invalid');")
        self.assertEqual(case.expected,'error')
        self.assertEqual(case.expected_scope,'syntax_and_semantics')
        self.assertEqual(case.expected_error_category,'backend_option_mismatch')

    def test_syntax_feature_is_covered_without_runtime_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_create_database_link_coverage'].documented_features}
        feature=features['create_database_link_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','representative'))
        audit=FactorCoverageAuditor(self.r).audit('create_database_link')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertIn('create_database_link_feature_runtime',
                      audit['documented_features']['needs_profile'])
        self.assertIn('create_database_link_feature_syntax_conflict',
                      audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
