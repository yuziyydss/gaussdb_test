"""The generation-gap disposition snapshot must match the current report."""
import json
from pathlib import Path
import unittest

from core.generation_gap_dispositions import load_generation_gap_dispositions

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / 'docs' / 'GENERATION_MODEL_REMAINING_20260920.json'


class GenerationGapDispositionInventoryTests(unittest.TestCase):
    def test_snapshot_matches_generation_report(self):
        report = json.loads((ROOT / 'generated/factor_packages/generation_report.json').read_text())
        payload = json.loads(JSON_PATH.read_text())
        dispositions = load_generation_gap_dispositions()
        self.assertIsNotNone(dispositions)
        self.assertEqual(report['generation_model_gap_count'], payload['remaining_count'])
        self.assertEqual({row['factor_ref'] for row in report['generation_model_gaps']}, set(dispositions))
        self.assertEqual(payload['with_manifest_count'], report['package_inventory']['with_manifest_count'])

    def test_every_gap_has_structured_disposition(self):
        report = json.loads((ROOT / 'generated/factor_packages/generation_report.json').read_text())
        payload = json.loads(JSON_PATH.read_text())
        self.assertEqual(len(report['generation_model_gaps']), 0)
        self.assertEqual(len(report['generation_model_gaps']), payload['remaining_count'])
        for row in report['generation_model_gaps']:
            with self.subTest(factor=row['factor_ref']):
                self.assertEqual(row['status'], 'generation_model_not_complete')
                self.assertTrue(row['blocking_category'])
                self.assertTrue(row['blocking_reason'])
                self.assertTrue(row['next_action'])
                self.assertTrue(row['value_gaps'] or row['feature_gaps'] or row['unresolved_fact_refs'])


if __name__ == '__main__':
    unittest.main()
