"""A CREATE snapshot cannot survive unexplained later fixture DDL."""
import unittest

from core.finite_sql_contract import inspect_write


class FixtureDDLFreshnessTests(unittest.TestCase):
    create = 'CREATE TABLE t (id INT);'

    def check(self, setup, sql='UPDATE t SET id=1;', status='needs_review'):
        result = inspect_write(sql, setup)
        self.assertEqual(result['status'], status, result)

    def test_alter_add_drop_and_type_changes_invalidate_old_columns(self):
        for alter, target in [
            ('ALTER TABLE t ADD note TEXT;', "UPDATE t SET note='x';"),
            ('ALTER TABLE t DROP COLUMN id;', 'UPDATE t SET id=1;'),
            ('ALTER TABLE ONLY t ALTER COLUMN id TYPE TEXT;', "UPDATE t SET id='x';"),
            ('ALTER TABLE IF EXISTS t ADD note TEXT;', 'UPDATE t SET id=1;'),
        ]:
            with self.subTest(alter=alter):
                self.check([self.create, alter], target)

    def test_drop_after_create_does_not_leave_writable_table(self):
        self.check([self.create, 'DROP TABLE t;'])
        self.check([self.create, 'DROP TABLE IF EXISTS t CASCADE;'])
        self.check([self.create, 'CREATE TABLE a(id INT);', 'DROP TABLE a,t;'])

    def test_drop_then_new_create_can_reestablish_new_shape(self):
        self.check(['DROP TABLE IF EXISTS t;', self.create], status='checked')
        self.check([self.create, 'DROP TABLE t;', 'CREATE TABLE t (note TEXT);'],
                   "UPDATE t SET note='x';", 'checked')
        self.check([self.create, 'ALTER TABLE t ADD note TEXT;', 'DROP TABLE t;', self.create],
                   status='checked')

    def test_unrelated_target_alter_or_drop_does_not_poison_table(self):
        for extra in ['ALTER TABLE a ADD note TEXT;', 'DROP TABLE a;']:
            self.check([self.create, 'CREATE TABLE a(id INT);', extra], status='checked')

    def test_renamed_target_cannot_reuse_old_name(self):
        self.check([self.create, 'ALTER TABLE t RENAME TO renamed;'])
        self.check([self.create, 'ALTER TABLE t RENAME TO renamed;'], 'UPDATE renamed SET id=1;')

    def test_duplicate_columns_and_conflicting_create_do_not_get_last_type(self):
        self.check(['CREATE TABLE t (id INT, ID TEXT);'], "UPDATE t SET id='x';")
        self.check([self.create, self.create])
        self.check([self.create, 'CREATE TABLE t (id TEXT);'], "UPDATE t SET id='x';")

    def test_multi_statement_or_commented_setup_not_single_create_proof(self):
        for setup in [[self.create + ' DROP TABLE t;'],
                      [self.create, 'SELECT 1; ALTER TABLE t DROP COLUMN id;'],
                      [self.create, '/* mutation */ DROP TABLE t;']]:
            with self.subTest(setup=setup):
                self.check(setup)

    def test_transaction_or_schema_reset_invalidates_prior_proof(self):
        self.check(['BEGIN;', self.create, 'ROLLBACK;'])
        self.check(['BEGIN;', self.create, 'ROLLBACK TO SAVEPOINT before_table;'])
        self.check(['CREATE TABLE s.t(id INT);', 'DROP SCHEMA s CASCADE;'], 'UPDATE s.t SET id=1;')

    def test_seed_values_and_quoted_semicolon_do_not_invalidate_shape(self):
        self.check(["CREATE TABLE t(id INT,note TEXT);",
                    "INSERT INTO t VALUES(1,'a; DROP TABLE t;');"], status='checked')


if __name__ == '__main__':
    unittest.main()
