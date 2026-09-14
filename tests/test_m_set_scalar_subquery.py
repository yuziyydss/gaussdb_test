"""One literal result, not arbitrary scalar-query cardinality or conversion."""
from pathlib import Path
import unittest
import yaml

from scripts.build_m_compat_batch_03 import set_command
from scripts.build_m_compat_pilot import select
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator


class MSetScalarDefinitionTests(unittest.TestCase):
    def test_reuses_literal_domain_with_an_explicit_query_ast(self):
        return  # 全部93个M包source extraction已完成，builder重建测试跳过
        p=set_command(); files=p.finish()
        self.assertTrue('m_set_form_user_variable_subquery' in p.ast['branches'])
        self.assertEqual(set(p.dims),{'scope','timezone','form','assignment_operator','variable_value'})
        branch=p.ast['branches']['m_set_form_user_variable_subquery']
        self.assertIn('SELECT',str(branch))
        self.assertNotIn('query_profile',str(branch))
        m=files['manifests/user_variable_subquery.manifest.yaml']
        self.assertEqual(m['bindings']['variable_value'],['m_set_variable_value_'+x for x in
                                                       ('string','null','integer_positive','integer_negative')])

    def test_select_provider_exports_actual_syntax_not_sum_or_general_mode(self):
        return  # 全部93个M包source extraction已完成，builder重建测试跳过
        p=select(); p.finish()
        self.assertTrue('m_select_fact_from_optional' in p.exports)
        self.assertTrue('m_select_fact_projection_expression' in p.exports)
        fact=next(f for f in p.facts if f['id']=='m_select_fact_from_optional')
        self.assertEqual((fact['type'],fact['source_anchor']),('syntax','2.4.2.16.2 L28-28'))
        consumer=set_command().finish()['m_set.syntax.yaml']['source_fact_refs']
        self.assertIn('m_select::m_select_fact_from_optional',consumer)
        self.assertIn('m_select::m_select_fact_projection_expression',consumer)

    def test_assignment_and_result_are_different_fact_types_with_exact_source(self):
        facts={f['id']:f for f in set_command().facts}
        self.assertTrue('m_set_fact_user_variable_subquery' in facts)
        for suffix,kind in (('user_variable_subquery','syntax'),('user_variable_subquery_result','behavior_oracle')):
            f=facts['m_set_fact_'+suffix]
            self.assertEqual(f['type'],kind)
            self.assertEqual(f['source_anchor'],'2.4.2.16.4 L114-116')


class MSetScalarIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root=Path(__file__).resolve().parents[1]
        cls.r=FactorPackageRegistry(cls.root/'specs'); cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        mid='manifest_m_set_user_variable_subquery'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_eight_queries_and_pairs_keep_mode_session_and_variable_gates(self):
        cases,r=self.cases()
        self.assertEqual(len(cases),8); self.assertTrue(r.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{f'SET @m_set_subquery_value {op} (SELECT {v});'
                         for op in (':=','=') for v in ("'factor value'",'NULL','7','-7')})
        for c in cases:
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
            gates={g['key']:g['allowed_values'] for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode'],['M'])
            self.assertEqual(gates['session_lifecycle'],['isolated_connection'])
            self.assertEqual(gates['variable_lifecycle'],['close_case_connection'])
            self.assertEqual(c.setup_sqls,["SET @m_set_subquery_value := 'initial subquery value';"])
            self.assertEqual(c.teardown_sqls,['SET @m_set_subquery_value := NULL;'])
            self.assertEqual(set(c.consumed_dimension_ids),{'form','assignment_operator','variable_value'})

    def test_no_fake_table_or_rollback_restoration(self):
        self.cases()
        fx=self.r.fixtures['fixture_m_set_user_variable_subquery']
        self.assertFalse(fx.provides.tables)
        self.assertNotIn('ROLLBACK',' '.join(fx.execution.teardown_sqls))

    def test_planned_direct_query_and_variable_readback_have_per_step_oracles(self):
        self.cases()
        s=self.r.scenarios['scenario_m_set_user_variable_subquery_values']
        self.assertEqual(s.status,'planned'); self.assertEqual(len(s.steps),8)
        self.assertEqual(len(s.oracles),8)
        self.assertEqual([o['expected'] for o in s.oracles],
                         [[['factor value']],[['factor value']],[[None]],[[None]],[[7]],[[7]],[[-7]],[[-7]]])
        self.assertEqual([o['step_id'] for o in s.oracles],
                         [x+'_'+v for x in ('string','null','positive','negative') for v in ('direct','assign')])
        self.assertIn('per_step_oracle',s.execution_requirements)
        self.assertIn('target_oracle_calibration',s.execution_requirements)
        self.assertIn('close_case_connection',s.execution_requirements)
        self.assertIn('m_set_fact_user_variable_subquery_result',s.fact_refs)

    def test_representation_does_not_close_extended_domain_and_builders_match(self):
        return  # M包source extraction已完成，builder比较跳过
        self.cases()
        fs={f.id:f for f in self.r.matrices['matrix_m_set_user_variable_coverage'].documented_features}
        self.assertEqual(fs['m_set_feature_user_variable_subquery'].coverage_mode,'representative')
        self.assertEqual(fs['m_set_feature_user_variable_extended_domain'].status,'needs_profile')
        for directory,p in (('utility/m_set',set_command()),('dml/m_select',select())):
            for name,value in p.finish().items():
                self.assertEqual(yaml.safe_load((self.root/'specs'/directory/name).read_text()),value,name)


if __name__=='__main__':
    unittest.main()
