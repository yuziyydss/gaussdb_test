"""One command rebuilds and checks the Advanced Package static evidence chain."""
import contextlib
import hashlib
import io
import json
import unittest
from pathlib import Path

from scripts.build_advanced_package_chain import (
    ADVANCED_PACKAGE_CHAIN_ARTIFACTS,
    main as chain_main,
)


ROOT = Path(__file__).resolve().parents[1]


class AdvancedPackageChainTests(unittest.TestCase):
    def test_chain_rebuilds_dry_run_and_evidence_bundle(self):
        with contextlib.redirect_stdout(io.StringIO()) as output:
            exit_code = chain_main(["--root", str(ROOT)])

        self.assertEqual(exit_code, 0)
        text = output.getvalue()
        for step in ("candidate_matrix", "runtime_dry_run", "evidence_bundle"):
            self.assertIn(f"building {step}...", text)
        self.assertIn("Advanced Package static chain rebuilt", text)

        runtime_path = ROOT / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["runtime_dry_run"]
        bundle_path = ROOT / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["evidence_bundle"]
        self.assertTrue(runtime_path.is_file())
        self.assertTrue(bundle_path.is_file())

        payload = json.loads(runtime_path.read_text(encoding="utf-8"))
        self.assertEqual(payload["profile"], "runtime_validation_pilot_v1")
        self.assertEqual(len(payload["units"]), 29)
        self.assertEqual(
            sum(len(unit["execution_plan"]) for unit in payload["units"]),
            37,
        )
        self.assertFalse(payload["database_executed"])
        self.assertFalse(payload["execution_authorized"])
        self.assertEqual(payload["runtime_verified"], 0)
        self.assertRegex(payload["plan_sha256"], r"[0-9a-f]{64}")

        policy_path = ROOT / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["policy_audit"]
        self.assertTrue(policy_path.is_file())
        policy = json.loads(policy_path.read_text(encoding="utf-8"))
        self.assertEqual(policy["kind"], "advanced_package_policy_audit")
        self.assertEqual(policy["summary"]["audited_package_count"], 8)
        self.assertEqual(policy["summary"]["documented_callable_count"], 99)
        self.assertEqual(policy["summary"]["modeled_callable_count"], 99)
        self.assertEqual(policy["summary"]["modeled_signature_count"], 126)
        self.assertEqual(policy["summary"]["recommended_runtime_candidate_count"], 38)
        self.assertEqual(policy["summary"]["recommended_blocked_count"], 6)

        bundle = json.loads(bundle_path.read_text(encoding="utf-8"))
        self.assertEqual(bundle["summary"]["package_count"], 22)
        self.assertEqual(bundle["summary"]["interface_count"], 251)
        self.assertEqual(bundle["summary"]["test_case_count"], 27)
        self.assertTrue(bundle["summary"]["static_complete"])
        self.assertFalse(bundle["summary"]["runtime_complete"])

    def test_chain_check_passes_when_artifacts_are_stable(self):
        with contextlib.redirect_stdout(io.StringIO()) as output:
            exit_code = chain_main(["--root", str(ROOT), "--check"])
        self.assertEqual(exit_code, 0)
        self.assertIn("Advanced Package static chain check passed", output.getvalue())

    def test_chain_check_detects_artifact_drift(self):
        artifact = ROOT / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["evidence_bundle"]
        original = artifact.read_bytes()
        try:
            artifact.write_bytes(original + b"\n")
            with contextlib.redirect_stdout(io.StringIO()) as output:
                exit_code = chain_main(["--root", str(ROOT), "--check"])
            self.assertEqual(exit_code, 1)
            self.assertIn("artifact hash drift detected", output.getvalue())
            self.assertIn("evidence_bundle", output.getvalue())
        finally:
            artifact.write_bytes(original)

    def test_chain_does_not_claim_runtime_evidence(self):
        with contextlib.redirect_stdout(io.StringIO()):
            chain_main(["--root", str(ROOT)])
        bundle = json.loads(
            (ROOT / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["evidence_bundle"])
            .read_text(encoding="utf-8")
        )
        self.assertFalse(bundle["summary"]["runtime_complete"])
        self.assertFalse(bundle["summary"]["all_complete"])


if __name__ == "__main__":
    unittest.main()
