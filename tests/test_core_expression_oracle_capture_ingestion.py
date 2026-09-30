"""Audited batch receipts ingest into capture slots with canonical hashes."""
import copy
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from core.core_expression_batch_execution import (
    build_core_expression_batch_execution_plan_payload,
)
from core.core_expression_oracle_capture import (
    build_core_expression_oracle_capture,
    canonical_evidence_sha256,
)
from core.core_expression_oracle_capture_ingestion import (
    ingest_core_expression_batch_receipt,
)

ROOT = Path(__file__).resolve().parents[1]
BATCH_ID = 'batch_02_strings_and_conversion'


class CoreExpressionOracleCaptureIngestionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan_payload = build_core_expression_batch_execution_plan_payload(ROOT, BATCH_ID)

    def valid_receipt(self, *, failure_at=None):
        plan = self.plan_payload
        steps = []
        for step in plan['steps']:
            failed = failure_at is not None and step['step_order'] == failure_at
            steps.append({
                'step_order': step['step_order'],
                'candidate_id': step['candidate_id'],
                'sql': step['sql'],
                'status': 'failed' if failed else 'success',
                'rows': [] if failed else [[1]],
                'notices': [],
                'error': 'simulated failure' if failed else '',
                'sqlstate': '42601' if failed else '00000',
                'duration_ms': 1,
            })
            if failed:
                break
        executed = len(steps)
        verified = executed - (1 if failure_at is not None else 0)
        return {
            'kind': 'core_expression_batch_runtime_receipt',
            'schema_version': 1,
            'profile': 'core_expression_batch_execution_plan_v1',
            'batch_id': BATCH_ID,
            'status': 'runtime_verified' if failure_at is None else 'failed',
            'database_executed': True,
            'execution_authorized': True,
            'connected_database': 'authorized_db',
            'connected_user': 'authorized_user',
            'server_version': 'test-version',
            'sql_compatibility': 'A',
            'started_at': '2026-09-29T00:00:00+08:00',
            'finished_at': '2026-09-29T00:00:01+08:00',
            'authorization': {
                'cli_authorized': True,
                'environment_authorized': True,
                'database_enabled': True,
                'gate_allowed': True,
                'preflight_audit_sha256': 'a' * 64,
            },
            'plan_sha256': plan['plan_sha256'],
            'plan_step_ids': [step['candidate_id'] for step in plan['steps']],
            'plan_step_count': len(plan['steps']),
            'executed_steps': executed,
            'runtime_verified_steps': verified,
            'failed_steps': 1 if failure_at is not None else 0,
            'steps': steps,
            'limits': [],
        }

    def test_full_successful_receipt_ingests_all_batch_slots(self):
        receipt = self.valid_receipt()
        ingestion = ingest_core_expression_batch_receipt(ROOT, BATCH_ID, receipt)
        self.assertTrue(ingestion.receipt_audit.valid)
        self.assertTrue(ingestion.receipt_audit.plan_verified)
        self.assertEqual(ingestion.summary.plan_step_count, 20)
        self.assertEqual(ingestion.summary.receipt_step_count, 20)
        self.assertEqual(ingestion.summary.ingested_capture_count, 20)
        self.assertEqual(ingestion.summary.captured_count, 20)
        self.assertEqual(ingestion.summary.capture_failed_count, 0)
        registry = ingestion.capture_registry
        self.assertEqual(registry.summary.captured_count, 20)
        self.assertEqual(registry.summary.pending_capture_count, 74)
        batch02 = [slot for slot in registry.capture_slots if slot.batch_id == BATCH_ID]
        self.assertTrue(all(slot.capture_status == 'captured' for slot in batch02))
        self.assertTrue(all(slot.evidence_sha256 for slot in batch02))
        self.assertTrue(all(slot.environment.is_complete() for slot in batch02))

    def test_partial_failure_ingests_stop_on_first_failure(self):
        receipt = self.valid_receipt(failure_at=3)
        ingestion = ingest_core_expression_batch_receipt(ROOT, BATCH_ID, receipt)
        self.assertEqual(ingestion.summary.receipt_step_count, 3)
        self.assertEqual(ingestion.summary.ingested_capture_count, 3)
        self.assertEqual(ingestion.summary.captured_count, 2)
        self.assertEqual(ingestion.summary.capture_failed_count, 1)
        registry = ingestion.capture_registry
        statuses = [slot.capture_status for slot in registry.capture_slots if slot.batch_id == BATCH_ID]
        self.assertEqual(statuses, ['captured', 'captured', 'capture_failed'] + ['pending_capture'] * 17)

    def test_ingested_evidence_hash_is_canonical(self):
        receipt = self.valid_receipt()
        ingestion = ingest_core_expression_batch_receipt(ROOT, BATCH_ID, receipt)
        for slot in ingestion.capture_registry.capture_slots:
            if slot.batch_id != BATCH_ID:
                continue
            with self.subTest(step=slot.candidate_id):
                self.assertEqual(slot.evidence_sha256, canonical_evidence_sha256(slot.canonical_evidence_payload()))

    def test_unverified_receipt_is_rejected(self):
        receipt = self.valid_receipt()
        receipt['plan_sha256'] = '0' * 64
        with self.assertRaisesRegex(ValueError, 'cannot ingest unverified receipt'):
            ingest_core_expression_batch_receipt(ROOT, BATCH_ID, receipt)

    def test_receipt_step_drift_is_rejected(self):
        receipt = self.valid_receipt()
        receipt['steps'][0]['sql'] = "SELECT 'tampered' AS value;"
        with self.assertRaisesRegex(ValueError, 'cannot ingest unverified receipt'):
            ingest_core_expression_batch_receipt(ROOT, BATCH_ID, receipt)

    def test_ingestion_cli_writes_report(self):
        import tempfile
        from scripts.ingest_core_expression_oracle_capture import main as ingest_main
        receipt = self.valid_receipt()
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            receipt_path = root / 'receipt.json'
            output_path = root / 'ingestion.json'
            receipt_path.write_text(json.dumps(receipt, ensure_ascii=False), encoding='utf-8')
            ingest_main([
                '--root', str(ROOT),
                '--batch-id', BATCH_ID,
                '--receipt', str(receipt_path),
                '--output', str(output_path),
            ])
            payload = json.loads(output_path.read_text(encoding='utf-8'))
            self.assertEqual(payload['summary']['ingested_capture_count'], 20)
            self.assertEqual(payload['summary']['captured_count'], 20)
            self.assertRegex(payload['ingestion_sha256'], r'[0-9a-f]{64}')


if __name__ == '__main__':
    unittest.main()
