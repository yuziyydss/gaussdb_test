"""DEFAULT is a target-column operation, not a base-lineage substitution.

Source boundaries: local PDF INSERT column_name/DEFAULT; ALTER VIEW
SET/DROP DEFAULT has no actual effect. Neither proves general view default
inheritance. These are static regressions, not database execution evidence.
"""
import unittest

from core.finite_sql_contract import inspect_write


class DefaultTargetContractTests(unittest.TestCase):
    setup = [
        "CREATE TABLE t (id INT DEFAULT 7, note TEXT DEFAULT 'ok')",
        "CREATE VIEW v AS SELECT id,note FROM t",
    ]

    def assert_review(self, sql, setup=None):
        result = inspect_write(sql, self.setup if setup is None else setup)
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertIn('default_unknown', [i['code'] for i in result['issues']], result)
        self.assertNotIn('insert_omitted_base_columns', result['checks'])

    def test_view_omission_cannot_bypass_explicit_default_guard(self):
        for sql in (
            "INSERT INTO v(id,note) VALUES(DEFAULT,'x')",
            "INSERT INTO v(note) VALUES('x')",
            "INSERT INTO v(note) SELECT 'x'",
            "INSERT INTO v VALUES(1)",
            "INSERT INTO v SELECT 1",
            "UPDATE v SET id=DEFAULT",
        ):
            with self.subTest(sql=sql):
                self.assert_review(sql)

    def test_renamed_view_column_retains_target_identity(self):
        setup = [self.setup[0], 'CREATE VIEW v(k,label) AS SELECT id,note FROM t']
        self.assert_review("INSERT INTO v AS dst(dst.label) VALUES('x')", setup)

    def test_derived_target_has_the_same_omission_guard(self):
        for sql in (
            "INSERT INTO (SELECT id,note FROM t) (note) VALUES('x')",
            "INSERT INTO (SELECT id,note FROM t) VALUES(1)",
        ):
            with self.subTest(sql=sql):
                self.assert_review(sql)

    def test_complete_values_and_base_defaults_remain_finite(self):
        for sql in (
            "INSERT INTO v VALUES(1,'x')",
            "INSERT INTO v SELECT 1,'x'",
            "UPDATE v SET note='x'",
            "INSERT INTO t(note) VALUES('x')",
            "INSERT INTO t DEFAULT VALUES",
            "UPDATE t SET id=DEFAULT",
        ):
            with self.subTest(sql=sql):
                self.assertEqual(inspect_write(sql, self.setup)['status'], 'checked')

    def test_default_function_is_not_the_assignment_keyword(self):
        for expr in ('DEFAULT(id)', 'app.DEFAULT(id)', 'nextval(\'seq\')'):
            result = inspect_write('UPDATE t SET id='+expr, self.setup)
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertNotIn('shared_constant_or_null_defaults', result['checks'])

    def test_rendered_auditor_consumes_target_default_guard(self):
        from scripts.audit_rendered_sql_contracts import audit_report
        case = dict(case_id='default_target_regression', factor_id='insert',
                    expected='success', sql="INSERT INTO v(note) VALUES('x')",
                    setup_sqls=self.setup, teardown_sqls=[])
        result = audit_report({'manifests': {'regression': {'cases': [case]}}})
        self.assertEqual(result['summary']['write_contract'], {'needs_review': 1})
        self.assertEqual(result['summary']['positive_rejected'], 0)
        self.assertFalse(result['database_executed'])

    def test_unknown_default_states_do_not_become_inherited_null(self):
        for default in ('', ' DEFAULT NULL', ' DEFAULT 7', " DEFAULT nextval('s')"):
            setup = [f'CREATE TABLE t(id INT{default}, note TEXT)', self.setup[1]]
            with self.subTest(default=default):
                self.assert_review("INSERT INTO v(note) VALUES('x')", setup)


if __name__ == '__main__':
    unittest.main()
