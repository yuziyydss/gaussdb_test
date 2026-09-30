"""Evidence bundle verification detects artifact drift without rebuilding sources."""
import json
import tempfile
import unittest
from pathlib import Path

from core.guc_evidence_bundle import verify_guc_v2_evidence_bundle
from scripts.verify_guc_v2_evidence_bundle import main as verify_main


ROOT = Path(__file__).resolve().parents[1]


class GucV2EvidenceBundleVerificationTests(unittest.TestCase):
    def test_current_evidence_bundle_matches_artifacts(self):
        result = verify_guc_v2_evidence_bundle(ROOT)
        self.assertTrue(result.valid, result.errors)
        self.assertEqual(result.recorded_summary.artifact_count, 15)
        self.assertEqual(result.current_summary.artifact_count, 15)
        self.assertEqual(result.recorded_summary.present_count, 11)
        self.assertEqual(result.current_summary.present_count, 11)
        self.assertEqual(result.recorded_summary.missing_count, 4)
        self.assertEqual(result.current_summary.missing_count, 4)
        self.assertTrue(result.recorded_summary.static_complete)
        self.assertTrue(result.current_summary.static_complete)
        self.assertFalse(result.recorded_summary.preflight_complete)
        self.assertFalse(result.current_summary.preflight_complete)
        self.assertFalse(result.recorded_summary.runtime_complete)
        self.assertFalse(result.current_summary.runtime_complete)

    def test_artifact_drift_is_detected(self):
        artifact = ROOT / "generated/guc_environment_v2/readiness.json"
        original = artifact.read_bytes()
        try:
            artifact.write_bytes(original + b"\n")
            result = verify_guc_v2_evidence_bundle(ROOT)
            self.assertFalse(result.valid)
            self.assertTrue(result.errors)
            self.assertTrue(any("readiness" in error for error in result.errors))
        finally:
            artifact.write_bytes(original)

    def test_missing_bundle_is_reported(self):
        with tempfile.TemporaryDirectory() as directory:
            result = verify_guc_v2_evidence_bundle(Path(directory))
            self.assertFalse(result.valid)
            self.assertTrue(any("evidence bundle" in error.lower() for error in result.errors))

    def test_cli_verifies_current_bundle(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "verification.json"
            exit_code = verify_main(["--root", str(ROOT), "--output", str(output)])
            self.assertEqual(exit_code, 0)
            payload = json.loads(output.read_text(encoding="utf-8"))
            self.assertTrue(payload["valid"])
            self.assertEqual(payload["kind"], "guc_v2_evidence_bundle_verification")
            self.assertEqual(payload["recorded_summary"]["artifact_count"], 15)
            self.assertEqual(payload["current_summary"]["artifact_count"], 15)


if __name__ == "__main__":
    unittest.main()
