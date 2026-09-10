"""Conflict UPDATE defaults must not bypass the target-column contract."""
import unittest

from core.finite_sql_contract import inspect_write
from scripts.audit_rendered_sql_contracts import audit_report


class ConflictDefaultContractTests(unittest.TestCase):
    clauses = ('ON DUPLICATE KEY UPDATE qty = DEFAULT',
               'ON CONFLICT (id) DO UPDATE SET qty = DEFAULT')

    def inspect(self, clause, definition='INT DEFAULT 7'):
        return inspect_write('INSERT INTO t VALUES (1,2) '+clause,
                             ['CREATE TABLE t(id INT, qty '+definition+')'])

    def test_default_null_cannot_bypass_not_null_in_either_branch(self):
        for clause in self.clauses:
            with self.subTest(clause=clause):
                result = self.inspect(clause, 'INT NOT NULL DEFAULT NULL')
                self.assertEqual(result['status'], 'rejected', result)
                self.assertIn('null_not_allowed', [i['code'] for i in result['issues']])

    def test_dynamic_default_remains_unknown(self):
        for clause in self.clauses:
            result = self.inspect(clause, "INT DEFAULT app.next_value()")
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertIn('default_unknown', [i['code'] for i in result['issues']])

    def test_conflict_target_must_be_a_real_column(self):
        for clause in self.clauses:
            result = self.inspect(clause.replace('qty =', 'missing ='))
            self.assertEqual(result['status'], 'rejected', result)
            self.assertIn('missing_column', [i['code'] for i in result['issues']])

    def test_valid_default_records_shared_contract_consumption(self):
        for clause in self.clauses:
            result = self.inspect(clause)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('conflict_assignment_defaults', result['checks'])
            self.assertIn('shared_constant_or_null_defaults', result['checks'])

    def test_default_without_clause_does_not_require_conflict_evidence(self):
        result = inspect_write('INSERT INTO t VALUES(1,DEFAULT)',
                               ['CREATE TABLE t(id INT, qty INT DEFAULT 7)'])
        self.assertEqual(result['status'], 'checked', result)
        self.assertNotIn('conflict_assignment_defaults', result['checks'])

    def test_tuple_alias_and_multiple_input_rows_use_target_defaults(self):
        for sql in (
            'INSERT INTO t VALUES(1,2),(3,4) ON DUPLICATE KEY UPDATE (id,qty)=(1,DEFAULT)',
            'INSERT INTO t AS dst VALUES(1,2) ON CONFLICT(id) DO UPDATE SET dst.qty=DEFAULT',
            'INSERT INTO t SELECT 1,2 ON CONFLICT(id) DO UPDATE SET qty=DEFAULT',
        ):
            result = inspect_write(sql, ['CREATE TABLE t(id INT,qty INT NOT NULL DEFAULT NULL)'])
            self.assertEqual(result['status'], 'rejected', result)
            self.assertIn('null_not_allowed', [i['code'] for i in result['issues']])

    def test_complex_conflict_defaults_remain_review(self):
        for clause in (
            'ON CONFLICT((id+1)) DO UPDATE SET qty=DEFAULT',
            'ON CONFLICT ON CONSTRAINT keyname DO UPDATE SET qty=DEFAULT',
            'ON DUPLICATE KEY UPDATE qty=DEFAULT(qty)',
        ):
            self.assertEqual(self.inspect(clause)['status'], 'needs_review')
    def test_plain_view_defaults_remain_review_but_duplicate_target_is_forbidden(self):
        result = inspect_write('INSERT INTO v VALUES(1,DEFAULT)',
                               ['CREATE TABLE t(id INT,qty INT DEFAULT 7)',
                                'CREATE VIEW v AS SELECT id,qty FROM t'])
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertIn('default_unknown', [i['code'] for i in result['issues']])
        result = inspect_write('INSERT INTO v VALUES(1,2) '+self.clauses[0],
                               ['CREATE TABLE t(id INT,qty INT DEFAULT 7)',
                                'CREATE VIEW v AS SELECT id,qty FROM t'])
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'view_duplicate_not_supported')

    def test_keyword_in_string_does_not_activate_the_contract(self):
        result = inspect_write("INSERT INTO t VALUES(1,'x') ON DUPLICATE KEY UPDATE qty='DEFAULT'",
                               ['CREATE TABLE t(id INT,qty TEXT)'])
        self.assertEqual(result['status'], 'checked', result)
        self.assertNotIn('conflict_assignment_defaults', result['checks'])

    def test_real_audit_consumer_does_not_upgrade_oracle_or_execute(self):
        case = dict(case_id='conflict_default_target', factor_id='insert', expected='success',
                    sql='INSERT INTO t VALUES(1,2) '+self.clauses[0],
                    setup_sqls=['CREATE TABLE t(id INT,qty INT NOT NULL DEFAULT NULL)'],
                    teardown_sqls=[])
        result = audit_report({'manifests': {'test': {'cases': [case]}}})
        self.assertEqual(result['summary']['positive_rejected'], 1)
        self.assertFalse(result['database_executed'])


if __name__ == '__main__':
    unittest.main()
