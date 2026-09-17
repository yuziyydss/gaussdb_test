"""Dry-run planning for the bounded insert_same_key runtime pilot."""
import copy
import json
import os
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.execute_prepared_batch import GsqlTransport, build_dry_run, execute_plan, main
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


class ScriptedTransport:
    def __init__(self, responses):
        self.responses = list(responses)
        self.calls = []

    def run(self, sql):
        self.calls.append(sql)
        if not self.responses:
            raise AssertionError("unexpected SQL call: " + sql)
        return self.responses.pop(0)


class RuntimeExecutionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / "specs")
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.preparation = build_batch(cls.registry, cls.generator, profile="insert_same_key")
        cls.plan = build_dry_run(cls.preparation)

    @staticmethod
    def success_responses():
        responses = []
        rows = [
            [[-1, "blocked"], [101, "alpha"]],
            [[-1, "blocked"], [101, "existing"], [102, "beta"]],
            [[-1, "blocked"], [101, "existing"]],
        ]
        for index, expected in enumerate(rows):
            responses.append((0, "PG", ""))
            responses.append((0, "CREATE TABLE", ""))
            responses.append((0, "INSERT 0 2", ""))
            responses.append((0, "INSERT 0 1" if index < 2 else "INSERT 0 0", ""))
            responses.append((0, "\n".join("\t".join(str(cell) for cell in row) for row in expected), ""))
            responses.append((0, "DROP TABLE", ""))
        return responses

    def test_all_three_units_can_be_runtime_verified(self):
        transport = ScriptedTransport(self.success_responses())
        receipt = execute_plan(self.plan, transport, connection={
            "host": "db.example", "port": 5432, "database": "test", "user": "tester",
        })
        self.assertEqual(receipt["kind"], "runtime_execution_receipt")
        self.assertTrue(receipt["database_executed"])
        self.assertTrue(receipt["execution_authorized"])
        self.assertEqual(receipt["runtime_verified"], 3)
        self.assertEqual(receipt["status"], "passed")
        self.assertEqual(receipt["summary"], {
            "units": 3, "runtime_verified": 3, "failed_units": 0,
            "target_steps_executed": 3, "oracles_executed": 3,
        })
        self.assertEqual(len(transport.calls), 18)
        for unit in receipt["units"]:
            self.assertEqual(unit["status"], "runtime_verified")
            self.assertTrue(unit["database_executed"])
            self.assertTrue(unit["runtime_verified"])
            self.assertEqual([step["status"] for step in unit["steps"]],
                             ["PASS"] * 6)
        self.assertNotIn("password", json.dumps(receipt))

    def test_wrong_physical_mode_blocks_unit_before_setup(self):
        responses = [(0, "M", "")]
        responses.extend(self.success_responses()[6:])
        transport = ScriptedTransport(responses)
        receipt = execute_plan(self.plan, transport)
        self.assertEqual(receipt["status"], "failed")
        self.assertEqual(receipt["runtime_verified"], 2)
        first = receipt["units"][0]
        self.assertEqual(first["status"], "failed")
        self.assertEqual(first["steps"][0]["status"], "FAIL")
        self.assertEqual([step["status"] for step in first["steps"][1:]], ["SKIPPED"] * 5)
        self.assertNotIn("CREATE TABLE", transport.calls[0:1])

    def test_create_failure_skips_target_and_unowned_cleanup(self):
        responses = self.success_responses()
        responses = [responses[0], (1, "", "ERROR: 42501: permission denied")]
        responses.extend(self.success_responses()[6:])
        transport = ScriptedTransport(responses)
        receipt = execute_plan(self.plan, transport)
        self.assertEqual(receipt["status"], "failed")
        first = receipt["units"][0]
        self.assertEqual([step["status"] for step in first["steps"]],
                         ["PASS", "FAIL", "SKIPPED", "SKIPPED", "SKIPPED", "SKIPPED"])
        self.assertNotIn("INSERT INTO g_insert_pg_key", transport.calls[2])
        self.assertEqual(receipt["runtime_verified"], 2)

    def test_seed_failure_after_create_runs_owned_cleanup(self):
        responses = self.success_responses()
        responses = responses[:2] + [(1, "", "ERROR: 23505: duplicate key")]
        responses.extend(self.success_responses()[5:])
        transport = ScriptedTransport(responses)
        receipt = execute_plan(self.plan, transport)
        first = receipt["units"][0]
        self.assertEqual([step["status"] for step in first["steps"]],
                         ["PASS", "PASS", "FAIL", "SKIPPED", "SKIPPED", "PASS"])
        self.assertEqual(receipt["runtime_verified"], 2)

    def test_oracle_mismatch_fails_unit_but_cleanup_runs(self):
        responses = self.success_responses()
        responses[4] = (0, "999\tfake", "")
        transport = ScriptedTransport(responses)
        receipt = execute_plan(self.plan, transport)
        first = receipt["units"][0]
        self.assertEqual([step["status"] for step in first["steps"]],
                         ["PASS", "PASS", "PASS", "PASS", "FAIL", "PASS"])
        self.assertEqual(receipt["runtime_verified"], 2)


    def test_gsql_password_is_environment_only_and_never_argv(self):
        response = type("Response", (), {"returncode": 0, "stdout": "PG\n", "stderr": ""})()
        with patch("scripts.execute_prepared_batch.subprocess.run", return_value=response) as run:
            transport = GsqlTransport(host="db.example", port=5432, database="test",
                                      user="tester", password="secret-runtime-password")
            result = transport.run("SELECT 1;")
        self.assertEqual(result, (0, "PG", ""))
        command = run.call_args.args[0]
        self.assertNotIn("secret-runtime-password", command)
        self.assertNotIn("PGPASSWORD", command)
        self.assertEqual(run.call_args.kwargs["env"]["PGPASSWORD"], "secret-runtime-password")

    def test_cli_execute_requires_explicit_connection(self):
        with tempfile.TemporaryDirectory() as directory:
            input_path = Path(directory) / "preparation.json"
            output = Path(directory) / "runtime.json"
            input_path.write_text(json.dumps(self.preparation, ensure_ascii=False) + "\n")
            with self.assertRaises(SystemExit) as context:
                main(["--input", str(input_path), "--output", str(output), "--execute"])
            self.assertEqual(context.exception.code, 2)

    def test_cli_execute_reads_password_env_and_never_writes_it(self):
        with tempfile.TemporaryDirectory() as directory:
            input_path = Path(directory) / "preparation.json"
            output = Path(directory) / "runtime.json"
            input_path.write_text(json.dumps(self.preparation, ensure_ascii=False) + "\n")
            transport = ScriptedTransport(self.success_responses())
            with patch.dict(os.environ, {"GAUSSDB_PASSWORD": "secret-runtime-password"}),                     patch("scripts.execute_prepared_batch.GsqlTransport", return_value=transport) as factory:
                main(["--input", str(input_path), "--output", str(output), "--execute",
                      "--host", "db.example", "--port", "5432",
                      "--database", "test", "--user", "tester"])
            factory.assert_called_once_with(
                host="db.example", port=5432, database="test", user="tester",
                password="secret-runtime-password", client="gsql", timeout=30)
            receipt = json.loads(output.read_text())
            self.assertEqual(receipt["kind"], "runtime_execution_receipt")
            self.assertEqual(receipt["runtime_verified"], 3)
            self.assertNotIn("secret-runtime-password", output.read_text())
    def test_cleanup_failure_prevents_runtime_verification(self):
        responses = self.success_responses()
        responses[5] = (1, "", "ERROR: 42501: not owner")
        transport = ScriptedTransport(responses)
        receipt = execute_plan(self.plan, transport)
        first = receipt["units"][0]
        self.assertEqual([step["status"] for step in first["steps"]],
                         ["PASS", "PASS", "PASS", "PASS", "PASS", "FAIL"])
        self.assertEqual(first["status"], "cleanup_failed")
        self.assertEqual(receipt["runtime_verified"], 2)
