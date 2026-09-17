"""Dry-run planning for the bounded insert_same_key runtime pilot."""
import copy
import json
import tempfile
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.execute_prepared_batch import build_dry_run, main
from scripts.prepare_execution_batch import build_batch

ROOT = Path(__file__).resolve().parents[1]


class ExecutePreparedBatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.preparation = build_batch(cls.registry, cls.generator, profile="insert_same_key")

    def test_real_preparation_builds_three_isolated_dry_run_units(self):
        plan = build_dry_run(self.preparation)
        self.assertEqual(plan["kind"], "runtime_execution_dry_run")
        self.assertEqual(plan["profile"], "insert_same_key")
        self.assertFalse(plan["database_executed"])
        self.assertFalse(plan["execution_authorized"])
        self.assertEqual(plan["runtime_verified"], 0)
        self.assertEqual(plan["summary"], {
            "units": 3,
            "ready_units": 3,
            "blocked_units": 0,
            "planned_target_steps": 3,
            "planned_oracles": 3,
        })
        by_scenario = {unit["scenario_ref"]: unit for unit in plan["units"]}
        self.assertEqual(set(by_scenario), {
            "scenario_insert_same_key_conflict",
            "scenario_insert_same_key_new",
            "scenario_insert_same_key_filtered",
        })
        for scenario_ref, unit in by_scenario.items():
            with self.subTest(scenario=scenario_ref):
                self.assertEqual(unit["status"], "ready_for_authorized_execution")
                self.assertEqual(unit["case_id"], next(
                    case["case_id"] for case in self.preparation["candidates"]
                    if case["params"]["source_profile"] == {
                        "scenario_insert_same_key_conflict": "insert_source_same_key_conflict",
                        "scenario_insert_same_key_new": "insert_source_same_key_new",
                        "scenario_insert_same_key_filtered": "insert_source_same_key_filtered",
                    }[scenario_ref]
                ))
                self.assertEqual(unit["finite_contract"]["contract"], "same_inline_integer_key_tuple_v1")
                self.assertFalse(unit["finite_contract"]["runtime_proven"])
                self.assertEqual(unit["environment_requirements"].get("compatibility_mode"), ["PG"])
                self.assertEqual([step["phase"] for step in unit["execution_plan"]],
                                 ["environment_check", "setup", "setup", "target", "oracle", "teardown"])
                self.assertEqual([step["phase"] for step in unit["execution_plan"] if step["phase"] == "target"],
                                 ["target"])
                oracle = next(step for step in unit["execution_plan"] if step["phase"] == "oracle")
                self.assertEqual(oracle["expected_rows"], unit["finite_contract"]["planned_rows"])
                self.assertEqual(oracle["sql"], unit["finite_contract"]["oracle_sql"])
                self.assertTrue(unit["cleanup"]["only_owned_objects"])
                self.assertFalse(unit["cleanup"]["runtime_ownership_proven"])

    def test_blockers_and_fabricated_runtime_claims_are_rejected(self):
        bad = copy.deepcopy(self.preparation)
        bad["units"][0]["static_blockers"] = ["probe_blocker"]
        with self.assertRaisesRegex(ValueError, "static_blockers"):
            build_dry_run(bad)

        bad = copy.deepcopy(self.preparation)
        bad["runtime_verified"] = 1
        with self.assertRaisesRegex(ValueError, "runtime_verified"):
            build_dry_run(bad)

        bad = copy.deepcopy(self.preparation)
        bad["units"][0]["execution_authorized"] = True
        with self.assertRaisesRegex(ValueError, "execution_authorized"):
            build_dry_run(bad)

    def test_oracle_identity_must_match_finite_contract(self):
        bad = copy.deepcopy(self.preparation)
        bad["units"][0]["source_scenario"]["oracles"][0]["expected"] = [[999, "fake"]]
        with self.assertRaisesRegex(ValueError, "finite oracle identity"):
            build_dry_run(bad)

        bad = copy.deepcopy(self.preparation)
        bad["units"][0]["source_scenario"]["oracles"][0]["sql"] = "SELECT 1;"
        with self.assertRaisesRegex(ValueError, "finite oracle identity"):
            build_dry_run(bad)

    def test_cli_writes_machine_receipt_without_overwrite(self):
        with tempfile.TemporaryDirectory() as directory:
            input_path = Path(directory) / "preparation.json"
            output = Path(directory) / "dry_run.json"
            input_path.write_text(json.dumps(self.preparation, ensure_ascii=False) + "\n")
            main(["--input", str(input_path), "--output", str(output)])
            receipt = json.loads(output.read_text())
            self.assertEqual(receipt["status"], "ready_for_authorized_execution")
            self.assertFalse(receipt["database_executed"])
            self.assertEqual(receipt["runtime_verified"], 0)
            with self.assertRaisesRegex(SystemExit, "2"):
                main(["--input", str(input_path), "--output", str(output)])


if __name__ == "__main__":
    unittest.main()
