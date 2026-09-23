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
        for suffix in ('plain','analyze','options'):
            cases=self.cases('vacuum_'+suffix)
            for c in cases:
                self.assertIn('m_vacuum_source',c.sql)
                self.assertIn('DELETE FROM m_vacuum_source WHERE id = 1;',c.setup_sqls)
                self.assertNotIn('START TRANSACTION;',c.setup_sqls)
                self.assertNotIn('ROLLBACK;',c.teardown_sqls)
                self.assertTrue(any(e['key']=='execution_context' and e['allowed_values']==['top_level_autocommit'] for e in c.environment_requirements))
            if suffix!='plain':self.assertTrue(any('ANALYZE' in c.sql for c in cases))

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

