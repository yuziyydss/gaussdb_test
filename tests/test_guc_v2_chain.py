"""One command rebuilds the complete static GUC V2 evidence chain."""
import contextlib
import io
import json
import unittest
from pathlib import Path

from scripts.build_guc_v2_chain import main as chain_main


ROOT = Path(__file__).resolve().parents[1]


class GucV2ChainTests(unittest.TestCase):
    def test_chain_rebuilds_all_static_artifacts(self):
        with contextlib.redirect_stdout(io.StringIO()) as output:
            exit_code = chain_main(["--root", str(ROOT)])

        self.assertEqual(exit_code, 0)
        text = output.getvalue()
        for step in (
            "reference_catalog",
            "candidate_matrix",
            "overlay_plans",
            "capability_matrix",
            "requirement_adapter",
            "preflight_plan",
            "runtime_dry_run",
            "static_audit",
            "readiness",
            "evidence_bundle",
        ):
            self.assertIn(f"building {step}...", text)
        self.assertIn("GUC V2 static chain rebuilt", text)

        expected_paths = {
            "reference_catalog": ROOT / "generated/guc_reference_catalog/catalog.json",
            "candidate_matrix": ROOT / "generated/guc_candidate_matrix/matrix.json",
            "overlay_plans": ROOT / "generated/guc_environment_v2/overlay_plans.json",
            "overlay_plans_sql": ROOT / "generated/guc_environment_v2/overlay_plans.sql",
            "capability_matrix": ROOT / "generated/guc_environment_v2/capability_matrix.json",
            "requirement_adapter": ROOT / "generated/guc_environment_v2/requirement_adapter.json",
            "preflight_plan": ROOT / "generated/guc_environment_v2/preflight_plan.json",
            "runtime_dry_run": ROOT / "generated/guc_environment_v2/runtime_dry_run.json",
            "static_audit": ROOT / "generated/guc_environment_v2/audit.json",
            "readiness": ROOT / "generated/guc_environment_v2/readiness.json",
            "evidence_bundle": ROOT / "generated/guc_environment_v2/evidence_bundle.json",
        }
        for name, path in expected_paths.items():
            with self.subTest(artifact=name):
                self.assertTrue(path.is_file())
                self.assertGreater(path.stat().st_size, 0)

    def test_chain_result_keeps_runtime_evidence_honest(self):
        evidence_path = ROOT / "generated/guc_environment_v2/evidence_bundle.json"
        readiness_path = ROOT / "generated/guc_environment_v2/readiness.json"
        evidence = json.loads(evidence_path.read_text(encoding="utf-8"))
        readiness = json.loads(readiness_path.read_text(encoding="utf-8"))

        self.assertTrue(evidence["summary"]["static_complete"])
        self.assertFalse(evidence["summary"]["preflight_complete"])
        self.assertFalse(evidence["summary"]["runtime_complete"])
        self.assertFalse(evidence["summary"]["all_complete"])

        self.assertFalse(readiness["preflight_result_present"])
        self.assertFalse(readiness["preflight_audit_valid"])
        self.assertFalse(readiness["ready_for_authorized_execution"])
        self.assertFalse(readiness["runtime_verified"])

    def test_chain_check_mode_detects_artifact_drift(self):
        artifact = ROOT / "generated/guc_environment_v2/runtime_dry_run.json"
        original = artifact.read_bytes()
        try:
            artifact.write_bytes(original + b"\n")
            with contextlib.redirect_stdout(io.StringIO()) as output:
                exit_code = chain_main(["--root", str(ROOT), "--check"])
            self.assertEqual(exit_code, 1)
            self.assertIn("artifact hash drift detected", output.getvalue())
            self.assertIn("runtime_dry_run", output.getvalue())
        finally:
            artifact.write_bytes(original)

    def test_chain_does_not_create_runtime_receipts(self):
        self.assertFalse(
            (ROOT / "generated/guc_environment_v2/preflight_result.json").exists()
        )
        self.assertFalse(
            (ROOT / "generated/guc_environment_v2/preflight_audit.json").exists()
        )
        self.assertFalse(
            (ROOT / "generated/guc_environment_v2/runtime_receipt.json").exists()
        )
        self.assertFalse(
            (ROOT / "generated/guc_environment_v2/runtime_receipt_audit.json").exists()
        )


if __name__ == "__main__":
    unittest.main()
