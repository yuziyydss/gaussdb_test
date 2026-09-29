"""Oracle capture registry enforces evidence schema and never fakes results."""
import copy
import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_oracle_capture import (
    OracleCaptureStepDef,
    build_core_expression_oracle_capture,
    canonical_evidence_sha256,
    verify_core_expression_oracle_capture,
)

ROOT = Path(__file__).resolve().parents[1]
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_capture_v1/captures.json'


def captured_step():
    return OracleCaptureStepDef(
        oracle_id='oracle_test',
        candidate_id='candidate_test',
        batch_id='batch_01_scalar_types_conditionals',
        capability='numeric_type_domain',
        fact_refs=['fact_test'],
        sql='SELECT 1;',
        capture_status='captured',
        captured_at='2026-09-29T00:00:00+08:00',
        duration_ms=1,
        rows=[[1]],
        notices=[],
        error='',
        sqlstate='00000',
        environment={
            'server_version': 'test-version',
            'sql_compatibility': 'A',
            'connected_database': 'testdb',
            'connected_user': 'testuser',
        },
        evidence_sha256='0' * 64,
    )


class CoreExpressionOracleCaptureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = build_core_expression_oracle_capture(ROOT)

    def test_all_94_probe_steps_have_pending_capture_slots(self):
        self.assertEqual(self.registry.summary.probe_plan_step_count, 94)
        self.assertEqual(self.registry.summary.capture_slot_count, 94)
        self.assertEqual(self.registry.summary.pending_capture_count, 94)
        self.assertEqual(self.registry.summary.captured_count, 0)
        self.assertEqual(self.registry.summary.capture_failed_count, 0)
        self.assertEqual(self.registry.summary.evidence_count, 0)
        self.assertTrue(self.registry.summary.all_steps_have_capture_slots)
        self.assertFalse(self.registry.summary.database_executed)
        self.assertFalse(self.registry.summary.runtime_verified)
        self.assertEqual(len({item.oracle_id for item in self.registry.capture_slots}), 94)
        self.assertEqual(len({item.candidate_id for item in self.registry.capture_slots}), 94)

    def test_pending_slots_cannot_contain_evidence(self):
        payload = self.registry.model_dump(mode='json')
        payload['capture_slots'][0]['rows'] = [[1]]
        with self.assertRaisesRegex(ValueError, 'pending capture .* cannot contain captured evidence'):
            type(self.registry)(**payload)

        payload = copy.deepcopy(self.registry.model_dump())
        payload['capture_slots'][0]['evidence_sha256'] = 'a' * 64
        with self.assertRaisesRegex(ValueError, 'cannot contain evidence hash'):
            type(self.registry)(**payload)

    def test_captured_success_requires_complete_evidence(self):
        step = captured_step()
        expected_hash = canonical_evidence_sha256(step.canonical_evidence_payload())
        step.evidence_sha256 = expected_hash
        self.assertEqual(step.capture_status, 'captured')
        self.assertEqual(step.evidence_sha256, expected_hash)

        bad = step.model_copy(update={'rows': []})
        with self.assertRaisesRegex(ValueError, 'must contain rows'):
            bad.model_validate(bad.model_dump())

        bad = step.model_copy(update={'sqlstate': ''})
        with self.assertRaisesRegex(ValueError, 'must contain SQLSTATE'):
            bad.model_validate(bad.model_dump())

    def test_capture_failure_requires_error_and_sqlstate(self):
        step = captured_step().model_copy(update={
            'capture_status': 'capture_failed',
            'rows': [],
            'error': 'simulated failure',
            'sqlstate': '42601',
        })
        self.assertEqual(step.capture_status, 'capture_failed')

        bad = step.model_copy(update={'error': ''})
        with self.assertRaisesRegex(ValueError, 'needs error'):
            bad.model_validate(bad.model_dump())

        bad = step.model_copy(update={'sqlstate': ''})
        with self.assertRaisesRegex(ValueError, 'needs SQLSTATE'):
            bad.model_validate(bad.model_dump())

    def test_evidence_hash_rule_is_canonical(self):
        step = captured_step()
        payload = step.canonical_evidence_payload()
        expected = hashlib.sha256(
            json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
        ).hexdigest()
        self.assertEqual(canonical_evidence_sha256(payload), expected)
        step.evidence_sha256 = expected
        self.assertEqual(step.evidence_sha256, expected)

    def test_decisions_and_captures_are_separate_boundaries(self):
        self.assertNotEqual(self.registry.kind, 'core_expression_oracle_review_decisions')
        self.assertIn('A capture result is not an oracle review decision.', self.registry.limits)

    def test_written_registry_is_current_and_drift_detected(self):
        self.assertTrue(OUTPUT_PATH.is_file())
        self.assertEqual(verify_core_expression_oracle_capture(ROOT), self.registry)
        original = OUTPUT_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['captured_count'] = 1
            OUTPUT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_oracle_capture.py'), '--check'],
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
