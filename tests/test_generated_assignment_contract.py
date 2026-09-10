"""Generated-column input identity, not evaluation or database error evidence.

Local PDF: M INSERT L15–16; M UPDATE L14–15; M CREATE TABLE L441–458.
General INSERT/UPDATE contain the same prohibition on direct generated writes.
"""
import unittest

from core.finite_sql_contract import inspect_write


class GeneratedAssignmentContractTests(unittest.TestCase):
    ddl = 'CREATE TABLE t(id INT, qty INT, g INT GENERATED ALWAYS AS (id + qty) STORED)'

    def check(self, sql, status, code=None, setup=None):
        result = inspect_write(sql, setup or [self.ddl])
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [item['code'] for item in result['issues']], result)
        return result

    def test_explicit_generated_values_and_null_are_rejected(self):
        for expr in ('99', 'NULL', 'id', 'id + 1'):
            for sql in (f'INSERT INTO t VALUES(1,2,{expr})', f'UPDATE t SET g={expr}'):
                with self.subTest(sql=sql):
                    self.check(sql, 'rejected', 'generated_column_write')

    def test_reordered_columns_tuple_update_and_query_use_same_guard(self):
        for sql in ('INSERT INTO t(g,id,qty) VALUES(99,1,2)',
                    'INSERT INTO t(g,id,qty) SELECT 99,1,2',
                    'UPDATE t AS dst SET dst.g=99',
                    'UPDATE t SET (id,g)=(1,99)',
                    'UPDATE t SET g=(SELECT 99)'):
            with self.subTest(sql=sql):
                self.check(sql, 'rejected', 'generated_column_write')

    def test_default_without_proved_inputs_stays_review_not_an_invented_null(self):
        finite = self.check('INSERT INTO t VALUES(1,2,DEFAULT)', 'checked')
        self.assertIn('stored_generated_integer_sum', finite['checks'])
        self.assertNotIn('shared_constant_or_null_defaults', finite['checks'])
        for sql in ('UPDATE t SET g=DEFAULT', 'INSERT INTO t DEFAULT VALUES'):
            with self.subTest(sql=sql):
                result = self.check(sql, 'needs_review', 'generated_default_unknown')
                self.assertNotIn('shared_constant_or_null_defaults', result['checks'])

    def test_omission_requires_proved_inputs_not_an_ordinary_nullable_column(self):
        finite = self.check('INSERT INTO t(id,qty) VALUES(1,2)', 'checked')
        self.assertIn('stored_generated_integer_sum', finite['checks'])
        for sql in ('INSERT INTO t(id,qty) SELECT 1,2',):
            with self.subTest(sql=sql):
                self.check(sql, 'needs_review', 'generated_default_unknown')

    def test_m_abbreviated_and_storage_variants_keep_generated_identity(self):
        for definition in ('AS (id + qty)', 'AS (id + qty) VIRTUAL',
                           'GENERATED ALWAYS AS (id + qty)',
                           'GENERATED ALWAYS AS (id + qty) STORED'):
            with self.subTest(definition=definition):
                setup = [f'CREATE TABLE t(id INT, qty INT, g INT {definition})']
                self.check('UPDATE t SET g=99', 'rejected', 'generated_column_write', setup)
                self.check('UPDATE t SET g=DEFAULT', 'needs_review', 'generated_default_unknown', setup)

    def test_view_and_derived_targets_do_not_acquire_fake_writability(self):
        self.check('UPDATE v SET g=99', 'needs_review',
                   setup=[self.ddl, 'CREATE VIEW v AS SELECT id,qty,g FROM t'])
        self.check('UPDATE (SELECT id,qty,g FROM t) SET g=99', 'needs_review')

    def test_keywords_in_column_name_or_default_literal_are_not_generated_identity(self):
        setup = ["CREATE TABLE t(g INT, generated TEXT DEFAULT 'AS (g) STORED')"]
        self.check('UPDATE t SET g=99', 'checked', setup=setup)

    def test_ordinary_assignments_and_defaults_remain_unchanged(self):
        self.check('UPDATE t SET id=99', 'checked')
        setup = ['CREATE TABLE t(id INT DEFAULT 7, qty INT DEFAULT NULL)']
        self.check('INSERT INTO t DEFAULT VALUES', 'checked', setup=setup)
        self.check('UPDATE t SET qty=DEFAULT', 'checked', setup=setup)

    def test_ddl_invalidation_prevents_stale_generated_contradiction(self):
        self.check('UPDATE t SET g=99', 'needs_review',
                   setup=[self.ddl, 'ALTER TABLE t DROP COLUMN g'])
        self.check('UPDATE t SET g=99', 'checked',
                   setup=[self.ddl, 'DROP TABLE t', 'CREATE TABLE t(g INT)'])


if __name__ == '__main__':
    unittest.main()
