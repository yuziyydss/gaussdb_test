"""GUC Environment V2 adds the reviewed candidate batch without widening unsafe cases."""
import unittest
from pathlib import Path

from core.guc_environment import GucEnvironmentPlanner, GucEnvironmentRegistry


ROOT = Path(__file__).resolve().parents[1]
NEW_SESSION_OVERLAY = {
    "a_format_enable_copy_empty_lobs",
    "enable_copy_case_sensitive",
    "enable_copy_when_filler",
    "enable_log_copy_illegal_chars",
    "track_procedure_sql",
}
NEW_MANUAL_REVIEW = {"enable_plan_trace", "enable_save_datachanged_timestamp"}


class GucEnvironmentV2Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = GucEnvironmentRegistry(
            ROOT,
            inventory_path=ROOT / "environments/guc_parameters_v2.yaml",
        )
        cls.registry.load_all()

    def test_v2_expands_v1_to_27_parameters(self):
        self.assertEqual(len(self.registry.parameters), 27)
        self.assertEqual(len(self.registry.parameters_by_name), 27)
        policies = {
            parameter.name: parameter.execution_policy
            for parameter in self.registry.parameters.values()
        }
        self.assertEqual(sum(value == "session_overlay" for value in policies.values()), 19)
        self.assertEqual(sum(value == "manual_review" for value in policies.values()), 6)
        self.assertEqual(sum(value == "read_only" for value in policies.values()), 1)
        self.assertEqual(sum(value == "blocked" for value in policies.values()), 1)

    def test_reviewed_batch_adds_only_confirmed_userset_booleans(self):
        for name in NEW_SESSION_OVERLAY | NEW_MANUAL_REVIEW:
            with self.subTest(parameter=name):
                parameter = self.registry.parameters_by_name[name]
                self.assertEqual(parameter.schema_version, 2)
                self.assertEqual(parameter.context_type, "USERSET")
                self.assertEqual(parameter.value_type, "boolean")
                self.assertEqual(parameter.dynamic, True)
                self.assertEqual(parameter.restart_required, False)
                self.assertIn("session", parameter.set_scopes)
                self.assertTrue(parameter.fact_refs)

        for name in NEW_SESSION_OVERLAY:
            self.assertEqual(
                self.registry.parameters_by_name[name].execution_policy,
                "session_overlay",
            )
        for name in NEW_MANUAL_REVIEW:
            parameter = self.registry.parameters_by_name[name]
            self.assertEqual(parameter.execution_policy, "manual_review")
            self.assertEqual(parameter.safe_probe_values, [])
            self.assertEqual(parameter.restore_policy, "not_applicable")

    def test_new_session_overlay_plans_remain_capture_apply_verify_restore(self):
        planner = GucEnvironmentPlanner(self.registry)
        for name in sorted(NEW_SESSION_OVERLAY):
            parameter = self.registry.parameters_by_name[name]
            original = parameter.default_value
            target = next(value for value in parameter.safe_probe_values if value != original)
            with self.subTest(parameter=name):
                plan = planner.plan(parameter.id, target, original)
                self.assertEqual(
                    [step.action for step in plan.steps],
                    [
                        "capture_original", "apply", "verify_target",
                        "restore", "verify_restore",
                    ],
                )
                joined_sql = "\n".join(step.sql for step in plan.steps)
                self.assertIn(f"SET {parameter.name} = {target};", joined_sql)
                self.assertIn(f"SET {parameter.name} = {original};", joined_sql)
                for forbidden in ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET "):
                    self.assertNotIn(forbidden, joined_sql)

    def test_v2_is_a_strict_superset_of_v1(self):
        v1 = GucEnvironmentRegistry(ROOT)
        v1.load_all()
        self.assertEqual(len(v1.parameters), 20)
        for name, parameter in v1.parameters_by_name.items():
            with self.subTest(parameter=name):
                self.assertIn(name, self.registry.parameters_by_name)
                self.assertEqual(
                    self.registry.parameters_by_name[name].execution_policy,
                    parameter.execution_policy,
                )


if __name__ == "__main__":
    unittest.main()
