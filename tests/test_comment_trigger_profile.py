"""COMMENT ON TRIGGER uses a real owned table/function/trigger lifecycle."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_trigger'
NS='g_comment_trigger_ns'
TABLE=f'{NS}.base_table'
TRIGGER='fp_comment_trigger'


class CommentTriggerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_trigger_target_crosses_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        expected={f"COMMENT ON TRIGGER {TRIGGER} ON {TABLE} IS {text};"
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only' for c in cases))

    def test_real_schema_table_function_trigger_and_reverse_cleanup(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                f'CREATE SCHEMA {NS};',
                f'CREATE TABLE {TABLE} (col_1 INTEGER, col_2 INTEGER) '
                'WITH (storage_type=astore);',
                f'CREATE FUNCTION {NS}.comment_trigger_fn() RETURNS TRIGGER '
                "LANGUAGE plpgsql AS 'BEGIN RETURN NEW; END;';",
                f'CREATE TRIGGER {TRIGGER} BEFORE INSERT ON {TABLE} '
                f'FOR EACH ROW EXECUTE PROCEDURE {NS}.comment_trigger_fn();',
            ])
            self.assertEqual(c.teardown_sqls,[
                f'DROP TRIGGER {TRIGGER} ON {TABLE} RESTRICT;',
                f'DROP FUNCTION {NS}.comment_trigger_fn() RESTRICT;',
                f'DROP TABLE {TABLE} RESTRICT;',
                f'DROP SCHEMA {NS} RESTRICT;',
            ])
            self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x
                                 for x in c.setup_sqls+c.teardown_sqls))
        fixture=self.r.fixtures['fixture_comment_trigger']
        self.assertEqual(fixture.provides.tables[0].table_kind,'regular')
        for phrase in ('非当前模式','本case','setup失败','不执行触发器'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_scenario_and_cross_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['comment_authority']['allowed_values'],['fixture_object_owner'])
        self.assertIn('comment_fact_authority',gates['comment_authority']['fact_refs'])
        self.assertEqual(gates['cleanup_trigger']['allowed_values'],['actual_case_trigger_owner'])
        self.assertIn('drop_trigger::drop_trigger_fact_permission',
                      gates['cleanup_trigger']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertTrue({'create_trigger','create_function','drop_trigger','drop_schema'}<=graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_trigger','create_function','drop_trigger','drop_schema')))
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        feature=fs['comment_feature_object_trigger']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['comment_target_trigger_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_trigger']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual(len(scenario.steps),1)
        self.assertEqual(len(scenario.oracles),1)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)
        self.assertIn('ownership_scoped_cleanup',scenario.execution_requirements)


if __name__=='__main__':unittest.main()
