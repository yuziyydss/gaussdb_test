"""Core expression probe dry-run stays static, fixture-free and read-only."""
import hashlib
import json
import re
import subprocess
import sys
import unittest
from pathlib import Path

from core.core_expression_probe_plan import build_core_expression_probe_plan, build_core_expression_probe_plan_payload

ROOT = Path(__file__).resolve().parents[1]
OUTPUT_PATH = ROOT / 'generated/core_expression_probe_plan_v1/dry_run.json'

STATEFUL_RE = re.compile(r'\b(CURRENT_DATE|CURRENT_TIME|CURRENT_TIMESTAMP|LOCALTIME|LOCALTIMESTAMP|NOW\s*\(|SYSDATE|STATEMENT_TIMESTAMP|TRANSACTION_TIMESTAMP|CLOCK_TIMESTAMP|TIMEOFDAY|PG_SLEEP|CURRENT_USER|SESSION_USER|CURRENT_SCHEMA|CURRENT_CATALOG)\b', re.I)
COMPAT_RE = re.compile(r'\b(LPAD_S|NVL\s*\(|NVL2\s*\(|DECODE\s*\(|IF\s*\(|IFNULL\s*\(|EMPTY_BLOB|EMPTY_CLOB|ROWID|HASH16|HASH32|YEAR\b|SHA2\s*\(|GROUP_CONCAT\s*\(|KEEP\s*\(|LNNVL\s*\(|TO_DATEA\s*\()', re.I)


class CoreExpressionProbePlanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_core_expression_probe_plan(ROOT)
        cls.payload = build_core_expression_probe_plan_payload(ROOT)

    def test_first_batch_filters_fixture_and_modes(self):
        self.assertEqual(self.plan.summary.candidate_count, 171)
        self.assertEqual(self.plan.summary.selected_count, 94)
        self.assertEqual(self.plan.summary.excluded_count, 77)
        self.assertEqual(self.plan.summary.step_count, 94)
        self.assertEqual(self.plan.summary.fixture_free_step_count, 94)
        self.assertEqual(self.plan.summary.mode_independent_step_count, 94)
        self.assertEqual(self.plan.summary.read_only_step_count, 94)
        self.assertFalse(self.plan.summary.database_executed)
        self.assertFalse(self.plan.summary.execution_authorized)
        self.assertFalse(self.plan.summary.runtime_verified)
        self.assertEqual(self.plan.status, 'ready_for_static_review')

    def test_plan_has_complete_exclusion_audit(self):
        selected_ids = {item.candidate_id for item in self.plan.steps}
        excluded_ids = {item.candidate_id for item in self.plan.exclusions}
        self.assertEqual(len(selected_ids | excluded_ids), 171)
        self.assertFalse(selected_ids & excluded_ids)
        for exclusion in self.plan.exclusions:
            with self.subTest(candidate=exclusion.candidate_id):
                self.assertTrue(exclusion.reasons)
                self.assertTrue(exclusion.reasons)

    def chain_candidates(self):
        return json.loads(
            (ROOT / 'generated/core_expression_candidate_chain_v1/candidates.json').read_text(encoding='utf-8')
        )['candidates']

    def test_steps_are_read_only_fixture_free_and_traceable(self):
        self.assertEqual([item.plan_order for item in self.plan.steps], list(range(1, 95)))
        self.assertEqual(len({item.candidate_id for item in self.plan.steps}), 94)
        for step in self.plan.steps:
            with self.subTest(step=step.candidate_id):
                self.assertEqual(step.compatibility_mode, 'any')
                self.assertEqual(step.fixture_ref, 'no_fixture')
                self.assertEqual(step.expected_kind, 'value')
                self.assertEqual(step.oracle_status, 'needs_verification')
                self.assertEqual(step.execution_status, 'not_executed')
                self.assertTrue(step.fact_refs)
                self.assertTrue(step.sql.endswith(';'))
                self.assertEqual(step.sql.count(';'), 1)
                self.assertTrue(step.sql.upper().startswith(('SELECT ', 'WITH ')))
                self.assertFalse(STATEFUL_RE.search(step.sql))
                self.assertFalse(COMPAT_RE.search(step.sql))
                for forbidden in ('INSERT ', 'UPDATE ', 'DELETE ', 'CREATE ', 'ALTER ', 'DROP ', 'TRUNCATE ', 'GRANT ', 'REVOKE ', 'CALL ', 'DBMS_'):
                    self.assertNotIn(forbidden, step.sql.upper())

    def test_source_hash_and_plan_hash_are_stable(self):
        chain_bytes = (ROOT / self.plan.source.candidate_chain_relpath).read_bytes()
        self.assertEqual(
            self.plan.source.candidate_chain_sha256,
            hashlib.sha256(chain_bytes).hexdigest(),
        )
        expected_hash = hashlib.sha256(
            json.dumps(
                self.plan.model_dump(mode='json'),
                ensure_ascii=False,
                sort_keys=True,
                separators=(',', ':'),
            ).encode('utf-8')
        ).hexdigest()
        self.assertEqual(self.payload['plan_sha256'], expected_hash)

    def test_written_plan_is_current(self):
        self.assertTrue(OUTPUT_PATH.is_file())
        payload = json.loads(OUTPUT_PATH.read_text(encoding='utf-8'))
        self.assertEqual(payload, self.payload)
        self.assertRegex(payload['plan_sha256'], r'[0-9a-f]{64}')

    def test_build_check_detects_drift(self):
        original = OUTPUT_PATH.read_text(encoding='utf-8')
        try:
            payload = json.loads(original)
            payload['summary']['selected_count'] += 1
            OUTPUT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
            result = subprocess.run(
                [sys.executable, str(ROOT / 'scripts/build_core_expression_probe_plan.py'), '--check'],
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
