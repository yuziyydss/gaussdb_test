"""Finite SET user-variable assignments are a separate AST branch, not TimeZone."""
import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from scripts.build_m_compat_batch_03 import set_command


class MSetVariableDefinitionTests(unittest.TestCase):
    def test_assignment_is_an_independent_branch_with_real_limited_values(self):
        p=set_command();files=p.finish()
        self.assertEqual(p.ast['kind'],'choice')
        self.assertEqual(p.ast['selector'],'form')
        self.assertEqual(set(p.ast['branches']),{'m_set_form_timezone','m_set_form_user_variable','m_set_form_user_variable_list','m_set_form_user_variable_chain','m_set_form_user_variable_subquery',
                                               'm_set_form_schema_to','m_set_form_schema_equals','m_set_form_schema_string'})
        self.assertEqual({v['render'] for c in p.dims['assignment_operator']['classes'] for v in c['values']},{':=','='})
        self.assertEqual({v['render'] for c in p.dims['variable_value']['classes'] for v in c['values']},{"'factor value'",'NULL','7','-7'})
        self.assertIn(p.fid('user_variable'),files['m_set.syntax.yaml']['source_fact_refs'])
        matrix=files['matrices/user_variable_coverage.matrix.yaml']
        self.assertEqual(matrix['documented_features'][0]['coverage_mode'],'any')
        self.assertTrue(all(f['status']=='covered' for f in matrix['documented_features']))


class MSetVariableIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_all_four_assignments_use_isolated_session_without_timezone_fixture(self):
        m=self.r.manifests['manifest_m_set_user_variable']
        cases,report=self.g.generate_with_report(m)
        expected={f'SET @m_set_value {op} {value};' for op in (':=','=') for value in ("'factor value'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected);self.assertEqual(len(cases),4)
        self.assertTrue(report.pairwise_complete)
        for c in cases:
            self.assertEqual(c.setup_sqls,["SET @m_set_value := 'initial value';"])
            self.assertEqual(c.teardown_sqls,['SET @m_set_value := NULL;'])
            self.assertEqual(c.expected_scope,'syntax_only')
            gates={g['key']:g['allowed_values'] for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode'],['M'])
            self.assertEqual(gates['session_lifecycle'],['isolated_connection'])
            self.assertIn('close_case_connection',gates['variable_lifecycle'])
            self.assertEqual(set(c.consumed_dimension_ids),{'form','assignment_operator','variable_value'})

    def test_old_timezone_and_prepare_fixture_sql_are_unchanged(self):
        old=self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_set_timezone'])
        self.assertEqual(len(old),9)
        expected={'SET '+(scope+' ' if scope else '')+'TIME ZONE '+zone+';'
                  for scope in ('','SESSION','LOCAL') for zone in ("'PRC'",'LOCAL','DEFAULT')}
        self.assertEqual({c.sql for c in old},expected)
        for c in old:
            self.assertEqual(c.setup_sqls,['START TRANSACTION;'])
            self.assertEqual(c.teardown_sqls,['ROLLBACK;'])
        fx=self.r.fixtures['fixture_m_set_prepare_string']
        self.assertEqual(fx.execution.setup_sqls,["SET @m_prepare_sql := 'SELECT 1';"])
        self.assertEqual(fx.execution.teardown_sqls,['SET @m_prepare_sql := NULL;'])

    def test_type_domain_and_actual_behavior_remain_open(self):
        self.assertTrue('manifest_m_set_user_variable' in self.r.manifests)
        fact=next(f for f in self.r.factors['m_set'].facts if f.id=='m_set_fact_user_variable_profile_gap')
        self.assertEqual(fact.status,'confirmed')
        scenario=self.r.scenarios['scenario_m_set_user_variable_values']
        self.assertEqual(scenario.status,'planned')
        self.assertIn('close_case_connection',scenario.execution_requirements)
        self.assertEqual([o['expected'] for o in scenario.oracles],[[['factor value']],[[None]]])
        audit=FactorCoverageAuditor(self.r).audit('m_set')
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__=='__main__':unittest.main()
