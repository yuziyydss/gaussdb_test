"""COMMENT ON TABLESPACE uses a dedicated empty RELATIVE tablespace."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_tablespace'
TABLESPACE='g_comment_tbspc'


class CommentTablespaceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_tablespace_target_crosses_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        expected={f'COMMENT ON TABLESPACE {TABLESPACE} IS {text};'
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only'
                            for c in cases))

    def test_real_tablespace_lifecycle_is_empty_and_owned(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                f"CREATE TABLESPACE {TABLESPACE} RELATIVE LOCATION 'g_comment_tbspc';",
            ])
            self.assertEqual(c.teardown_sqls,[f'DROP TABLESPACE {TABLESPACE};'])
            self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x
                                  for x in c.setup_sqls+c.teardown_sqls))
            self.assertFalse(any('MAXSIZE' in x or 'LOCATION' in x.upper() and 'RELATIVE' not in x
                                 for x in c.setup_sqls))
        fixture=self.r.fixtures['fixture_comment_tablespace']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('空','RELATIVE','非事务块','本case','setup失败'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_scenario_and_cross_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['tablespace_create_privilege']['allowed_values'],['true'])
        self.assertIn('create_tablespace::create_tablespace_fact_body_8',
                      gates['tablespace_create_privilege']['fact_refs'])
        self.assertEqual(gates['tablespace_drop_privilege']['allowed_values'],
                         ['actual_case_tablespace_owner'])
        self.assertIn('drop_tablespace::drop_tablespace_fact_body_8',
                      gates['tablespace_drop_privilege']['fact_refs'])
        self.assertEqual(gates['comment_authority']['allowed_values'],['fixture_object_owner'])
        self.assertIn('comment_fact_authority',gates['comment_authority']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertIn('create_tablespace',graph['comment'])
        self.assertIn('drop_tablespace',graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_tablespace','drop_tablespace')))
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        feature=fs['comment_feature_object_tablespace']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['comment_target_tablespace_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_tablespace']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual(len(scenario.steps),1)
        self.assertEqual(len(scenario.oracles),1)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)
        self.assertIn('drop_tablespace::drop_tablespace_fact_body_10',scenario.fact_refs)
        self.assertIn('drop_tablespace::drop_tablespace_fact_body_11',scenario.fact_refs)


if __name__=='__main__':unittest.main()
