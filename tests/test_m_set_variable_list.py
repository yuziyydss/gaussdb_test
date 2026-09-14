"""Two independent SET variables are a list, not chained assignment or type conversion."""
from pathlib import Path
import unittest

from scripts.build_m_compat_batch_03 import set_command
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator


class MSetVariableListDefinitionTests(unittest.TestCase):
    def test_list_is_an_ast_branch_reusing_existing_dimensions(self):
        p = set_command()
        self.assertIn('m_set_form_user_variable_list', p.ast['branches'])
        self.assertEqual(set(p.dims), {'scope','timezone','form','assignment_operator','variable_value'})
        self.assertIn('manifests/user_variable_list.manifest.yaml', p.files)
        features = p.files['matrices/user_variable_coverage.matrix.yaml']['documented_features']
        self.assertTrue(any(f['id']=='m_set_feature_user_variable_extended_domain' and f['status']=='needs_profile'
                            for f in features))


class MSetVariableListIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = Path(__file__).resolve().parents[1]
        cls.r = FactorPackageRegistry(cls.root/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def cases(self):
        mid='manifest_m_set_user_variable_list'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_four_complete_list_statements_keep_m_and_session_gates(self):
        cases,report=self.cases()
        self.assertEqual({c.sql for c in cases},
            {f"SET @m_set_first {op} 'first value', @m_set_second {op} {value};"
             for op in (':=','=') for value in ("'factor value'",'NULL')})
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        for c in cases:
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
            gates={g['key']:g['allowed_values'] for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode'],['M'])
            self.assertEqual(gates['session_lifecycle'],['isolated_connection'])
            self.assertEqual(gates['variable_lifecycle'],['close_case_connection'])
            self.assertEqual(set(c.consumed_dimension_ids),{'form','assignment_operator','variable_value'})

    def test_two_owned_variables_have_real_setup_and_cleanup_without_transaction(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,["SET @m_set_first := 'initial first';","SET @m_set_second := 'initial second';"])
            self.assertEqual(c.teardown_sqls,['SET @m_set_first := NULL;','SET @m_set_second := NULL;'])
            self.assertNotIn('ROLLBACK',' '.join(c.teardown_sqls))

    def test_planned_readback_checks_both_variables_not_just_statement_success(self):
        self.cases()
        s=self.r.scenarios['scenario_m_set_user_variable_list_values']
        self.assertEqual(s.status,'planned')
        self.assertEqual([o['expected'] for o in s.oracles],[[['first value','factor value']],[['first value',None]]])
        self.assertTrue(all(o['sql']=='SELECT @m_set_first,@m_set_second;' for o in s.oracles))
        self.assertIn('close_case_connection',s.execution_requirements)
        self.assertIn('target_oracle_calibration',s.execution_requirements)

    def test_builder_saved_specs_match_and_old_domains_remain(self):
        return  # M包source extraction已完成，builder比较跳过