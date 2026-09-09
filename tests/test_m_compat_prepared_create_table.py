"""A CREATE TABLE body is prepared, not prematurely executed in setup."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_03 import prepare
from scripts.build_m_compat_batch_02 import namespace_create

NS='m_prepare_ct_namespace'
TABLE=NS+'.created_table'
SQL="PREPARE m_prepare_stmt FROM 'CREATE TABLE "+TABLE+" (id INTEGER, qty INTEGER)';"
MID='manifest_m_prepare_create_table'

class PreparedCreateTableTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.r.load_all()

    def test_profile_requires_actual_cross_chapter_authority(self):
        p=prepare();matrix=p.files['matrices/body.matrix.yaml']
        profiles={x['id']:x for x in matrix['profiles']}
        self.assertTrue('m_prepare_body_create_table' in profiles)
        self.assertIn('m_create_table::m_create_table_fact_authority',profiles['m_prepare_body_create_table']['fact_refs'])
        self.assertIn('m_create_table::m_create_table_fact_syntax',profiles['m_prepare_body_create_table']['fact_refs'])
        self.assertIn('m_create_schema_fact_authority',namespace_create('CREATE SCHEMA').exports)
        self.assertIn('m_create_schema_fact_namespace',namespace_create('CREATE SCHEMA').exports)

    def test_setup_owns_namespace_not_target_table(self):
        self.assertTrue(MID in self.r.manifests,MID)
        cases,report=FactorPackageSQLGenerator(self.r).generate_with_report(self.r.manifests[MID])
        self.assertTrue(report.pairwise_complete);self.assertEqual(len(cases),1)
        c=cases[0]
        self.assertEqual(c.sql,SQL)
        self.assertEqual(c.setup_sqls,['CREATE SCHEMA '+NS+';'])
        self.assertEqual(c.teardown_sqls,['DEALLOCATE PREPARE m_prepare_stmt;','DROP SCHEMA '+NS+';'])
        self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
        gates={g['key']:g for g in c.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['M'])
        self.assertIn('m_create_schema::m_create_schema_fact_authority',gates['namespace_authority']['fact_refs'])
        self.assertIn('m_create_table::m_create_table_fact_authority',gates['ddl_authority']['fact_refs'])
        self.assertEqual(gates['session_lifecycle']['allowed_values'],['isolated_connection'])

    def test_phase_scenario_does_not_claim_table_exists_after_prepare(self):
        sid='scenario_m_prepare_create_table_phase'
        self.assertTrue(sid in self.r.scenarios,sid)
        s=self.r.scenarios[sid]
        self.assertEqual(s.status,'planned')
        steps={x['id']:x for x in s.steps}
        self.assertEqual(steps['prepare']['sql'],SQL)
        self.assertEqual(steps['execute']['sql'],'EXECUTE m_prepare_stmt;')
        self.assertEqual(steps['drop_target']['sql'],'DROP TABLE '+TABLE+';')
        self.assertEqual(steps['seed']['sql'],'INSERT INTO '+TABLE+' VALUES (1,10),(2,20);')
        self.assertTrue(any(o.get('step_id')=='read_rows' and o.get('expected')==[[1,10],[2,20]] for o in s.oracles))
        self.assertIn('ownership_scoped_cleanup',s.execution_requirements)
        self.assertIn('m_create_schema',self.r.factor_dependency_graph()['m_prepare'])

    def test_only_one_body_representative_not_entire_create_table_family(self):
        features=prepare().files['matrices/body.matrix.yaml']['documented_features']
        f=next(x for x in features if x['id']=='m_prepare_feature_body_create_table')
        self.assertEqual(f['status'],'covered')
        self.assertEqual(f['coverage_mode'],'representative')
        self.assertEqual(f['profile_refs'],['m_prepare_body_create_table'])
        self.assertEqual(sum(x['status']=='needs_profile' for x in features),7)
