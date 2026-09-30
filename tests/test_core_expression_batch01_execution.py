"""Batch 01 execution plan and receipt schema remain strict and auditable."""
import copy
import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_batch01_execution import (
    build_core_expression_batch01_execution_plan,
    build_core_expression_batch01_execution_plan_payload,
    audit_core_expression_batch01_receipt,
    verify_core_expression_batch01_execution_plan,
)

ROOT = Path(__file__).resolve().parents[1]
PLAN_PATH = ROOT / 'generated/core_expression_probe_batches_v1/batch_01_execution_plan.json'


class CoreExpressionBatch01ExecutionPlanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_core_expression_batch01_execution_plan(ROOT)
        cls.payload = build_core_expression_batch01_execution_plan_payload(ROOT)

    def test_plan_binds_to_batch_01_with_23_steps(self):
        self.assertEqual(self.plan.batch_id, 'batch_01_scalar_types_conditionals')
        self.assertEqual(len(self.plan.steps), 23)
        self.assertEqual(self.plan.source.step_count, 23)
        self.assertEqual([step.step_order for step in self.plan.steps], list(range(1, 24)))
        self.assertEqual(len({step.candidate_id for step in self.plan.steps}), 23)

    def test_plan_sql_is_single_read_only_fixture_free(self):
        for step in self.plan.steps:
            with self.subTest(step=step.candidate_id):
                self.assertTrue(step.sql.endswith(';'))
                self.assertEqual(step.sql.count(';'), 1)
                self.assertTrue(step.sql.upper().startswith(('SELECT ', 'WITH ')))
                self.assertEqual(step.fixture_ref, 'no_fixture')
                self.assertEqual(step.compatibility_mode, 'any')
                self.assertEqual(step.oracle_status, 'needs_verification')
                for forbidden in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
                    self.assertNotIn(forbidden, step.sql.upper())

    def test_plan_hash_and_written_artifact_are_stable(self):
        expected_hash = hashlib.sha256(
            json.dumps(
                self.plan.model_dump(mode='json'),
                ensure_ascii=False,
                sort_keys=True,
                separators=(',', ':'),
            ).encode('utf-8')
        ).hexdigest()
        self.assertEqual(self.payload['plan_sha256'], expected_hash)
        self.assertTrue(PLAN_PATH.is_file())
        self.assertEqual(json.loads(PLAN_PATH.read_text(encoding='utf-8')), self.payload)
        verify_core_expression_batch01_execution_plan(ROOT)

    def test_build_check_detects_drift(self):
        original = PLAN_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['steps'][0]['sql'] = "SELECT 'tampered' AS value;"
            PLAN_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_batch01_execution_plan.py'), '--check'],
                cwd=ROOT,
                text=True,
                capture_output=True,
            )
            self.assertEqual(result.returncode, 1)
            self.assertIn('artifact drift', result.stdout)
        finally:
            PLAN_PATH.write_text(original, encoding='utf-8')


