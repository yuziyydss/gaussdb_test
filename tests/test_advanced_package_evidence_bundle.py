"""Advanced Package evidence bundle inventories pilot coverage and runtime gaps."""
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from core.advanced_package import AdvancedPackageRegistry
from core.advanced_package_evidence import (
    build_advanced_package_evidence_bundle,
    verify_advanced_package_evidence_bundle,
)


ROOT = Path(__file__).resolve().parents[1]


class AdvancedPackageEvidenceBundleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.bundle = build_advanced_package_evidence_bundle(ROOT)

    def test_bundle_inventories_pilot_and_runtime_artifacts(self):
        self.assertEqual(self.bundle.schema_version, 1)
        self.assertEqual(self.bundle.kind, "advanced_package_evidence_bundle")
        self.assertEqual(self.bundle.summary.artifact_count, 8)
        self.assertEqual(self.bundle.summary.present_count, 4)
        self.assertEqual(self.bundle.summary.missing_count, 4)
        self.assertTrue(self.bundle.summary.static_complete)
        self.assertFalse(self.bundle.summary.runtime_complete)
        self.assertFalse(self.bundle.summary.all_complete)

    def test_pilot_contract_scale_is_explicit(self):
        summary = self.bundle.summary
        self.assertEqual(summary.package_count, 22)
        self.assertEqual(summary.supported_package_count, 22)
        self.assertEqual(summary.unmodeled_supported_package_count, 0)
        self.assertEqual(summary.interface_count, 251)
        self.assertEqual(summary.runtime_candidate_interface_count, 77)
        self.assertEqual(summary.manual_review_interface_count, 172)
        self.assertEqual(summary.static_probe_interface_count, 2)
        self.assertEqual(summary.test_case_count, 27)
        self.assertEqual(summary.runtime_dry_run_advanced_unit_count, 27)
        self.assertEqual(summary.runtime_dry_run_advanced_step_count, 27)
        self.assertEqual(summary.runtime_case_interface_count, 77)
        self.assertEqual(summary.uncovered_runtime_candidate_interface_count, 0)
        self.assertTrue(summary.runtime_candidate_case_coverage_complete)
        self.assertTrue(self.bundle.runtime_dry_run.interface_ids)
        self.assertEqual(
            set(self.bundle.uncovered_runtime_candidate_interface_ids),
            set(self.bundle.uncovered_runtime_candidate_interface_ids),
        )
        self.assertFalse(self.bundle.uncovered_runtime_candidate_interface_ids)

    def test_present_artifacts_are_hash_bound(self):
        by_name = {item.name: item for item in self.bundle.artifacts}
        for name in ("interface_inventory", "runtime_dry_run"):
            with self.subTest(artifact=name):
                artifact = by_name[name]
                self.assertTrue(artifact.exists)
                self.assertRegex(artifact.sha256, r"[0-9a-f]{64}")
                self.assertGreater(artifact.size_bytes, 0)
                actual_hash = hashlib.sha256(
                    (ROOT / artifact.path).read_bytes()
                ).hexdigest()
                self.assertEqual(artifact.sha256, actual_hash)

    def test_missing_runtime_artifacts_are_explicit(self):
        by_name = {item.name: item for item in self.bundle.artifacts}
        self.assertEqual(
            {name for name, artifact in by_name.items() if not artifact.exists},
            {"runtime_preflight_result", "runtime_preflight_audit", "runtime_receipt", "runtime_receipt_audit"},
        )

    def test_runtime_dry_run_units_match_advanced_pilot_cases(self):
        runtime = self.bundle.runtime_dry_run
        self.assertIsNotNone(runtime)
        self.assertEqual(runtime.unit_count, 27)
        self.assertEqual(runtime.step_count, 27)
        self.assertEqual(len(runtime.unit_ids), 27)
        self.assertIn("adv_case_dbe_raw_bit_and", runtime.unit_ids)
        self.assertIn("adv_case_dbe_raw_cast_number_roundtrip", runtime.unit_ids)
        self.assertTrue(set(runtime.case_ids).issuperset(runtime.unit_ids))
        self.assertTrue(all(item.runtime_verified is False for item in runtime.units))

    def test_all_runtime_candidate_interfaces_are_covered_by_dry_run(self):
        registry = AdvancedPackageRegistry(ROOT)
        registry.load_all()
        runtime_candidate_ids = {
            interface.id
            for package in registry.environment.packages
            for interface in package.interfaces
            if interface.execution_policy == "runtime_candidate"
        }
        dry_run_interface_ids = {
            interface_id
            for unit in self.bundle.runtime_dry_run.units
            for interface_id in unit.interface_refs
        }
        self.assertEqual(len(runtime_candidate_ids), 77)
        self.assertEqual(len(dry_run_interface_ids), 77)
        self.assertFalse(runtime_candidate_ids - dry_run_interface_ids)
        self.assertTrue(self.bundle.summary.runtime_candidate_case_coverage_complete)

    def test_written_bundle_is_current_and_verifiable(self):
        path = ROOT / "generated/advanced_package_pilot/evidence_bundle.json"
        self.assertTrue(path.is_file())
        payload = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(payload["kind"], "advanced_package_evidence_bundle")
        self.assertTrue(payload["summary"]["static_complete"])

        result = verify_advanced_package_evidence_bundle(ROOT)
        self.assertTrue(result.valid, result.errors)
        self.assertEqual(result.recorded_summary.package_count, 22)
        self.assertEqual(result.current_summary.package_count, 22)

    def test_cli_builds_and_verifies_bundle(self):
        import io
        import contextlib

        from scripts.build_advanced_package_evidence_bundle import main as build_main
        from scripts.verify_advanced_package_evidence_bundle import main as verify_main

        with tempfile.TemporaryDirectory() as directory:
            bundle_path = Path(directory) / "evidence_bundle.json"
            report_path = Path(directory) / "verification.json"
            with contextlib.redirect_stdout(io.StringIO()):
                build_exit = build_main(["--output", str(bundle_path)])
            self.assertEqual(build_exit, 0)

            with contextlib.redirect_stdout(io.StringIO()):
                verify_exit = verify_main([
                    "--root", str(ROOT),
                    "--output", str(report_path),
                ])
            self.assertEqual(verify_exit, 0)
            report = json.loads(report_path.read_text(encoding="utf-8"))
            self.assertTrue(report["valid"])
            self.assertEqual(report["current_summary"]["package_count"], 22)
            self.assertEqual(report["current_summary"]["interface_count"], 251)

    def test_artifact_drift_fails_closed(self):
        artifact = ROOT / "generated/runtime_validation_pilot/dry_run.json"
        original = artifact.read_bytes()
        try:
            artifact.write_bytes(original + b"\n")
            result = verify_advanced_package_evidence_bundle(ROOT)
            self.assertFalse(result.valid)
            self.assertTrue(any("runtime_dry_run" in error for error in result.errors))
        finally:
            artifact.write_bytes(original)

    def test_missing_bundle_fails_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            result = verify_advanced_package_evidence_bundle(Path(directory))
            self.assertFalse(result.valid)
            self.assertTrue(any("evidence bundle" in error.lower() for error in result.errors))


