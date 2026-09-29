"""GUC V2 runtime pilot stays explicit, restorable, and never fakes execution."""
import json
import tempfile
import unittest
from pathlib import Path

from core.guc_runtime_pilot import (
    GucV2RuntimePilotError,
    GucV2RuntimePilotRegistry,
    build_guc_v2_runtime_dry_run,
)
from core.runtime_validation_pilot import (
    RuntimeStepResult,
    ScriptedRuntimeTransport,
    execute_plan,
    plan_sha256,
)
from scripts.run_guc_v2_runtime_pilot import main as runtime_pilot_cli


ROOT = Path(__file__).resolve().parents[1]


def success(value):
    return RuntimeStepResult(success=True, rows=[[value]], notices=[], error="")


class GucV2RuntimePilotTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_guc_v2_runtime_dry_run(ROOT)

    def test_dry_run_contains_19_guc_overlay_units(self):
        self.assertEqual(self.plan.profile, "runtime_guc_v2_pilot_v1")
        self.assertEqual(self.plan.kind, "runtime_validation_pilot")
        self.assertEqual(len(self.plan.units), 19)
        self.assertTrue(all(unit.kind == "guc_overlay" for unit in self.plan.units))
        self.assertEqual(sum(len(unit.execution_plan) for unit in self.plan.units), 95)
        self.assertFalse(self.plan.database_executed)
        self.assertFalse(self.plan.execution_authorized)
        self.assertEqual(self.plan.runtime_verified, 0)

    def test_each_unit_captures_applies_verifies_restores_and_verifies_restore(self):
        for unit in self.plan.units:
            with self.subTest(unit=unit.id):
                self.assertEqual(
                    [step.phase for step in unit.execution_plan],
                    [
                        "capture_original", "apply", "verify_target",
                        "restore", "verify_restore",
                    ],
                )
                self.assertTrue(unit.cleanup.restore_original_guc)
                self.assertTrue(unit.execution_plan[0].expected_rows)
                self.assertTrue(unit.execution_plan[2].expected_rows)
                self.assertTrue(unit.execution_plan[4].expected_rows)
                joined_sql = "\n".join(step.sql for step in unit.execution_plan)
                for forbidden in ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET "):
                    self.assertNotIn(forbidden, joined_sql)

    def test_plan_fingerprint_is_stable(self):
        rebuilt = build_guc_v2_runtime_dry_run(ROOT)
        self.assertEqual(plan_sha256(self.plan), plan_sha256(rebuilt))

    def test_authorized_execution_verifies_all_units_with_scripted_transport(self):
        responses = []
        for unit in self.plan.units:
            responses.extend([
                success(unit.execution_plan[0].expected_rows[0][0]),
                success([]),
                success(unit.execution_plan[2].expected_rows[0][0]),
                success([]),
                success(unit.execution_plan[4].expected_rows[0][0]),
            ])
        transport = ScriptedRuntimeTransport(responses)
        receipt = execute_plan(self.plan, transport, authorized=True)
        self.assertEqual(receipt["status"], "runtime_verified")
        self.assertTrue(receipt["database_executed"])
        self.assertTrue(receipt["execution_authorized"])
        self.assertEqual(receipt["runtime_verified"], 19)
        self.assertEqual(receipt["failed_units"], 0)
        self.assertEqual(receipt["executed_steps"], 95)
        self.assertEqual(receipt["plan_step_count"], 95)
        self.assertEqual(len(transport.calls), 95)

    def test_failed_verify_target_blocks_unit_without_faking_success(self):
        responses = []
        failed = False
        for unit in self.plan.units:
            values = [
                unit.execution_plan[0].expected_rows[0][0],
                [],
                unit.execution_plan[2].expected_rows[0][0],
                [],
                unit.execution_plan[4].expected_rows[0][0],
            ]
            if not failed and unit.id.endswith("enable_seqscan"):
                responses.extend([
                    success(values[0]),
                    success([]),
                    RuntimeStepResult(success=True, rows=[["unexpected"]], notices=[], error=""),
                ])
                failed = True
            else:
                responses.extend(success(value) for value in values)
        transport = ScriptedRuntimeTransport(responses)
        receipt = execute_plan(self.plan, transport, authorized=True)
        self.assertEqual(receipt["status"], "failed")
        self.assertEqual(receipt["runtime_verified"], 18)
        self.assertEqual(receipt["failed_units"], 1)
        failed_unit = next(unit for unit in receipt["units"] if unit["status"] == "execution_failed")
        self.assertFalse(failed_unit["runtime_verified"])

    def test_unauthorized_execution_is_rejected(self):
        transport = ScriptedRuntimeTransport([])
        with self.assertRaisesRegex(ValueError, "explicit authorization"):
            execute_plan(self.plan, transport, authorized=False)

    def test_registry_writes_and_loads_plan_with_hash(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "dry_run.json"
            registry = GucV2RuntimePilotRegistry(ROOT)
            written = registry.write(output)
            self.assertEqual(written, output)
            payload = json.loads(output.read_text(encoding="utf-8"))
            self.assertEqual(payload["profile"], "runtime_guc_v2_pilot_v1")
            self.assertIn("plan_sha256", payload)
            loaded = registry.load(output)
            self.assertEqual(loaded.profile, "runtime_guc_v2_pilot_v1")
            self.assertEqual(len(loaded.units), 19)

    def test_registry_rejects_hash_drift(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "dry_run.json"
            registry = GucV2RuntimePilotRegistry(ROOT)
            registry.write(output)
            payload = json.loads(output.read_text(encoding="utf-8"))
            payload["plan_sha256"] = "0" * 64
            output.write_text(json.dumps(payload), encoding="utf-8")
            with self.assertRaises(GucV2RuntimePilotError) as caught:
                registry.load(output)
            self.assertIn("plan hash drift", str(caught.exception))

    def test_cli_writes_dry_run_without_overwrite(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "dry_run.json"
            runtime_pilot_cli(["--output", str(output)])
            payload = json.loads(output.read_text(encoding="utf-8"))
            self.assertEqual(payload["kind"], "runtime_validation_pilot")
            self.assertEqual(payload["profile"], "runtime_guc_v2_pilot_v1")
            self.assertFalse(payload["database_executed"])
            self.assertEqual(len(payload["units"]), 19)
            with self.assertRaisesRegex(SystemExit, "already exists"):
                runtime_pilot_cli(["--output", str(output)])


if __name__ == "__main__":
    unittest.main()
