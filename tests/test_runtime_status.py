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
        self.assertTrue(status.readiness["guc_v2_static_ready"])
        self.assertFalse(status.readiness["guc_v2_preflight_ready"])
        self.assertFalse(status.readiness["guc_v2_ready_for_authorized_execution"])
        self.assertFalse(status.readiness["guc_v2_runtime_executed"])
        self.assertFalse(status.readiness["guc_v2_runtime_audit_valid"])
        self.assertFalse(status.readiness["guc_v2_all_modeled_runtime_evidence_complete"])

        guc_runtime = status.artifacts["guc_v2_runtime_plan"]
        self.assertTrue(guc_runtime.exists)
        self.assertTrue(guc_runtime.valid)
        self.assertEqual(guc_runtime.summary["profile"], "runtime_guc_v2_pilot_v1")
        self.assertEqual(guc_runtime.summary["unit_count"], 19)
        self.assertEqual(guc_runtime.summary["step_count"], 95)
        self.assertFalse(guc_runtime.summary["database_executed"])
        self.assertFalse(guc_runtime.summary["execution_authorized"])
        self.assertEqual(guc_runtime.summary["runtime_verified"], 0)

        guc_readiness = status.artifacts["guc_v2_readiness"]
        self.assertTrue(guc_readiness.exists)
        self.assertTrue(guc_readiness.valid)
        self.assertTrue(guc_readiness.summary["static_audit_valid"])
        self.assertTrue(guc_readiness.summary["environment_v2_valid"])
        self.assertTrue(guc_readiness.summary["overlay_plans_valid"])
        self.assertTrue(guc_readiness.summary["runtime_plan_valid"])
        self.assertTrue(guc_readiness.summary["preflight_plan_valid"])
        self.assertFalse(guc_readiness.summary["preflight_result_present"])
        self.assertFalse(guc_readiness.summary["preflight_audit_valid"])
        self.assertFalse(guc_readiness.summary["ready_for_authorized_execution"])

        guc_receipt = status.artifacts["guc_v2_runtime_receipt"]
        self.assertFalse(guc_receipt.exists)
        self.assertFalse(guc_receipt.valid)

        guc_receipt_audit = status.artifacts["guc_v2_runtime_receipt_audit"]
        self.assertFalse(guc_receipt_audit.exists)
        self.assertFalse(guc_receipt_audit.valid)

        self.assertEqual(len(status.artifacts), 13)

        guc_evidence = status.artifacts["guc_v2_evidence_bundle"]
        self.assertTrue(guc_evidence.exists)
        self.assertTrue(guc_evidence.valid)
        self.assertEqual(guc_evidence.summary["artifact_count"], 15)
        self.assertEqual(guc_evidence.summary["present_count"], 11)
        self.assertEqual(guc_evidence.summary["missing_count"], 4)
        self.assertTrue(guc_evidence.summary["static_complete"])
        self.assertFalse(guc_evidence.summary["preflight_complete"])
        self.assertFalse(guc_evidence.summary["runtime_complete"])
        self.assertTrue(status.readiness["guc_v2_evidence_bundle_complete"])
        self.assertTrue(status.readiness["advanced_package_static_ready"])
        self.assertFalse(status.readiness["advanced_package_preflight_ready"])
        self.assertFalse(status.readiness["advanced_package_runtime_executed"])
        advanced_summary = status.artifacts["advanced_package_evidence_bundle"].summary
        self.assertTrue(advanced_summary["preflight_plan_valid"])
        self.assertFalse(advanced_summary["preflight_result_present"])
        self.assertFalse(advanced_summary["preflight_audit_present"])
        self.assertIn("Run the Advanced Package read-only preflight and resolve audit findings.", status.next_actions)
        self.assertFalse(status.readiness["advanced_package_all_complete"])

        advanced_evidence = status.artifacts["advanced_package_evidence_bundle"]
        self.assertTrue(advanced_evidence.exists)
        self.assertTrue(advanced_evidence.valid)
        self.assertEqual(advanced_evidence.summary["package_count"], 22)
        self.assertEqual(advanced_evidence.summary["supported_package_count"], 22)
        self.assertEqual(advanced_evidence.summary["unmodeled_supported_package_count"], 0)
        self.assertEqual(advanced_evidence.summary["interface_count"], 251)
        self.assertEqual(advanced_evidence.summary["test_case_count"], 27)
        self.assertTrue(advanced_evidence.summary["static_complete"])
        self.assertFalse(advanced_evidence.summary["runtime_complete"])

        self.assertTrue(status.readiness["advanced_package_runtime_candidate_coverage_complete"])
        self.assertEqual(status.artifacts["advanced_package_evidence_bundle"].summary["runtime_case_interface_count"], 77)
        self.assertEqual(status.artifacts["advanced_package_evidence_bundle"].summary["uncovered_runtime_candidate_interface_count"], 0)

        runtime_plan = status.artifacts["runtime_plan"]
        self.assertTrue(runtime_plan.exists)
        self.assertTrue(runtime_plan.valid)
        self.assertRegex(runtime_plan.sha256, r"[0-9a-f]{64}")
        self.assertGreater(runtime_plan.size_bytes, 0)
        self.assertEqual(runtime_plan.summary["unit_count"], 29)
        self.assertEqual(runtime_plan.summary["step_count"], 37)
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
        self.assertTrue(any("Run the GUC V2 read-only preflight" in action for action in status.next_actions))
        self.assertTrue(any("Clear GUC V2 readiness blockers" in action for action in status.next_actions))
        self.assertTrue(any("Execute the GUC V2 runtime pilot" in action for action in status.next_actions))
        self.assertTrue(any("Audit the GUC V2 runtime receipt" in action for action in status.next_actions))

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
