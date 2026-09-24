"""Affected rows belongs to the bound target, not a post-query or any error."""
import unittest
from pathlib import Path

from core.execution_preparation import prepare_unit
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator


class AffectedRowsPreparationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.cases = cls.g.generate_with_report(cls.r.manifests['manifest_insert_partial_index_fresh'])[0]

    def prepare(self, oracle=None, scenario_id='scenario_insert_partial_index_conflict'):
        scenario = self.r.scenarios[scenario_id].model_copy(deep=True)
        if oracle is not None:
            scenario.oracles[0] = oracle
        return prepare_unit(scenario, self.cases, self.g)

    def test_three_real_outcomes_bind_target_rowcount_without_runtime_promotion(self):
        for suffix, expected in [('conflict', 0), ('new_key', 1), ('outside', 1)]:
            with self.subTest(suffix=suffix):
                unit = self.prepare(scenario_id='scenario_insert_partial_index_'+suffix)
                self.assertEqual(unit['static_blockers'], [])
                oracle = unit['steps'][0]['oracles'][0]
                self.assertEqual(oracle['expected'], expected)
                self.assertEqual(oracle['measurement_source'], 'target_command_affected_rows')
                self.assertFalse(unit['database_executed'])
                self.assertFalse(unit['execution_authorized'])
                self.assertEqual(unit['source_scenario']['status'], 'planned')

    def test_invalid_counts_and_separate_query_are_blocked_even_if_uncalibrated(self):
        for expected in [-1, True, 1.5, '1', None, [1]]:
            for pending in [False, True]:
                oracle = {'kind': 'affected_rows', 'step_id': 'insert_row', 'expected': expected}
                if pending:
                    oracle['calibration_status'] = 'needs_verification'
                with self.subTest(expected=expected, pending=pending):
                    self.assertIn('invalid_affected_rows_expected:0', self.prepare(oracle)['static_blockers'])
        oracle = {'kind': 'affected_rows', 'step_id': 'insert_row', 'expected': 1, 'sql': 'SELECT 1;'}
        self.assertIn('affected_rows_separate_query:0', self.prepare(oracle)['static_blockers'])

    def test_missing_or_wrong_step_does_not_become_an_observation(self):
        self.assertIn('missing_oracle_expected:0', self.prepare({'kind': 'affected_rows'})['static_blockers'])
        unit = self.prepare({'kind': 'affected_rows', 'expected': 1, 'step_id': 'absent'})
        self.assertIn('oracle_step:0', unit['static_blockers'])

    def test_non_dml_target_cannot_use_affected_rows(self):
        scenario = self.r.scenarios['scenario_create_index_visibility_fresh'].model_copy(deep=True)
        scenario.oracles = [{'kind': 'affected_rows', 'step_id': scenario.steps[0]['id'], 'expected': 1}]
        cases = self.g.generate_with_report(self.r.manifests['manifest_create_index_visibility_a_fresh'])[0]
        unit = prepare_unit(scenario, cases, self.g)
        self.assertIn('affected_rows_target_not_successful_dml:0', unit['static_blockers'])

