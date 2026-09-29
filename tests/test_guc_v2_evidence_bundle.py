"""GUC V2 evidence bundle inventories static, preflight, and runtime artifacts."""
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from core.guc_evidence_bundle import build_guc_v2_evidence_bundle


ROOT = Path(__file__).resolve().parents[1]


class GucV2EvidenceBundleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.bundle = build_guc_v2_evidence_bundle(ROOT)

    def test_bundle_contains_all_guc_v2_artifacts(self):
        self.assertEqual(self.bundle.schema_version, 1)
        self.assertEqual(self.bundle.kind, "guc_v2_evidence_bundle")
        self.assertEqual(self.bundle.summary.artifact_count, 15)
        self.assertEqual(self.bundle.summary.present_count, 11)
        self.assertEqual(self.bundle.summary.missing_count, 4)
        self.assertEqual(
            {artifact.name for artifact in self.bundle.artifacts},
            {
                "environment_v2",
                "reference_catalog",
                "candidate_matrix",
                "overlay_plans",
                "overlay_plans_sql",
                "capability_matrix",
                "requirement_adapter",
                "preflight_plan",
                "preflight_result",
                "preflight_audit",
                "runtime_dry_run",
                "runtime_receipt",
                "runtime_receipt_audit",
                "readiness",
                "static_audit",
            },
        )

    def test_present_artifacts_have_identity_and_missing_artifacts_are_explicit(self):
        by_name = {artifact.name: artifact for artifact in self.bundle.artifacts}
        for name in (
            "environment_v2",
            "reference_catalog",
            "candidate_matrix",
            "overlay_plans",
            "overlay_plans_sql",
            "capability_matrix",
            "requirement_adapter",
            "preflight_plan",
            "runtime_dry_run",
            "readiness",
            "static_audit",
        ):
            with self.subTest(artifact=name):
                artifact = by_name[name]
                self.assertTrue(artifact.exists)
                self.assertRegex(artifact.sha256, r"[0-9a-f]{64}")
                self.assertGreater(artifact.size_bytes, 0)
                actual_hash = hashlib.sha256((ROOT / artifact.path).read_bytes()).hexdigest()
                self.assertEqual(artifact.sha256, actual_hash)

        for name in (
            "preflight_result",
            "preflight_audit",
            "runtime_receipt",
            "runtime_receipt_audit",
        ):
            with self.subTest(missing=name):
                artifact = by_name[name]
                self.assertFalse(artifact.exists)
                self.assertIsNone(artifact.sha256)
                self.assertIsNone(artifact.size_bytes)

    def test_layers_separate_static_preflight_and_runtime_evidence(self):
        layers = {layer.name: layer for layer in self.bundle.layers}
        self.assertEqual(set(layers), {"static", "preflight", "runtime"})
        self.assertTrue(layers["static"].complete)
        self.assertFalse(layers["preflight"].complete)
        self.assertFalse(layers["runtime"].complete)
        self.assertEqual(layers["static"].present_count, 11)
        self.assertEqual(layers["static"].missing_count, 0)
        self.assertEqual(layers["preflight"].present_count, 0)
        self.assertEqual(layers["preflight"].missing_count, 2)
        self.assertEqual(layers["runtime"].present_count, 0)
        self.assertEqual(layers["runtime"].missing_count, 2)

    def test_summary_does_not_claim_runtime_evidence(self):
        summary = self.bundle.summary
        self.assertTrue(summary.static_complete)
        self.assertFalse(summary.preflight_complete)
        self.assertFalse(summary.runtime_complete)
        self.assertFalse(summary.all_complete)
        self.assertIn(
            "Static evidence does not prove database behavior.",
            self.bundle.limits,
        )

    def test_written_bundle_artifact_is_current(self):
        path = ROOT / "generated/guc_environment_v2/evidence_bundle.json"
        self.assertTrue(path.is_file())
        payload = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(payload["kind"], "guc_v2_evidence_bundle")
        self.assertTrue(payload["summary"]["static_complete"])
        self.assertFalse(payload["summary"]["preflight_complete"])
        self.assertFalse(payload["summary"]["runtime_complete"])

    def test_layer_count_drift_fails_closed(self):
        payload = self.bundle.model_dump()
        payload["layers"][1]["present_count"] = 1
        payload["layers"][1]["missing_count"] = 1
        with self.assertRaises(ValueError) as caught:
            type(self.bundle)(**payload)
        self.assertIn("preflight layer present_count is inconsistent", str(caught.exception))

    def test_layer_artifact_drift_fails_closed(self):
        payload = self.bundle.model_dump()
        payload["layers"][0]["artifacts"] = payload["layers"][0]["artifacts"][:-1]
        payload["layers"][0]["present_count"] = len(payload["layers"][0]["artifacts"])
        with self.assertRaises(ValueError) as caught:
            type(self.bundle)(**payload)
        self.assertIn("evidence layers must cover every artifact exactly once", str(caught.exception))

    def test_empty_root_reports_missing_static_evidence(self):
        with tempfile.TemporaryDirectory() as directory:
            bundle = build_guc_v2_evidence_bundle(Path(directory))
            self.assertEqual(bundle.summary.artifact_count, 15)
            self.assertEqual(bundle.summary.present_count, 0)
            self.assertEqual(bundle.summary.missing_count, 15)
            self.assertFalse(bundle.summary.static_complete)
            self.assertFalse(bundle.summary.all_complete)


if __name__ == "__main__":
    unittest.main()
