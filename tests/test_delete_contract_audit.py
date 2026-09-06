import copy
import unittest
from scripts.audit_delete_contracts import audit_report


class DeleteContractAuditTests(unittest.TestCase):
    def report(self):
        return {'manifests': {'m': {'cases': [
            {'case_id': 'del1', 'factor_id': 'delete', 'expected': 'success',
             'sql': 'DELETE FROM t WHERE id=1', 'setup_sqls': ['CREATE TABLE t(id INT)'], 'teardown_sqls': []},
            {'case_id': 'other1', 'factor_id': 'update', 'expected': 'success',
             'sql': 'UPDATE t SET id=2', 'setup_sqls': ['CREATE TABLE t(id INT)'], 'teardown_sqls': []},
        ]}}}

    def test_selection_denominators_are_separate_and_input_is_not_changed(self):
        report = self.report()
        original = copy.deepcopy(report)
        result = audit_report(report)
        self.assertEqual(report, original)
        self.assertEqual(result['summary']['generation_population'], 2)
        self.assertEqual(result['summary']['delete_population'], 1)
        self.assertEqual(result['summary']['outside_delete_scope'], 1)
        self.assertEqual(result['summary']['delete_contract'], {'checked': 1})
        self.assertEqual(result['cases'][0]['case_id'], 'del1')
        self.assertEqual(result['cases'][0]['lifecycle']['status'], 'needs_review')
        self.assertFalse(result['database_executed'])

    def test_duplicate_global_case_id_is_an_error_even_outside_selected_scope(self):
        report = self.report()
        report['manifests']['m']['cases'][1]['case_id'] = 'del1'
        with self.assertRaises(ValueError):
            audit_report(report)

    def test_positive_contradiction_is_not_hidden_and_unknown_negative_is_not_passed(self):
        report = self.report()
        report['manifests']['m']['cases'][0]['sql'] = 'DELETE FROM t WHERE missing=1'
        result = audit_report(report)
        self.assertEqual(result['summary']['positive_rejected'], 1)
        case = report['manifests']['m']['cases'][0]
        case.update(expected='error', sql='DELETE FROM t,a USING b')
        result = audit_report(report)
        self.assertEqual(result['cases'][0]['delete_contract']['status'], 'needs_review')
        self.assertFalse(result['cases'][0]['target_error_verified'])

    def test_sql_and_setup_changes_are_visible_in_case_identity(self):
        report = self.report()
        before = audit_report(report)['cases'][0]['complete_case_sha256']
        report['manifests']['m']['cases'][0]['setup_sqls'].append('DROP TABLE t')
        result = audit_report(report)
        self.assertNotEqual(before, result['cases'][0]['complete_case_sha256'])
        self.assertEqual(result['cases'][0]['delete_contract']['status'], 'needs_review')


if __name__ == '__main__':
    unittest.main()
