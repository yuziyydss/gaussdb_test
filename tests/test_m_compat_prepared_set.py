"""Prepared SET must borrow real SET syntax and transaction fixture, not execute early."""
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_03 import prepare, set_command


SQL = "PREPARE m_prepare_stmt FROM 'SET SESSION TIME ZONE ''PRC''';"


class PreparedSetTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.r.load_all()

    def test_literal_body_is_sourced_from_real_set_syntax(self):
        p = prepare()
        profiles = {x['id']: x for x in p.files['matrices/body.matrix.yaml']['profiles']}
        self.assertTrue('m_prepare_body_set_timezone' in profiles)
        profile = profiles['m_prepare_body_set_timezone']
        self.assertEqual(profile['render'], "'SET SESSION TIME ZONE ''PRC'''")
        self.assertIn('m_set::m_set_fact_timezone', profile['fact_refs'])
        self.assertIn('m_set_fact_timezone', set_command().exports)
        self.assertEqual(profile['properties']['source_tables'], [])

    def test_candidate_expands_shared_transaction_and_releases_in_reverse_order(self):
        mid = 'manifest_m_prepare_set_timezone'
        self.assertTrue(mid in self.r.manifests, mid)
        cases, report = FactorPackageSQLGenerator(self.r).generate_with_report(self.r.manifests[mid])
        self.assertEqual(len(cases), 1)
        self.assertTrue(report.pairwise_complete)
        case = cases[0]
        self.assertEqual(case.sql, SQL)
        self.assertEqual(case.setup_sqls, ['START TRANSACTION;', 'SHOW TimeZone;'])
        self.assertEqual(case.teardown_sqls, ['DEALLOCATE PREPARE m_prepare_stmt;', 'ROLLBACK;'])
        self.assertEqual((case.expected, case.expected_scope), ('success', 'syntax_only'))
        self.assertNotIn('EXECUTE ', ' '.join(case.setup_sqls + [case.sql] + case.teardown_sqls))
        gates = {g['key']: g for g in case.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'], ['M'])
        self.assertEqual(gates['session_lifecycle']['allowed_values'], ['isolated_connection'])
        self.assertIn('m_set::m_set_fact_session', gates['session_lifecycle']['fact_refs'])

    def test_real_dependency_is_retained_and_user_variable_is_not_assumed_preparable(self):
        fid = 'fixture_m_prepare_set_timezone'
        self.assertTrue(fid in self.r.fixtures, fid)
        self.assertEqual(self.r.fixtures[fid].requires_fixture_refs, ['fixture_m_set_transaction'])
        self.assertIn('m_set', self.r.factor_dependency_graph()['m_prepare'])
        order = self.r.factor_topological_order()
        self.assertLess(order.index('m_set'), order.index('m_prepare'))
        scenario = self.r.scenarios['scenario_m_prepare_variable_from']
        self.assertEqual(scenario.status, 'planned')
        self.assertTrue(any('@m_prepare_sql' in str(s) for s in scenario.steps))

    def test_phase_oracle_stays_planned_and_other_set_families_are_not_closed(self):
        p = prepare()
        sid = 'scenario_m_prepare_set_phase'
        self.assertTrue(sid in self.r.scenarios, sid)
        scenario = self.r.scenarios[sid]
        self.assertEqual(scenario.status, 'planned')
        self.assertTrue(any(s.get('id') == 'prepare' and s.get('sql') == SQL for s in scenario.steps))
        self.assertTrue(any(s.get('id') == 'execute' and s.get('sql') == 'EXECUTE m_prepare_stmt;' for s in scenario.steps))
        self.assertTrue(any(o.get('kind') == 'manual_assertion' for o in scenario.oracles))
        features = {f['id']: f for f in p.files['matrices/body.matrix.yaml']['documented_features']}
        self.assertEqual(features['m_prepare_feature_body_set']['coverage_mode'], 'representative')
        self.assertEqual(sum(f['status'] == 'needs_profile' for f in features.values()), 7)
        self.assertIn('用户变量', p.files['manifests/set_timezone.manifest.yaml']['description'])


if __name__ == '__main__':
    unittest.main()
