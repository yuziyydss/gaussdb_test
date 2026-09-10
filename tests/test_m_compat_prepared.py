import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MPreparedTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,fid):
        return [c for mid in self.r.factors[fid].manifest_refs
                for c in self.g.generate_cases_for_manifest(self.r.manifests[mid])]

    def test_prepare_uses_literal_from_and_real_source_contract(self):
        cases=self.cases('m_prepare')
        self.assertEqual(len(cases),17)
        for c in cases:
            self.assertTrue(c.sql.startswith("PREPARE m_prepare_stmt FROM '"))
            self.assertTrue(c.sql.endswith("';"))
            if c.params['body']=='m_prepare_body_set_timezone':
                self.assertEqual(c.setup_sqls,['START TRANSACTION;','SHOW TimeZone;'])
                self.assertEqual(c.teardown_sqls,['DEALLOCATE PREPARE m_prepare_stmt;','ROLLBACK;'])
            elif c.params['body']=='m_prepare_body_commit':
                self.assertEqual(c.setup_sqls,['CREATE TABLE m_commit_data (id INT);',
                    'INSERT INTO m_commit_data VALUES (0);','BEGIN;','INSERT INTO m_commit_data VALUES (1);',
                    'SELECT COUNT(*) FROM m_commit_data;'])
                self.assertEqual(c.teardown_sqls,['DEALLOCATE PREPARE m_prepare_stmt;','ROLLBACK;','DROP TABLE m_commit_data;'])
            elif c.params['body']=='m_prepare_body_create_table':
                self.assertEqual(c.setup_sqls,['CREATE SCHEMA m_prepare_ct_namespace;'])
                self.assertEqual(c.teardown_sqls,['DEALLOCATE PREPARE m_prepare_stmt;','DROP SCHEMA m_prepare_ct_namespace;'])
            elif c.params['body']=='m_prepare_body_create_namespace':
                self.assertEqual(c.setup_sqls,['SHOW search_path;'])
                self.assertEqual(c.teardown_sqls,['DEALLOCATE PREPARE m_prepare_stmt;'])
            elif c.params['body']=='m_prepare_body_drop_namespace':
                self.assertEqual(c.setup_sqls,['SHOW search_path;','CREATE SCHEMA m_prepare_drop_namespace;'])
                self.assertEqual(c.teardown_sqls,['DEALLOCATE PREPARE m_prepare_stmt;',
                    'DROP SCHEMA IF EXISTS m_prepare_drop_namespace;'])
            elif c.params['body'].startswith('m_prepare_body_drop_'):
                kind=c.params['body'].removeprefix('m_prepare_body_drop_')
                self.assertIn(kind,('table','view','index'))
                ns='m_prepare_drop_'+kind+'_ns'
                self.assertEqual(c.setup_sqls[0],'CREATE SCHEMA '+ns+';')
                self.assertEqual(c.setup_sqls[1],'CREATE TABLE '+ns+'.base_table (id INTEGER, qty INTEGER);')
                self.assertEqual(c.teardown_sqls[-1],'DROP SCHEMA '+ns+';')
            else:
                self.assertTrue(any(s.startswith('CREATE TABLE m_prepare_data ') for s in c.setup_sqls))
            self.assertNotIn('PREPARE m_prepare_stmt', '\n'.join(c.setup_sqls))
            self.assertEqual(c.teardown_sqls[0],'DEALLOCATE PREPARE m_prepare_stmt;')

    def test_execute_name_resolves_in_same_session_fixture(self):
        cases=self.cases('m_execute')
        self.assertEqual(len(cases),2)
        for c in cases:
            name=c.sql.removeprefix('EXECUTE ').rstrip(';')
            self.assertTrue(any(s.startswith('PREPARE '+name+' FROM ') for s in c.setup_sqls))
            self.assertTrue(any(r['key']=='session_lifecycle' and r['allowed_values']==['isolated_connection']
                                for r in c.environment_requirements))
            self.assertNotIn(' USING ',c.sql)

    def test_drop_target_is_not_deallocated_twice(self):
        for fid in ('m_deallocate','m_drop_prepare'):
            cases=self.cases(fid)
            self.assertEqual(len(cases),2)
            self.assertEqual({c.sql.split(' ')[0] for c in cases},{'DROP','DEALLOCATE'})
            for c in cases:
                self.assertEqual(sum(s.startswith('PREPARE ') for s in c.setup_sqls),1)
                self.assertFalse(any('PREPARE' in s for s in c.teardown_sqls))
                self.assertTrue(any(r['key']=='session_lifecycle' for r in c.environment_requirements))
            f=self.r.fixtures['fixture_'+fid+'_one_prepared']
            self.assertIn('关闭此 case 独占会话',f.execution.note)


if __name__=='__main__':unittest.main()
