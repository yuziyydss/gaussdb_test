"""Documented foreign-target RLS prohibition, not arbitrary FDW ALTER support."""
import unittest
from pathlib import Path
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_alter_table_log_foreign_rls_negative'

class AlterTableLogForeignTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def generate(self, manifest=None):
        self.assertTrue(MID in self.r.manifests, MID)
        return self.g.generate_with_report(manifest or self.r.manifests[MID])

    def test_actual_foreign_target_has_server_and_exact_reverse_cleanup(self):
        cases, report = self.generate()
        self.assertEqual(len(cases), 1)
        c = cases[0]
        self.assertEqual(c.sql, 'ALTER TABLE g_a3_at_log_ns.foreign_table ENABLE ROW LEVEL SECURITY;')
        self.assertEqual(c.setup_sqls, [
            'CREATE SERVER g_a3_log_server FOREIGN DATA WRAPPER log_fdw;',
            'CREATE SCHEMA g_a3_at_log_ns;',
            "CREATE FOREIGN TABLE g_a3_at_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');"])
        self.assertEqual(c.teardown_sqls, [
            'DROP FOREIGN TABLE g_a3_at_log_ns.foreign_table RESTRICT;',
            'DROP SCHEMA g_a3_at_log_ns RESTRICT;', 'DROP SERVER g_a3_log_server RESTRICT;'])
        self.assertTrue(report.pairwise_complete)
        m = self.r.manifests[MID]
        self.assertEqual(m.expected.default, 'error')
        self.assertEqual(m.expected.oracle_status, 'needs_verification')
        self.assertEqual(m.expected.error_category, 'unsupported_rls_target')

    def test_wrong_wrapper_plain_table_absent_server_or_extra_sql_rejected(self):
        self.generate()
        original = self.g._compile_fixture_lifecycle
        mutations = [lambda s: s[1:], lambda s: [x.replace('log_fdw', 'file_fdw') for x in s],
                     lambda s: [x.replace('CREATE FOREIGN TABLE', 'CREATE TABLE') for x in s],
                     lambda s: s + ['SELECT 1;']]
        for mutate in mutations:
            with self.subTest(mutate=mutate), patch.object(self.g, '_compile_fixture_lifecycle',
                    side_effect=lambda refs: (mutate(original(refs)[0]), original(refs)[1])):
                with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
                    self.generate()

    def test_target_and_action_cannot_drift(self):
        self.generate(); original = self.g._render_sql_with_consumption
        for old, new in [('g_a3_at_log_ns.foreign_table', 'public.other'),
                         ('ENABLE ROW LEVEL SECURITY', 'DISABLE ROW LEVEL SECURITY'),
                         ('ENABLE ROW LEVEL SECURITY', 'FORCE ROW LEVEL SECURITY')]:
            def altered(*args):
                sql, consumed = original(*args)
                return sql.replace(old, new), consumed
            with self.subTest(new=new), patch.object(self.g, '_render_sql_with_consumption', side_effect=altered):
                with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
                    self.generate()

    def test_cleanup_and_missing_contract_fail_closed(self):
        self.generate(); original = self.g._compile_fixture_lifecycle
        with patch.object(self.g, '_compile_fixture_lifecycle',
                          side_effect=lambda refs: (original(refs)[0], ['ROLLBACK;'])):
            with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
                self.generate()
        key = 'matrix_alter_table_table_profiles'
        matrix = self.r.matrices[key].model_copy(deep=True)
        profile = next(p for p in matrix.profiles if p.id == 'at_table_log_foreign_fresh')
        profile.properties.pop('foreign_table_contract')
        with patch.dict(self.r.matrices, {key: matrix}):
            with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
                self.generate()

    def test_missing_gate_and_wrong_mode_are_not_accepted(self):
        self.generate()
        manifest = self.r.manifests[MID].model_copy(deep=True)
        manifest.environment_requirements = []
        with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
            self.generate(manifest)
        manifest = self.r.manifests[MID].model_copy(deep=True)
        gate = manifest.environment_requirements[0].model_copy(deep=True)
        gate.key, gate.allowed_values = 'compatibility_mode', ['M']
        manifest.environment_requirements.append(gate)
        with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
            self.generate(manifest)
        manifest = self.r.manifests[MID].model_copy(deep=True)
        manifest.environment_requirements.append(manifest.environment_requirements[0].model_copy(deep=True))
        with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
            self.generate(manifest)

    def test_generic_external_gap_and_source_atomicity_remain_truthful(self):
        self.generate()
        values = self.r.resolve_dimension_values('alter_table')['table_profile']
        self.assertEqual(values['at_table_external'].validity, 'conditional')
        self.r.factor_topological_order()
        scenario = self.r.scenarios['scenario_alter_table_log_foreign_rls']
        self.assertEqual(scenario.status, 'planned')
        self.assertTrue(all(o['kind'] == 'manual_assertion' for o in scenario.oracles))

    def test_evidence_does_not_claim_target_error_or_runtime_ownership(self):
        from core.log_fdw_catalog_contract import check_log_fdw_enable_rls_negative
        cases, _ = self.generate(); c = cases[0]
        m = self.r.manifests[MID]
        evidence = check_log_fdw_enable_rls_negative(c.sql, c.setup_sqls, c.teardown_sqls,
            {g.key: g.allowed_values for g in m.environment_requirements}, 'g_a3_at_log_ns.foreign_table')
        for key in ('runtime_proven', 'data_access_proven', 'cleanup_ownership_proven', 'target_error_proven'):
            self.assertFalse(evidence[key])
        self.assertEqual(c.expected_sqlstates, [])

if __name__ == '__main__':
    unittest.main()