class CoreExpressionBatch01ReceiptAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_core_expression_batch01_execution_plan(ROOT)
        cls.payload = build_core_expression_batch01_execution_plan_payload(ROOT)
        cls.expected_hash = cls.payload['plan_sha256']

    def valid_receipt(self):
        steps = []
        for step in self.plan.steps:
            steps.append({
                'step_order': step.step_order,
                'candidate_id': step.candidate_id,
                'sql': step.sql,
                'status': 'success',
                'rows': [[1]],
                'notices': [],
                'error': '',
                'sqlstate': '00000',
                'duration_ms': 1,
            })
        return {
            'kind': 'core_expression_batch01_runtime_receipt',
            'schema_version': 1,
            'profile': 'core_expression_batch01_execution_plan_v1',
            'batch_id': 'batch_01_scalar_types_conditionals',
            'status': 'runtime_verified',
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
            'plan_sha256': self.expected_hash,
            'plan_step_ids': [step.candidate_id for step in self.plan.steps],
            'plan_step_count': 23,
            'executed_steps': 23,
            'runtime_verified_steps': 23,
            'failed_steps': 0,
            'steps': steps,
            'limits': [],
        }

    def test_valid_receipt_passes_audit(self):
        audit = audit_core_expression_batch01_receipt(
            self.valid_receipt(),
            plan=self.plan,
            expected_plan_sha256=self.expected_hash,
        )
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)
        self.assertEqual(audit.summary, {
            'plan_steps': 23,
            'executed_steps': 23,
            'runtime_verified_steps': 23,
            'failed_steps': 0,
        })

    def test_missing_expected_hash_fails_closed(self):
        audit = audit_core_expression_batch01_receipt(self.valid_receipt(), plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn('expected plan hash not supplied', audit.errors[0])

    def test_plan_hash_mismatch_fails(self):
        receipt = self.valid_receipt()
        receipt['plan_sha256'] = '0' * 64
        audit = audit_core_expression_batch01_receipt(receipt, plan=self.plan, expected_plan_sha256=self.expected_hash)
        self.assertFalse(audit.valid)
        self.assertIn('plan hash mismatch', audit.errors[0])

    def test_step_sql_drift_fails(self):
        receipt = self.valid_receipt()
        receipt['steps'][0]['sql'] = "SELECT 'tampered' AS value;"
        audit = audit_core_expression_batch01_receipt(receipt, plan=self.plan, expected_plan_sha256=self.expected_hash)
        self.assertFalse(audit.valid)
        self.assertIn('step 1: SQL mismatch', audit.errors)

    def test_unauthorized_receipt_is_rejected_by_schema(self):
        receipt = self.valid_receipt()
        receipt['execution_authorized'] = False
        audit = audit_core_expression_batch01_receipt(receipt, plan=self.plan, expected_plan_sha256=self.expected_hash)
        self.assertFalse(audit.valid)
        self.assertIn('receipt schema validation failed', audit.errors[0])
        self.assertIn('runtime receipt must claim database execution and authorization', audit.errors[0])

    def test_partial_failure_stops_execution(self):
        receipt = self.valid_receipt()
        receipt['steps'] = receipt['steps'][:3]
        receipt['steps'][2]['status'] = 'failed'
        receipt['steps'][2]['error'] = 'simulated failure'
        receipt['steps'][2]['rows'] = []
        receipt['status'] = 'failed'
        receipt['executed_steps'] = 3
        receipt['runtime_verified_steps'] = 2
        receipt['failed_steps'] = 1
        audit = audit_core_expression_batch01_receipt(receipt, plan=self.plan, expected_plan_sha256=self.expected_hash)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)
        self.assertEqual(audit.summary['failed_steps'], 1)

    def test_step_after_failure_is_rejected(self):
        receipt = self.valid_receipt()
        receipt['steps'][2]['status'] = 'failed'
        receipt['steps'][2]['error'] = 'simulated failure'
        receipt['steps'][2]['rows'] = []
        receipt['status'] = 'failed'
        receipt['runtime_verified_steps'] = 2
        receipt['failed_steps'] = 1
        audit = audit_core_expression_batch01_receipt(receipt, plan=self.plan, expected_plan_sha256=self.expected_hash)
        self.assertFalse(audit.valid)
        self.assertIn('receipt schema validation failed', audit.errors[0])
        self.assertIn('execution must stop on first failed step', audit.errors[0])

    def test_audit_cli_writes_report(self):
        import tempfile
        from scripts.audit_core_expression_batch01_receipt import main as audit_main
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            receipt_path = root / 'receipt.json'
            plan_path = root / 'plan.json'
            output_path = root / 'audit.json'
            receipt_path.write_text(json.dumps(self.valid_receipt(), ensure_ascii=False), encoding='utf-8')
            plan_path.write_text(json.dumps(self.payload, ensure_ascii=False), encoding='utf-8')
            audit_main([
                '--receipt', str(receipt_path),
                '--plan', str(plan_path),
                '--output', str(output_path),
            ])
            payload = json.loads(output_path.read_text(encoding='utf-8'))
            self.assertTrue(payload['valid'])
            self.assertTrue(payload['plan_verified'])


if __name__ == '__main__':
    unittest.main()
