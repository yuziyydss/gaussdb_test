from tests.evolved_asset_assertions import assert_evolved_asset
import hashlib
import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry,FactorPackageLoadError
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from core.m_compat_environment import MEnvironment

ROOT=Path(__file__).resolve().parents[1]


class MLoadCleanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_primary_key_metadata_is_not_nullable(self):
        for suffix in ('empty','conflict'):
            fixture=self.r.fixtures['fixture_m_load_data_'+suffix]
            self.assertFalse(fixture.provides.tables[0].columns[0].nullable)
            bad=fixture.model_copy(deep=True);bad.provides.tables[0].columns[0].nullable=True
            self.r.fixtures[fixture.id]=bad
            try:
                with self.assertRaisesRegex(GenerationValidationError,'nullable.*DDL'):self.g._compile_fixture_lifecycle([fixture.id])
            finally:self.r.fixtures[fixture.id]=fixture

    def test_real_tsv_propagates_and_negative_targets_keep_assets(self):
        for mid in self.r.factors['m_load_data'].manifest_refs:
            m=self.r.manifests[mid]
            for c in self.g.generate_cases_for_manifest(m):
                self.assertEqual(len(c.file_assets),1);a=c.file_assets[0]
                data=(ROOT/a['repository_source_path']).read_bytes()
                self.assertEqual(data,b'1\t10\n2\t20\n3\t30\n')
                self.assertEqual(hashlib.sha256(data).hexdigest(),a['sha256'])
                self.assertIn("INFILE '"+a['target_path']+"'",c.sql)
                self.assertFalse(a['deployed']);self.assertIn('file_assets',c.to_dict())
                self.assertIn("LINES TERMINATED BY '\n'",c.sql)
                self.assertNotIn(' LOCAL ',c.sql)
                self.assertTrue(any('qty INTEGER DEFAULT 9' in s for s in c.setup_sqls))
                self.assertFalse(any(s.startswith(('SET ','ALTER SYSTEM','COPY ')) for s in c.setup_sqls))

    def test_missing_payload_blocks_real_package_load(self):
        # Inject a missing path in memory; do not modify the real source asset.
        fixture=self.r.fixtures['fixture_m_load_data_empty'];old=fixture.provides.files[0]
        fixture.provides.files[0]=old.model_copy(update={'source_path':'assets/absent.tsv'})
        try:
            with self.assertRaisesRegex(ValueError,'file asset missing'):self.cases('load_data_empty')
        finally:fixture.provides.files[0]=old

    def test_conflicts_and_column_expression_target_only_one_rule(self):
        for c in self.cases('load_data_conflict'):
            self.assertIn('INSERT INTO m_load_data_conflict VALUES (2,99);',c.setup_sqls)
            self.assertTrue(' REPLACE ' in c.sql or ' IGNORE ' in c.sql)
        for name,rule in [('duplicate_negative','collision_error'),('column_expr_negative','no_column_expr')]:
            m=self.r.manifests['manifest_m_load_data_'+name];cases=self.cases('load_data_'+name)
            self.assertEqual(len(cases),1);self.assertEqual(m.violates_rule_refs,['m_load_data_rule_'+rule])
            self.assertEqual(m.expected.oracle_status,'needs_verification')
        self.assertIn('SET qty = id',self.cases('load_data_column_expr_negative')[0].sql)

    def test_clean_is_explicitly_scoped_without_force_or_fake_database(self):
        cases=self.cases('clean_connection_no_target_sessions');self.assertEqual(len(cases),2)
        for c in cases:
            self.assertIn('FOR DATABASE '+MEnvironment().database+' TO USER m_clean_connection_user',c.sql)
            self.assertNotIn('FORCE',c.sql);self.assertIn('TO ALL',c.sql)
            self.assertFalse(any(s.startswith(('CREATE DATABASE','DROP DATABASE')) for s in c.setup_sqls+c.teardown_sqls))
            self.assertTrue(any('CREATE USER m_clean_connection_user NOLOGIN' in s for s in c.setup_sqls))
            self.assertIn("current_database() = '"+MEnvironment().database+"'",c.setup_sqls[0])
            self.assertEqual(c.teardown_sqls,['DROP SCHEMA m_clean_connection_user;','DROP USER m_clean_connection_user RESTRICT;'])

    def test_reconstruction_and_asset_bytes(self):
        from scripts.build_m_compat_batch_05 import BUILDERS,LOAD_PAYLOAD
        for key in ('load_data','clean_connection'):
            p=BUILDERS[key]()
            for name,obj in p.finish().items():assert_evolved_asset(self, (ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))
        self.assertEqual((ROOT/'specs/utility/m_load_data/fixtures/assets/two_int.tsv').read_bytes(),LOAD_PAYLOAD.encode())
