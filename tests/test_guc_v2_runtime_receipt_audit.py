"""GUC V2 receipts are audited against the original dry-run plan."""
import copy
import json
import tempfile
import unittest
from pathlib import Path

from core.guc_runtime_pilot import build_guc_v2_runtime_dry_run
from core.runtime_receipt_audit import audit_runtime_receipt
from core.runtime_validation_pilot import (
    RuntimeStepResult,
    ScriptedRuntimeTransport,
    execute_plan,
)
from scripts.audit_guc_v2_runtime_receipt import main as audit_main


ROOT = Path(__file__).resolve().parents[1]


def success(value=None):
    if value is None:
        return RuntimeStepResult(success=True, rows=[], notices=[], error="")
    return RuntimeStepResult(success=True, rows=[[value]], notices=[], error="")


def all_success_responses(plan):
    responses = []
    for unit in plan.units:
        responses.extend([
            success(unit.execution_plan[0].expected_rows[0][0]),
            success(),
            success(unit.execution_plan[2].expected_rows[0][0]),
            success(),
            success(unit.execution_plan[4].expected_rows[0][0]),
        ])
    return responses


class GucV2RuntimeReceiptAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_guc_v2_runtime_dry_run(ROOT)
        transport = ScriptedRuntimeTransport(all_success_responses(cls.plan))
        cls.receipt = execute_plan(cls.plan, transport, authorized=True)

    def test_valid_receipt_matches_guc_v2_plan_and_counts(self):
        audit = audit_runtime_receipt(self.receipt, plan=self.plan)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)
        self.assertEqual(audit.summary, {
            "units": 19,
            "runtime_verified": 19,
            "failed_units": 0,
            "executed_steps": 95,
        })

    def test_missing_plan_is_not_trusted(self):
        audit = audit_runtime_receipt(self.receipt)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn("plan not supplied", audit.errors[0])

    def test_plan_hash_mismatch_is_rejected(self):
        bad = copy.deepcopy(self.receipt)
        bad["plan_sha256"] = "0" * 64
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn("plan hash mismatch", audit.errors[0])

    def test_runtime_verified_count_mismatch_is_rejected(self):
        bad = copy.deepcopy(self.receipt)
        bad["runtime_verified"] = 18
        bad["failed_units"] = 1
        bad["status"] = "failed"
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("runtime_verified mismatch", audit.errors[0])

    def test_guc_cleanup_claim_must_be_present(self):
        bad = copy.deepcopy(self.receipt)
        bad["units"][0]["cleanup"]["restore_original_guc"] = False
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("GUC overlay must restore original value", audit.errors[0])

    def test_forbidden_sql_is_rejected(self):
        bad = copy.deepcopy(self.receipt)
        bad["units"][0]["steps"][1]["sql"] = "ALTER SYSTEM SET enable_seqscan = 'off';"
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("forbidden SQL detected", audit.errors[0])

    def test_failed_unit_cannot_claim_runtime_verified(self):
        bad = copy.deepcopy(self.receipt)
        bad["units"][0]["steps"][0]["status"] = "failed"
        bad["units"][0]["steps"][0]["error"] = "simulated failure"
        bad["units"][0]["runtime_verified"] = False
        bad["units"][0]["status"] = "execution_failed"
        bad["runtime_verified"] = 18
        bad["failed_units"] = 1
        bad["status"] = "failed"
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertTrue(audit.valid, audit.errors)
        self.assertEqual(audit.summary["runtime_verified"], 18)
        self.assertEqual(audit.summary["failed_units"], 1)

    def test_cli_audits_receipt_against_guc_v2_plan(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            receipt_path = root / "receipt.json"
            plan_path = ROOT / "generated/guc_environment_v2/runtime_dry_run.json"
            output_path = root / "audit.json"
            receipt_path.write_text(
                json.dumps(self.receipt, ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
            audit_main([
                "--receipt", str(receipt_path),
                "--plan", str(plan_path),
                "--output", str(output_path),
            ])
            payload = json.loads(output_path.read_text(encoding="utf-8"))
            self.assertTrue(payload["valid"])
            self.assertTrue(payload["plan_verified"])
            self.assertEqual(payload["kind"], "runtime_receipt_audit")
            self.assertEqual(payload["summary"]["units"], 19)
            self.assertEqual(payload["summary"]["executed_steps"], 95)


if __name__ == "__main__":
    unittest.main()
