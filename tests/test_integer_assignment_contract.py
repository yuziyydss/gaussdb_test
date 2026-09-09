"""Finite integer storage evidence is not a whole-statement execution proof."""
import unittest

from core.finite_sql_contract import inspect_write


class IntegerAssignmentContractTests(unittest.TestCase):
    def inspect(self, sql, ddl='CREATE TABLE t (x SMALLINT)', extra=()):
        result = inspect_write(sql, [ddl, *extra])
        self.assertEqual(result['scope'], 'finite_write_shape_only')
        return result

    def test_insert_update_and_select_literal_overflow_need_review(self):
        for sql in ('INSERT INTO t VALUES (40000)', 'UPDATE t SET x=-32769',
                    'INSERT INTO t SELECT 40000', 'UPDATE t SET x=(SELECT 40000)',
                    'INSERT INTO t VALUES (1),(40000)'):
            with self.subTest(sql=sql):
                result = self.inspect(sql)
                self.assertEqual(result['status'], 'needs_review', result)
                self.assertEqual(result['issues'][0]['code'], 'assignment_range_unknown')

    def test_signed_boundaries_are_shared(self):
        for typ, low, high in [('SMALLINT', -32768, 32767),
                               ('INTEGER', -2147483648, 2147483647),
                               ('BIGINT', -9223372036854775808, 9223372036854775807)]:
            for value in (low, high):
                for sql in (f'INSERT INTO t VALUES ({value})', f'UPDATE t SET x={value}'):
                    result = self.inspect(sql, f'CREATE TABLE t (x {typ})')
                    self.assertEqual(result['status'], 'checked', result)
                    self.assertIn('shared_integer_literal_ranges', result['checks'])
            result = self.inspect(f'INSERT INTO t VALUES ({high+1})', f'CREATE TABLE t (x {typ})')
            self.assertEqual(result['issues'][0]['code'], 'assignment_range_unknown')

    def test_view_renaming_preserves_actual_base_range(self):
        extra = ['CREATE VIEW v (renamed) AS SELECT x FROM t']
        for sql in ('INSERT INTO v VALUES (40000)', 'UPDATE v SET renamed=40000'):
            result = self.inspect(sql, extra=extra)
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertEqual(result['issues'][0]['code'], 'assignment_range_unknown')

    def test_unknown_values_and_opaque_ddl_do_not_gain_range_proof(self):
        for sql, ddl in [('UPDATE t SET x=x+1', 'CREATE TABLE t (x SMALLINT)'),
                         ('INSERT INTO t SELECT x FROM t', 'CREATE TABLE t (x SMALLINT)'),
                         ('INSERT INTO t VALUES (40000)', 'CREATE TABLE t (x SMALLINT) WITH (fillfactor=70)')]:
            result = self.inspect(sql, ddl)
            self.assertNotIn('shared_integer_literal_ranges', result['checks'])

    def test_default_route_and_sql_grammar_stay_separate(self):
        result = self.inspect('INSERT INTO t DEFAULT VALUES', 'CREATE TABLE t (x SMALLINT DEFAULT 40000)')
        self.assertEqual(result['issues'][0]['code'], 'default_range_unknown')
        self.assertEqual(self.inspect('INSERT INTO t SELECT DEFAULT')['status'], 'needs_review')
        self.assertEqual(self.inspect("UPDATE t SET x='1'")['issues'][0]['code'], 'conversion_unknown')

    def test_long_literals_do_not_crash_or_confuse_leading_zeros(self):
        result = self.inspect('UPDATE t SET x=' + '9'*5000)
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['issues'][0]['code'], 'assignment_range_unknown')
        result = self.inspect('UPDATE t SET x=+' + '0'*5000 + '1')
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('shared_integer_literal_ranges', result['checks'])


if __name__ == '__main__':
    unittest.main()
