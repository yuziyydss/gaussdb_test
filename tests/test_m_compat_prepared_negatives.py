"""Concrete, independent negative scenario definitions; no database execution."""
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

from scripts.build_m_compat_batch_03 import prepare, set_command


class PreparedNegativeDefinitionsTests(unittest.TestCase):
    def test_duplicate_has_one_prior_statement_and_one_target(self):
        p = prepare()
        scenario = p.files['scenarios/duplicate_and_variable.scenario.yaml']
        self.assertEqual(scenario['fact_refs'], [p.fid('duplicate'), p.fid('session')])
        self.assertEqual(scenario['steps'], [dict(id='target',
            sql="PREPARE m_prepare_duplicate FROM 'SELECT 2';", expected='error')])
        fixture = p.files['fixtures/duplicate_prepared.fixture.yaml']
        self.assertEqual(fixture['execution']['setup_sqls'],
                         ["PREPARE m_prepare_duplicate FROM 'SELECT 1';"])
        self.assertEqual(fixture['execution']['teardown_sqls'],
                         ['DEALLOCATE PREPARE m_prepare_duplicate;'])
        self.assertNotIn('@', scenario['steps'][0]['sql'])

    def test_variable_precondition_is_owned_by_set_and_never_prepares_target(self):
        p = prepare()
        scenario = p.files['scenarios/variable_from.scenario.yaml']
        self.assertIn('m_set::m_set_fact_user_variable_types', scenario['fact_refs'])
        self.assertEqual(scenario['steps'], [dict(id='target',
            sql='PREPARE m_prepare_variable FROM @m_prepare_sql;', expected='error')])
        wrapper = p.files['fixtures/prepare_string.fixture.yaml']
        self.assertEqual(wrapper['requires_fixture_refs'], ['fixture_m_set_prepare_string'])
        provider = set_command()
        fixture = provider.files['fixtures/prepare_string.fixture.yaml']
        self.assertEqual(fixture['execution']['setup_sqls'], ["SET @m_prepare_sql := 'SELECT 1';"])
        self.assertEqual(fixture['execution']['teardown_sqls'], ['SET @m_prepare_sql := NULL;'])
        self.assertIn('m_set_fact_user_variable_types', provider.exports)
        self.assertIn('关闭', wrapper['execution']['note'])

    def test_negative_oracles_are_target_only_and_uncalibrated(self):
        p = prepare()
        for suffix, category in [('duplicate_and_variable', 'duplicate_prepared_statement'),
                                 ('variable_from', 'prepare_user_variable')]:
            scenario = p.files['scenarios/'+suffix+'.scenario.yaml']
            self.assertEqual(scenario['status'], 'planned')
            self.assertIn('isolated_connection', scenario['execution_requirements'])
            self.assertIn('close_case_connection', scenario['execution_requirements'])
            oracle = scenario['oracles'][0]
            self.assertEqual(oracle['kind'], 'target_error')
            self.assertEqual(oracle['step_id'], 'target')
            self.assertEqual(oracle['stage'], 'target')
            self.assertEqual(oracle['error_category'], category)
            self.assertEqual(oracle['oracle_status'], 'needs_verification')
            self.assertEqual(oracle['sqlstates'], [])

    def test_set_fixture_has_readback_oracle_and_separate_assignment_branch(self):
        p = set_command()
        files = p.finish()
        self.assertIn(p.fid('user_variable'), files['m_set.syntax.yaml']['source_fact_refs'])
        self.assertEqual(p.ast['kind'], 'choice')
        self.assertEqual(p.ast['selector'], 'form')
        self.assertNotIn('@m_set_value', str(p.ast['branches']['m_set_form_timezone']))
        scenario = files['scenarios/prepare_string_value.scenario.yaml']
        self.assertEqual(scenario['status'], 'planned')
        self.assertEqual(scenario['oracles'], [dict(kind='result_set',
            sql='SELECT @m_prepare_sql;', expected=[['SELECT 1']])])


class PreparedNegativeIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def test_real_fixture_dependency_expands_without_unrelated_setup(self):
        refs = self.registry.scenarios['scenario_m_prepare_variable_from'].fixture_refs
        self.assertEqual(self.registry.fixture_topological_order(refs),
                         ['fixture_m_set_prepare_string', 'fixture_m_prepare_prepare_string'])
        setup, teardown = self.generator._compile_fixture_lifecycle(refs)
        self.assertEqual(setup, ["SET @m_prepare_sql := 'SELECT 1';"])
        self.assertEqual(teardown, ['SET @m_prepare_sql := NULL;'])

    def test_graph_orders_set_before_prepare_and_execute(self):
        order = self.registry.factor_topological_order()
        self.assertLess(order.index('m_set'), order.index('m_prepare'))
        self.assertLess(order.index('m_prepare'), order.index('m_execute'))
        fact = self.registry.resolve_fact_ref('m_prepare', 'm_set::m_set_fact_user_variable_types')
        self.assertEqual(fact.type, 'constraint')
        self.assertEqual(fact.source_anchor, '2.4.2.16.4 L97-97')

    def test_duplicate_fixture_does_not_share_variable_setup(self):
        refs = self.registry.scenarios['scenario_m_prepare_duplicate_and_variable'].fixture_refs
        setup, teardown = self.generator._compile_fixture_lifecycle(refs)
        self.assertEqual(setup, ["PREPARE m_prepare_duplicate FROM 'SELECT 1';"])
        self.assertEqual(teardown, ['DEALLOCATE PREPARE m_prepare_duplicate;'])

    def test_auditor_keeps_extended_set_domain_gap_without_wrong_fact_consumers(self):
        from core.factor_coverage_auditor import FactorCoverageAuditor
        auditor = FactorCoverageAuditor(self.registry)
        for fid in ('m_set', 'm_prepare'):
            audit = auditor.audit(fid)
            self.assertEqual(audit['facts']['wrong_consumer_type'], [], fid)
            self.assertTrue(audit['conclusions']['static_coverage_complete'])
        matrix = self.registry.matrices['matrix_m_set_user_variable_coverage']
        self.assertEqual(matrix.profiles, [])
        self.assertTrue(all(f.status == 'covered' for f in matrix.documented_features))
        self.assertTrue(all(f.coverage_mode == 'any' for f in matrix.documented_features))

