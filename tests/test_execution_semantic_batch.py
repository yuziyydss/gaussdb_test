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
