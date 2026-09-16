from tests.evolved_asset_assertions import assert_evolved_asset
import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MMaintenanceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_analyze_only_real_table_and_column_forms(self):
        cases=self.cases('analyze_ordinary');self.assertEqual(len(cases),8)
        for c in cases:
            self.assertIn('m_b01_source',c.sql);self.assertNotIn('VERIFY',c.sql)
            self.assertTrue(any(s.startswith('CREATE TABLE m_b01_source') for s in c.setup_sqls))
        self.assertTrue(any('((id, qty))' in c.sql for c in cases))

    def test_vacuum_dead_rows_autocommit_and_no_whole_database(self):
        for suffix in ('plain','analyze','options','columns_without_analyze'):
            for c in self.cases('vacuum_'+suffix):
                self.assertIn('m_vacuum_source',c.sql)
                self.assertIn('DELETE FROM m_vacuum_source WHERE id = 1;',c.setup_sqls)
                self.assertNotIn('START TRANSACTION;',c.setup_sqls)
                self.assertNotIn('ROLLBACK;',c.teardown_sqls)
                self.assertTrue(any(e['key']=='execution_context' and e['allowed_values']==['top_level_autocommit'] for e in c.environment_requirements))
                if suffix!='columns_without_analyze' and c.params['columns']!='m_vacuum_columns_all':self.assertIn('ANALYZE',c.sql)

    def test_maintenance_negatives_only_invert_target_rules(self):
        samples=[('m_analyze','ordinary','missing_column','columns','missing','column_exists'),
            ('m_lock','finite','unsupported_mode','mode','unsupported','supported_modes'),
            ('m_vacuum','options','columns_without_analyze','columns','id','columns_require_analyze')]
        for fid,ps,ns,dim,value,rule in samples:
            f=self.r.factors[fid];resolved=self.r.resolve_dimension_values(fid)
            combo={k:d.default_value_id for k,d in f.dimensions.items()};combo[dim]=fid+'_'+dim+'_'+value
            if fid=='m_vacuum':combo.update(form='m_vacuum_form_options',options='m_vacuum_options_verbose')
            pos=self.r.manifests['manifest_'+fid+'_'+ps];neg=self.r.manifests['manifest_'+fid+'_'+ns]
            self.assertFalse(self.g._build_solver(f,pos,resolved).is_valid(combo)[0])
            self.assertTrue(self.g._build_solver(f,neg,resolved).is_valid(combo)[0])
            self.assertEqual(neg.expected.oracle_status,'needs_verification')
            self.assertEqual(neg.violates_rule_refs,[fid+'_rule_'+rule])

    def test_lock_transaction_ends_before_object_cleanup(self):
        for suffix in ('finite','unsupported_mode'):
            for c in self.cases('lock_'+suffix):
                self.assertEqual(c.setup_sqls[-1],'START TRANSACTION;')
                self.assertEqual(c.teardown_sqls,['ROLLBACK;','DROP TABLE m_lock_two;','DROP TABLE m_lock_one;'])
                self.assertNotIn('UNLOCK',c.sql)
                if c.params['count']=='m_lock_count_two':self.assertIn('m_lock_two',c.sql)
                self.assertTrue(any(e['key']=='execution_context' and e['allowed_values']==['same_explicit_transaction'] for e in c.environment_requirements))

    def test_reindex_uses_existing_indexes_and_online_gate(self):
        for suffix in ('ordinary','online'):
            for c in self.cases('reindex_'+suffix):
                self.assertTrue(any(s.startswith('CREATE INDEX m_b03_existing_index ') for s in c.setup_sqls))
                self.assertNotRegex(c.sql,r'\b(?:DATABASE|SYSTEM|INTERNAL|PARTITION)\b')
                if suffix=='online':
                    self.assertIn('CONCURRENTLY',c.sql)
                    self.assertTrue(any(e['key']=='index_storage' and e['allowed_values']==['verified_non_pcr_btree_or_ubtree'] for e in c.environment_requirements))
                    self.assertTrue(any(e['key']=='execution_context' and e['allowed_values']==['top_level_autocommit'] for e in c.environment_requirements))

    def test_select_into_one_into_and_actual_projection_types(self):
        vals=self.r.resolve_dimension_values('m_select_into')['projection']
        for c in self.cases('select_into_direct_columns'):
            self.assertEqual(c.sql.count(' INTO '),1)
            self.assertLess(c.sql.index(' INTO '),c.sql.index(' FROM '))
            v=vals[c.params['projection']];props={k.removeprefix('projection.properties.'):value for k,value in v.attributes.items()}
            self.assertEqual(props['output_columns'],props['items'])
            self.assertEqual(props['output_types'],['INTEGER']*len(props['items']))
            self.assertTrue(set(props['source_columns'])<={'id','qty'})
            self.assertEqual(c.teardown_sqls,['DROP TABLE IF EXISTS m_select_into_new;','DROP TABLE m_select_into_source;'])
            self.assertNotRegex(c.sql,r'\b(?:TEMPORARY|GLOBAL|LOCAL)\b')

    def test_source_conflicts_and_reconstruction(self):
        from scripts.build_m_compat_batch_05 import BUILDERS
        for builder in BUILDERS.values():
            p=builder()
            for name,obj in p.finish().items():
                assert_evolved_asset(self, (ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))
        for fid,suffix in [('m_lock','access_share_conflict'),('m_select_into','duplicate_into'),('m_reindex','partition')]:
            self.assertTrue(any(f.id==fid+'_fact_'+suffix and f.status=='needs_verification' for f in self.r.factors[fid].facts))


if __name__=='__main__':unittest.main()
