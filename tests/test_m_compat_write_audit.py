"""M writes must expose actual finite-check limitations, not disappear from audit."""
import unittest

from scripts.audit_rendered_sql_contracts import audit_report


class MCompatWriteAuditTests(unittest.TestCase):
    def audit_case(self, factor_id, sql):
        case = dict(factor_id=factor_id, case_id='m_write_audit_regression',
                    sql=sql, setup_sqls=['CREATE TABLE t(id INT, qty INT)'],
                    teardown_sqls=['DROP TABLE t'], expected='success')
        return audit_report({'manifests': {'regression': {'cases': [case]}}})

    def test_supported_m_write_shapes_are_actually_inspected(self):
        for factor_id, sql in (
            ('m_insert', 'INSERT INTO t VALUES(1,2)'),
            ('m_update', 'UPDATE t SET qty=2'),
            ('m_replace', 'REPLACE INTO t VALUES(1,2)'),
        ):
            with self.subTest(factor_id=factor_id):
                result = self.audit_case(factor_id, sql)
                check = result['cases'][0]['write_contract']
                self.assertEqual(check['status'], 'checked', check)
                self.assertEqual(check['scope'], 'finite_write_shape_only')
                self.assertFalse(result['database_executed'])

    def test_m_only_syntax_stays_review_needed_not_silent_exclusion(self):
        result = self.audit_case('m_insert', 'INSERT INTO t SET id=1, qty=2')
        check = result['cases'][0]['write_contract']
        self.assertEqual(check['status'], 'needs_review', check)
        self.assertIn('syntax_unknown', [item['code'] for item in check['issues']])

    def test_real_m_shape_contradiction_remains_visible(self):
        result = self.audit_case('m_insert', 'INSERT INTO t(id) VALUES(1,2)')
        self.assertEqual(result['cases'][0]['write_contract']['status'], 'rejected')
        self.assertEqual(result['summary']['positive_rejected'], 1)

    def test_non_write_package_remains_outside_write_shape_scope(self):
        result = self.audit_case('m_select', 'SELECT id FROM t')
        self.assertEqual(result['cases'][0]['write_contract']['status'], 'not_applicable')


if __name__ == '__main__':
    unittest.main()
