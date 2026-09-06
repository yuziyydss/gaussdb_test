"""Finite GRANT membership candidates must carry real, isolated prerequisites."""
import itertools
import json
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_grant_role_membership_positive'


class GrantPackageClosureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def manifest(self):
        self.assertIn(MID, self.registry.factors['grant'].manifest_refs)
        return self.registry.manifests[MID]

    def test_membership_pair_domain_is_independently_covered(self):
        manifest = self.manifest()
        self.assertEqual(manifest.status, 'needs_review')
        self.assertEqual(manifest.expected.scope, 'syntax_only')
        cases, report = self.generator.generate_with_report(manifest)
        dimensions = ('role_source', 'role_recipient', 'admin_option')
        space = [manifest.bindings[d] for d in dimensions]
        self.assertEqual([len(values) for values in space], [2, 2, 2])
        expected = {pair for combo in itertools.product(*space)
                    for pair in itertools.combinations(zip(dimensions, combo), 2)}
        actual = {pair for case in cases for pair in itertools.combinations(
            [(d, case.params[d]) for d in dimensions], 2)}
        self.assertEqual(actual, expected)
        self.assertTrue(report.pairwise_complete)
        self.assertGreaterEqual(len(cases), 4)
        self.assertLessEqual(len(cases), 8)
        self.assertEqual(len(cases), len({c.sql for c in cases}))
        self.assertEqual(len(cases), len({c.case_id for c in cases}))
        for case in cases:
            self.assertEqual(set(case.consumed_dimension_ids), set(dimensions) | {'statement_form'})
            self.assertTrue(case.sql.startswith('GRANT grant_source_role'))
            for unwanted in (' ON ', ' TO GROUP ', ' ANY ', 'GRANT ALL', 'DATABASE LINK'):
                self.assertNotIn(unwanted, case.sql)

    def test_all_referenced_roles_are_created_without_cleanup_of_existing_roles(self):
        cases, _ = self.generator.generate_with_report(self.manifest())
        expected_names = {'grant_source_role', 'grant_source_role_two', 'grant_recipient', 'grant_recipient_two'}
        for case in cases:
            self.assertEqual(case.setup_sqls[0], 'BEGIN;')
            self.assertEqual(len(case.setup_sqls), 5)
            creates = case.setup_sqls[1:]
            self.assertEqual({sql.split()[2] for sql in creates}, expected_names)
            self.assertTrue(all('NOLOGIN' in sql and 'PASSWORD DISABLE' in sql for sql in creates))
            self.assertTrue(all('NOSYSADMIN' in sql for sql in creates))
            self.assertEqual(case.teardown_sqls, ['ROLLBACK;'])
            self.assertNotIn('DROP ', ' '.join(case.setup_sqls + case.teardown_sqls))
            self.assertNotIn('grant_schema', ' '.join(case.setup_sqls))
            env = {r['key']: r['allowed_values'] for r in case.environment_requirements}
            self.assertEqual(env['executor_role'], ['system_administrator'])
            self.assertEqual(env['separation_of_duties'], ['off'])
            self.assertEqual(env['role_test_environment'], ['isolated_instance_fresh_names'])

    def test_group_recipient_is_not_allowed_by_membership_local_rule(self):
        manifest = self.manifest()
        factor = self.registry.factors['grant']
        resolved = self.registry.resolve_dimension_values(factor.id)
        solver = self.generator._build_solver(factor, manifest, resolved)
        combo = {k: values[0] for k, values in self.generator.build_param_space(factor, manifest).items()}
        self.assertTrue(solver.is_valid(combo)[0])
        combo['role_recipient'] = 'grant_role_recipient_group'
        self.assertFalse(solver.is_valid(combo)[0])

    def test_creation_fact_dependency_and_unverified_behavior_are_retained(self):
        self.manifest()
        self.assertIn('create_role', self.registry.factor_dependency_graph()['grant'])
        scenario = self.registry.scenarios['scenario_grant_fresh_membership']
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual(scenario.fixture_refs, ['fixture_grant_fresh_membership_roles'])
        audit = FactorCoverageAuditor(self.registry).audit('grant')
        for value in ('statement_form.grant_form_role_membership', 'role_source.grant_role_source_one',
                      'role_source.grant_role_source_two', 'role_recipient.grant_role_recipient_one',
                      'role_recipient.grant_role_recipient_two', 'admin_option.grant_admin_option_absent',
                      'admin_option.grant_admin_option_with_admin'):
            self.assertNotIn(value, audit['values']['coverage_gaps'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(self.registry.factors['grant'].status, 'needs_review')

    def test_original_object_manifests_have_identical_complete_cases(self):
        self.manifest()
        baseline = json.loads((ROOT / 'generated/factor_packages/generation_report.json').read_text())
        for mid, record in baseline['manifests'].items():
            if not mid.startswith('manifest_grant_'):
                continue
            cases, _ = self.generator.generate_with_report(self.registry.manifests[mid])
            self.assertEqual([c.to_dict() for c in cases], record['cases'], mid)

    def any_manifest(self):
        mid = 'manifest_grant_any_positive'
        self.assertIn(mid, self.registry.factors['grant'].manifest_refs)
        return self.registry.manifests[mid]

    def test_any_privileges_match_the_documented_27_not_arbitrary_valid_labels(self):
        manifest = self.any_manifest()
        factor = self.registry.factors['grant']
        values = {v.id: v for c in factor.dimensions['any_privilege'].classes for v in c.values}
        expected = {
            'CREATE ANY TABLE', 'ALTER ANY TABLE', 'DROP ANY TABLE', 'SELECT ANY TABLE',
            'INSERT ANY TABLE', 'UPDATE ANY TABLE', 'DELETE ANY TABLE', 'TRUNCATE ANY TABLE',
            'CREATE ANY SEQUENCE', 'CREATE ANY INDEX', 'CREATE ANY FUNCTION', 'EXECUTE ANY FUNCTION',
            'CREATE ANY PACKAGE', 'EXECUTE ANY PACKAGE', 'CREATE ANY TYPE', 'ALTER ANY TYPE',
            'DROP ANY TYPE', 'ALTER ANY SEQUENCE', 'DROP ANY SEQUENCE', 'SELECT ANY SEQUENCE',
            'ALTER ANY INDEX', 'DROP ANY INDEX', 'CREATE ANY SYNONYM', 'DROP ANY SYNONYM',
            'CREATE ANY TRIGGER', 'ALTER ANY TRIGGER', 'DROP ANY TRIGGER',
        }
        self.assertEqual(len(expected), 27)
        self.assertEqual({values[v].render for v in manifest.bindings['any_privilege']},
                         expected | {'SELECT ANY TABLE, UPDATE ANY TABLE'})
        self.assertTrue(all(values[v].validity == 'valid' for v in manifest.bindings['any_privilege']))

    def test_any_pairs_and_consumed_dimensions_are_independent_of_inactive_defaults(self):
        manifest = self.any_manifest()
        cases, report = self.generator.generate_with_report(manifest)
        dimensions = ('any_privilege', 'role_recipient', 'admin_option')
        expected = {pair for combo in itertools.product(*(manifest.bindings[d] for d in dimensions))
                    for pair in itertools.combinations(zip(dimensions, combo), 2)}
        actual = {pair for c in cases for pair in itertools.combinations(
            [(d, c.params[d]) for d in dimensions], 2)}
        self.assertEqual(len(expected), 146)
        self.assertEqual(actual, expected)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(report.feasible_combination_count, 168)
        self.assertEqual(len(cases), len({c.sql for c in cases}))
        for c in cases:
            self.assertEqual(set(c.consumed_dimension_ids), set(dimensions) | {'statement_form'})
            self.assertIn(' ANY ', c.sql)
            self.assertNotIn('TO PUBLIC', c.sql)
            self.assertNotIn(' ON ', c.sql)
            self.assertNotIn('WITH GRANT OPTION', c.sql)

    def test_any_fixture_prepares_only_fresh_recipients_and_keeps_execution_gated(self):
        manifest = self.any_manifest()
        self.assertEqual(manifest.status, 'needs_review')
        self.assertEqual(manifest.expected.scope, 'syntax_only')
        cases, _ = self.generator.generate_with_report(manifest)
        for c in cases:
            self.assertEqual(c.setup_sqls, [
                'BEGIN;',
                'CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;',
                'CREATE ROLE grant_recipient_two NOSYSADMIN NOLOGIN PASSWORD DISABLE;',
            ])
            self.assertEqual(c.teardown_sqls, ['ROLLBACK;'])
            env = {r['key']: r['allowed_values'] for r in c.environment_requirements}
            self.assertEqual(env['executor_role'], ['system_administrator'])
            self.assertEqual(env['separation_of_duties'], ['off'])
            self.assertEqual(env['role_test_environment'], ['isolated_instance_fresh_names'])
        scenario = self.registry.scenarios['scenario_grant_fresh_any']
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual(scenario.fixture_refs, ['fixture_grant_fresh_recipients'])
        self.assertIn('grant_fact_any_database_scope', scenario.fact_refs)

    def sysadmin_manifest(self):
        mid = 'manifest_grant_sysadmin_spelling'
        self.assertIn(mid, self.registry.factors['grant'].manifest_refs)
        return self.registry.manifests[mid]

    def test_sysadmin_spelling_is_two_single_recipient_forms_not_object_all(self):
        manifest = self.sysadmin_manifest()
        cases, report = self.generator.generate_with_report(manifest)
        self.assertEqual(manifest.strategy, 'full_cartesian')
        self.assertEqual({c.sql for c in cases}, {
            'GRANT ALL PRIVILEGES TO grant_recipient;',
            'GRANT ALL PRIVILEGE TO grant_recipient;',
        })
        self.assertEqual(len(cases), 2)
        self.assertEqual(report.feasible_combination_count, 2)
        for c in cases:
            self.assertEqual(set(c.consumed_dimension_ids),
                             {'statement_form', 'role_recipient', 'sysadmin_spelling'})
            self.assertNotIn(' ON ', c.sql)
            self.assertNotIn('OPTION', c.sql)

    def test_sysadmin_requires_new_nonlogin_role_and_its_own_authority_fact(self):
        manifest = self.sysadmin_manifest()
        self.assertEqual(manifest.status, 'needs_review')
        self.assertEqual(manifest.expected.scope, 'syntax_only')
        cases, _ = self.generator.generate_with_report(manifest)
        for c in cases:
            self.assertEqual(c.setup_sqls, [
                'BEGIN;', 'CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;'])
            self.assertEqual(c.teardown_sqls, ['ROLLBACK;'])
            authority = next(r for r in c.environment_requirements if r['key'] == 'executor_role')
            self.assertEqual(authority['allowed_values'], ['system_administrator'])
            self.assertIn('grant_fact_all_privileges_environment', authority['fact_refs'])
            self.assertNotIn('grant_fact_any_environment', authority['fact_refs'])
        scenario = self.registry.scenarios['scenario_grant_fresh_sysadmin']
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual(scenario.fixture_refs, ['fixture_grant_fresh_single_recipient'])
        self.assertIn('独立SYSADMIN授予执行授权', scenario.execution_requirements)

    def test_sysadmin_rejects_group_and_multiple_recipients_even_if_domain_is_shared(self):
        manifest = self.sysadmin_manifest()
        factor = self.registry.factors['grant']
        solver = self.generator._build_solver(factor, manifest,
                                              self.registry.resolve_dimension_values(factor.id))
        combo = {k: values[0] for k, values in self.generator.build_param_space(factor, manifest).items()}
        self.assertTrue(solver.is_valid(combo)[0])
        for value in ('grant_role_recipient_group', 'grant_role_recipient_two'):
            combo['role_recipient'] = value
            self.assertFalse(solver.is_valid(combo)[0])


if __name__ == '__main__':
    unittest.main()
