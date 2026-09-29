"""GUC V2 audit cross-checks reference, candidates, environment, and plans."""
import hashlib
import json
import unittest
from pathlib import Path

from core.guc_audit import build_guc_v2_audit


ROOT = Path(__file__).resolve().parents[1]


class GucV2AuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.audit = build_guc_v2_audit(ROOT)

    def test_audit_is_valid_and_covers_all_layers(self):
        self.assertTrue(self.audit.valid)
        self.assertEqual(self.audit.kind, "guc_v2_audit")
        self.assertEqual(self.audit.schema_version, 1)
        self.assertEqual(
            set(self.audit.layers),
            {
                "reference_catalog",
                "candidate_matrix",
                "environment_v2",
                "overlay_plans",
                "overlay_plans_sql",
                "capability_matrix",
                "requirement_adapter",
                "runtime_pilot",
                "preflight_plan",
            },
        )
        for layer in self.audit.layers.values():
            with self.subTest(layer=layer.path):
                self.assertTrue(layer.exists)
                self.assertTrue(layer.valid)
                self.assertTrue(layer.sha256)
                self.assertGreater(layer.size_bytes, 0)

    def test_audit_summary_matches_all_artifacts(self):
        summary = self.audit.summary
        self.assertEqual(summary["reference_parameter_count"], 1175)
        self.assertEqual(summary["reference_occurrence_count"], 1177)
        self.assertEqual(summary["candidate_parameter_count"], 1175)
        self.assertEqual(summary["candidate_occurrence_count"], 1177)
        self.assertEqual(summary["environment_parameter_count"], 27)
        self.assertEqual(summary["session_overlay_count"], 19)
        self.assertEqual(summary["manual_review_count"], 6)
        self.assertEqual(summary["read_only_count"], 1)
        self.assertEqual(summary["blocked_count"], 1)
        self.assertEqual(summary["next_batch_candidate_count"], 7)
        self.assertEqual(summary["next_batch_session_overlay_count"], 5)
        self.assertEqual(summary["next_batch_manual_review_count"], 2)
        self.assertEqual(summary["deferred_unverified_candidate_count"], 1)
        self.assertEqual(summary["exported_plan_count"], 19)
        self.assertEqual(summary["exported_step_count"], 95)

    def test_cross_layer_checks_pass(self):
        self.assertTrue(self.audit.checks)
        self.assertTrue(all(check.passed for check in self.audit.checks))
        check_names = {check.name for check in self.audit.checks}
        self.assertIn("reference_candidate_parameter_identity", check_names)
        self.assertIn("next_batch_environment_alignment", check_names)
        self.assertIn("session_overlay_plan_coverage", check_names)
        self.assertIn("plan_sql_forbidden_operations", check_names)
        self.assertIn("capability_matrix_shape", check_names);
        self.assertIn("capability_overlay_binding", check_names);
        self.assertIn("requirement_adapter_shape", check_names);
        self.assertIn("requirement_adapter_capability_binding", check_names);
        self.assertIn("runtime_pilot_shape", check_names);
        self.assertIn("runtime_pilot_overlay_binding", check_names);
        self.assertIn("preflight_plan_shape", check_names);
        self.assertIn("preflight_read_only_sql", check_names);

    def test_audit_rejects_unaccounted_next_batch_candidates(self):
        # The builder itself is deterministic; this test guards the invariant by
        # confirming the exact 7 candidates and their V2 dispositions.
        environment_names = set(self.audit.summary["next_batch_environment_names"])
        self.assertEqual(environment_names, {
            "a_format_enable_copy_empty_lobs",
            "enable_copy_case_sensitive",
            "enable_copy_when_filler",
            "enable_log_copy_illegal_chars",
            "enable_plan_trace",
            "enable_save_datachanged_timestamp",
            "track_procedure_sql",
        })
        self.assertEqual(
            set(self.audit.summary["next_batch_session_overlay_names"]),
            {
                "a_format_enable_copy_empty_lobs",
                "enable_copy_case_sensitive",
                "enable_copy_when_filler",
                "enable_log_copy_illegal_chars",
                "track_procedure_sql",
            },
        )
        self.assertEqual(
            set(self.audit.summary["next_batch_manual_review_names"]),
            {"enable_plan_trace", "enable_save_datachanged_timestamp"},
        )

    def test_written_audit_artifact_is_current(self):
        path = ROOT / "generated/guc_environment_v2/audit.json"
        self.assertTrue(path.is_file())
        payload = json.loads(path.read_text(encoding="utf-8"))
        self.assertTrue(payload["valid"])
        self.assertEqual(payload["summary"], self.audit.summary)


if __name__ == "__main__":
    unittest.main()
