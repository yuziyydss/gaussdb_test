"""The quality queue is an evidence inventory, never a completion shortcut."""
import unittest
from scripts.build_quality_backlog import collect_audit_gaps, summarize_items, find_entity


class QualityBacklogTests(unittest.TestCase):
    def audit(self):
        return {
            'facts': {'unresolved': ['q1'], 'unconsumed_confirmed': [], 'wrong_consumer_type': [], 'unledgered': []},
            'values': {'coverage_gaps': ['v1']},
            'rules': {'gaps': ['r1']},
            'documented_features': {'coverage_gaps': ['f1']},
            'scenarios': {'non_ready': ['s1'], 'missing_required_fact_coverage': []},
            'manifests': {'errors': [], 'pairwise_incomplete': [], 'generated_case_count': 1,
                          'unresolved_error_oracles': ['m1'],
                          'duplicate_case_ids': [], 'duplicate_sql': []},
            'source_units': {'unmapped': [], 'atomicity': {'gaps': []}, 'line_coverage': {'missing': []}},
        }

    def test_preserves_all_gap_kinds(self):
        gaps = collect_audit_gaps(self.audit())
        self.assertEqual({k for k, _ in gaps}, {
            'unresolved_fact', 'value_gap', 'rule_gap', 'feature_gap',
            'scenario_pending', 'error_oracle_pending'})

    def test_raw_evidence_not_coerced_to_success(self):
        a = self.audit()
        a['manifests']['errors'] = ['m2: missing fixture']
        a['source_units']['atomicity']['gaps'] = [{'id': 'u1', 'reasons': ['compound']}]
        gaps = collect_audit_gaps(a)
        self.assertIn(('generation_error', 'm2: missing fixture'), gaps)
        self.assertIn(('source_atomicity', {'id': 'u1', 'reasons': ['compound']}), gaps)

    def test_issue_counts_are_not_factor_coverage(self):
        items = [{'factor_id': 'a', 'kind': 'feature_gap'},
                 {'factor_id': 'a', 'kind': 'feature_gap'},
                 {'factor_id': 'b', 'kind': 'scenario_pending'}]
        s = summarize_items(items)
        self.assertEqual(s['issue_count'], 3)
        self.assertEqual(s['factors_with_issues'], 2)
        self.assertEqual(s['by_kind']['feature_gap'], 2)
        self.assertNotIn('pass_rate', s)

    def test_missing_audit_sections_fail_loudly(self):
        with self.assertRaises(KeyError):
            collect_audit_gaps({})

    def test_markdown_keeps_generation_and_asset_rows_separate(self):
        from scripts.build_quality_backlog import render_markdown, FAMILIES
        factors = [
            {'factor_id': 'generated_example', 'candidate_cases': 2, 'manifest_count': 1,
             'gap_counts': {k: 1 for k in FAMILIES}, 'progress': {'static_status': 'gaps'}},
            {'factor_id': 'asset_example', 'candidate_cases': 0, 'manifest_count': 0,
             'asset_route': {'label': '模型输入', 'readiness': 'not_assessed'}},
        ]
        rendered = render_markdown({'factors': factors})
        self.assertIn('| generated_example | 2 |', rendered)
        self.assertIn('| asset_example | 模型输入 | not_assessed |', rendered)
        self.assertNotIn('| asset_example | 0 |', rendered)
        self.assertIn('不是通过率', rendered)

    def test_dimension_qualified_value_has_actionable_source(self):
        entities = {'grant_any_select_table': ('factor.yaml', {'fact_refs': ['f1'], 'render': 'SELECT ANY TABLE'})}
        path, data = find_entity('any_privilege.grant_any_select_table', entities, 'fallback.yaml')
        self.assertEqual(path, 'factor.yaml')
        self.assertEqual(data['fact_refs'], ['f1'])

    def test_exact_id_wins_over_dotted_suffix(self):
        entities = {'a.b': ('exact.yaml', {}), 'b': ('suffix.yaml', {})}
        self.assertEqual(find_entity('a.b', entities, 'fallback')[0], 'exact.yaml')

    def test_rule_reason_preserves_entity_and_original_gap_evidence(self):
        entities = {'r1': ('factor.yaml', {'id': 'r1', 'fact_refs': ['f1']})}
        evidence = 'r1: not targeted by a negative manifest'
        self.assertEqual(find_entity(evidence, entities, 'fallback')[1]['id'], 'r1')
        a = self.audit(); a['rules']['gaps'] = [evidence]
        self.assertIn(('rule_gap', evidence), collect_audit_gaps(a))
        self.assertEqual(find_entity('external::r1', entities, 'fallback'), ('fallback', {}))

    def test_static_blocking_fact_and_source_gaps_are_not_dropped(self):
        a = self.audit()
        a['facts'].update(unconsumed_confirmed=['f1'], wrong_consumer_type=['f2'], unledgered=['f3'])
        a['source_units']['line_coverage']['missing'] = [10]
        gaps = collect_audit_gaps(a)
        for pair in [('unconsumed_fact', 'f1'), ('wrong_fact_consumer', 'f2'),
                     ('unledgered_fact', 'f3'), ('source_missing_line', 10)]:
            self.assertIn(pair, gaps)

    def test_cohorts_keep_no_case_packages_out_of_generated_denominator(self):
        from scripts.build_quality_backlog import summarize_cohorts
        factors = [{'factor_id': 'a', 'candidate_cases': 2}, {'factor_id': 'b', 'candidate_cases': 0}]
        items = [{'factor_id': 'a', 'kind': 'value_gap'}, {'factor_id': 'a', 'kind': 'value_gap'},
                 {'factor_id': 'b', 'kind': 'no_manifest'}]
        result = summarize_cohorts(factors, items)
        self.assertEqual(result['with_candidates']['factor_count'], 1)
        self.assertEqual(result['with_candidates']['by_kind'], {'value_gap': 2})
        self.assertEqual(result['with_candidates']['affected_by_family']['values'], 1)
        self.assertEqual(result['without_candidates']['factor_count'], 1)
        self.assertNotIn('pass_rate', result['with_candidates'])

    def test_asset_routing_is_complete_unique_and_not_support_verification(self):
        from scripts.build_quality_backlog import asset_routes_by_factor
        factors = [{'factor_id': 'a', 'manifest_count': 0}, {'factor_id': 'b', 'manifest_count': 1}]
        routes = {'groups': [{'id': 'assets', 'label': '外部资产', 'count': 1, 'members': ['a'],
                             'evidence': 'doc', 'next_action': 'prepare', 'acceptance': 'verify'}]}
        result = asset_routes_by_factor(factors, routes)
        self.assertEqual(set(result), {'a'})
        self.assertEqual(result['a']['readiness'], 'not_assessed')
        self.assertNotIn('supported', result['a'])
        routes['groups'][0]['members'] = ['b']
        with self.assertRaises(ValueError): asset_routes_by_factor(factors, routes)
        routes['groups'][0]['members'] = ['a','a'];routes['groups'][0]['count'] = 2
        with self.assertRaises(ValueError): asset_routes_by_factor(factors, routes)


if __name__ == '__main__':
    unittest.main()
