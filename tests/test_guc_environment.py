"""GUC environment model and fail-closed session overlay planning."""
from pathlib import Path
import unittest

from core.guc_environment import (
    GucEnvironmentPlanner,
    GucEnvironmentRegistry,
)

ROOT = Path(__file__).resolve().parents[1]


class GucEnvironmentModelTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = GucEnvironmentRegistry(ROOT)
        cls.registry.load_all()

    def test_pilot_inventory_is_complete_unique_and_traceable(self):
        self.assertEqual(len(self.registry.parameters), 20)
        self.assertEqual(len(self.registry.parameters_by_name), 20)
        for parameter in self.registry.parameters.values():
            with self.subTest(parameter=parameter.name):
                self.assertTrue((ROOT / parameter.source.source_relpath).is_file())
                self.assertTrue(parameter.source.anchor)
                for fact_id in parameter.fact_refs:
                    self.assertEqual(self.registry.fact_statuses[fact_id], "confirmed")

    def test_execution_policy_is_explicit_and_fail_closed(self):
        policies = {
            parameter.name: parameter.execution_policy
            for parameter in self.registry.parameters.values()
        }
        self.assertEqual(policies["sql_compatibility"], "read_only")
        self.assertEqual(policies["enable_global_plancache"], "blocked")
        self.assertEqual(policies["synchronous_commit"], "manual_review")
        self.assertEqual(policies["m_format_behavior_compat_options"], "manual_review")
        self.assertEqual(len(self.registry.session_overlay_parameters()), 14)
        for parameter in self.registry.session_overlay_parameters():
            self.assertIn("session", parameter.set_scopes)
            self.assertTrue(parameter.dynamic)
            self.assertFalse(parameter.restart_required)
            self.assertTrue(parameter.safe_probe_values)

    def test_needs_verification_runtime_facts_are_not_bound_to_parameters(self):
        for fact_id in ("guc_td_compatible_truncation", "guc_max_wal_size"):
            self.assertEqual(self.registry.fact_statuses[fact_id], "needs_verification")
            self.assertFalse(any(
                fact_id in parameter.fact_refs
                for parameter in self.registry.parameters.values()
            ))

    def test_session_overlay_plans_capture_apply_verify_and_restore(self):
        planner = GucEnvironmentPlanner(self.registry)
        for parameter in self.registry.session_overlay_parameters():
            original = parameter.default_value
            target = next(
                value for value in parameter.safe_probe_values if value != original
            )
            with self.subTest(parameter=parameter.name):
                plan = planner.plan(parameter.id, target, original)
                self.assertEqual(
                    [step.action for step in plan.steps],
                    [
                        "capture_original", "apply", "verify_target",
                        "restore", "verify_restore",
                    ],
                )
                self.assertIn(f"SET {parameter.name} = {target};", plan.steps[1].sql)
                self.assertIn(f"SET {parameter.name} = {original};", plan.steps[3].sql)
                self.assertIn(f"current_setting('{parameter.name}', true)", plan.steps[0].sql)
                joined_sql = "\n".join(step.sql for step in plan.steps)
                for forbidden in ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET "):
                    self.assertNotIn(forbidden, joined_sql)

    def test_planner_rejects_non_overlay_unknown_and_unsafe_values(self):
        planner = GucEnvironmentPlanner(self.registry)
        with self.assertRaisesRegex(ValueError, "read_only"):
            planner.plan("guc_sql_compatibility", "'B'", "'A'")
        with self.assertRaisesRegex(ValueError, "blocked"):
            planner.plan("guc_enable_global_plancache", "'on'", "'off'")
        with self.assertRaisesRegex(ValueError, "manual_review"):
            planner.plan("guc_synchronous_commit", "'off'", "'on'")
        with self.assertRaisesRegex(ValueError, "safe_probe_values"):
            planner.plan("guc_b_format_behavior_compat_options", "'all'", "''")
        with self.assertRaisesRegex(ValueError, "target_value"):
            planner.plan("guc_enable_seqscan", "'maybe'", "'on'")
        with self.assertRaisesRegex(ValueError, "original_value"):
            planner.plan("guc_enable_seqscan", "'off'", "'maybe'")


if __name__ == "__main__":
    unittest.main()
