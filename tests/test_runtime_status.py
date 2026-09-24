"""Runtime status aggregates artifacts without inventing execution evidence."""
import json
import tempfile
import unittest
from pathlib import Path

from core.runtime_status import build_runtime_status
from scripts.runtime_status import main as status_main

ROOT = Path(__file__).resolve().parents[1]


class RuntimeStatusTests(unittest.TestCase):
    def test_current_repo_has_offline_plans_but_no_runtime_evidence(self):
        status = build_runtime_status(ROOT)
        self.assertTrue(status.readiness["offline_ready"])
        self.assertFalse(status.readiness["preflight_ready"])
        self.assertFalse(status.readiness["runtime_executed"])
        self.assertFalse(status.readiness["runtime_audit_valid"])
        self.assertFalse(status.readiness["phase1_executed"])
        self.assertFalse(status.readiness["phase1_audit_valid"])
        self.assertFalse(status.readiness["all_modeled_runtime_evidence_complete"])

        runtime_plan = status.artifacts["runtime_plan"]
        self.assertTrue(runtime_plan.exists)
        self.assertTrue(runtime_plan.valid)
        self.assertRegex(runtime_plan.sha256, r"[0-9a-f]{64}")
        self.assertGreater(runtime_plan.size_bytes, 0)
        self.assertEqual(runtime_plan.summary["unit_count"], 7)
        self.assertEqual(runtime_plan.summary["step_count"], 15)
        self.assertFalse(runtime_plan.summary["database_executed"])
        self.assertFalse(runtime_plan.summary["execution_authorized"])
        self.assertEqual(runtime_plan.summary["runtime_verified"], 0)

        phase1_plan = status.artifacts["phase1_plan"]
        self.assertTrue(phase1_plan.exists)
        self.assertTrue(phase1_plan.valid)
        self.assertRegex(phase1_plan.sha256, r"[0-9a-f]{64}")
        self.assertGreater(phase1_plan.size_bytes, 0)
        self.assertEqual(phase1_plan.summary["unit_count"], 10)
        self.assertTrue(phase1_plan.summary["has_setup"])
        self.assertTrue(phase1_plan.summary["has_cleanup"])

        self.assertIn("Run the read-only runtime preflight", status.next_actions[0])
        self.assertTrue(any("Execute the runtime pilot" in action for action in status.next_actions))
        self.assertTrue(any("Execute Phase 1" in action for action in status.next_actions))

    def test_empty_root_reports_missing_artifacts_and_offline_not_ready(self):
        with tempfile.TemporaryDirectory() as directory:
            status = build_runtime_status(Path(directory))
            self.assertFalse(status.readiness["offline_ready"])
            for artifact in status.artifacts.values():
                self.assertFalse(artifact.exists)
                self.assertFalse(artifact.valid)
            self.assertIn("Generate the runtime pilot dry-run plan.", status.next_actions)
            self.assertIn("Generate the Phase 1 dry-run plan.", status.next_actions)

    def test_cli_writes_status_and_rejects_overwrite(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "status.json"
            status_main(["--root", str(ROOT), "--output", str(output)])
            payload = json.loads(output.read_text())
            self.assertEqual(payload["kind"], "runtime_status")
            self.assertTrue(payload["readiness"]["offline_ready"])
            with self.assertRaisesRegex(SystemExit, "already exists"):
                status_main(["--root", str(ROOT), "--output", str(output)])


if __name__ == "__main__":
    unittest.main()
