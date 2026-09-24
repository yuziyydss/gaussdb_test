"""DROP GROUP uses one dedicated NOLOGIN/DISABLE group."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_group_fresh_group'
GROUP='g_drop_group'


class DropGroupFreshGroupTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_if_exists_modifier_crosses_two_candidates(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),2)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{
            f'DROP GROUP {GROUP};',
            f'DROP GROUP IF EXISTS {GROUP};',
        })
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only'
                            for c in cases))

    def test_lifecycle_creates_dedicated_group_and_cleans_by_role(self):
        cases,_=self.cases()
        for case in cases:
            self.assertEqual(case.setup_sqls,
                             [f'CREATE GROUP {GROUP} NOLOGIN PASSWORD DISABLE;'])
            self.assertEqual(case.teardown_sqls,
                             [f'DROP ROLE IF EXISTS {GROUP};'])
            self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x or 'REVOKE OWNED' in x
                                  for x in case.setup_sqls+case.teardown_sqls))
        fixture=self.r.fixtures['fixture_drop_group_fresh_group']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('NOLOGIN','PASSWORD DISABLE','管理工具接口','setup失败','禁止CASCADE'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gates_feature_and_audit_do_not_claim_tool_behavior(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['management_tool_context']['allowed_values'],
                         ['authorized_isolated_tool_session'])
        self.assertIn('drop_group_fact_tool_interface',
                      gates['management_tool_context']['fact_refs'])
        self.assertIn('drop_group_fact_not_recommended',
                      gates['management_tool_context']['fact_refs'])
        self.assertEqual(gates['role_creator_authorized']['allowed_values'],['true'])
        self.assertIn('create_role::create_role_fact_privilege',
                      gates['role_creator_authorized']['fact_refs'])
        self.assertEqual(gates['password_disable_admin']['allowed_values'],['true'])
        self.assertIn('create_role::create_role_fact_disable_admin',
                      gates['password_disable_admin']['fact_refs'])
        self.assertEqual(gates['separation_of_duty']['allowed_values'],['off'])
        self.assertIn('create_role::create_role_fact_sysadmin_duty_off',
                      gates['separation_of_duty']['fact_refs'])
        features={f.id:f for f in self.r.matrices['matrix_drop_group_coverage'].documented_features}
        feature=features['drop_group_feature_legacy_tool_drop']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','all'))
        self.assertEqual(feature.value_refs,[
            'drop_group_if_exists_none',
            'drop_group_if_exists_yes',
            'drop_group_group_names_fresh',
        ])
        audit=FactorCoverageAuditor(self.r).audit('drop_group')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])


if __name__=='__main__':unittest.main()
