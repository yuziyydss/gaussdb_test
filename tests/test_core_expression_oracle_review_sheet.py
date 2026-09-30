"""Oracle review sheet stays pending, complete and free of invented evidence."""
import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_oracle_review_sheet import (
    build_core_expression_oracle_review_sheet,
    build_core_expression_oracle_review_sheet_payloads,
    verify_core_expression_oracle_review_sheet,
)

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / 'generated/core_expression_oracle_review_sheet_v1/review_sheet.json'
MD_PATH = ROOT / 'generated/core_expression_oracle_review_sheet_v1/review_sheet.md'


class CoreExpressionOracleReviewSheetTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.sheet = build_core_expression_oracle_review_sheet(ROOT)
        cls.payload, cls.markdown = build_core_expression_oracle_review_sheet_payloads(ROOT)

    def test_all_94_drafts_are_scheduled_for_review(self):
        self.assertEqual(self.sheet.summary.oracle_draft_step_count, 94)
        self.assertEqual(self.sheet.summary.review_step_count, 94)
        self.assertEqual(self.sheet.summary.capability_group_count, 14)
        self.assertEqual(self.sheet.summary.pending_review_count, 94)
        self.assertEqual(self.sheet.summary.verified_count, 0)
        self.assertTrue(self.sheet.summary.all_steps_scheduled_for_review)
        self.assertFalse(self.sheet.summary.database_executed)
        self.assertFalse(self.sheet.summary.runtime_verified)

    def test_steps_are_pending_and_do_not_add_expected_values(self):
        for step in self.sheet.steps:
            with self.subTest(step=step.oracle_id):
                self.assertEqual(step.review_status, 'pending_review')
                self.assertEqual(len(step.review_questions), 5)
                self.assertTrue(step.fact_refs)
                self.assertTrue(step.planned_assertions)

    def test_capability_groups_cover_every_step_once(self):
        grouped = [oracle_id for group in self.sheet.capability_groups for oracle_id in group.oracle_ids]
        self.assertEqual(len(grouped), 94)
        self.assertEqual(len(set(grouped)), 94)
        self.assertEqual(set(grouped), {step.oracle_id for step in self.sheet.steps})
        for group in self.sheet.capability_groups:
            with self.subTest(group=group.capability):
                self.assertEqual(group.step_count, len(group.oracle_ids))
                self.assertEqual(group.review_status, 'pending_review')
        self.assertEqual(self.sheet.summary.capability_group_count, 14)

    def test_markdown_contains_all_steps_and_boundaries(self):
        self.assertEqual(self.payload['sheet_sha256'], hashlib.sha256(
            json.dumps(
                {key: value for key, value in self.payload.items() if key != 'sheet_sha256'},
                ensure_ascii=False,
                sort_keys=True,
                separators=(',', ':'),
            ).encode('utf-8')
        ).hexdigest())
        self.assertIn('# Core Expression Oracle Review Sheet', self.markdown)
        for step in self.sheet.steps:
            self.assertIn(f"### `{step.oracle_id}`", self.markdown)
            self.assertIn(f"- Candidate: `{step.candidate_id}`", self.markdown)
        self.assertIn('- Pending review 不代表数据库行为已验证。', self.markdown)

    def test_written_artifacts_are_current(self):
        self.assertTrue(JSON_PATH.is_file())
        self.assertTrue(MD_PATH.is_file())
        self.assertEqual(json.loads(JSON_PATH.read_text(encoding='utf-8')), self.payload)
        self.assertEqual(MD_PATH.read_text(encoding='utf-8'), self.markdown)
        self.assertEqual(verify_core_expression_oracle_review_sheet(ROOT), self.payload)

    def test_build_check_detects_drift(self):
        original = JSON_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['pending_review_count'] += 1
            JSON_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_oracle_review_sheet.py'), '--check'],
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
