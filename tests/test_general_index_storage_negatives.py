"""Inverted-index storage negatives are archived; positive fixtures stay isolated."""
from pathlib import Path
import unittest

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_model import FactorPackageRegistry

ROOT=Path(__file__).resolve().parents[1]


class GeneralIndexStorageNegativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()

    def test_archived_negatives_are_not_active(self):
        for suffix in ('ugin_fastupdate_negative','gin_pending_negative'):
            mid='manifest_create_index_'+suffix
            self.assertNotIn(mid,self.r.manifests)
            self.assertNotIn(mid,self.r.factors['create_index'].manifest_refs)
            path=ROOT/'archive/spec_reviews/20260923/generated_sql/create_index'/f'{mid}.sql'
            self.assertTrue(path.is_file(),mid)
            self.assertIn('CREATE INDEX',path.read_text())

    def test_static_closure_does_not_claim_behavior(self):
        audit=FactorCoverageAuditor(self.r).audit('create_index')
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(audit['manifests']['unresolved_error_oracles'],[])

    def test_fresh_profiles_have_exact_nullable_array_columns_without_old_fixture_reuse(self):
        for suffix,table,column,datatype,engine in [
            ('ugin_storage','g_ci_ugin_storage','tags','BOOL[]','ustore'),
            ('gin_storage','g_ci_gin_storage','info','INT[]','astore')]:
            with self.subTest(suffix=suffix):
                fid='fixture_create_index_'+suffix
                self.assertIn(fid,self.r.fixtures)
                fx=self.r.fixtures[fid]
                self.assertEqual(fx.requires_fixture_refs,[])
                self.assertEqual(fx.execution.setup_sqls,[f'CREATE TABLE {table} ({column} {datatype}) WITH (storage_type={engine});'])
                self.assertEqual(len(fx.provides.tables),1)
                columns=fx.provides.tables[0].columns
                self.assertEqual(len(columns),1)
                self.assertEqual((columns[0].name,columns[0].type,columns[0].nullable),(column,datatype,True))


if __name__=='__main__':
    unittest.main()
