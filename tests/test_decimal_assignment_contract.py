"""Exact representation is local evidence, not a rounding or execution oracle."""
import unittest

from core.finite_sql_contract import inspect_write
from core.shared_column_contract import ordinary_columns


class DecimalAssignmentContractTests(unittest.TestCase):
    marker = 'shared_exact_decimal_literals'

    def inspect(self, sql, ddl='CREATE TABLE t (x NUMERIC(5,2))', extra=()):
        result = inspect_write(sql, [ddl, *extra])
        self.assertEqual(result['scope'], 'finite_write_shape_only')
        return result

    def test_decimal_ddl_preserves_explicit_contract_and_default(self):
        for typ in ('NUMERIC', 'DECIMAL'):
            columns = ordinary_columns(f'CREATE TABLE t (x {typ}(5,2) DEFAULT 1.23)')
            self.assertIsNotNone(columns)
            self.assertEqual((columns['x']['precision'], columns['x']['scale']), (5, 2))
            self.assertEqual(columns['x']['default_state'], 'constant')
            self.assertEqual(columns['x']['default_sql'], '1.23')
            self.assertEqual(columns['x']['origin'], ('t', 'x'))

    def test_explicit_literals_share_precision_limits(self):
        for sql in ('INSERT INTO t VALUES (1000.00)', 'UPDATE t SET x=-1000',
                    'INSERT INTO t SELECT 1000.00', 'UPDATE t SET x=(SELECT 1000.00)',
                    'UPDATE t SET (x)=(1000.00)', 'INSERT INTO t VALUES (1),(1000)'):
            with self.subTest(sql=sql):
                result = self.inspect(sql)
                self.assertEqual(result['status'], 'needs_review', result)
                self.assertEqual(result['issues'][0]['code'], 'decimal_range_unknown')

    def test_exact_boundaries_and_zero_normalization(self):
        for typ in ('NUMERIC', 'DECIMAL'):
            for value in ('999.99', '-999.99', '0', '+000.0100', '-0.0000', '1'):
                for sql in (f'INSERT INTO t VALUES ({value})', f'UPDATE t SET x={value}'):
                    result = self.inspect(sql, f'CREATE TABLE t (x {typ}(5,2))')
                    self.assertEqual(result['status'], 'checked', result)
                    self.assertIn(self.marker, result['checks'])
        for typ, value in [('NUMERIC(2,2)', '0.99'), ('DECIMAL(2,0)', '99.000')]:
            self.assertIn(self.marker, self.inspect('UPDATE t SET x='+value,
                          f'CREATE TABLE t (x {typ})')['checks'])

    def test_rounding_is_not_simulated(self):
        for value in ('1.234', '999.995', '-1.235'):
            result = self.inspect('INSERT INTO t VALUES ('+value+')')
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertEqual(result['issues'][0]['code'], 'decimal_rounding_unknown')
            self.assertNotIn(self.marker, result['checks'])

    def test_defaults_share_exact_value_check_but_not_view_default_semantics(self):
        ddl = 'CREATE TABLE t (x NUMERIC(5,2) DEFAULT 1.23)'
        for sql in ('INSERT INTO t DEFAULT VALUES', 'INSERT INTO t VALUES (DEFAULT)',
                    'UPDATE t SET x=DEFAULT'):
            result = self.inspect(sql, ddl)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('shared_constant_or_null_defaults', result['checks'])
        for default, code in [('1000.00', 'decimal_range_unknown'), ('1.234', 'decimal_rounding_unknown')]:
            result = self.inspect('UPDATE t SET x=DEFAULT',
                                  f'CREATE TABLE t (x DECIMAL(5,2) DEFAULT {default})')
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertEqual(result['issues'][0]['code'], code)
        result = self.inspect('UPDATE v SET y=DEFAULT', ddl, ['CREATE VIEW v(y) AS SELECT x FROM t'])
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['issues'][0]['code'], 'default_unknown')

    def test_view_lineage_uses_actual_base_typmod(self):
        extra = ['CREATE VIEW v(y) AS SELECT x FROM t']
        for sql in ('INSERT INTO v VALUES (1000)', 'UPDATE v SET y=1000.00'):
            result = self.inspect(sql, extra=extra)
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertEqual(result['issues'][0]['code'], 'decimal_range_unknown')
        result = self.inspect('UPDATE v SET y=1.23', extra=extra)
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn(self.marker, result['checks'])

    def test_no_evidence_or_value_evaluation_means_no_new_proof(self):
        for typ in ('NUMERIC', 'DECIMAL', 'NUMERIC(5)', 'DECIMAL(0,0)',
                    'NUMERIC(5,6)', 'NUMERIC(1001,2)', 'REAL', 'FLOAT'):
            self.assertNotIn(self.marker, self.inspect('UPDATE t SET x=1.23',
                             f'CREATE TABLE t (x {typ})')['checks'])
        for sql in ('UPDATE t SET x=x+1', 'INSERT INTO t SELECT x FROM t',
                    "UPDATE t SET x='1.23'", 'UPDATE t SET x=1.23::numeric(5,2)',
                    'UPDATE t SET x=1e2', 'INSERT INTO t SELECT DEFAULT'):
            self.assertNotIn(self.marker, self.inspect(sql)['checks'])
        for extra in (['ALTER TABLE t ALTER COLUMN x TYPE NUMERIC(2,0)'],
                      ['SET search_path TO another'], ['ROLLBACK']):
            self.assertNotIn(self.marker, self.inspect('UPDATE t SET x=1.23', extra=extra)['checks'])

    def test_large_literals_are_bounded_without_float_or_int_conversion(self):
        result = self.inspect('UPDATE t SET x='+'9'*5000+'.00')
        self.assertEqual(result['issues'][0]['code'], 'decimal_range_unknown')
        result = self.inspect('UPDATE t SET x=+'+'0'*5000+'1.23000')
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn(self.marker, result['checks'])
        result = self.inspect('UPDATE t SET x='+'9'*1000, 'CREATE TABLE t (x NUMERIC(1000,0))')
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn(self.marker, result['checks'])
        self.assertIsNone(ordinary_columns('CREATE TABLE t (x NUMERIC('+'9'*5000+',0))'))


if __name__ == '__main__':
    unittest.main()
