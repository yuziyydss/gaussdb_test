"""Rendered SQL checks must distinguish proof, contradiction and unknown."""
import unittest
from pathlib import Path

from core.finite_sql_contract import inspect_write, inspect_lifecycle


class FiniteSQLContractTests(unittest.TestCase):
    setup = ["CREATE TABLE t (id INT, payload INT, note TEXT);"]
    partition_setup = [
        "CREATE TABLE p (k INT, s INT, payload INT) PARTITION BY RANGE (k) "
        "SUBPARTITION BY RANGE (s) (PARTITION p1 VALUES LESS THAN (10) "
        "(SUBPARTITION s1 VALUES LESS THAN (10), SUBPARTITION s2 VALUES LESS THAN (20)));"
    ]

    def check(self, sql, status, code=None, setup=None):
        result = inspect_write(sql, self.setup if setup is None else setup)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [x['code'] for x in result['issues']], result)

    def test_assignment_column_must_exist(self):
        self.check('UPDATE t SET missing = 1;', 'rejected', 'missing_column')

    def test_tuple_arity_must_match(self):
        self.check('UPDATE t SET (id, payload) = (1);', 'rejected', 'arity')

    def test_simple_assignment_and_quoted_comma(self):
        self.check("UPDATE t SET payload = payload + 1, note = 'a,b WHERE c';", 'checked')

    def test_target_alias_is_resolved(self):
        self.check('UPDATE t AS x SET x.payload = x.payload + 1;', 'checked')

    def test_unknown_function_is_not_success(self):
        self.check('UPDATE t SET payload = vendor_fn(id);', 'needs_review', 'expression_unknown')

    def test_implicit_cast_is_not_called_invalid(self):
        self.check("UPDATE t SET payload = '12';", 'needs_review', 'conversion_unknown')

    def test_assignment_types_use_actual_ddl(self):
        self.check('UPDATE t SET note = 5;', 'needs_review', 'conversion_unknown')

    def test_subpartition_key_outside_all_leaf_bounds(self):
        self.check('UPDATE p SUBPARTITION (s1) SET s = 42;', 'rejected', 'partition_out_of_range', self.partition_setup)

    def test_partition_key_change_requires_review(self):
        self.check('UPDATE p SUBPARTITION (s1) SET s = 12;', 'needs_review', 'partition_movement', self.partition_setup)

    def test_extensible_or_maxvalue_partitions_do_not_get_false_overflow(self):
        self.check('UPDATE p SET k = 42;', 'needs_review', setup=[
            'CREATE TABLE p (k INT) PARTITION BY RANGE (k) INTERVAL (10) (PARTITION p1 VALUES LESS THAN (10));'])
        self.check('UPDATE p SET k = 42;', 'needs_review', setup=[
            'CREATE TABLE p (k INT) PARTITION BY RANGE (k) (PARTITION p1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN MAXVALUE);'])

    def test_identity_and_nonkey_writes_are_distinct(self):
        self.check('UPDATE p SUBPARTITION (s1) SET s = s;', 'checked', setup=self.partition_setup)
        self.check('UPDATE p SUBPARTITION FOR (1,1) SET payload = 42;', 'checked', setup=self.partition_setup)

    def test_insert_width(self):
        self.check('INSERT INTO t (id,payload) VALUES (1);', 'rejected', 'arity')

    def test_insert_projection_matches_target(self):
        self.check('INSERT INTO t (id,payload) SELECT id FROM t;', 'rejected', 'arity')
        self.check('INSERT INTO t (id,payload) SELECT id,payload FROM t;', 'checked')

    def test_tuple_subquery_is_not_an_expression_list(self):
        self.check('UPDATE t SET (id,payload) = (SELECT * FROM external_table);', 'needs_review', 'query_unknown')

    def test_simple_assignment_subqueries_use_real_projection_width(self):
        self.check('UPDATE t SET (id,payload) = (SELECT id,payload FROM t);', 'checked')
        self.check('UPDATE t SET id = (SELECT id,payload FROM t);', 'rejected', 'arity')
        self.check('UPDATE t SET id = (SELECT missing FROM t);', 'rejected', 'missing_column')

    def test_transaction_cleanup_must_end_in_rollback(self):
        setup = ['BEGIN;', 'CREATE SCHEMA fp_q2;', 'CREATE TABLE fp_q2.t (id INT);']
        self.assertEqual(inspect_lifecycle(setup, ['DROP TABLE fp_q2.t;', 'ROLLBACK;'])['status'], 'transaction_scoped')
        self.assertEqual(inspect_lifecycle(setup, ['COMMIT;', 'ROLLBACK;'])['status'], 'needs_review')
        self.assertEqual(inspect_lifecycle(['BEGIN;', 'CREATE TABLE t(id INT); COMMIT;'], ['ROLLBACK;'])['status'], 'needs_review')
        self.assertEqual(inspect_lifecycle(['BEGIN;', 'BEGIN;'], ['ROLLBACK;'])['status'], 'needs_review')

    def test_update_from_does_not_assume_rhs_belongs_to_target(self):
        self.check('UPDATE t SET payload = src_col FROM src;', 'needs_review', 'query_unknown',
                   self.setup + ['CREATE TABLE src (src_col INT);'])

    def test_replace_values_and_set(self):
        self.check('REPLACE INTO t (id,payload) VALUES (1,2),(3,4);', 'checked')
        self.check('REPLACE t SET payload = payload + 1;', 'checked')

    def test_insert_default_uses_proven_absence_and_nullable_ddl(self):
        self.check('INSERT INTO t (id) VALUES (DEFAULT);', 'checked')
        self.check('INSERT INTO t (id) VALUES (DEFAULT);', 'needs_review', 'default_unknown',
                   setup=['CREATE TABLE t (id INT DEFAULT vendor_fn());'])

    def test_complex_or_external_sources_remain_unknown(self):
        self.check('WITH c AS (SELECT 1) UPDATE t SET id=1;', 'needs_review')
        self.check('UPDATE external_table SET x=1;', 'needs_review')
        self.check('INSERT INTO t (id) SELECT x FROM external_table;', 'needs_review')

    def test_missing_rhs_column_is_rejected(self):
        self.check('UPDATE t SET payload = missing;', 'rejected', 'missing_column')

    def test_conflicting_ddl_is_not_a_proof(self):
        self.check('UPDATE t SET id=1;', 'needs_review', setup=self.setup + ['CREATE TABLE t (id TEXT);'])

    def test_indented_fixture_ddl_uses_normalized_offsets(self):
        self.check('INSERT INTO t (id) VALUES (1);', 'checked', setup=['  \n CREATE TABLE t (id INT);'])

    def test_insert_select_tail_preserves_shape_checks(self):
        self.check('INSERT INTO t (id) SELECT id FROM t WHERE id > 0 RETURNING id;', 'checked')
        self.check('INSERT INTO t (id,payload) SELECT id FROM t ON CONFLICT (id) DO NOTHING;', 'rejected', 'arity')
        self.check('INSERT INTO t (id) SELECT id FROM t JOIN other USING(id);', 'needs_review')

    def test_insert_target_alias_resolves_qualified_columns(self):
        self.check('INSERT INTO t AS dst (dst.id,dst.payload) VALUES (1,2);', 'checked')
        self.check('INSERT INTO t AS dst (other.id) VALUES (1);', 'needs_review', 'qualifier_unknown')
        self.check('INSERT INTO t AS dst (dst.missing) VALUES (1);', 'rejected', 'missing_column')

    def test_update_from_literal_does_not_require_rhs_resolution(self):
        self.check("UPDATE t SET note='changed' FROM src WHERE t.id=src.id;", 'checked',
                   setup=self.setup + ['CREATE TABLE src (id INT);'])
        self.check('UPDATE t SET payload=src_col FROM src;', 'needs_review', 'query_unknown',
                   setup=self.setup + ['CREATE TABLE src (src_col INT);'])

    def test_finite_select_cte_projection_and_explicit_names(self):
        self.check('WITH c AS (SELECT id,payload FROM t) INSERT INTO t (id,payload) SELECT * FROM c;', 'checked')
        self.check('WITH c(x,y) AS (SELECT id,payload FROM t), d AS (SELECT x,y FROM c) INSERT INTO t(id,payload) SELECT x,y FROM d;', 'checked')
        self.check('WITH c AS (SELECT id FROM t) INSERT INTO t (id,payload) SELECT * FROM c;', 'rejected', 'arity')
        self.check('WITH c(x,y) AS (SELECT id FROM t) INSERT INTO t(id) SELECT x FROM c;', 'needs_review')

    def test_cte_unsupported_scope_stays_unknown(self):
        self.check('WITH RECURSIVE c AS (SELECT id FROM t) INSERT INTO t(id) SELECT id FROM c;', 'needs_review')
        self.check('WITH c AS (DELETE FROM t WHERE id=1 OR id=2 RETURNING id) INSERT INTO t(id) SELECT id FROM c;', 'needs_review')
        self.check('WITH c AS (SELECT id FROM later), later AS (SELECT id FROM t) UPDATE t SET id=1;', 'needs_review')

    def test_finite_delete_cte_has_explicit_inner_scope(self):
        result = inspect_write('WITH c AS (DELETE FROM t RETURNING id) INSERT INTO t(id) SELECT id FROM c;', self.setup)
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('dml_cte:delete_no_predicate', result['checks'])

    def test_cte_is_not_a_writable_fixture(self):
        self.check('WITH c AS (SELECT id FROM t) UPDATE c SET id=1;', 'needs_review')

    def test_insert_all_checks_each_target_against_query_output(self):
        self.check('INSERT ALL INTO t (id,payload) VALUES (id,payload) SELECT id,payload FROM t;', 'checked')
        self.check('INSERT FIRST WHEN id > 0 THEN INTO t(id) VALUES(id) WHEN id > 1 THEN INTO t(payload) VALUES(id) SELECT id FROM t;', 'checked')
        self.check('INSERT ALL INTO t(id,payload) VALUES(id) SELECT id FROM t;', 'rejected', 'arity')
        self.check('INSERT ALL INTO t(id) VALUES(payload) SELECT id FROM t;', 'rejected', 'missing_column')
        self.check('INSERT ALL INTO t(id) VALUES(id) INTO unknown(id) VALUES(id) SELECT id FROM t;', 'needs_review')

    def test_update_inheritance_marker_keeps_finite_target_columns(self):
        self.check('UPDATE t * SET payload=1;', 'checked')
        self.check('UPDATE t * AS dst SET dst.payload=1;', 'checked')

    def test_multiple_targets_only_with_explicit_alias_and_literal(self):
        setup = self.setup + ['CREATE TABLE aux (note TEXT);']
        self.check("UPDATE t AS x, aux AS a SET x.note='one', a.note='two';", 'checked', setup=setup)
        self.check("UPDATE t AS x, aux AS a SET a.missing='two';", 'rejected', 'missing_column', setup)
        self.check("UPDATE t AS x, aux AS a SET note='two';", 'needs_review', setup=setup)
        self.check('UPDATE t AS x, aux AS a SET x.note=a.note;', 'needs_review', setup=setup)

    def test_cleanup_requires_owned_transaction_not_name_prefix(self):
        r = inspect_lifecycle(['CREATE SCHEMA fp_test;'], ['DROP SCHEMA fp_test CASCADE;'])
        self.assertEqual(r['status'], 'needs_review')
        r = inspect_lifecycle(['BEGIN;', 'CREATE SCHEMA fp_test;'], ['ROLLBACK;'])
        self.assertEqual(r['status'], 'transaction_scoped')
        r = inspect_lifecycle(['BEGIN;', 'COMMIT;'], ['DROP OWNED BY mike;'])
        self.assertEqual(r['status'], 'needs_review')


class RenderedContractIntegrationTests(unittest.TestCase):
    def test_positive_generation_rejects_rendered_partition_key_overflow(self):
        from core.factor_package_model import FactorPackageRegistry
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        registry.load_all()
        profile = next(p for p in registry.matrices['matrix_update_set_profiles'].profiles
                       if p.id == 'update_set_partition_int')
        profile.render = 'col_2 = 42'
        with self.assertRaisesRegex(GenerationValidationError, 'partition_out_of_range'):
            FactorPackageSQLGenerator(registry).generate_with_report(
                registry.manifests['manifest_update_partition_positive'])


if __name__ == '__main__':
    unittest.main()
