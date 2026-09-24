"""Four fixed productions get syntax-only representatives without runtime claims."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]

CASES={
    'alter_async_encryption_key_rotation': (
        'manifest_alter_async_encryption_key_rotation_fresh_syntax',
        'ALTER ASYNC ENCRYPTION KEY ROTATION;',
        'alter_async_encryption_key_rotation_feature_rotation',
    ),
    'autohint_purge': (
        'manifest_autohint_purge_fresh_syntax',
        'AUTOHINT PURGE;',
        'autohint_purge_feature_runtime',
    ),
    'generated_update_system_object': (
        'manifest_generated_update_system_object_fresh_syntax',
        'GENERATED UPDATE SYSTEM OBJECT;',
        'generated_update_system_object_feature_internal_upgrade',
    ),
    'impdp_pluggable_database_recover': (
        'manifest_impdp_pluggable_database_recover_fresh_syntax',
        'IMPDP PLUGGABLE DATABASE RECOVER;',
        'impdp_pluggable_database_recover_feature_recovery_pipeline',
    ),
}


class NoManifestStaticSyntaxBatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_each_fixed_command_has_one_syntax_only_candidate(self):
        for factor,(mid,sql,_) in CASES.items():
            with self.subTest(factor=factor):
                self.assertIn(mid,self.r.manifests)
                cases,report=self.g.generate_with_report(self.r.manifests[mid])
                self.assertEqual([case.sql for case in cases],[sql])
                self.assertEqual(len(cases),1)
                self.assertTrue(report.pairwise_complete)
                self.assertEqual(cases[0].expected,'success')
                self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_no_fixture_or_runtime_setup_is_attached(self):
        for factor,(mid,_,_) in CASES.items():
            with self.subTest(factor=factor):
                cases,_=self.g.generate_with_report(self.r.manifests[mid])
                case=cases[0]
                self.assertEqual(case.setup_sqls,[])
                self.assertEqual(case.teardown_sqls,[])
                self.assertNotEqual(case.environment_requirements,[])

    def test_runtime_gap_remains_after_static_closure(self):
        for factor,(mid,_,runtime_feature) in CASES.items():
            with self.subTest(factor=factor):
                self.g.generate_with_report(self.r.manifests[mid])
                audit=FactorCoverageAuditor(self.r).audit(factor)
                self.assertTrue(audit['conclusions']['static_coverage_complete'])
                self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
                self.assertNotIn(runtime_feature,audit['documented_features']['needs_profile'])
                self.assertEqual(audit['documented_features']['coverage_gaps'],[])


if __name__=='__main__':unittest.main()
