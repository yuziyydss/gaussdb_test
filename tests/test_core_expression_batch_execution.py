"""Generic core-expression batch execution plans and receipt audits stay strict."""
import copy
import hashlib
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from core.core_expression_batch_execution import (
    build_core_expression_batch_execution_plan,
    build_core_expression_batch_execution_plan_payload,
    audit_core_expression_batch_receipt,
    plan_output_path,
    verify_core_expression_batch_execution_plan,
)

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {
    'batch_02_strings_and_conversion': 20,
    'batch_03_structured_types': 31,
    'batch_04_aggregates_windows_datetime': 20,
}


class CoreExpressionBatchExecutionPlanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plans = {}
        cls.payloads = {}
        for batch_id, step_count in EXPECTED.items():
            cls.plans[batch_id] = build_core_expression_batch_execution_plan(ROOT, batch_id)
            cls.payloads[batch_id] = build_core_expression_batch_execution_plan_payload(ROOT, batch_id)

    def test_batch02_03_04_are_bound_to_expected_steps(self):
        for batch_id, expected_count in EXPECTED.items():
            with self.subTest(batch=batch_id):
                plan = self.plans[batch_id]
                self.assertEqual(plan.batch_id, batch_id)
                self.assertEqual(len(plan.steps), expected_count)
                self.assertEqual(plan.source.step_count, expected_count)
                self.assertEqual([step.step_order for step in plan.steps], list(range(1, expected_count + 1)))
                self.assertEqual([step.batch_order for step in plan.steps], list(range(1, expected_count + 1)))
                self.assertEqual(len({step.candidate_id for step in plan.steps}), expected_count)

    def test_plans_are_single_read_only_fixture_free_sql(self):
        for batch_id, plan in self.plans.items():
            for step in plan.steps:
                with self.subTest(batch=batch_id, step=step.candidate_id):
                    self.assertTrue(step.sql.endswith(';'))
                    self.assertEqual(step.sql.count(';'), 1)
                    self.assertTrue(step.sql.upper().startswith(('SELECT ', 'WITH ')))
                    self.assertEqual(step.fixture_ref, 'no_fixture')
                    self.assertEqual(step.compatibility_mode, 'any')
                    self.assertEqual(step.oracle_status, 'needs_verification')
                    for forbidden in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
                        self.assertNotIn(forbidden, step.sql.upper())

    def test_plan_hash_and_written_artifacts_are_current(self):
        for batch_id, payload in self.payloads.items():
            with self.subTest(batch=batch_id):
                plan = self.plans[batch_id]
                expected_hash = hashlib.sha256(
                    json.dumps(plan.model_dump(mode='json'), ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
                ).hexdigest()
                self.assertEqual(payload['plan_sha256'], expected_hash)
                path = plan_output_path(ROOT, batch_id)
                self.assertTrue(path.is_file())
                self.assertEqual(json.loads(path.read_text(encoding='utf-8')), payload)
                self.assertEqual(verify_core_expression_batch_execution_plan(ROOT, batch_id), payload)

    def test_build_check_detects_drift(self):
        batch_id = 'batch_02_strings_and_conversion'
        path = plan_output_path(ROOT, batch_id)
        original = path.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['steps'][0]['sql'] = "SELECT 'tampered' AS value;"
            path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_batch_execution_plan.py'), '--batch-id', batch_id, '--check'],
                cwd=ROOT,
                text=True,
                capture_output=True,
            )
            self.assertEqual(result.returncode, 1)
            self.assertIn('artifact drift', result.stdout)
        finally:
            path.write_text(original, encoding='utf-8')


class CoreExpressionBatchReceiptAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plans = {
            batch_id: build_core_expression_batch_execution_plan(ROOT, batch_id)
            for batch_id in EXPECTED
        }
        cls.payloads = {
            batch_id: build_core_expression_batch_execution_plan_payload(ROOT, batch_id)
            for batch_id in EXPECTED
        }

    def valid_receipt(self, batch_id):
        plan = self.plans[batch_id]
        steps = [{
            'step_order': step.step_order,
            'candidate_id': step.candidate_id,
            'sql': step.sql,
            'status': 'success',
            'rows': [[1]],
            'notices': [],
            'error': '',
            'sqlstate': '00000',
            'duration_ms': 1,
        } for step in plan.steps]
        return {
            'kind': 'core_expression_batch_runtime_receipt',
            'schema_version': 1,
            'profile': 'core_expression_batch_execution_plan_v1',
            'batch_id': batch_id,
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
            'plan_sha256': self.payloads[batch_id]['plan_sha256'],
            'plan_step_ids': [step.candidate_id for step in plan.steps],
            'plan_step_count': len(plan.steps),
            'executed_steps': len(plan.steps),
            'runtime_verified_steps': len(plan.steps),
            'failed_steps': 0,
            'steps': steps,
            'limits': [],
        }

    def test_valid_receipts_pass_audit_for_every_batch(self):
        for batch_id in EXPECTED:
            with self.subTest(batch=batch_id):
                audit = audit_core_expression_batch_receipt(
                    self.valid_receipt(batch_id),
                    plan=self.plans[batch_id],
                    expected_plan_sha256=self.payloads[batch_id]['plan_sha256'],
                )
                self.assertTrue(audit.valid, audit.errors)
                self.assertTrue(audit.plan_verified)
                self.assertEqual(audit.batch_id, batch_id)
                self.assertEqual(audit.summary, {
                    'plan_steps': len(self.plans[batch_id].steps),
                    'executed_steps': len(self.plans[batch_id].steps),
                    'runtime_verified_steps': len(self.plans[batch_id].steps),
                    'failed_steps': 0,
                })

    def test_missing_expected_hash_fails_closed(self):
        batch_id = 'batch_02_strings_and_conversion'
        audit = audit_core_expression_batch_receipt(self.valid_receipt(batch_id), plan=self.plans[batch_id])
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn('expected plan hash not supplied', audit.errors[0])

    def test_plan_hash_and_sql_drift_fail(self):
        batch_id = 'batch_02_strings_and_conversion'
        receipt = self.valid_receipt(batch_id)
        receipt['plan_sha256'] = '0' * 64
        receipt['steps'][0]['sql'] = "SELECT 'tampered' AS value;"
        audit = audit_core_expression_batch_receipt(receipt, plan=self.plans[batch_id], expected_plan_sha256=self.payloads[batch_id]['plan_sha256'])
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertTrue(any('plan hash mismatch' in error for error in audit.errors))
        self.assertTrue(any('step 1: SQL mismatch' in error for error in audit.errors))

    def test_partial_failure_stops_execution(self):
        batch_id = 'batch_02_strings_and_conversion'
        receipt = self.valid_receipt(batch_id)
        receipt['steps'] = receipt['steps'][:3]
        receipt['steps'][2]['status'] = 'failed'
        receipt['steps'][2]['error'] = 'simulated failure'
        receipt['steps'][2]['rows'] = []
        receipt['status'] = 'failed'
        receipt['executed_steps'] = 3
        receipt['runtime_verified_steps'] = 2
        receipt['failed_steps'] = 1
        audit = audit_core_expression_batch_receipt(receipt, plan=self.plans[batch_id], expected_plan_sha256=self.payloads[batch_id]['plan_sha256'])
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)
        self.assertEqual(audit.summary, {
            'plan_steps': len(self.plans[batch_id].steps),
            'executed_steps': 3,
            'runtime_verified_steps': 2,
            'failed_steps': 1,
        })

    def test_step_after_failure_is_rejected_by_schema(self):
        batch_id = 'batch_02_strings_and_conversion'
        receipt = self.valid_receipt(batch_id)
        receipt['steps'][2]['status'] = 'failed'
        receipt['steps'][2]['error'] = 'simulated failure'
        receipt['steps'][2]['rows'] = []
        receipt['status'] = 'failed'
        receipt['runtime_verified_steps'] = 2
        receipt['failed_steps'] = 1
        audit = audit_core_expression_batch_receipt(receipt, plan=self.plans[batch_id], expected_plan_sha256=self.payloads[batch_id]['plan_sha256'])
        self.assertFalse(audit.valid)
        self.assertIn('receipt schema validation failed', audit.errors[0])
        self.assertIn('execution must stop on first failed step', audit.errors[0])

    def test_audit_cli_writes_report(self):
        batch_id = 'batch_02_strings_and_conversion'
        from scripts.audit_core_expression_batch_receipt import main as audit_main
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            receipt_path = root / 'receipt.json'
            plan_path = root / 'plan.json'
            output_path = root / 'audit.json'
            receipt_path.write_text(json.dumps(self.valid_receipt(batch_id), ensure_ascii=False), encoding='utf-8')
            plan_path.write_text(json.dumps(self.payloads[batch_id], ensure_ascii=False), encoding='utf-8')
            audit_main([
                '--batch-id', batch_id,
                '--receipt', str(receipt_path),
                '--plan', str(plan_path),
                '--output', str(output_path),
            ])
            payload = json.loads(output_path.read_text(encoding='utf-8'))
            self.assertTrue(payload['valid'])
            self.assertTrue(payload['plan_verified'])
            self.assertEqual(payload['batch_id'], batch_id)


if __name__ == '__main__':
    unittest.main()
