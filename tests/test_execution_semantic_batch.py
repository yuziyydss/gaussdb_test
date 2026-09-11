"""The new review batch preserves generated candidates and visible blockers."""
import json
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.prepare_execution_batch import build_batch

ROOT = Path(__file__).resolve().parents[1]


class SemanticReviewBatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / 'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def test_semantic_batch_has_all_six_real_sequences_and_keeps_foreign_blockers(self):
        batch = build_batch(self.r, self.g, profile='semantic_contracts')
        self.assertEqual(batch['summary']['scenario_sequences'], 6)
        self.assertEqual(batch['summary']['unbound_candidate_ids'], [])
        units = {u['scenario_ref']: u for u in batch['units']}
        for suffix in ('conflict', 'new_key', 'outside'):
            unit = units['scenario_insert_partial_index_'+suffix]
            self.assertEqual(unit['static_blockers'], [])
            self.assertEqual(unit['steps'][0]['oracles'][0]['measurement_source'], 'target_command_affected_rows')
        foreign = units['scenario_alter_table_log_foreign_rls']
        self.assertNotIn('expected_mismatch:enable_foreign_rls', foreign['static_blockers'])
        self.assertEqual(foreign['steps'][0]['source_step']['expected'], 'error')
        self.assertTrue(foreign['static_blockers'])
        self.assertEqual(foreign['static_blockers'], ['physical_mode_unresolved'])
        parents = foreign['ownership_plan']['creates'][-1]['depends_on']
        self.assertEqual(parents, ['g_a3_at_log_ns', 'g_a3_log_server'])
        self.assertFalse(foreign['ownership_plan']['runtime_ownership_proven'])
        self.assertTrue(foreign['oracle_calibration_pending'])
        self.assertIn('CREATE SERVER', foreign['setup_sqls'][0])
        self.assertTrue(any('CREATE FOREIGN TABLE' in sql for sql in foreign['setup_sqls']))
        self.assertEqual(foreign['preparation_status'], 'blocked')
        self.assertIsNotNone(units['scenario_m_insert_generated_default_result']['m_environment_plan_ref'])
        self.assertTrue(all(not u['database_executed'] and not u['execution_authorized'] for u in units.values()))

    def test_all_candidate_fields_and_generation_coverage_match_published_baseline(self):
        batch = build_batch(self.r, self.g, profile='semantic_contracts')
        baseline = json.loads((ROOT/'generated/factor_packages/generation_report.json').read_text())
        original = {c['case_id']: c for m in baseline['manifests'].values() for c in m['cases']}
        for candidate in batch['candidates']:
            self.assertEqual(candidate, original[candidate['case_id']])
        for report in batch['generation_reports'].values():
            self.assertFalse(report['missing_pairs'])
        self.assertEqual(batch['summary']['bound_candidate_ids'], batch['summary']['candidates'])

    def test_unknown_profile_fails_instead_of_selecting_default(self):
        with self.assertRaisesRegex(ValueError, 'Unknown preparation profile'):
            build_batch(self.r, self.g, profile='typo')


if __name__ == '__main__':
    unittest.main()
