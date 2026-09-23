"""PDF GRANT special forms: real finite domains, not executed privilege tests."""
import itertools
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]
MIDS = ('manifest_grant_database_link_positive', 'manifest_grant_public_synonym_positive')


class GrantSpecialPrivilegesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def test_pdf_forms_have_exact_six_and_four_sql_candidates(self):
        expected = [
            {f'GRANT {priv} {public}DATABASE LINK TO grant_recipient;'
             for priv, public in itertools.product(('CREATE', 'ALTER', 'DROP'), ('', 'PUBLIC '))},
            {f'GRANT {priv} PUBLIC SYNONYM TO grant_recipient{admin};'
             for priv, admin in itertools.product(('CREATE', 'DROP'), ('', ' WITH ADMIN OPTION'))}]
        for mid, sqls in zip(MIDS, expected):
            with self.subTest(manifest=mid):
                self.assertIn(mid, self.registry.factors['grant'].manifest_refs)
                manifest = self.registry.manifests[mid]
                cases, report = self.generator.generate_with_report(manifest)
                self.assertEqual({c.sql for c in cases}, sqls)
                self.assertEqual(len(cases), len(sqls))
                self.assertEqual(len({c.case_id for c in cases}), len(cases))
                dimensions = [d for d, values in manifest.bindings.items() if len(values) > 1]
                required = set(itertools.product(*(manifest.bindings[d] for d in dimensions)))
                self.assertEqual({tuple(c.params[d] for d in dimensions) for c in cases}, required)
                self.assertTrue(report.pairwise_complete)
                self.assertEqual(manifest.status, 'needs_review')
                self.assertEqual(manifest.expected.scope, 'syntax_only')

    def test_actual_prerequisites_are_local_fresh_non_login_role_only(self):
        for mid in MIDS:
            cases, _ = self.generator.generate_with_report(self.registry.manifests[mid])
            for case in cases:
                self.assertEqual(case.setup_sqls, ['BEGIN;', 'CREATE ROLE grant_recipient NOSYSADMIN NOLOGIN PASSWORD DISABLE;'])
                self.assertEqual(case.teardown_sqls, ['ROLLBACK;'])
                env = {e['key']: e['allowed_values'] for e in case.environment_requirements}
                self.assertEqual(env['role_test_environment'], ['isolated_instance_fresh_names'])
                self.assertEqual(env['special_grant_authorization'], ['independent_approval_and_grantor_preflight'])
                self.assertNotIn('grant_fact_all_privileges_environment', str(case.environment_requirements))
                self.assertNotIn('grant_fact_any_environment', str(case.environment_requirements))

    def test_special_forms_reject_group_or_multiple_recipient(self):
        factor = self.registry.factors['grant']
        resolved = self.registry.resolve_dimension_values('grant')
        for mid in MIDS:
            manifest = self.registry.manifests[mid]
            solver = self.generator._build_solver(factor, manifest, resolved)
            combo = {d: values[0] for d, values in self.generator.build_param_space(factor, manifest).items()}
            self.assertTrue(solver.is_valid(combo)[0])
            for recipient in ('grant_role_recipient_group', 'grant_role_recipient_two'):
                combo['role_recipient'] = recipient
                self.assertFalse(solver.is_valid(combo)[0], (mid, recipient))

    def test_missing_authority_oracles_and_other_profiles_stay_visible(self):
        scenario = self.registry.scenarios['scenario_grant_special_privileges']
        self.assertEqual(scenario.status, 'planned')
        self.assertIn('授权者', scenario.description)
        audit = FactorCoverageAuditor(self.registry).audit('grant')
        self.assertEqual(audit['values']['coverage_gaps'], [])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__ == '__main__':
    unittest.main()
