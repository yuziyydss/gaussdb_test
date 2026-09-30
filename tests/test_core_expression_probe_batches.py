"""Core expression probe batches are dry-run only and fully cover the plan."""
import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_probe_batches import build_core_expression_probe_batches_payload

ROOT = Path(__file__).resolve().parents[1]
OUTPUT_PATH = ROOT / 'generated/core_expression_probe_batches_v1/batches.json'


class CoreExpressionProbeBatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.payload = build_core_expression_probe_batches_payload(ROOT)
        cls.plan = cls.payload

    def test_94_probes_split_into_four_batches(self):
        self.assertEqual(self.plan['summary']['probe_plan_step_count'], 94)
        self.assertEqual(self.plan['summary']['batch_count'], 4)
        self.assertEqual(self.plan['summary']['batched_step_count'], 94)
        self.assertEqual(self.plan['summary']['unbatched_step_count'], 0)
        self.assertEqual(
            self.plan['summary']['batch_step_counts'],
            {
                'batch_01_scalar_types_conditionals': 23,
                'batch_02_strings_and_conversion': 20,
                'batch_03_structured_types': 31,
                'batch_04_aggregates_windows_datetime': 20,
            },
        )

    def test_batches_do_not_claim_runtime_evidence(self):
        self.assertFalse(self.plan['summary']['database_executed'])
        self.assertFalse(self.plan['summary']['execution_authorized'])
        self.assertEqual(self.plan['summary']['runtime_verified_count'], 0)
        for batch in self.plan['batches']:
            with self.subTest(batch=batch['id']):
                self.assertFalse(batch['database_executed'])
                self.assertFalse(batch['runtime_verified'])
                self.assertEqual(batch['execution_policy'], 'requires_explicit_authorization')

    def test_batch_candidate_ids_and_orders_are_unique(self):
        all_ids = []
        for batch in self.plan['batches']:
            ids = [step['candidate_id'] for step in batch['steps']]
            self.assertEqual(len(ids), len(set(ids)))
            self.assertEqual([step['batch_order'] for step in batch['steps']], list(range(1, len(ids) + 1)))
            self.assertEqual(batch['step_count'], len(ids))
            all_ids.extend(ids)
        self.assertEqual(len(all_ids), 94)
        self.assertEqual(len(all_ids), len(set(all_ids)))

    def test_every_step_is_single_read_only_fixture_free_sql(self):
        for batch in self.plan['batches']:
            for step in batch['steps']:
                with self.subTest(batch=batch['id'], step=step['candidate_id']):
                    self.assertTrue(step['sql'].endswith(';'))
                    self.assertEqual(step['sql'].count(';'), 1)
                    self.assertTrue(step['sql'].upper().startswith(('SELECT ', 'WITH ')))
                    self.assertEqual(step['fixture_ref'], 'no_fixture')
                    self.assertEqual(step['compatibility_mode'], 'any')
                    self.assertEqual(step['oracle_status'], 'needs_verification')
                    self.assertEqual(step['execution_status'], 'not_executed')
                    for forbidden in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
                        self.assertNotIn(forbidden, step['sql'].upper())

    def test_batch_plan_hash_is_stable(self):
        expected_hash = hashlib.sha256(
            json.dumps(
                {key: value for key, value in self.plan.items() if key != 'plan_sha256'},
                ensure_ascii=False,
                sort_keys=True,
                separators=(',', ':'),
            ).encode('utf-8')
        ).hexdigest()
        self.assertEqual(self.plan['plan_sha256'], expected_hash)

    def test_written_batches_are_current(self):
        self.assertTrue(OUTPUT_PATH.is_file())
        self.assertEqual(json.loads(OUTPUT_PATH.read_text(encoding='utf-8')), self.plan)

    def test_build_check_detects_drift(self):
        original = OUTPUT_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['batched_step_count'] += 1
            OUTPUT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_probe_batches.py'), '--check'],
                cwd=ROOT,
                text=True,
                capture_output=True,
            )
            self.assertEqual(result.returncode, 1)
            self.assertIn('artifact drift', result.stdout)
        finally:
            OUTPUT_PATH.write_text(original, encoding='utf-8')


if __name__ == '__main__':
    unittest.main()
