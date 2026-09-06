import copy
import unittest

from core.progress_reporting import factor_progress, summarize_progress


class ProgressReportingTests(unittest.TestCase):
    def audit(self, count=3, static=True, errors=None):
        return {'manifests': {'generated_case_count': count, 'errors': errors or []},
                'conclusions': {'source_extraction_complete': True,
                                'generation_model_complete': True,
                                'static_coverage_complete': static,
                                'behavior_coverage_complete': True}}

    def test_no_cases_never_turns_into_static_or_runtime_success(self):
        p = factor_progress(self.audit(0))
        self.assertTrue(p['package_built'])
        self.assertFalse(p['has_candidates'])
        self.assertEqual(p['generation_status'], 'no_cases')
        self.assertEqual(p['static_status'], 'no_cases')
        self.assertIsNone(p['runtime_verified'])
        self.assertEqual(p['runtime_status'], 'not_connected')

    def test_candidates_do_not_imply_static_coverage(self):
        p = factor_progress(self.audit(static=False))
        self.assertTrue(p['has_candidates'])
        self.assertEqual(p['static_status'], 'gaps')
        self.assertEqual(p['runtime_status'], 'not_connected')

    def test_generation_errors_cannot_be_hidden_by_partial_cases(self):
        p = factor_progress(self.audit(errors=['failed manifest']))
        self.assertTrue(p['has_candidates'])
        self.assertEqual(p['generation_status'], 'partial')
        self.assertEqual(p['static_status'], 'gaps')

    def test_summary_keeps_denominator_and_does_not_mutate_legacy_audits(self):
        audits = {'a': self.audit(), 'b': self.audit(0), 'c': self.audit(static=False)}
        before = copy.deepcopy(audits)
        p = summarize_progress(audits)
        self.assertEqual(p['package_count'], 3)
        self.assertEqual(p['with_candidates_count'], 2)
        self.assertEqual(p['without_candidates_count'], 1)
        self.assertEqual(p['static_covered_count'], 1)
        self.assertIsNone(p['runtime_verified_count'])
        self.assertEqual(audits, before)
