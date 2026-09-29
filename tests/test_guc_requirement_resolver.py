"""GUC environment gates resolve to reviewed V2 capabilities without execution."""
import copy
import unittest
from pathlib import Path

from core.execution_preparation import prepare_unit
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from core.guc_requirement_resolver import resolve_guc_requirements


ROOT = Path(__file__).resolve().parents[1]


class GucRequirementResolverTests(unittest.TestCase):
    def test_supported_gate_resolves_to_capability_plan(self):
        result = resolve_guc_requirements(
            {"guc_track_procedure_sql": ["off"]}, ROOT
        )
        self.assertEqual(result.kind, "guc_requirement_resolver")
        self.assertEqual(result.summary.requested_count, 1)
        self.assertEqual(result.summary.supported_count, 1)
        self.assertEqual(result.summary.unsupported_count, 0)
        self.assertEqual(result.summary.invalid_value_count, 0)
        self.assertEqual(result.supported[0].parameter_name, "track_procedure_sql")
        self.assertEqual(result.supported[0].allowed_values, ["off"])
        self.assertEqual(
            [step.action for step in result.supported[0].plan.steps],
            [
                "capture_original", "apply", "verify_target",
                "restore", "verify_restore",
            ],
        )

    def test_unknown_gate_is_unsupported(self):
        result = resolve_guc_requirements(
            {"guc_not_a_guc": ["on"]}, ROOT
        )
        self.assertEqual(result.summary.requested_count, 1)
        self.assertEqual(result.summary.supported_count, 0)
        self.assertEqual(result.summary.unsupported_count, 1)
        self.assertEqual(result.unsupported, ["guc_not_a_guc"])

    def test_value_outside_declared_domain_is_invalid(self):
        result = resolve_guc_requirements(
            {"guc_track_procedure_sql": ["maybe"]}, ROOT
        )
        self.assertEqual(result.summary.requested_count, 1)
        self.assertEqual(result.summary.supported_count, 0)
        self.assertEqual(result.summary.invalid_value_count, 1)
        self.assertEqual(result.invalid_values[0].requested_values, ["maybe"])
        self.assertEqual(result.invalid_values[0].supported_values, ["on", "off"])

    def test_non_guc_gates_are_ignored(self):
        result = resolve_guc_requirements(
            {"compatibility_mode": ["PG"], "session_ownership": ["exclusive"]}, ROOT
        )
        self.assertEqual(result.summary.requested_count, 0)
        self.assertEqual(result.supported, [])
        self.assertEqual(result.unsupported, [])
        self.assertEqual(result.invalid_values, [])


class GucRequirementPreparationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.cases = cls.generator.generate_with_report(
            cls.registry.manifests["manifest_insert_pg_tuple_fresh"]
        )[0]

    def test_prepare_unit_attaches_guc_environment_plan(self):
        cases = [copy.deepcopy(case) for case in self.cases]
        for case in cases:
            case.environment_requirements.append({
                "key": "guc_track_procedure_sql",
                "allowed_values": ["off"],
                "fact_refs": ["guc_track_procedure_sql"],
            })
        scenario = self.registry.scenarios["scenario_insert_pg_tuple_fresh"]
        result = prepare_unit(scenario, cases, self.generator)

        self.assertIn("guc_environment_plan", result)
        plan = result["guc_environment_plan"]
        self.assertEqual(plan["summary"]["supported_count"], 1)
        self.assertEqual(plan["summary"]["unsupported_count"], 0)
        self.assertEqual(plan["summary"]["invalid_value_count"], 0)
        self.assertEqual(plan["supported"][0]["parameter_name"], "track_procedure_sql")
        self.assertIn(
            "guc_overlay_capture_apply_verify_restore_verify",
            result["required_runtime_evidence"],
        )
        self.assertIn("guc_execution_plan", result)
        execution_plan = result["guc_execution_plan"]
        self.assertEqual(execution_plan["summary"]["selection_count"], 1)
        self.assertEqual(execution_plan["selections"][0]["selected_value"], "off")
        self.assertIn(
            "SET track_procedure_sql = 'off';",
            execution_plan["selections"][0]["plan"]["steps"][1]["sql"],
        )
        self.assertFalse(any(
            blocker.startswith("guc_requirement_")
            for blocker in result["static_blockers"]
        ))

    def test_prepare_unit_blocks_unknown_guc_gate(self):
        cases = [copy.deepcopy(case) for case in self.cases]
        for case in cases:
            case.environment_requirements.append({
                "key": "guc_not_a_guc",
                "allowed_values": ["on"],
                "fact_refs": ["not_a_real_fact"],
            })
        scenario = self.registry.scenarios["scenario_insert_pg_tuple_fresh"]
        result = prepare_unit(scenario, cases, self.generator)

        self.assertIn("guc_environment_plan", result)
        self.assertIn(
            "guc_requirement_unsupported:guc_not_a_guc",
            result["static_blockers"],
        )

    def test_prepare_unit_blocks_invalid_guc_value(self):
        cases = [copy.deepcopy(case) for case in self.cases]
        for case in cases:
            case.environment_requirements.append({
                "key": "guc_track_procedure_sql",
                "allowed_values": ["maybe"],
                "fact_refs": ["guc_track_procedure_sql"],
            })
        scenario = self.registry.scenarios["scenario_insert_pg_tuple_fresh"]
        result = prepare_unit(scenario, cases, self.generator)

        self.assertIn("guc_environment_plan", result)
        self.assertIn(
            "guc_requirement_invalid_values:guc_track_procedure_sql",
            result["static_blockers"],
        )


if __name__ == "__main__":
    unittest.main()