try:
    from fastapi.testclient import TestClient
    from main import app
    HAS_FASTAPI = True
except ImportError:
    HAS_FASTAPI = False


@unittest.skipUnless(HAS_FASTAPI, "fastapi or httpx dependencies are unavailable")
class AdvancedPackageApiTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.client = TestClient(app)

    def test_runtime_plan_api_reports_all_units_and_steps_without_runtime_claims(self):
        response = self.client.get("/api/advanced-package/runtime-plan")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "runtime_validation_pilot")
        self.assertEqual(payload["profile"], "runtime_validation_pilot_v1")
        self.assertEqual(len(payload["units"]), 29)
        self.assertEqual(
            sum(len(unit["execution_plan"]) for unit in payload["units"]),
            37,
        )
        self.assertFalse(payload["database_executed"])
        self.assertFalse(payload["execution_authorized"])
        self.assertEqual(payload["runtime_verified"], 0)
        advanced_units = [unit for unit in payload["units"] if unit["kind"] == "advanced_package"]
        self.assertEqual(len(advanced_units), 27)
        self.assertEqual(
            [unit["kind"] for unit in payload["units"][:2]],
            ["guc_overlay", "guc_overlay"],
        )
        for unit in advanced_units:
            with self.subTest(unit=unit["id"]):
                self.assertEqual(unit["status"], "ready_for_authorized_execution")
                self.assertFalse(unit["database_executed"])
                self.assertFalse(unit["runtime_verified"])
                self.assertEqual(unit["oracle"]["status"], "needs_verification")

    def test_pilot_api_reports_modeled_interfaces_and_cases(self):
        response = self.client.get("/api/advanced-package/pilot")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "advanced_package_environment")
        self.assertEqual(len(payload["packages"]), 22)
        self.assertEqual(len(payload["test_cases"]), 27)

    def test_advanced_package_page_shows_static_and_runtime_boundary(self):
        response = self.client.get("/advanced-package")
        self.assertEqual(response.status_code, 200)
        self.assertIn("高级包静态证据链", response.text)
        self.assertIn("DBE_OBFUSCATION_TOOLKIT", response.text)
        self.assertIn("Candidate Matrix", response.text)
        self.assertIn("Runtime证据", response.text)
        self.assertIn("Runtime候选覆盖", response.text)
        self.assertIn("Execution Gate", response.text)
        self.assertIn("GAUSSDB_RUNTIME_PILOT_AUTHORIZED", response.text)
        self.assertIn("GAUSSDB_ENABLED", response.text)
        self.assertIn("0 uncovered", response.text)
        self.assertIn("Preflight</span>", response.text)
        self.assertIn("Result + audit + 0 findings", response.text)
        self.assertIn("29 units / 37 steps", response.text)
        self.assertIn("当前页面只读取本地高级包产物", response.text)

    def test_candidate_matrix_api_reports_supported_and_modeled_packages(self):
        response = self.client.get("/api/advanced-package/candidate-matrix")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "advanced_package_candidate_matrix")
        self.assertEqual(payload["summary"]["supported_package_count"], 22)
        self.assertEqual(payload["summary"]["modeled_package_count"], 22)
        self.assertEqual(payload["summary"]["unmodeled_package_count"], 0)

    def test_evidence_bundle_api_reports_static_and_runtime_state(self):
        response = self.client.get("/api/advanced-package/evidence-bundle")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "advanced_package_evidence_bundle")
        self.assertEqual(payload["summary"]["artifact_count"], 8)
        self.assertEqual(payload["summary"]["present_count"], 4)
        self.assertEqual(payload["summary"]["missing_count"], 4)
        self.assertTrue(payload["summary"]["static_complete"])
        self.assertFalse(payload["summary"]["runtime_complete"])

    def test_runtime_candidate_coverage_api_reports_full_coverage(self):
        response = self.client.get("/api/advanced-package/runtime-candidate-coverage")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "advanced_package_runtime_candidate_coverage")
        self.assertEqual(payload["runtime_candidate_interface_count"], 77)
        self.assertEqual(payload["runtime_case_interface_count"], 77)
        self.assertEqual(payload["uncovered_runtime_candidate_interface_count"], 0)
        self.assertTrue(payload["runtime_candidate_case_coverage_complete"])
        self.assertEqual(len(payload["runtime_candidate_interface_ids"]), 77)
        self.assertEqual(len(payload["runtime_case_interface_ids"]), 77)
        self.assertEqual(payload["uncovered_runtime_candidate_interface_ids"], [])

    def test_execution_gate_api_blocks_without_authorization(self):
        response = self.client.get("/api/advanced-package/execution-gate")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "advanced_package_gate")
        self.assertTrue(payload["static_ready"])
        self.assertTrue(payload["runtime_plan_ready"])
        self.assertTrue(payload["static_ready"])
        self.assertTrue(payload["runtime_plan_ready"])
        self.assertFalse(payload["preflight_ready"])
        self.assertFalse(payload["technical_ready"])
        self.assertFalse(payload["authorization_requested"])
        self.assertFalse(payload["allowed"])

    def test_evidence_bundle_verify_api_reports_file_identity(self):
        response = self.client.get("/api/advanced-package/evidence-bundle/verify")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "advanced_package_evidence_bundle_verification")
        self.assertTrue(payload["valid"])
        self.assertEqual(payload["current_summary"]["package_count"], 22)


if __name__ == "__main__":
    unittest.main()
