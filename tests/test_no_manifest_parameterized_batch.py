"""Four no-manifest packages get finite syntax-only representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
STATIC_CLOSED={'alter_column_encryption_key','impdp_database_create','impdp_pluggable_database_create','impdp_recover'}

CASES={
    'alter_column_encryption_key': {
        'mid':'manifest_alter_column_encryption_key_fresh_syntax',
        'sqls':['ALTER COLUMN ENCRYPTION KEY g_alter_column_encryption_key WITH VALUES (CLIENT_MASTER_KEY = g_new_client_master_key);'],
        'matrix':'matrix_alter_column_encryption_key_coverage',
        'syntax':'alter_column_encryption_key_feature_syntax',
        'values':['alter_column_encryption_key_key_name_fresh','alter_column_encryption_key_new_cmk_name_fresh'],
        'runtime':'alter_column_encryption_key_feature_rotation',
    },
    'impdp_database_create': {
        'mid':'manifest_impdp_database_create_fresh_syntax',
        'sqls':["IMPDP DATABASE CREATE SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner;",
                "IMPDP DATABASE b8_import_db CREATE SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner LOCAL;",
                "IMPDP DATABASE CREATE SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner LOCAL;",
                "IMPDP DATABASE b8_import_db CREATE SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner;"],
        'matrix':'matrix_impdp_database_create_coverage',
        'syntax':'impdp_database_create_feature_syntax',
        'values':['impdp_database_create_db_name_keep','impdp_database_create_db_name_rename','impdp_database_create_directory_path','impdp_database_create_owner_dedicated','impdp_database_create_local_new_cluster','impdp_database_create_local_same_cluster'],
        'runtime':'impdp_database_create_feature_physical_backup_restore',
    },
    'impdp_pluggable_database_create': {
        'mid':'manifest_impdp_pluggable_database_create_fresh_syntax',
        'sqls':["IMPDP PLUGGABLE DATABASE b8_import_pdb CREATE SOURCE = '/tmp/gaussdb_b8/export_pdb' OWNER = b8_import_owner;"],
        'matrix':'matrix_impdp_pluggable_database_create_coverage',
        'syntax':'impdp_pluggable_database_create_feature_syntax',
        'values':['impdp_pluggable_database_create_pdb_name_dedicated','impdp_pluggable_database_create_directory_dedicated','impdp_pluggable_database_create_owner_dedicated'],
        'runtime':'impdp_pluggable_database_create_feature_pdb_import',
    },
    'impdp_recover': {
        'mid':'manifest_impdp_recover_fresh_syntax',
        'sqls':["IMPDP DATABASE RECOVER SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner;",
                "IMPDP DATABASE RECOVER SOURCE = '/tmp/gaussdb_b8/export_database' OWNER = b8_import_owner LOCAL;"],
        'matrix':'matrix_impdp_recover_coverage',
        'syntax':'impdp_recover_feature_syntax',
        'values':['impdp_recover_directory_path','impdp_recover_owner_dedicated','impdp_recover_local_new_cluster','impdp_recover_local_same_cluster'],
        'runtime':'impdp_recover_feature_physical_backup_restore',
    },
}


class NoManifestParameterizedBatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_each_package_generates_its_finite_syntax_candidates(self):
        for factor,cfg in CASES.items():
            with self.subTest(factor=factor):
                self.assertIn(cfg['mid'],self.r.manifests)
                cases,report=self.g.generate_with_report(self.r.manifests[cfg['mid']])
                self.assertEqual([case.sql for case in cases],cfg['sqls'])
                self.assertEqual(len(cases),len(cfg['sqls']))
                self.assertTrue(report.pairwise_complete)
                self.assertEqual(cases[0].expected,'success')
                self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_no_key_or_backup_fixture_lifecycle_is_attached(self):
        for factor,cfg in CASES.items():
            with self.subTest(factor=factor):
                cases,_=self.g.generate_with_report(self.r.manifests[cfg['mid']])
                case=cases[0]
                self.assertEqual(case.setup_sqls,[])
                self.assertEqual(case.teardown_sqls,[])
                self.assertNotIn('CREATE CLIENT MASTER KEY',case.sql)
                self.assertNotIn('mkdir',case.sql)
                self.assertNotIn('gs_restore',case.sql)

    def test_syntax_feature_is_representative_and_runtime_gap_remains(self):
        for factor,cfg in CASES.items():
            with self.subTest(factor=factor):
                self.g.generate_with_report(self.r.manifests[cfg['mid']])
                features={f.id:f for f in self.r.matrices[cfg['matrix']].documented_features}
                feature=features[cfg['syntax']]
                self.assertEqual(feature.status,'covered')
                self.assertIn(feature.coverage_mode,{'any','representative'})
                self.assertEqual(feature.value_refs,cfg['values'])
                audit=FactorCoverageAuditor(self.r).audit(factor)
                self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
                self.assertEqual(audit['conclusions']['static_coverage_complete'],factor in STATIC_CLOSED)
                if factor in STATIC_CLOSED:
                    self.assertNotIn(cfg['runtime'],audit['documented_features']['needs_profile'])
                else:
                    self.assertIn(cfg['runtime'],audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
