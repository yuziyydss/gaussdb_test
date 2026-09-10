"""Incoming conflict rows are not existing target rows or generic functions."""
import unittest
from pathlib import Path
from unittest.mock import patch

from core.finite_sql_contract import inspect_write, check_assignments, Contradiction
from scripts.audit_rendered_sql_contracts import audit_report


class ConflictSourceContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT PRIMARY KEY, qty INT DEFAULT 7)']

    def inspect(self, assignment, clause='ON DUPLICATE KEY UPDATE', setup=None, **kwargs):
        return inspect_write('INSERT INTO t VALUES(1,2) '+clause+' '+assignment,
                             self.setup if setup is None else setup, **kwargs)

    def test_source_column_must_exist_without_default(self):
        for expr in ('VALUES(missing)', 'EXCLUDED.missing'):
            result = self.inspect('qty='+expr)
            self.assertEqual(result['status'], 'rejected', result)
            self.assertEqual(result['issues'][0]['code'], 'missing_column')

    def test_destination_must_exist_without_default(self):
        result = self.inspect('missing=VALUES(qty)')
        self.assertEqual(result['status'], 'rejected', result)

    def test_same_column_records_identity_not_row_value_proof(self):
        for clause, expr in (
            ('ON DUPLICATE KEY UPDATE', 'VALUES(qty)'),
            ('ON DUPLICATE KEY UPDATE', 'EXCLUDED.qty'),
            ('ON CONFLICT(id) DO UPDATE SET', 'EXCLUDED.qty'),
        ):
            result = self.inspect('qty='+expr, clause)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('conflict_input_same_column_types', result['checks'])
            self.assertNotIn('conflict_assignment_defaults', result['checks'])

    def test_mixed_defaults_and_reference_reuse_target_default_checks(self):
        for assignment in ('qty=VALUES(qty), id=DEFAULT', '(qty,id)=(VALUES(qty),DEFAULT)'):
            result = self.inspect(assignment, setup=['CREATE TABLE t(id INT DEFAULT 8,qty INT)'])
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('shared_constant_or_null_defaults', result['checks'])
            self.assertIn('conflict_assignment_defaults', result['checks'])
            bad = self.inspect(assignment, setup=['CREATE TABLE t(id INT NOT NULL DEFAULT NULL,qty INT)'])
            self.assertEqual(bad['status'], 'rejected', bad)
            self.assertEqual(bad['issues'][0]['code'], 'null_not_allowed')

    def test_cross_column_even_same_family_is_not_identity(self):
        result = self.inspect('qty=VALUES(id)')
        self.assertEqual(result['status'], 'needs_review', result)

    def test_complex_expressions_do_not_inherit_identity(self):
        for expr in ('VALUES(qty)+1', 'app.VALUES(qty)'):
            self.assertEqual(self.inspect('qty='+expr)['status'], 'needs_review')

    def test_documented_values_predicate_is_a_restriction_not_type_inference(self):
        result = self.inspect('qty=CASE WHEN VALUES(qty) IN (1) THEN 2 ELSE 3 END')
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'duplicate_values_predicate_not_supported')

    def test_values_is_not_enabled_in_pg_conflict(self):
        result = self.inspect('qty=VALUES(qty)', 'ON CONFLICT(id) DO UPDATE SET')
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'conflict_values_scope')

    def test_m_scope_has_values_evidence_but_no_excluded_claim(self):
        result = self.inspect('qty=VALUES(qty)', conflict_source_scope='m_compat')
        self.assertEqual(result['status'], 'checked', result)
        result = self.inspect('qty=EXCLUDED.qty', conflict_source_scope='m_compat')
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['issues'][0]['code'], 'conflict_source_scope_unknown')

    def test_alias_shadowing_stays_review(self):
        result = inspect_write('INSERT INTO t AS excluded VALUES(1,2) '
                               'ON CONFLICT(id) DO UPDATE SET qty=excluded.qty', self.setup)
        self.assertEqual(result['status'], 'needs_review', result)
        result = inspect_write('INSERT INTO excluded VALUES(1,2) '
                               'ON CONFLICT(id) DO UPDATE SET qty=excluded.qty',
                               ['CREATE TABLE excluded(id INT,qty INT)'])
        self.assertEqual(result['status'], 'needs_review', result)

    def test_incoming_partition_key_is_not_old_row_identity(self):
        setup = ['CREATE TABLE t(id INT,qty INT) PARTITION BY RANGE(qty) '
                 '(PARTITION p1 VALUES LESS THAN(10))']
        result = self.inspect('qty=VALUES(qty)', setup=setup)
        self.assertEqual(result['status'], 'needs_review', result)

    def test_stale_ddl_does_not_provide_ordinary_table_contract(self):
        setup = [*self.setup, 'ALTER TABLE t ALTER COLUMN qty SET DEFAULT 9']
        self.assertEqual(self.inspect('qty=VALUES(qty)', setup=setup)['status'], 'needs_review')

    def test_view_target_is_forbidden_before_source_identity_inference(self):
        setup = ['CREATE TABLE base(id INT,qty INT)', 'CREATE VIEW t AS SELECT id,qty FROM base']
        result = self.inspect('qty=VALUES(qty)', setup=setup)
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'view_duplicate_not_supported')

    def test_alias_reordered_input_and_query_preserve_target_column_identity(self):
        for sql in (
            'INSERT INTO t(qty,id) VALUES(2,1),(4,3) ON DUPLICATE KEY UPDATE qty=VALUES(qty)',
            'INSERT INTO t AS dst VALUES(1,2) ON CONFLICT(id) DO UPDATE SET dst.qty=EXCLUDED.qty',
            'INSERT INTO t SELECT 1,2 ON DUPLICATE KEY UPDATE qty=VALUES(qty)',
        ):
            result = inspect_write(sql, self.setup)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('conflict_input_same_column_types', result['checks'])

    def test_unrelated_update_and_literal_do_not_gain_source_checks(self):
        for sql in ('UPDATE t SET qty=VALUES(qty)', 'UPDATE t SET qty=EXCLUDED.qty'):
            self.assertEqual(inspect_write(sql, self.setup)['status'], 'needs_review')
        result = self.inspect("qty='VALUES(missing) EXCLUDED.missing DEFAULT'",
                              setup=['CREATE TABLE t(id INT,qty TEXT)'])
        self.assertNotIn('conflict_input_same_column_types', result['checks'])

    def test_tuple_arity_not_lost_by_per_expression_check(self):
        result = self.inspect('(id,qty)=(VALUES(id))')
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'arity')

    def test_actual_audit_consumer_routes_m_scope_without_execution(self):
        cases = [dict(case_id=fid, factor_id=fid, expected='success',
                      sql='INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE qty=EXCLUDED.qty',
                      setup_sqls=self.setup, teardown_sqls=[]) for fid in ('insert', 'm_insert')]
        result = audit_report({'manifests': {'test': {'cases': cases}}})
        self.assertEqual([c['write_contract']['status'] for c in result['cases']],
                         ['checked', 'needs_review'])
        self.assertFalse(result['database_executed'])


    def test_generated_destination_guard_precedes_unknown_source_contract(self):
        table = {'ddl': 'CREATE TABLE t(id INT, g INT GENERATED ALWAYS AS (id+1) STORED)',
                 'columns': {'id': 'integer', 'g': 'integer'}}
        with self.assertRaises(Contradiction) as caught:
            check_assignments('g=VALUES(g)', table, None, {'t': table},
                              allow_defaults=True, conflict_source=('duplicate', 'general'))
        self.assertEqual(caught.exception.code, 'generated_column_write')

    def test_unregistered_source_scope_does_not_default_to_general_evidence(self):
        result = self.inspect('qty=VALUES(qty)', conflict_source_scope='unreviewed')
        self.assertEqual(result['status'], 'needs_review', result)


class ConflictSourceConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.registry.load_all()

    def test_generator_uses_actual_catalog_scope(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        generator = FactorPackageSQLGenerator(self.registry)
        for mid, scope in (('manifest_m_insert_upsert_conflict', 'm_compat'),
                           ('manifest_insert_pg_conflict_fresh', 'general')):
            with patch('core.factor_package_generator.inspect_write', wraps=inspect_write) as checker:
                cases, _ = generator.generate_with_report(self.registry.manifests[mid])
                self.assertTrue(cases)
                self.assertTrue(checker.call_args_list)
                self.assertTrue(all(call.kwargs['conflict_source_scope'] == scope
                                    for call in checker.call_args_list))

    def test_opt_in_m_seed_does_not_inherit_general_excluded(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        factor = self.registry.factors['m_create_table_select']
        setup = ['CREATE TABLE t(id INT,qty INT)',
                 'INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE qty=VALUES(qty)']
        FactorPackageSQLGenerator._validate_fixture_write_contract(factor, setup)
        with self.assertRaisesRegex(GenerationValidationError, 'conflict_source_scope_unknown'):
            FactorPackageSQLGenerator._validate_fixture_write_contract(
                factor, [setup[0], setup[1].replace('VALUES(qty)', 'EXCLUDED.qty')])


if __name__ == '__main__':
    unittest.main()
