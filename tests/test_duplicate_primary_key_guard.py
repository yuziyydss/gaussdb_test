"""General INSERT L332: positive inline-PK evidence, not an index catalog."""
import unittest
from core.finite_sql_contract import inspect_write


class DuplicatePrimaryKeyGuardTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT PRIMARY KEY,qty INT)']

    def inspect(self, sql, scope='general', setup=None):
        return inspect_write(sql, self.setup if setup is None else setup, conflict_source_scope=scope)

    def test_actual_primary_key_assignment_is_forbidden_for_every_rhs(self):
        for expression in ('3', 'VALUES(id)', 'DEFAULT', 'id', 'fn()'):
            result = self.inspect('INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE id='+expression)
            self.assertEqual(result['status'], 'rejected', result)
            self.assertEqual(result['issues'][0]['code'], 'duplicate_key_update_not_supported')

    def test_alias_and_actual_key_name_not_assumed_id(self):
        setup=['CREATE TABLE t(id INT,qty INT PRIMARY KEY)']
        result=self.inspect('INSERT INTO t AS dst VALUES(1,2) ON DUPLICATE KEY UPDATE dst.qty=3',setup=setup)
        self.assertEqual(result['status'],'rejected',result)
        self.assertEqual(result['issues'][0]['code'],'duplicate_key_update_not_supported')
        self.assertEqual(self.inspect('INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE id=3',setup=setup)['status'],'checked')

    def test_non_key_update_and_plain_update_do_not_borrow_conflict_rule(self):
        for sql in ('INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE qty=3',
                    'UPDATE t SET id=3',
                    'INSERT INTO t VALUES(1,2) ON CONFLICT(id) DO UPDATE SET id=3'):
            result=self.inspect(sql)
            self.assertEqual(result['status'],'checked',result)
            self.assertEqual(result['scope'],'finite_write_shape_only')

    def test_m_and_unknown_source_do_not_borrow_general_primary_key_ban(self):
        for scope in ('m_compat','unreviewed'):
            result=self.inspect('INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE id=3',scope)
            self.assertNotEqual(result['status'],'rejected',result)

    def test_default_string_does_not_create_primary_key_evidence(self):
        setup=["CREATE TABLE t(id INT,qty TEXT DEFAULT 'PRIMARY KEY')"]
        result=self.inspect("INSERT INTO t VALUES(1,'x') ON DUPLICATE KEY UPDATE id=3",setup=setup)
        self.assertEqual(result['status'],'checked',result)

    def test_changed_or_opaque_target_definition_stays_review(self):
        for setup in (self.setup+['ALTER TABLE t DROP CONSTRAINT any_key'],
                      self.setup+['DROP TABLE t'], self.setup+['DROP INDEX any_key CASCADE']):
            result=self.inspect('INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE id=3',setup=setup)
            self.assertEqual(result['status'],'needs_review',result)

    def test_literal_keyword_is_not_a_conflict_clause(self):
        setup=['CREATE TABLE t(id INT PRIMARY KEY,qty TEXT)']
        result=self.inspect("INSERT INTO t VALUES(1,'ON DUPLICATE KEY UPDATE id=3')",setup=setup)
        self.assertEqual(result['status'],'checked',result)


if __name__ == '__main__':
    unittest.main()
