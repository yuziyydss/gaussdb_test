"""Assertion authoring admits only promoted items and forbids literal claims."""
import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_oracle_assertion_authoring import (
    build_core_expression_oracle_assertion_authoring,
    build_core_expression_oracle_assertion_authoring_payloads,
    verify_core_expression_oracle_assertion_authoring,
)

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / 'generated/core_expression_oracle_assertion_authoring_v1/assertion_authoring.json'
MD_PATH = ROOT / 'generated/core_expression_oracle_assertion_authoring_v1/assertion_authoring.md'


class CoreExpressionOracleAssertionAuthoringTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.sheet = build_core_expression_oracle_assertion_authoring(ROOT)
        cls.payload, cls.markdown = build_core_expression_oracle_assertion_authoring_payloads(ROOT)

    def test_empty_baseline_covers_zero_promoted_items(self):
        self.assertEqual(self.sheet.summary.promotion_item_count, 0)
        self.assertEqual(self.sheet.summary.authoring_item_count, 0)
        self.assertEqual(self.sheet.summary.pending_authoring_count, 0)
        self.assertEqual(self.sheet.summary.assertion_draft_count, 0)
        self.assertEqual(self.sheet.summary.exact_literal_claim_count, 0)
        self.assertEqual(self.sheet.summary.runtime_verified_count, 0)
        self.assertTrue(self.sheet.summary.all_promoted_items_are_scheduled)
        self.assertTrue(self.sheet.summary.empty_without_promoted)
        self.assertFalse(self.sheet.summary.database_executed)
        self.assertFalse(self.sheet.summary.execution_authorized)

    def test_allowed_assertion_types_are_limited(self):
        self.assertEqual(
            set(self.sheet.allowed_assertion_types),
            {'documented_semantics', 'no_error', 'result_shape', 'row_count'},
        )

    def test_artifacts_do_not_contain_literal_equality_or_runtime_claims(self):
        self.assertEqual(self.sheet.summary.exact_literal_claim_count, 0)
        self.assertEqual(self.sheet.summary.runtime_verified_count, 0)
        for item in self.sheet.authoring_items:
            with self.subTest(item=item.oracle_id):
                self.assertEqual(item.authoring_status, 'pending_authoring')
                self.assertFalse(item.runtime_verified)
                self.assertEqual(item.exact_literal_claims, [])
                for draft in item.assertion_drafts:
                    self.assertIsNone(draft.expected_literal)
                    self.assertIsNone(draft.expected_literal_claim)
        self.assertNotIn('literal_equality', self.markdown.lower())
        self.assertIn('Literal equality assertions require a future schema', self.markdown)

    def test_source_hash_and_authoring_hash_are_stable(self):
        self.assertEqual(
            self.sheet.source.promotion_sha256,
            hashlib.sha256((ROOT / self.sheet.source.promotion_relpath).read_bytes()).hexdigest(),
        )
        expected_hash = hashlib.sha256(
            json.dumps(self.sheet.model_dump(mode='json'), ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
        ).hexdigest()
        self.assertEqual(self.payload['authoring_sha256'], expected_hash)

    def test_written_artifacts_are_current(self):
        self.assertTrue(JSON_PATH.is_file())
        self.assertTrue(MD_PATH.is_file())
        self.assertEqual(json.loads(JSON_PATH.read_text(encoding='utf-8')), self.payload)
        self.assertEqual(MD_PATH.read_text(encoding='utf-8'), self.markdown)
        self.assertEqual(verify_core_expression_oracle_assertion_authoring(ROOT), self.payload)

    def test_build_check_detects_drift(self):
        original = JSON_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['authoring_item_count'] = 1
            JSON_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_oracle_assertion_authoring.py'), '--check'],
                cwd=ROOT,
                text=True,
                capture_output=True,
            )
            self.assertEqual(result.returncode, 1)
            self.assertIn('artifact drift', result.stdout)
        finally:
            JSON_PATH.write_text(original, encoding='utf-8')


if __name__ == '__main__':
    unittest.main()
