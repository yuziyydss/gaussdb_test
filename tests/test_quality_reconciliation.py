import copy
import unittest
from scripts.reconcile_quality_round import reconcile_cases


class ReconciliationTests(unittest.TestCase):
    def report(self):
        return {'cases': [{'case_id': 'c1', 'factor_id': 'insert', 'manifest_id': 'm1',
                          'expected': 'success', 'write_contract': {'status': 'needs_review',
                          'issues': [{'code': 'default_unknown', 'detail': 'DEFAULT'}]}}]}

    def test_still_unknown_is_not_closed(self):
        report = self.report()
        result = reconcile_cases(report, report)
        self.assertEqual(result['dispositions'], {'still_requires_review': 1})
        self.assertTrue(result['rows'][0]['next_action'])
        self.assertFalse(result['rows'][0]['database_verified'])

    def test_dropped_cases_or_changed_expectations_cannot_improve_score(self):
        with self.assertRaises(ValueError):
            reconcile_cases(self.report(), {'cases': []})
        new = self.report()
        new['cases'][0]['expected'] = 'error'
        with self.assertRaises(ValueError):
            reconcile_cases(self.report(), new)

    def test_duplicate_id_is_error(self):
        new = self.report()
        new['cases'].append(copy.deepcopy(new['cases'][0]))
        with self.assertRaises(ValueError):
            reconcile_cases(self.report(), new)

    def test_checked_is_only_finite_shape_evidence(self):
        new = self.report()
        new['cases'][0]['write_contract'] = {'status': 'checked', 'issues': []}
        result = reconcile_cases(self.report(), new)
        self.assertEqual(result['dispositions'], {'finite_shape_evidence_added': 1})
        self.assertFalse(result['rows'][0]['database_verified'])

    def test_identity_and_expected_are_locked_for_every_prior_status(self):
        for status in ('checked', 'needs_review', 'rejected', 'not_applicable'):
            for field in ('factor_id', 'manifest_id', 'expected'):
                with self.subTest(status=status, field=field):
                    old = self.report()
                    old['cases'][0]['write_contract']['status'] = status
                    new = copy.deepcopy(old)
                    new['cases'][0][field] = 'changed'
                    with self.assertRaisesRegex(ValueError, 'Case identity changed'):
                        reconcile_cases(old, new)

    def test_evidence_withdrawal_cannot_disappear_behind_baseline_cohort(self):
        old = self.report()
        checked = copy.deepcopy(old['cases'][0])
        checked['case_id'] = 'c2'
        checked['write_contract'] = {'status': 'checked', 'issues': []}
        old['cases'].append(checked)
        new = copy.deepcopy(old)
        new['cases'][0]['write_contract'] = {'status': 'checked', 'issues': []}
        new['cases'][1]['write_contract'] = {'status': 'needs_review', 'issues': [
            {'code': 'fixture_unknown', 'detail': 'prior evidence invalidated'}]}
        result = reconcile_cases(old, new)
        # Existing cohort semantics stay intact, but no longer hide the new review.
        self.assertEqual(result['baseline_review_count'], 1)
        self.assertEqual(result['dispositions'], {'finite_shape_evidence_added': 1})
        self.assertEqual(result['identity_checked_cases'], 2)
        self.assertEqual(result['population_status_counts'], {
            'before': {'needs_review': 1, 'checked': 1},
            'after': {'checked': 1, 'needs_review': 1}})
        self.assertEqual(result['withdrawn_evidence_case_ids'], ['c2'])
        self.assertEqual(len(result['state_changes']), 2)
        self.assertTrue(all(not x['database_verified'] for x in result['state_changes']))

    def test_unknown_audit_status_is_not_silently_ignored(self):
        for side in ('before', 'after'):
            with self.subTest(side=side):
                old, new = self.report(), self.report()
                target = old if side == 'before' else new
                target['cases'][0]['write_contract']['status'] = 'made_up_pass'
                with self.assertRaisesRegex(ValueError, 'Unknown write-contract status'):
                    reconcile_cases(old, new)

    def test_fixture_followup_includes_invalidated_ordinary_ddl(self):
        old = self.report()
        old['cases'][0]['write_contract']['issues'][0]['code'] = 'fixture_unknown'
        result = reconcile_cases(old, old)
        self.assertIn('DDL', result['rows'][0]['next_action'][0])

    def test_lifecycle_withdrawal_is_independent_of_write_review_cohort(self):
        old = self.report()
        old['cases'][0]['write_contract'] = {'status': 'not_applicable', 'issues': []}
        old['cases'][0]['lifecycle'] = {'status': 'transaction_scoped', 'database_executed': False}
        new = copy.deepcopy(old)
        new['cases'][0]['lifecycle']['status'] = 'needs_review'
        result = reconcile_cases(old, new)
        self.assertEqual(result['baseline_review_count'], 0)
        self.assertEqual(result['state_changes'], [])
        lifecycle = result['lifecycle']
        self.assertEqual(lifecycle['withdrawn_evidence_case_ids'], ['c1'])
        self.assertEqual(lifecycle['population_status_counts'], {
            'before': {'transaction_scoped': 1}, 'after': {'needs_review': 1}})
        self.assertEqual(lifecycle['state_changes'][0]['case_id'], 'c1')
        self.assertFalse(lifecycle['state_changes'][0]['database_verified'])

    def test_legacy_missing_lifecycle_is_unavailable_not_pass(self):
        old, new = self.report(), self.report()
        new['cases'][0]['lifecycle'] = {'status': 'needs_review'}
        lifecycle = reconcile_cases(old, new)['lifecycle']
        self.assertEqual(lifecycle['population_status_counts'], {
            'before': {'unavailable': 1}, 'after': {'needs_review': 1}})
        self.assertEqual(lifecycle['withdrawn_evidence_case_ids'], [])
        self.assertEqual(lifecycle['scope'], 'static_lifecycle_shape_only')

    def test_missing_after_lifecycle_withdraws_prior_scoped_evidence(self):
        old, new = self.report(), self.report()
        old['cases'][0]['lifecycle'] = {'status': 'transaction_scoped'}
        lifecycle = reconcile_cases(old, new)['lifecycle']
        self.assertEqual(lifecycle['withdrawn_evidence_case_ids'], ['c1'])
        self.assertEqual(lifecycle['state_changes'][0]['after_status'], 'unavailable')

    def test_malformed_lifecycle_is_not_silent_legacy_compatibility(self):
        for malformed in (None, [], {}, {'status': 'success'}, {'status': []}):
            for side in ('before', 'after'):
                with self.subTest(malformed=malformed, side=side):
                    old, new = self.report(), self.report()
                    (old if side == 'before' else new)['cases'][0]['lifecycle'] = malformed
                    with self.assertRaisesRegex(ValueError, 'Invalid lifecycle status'):
                        reconcile_cases(old, new)
