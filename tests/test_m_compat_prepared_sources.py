"""Source completeness for the prepared-statement family, without executing SQL."""
import unittest

from scripts.build_m_compat_batch_03 import prepare, execute, release_prepared


class PreparedSourceTests(unittest.TestCase):
    def test_all_documented_body_branches_have_separate_source_facts(self):
        package = prepare()
        branches = [(i, line.strip().removeprefix('–').strip())
                    for i, line in enumerate(package.lines, 1)
                    if line.strip().startswith('–')]
        self.assertEqual(len(branches), 19)
        for line, body in branches[4:]:
            with self.subTest(body=body):
                facts = [f for f in package.facts if f['type'] == 'syntax'
                         and f['source_anchor'].endswith(f'L{line}-{line}')]
                self.assertEqual(len(facts), 1)
                self.assertIn(body, facts[0]['statement'])
                self.assertEqual(facts[0]['type'], 'syntax')
        # Four DML bodies, ANALYZE, TRUNCATE, four DDL, SET and COMMIT representatives.
        self.assertEqual(len(package.files['matrices/body.matrix.yaml']['profiles']), 12)
        features = package.files['matrices/body.matrix.yaml']['documented_features']
        self.assertEqual(len(features), 15)
        represented = {'m_prepare_feature_body_'+name for name in
                       ('analyze', 'truncate', 'create_index', 'create_view', 'alter_relation', 'set', 'commit', 'create_table')}
        pending = [f for f in features if f['id'] not in represented]
        self.assertEqual(len(pending), 7)
        self.assertTrue(all(f['status'] == 'needs_profile'
                            and not f.get('profile_refs') for f in pending))
        files = package.finish()
        self.assertEqual(files['m_prepare.syntax.yaml']['source_fact_refs'],
                         ['m_prepare_fact_syntax', 'm_prepare_fact_bodies', 'm_prepare_fact_body_analyze',
                          'm_prepare_fact_body_truncate', 'm_prepare_fact_body_create_index',
                          'm_prepare_fact_body_create_view', 'm_prepare_fact_body_alter_relation', 'm_prepare_fact_body_set',
                          'm_prepare_fact_body_commit', 'm_prepare_fact_body_create_table'])
        self.assertTrue(all(u['atomicity'] == 'unreviewed'
                            for u in files['m_prepare.source.yaml']['units']))

    def test_database_owner_limit_and_execution_phases_are_not_lost(self):
        facts = {f['id']: f for f in prepare().facts}
        self.assertIn('不支持修改数据库所有者', facts['m_prepare_fact_database_owner_limit']['statement'])
        self.assertEqual(facts['m_prepare_fact_database_owner_limit']['type'], 'constraint')
        for name in ('prepare_phase', 'execute_phase'):
            self.assertIn('m_prepare_fact_' + name, facts)

    def test_execute_write_has_concrete_result_oracle_and_keeps_parameter_gap(self):
        package = execute()
        scenario = package.files['scenarios/write_rows.scenario.yaml']
        self.assertEqual(scenario['status'], 'planned')
        self.assertEqual(scenario['steps'], [{'sql': 'EXECUTE m_execute_write;'}])
        self.assertEqual(scenario['oracles'], [{
            'kind': 'result_set', 'sql': 'SELECT id,qty FROM m_execute_data ORDER BY id;',
            'expected': [[1, 99], [2, 20]]}])
        self.assertIn('m_prepare::m_prepare_fact_session', scenario['fact_refs'])
        self.assertIn('isolated_connection', scenario['execution_requirements'])
        question = next(f for f in package.facts if f['id'].endswith('_parameter_gap'))
        self.assertEqual(question['status'], 'needs_verification')

    def test_release_aliases_retain_session_gate_and_do_not_double_deallocate(self):
        for command in ('DEALLOCATE', 'DROP PREPARE'):
            package = release_prepared(command)
            fixture = package.files['fixtures/one_prepared.fixture.yaml']
            self.assertTrue(all('PREPARE' not in sql for sql in fixture['execution']['teardown_sqls']))
            gates = package.files['manifests/finite.manifest.yaml']['environment_requirements']
            self.assertTrue(any(g['key'] == 'session_lifecycle'
                                and g['allowed_values'] == ['isolated_connection'] for g in gates))
            scenario = package.files['scenarios/statement_removed.scenario.yaml']
            self.assertEqual(scenario['status'], 'planned')


if __name__ == '__main__':
    unittest.main()
