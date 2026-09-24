"""Runtime pilot plans are explicit, restorable, and never fake execution."""
from pathlib import Path
import copy
import json
import tempfile
import unittest

from core.runtime_validation_pilot import (
    RuntimeStepResult,
    ScriptedRuntimeTransport,
    build_dry_run,
    execute_plan,
    plan_sha256,
)
from scripts.run_runtime_validation_pilot import main as cli_main

ROOT = Path(__file__).resolve().parents[1]


def success(rows=None, notices=None):
    return RuntimeStepResult(success=True, rows=rows or [], notices=notices or [])


def failure(error="simulated failure"):
    return RuntimeStepResult(success=False, error=error)


def _all_success_responses():
    return [
        # GUC enable_seqscan: on -> off -> on.
        success(rows=[["on"]]), success(),
        success(rows=[["off"]]), success(),
        success(rows=[["on"]]),
        # GUC default_transaction_read_only: off -> on -> off.
        success(rows=[["off"]]), success(),
        success(rows=[["on"]]), success(),
        success(rows=[["off"]]),
        # Advanced package candidates.
        success(notices=["hello, database!"]),
        success(notices=["buffered"]),
        success(rows=[["ABC"]]),
        success(rows=[[742]]),
        success(notices=["value=1"]),
    ]


class RuntimeValidationPilotTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_dry_run(ROOT)

    def test_dry_run_contains_two_guc_and_five_advanced_units(self):
        self.assertEqual(self.plan.profile, "runtime_validation_pilot_v1")
        self.assertEqual(len(self.plan.units), 7)
        self.assertEqual(
            [unit.kind for unit in self.plan.units],
            ["guc_overlay", "guc_overlay"] + ["advanced_package"] * 5,
        )
        self.assertFalse(self.plan.database_executed)
        self.assertFalse(self.plan.execution_authorized)
        self.assertEqual(self.plan.runtime_verified, 0)

    def test_guc_units_capture_apply_verify_restore_and_verify_restore(self):
        for unit in self.plan.units[:2]:
            with self.subTest(unit=unit.id):
                self.assertEqual(
                    [step.phase for step in unit.execution_plan],
                    [
                        "capture_original", "apply", "verify_target",
                        "restore", "verify_restore",
                    ],
                )
                self.assertTrue(unit.cleanup.restore_original_guc)
                self.assertIn("SET ", unit.execution_plan[1].sql)
                self.assertIn("SET ", unit.execution_plan[3].sql)
                self.assertNotIn("ALTER SYSTEM", "\n".join(step.sql for step in unit.execution_plan))
                self.assertNotIn("RESET ", "\n".join(step.sql for step in unit.execution_plan))

    def test_advanced_units_keep_unverified_oracles_and_cleanup_boundary(self):
        advanced = self.plan.units[2:]
        self.assertEqual(len(advanced), 5)
        for unit in advanced:
            with self.subTest(unit=unit.id):
                self.assertEqual(unit.oracle.status, "needs_verification")
                self.assertEqual(unit.execution_plan[0].phase, "target")
        sql_case = next(unit for unit in advanced if unit.id == "adv_case_dbe_sql_select_lifecycle")
        self.assertIn("RAISE NOTICE 'value=%'", sql_case.execution_plan[0].sql)
        self.assertEqual(sql_case.execution_plan[0].sql.count("DBE_SQL.SQL_UNREGISTER_CONTEXT"), 2)
        self.assertTrue(sql_case.cleanup.close_advanced_context)

    def test_plan_fingerprint_is_stable(self):
        rebuilt = build_dry_run(ROOT)
        self.assertEqual(plan_sha256(self.plan), plan_sha256(rebuilt))

    def test_authorized_execution_verifies_all_units_with_scripted_transport(self):
        transport = ScriptedRuntimeTransport(_all_success_responses())
        receipt = execute_plan(self.plan, transport, authorized=True)
        self.assertEqual(receipt["status"], "runtime_verified")
        self.assertTrue(receipt["database_executed"])
        self.assertTrue(receipt["execution_authorized"])
        self.assertEqual(receipt["runtime_verified"], 7)
        self.assertEqual(receipt["failed_units"], 0)
        self.assertEqual(receipt["executed_steps"], 15)
        self.assertEqual(len(transport.calls), 15)

    def test_missing_notice_oracle_fails_unit_without_faking_pass(self):
        responses = _all_success_responses()
        responses[10] = success(notices=["unexpected output"])
        transport = ScriptedRuntimeTransport(responses)
        receipt = execute_plan(self.plan, transport, authorized=True)
        self.assertEqual(receipt["status"], "failed")
        self.assertEqual(receipt["runtime_verified"], 6)
        self.assertEqual(receipt["failed_units"], 1)
        failed_unit = next(unit for unit in receipt["units"] if unit["status"] == "execution_failed")
        self.assertFalse(failed_unit["runtime_verified"])
        self.assertEqual(failed_unit["steps"][0]["status"], "failed")

    def test_unauthorized_execution_is_rejected(self):
        transport = ScriptedRuntimeTransport([])
        with self.assertRaisesRegex(ValueError, "explicit authorization"):
            execute_plan(self.plan, transport, authorized=False)

    def test_cli_writes_dry_run_without_overwrite(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "dry_run.json"
            cli_main(["--output", str(output)])
            payload = json.loads(output.read_text())
            self.assertEqual(payload["kind"], "runtime_validation_pilot")
            self.assertFalse(payload["database_executed"])
            self.assertEqual(len(payload["units"]), 7)
            self.assertIn("plan_sha256", payload)
            with self.assertRaisesRegex(SystemExit, "already exists"):
                cli_main(["--output", str(output)])


if __name__ == "__main__":
    unittest.main()
