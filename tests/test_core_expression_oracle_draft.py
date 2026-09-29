"""Core expression oracle drafts stay review-only and do not invent literals."""
import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_oracle_draft import (
    build_core_expression_oracle_draft,
    build_core_expression_oracle_draft_payload,
    verify_core_expression_oracle_draft,
)

ROOT = Path(__file__).resolve().parents[1]
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_draft_v1/oracle_draft.json'


class CoreExpressionOracleDraftTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.draft = build_core_expression_oracle_draft(ROOT)
        cls.payload = build_core_expression_oracle_draft_payload(ROOT)

    def test_all_94_probe_steps_have_oracle_drafts(self):
        self.assertEqual(self.draft.summary.probe_plan_step_count, 94)
        self.assertEqual(self.draft.summary.oracle_draft_count, 94)
        self.assertEqual(self.draft.summary.batch_count, 4)
        self.assertTrue(self.draft.summary.all_steps_drafted)
        self.assertEqual(len({step.oracle_id for step in self.draft.steps}), 94)
        self.assertEqual(len({step.candidate_id for step in self.draft.steps}), 94)
        self.assertEqual([step.plan_order for step in sorted(self.draft.steps, key=lambda x: x.plan_order)], list(range(1, 95)))

    def test_no_expected_literal_values_are_claimed(self):
        self.assertEqual(self.draft.summary.exact_value_assertion_count, 0)
        for step in self.draft.steps:
            with self.subTest(step=step.oracle_id):
                self.assertEqual(step.expected_literal_claims, [])
                self.assertEqual(step.expected_shape, 'to_be_captured')
                self.assertEqual(step.oracle_status, 'needs_verification')
                self.assertEqual(step.draft_status, 'ready_for_review')
                self.assertNotIn('expected_value', step.model_dump())

    def test_capture_and_assertions_are_explicit(self):
        planned = {
            'no_unexpected_error',
            'rows_are_captured',
            'sqlstate_is_captured',
            'result_semantics_are_reviewed_against_fact_refs',
        }
        for step in self.draft.steps:
            with self.subTest(step=step.oracle_id):
                self.assertTrue(step.fact_refs)
                self.assertEqual(set(step.planned_assertions), planned)
                self.assertTrue(step.capture.rows)
                self.assertTrue(step.capture.error)
                self.assertTrue(step.capture.sqlstate)
                self.assertTrue(step.capture.server_version)
                self.assertTrue(step.capture.sql_compatibility)

    def test_sql_remains_single_read_only_statement(self):
        for step in self.draft.steps:
            with self.subTest(step=step.oracle_id):
                self.assertTrue(step.sql.endswith(';'))
                self.assertEqual(step.sql.count(';'), 1)
                self.assertTrue(step.sql.upper().startswith(('SELECT ', 'WITH ')))
                for forbidden in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
                    self.assertNotIn(forbidden, step.sql.upper())

    def test_source_hashes_and_draft_hash_are_stable(self):
        self.assertEqual(
            self.draft.source.probe_plan_sha256,
            hashlib.sha256((ROOT / self.draft.source.probe_plan_relpath).read_bytes()).hexdigest(),
        )
        self.assertEqual(
            self.draft.source.batches_sha256,
            hashlib.sha256((ROOT / self.draft.source.batches_relpath).read_bytes()).hexdigest(),
        )
        expected_hash = hashlib.sha256(
            json.dumps(self.draft.model_dump(mode='json'), ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
        ).hexdigest()
        self.assertEqual(self.payload['draft_sha256'], expected_hash)

    def test_written_artifact_is_current(self):
        self.assertTrue(OUTPUT_PATH.is_file())
        self.assertEqual(json.loads(OUTPUT_PATH.read_text(encoding='utf-8')), self.payload)
        self.assertEqual(verify_core_expression_oracle_draft(ROOT), self.payload)

    def test_build_check_detects_drift(self):
        original = OUTPUT_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['oracle_draft_count'] += 1
            OUTPUT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_oracle_draft.py'), '--check'],
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
