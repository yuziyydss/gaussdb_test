"""COMMENT ON OPERATOR CLASS/FAMILY uses one transactional btree lifecycle."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_operator_class_family'
NS='g_comment_opclass_ns'
NAME=f'{NS}.g_comment_opclass'


class CommentOperatorClassFamilyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_class_and_family_targets_cross_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),8);self.assertTrue(report.pairwise_complete)
        expected={f'COMMENT ON {kind} {NAME} USING btree IS {text};'
                  for kind in ('OPERATOR CLASS','OPERATOR FAMILY')
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only'
                            for c in cases))

    def test_real_class_lifecycle_creates_auto_family_and_rolls_back(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                'BEGIN;',
                f'CREATE SCHEMA {NS};',
                f'CREATE FUNCTION {NS}.compare_integer(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL IMMUTABLE AS \'SELECT CASE WHEN $1 = $2 THEN 0 WHEN $1 < $2 THEN -1 ELSE 1 END;\';',
                f'CREATE OPERATOR CLASS {NAME} FOR TYPE INTEGER USING btree AS FUNCTION 1 {NS}.compare_integer(INTEGER, INTEGER);',
            ])
            self.assertEqual(c.teardown_sqls,['ROLLBACK;'])
            self.assertFalse(any('DROP OPERATOR' in x or 'CASCADE' in x or 'DROP OWNED' in x
                                  for x in c.setup_sqls+c.teardown_sqls))
        fixture=self.r.fixtures['fixture_comment_operator_class_family']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('事务内','同名操作符族','索引比较契约','ROLLBACK','非默认'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_scenario_and_cross_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['internal_operator_class_test']['allowed_values'],['true'])
        self.assertIn('create_operator_class::create_operator_class_fact_internal',
                      gates['internal_operator_class_test']['fact_refs'])
        self.assertEqual(gates['operator_class_create_privilege']['allowed_values'],['sysadmin'])
        self.assertIn('create_operator_class::create_operator_class_fact_privilege',
                      gates['operator_class_create_privilege']['fact_refs'])
        self.assertEqual(gates['comment_authority']['allowed_values'],['sysadmin'])
        self.assertIn('comment_fact_authority',gates['comment_authority']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertIn('create_operator_class',graph['comment'])
        self.assertIn('create_function',graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_operator_class','create_function')))
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        for feature_id,value_ref in (
            ('comment_feature_object_operator_class','comment_target_operator_class_fresh'),
            ('comment_feature_object_operator_family','comment_target_operator_family_fresh'),
        ):
            feature=fs[feature_id]
            self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
            self.assertEqual(feature.value_refs,[value_ref])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_operator_class_family']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual([s['id'] for s in scenario.steps],
                         ['comment_operator_class','comment_operator_family'])
        self.assertEqual(len(scenario.oracles),2)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)


if __name__=='__main__':unittest.main()
