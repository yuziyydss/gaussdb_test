"""COMMENT ON CAST uses a real local cast lifecycle; not metadata proof."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_cast'
NS='g_comment_cast_ns'
TARGET='CAST (double precision AS timestamp with time zone)'
FN=f'{NS}.double_to_timestamptz'


class CommentCastTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_cast_target_crosses_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        expected={f'COMMENT ON {TARGET} IS {text};'
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only' for c in cases))

    def test_real_function_cast_and_reverse_owned_cleanup(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                f'CREATE SCHEMA {NS};',
                f'CREATE FUNCTION {FN}(double precision) RETURNS timestamp with time zone '
                "LANGUAGE SQL STRICT AS 'SELECT to_timestamp($1);';",
                f'CREATE CAST (double precision AS timestamp with time zone) '
                f'WITH FUNCTION {FN}(double precision);',
            ])
            self.assertEqual(c.teardown_sqls,[
                'DROP CAST (double precision AS timestamp with time zone) RESTRICT;',
                f'DROP FUNCTION {FN}(double precision);',
                f'DROP SCHEMA {NS} RESTRICT;',
            ])
            self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x
                                 for x in c.setup_sqls+c.teardown_sqls))
        fixture=self.r.fixtures['fixture_comment_cast']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('非当前模式','本case','setup失败','不执行转换'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_scenario_and_cross_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['cast_create_privilege']['allowed_values'],['true'])
        self.assertIn('comment_fact_authority',gates['cast_create_privilege']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertTrue({'create_function','drop_cast','drop_schema'}<=graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_cast','create_function','drop_cast','drop_schema')))
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        feature=fs['comment_feature_object_cast']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','representative'))
        self.assertEqual(feature.value_refs,['comment_target_cast_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_cast']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual(len(scenario.steps),1)
        self.assertEqual(len(scenario.oracles),1)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)
        self.assertIn('ownership_scoped_cleanup',scenario.execution_requirements)


if __name__=='__main__':unittest.main()
