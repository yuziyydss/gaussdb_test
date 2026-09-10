"""Finite documented log_fdw DDL; never claims external data usability."""
import unittest
from pathlib import Path
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]


class LogFDWCatalogTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def cases(self, action):
        mid = 'manifest_'+action+'_foreign_table_log_catalog'
        self.assertTrue(mid in self.r.manifests, mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_real_server_schema_table_names_and_reverse_cleanup(self):
        create, cr = self.cases('create'); drop, dr = self.cases('drop')
        self.assertEqual((len(create), len(drop)), (1, 1))
        sql = "CREATE FOREIGN TABLE g_a3_log_ns.foreign_table (col1 TEXT) SERVER g_a3_log_server OPTIONS (logtype 'gs_log');"
        self.assertEqual(create[0].sql, sql)
        self.assertEqual(drop[0].setup_sqls, create[0].setup_sqls + [sql])
        self.assertEqual(drop[0].sql, 'DROP FOREIGN TABLE g_a3_log_ns.foreign_table RESTRICT;')
        self.assertEqual(create[0].teardown_sqls, [drop[0].sql] + drop[0].teardown_sqls)
        self.assertEqual(drop[0].teardown_sqls,
                         ['DROP SCHEMA g_a3_log_ns RESTRICT;', 'DROP SERVER g_a3_log_server RESTRICT;'])
        self.assertTrue(cr.pairwise_complete and dr.pairwise_complete)
        self.assertTrue(all(c.expected_scope == 'syntax_only' for c in create+drop))

    def test_wrong_wrapper_missing_server_wrong_order_and_plain_table_rejected(self):
        self.cases('drop')
        original = self.g._compile_fixture_lifecycle
        for mutate in (lambda s: [x.replace('log_fdw', 'file_fdw') for x in s],
                       lambda s: s[1:], lambda s: list(reversed(s)),
                       lambda s: [x.replace('CREATE FOREIGN TABLE', 'CREATE TABLE') for x in s]):
            def altered(refs):
                setup, teardown = original(refs)
                return mutate(setup), teardown
            with patch.object(self.g, '_compile_fixture_lifecycle', side_effect=altered):
                with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
                    self.cases('drop')

    def test_filename_credentials_and_wrong_target_cannot_mix_into_log_example(self):
        self.cases('create')
        original = self.g._render_sql_with_consumption
        for old, new in [("logtype 'gs_log'", "filename '/tmp/fake'"),
                         ("logtype 'gs_log'", "password 'secret'"),
                         ('g_a3_log_ns.foreign_table', 'public.other')]:
            def altered(*args):
                sql, consumed = original(*args)
                return sql.replace(old, new), consumed
            with patch.object(self.g, '_render_sql_with_consumption', side_effect=altered):
                with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
                    self.cases('create')

    def test_gates_cleanup_and_contract_cannot_silently_disappear(self):
        self.cases('create')
        mid = 'manifest_create_foreign_table_log_catalog'
        manifest = self.r.manifests[mid].model_copy(deep=True)
        manifest.environment_requirements = []
        with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
            self.g.generate_with_report(manifest)
        original = self.g._compile_fixture_lifecycle
        for cleanup in (['ROLLBACK;'], ['DROP SCHEMA g_a3_log_ns CASCADE;']):
            with patch.object(self.g, '_compile_fixture_lifecycle', side_effect=lambda refs: (original(refs)[0], cleanup)):
                with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
                    self.cases('create')
        matrix_id = 'matrix_create_foreign_table_log_catalog'
        matrix = self.r.matrices[matrix_id].model_copy(deep=True)
        matrix.profiles[0].properties = {}
        with patch.dict(self.r.matrices, {matrix_id: matrix}):
            with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
                self.cases('create')

    def test_file_formats_are_not_credited_by_a_log_catalog_example(self):
        cases, _ = self.cases('create')
        self.assertNotIn('format', cases[0].consumed_dimension_ids)
        values = self.r.resolve_dimension_values('create_foreign_table')['format']
        for suffix in ('text', 'csv', 'binary', 'fixed'):
            self.assertEqual(values['create_foreign_table_format_'+suffix].validity, 'conditional')
        manifest = self.r.manifests['manifest_create_foreign_table_log_catalog'].model_copy(deep=True)
        manifest.bindings['format'] = ['create_foreign_table_format_text']
        with self.assertRaisesRegex(GenerationValidationError, 'log_fdw'):
            self.g.generate_with_report(manifest)

    def test_sources_and_dependencies_do_not_turn_internal_only_into_positive(self):
        self.cases('create'); self.cases('drop')
        graph = self.r.factor_dependency_graph()
        self.assertIn('create_server', graph['create_foreign_table'])
        self.assertIn('create_foreign_table', graph['drop_foreign_table'])
        self.r.factor_topological_order()
        self.assertEqual(self.r.factors['create_conversion'].manifest_refs, [])
        for factor in ('create_foreign_table', 'drop_foreign_table'):
            self.assertEqual(self.r.factors[factor].status, 'needs_review')
            s = self.r.scenarios['scenario_'+factor+'_log_catalog']
            self.assertEqual(s.status, 'planned')
            self.assertTrue(all(o['kind'] == 'manual_assertion' for o in s.oracles))


if __name__ == '__main__':
    unittest.main()
