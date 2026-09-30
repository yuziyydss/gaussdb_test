"""GUC execution selection turns resolved gates into concrete overlay plans."""
import unittest
from pathlib import Path

from core.guc_execution_selector import (
    GucExecutionSelectionError,
    select_guc_execution_values,
)
from core.guc_requirement_resolver import resolve_guc_requirements


ROOT = Path(__file__).resolve().parents[1]


class GucExecutionSelectorTests(unittest.TestCase):
    def test_first_allowed_value_is_selected_by_default(self):
        resolved = resolve_guc_requirements(
            {"guc_track_procedure_sql": ["on", "off"]}, ROOT
        )
        selection = select_guc_execution_values(resolved, ROOT)
        self.assertEqual(selection.kind, "guc_execution_selection")
        self.assertEqual(selection.summary.selection_count, 1)
        self.assertEqual(selection.selections[0].requirement_key, "guc_track_procedure_sql")
        self.assertEqual(selection.selections[0].selected_value, "on")
        self.assertEqual(selection.selections[0].parameter_name, "track_procedure_sql")
        self.assertEqual(
            [step.action for step in selection.selections[0].plan.steps],
            [
                "capture_original", "apply", "verify_target",
                "restore", "verify_restore",
            ],
        )

    def test_explicit_selection_is_used(self):
        resolved = resolve_guc_requirements(
            {"guc_track_procedure_sql": ["on", "off"]}, ROOT
        )
        selection = select_guc_execution_values(
            resolved, ROOT, selections={"guc_track_procedure_sql": "off"}
        )
        self.assertEqual(selection.selections[0].selected_value, "off")
        self.assertIn("SET track_procedure_sql = 'off';", selection.selections[0].plan.steps[1].sql)

    def test_unknown_selection_key_fails_closed(self):
        resolved = resolve_guc_requirements(
            {"guc_track_procedure_sql": ["on", "off"]}, ROOT
        )
        with self.assertRaises(GucExecutionSelectionError) as caught:
            select_guc_execution_values(
                resolved, ROOT, selections={"guc_unknown": "on"}
            )
        self.assertIn("unknown GUC selection key", str(caught.exception))

    def test_value_outside_allowed_domain_fails_closed(self):
        resolved = resolve_guc_requirements(
            {"guc_track_procedure_sql": ["on", "off"]}, ROOT
        )
        with self.assertRaises(GucExecutionSelectionError) as caught:
            select_guc_execution_values(
                resolved, ROOT, selections={"guc_track_procedure_sql": "maybe"}
            )
        self.assertIn("not in allowed values", str(caught.exception))

    def test_selector_does_not_execute_sql_or_claim_runtime_evidence(self):
        resolved = resolve_guc_requirements(
            {"guc_track_procedure_sql": ["off"]}, ROOT
        )
        selection = select_guc_execution_values(resolved, ROOT)
        self.assertFalse(selection.runtime_authorized)
        self.assertFalse(selection.database_executed)
        self.assertFalse(selection.runtime_verified)
        joined_sql = "\n".join(
            step.sql for item in selection.selections for step in item.plan.steps
        )
        for forbidden in ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET "):
            self.assertNotIn(forbidden, joined_sql)


if __name__ == "__main__":
    unittest.main()
