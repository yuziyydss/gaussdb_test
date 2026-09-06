"""Documented forms and narrow dependency retention, without runtime claims."""
import unittest

from core.finite_sql_contract import inspect_write


class SharedContractFollowthroughTests(unittest.TestCase):
    table = "CREATE TABLE t (id INT DEFAULT 7, note VARCHAR(8) DEFAULT 'ok')"
    view = 'CREATE VIEW v AS SELECT id,note FROM t'

    def check(self, sql, setup, status='checked', code=None):
        result = inspect_write(sql, setup)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [i['code'] for i in result['issues']], result)
        return result

    def test_default_values_accepts_explicit_and_reordered_base_columns(self):
        for sql in ('INSERT INTO t (note) DEFAULT VALUES',
                    'INSERT INTO t (note,id) DEFAULT VALUES RETURNING *',
                    'INSERT INTO t AS dst (dst.id) DEFAULT VALUES'):
            self.check(sql, [self.table])

    def test_default_values_checks_omitted_required_columns(self):
        self.check('INSERT INTO t (note) DEFAULT VALUES',
                   ["CREATE TABLE t (id INT NOT NULL, note TEXT DEFAULT 'ok')"],
                   'rejected', 'null_not_allowed')

    def test_default_values_still_checks_names_and_unknown_defaults(self):
        self.check('INSERT INTO t (missing) DEFAULT VALUES', [self.table], 'rejected', 'missing_column')
        self.check('INSERT INTO t (note,note) DEFAULT VALUES', [self.table], 'rejected', 'duplicate_column')
        self.check('INSERT INTO t (note) DEFAULT VALUES',
                   ["CREATE TABLE t (id INT DEFAULT f(), note TEXT DEFAULT 'ok')"], 'needs_review')
        self.check('INSERT INTO v (note) DEFAULT VALUES', [self.table, self.view], 'needs_review')

    def test_closed_direct_view_survives_unrelated_ordinary_table_ddl(self):
        for suffix in (['CREATE TABLE aux (id INT)'], ['DROP TABLE IF EXISTS aux CASCADE'],
                       ['DROP TABLE IF EXISTS aux CASCADE', 'CREATE TABLE aux (id INT)'],
                       ['DROP TABLE IF EXISTS aux RESTRICT']):
            with self.subTest(suffix=suffix):
                result = self.check("UPDATE v SET note='ok'", [self.table, self.view] + suffix)
                self.assertIn('single_base_direct_view_columns', result['checks'])

    def test_view_can_read_new_unrelated_query_source(self):
        self.check('INSERT INTO v (id,note) SELECT id,note FROM src',
                   [self.table, self.view, 'DROP TABLE IF EXISTS src CASCADE',
                    'CREATE TABLE src (id INT, note TEXT)'])

    def test_dependency_and_uncertain_namespace_changes_still_revoke(self):
        for suffix in (['DROP TABLE t CASCADE', self.table], ['DROP VIEW v'],
                       ['ALTER TABLE aux RENAME TO t'], ['DROP SCHEMA s CASCADE'],
                       ['DO opaque_code'], ['COMMIT'], ['CREATE TABLE aux AS SELECT * FROM t'],
                       ['CREATE TABLE aux (id INT REFERENCES t(id))']):
            self.check("UPDATE v SET note='ok'", [self.table, self.view] + suffix, 'needs_review')
        # An unqualified name could resolve to the schema-qualified dependency.
        self.check('UPDATE v SET id=1', ['CREATE TABLE s.t(id INT)',
                   'CREATE VIEW v AS SELECT id FROM s.t', 'DROP TABLE t CASCADE'], 'needs_review')
        self.check('UPDATE v SET id=1', ['CREATE TABLE t(id INT)',
                   'CREATE VIEW v AS SELECT id FROM t', 'DROP TABLE s.t CASCADE'], 'needs_review')

    def test_dynamic_base_default_does_not_form_closed_dependency_graph(self):
        self.check('UPDATE v SET id=1', ['CREATE TABLE t(id INT DEFAULT f())',
                   'CREATE VIEW v AS SELECT id FROM t', 'DROP TABLE aux CASCADE'], 'needs_review')

    def test_drop_with_multiple_or_unconsumed_targets_stays_unknown(self):
        for drop in ('DROP TABLE aux,t CASCADE', 'DROP TABLE aux CASCADE PURGE',
                     'DROP TABLE aux CASCADE; DROP VIEW v'):
            self.check("UPDATE v SET note='ok'", [self.table, self.view, drop], 'needs_review')


if __name__ == '__main__':
    unittest.main()
