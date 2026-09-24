"""Offline preparation must not mistake source coverage for runtime permission."""
import copy
import unittest
from pathlib import Path

from core.execution_preparation import prepare_unit, sql_identity, ownership_plan
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT = Path(__file__).resolve().parents[1]


class PreparationPrimitiveTests(unittest.TestCase):
    def test_identity_preserves_literals_and_quoted_names(self):
        self.assertEqual(sql_identity('INSERT INTO t VALUES(7,9);'), sql_identity('insert into t VALUES (7, 9);'))
        self.assertNotEqual(sql_identity("SELECT 'A'"), sql_identity("SELECT 'a'"))
        self.assertNotEqual(sql_identity('SELECT "A"'), sql_identity('SELECT "a"'))
        with self.assertRaises(ValueError):
            sql_identity('SELECT 1; DROP TABLE t;')

    def test_owned_objects_record_success_conditions_not_assumed_ownership(self):
        plan = ownership_plan(['CREATE SCHEMA fp_ns;', 'CREATE TABLE fp_ns.t (id INT);', 'INSERT INTO fp_ns.t VALUES (1);'],
                              ['DROP TABLE fp_ns.t RESTRICT;', 'DROP SCHEMA fp_ns;'])
        self.assertEqual([o['object'] for o in plan['creates']], ['fp_ns', 'fp_ns.t'])
        self.assertTrue(all(o['requires_success_receipt'] for o in plan['creates']))
        self.assertFalse(plan['runtime_ownership_proven'])

    def test_blind_cleanup_existing_objects_and_transactions_are_not_approved(self):
        for setup, cleanup in [
            (['CREATE TABLE t(id INT);'], ['DROP TABLE other;']),
            (['DROP TABLE IF EXISTS t;', 'CREATE TABLE t(id INT);'], ['DROP TABLE t;']),
            (['CREATE TABLE t(id INT);'], ['DROP TABLE t CASCADE;']),
            (['BEGIN;', 'CREATE TABLE t(id INT);'], ['ROLLBACK;']),
        ]:
            self.assertTrue(ownership_plan(setup, cleanup)['blockers'])


class PreparationConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / 'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.cases = cls.g.generate_with_report(cls.r.manifests['manifest_insert_pg_tuple_fresh'])[0]

    def prepare(self, scenario=None, cases=None):
        return prepare_unit(scenario or self.r.scenarios['scenario_insert_pg_tuple_fresh'],
                            self.cases if cases is None else cases, self.g)

    def test_sequential_oracle_is_not_assigned_to_independent_case(self):
        result = self.prepare()
        self.assertEqual(result['unit_kind'], 'scenario_sequence')
        self.assertEqual(result['static_blockers'], [])
        self.assertFalse(result['execution_authorized'])
        self.assertEqual(len(result['steps']), 2)
        self.assertEqual(result['steps'][1]['oracles'][0]['expected'], [[101, 'alpha', 9], [102, 'beta', 8]])
        self.assertEqual(result['setup_sqls'], self.cases[0].setup_sqls)
        self.assertIn('sequence_state_not_independent_case_oracle', result['limits'])

    def test_same_sql_different_seed_does_not_match(self):
        cases = copy.deepcopy(self.cases)
        cases[0].setup_sqls[-1] = cases[0].setup_sqls[-1].replace("'existing'", "'other'")
        result = self.prepare(cases=cases)
        self.assertTrue(any('case_identity' in b for b in result['static_blockers']))

    def test_ambiguous_oracle_or_bad_step_ref_is_blocked(self):
        scenario = self.r.scenarios['scenario_insert_pg_tuple_fresh'].model_copy(deep=True)
        scenario.oracles[0].pop('step_id')
        self.assertTrue(any('oracle_step' in b for b in self.prepare(scenario)['static_blockers']))
        scenario.oracles[0]['step_id'] = 'absent'
        self.assertTrue(any('oracle_step' in b for b in self.prepare(scenario)['static_blockers']))

    def test_modes_cannot_be_merged_or_masquerade_as_one_database(self):
        cases = copy.deepcopy(self.cases)
        next(g for g in cases[0].environment_requirements if g['key'] == 'compatibility_mode')['allowed_values'] = ['M']
        result = self.prepare(cases=cases)
        self.assertIn('inconsistent_environment_requirements', result['static_blockers'])

    def test_missing_oracle_does_not_become_success_by_default(self):
        scenario = self.r.scenarios['scenario_insert_pg_tuple_fresh'].model_copy(deep=True)
        scenario.oracles = []
        result = self.prepare(scenario)
        self.assertTrue(any('missing_oracle' in b for b in result['static_blockers']))

    def test_empty_sequence_and_incomplete_result_oracle_fail_closed(self):
        scenario = self.r.scenarios['scenario_insert_pg_tuple_fresh'].model_copy(deep=True)
        scenario.steps = []
        scenario.oracles = []
        self.assertIn('empty_sequence', self.prepare(scenario)['static_blockers'])
        scenario = self.r.scenarios['scenario_insert_pg_tuple_fresh'].model_copy(deep=True)
        scenario.oracles[0].pop('expected')
        self.assertIn('missing_oracle_expected:0', self.prepare(scenario)['static_blockers'])

    def test_real_general_and_m_batch_retains_identity_and_oracle_gaps(self):
        from scripts.prepare_execution_batch import build_batch
        batch = build_batch(self.r, self.g)
        self.assertEqual(batch['summary']['packages'], 5)
        self.assertEqual(batch['summary']['candidates'], 11)
        self.assertEqual(batch['summary']['bound_candidate_ids'], 11)
        self.assertEqual(batch['summary']['unbound_candidate_ids'], [])
        self.assertEqual(batch['summary']['runtime_verified'], 0)
        self.assertEqual(batch['summary']['physical_modes'], ['A', 'B', 'M', 'PG'])
        units = {u['scenario_ref']: u for u in batch['units']}
        count = units['scenario_m_select_count_all_null']
        self.assertEqual(count['static_blockers'], [])
        self.assertEqual(len(count['oracle_calibration_pending']), 4)
        self.assertTrue(count['m_environment_plan_ref'])
        for sid in ('scenario_m_insert_generated_null_write', 'scenario_m_update_generated_write',
                    'scenario_m_update_generated_null_write'):
            with self.subTest(scenario=sid):
                unit = units[sid]
                self.assertEqual(unit['static_blockers'], [])
                self.assertEqual(unit['preparation_status'], 'oracle_calibration_pending')
                self.assertEqual(unit['steps'][0]['oracles'][0]['sqlstates'], [])
        for sid in ('scenario_create_index_comment_short_b', 'scenario_create_index_visibility_fresh'):
            with self.subTest(scenario=sid):
                self.assertEqual(units[sid]['static_blockers'], [])
                self.assertEqual(units[sid]['preparation_status'], 'oracle_calibration_pending')
                self.assertTrue(all('candidate' in s['source_step'] and 'sql' not in s['source_step']
                                    for s in units[sid]['steps']))
        self.assertTrue(all(not u['execution_authorized'] for u in batch['units']))
        self.assertTrue(all(not u['ownership_plan']['runtime_ownership_proven'] for u in batch['units']))
        for case in batch['candidates']:
            if case['case_id'] in {c.case_id for c in self.cases}:
                self.assertEqual(case, next(c.to_dict() for c in self.cases if c.case_id == case['case_id']))

    def test_old_observed_index_name_is_not_implicitly_rewritten(self):
        scenario = self.r.scenarios['scenario_create_index_comment_short_b'].model_copy(deep=True)
        scenario.steps = [{'id': 'create_comment', 'sql':
            "CREATE INDEX idx_ci_comment_observed ON g_ci_comment USING btree (id) COMMENT 'factor index';"}]
        cases = self.g.generate_with_report(self.r.manifests['manifest_create_index_comment_b_fresh'])[0]
        result = prepare_unit(scenario, cases, self.g)
        self.assertTrue(any('case_identity' in b for b in result['static_blockers']))
        self.assertIsNone(result['steps'][0]['resolved_sql'])


if __name__ == '__main__':
    unittest.main()
