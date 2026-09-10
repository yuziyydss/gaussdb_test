"""A two-variable assignment chain is not a comma list or repeated equals."""
from pathlib import Path
import unittest
from scripts.build_m_compat_batch_03 import set_command
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator


class MSetChainDefinitionTests(unittest.TestCase):
    def test_new_branch_reuses_dimensions_and_has_its_own_constraint(self):
        p=set_command()
        self.assertTrue('m_set_form_user_variable_chain' in p.ast['branches'])
        self.assertEqual(set(p.dims),{'scope','timezone','form','assignment_operator','variable_value'})
        self.assertTrue('manifests/user_variable_chain.manifest.yaml' in p.files)


class MSetChainIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root=Path(__file__).resolve().parents[1]
        cls.r=FactorPackageRegistry(cls.root/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        mid='manifest_m_set_user_variable_chain'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_first_operator_varies_but_second_is_always_colon_assignment(self):
        cases,report=self.cases()
        self.assertEqual({c.sql for c in cases},{f'SET @m_set_chain_left {op} @m_set_chain_right := {v};'
            for op in (':=','=') for v in ("'factor value'",'NULL')})
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        for c in cases:
            gates={g['key']:g['allowed_values'] for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode'],['M'])
            self.assertEqual(gates['variable_lifecycle'],['close_case_connection'])
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))

    def test_both_variables_are_initialized_and_cleared_without_rollback(self):
        for c in self.cases()[0]:
            self.assertEqual(c.setup_sqls,["SET @m_set_chain_left := 'initial left';","SET @m_set_chain_right := 'initial right';"])
            self.assertEqual(c.teardown_sqls,['SET @m_set_chain_left := NULL;','SET @m_set_chain_right := NULL;'])

    def test_both_readback_values_match_in_planned_not_executed_scenario(self):
        self.cases()
        s=self.r.scenarios['scenario_m_set_user_variable_chain_values']
        self.assertEqual(s.status,'planned')
        self.assertEqual([o['expected'] for o in s.oracles],[[['factor value','factor value']],[[None,None]]])
        self.assertTrue(all(o['sql']=='SELECT @m_set_chain_left,@m_set_chain_right;' for o in s.oracles))
        self.assertIn('target_oracle_calibration',s.execution_requirements)
        self.assertIn('close_case_connection',s.execution_requirements)

    def test_source_constraint_and_remaining_domain_are_not_hidden(self):
        self.cases()
        fact=next(f for f in self.r.factors['m_set'].facts if f.id=='m_set_fact_user_variable_chain')
        self.assertEqual(fact.type,'constraint')
        self.assertEqual(fact.source_anchor,'2.4.2.16.4 L102-105')
        ledger=self.r.source_ledgers[self.r.factors['m_set'].source_ledger_ref]
        unit=next(u for u in ledger.units if fact.id in u.fact_refs)
        self.assertEqual((unit.line_start,unit.line_end),(102,105))
        features={f.id:f for f in self.r.matrices['matrix_m_set_user_variable_coverage'].documented_features}
        self.assertEqual(features['m_set_feature_user_variable_chain'].coverage_mode,'representative')
        self.assertEqual(features['m_set_feature_user_variable_extended_domain'].status,'needs_profile')


if __name__=='__main__':unittest.main()
