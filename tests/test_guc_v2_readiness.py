"""GUC V2 readiness separates static readiness from authorization and runtime evidence."""
import json
import tempfile
import unittest
from pathlib import Path

from core.guc_readiness import build_guc_v2_readiness


ROOT = Path(__file__).resolve().parents[1]


class GucV2ReadinessTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.readiness = build_guc_v2_readiness(ROOT)

    def test_static_layers_are_ready_but_runtime_is_not(self):
        self.assertEqual(self.readiness.kind, "guc_v2_readiness")
        self.assertEqual(self.readiness.schema_version, 1)
        self.assertTrue(self.readiness.static_audit_valid)
        self.assertTrue(self.readiness.environment_v2_valid)
        self.assertTrue(self.readiness.overlay_plans_valid)
        self.assertTrue(self.readiness.runtime_plan_valid)
        self.assertTrue(self.readiness.preflight_plan_valid)
        self.assertFalse(self.readiness.preflight_result_present)
        self.assertFalse(self.readiness.preflight_result_valid)
        self.assertFalse(self.readiness.preflight_audit_valid)
        self.assertFalse(self.readiness.preflight_connected)
        self.assertFalse(self.readiness.preflight_metadata_read)
        self.assertFalse(self.readiness.ready_for_authorized_execution)
        self.assertFalse(self.readiness.execution_authorized)
        self.assertFalse(self.readiness.runtime_verified)

    def test_summary_counts_match_guc_v2_artifacts(self):
        summary = self.readiness.summary
        self.assertEqual(summary["environment_parameter_count"], 27)
        self.assertEqual(summary["overlay_plan_count"], 19)
        self.assertEqual(summary["overlay_step_count"], 95)
        self.assertEqual(summary["runtime_unit_count"], 19)
        self.assertEqual(summary["runtime_step_count"], 95)
        self.assertEqual(summary["preflight_query_count"], 27)
        self.assertEqual(summary["static_audit_check_count"], 25)
        self.assertIsNone(summary["preflight_domain_mismatch_count"])
        self.assertIsNone(summary["preflight_error_count"])
        self.assertFalse(summary["preflight_audit_valid"])

    def test_blockers_and_next_actions_do_not_fake_authorization(self):
        self.assertIn(
            "GUC V2 preflight result is missing.",
            self.readiness.blockers,
        )
        self.assertIn(
            "Runtime execution is not authorized.",
            self.readiness.blockers,
        )
        self.assertTrue(any(
            "Run the GUC V2 read-only preflight" in action
            for action in self.readiness.next_actions
        ))
        self.assertTrue(any(
            "Do not authorize GUC V2 execution" in action
            for action in self.readiness.next_actions
        ))
        self.assertTrue(any(
            "runtime behavior is not verified" in limit.lower()
            for limit in self.readiness.limits
        ))

    def test_readiness_artifact_is_written_and_current(self):
        path = ROOT / "generated/guc_environment_v2/readiness.json"
        self.assertTrue(path.is_file())
        payload = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(payload["kind"], "guc_v2_readiness")
        self.assertTrue(payload["static_audit_valid"])
        self.assertFalse(payload["ready_for_authorized_execution"])

    def test_empty_root_reports_missing_static_layers(self):
        with tempfile.TemporaryDirectory() as directory:
            readiness = build_guc_v2_readiness(Path(directory))
            self.assertFalse(readiness.static_audit_valid)
            self.assertFalse(readiness.environment_v2_valid)
            self.assertFalse(readiness.overlay_plans_valid)
            self.assertFalse(readiness.preflight_plan_valid)
            self.assertFalse(readiness.ready_for_authorized_execution)
            self.assertIn("GUC V2 static audit is missing or invalid.", readiness.blockers)


if __name__ == "__main__":
    unittest.main()
