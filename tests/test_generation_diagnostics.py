"""Explain audit layers without changing their meaning or inventing support."""
import copy
import json
from pathlib import Path
import unittest

from core.progress_reporting import factor_progress, summarize_progress


def audit():
    return {
        'manifests': {'total': 1, 'generated_case_count': 2, 'errors': [],
                      'pairwise_incomplete': [], 'duplicate_case_ids': [], 'duplicate_sql': [],
                      'unresolved_error_oracles': []},
        'values': {'coverage_gaps': [], 'unselected_by_validity': {},
                   'valid_without_positive': [], 'invalid_without_negative': []},
        'rules': {'gaps': []}, 'facts': {'unresolved': []},
        'conclusions': {'source_extraction_complete': True, 'generation_model_complete': True,
                        'static_coverage_complete': False, 'behavior_coverage_complete': False},
    }


class GenerationDiagnosticsTests(unittest.TestCase):
    def diagnostics(self, row):
        return factor_progress(row)['generation_diagnostics']

    def test_pending_oracle_is_not_a_generation_failure(self):
        row = audit(); row['manifests']['unresolved_error_oracles'] = ['negative_case']
        d = self.diagnostics(row)
        self.assertEqual(d['status'], 'satisfied')
        self.assertEqual(d['blockers'], [])
        self.assertEqual(d['unresolved_error_oracles'], ['negative_case'])
        self.assertEqual(factor_progress(row)['static_status'], 'gaps')
        self.assertIsNone(factor_progress(row)['runtime_verified'])

    def test_conditional_gaps_remain_visible_without_claiming_unsupported(self):
        row = audit(); row['conclusions']['generation_model_complete'] = False
        row['values'].update(coverage_gaps=['options.dop'],
                             unselected_by_validity={'conditional': ['options.dop']})
        row['facts']['unresolved'] = ['dop_document_conflict']
        d = self.diagnostics(row)
        self.assertEqual(d['status'], 'gaps')
        self.assertEqual(d['blockers'][0]['code'], 'conditional_values_unselected')
        self.assertEqual(d['blockers'][0]['items'], ['options.dop'])
        self.assertEqual(d['review_context_fact_refs'], ['dop_document_conflict'])
        self.assertNotIn('unsupported', d['blockers'][0]['code'])

    def test_value_reasons_partition_gaps_without_double_counting(self):
        row = audit(); row['conclusions']['generation_model_complete'] = False
        row['values'].update(coverage_gaps=['x.bad','x.good','x.conditional','x.unknown'],
            invalid_without_negative=['x.bad'], valid_without_positive=['x.good'],
            unselected_by_validity={'invalid':['x.bad'],'valid':['x.good'],
                                   'conditional':['x.conditional']})
        items = [i for b in self.diagnostics(row)['blockers'] for i in b['items']]
        self.assertCountEqual(items, row['values']['coverage_gaps'])
        self.assertEqual(len(items), len(set(items)))

    def test_rules_pairs_ids_and_errors_have_separate_reasons(self):
        row = audit(); row['conclusions']['generation_model_complete'] = False
        row['manifests'].update(errors={'m':'render failure'}, pairwise_incomplete=['m'],
                                 duplicate_case_ids=['duplicate'])
        row['rules']['gaps'] = ['r: missing negative target']
        codes = {b['code'] for b in self.diagnostics(row)['blockers']}
        self.assertEqual(codes, {'generation_errors','incomplete_pairs','duplicate_case_ids','rule_coverage_gaps'})

    def test_same_target_sql_with_distinct_setup_is_not_a_blocker(self):
        row = audit(); row['manifests'].update(duplicate_sql=['SELECT COUNT(*) FROM t'],duplicate_inputs=[])
        self.assertEqual(self.diagnostics(row)['status'], 'satisfied')
        row['manifests']['duplicate_inputs'] = ['SELECT COUNT(*) FROM t']
        row['conclusions']['generation_model_complete'] = False
        self.assertEqual(self.diagnostics(row)['blockers'][0]['code'], 'duplicate_inputs')

    def test_missing_diagnostics_and_inconsistent_flag_do_not_look_complete(self):
        row = audit(); del row['rules']
        self.assertEqual(self.diagnostics(row)['status'], 'unavailable')
        row = audit(); row['conclusions']['generation_model_complete'] = False
        self.assertEqual(self.diagnostics(row)['status'], 'inconsistent')
        row = audit(); row['rules']['gaps'] = ['uncovered']
        self.assertEqual(self.diagnostics(row)['status'], 'inconsistent')

    def test_zero_cases_is_neither_unsupported_nor_complete(self):
        row = audit(); row['manifests'].update(total=0,generated_case_count=0)
        row['conclusions']['generation_model_complete'] = False
        d = self.diagnostics(row)
        self.assertEqual(d['status'], 'no_cases')
        self.assertIn('no_candidates', [b['code'] for b in d['blockers']])

    def test_summary_counts_packages_separately_from_oracle_manifests(self):
        a = audit(); a['manifests']['unresolved_error_oracles'] = ['n1','n2']
        b = audit(); b['conclusions']['generation_model_complete'] = False
        b['rules']['gaps'] = ['rule_a','rule_b']
        before = copy.deepcopy({'a':a,'b':b})
        result = summarize_progress({'a':a,'b':b})
        self.assertEqual(result['generation_model_satisfied_count'],1)
        self.assertEqual(result['generation_model_gap_count'],1)
        self.assertEqual(result['unresolved_oracle_package_count'],1)
        self.assertEqual(result['unresolved_oracle_manifest_count'],2)
        self.assertEqual({'a':a,'b':b},before)

    def test_current_frozen_report_has_exact_explainable_blockers(self):
        path=Path(__file__).resolve().parents[1]/'generated/factor_packages/generation_report.json'
        rows=json.loads(path.read_text())['factor_coverage']
        for fid,row in rows.items():
            d=self.diagnostics(row)
            self.assertNotIn(d['status'],['unavailable','inconsistent'],fid)
            self.assertEqual(d['status']=='satisfied',row['conclusions']['generation_model_complete'],fid)
        pool=self.diagnostics(rows['create_resource_pool'])
        self.assertEqual(pool['blockers'][0]['code'],'conditional_values_unselected')
        self.assertEqual(self.diagnostics(rows['m_select'])['status'],'satisfied')
        summary=summarize_progress(rows)
        self.assertEqual(summary['unresolved_oracle_manifest_count'],sum(
            len(r['manifests']['unresolved_error_oracles']) for r in rows.values()))


if __name__=='__main__':unittest.main()
