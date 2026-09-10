"""Documented target restrictions are independent of conflict RHS/defaults.

PDF general INSERT: view/subquery restrictions item 7; M INSERT: view item 6.
These checks detect a forbidden feature/target pair, not a runtime SQLSTATE.
"""
import unittest

from core.finite_sql_contract import inspect_write
from scripts.audit_rendered_sql_contracts import audit_report


class ViewConflictTargetContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT, qty INT DEFAULT 7)',
             'CREATE VIEW v AS SELECT id,qty FROM t']

    def inspect(self, sql, scope='general', setup=None):
        return inspect_write(sql, self.setup if setup is None else setup,
                             conflict_source_scope=scope)

    def assert_forbidden(self, result):
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'view_duplicate_not_supported')

    def test_named_view_restriction_does_not_depend_on_assignment_expression(self):
        for scope in ('general', 'm_compat'):
            for expr in ('3', 'VALUES(qty)', 'DEFAULT', 'qty+1'):
                with self.subTest(scope=scope, expr=expr):
                    self.assert_forbidden(self.inspect(
                        'INSERT INTO v VALUES(1,2) ON DUPLICATE KEY UPDATE qty='+expr, scope))

    def test_general_derived_target_has_its_own_documented_restriction(self):
        self.assert_forbidden(self.inspect('INSERT INTO (SELECT id,qty FROM t) '
                                          'VALUES(1,2) ON DUPLICATE KEY UPDATE qty=3'))

    def test_unknown_input_default_does_not_hide_known_target_restriction(self):
        self.assert_forbidden(self.inspect('INSERT INTO v VALUES(1,DEFAULT) '
                                          'ON DUPLICATE KEY UPDATE qty=3'))

    def test_m_optional_into_and_set_share_target_guard(self):
        for sql in ('INSERT v VALUE(1,2)', 'INSERT INTO v SET id=1,qty=2'):
            self.assert_forbidden(self.inspect(sql+' ON DUPLICATE KEY UPDATE qty=3', 'm_compat'))

    def test_multiline_and_alias_preserve_top_level_clause_identity(self):
        self.assert_forbidden(self.inspect('INSERT INTO v AS dst(id,qty) VALUES(1,2) '
                                          'ON\nDUPLICATE\tKEY UPDATE qty=3'))

    def test_plain_table_is_not_a_view_by_its_name(self):
        result = self.inspect('INSERT INTO v VALUES(1,2) ON DUPLICATE KEY UPDATE qty=3',
                              setup=['CREATE TABLE v(id INT,qty INT)'])
        self.assertEqual(result['status'], 'checked', result)

    def test_string_and_nested_expression_do_not_supply_top_level_clause(self):
        setup = ['CREATE TABLE t(id INT,qty TEXT)', 'CREATE VIEW v AS SELECT id,qty FROM t']
        for expr in ("'ON DUPLICATE KEY UPDATE qty=3'", "fn('ON DUPLICATE KEY UPDATE qty=3')"):
            result = self.inspect('INSERT INTO v VALUES(1,'+expr+')', setup=setup)
            self.assertNotEqual(result['status'], 'rejected', result)

    def test_plain_view_insert_is_still_finite_shape_only(self):
        result = self.inspect('INSERT INTO v VALUES(1,2)')
        self.assertEqual(result['status'], 'checked', result)
        self.assertEqual(result['scope'], 'finite_write_shape_only')

    def test_unproved_or_invalidated_view_identity_stays_review(self):
        for setup in (self.setup+['DROP VIEW v'],
                      ['CREATE TABLE t(id INT,qty INT)', 'CREATE VIEW v AS SELECT id,qty+1 FROM t']):
            result = self.inspect('INSERT INTO v VALUES(1,2) ON DUPLICATE KEY UPDATE qty=3', setup=setup)
            self.assertEqual(result['status'], 'needs_review', result)

    def test_unknown_scope_and_m_derived_do_not_borrow_general_evidence(self):
        for sql, scope in (('INSERT INTO v VALUES(1,2)', 'unreviewed'),
                           ('INSERT INTO (SELECT id,qty FROM t) VALUES(1,2)', 'm_compat')):
            result = self.inspect(sql+' ON DUPLICATE KEY UPDATE qty=3', scope)
            self.assertEqual(result['status'], 'needs_review', result)

    def test_audit_keeps_negative_expected_and_separate_execution_status(self):
        cases = [dict(case_id=fid, factor_id=fid, expected='error',
                      sql='INSERT INTO v VALUES(1,2) ON DUPLICATE KEY UPDATE qty=3',
                      setup_sqls=self.setup, teardown_sqls=[]) for fid in ('insert', 'm_insert')]
        result = audit_report({'manifests': {'view_negative': {'cases': cases}}})
        self.assertEqual(result['summary']['write_contract'], {'rejected': 2})
        self.assertEqual(result['summary']['positive_rejected'], 0)
        self.assertFalse(result['database_executed'])
        self.assertTrue(all(c['expected'] == 'error' for c in result['cases']))


if __name__ == '__main__':
    unittest.main()
