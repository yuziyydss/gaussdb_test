"""COMMENT ON FOREIGN DATA WRAPPER uses a real owned wrapper."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_fdw'
TARGET='FOREIGN DATA WRAPPER g_comment_fdw'


class CommentFDWTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_wrapper_target_crosses_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        expected={f'COMMENT ON {TARGET} IS {text};'
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only'
                            for c in cases))

    def test_real_wrapper_lifecycle_and_owned_cleanup(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                'CREATE FOREIGN DATA WRAPPER g_comment_fdw NO HANDLER NO VALIDATOR;',
            ])
            self.assertEqual(c.teardown_sqls,[
                'DROP FOREIGN DATA WRAPPER g_comment_fdw RESTRICT;',
            ])
            self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x
                                 for x in c.setup_sqls+c.teardown_sqls))
        fixture=self.r.fixtures['fixture_comment_fdw']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('独占','本case','setup失败','不访问外部数据'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_scenario_and_cross_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['fdw_create_privilege']['allowed_values'],['true'])
        self.assertIn('create_foreign_data_wrapper::create_foreign_data_wrapper_fact_privilege',
                      gates['fdw_create_privilege']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertIn('create_foreign_data_wrapper',graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_foreign_data_wrapper',)))
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        feature=fs['comment_feature_object_foreign_data_wrapper']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['comment_target_fdw_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_fdw']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual(len(scenario.steps),1)
        self.assertEqual(len(scenario.oracles),1)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)


if __name__=='__main__':unittest.main()
