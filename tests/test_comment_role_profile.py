"""COMMENT ON ROLE uses a dedicated NOLOGIN/DISABLE role, not global state proof."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_role'
ROLE='g_comment_role'

class CommentRoleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_role_target_crosses_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        expected={f"COMMENT ON ROLE {ROLE} IS {text};"
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only'
                            for c in cases))

    def test_real_role_lifecycle_is_nonlogin_disabled_and_owned_cleanup(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                f'CREATE ROLE {ROLE} NOLOGIN PASSWORD DISABLE;',
            ])
            self.assertEqual(c.teardown_sqls,[
                f'DROP ROLE {ROLE};',
            ])
            self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x
                                 for x in c.setup_sqls+c.teardown_sqls))
            self.assertFalse(any("PASSWORD '" in x or 'IDENTIFIED BY' in x
                                 for x in c.setup_sqls+c.teardown_sqls))
        fixture=self.r.fixtures['fixture_comment_role']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('独占','NOLOGIN','PASSWORD DISABLE','本case','setup失败'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_scenario_and_cross_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['role_create_privilege']['allowed_values'],['true'])
        self.assertIn('create_role::create_role_fact_privilege',
                      gates['role_create_privilege']['fact_refs'])
        self.assertEqual(gates['password_disable_admin']['allowed_values'],['true'])
        self.assertIn('create_role::create_role_fact_disable_admin',
                      gates['password_disable_admin']['fact_refs'])
        self.assertEqual(gates['separation_of_duty']['allowed_values'],['off'])
        self.assertIn('create_role::create_role_fact_sysadmin_duty_off',
                      gates['separation_of_duty']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertIn('create_role',graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_role',)))
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        feature=fs['comment_feature_object_role']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','representative'))
        self.assertEqual(feature.value_refs,['comment_target_role_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_role']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual(len(scenario.steps),1)
        self.assertEqual(len(scenario.oracles),1)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)


if __name__=='__main__':unittest.main()
