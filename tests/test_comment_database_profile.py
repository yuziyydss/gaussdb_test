"""COMMENT ON DATABASE uses a fresh isolated database, not an existing shared one."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_database'
DB='g_comment_database'


class CommentDatabaseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_database_target_crosses_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        expected={f'COMMENT ON DATABASE {DB} IS {text};'
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only'
                            for c in cases))

    def test_real_database_lifecycle_is_isolated_and_owned(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[f'CREATE DATABASE {DB};'])
            self.assertEqual(c.teardown_sqls,[f'DROP DATABASE {DB};'])
            self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x
                                 for x in c.setup_sqls+c.teardown_sqls))
            self.assertFalse(any(x in ('postgres','template0','template1','templatea','templatem')
                                 for x in c.setup_sqls+c.teardown_sqls))
        fixture=self.r.fixtures['fixture_comment_database']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('非PDB','独占','本case','setup失败','不验证模板'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_scenario_and_cross_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['database_scope']['allowed_values'],['non_pdb'])
        self.assertIn('comment_fact_pdb',gates['database_scope']['fact_refs'])
        self.assertEqual(gates['database_create_privilege']['allowed_values'],['true'])
        self.assertIn('create_database::create_database_fact_privilege',
                      gates['database_create_privilege']['fact_refs'])
        self.assertEqual(gates['create_database_autocommit']['allowed_values'],['true'])
        self.assertIn('create_database::create_database_fact_no_transaction',
                      gates['create_database_autocommit']['fact_refs'])
        self.assertEqual(gates['drop_database_autocommit']['allowed_values'],['true'])
        self.assertIn('drop_database::drop_database_fact_no_transaction',
                      gates['drop_database_autocommit']['fact_refs'])
        self.assertEqual(gates['database_has_connections']['allowed_values'],['false'])
        self.assertIn('drop_database::drop_database_fact_no_connections',
                      gates['database_has_connections']['fact_refs'])
        self.assertEqual(gates['enable_db_recyclebin']['allowed_values'],['off'])
        self.assertIn('drop_database::drop_database_fact_recyclebin_environment',
                      gates['enable_db_recyclebin']['fact_refs'])
        self.assertEqual(gates['cleanup_database']['allowed_values'],['actual_case_database_owner'])
        self.assertIn('drop_database::drop_database_fact_privilege',
                      gates['cleanup_database']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertIn('create_database',graph['comment'])
        self.assertIn('drop_database',graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_database','drop_database')))
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        feature=fs['comment_feature_object_database']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['comment_target_database_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_database']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual(len(scenario.steps),1)
        self.assertEqual(len(scenario.oracles),1)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)


if __name__=='__main__':unittest.main()
