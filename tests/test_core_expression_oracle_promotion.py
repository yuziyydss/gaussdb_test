"""Oracle promotion admits only confirmed decisions and never fakes evidence."""
import copy
import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_oracle_promotion import (
    build_core_expression_oracle_promotion,
    build_core_expression_oracle_promotion_payload,
    verify_core_expression_oracle_promotion,
)

ROOT = Path(__file__).resolve().parents[1]
OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_promotion_v1/executable_oracles.json'


class CoreExpressionOraclePromotionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.promotion = build_core_expression_oracle_promotion(ROOT)
        cls.payload = build_core_expression_oracle_promotion_payload(ROOT)

    def test_baseline_promotes_zero_confirmed_items(self):
        self.assertEqual(self.promotion.summary.decision_count, 94)
        self.assertEqual(self.promotion.summary.confirmed_decision_count, 0)
        self.assertEqual(self.promotion.summary.pending_decision_count, 94)
        self.assertEqual(self.promotion.summary.needs_revision_decision_count, 0)
        self.assertEqual(self.promotion.summary.blocked_decision_count, 0)
        self.assertEqual(self.promotion.summary.promoted_count, 0)
        self.assertEqual(self.promotion.summary.excluded_count, 94)
        self.assertEqual(len(self.promotion.executable_oracles), 0)
        self.assertEqual(self.promotion.summary.exact_value_assertion_count if hasattr(self.promotion.summary, 'exact_value_assertion_count') else 0, 0)
        self.assertTrue(self.promotion.summary.all_promoted_items_are_confirmed)
        self.assertTrue(self.promotion.summary.promotion_complete)
        self.assertTrue(self.promotion.summary.empty_without_confirmed)
        self.assertFalse(self.promotion.summary.database_executed)
        self.assertFalse(self.promotion.summary.runtime_verified)

    def test_exclusion_list_covers_all_unpromoted_decisions(self):
        self.assertEqual(len(self.promotion.excluded_oracle_ids), 94)
        self.assertEqual(len(set(self.promotion.excluded_oracle_ids)), 94)
        self.assertEqual(
            set(self.promotion.excluded_oracle_ids),
            {item.oracle_id for item in __import__('core.core_expression_oracle_review_decision', fromlist=['build_core_expression_oracle_review_decisions']).build_core_expression_oracle_review_decisions(ROOT).decisions},
        )

    def test_build_rejects_promotion_with_pending_or_nonconfirmed(self):
        # This is a model-level boundary test using a minimal confirmed item.
        from core.core_expression_oracle_promotion import ExecutableOracleDef, OraclePromotionEvidenceDef
        with self.assertRaisesRegex(ValueError, 'promotion cannot claim runtime verification'):
            ExecutableOracleDef(
                oracle_id='oracle_x',
                candidate_id='candidate_x',
                batch_id='batch_x',
                capability='cap_x',
                fact_refs=['fact_x'],
                sql='SELECT 1;',
                planned_assertions=['no_unexpected_error'],
                evidence=OraclePromotionEvidenceDef(
                    reviewer='alice', reviewed_at='2026-09-29T00:00:00+08:00',
                    rows_json_sha256='a' * 64, notices_sha256='b' * 64,
                    sqlstate='00000', server_version='test', sql_compatibility='A',
                ),
                reviewer_conclusion='Confirmed.',
                promotion_status='ready_for_assertion_authoring',
                runtime_verified=True,
            )

    def test_source_hashes_and_promotion_hash_are_stable(self):
        self.assertEqual(
            self.promotion.source.decisions_sha256,
            hashlib.sha256((ROOT / self.promotion.source.decisions_relpath).read_bytes()).hexdigest(),
        )
        self.assertEqual(
            self.promotion.source.oracle_draft_sha256,
            hashlib.sha256((ROOT / self.promotion.source.oracle_draft_relpath).read_bytes()).hexdigest(),
        )
        expected_hash = hashlib.sha256(
            json.dumps(self.promotion.model_dump(mode='json'), ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
        ).hexdigest()
        self.assertEqual(self.payload['promotion_sha256'], expected_hash)

    def test_written_artifact_is_current(self):
        self.assertTrue(OUTPUT_PATH.is_file())
        self.assertEqual(json.loads(OUTPUT_PATH.read_text(encoding='utf-8')), self.payload)
        self.assertEqual(verify_core_expression_oracle_promotion(ROOT), self.payload)

    def test_build_check_detects_drift(self):
        original = OUTPUT_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['promoted_count'] = 1
            OUTPUT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_oracle_promotion.py'), '--check'],
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
