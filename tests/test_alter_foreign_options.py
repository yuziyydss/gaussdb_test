"""Finite documented log_fdw options; no runtime or arbitrary validator claims."""
import unittest
from pathlib import Path
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from core.execution_preparation import sql_identity

ROOT = Path(__file__).resolve().parents[1]


class AlterForeignOptionsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def cases(self, op):
        mid = 'manifest_alter_foreign_table_log_' + op
        self.assertTrue(mid in self.r.manifests, mid)
        return self.g.generate_with_report(self.r.manifests[mid])[0]

    def test_four_options_have_actual_option_state_and_preserve_scope(self):
        for op, clause in [('implicit', "latest_files '2'"), ('add', "ADD latest_files '2'"),
                           ('set', "SET latest_files '5'"), ('drop', 'DROP latest_files')]:
            with self.subTest(op=op):
                cases = self.cases(op); self.assertEqual(len(cases), 1)
                c = cases[0]
                self.assertEqual(sql_identity(c.sql), sql_identity(
                    'ALTER FOREIGN TABLE g_a3_aft_ns.foreign_table OPTIONS ('+clause+');'))
                self.assertEqual(len(c.setup_sqls), 4 if op in ('set','drop') else 3)
                self.assertIn('CREATE FOREIGN TABLE', c.setup_sqls[2])
                if op in ('set','drop'):
                    self.assertEqual(c.setup_sqls[3], "ALTER FOREIGN TABLE g_a3_aft_ns.foreign_table OPTIONS (ADD latest_files '2');")
                self.assertEqual(c.teardown_sqls[-1], 'DROP SERVER g_a3_log_server RESTRICT;')
                self.assertEqual(c.expected_scope, 'syntax_only')
                self.assertEqual(c.expected, 'success')

    def test_wrong_wrapper_missing_existing_option_and_extra_statement_rejected(self):
        self.cases('set')
        original = self.g._compile_fixture_lifecycle
        for mutate in [lambda s:s[:3], lambda s:[x.replace('log_fdw','file_fdw') for x in s],
                       lambda s:s+['SELECT 1;'], lambda s:[x.replace("latest_files '2'", "latest_files '9'") for x in s]]:
            with self.subTest(mutate=mutate), patch.object(self.g,'_compile_fixture_lifecycle',
                    side_effect=lambda refs:(mutate(original(refs)[0]),original(refs)[1])):
                with self.assertRaisesRegex(GenerationValidationError,'log_fdw'):
                    self.cases('set')

    def test_target_option_gate_and_cleanup_drift_rejected(self):
        self.cases('add')
        render = self.g._render_sql_with_consumption
        for old,new in [('latest_files','filename'), ('g_a3_aft_ns.foreign_table','public.other')]:
            def changed(*args):
                sql, consumed = render(*args); return sql.replace(old,new), consumed
            with patch.object(self.g,'_render_sql_with_consumption',side_effect=changed):
                with self.assertRaisesRegex(GenerationValidationError,'log_fdw'):
                    self.cases('add')
        m = self.r.manifests['manifest_alter_foreign_table_log_add'].model_copy(deep=True)
        m.environment_requirements = []
        with self.assertRaisesRegex(GenerationValidationError,'log_fdw'):
            self.g.generate_with_report(m)

    def test_untested_column_and_file_contracts_remain_open(self):
        self.cases('add')
        f = self.r.factors['alter_foreign_table']
        facts = {x.id:x for x in f.facts}
        self.assertEqual(facts['alter_foreign_table_fact_incomplete_column_production'].status,'needs_verification')
        self.assertEqual(facts['alter_foreign_table_fact_runtime_fixture'].status,'needs_verification')
        self.assertEqual(self.r.scenarios['scenario_alter_foreign_table_log_options'].status,'planned')
