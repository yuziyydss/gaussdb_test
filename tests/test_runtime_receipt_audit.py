"""Runtime receipts are audited before any runtime claim is accepted."""
import copy
import unittest

from core.runtime_receipt_audit import audit_runtime_receipt
from core.runtime_validation_pilot import (
    RuntimeStepResult,
    ScriptedRuntimeTransport,
    build_dry_run,
    execute_plan,
)
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def success(rows=None, notices=None):
    return RuntimeStepResult(success=True, rows=rows or [], notices=notices or [])


def all_success_responses():
    return [
        success(rows=[["on"]]), success(),
        success(rows=[["off"]]), success(),
        success(rows=[["on"]]),
        success(rows=[["off"]]), success(),
        success(rows=[["on"]]), success(),
        success(rows=[["off"]]),
        success(notices=["hello, database!"]),
        success(notices=["buffered"]),
        success(rows=[["ABC"]]),
        success(rows=[[742]]),
        success(notices=["value=1"]),
    ]


class RuntimeReceiptAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_dry_run(ROOT)
        transport = ScriptedRuntimeTransport(all_success_responses())
        cls.receipt = execute_plan(cls.plan, transport, authorized=True)

    def test_valid_receipt_matches_plan_and_internal_counts(self):
        audit = audit_runtime_receipt(self.receipt, plan=self.plan)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)
        self.assertEqual(audit.summary, {
            "units": 7,
            "runtime_verified": 7,
            "failed_units": 0,
            "executed_steps": 15,
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
        bad["runtime_verified"] = 6
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("runtime_verified mismatch", audit.errors[0])

    def test_executed_steps_mismatch_is_rejected(self):
        bad = copy.deepcopy(self.receipt)
        bad["executed_steps"] = 14
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("executed_steps mismatch", audit.errors[0])

    def test_guc_cleanup_claim_must_be_present(self):
        bad = copy.deepcopy(self.receipt)
        bad["units"][0]["cleanup"]["restore_original_guc"] = False
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("GUC overlay must restore original value", audit.errors[0])

    def test_dbe_sql_context_cleanup_must_be_present(self):
        bad = copy.deepcopy(self.receipt)
        sql_unit = next(unit for unit in bad["units"] if unit["id"] == "adv_case_dbe_sql_select_lifecycle")
        sql_unit["cleanup"]["close_advanced_context"] = False
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("DBE_SQL unit must close context", audit.errors[0])

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
        bad["runtime_verified"] = 6
        bad["failed_units"] = 1
        bad["status"] = "failed"
        audit = audit_runtime_receipt(bad, plan=self.plan)
        self.assertTrue(audit.valid, audit.errors)
        self.assertEqual(audit.summary["runtime_verified"], 6)
        self.assertEqual(audit.summary["failed_units"], 1)


if __name__ == "__main__":
    unittest.main()

    def test_cli_audits_receipt_against_plan(self):
        import json
        import tempfile
        from scripts.audit_runtime_receipt import main as audit_main

        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            receipt_path = root / "receipt.json"
            plan_path = root / "plan.json"
            output_path = root / "audit.json"
            receipt_path.write_text(json.dumps(self.receipt, ensure_ascii=False) + "\n")
            plan_path.write_text(json.dumps(self.plan.model_dump(mode="json"), ensure_ascii=False) + "\n")
            audit_main(["--receipt", str(receipt_path), "--plan", str(plan_path), "--output", str(output_path)])
            payload = json.loads(output_path.read_text())
            self.assertTrue(payload["valid"])
            self.assertTrue(payload["plan_verified"])
            self.assertEqual(payload["kind"], "runtime_receipt_audit")
