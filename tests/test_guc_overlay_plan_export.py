"""GUC V2 overlay plans are deterministic, source-bound, and execution-safe."""
import hashlib
import json
import re
import unittest
from pathlib import Path

from core.guc_environment import GucEnvironmentRegistry
from core.guc_plan_export import (
    GucOverlayPlanExportError,
    GucOverlayPlanExportRegistry,
    render_guc_overlay_plan_sql,
)


ROOT = Path(__file__).resolve().parents[1]
PLAN_ACTIONS = [
    "capture_original", "apply", "verify_target", "restore", "verify_restore",
]


class GucOverlayPlanExportTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.export = GucOverlayPlanExportRegistry(ROOT).load()
        cls.sql_path = ROOT / "generated/guc_environment_v2/overlay_plans.sql"

    def test_export_contains_all_v2_session_overlay_parameters(self):
        summary = self.export.summary
        self.assertEqual(self.export.schema_version, 1)
        self.assertEqual(self.export.kind, "guc_overlay_plan_export")
        self.assertEqual(summary.environment_parameter_count, 27)
        self.assertEqual(summary.exported_plan_count, 19)
        self.assertEqual(summary.excluded_parameter_count, 8)
        self.assertEqual(summary.step_count, 95)
        self.assertEqual(len(self.export.plans), 19)
        self.assertEqual(
            len({plan.parameter_id for plan in self.export.plans}), 19
        )

    def test_each_plan_is_capture_apply_verify_restore(self):
        for plan in self.export.plans:
            with self.subTest(parameter=plan.parameter_name):
                self.assertEqual([step.action for step in plan.steps], PLAN_ACTIONS)
                self.assertTrue(all(step.must_succeed for step in plan.steps))
                self.assertIn(f"SET {plan.parameter_name} = {plan.target_value};", plan.steps[1].sql)
                self.assertIn(f"SET {plan.parameter_name} = {plan.original_value};", plan.steps[3].sql)

    def test_rendered_sql_contains_no_global_or_reset_operations(self):
        sql = self.sql_path.read_text(encoding="utf-8")
        self.assertEqual(sql, render_guc_overlay_plan_sql(self.export))
        for forbidden in ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET "):
            self.assertNotIn(forbidden, sql)
        self.assertEqual(sql.count("SET "), 38)

    def test_export_is_bound_to_environment_v2_source(self):
        source = self.export.source
        self.assertEqual(source.relpath, "environments/guc_parameters_v2.yaml")
        actual_hash = hashlib.sha256((ROOT / source.relpath).read_bytes()).hexdigest()
        self.assertEqual(source.sha256, actual_hash)

    def test_manual_review_read_only_and_blocked_parameters_are_excluded(self):
        names = {plan.parameter_name for plan in self.export.plans}
        registry = GucEnvironmentRegistry(
            ROOT,
            inventory_path=ROOT / "environments/guc_parameters_v2.yaml",
        )
        registry.load_all()
        excluded = {
            parameter.name
            for parameter in registry.parameters.values()
            if parameter.execution_policy != "session_overlay"
        }
        self.assertEqual(len(excluded), 8)
        self.assertEqual(names & excluded, set())
        self.assertIn("enable_plan_trace", excluded)
        self.assertIn("enable_save_datachanged_timestamp", excluded)
        self.assertIn("sql_compatibility", excluded)
        self.assertIn("enable_global_plancache", excluded)

    def test_payload_with_drifted_summary_fails_closed(self):
        payload = json.loads(
            (ROOT / "generated/guc_environment_v2/overlay_plans.json").read_text(encoding="utf-8")
        )
        payload["summary"]["exported_plan_count"] += 1
        with self.assertRaises(GucOverlayPlanExportError) as caught:
            GucOverlayPlanExportRegistry(ROOT).load_payload(payload)
        self.assertIn("summary", str(caught.exception))


if __name__ == "__main__":
    unittest.main()
