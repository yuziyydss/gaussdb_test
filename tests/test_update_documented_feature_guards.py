"""General UPDATE L16 and L177-178 need actual target and SET context."""
import unittest
from unittest.mock import patch
from core.finite_sql_contract import inspect_write


class UpdateDocumentedFeatureGuardTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT,note TEXT,qty INT)',
             'CREATE TABLE s(id INT,label TEXT,amount INT)',
             'CREATE VIEW v AS SELECT id,note,qty FROM t']

    def inspect(self, sql, scope='general', setup=None):
        return inspect_write(sql, self.setup if setup is None else setup, conflict_source_scope=scope)

    def test_multi_column_subquery_top_level_order_or_limit_is_forbidden(self):
        for clause in ('ORDER BY id', 'LIMIT 1', 'ORDER BY id LIMIT 1'):
            with self.subTest(clause=clause):
                result = self.inspect('UPDATE t SET (note,qty)=(SELECT label,amount FROM s '+clause+')')
                self.assertEqual(result['status'], 'rejected', result)
                self.assertEqual(result['issues'][0]['code'], 'multi_column_subquery_order_limit_not_supported')

    def test_single_column_subquery_can_keep_its_documented_order_and_limit(self):
        for lhs in ('qty', '(qty)'):
            result = self.inspect('UPDATE t SET '+lhs+'=(SELECT amount FROM s ORDER BY id LIMIT 1)')
            self.assertEqual(result['status'], 'checked', result)

    def test_plain_tuple_and_outer_order_limit_are_not_the_subquery_clause(self):
        for sql in ("UPDATE t SET (note,qty)=('x',2) ORDER BY id LIMIT 1",
                    'UPDATE t SET (note,qty)=(SELECT label,amount FROM s) ORDER BY id LIMIT 1'):
            result = self.inspect(sql)
            self.assertEqual(result['status'], 'checked', result)

    def test_m_or_unreviewed_source_does_not_borrow_general_update_restrictions(self):
        for scope in ('m_compat', 'unreviewed'):
            result = self.inspect('UPDATE t SET (note,qty)=(SELECT label,amount FROM s ORDER BY id LIMIT 1)',scope)
            self.assertNotEqual(result['status'],'rejected',result)
        # M's own L16 now supplies view evidence; unknown sources still do not.
        result=self.inspect("UPDATE v AS u,s AS a SET u.note='x'",'unreviewed')
        self.assertNotEqual(result['status'],'rejected',result)

    def test_dml_cte_preserves_outer_source_scope_in_recursive_inspection(self):
        sql = ('WITH c AS (UPDATE t SET (note,qty)=(SELECT label,amount FROM s ORDER BY id LIMIT 1) '
               'RETURNING note,qty) INSERT INTO t (note,qty) SELECT note,qty FROM c')
        result = self.inspect(sql)
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'multi_column_subquery_order_limit_not_supported')
        for scope in ('m_compat', 'unreviewed'):
            # Keeping the outer scope must not borrow either the general
            # UPDATE restriction or the newer general RETURNING proof.
            with patch('core.finite_sql_contract.inspect_write', wraps=inspect_write) as recursive:
                result = self.inspect(sql, scope)
                recursive.assert_called_once()
                self.assertEqual(recursive.call_args.kwargs['conflict_source_scope'], scope)
                self.assertTrue(recursive.call_args.args[0].startswith('UPDATE t SET'))
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertEqual(result['issues'][0]['code'], 'returning_source_unknown')
            control = 'UPDATE t SET (note,qty)=(SELECT label,amount FROM s ORDER BY id LIMIT 1)'
            self.assertEqual(self.inspect(control, scope)['status'], 'checked')

    def test_known_view_target_is_forbidden_in_multi_table_update(self):
        result = self.inspect("UPDATE v AS u,s AS a SET u.note='x'")
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'multi_update_view_not_supported')

    def test_single_view_update_and_plain_multi_target_do_not_gain_a_ban(self):
        for sql in ("UPDATE v SET note='x'", "UPDATE t AS u,s AS a SET u.note='x'"):
            result = self.inspect(sql)
            self.assertEqual(result['status'], 'checked', result)
            self.assertEqual(result['scope'], 'finite_write_shape_only')

    def test_table_called_view_and_unproved_view_identity_are_distinct(self):
        tables = ['CREATE TABLE v(id INT,note TEXT,qty INT)', self.setup[1]]
        result = self.inspect("UPDATE v AS u,s AS a SET u.note='x'", setup=tables)
        self.assertEqual(result['status'], 'checked', result)
        result = self.inspect("UPDATE v AS u,s AS a SET u.note='x'", setup=self.setup+['DROP VIEW v'])
        self.assertEqual(result['status'], 'needs_review', result)

    def test_literal_or_nested_order_is_not_top_level_subquery_order(self):
        for sql in ("UPDATE t SET (note,qty)=('ORDER BY id LIMIT 1',2)",
                    'UPDATE t SET (note,qty)=(SELECT label,amount FROM (SELECT label,amount FROM s ORDER BY id LIMIT 1) q)'):
            result = self.inspect(sql)
            self.assertNotIn('multi_column_subquery_order_limit_not_supported', [i['code'] for i in result['issues']])


if __name__ == '__main__':
    unittest.main()
