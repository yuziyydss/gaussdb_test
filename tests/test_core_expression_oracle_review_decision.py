"""Oracle decision registry enforces explicit evidence and never fakes review."""
import copy
import json
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_oracle_review_decision import (
    build_core_expression_oracle_review_decisions,
    validate_core_expression_oracle_review_decisions,
    verify_core_expression_oracle_review_decisions,
)

ROOT = Path(__file__).resolve().parents[1]
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_review_decisions_v1/review_decisions.json'


class CoreExpressionOracleReviewDecisionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = build_core_expression_oracle_review_decisions(ROOT)

    def test_all_94_oracles_start_pending(self):
        self.assertEqual(self.registry.summary.review_step_count, 94)
        self.assertEqual(self.registry.summary.decision_count, 94)
        self.assertEqual(self.registry.summary.pending_count, 94)
        self.assertEqual(self.registry.summary.confirmed_count, 0)
        self.assertEqual(self.registry.summary.needs_revision_count, 0)
        self.assertEqual(self.registry.summary.blocked_count, 0)
        self.assertTrue(self.registry.summary.all_decisions_recorded)
        self.assertFalse(self.registry.summary.database_executed)
        self.assertFalse(self.registry.summary.runtime_verified)
        self.assertEqual(len({item.oracle_id for item in self.registry.decisions}), 94)
        for decision in self.registry.decisions:
            with self.subTest(decision=decision.oracle_id):
                self.assertEqual(decision.decision, 'pending')
                self.assertIsNone(decision.evidence)
                self.assertEqual(decision.reason, '')

    def test_confirmed_requires_complete_evidence_and_reason(self):
        base = self.registry.model_dump(mode='json')
        payload = copy.deepcopy(base)
        step = payload['decisions'][0]
        step['decision'] = 'confirmed'
        with self.assertRaisesRegex(ValueError, 'requires captured evidence'):
            validate_core_expression_oracle_review_decisions(payload)

        step['evidence'] = {
            'reviewer': '', 'reviewed_at': '', 'rows_json_sha256': '0' * 64,
            'notices_sha256': '0' * 64, 'sqlstate': '', 'server_version': '',
            'sql_compatibility': '', 'notes': '',
        }
        with self.assertRaisesRegex(ValueError, 'confirmed oracle evidence fields cannot be blank'):
            validate_core_expression_oracle_review_decisions(payload)

        step['reason'] = 'Actual result matches documented semantics.'
        step['evidence'] = {
            'reviewer': 'alice',
            'reviewed_at': '2026-09-29T00:00:00+08:00',
            'rows_json_sha256': 'a' * 64,
            'notices_sha256': 'b' * 64,
            'sqlstate': '00000',
            'server_version': 'test-version',
            'sql_compatibility': 'A',
            'notes': 'Captured on authorized target.',
        }
        validated = validate_core_expression_oracle_review_decisions(payload)
        self.assertEqual(validated.summary.confirmed_count, 1)
        self.assertEqual(validated.summary.executable_oracle_candidate_count, 1)

    def test_needs_revision_and_blocked_require_reason(self):
        base = self.registry.model_dump(mode='json')
        payload = copy.deepcopy(base)
        payload['decisions'][0]['decision'] = 'needs_revision'
        with self.assertRaisesRegex(ValueError, 'requires reason'):
            validate_core_expression_oracle_review_decisions(payload)
        payload['decisions'][0]['reason'] = 'Output needs a compatibility-mode qualifier.'
        validated = validate_core_expression_oracle_review_decisions(payload)
        self.assertEqual(validated.summary.needs_revision_count, 1)

        payload['decisions'][1]['decision'] = 'blocked'
        with self.assertRaisesRegex(ValueError, 'requires reason'):
            validate_core_expression_oracle_review_decisions(payload)
        payload['decisions'][1]['reason'] = 'Target feature unavailable.'
        validated = validate_core_expression_oracle_review_decisions(payload)
        self.assertEqual(validated.summary.blocked_count, 1)

    def test_pending_cannot_have_evidence_or_reason(self):
        base = self.registry.model_dump(mode='json')
        payload = copy.deepcopy(base)
        payload['decisions'][0]['reason'] = 'not allowed'
        with self.assertRaisesRegex(ValueError, 'cannot have a decision reason'):
            validate_core_expression_oracle_review_decisions(payload)
        payload['decisions'][0]['reason'] = ''
        payload['decisions'][0]['evidence'] = {
            'reviewer': 'alice', 'reviewed_at': 'now', 'rows_json_sha256': 'a' * 64,
            'notices_sha256': 'b' * 64, 'sqlstate': '00000',
            'server_version': 'v', 'sql_compatibility': 'A', 'notes': '',
        }
        with self.assertRaisesRegex(ValueError, 'cannot have evidence'):
            validate_core_expression_oracle_review_decisions(payload)

    def test_decisions_must_cover_review_sheet_exactly(self):
        payload = self.registry.model_dump(mode='json')
        payload['decisions'] = payload['decisions'][:-1]
        with self.assertRaisesRegex(ValueError, 'cover every review sheet step'):
            validate_core_expression_oracle_review_decisions(payload)

    def test_written_registry_is_current_and_drift_detected(self):
        self.assertTrue(OUTPUT_PATH.is_file())
        self.assertEqual(verify_core_expression_oracle_review_decisions(ROOT), self.registry)
        original = OUTPUT_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['confirmed_count'] = 1
            OUTPUT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_oracle_review_decisions.py'), '--check'],
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
