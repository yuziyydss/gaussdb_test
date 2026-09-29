"""GUC V2 preflight is read-only, source-bound, and domain-aware."""
import hashlib
import json
import contextlib
import io
import json
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

from core.runtime_validation_pilot import RuntimeStepResult
from scripts.run_guc_v2_preflight import main as preflight_cli
from core.guc_preflight import (
    GucV2PreflightError,
    GucV2PreflightRegistry,
    ScriptedGucPreflightTransport,
    build_guc_v2_preflight_plan,
    run_guc_v2_preflight,
)


ROOT = Path(__file__).resolve().parents[1]


def ok(value):
    return SimpleNamespace(success=True, rows=[[value]], notices=[], error="")


def fail(error):
    return SimpleNamespace(success=False, rows=[], notices=[], error=error)


class GucV2PreflightTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_guc_v2_preflight_plan(ROOT)

    def test_plan_covers_all_27_environment_parameters(self):
        self.assertEqual(self.plan.schema_version, 1)
        self.assertEqual(self.plan.kind, "guc_v2_preflight_plan")
        self.assertEqual(self.plan.environment_id, "guc_environment_v2")
        self.assertEqual(self.plan.environment_schema_version, 2)
        self.assertEqual(len(self.plan.queries), 27)
        self.assertEqual(len({q.parameter_id for q in self.plan.queries}), 27)
        self.assertEqual(self.plan.summary.query_count, 27)
        self.assertEqual(self.plan.summary.read_only, True)

    def test_preflight_queries_are_read_only_and_source_bound(self):
        source = self.plan.source
        self.assertEqual(source.relpath, "environments/guc_parameters_v2.yaml")
        actual_hash = hashlib.sha256((ROOT / source.relpath).read_bytes()).hexdigest()
        self.assertEqual(source.sha256, actual_hash)
        for query in self.plan.queries:
            with self.subTest(parameter=query.parameter_name):
                self.assertTrue(query.sql.startswith("SELECT current_setting("))
                self.assertIn(query.parameter_name, query.sql)
                for forbidden in ("SET ", "INSERT ", "UPDATE ", "DELETE ", "CREATE ", "DROP ", "ALTER "):
                    self.assertNotIn(forbidden, query.sql)

    def test_scripted_preflight_reports_values_and_domain_matches(self):
        registry = GucV2PreflightRegistry(ROOT)
        values = registry.current_values()
        self.assertEqual(len(values), 27)
        transport = ScriptedGucPreflightTransport([ok(value) for value in values])
        result = run_guc_v2_preflight(self.plan, transport)
        self.assertTrue(result.connected)
        self.assertTrue(result.metadata_read)
        self.assertFalse(result.target_sql_executed)
        self.assertFalse(result.guc_changed)
        self.assertFalse(result.object_created)
        self.assertEqual(result.summary.query_count, 27)
        self.assertEqual(result.summary.success_count, 27)
        self.assertEqual(result.summary.error_count, 0)
        self.assertEqual(result.summary.domain_mismatch_count, 0)
        self.assertTrue(all(query.in_declared_domain for query in result.queries))

    def test_domain_mismatch_is_reported_without_faking_success(self):
        registry = GucV2PreflightRegistry(ROOT)
        values = registry.current_values()
        values[0] = "not-a-valid-value"
        transport = ScriptedGucPreflightTransport([ok(value) for value in values])
        result = run_guc_v2_preflight(self.plan, transport)
        self.assertTrue(result.connected)
        self.assertTrue(result.metadata_read)
        self.assertEqual(result.summary.success_count, 27)
        self.assertEqual(result.summary.domain_mismatch_count, 1)
        self.assertFalse(result.queries[0].in_declared_domain)

    def test_query_failure_is_recorded_and_blocks_metadata_readiness(self):
        registry = GucV2PreflightRegistry(ROOT)
        values = registry.current_values()
        responses = [ok(value) for value in values]
        responses[3] = fail("parameter unavailable")
        transport = ScriptedGucPreflightTransport(responses)
        result = run_guc_v2_preflight(self.plan, transport)
        self.assertTrue(result.connected)
        self.assertFalse(result.metadata_read)
        self.assertEqual(result.summary.success_count, 26)
        self.assertEqual(result.summary.error_count, 1)
        self.assertEqual(result.errors, ["behavior_compat_options: parameter unavailable"])
        self.assertEqual(result.queries[3].status, "error")

    def test_cli_runs_read_only_preflight_and_writes_result(self):
        registry = GucV2PreflightRegistry(ROOT)
        values = registry.current_values()
        responses = [
            RuntimeStepResult(success=True, rows=[[value]])
            for value in values
        ]

        class FakeTransport:
            def __init__(self, **kwargs):
                self.kwargs = kwargs
                self.closed = False

            def run(self, sql):
                return responses.pop(0)

            def close(self):
                self.closed = True

        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "preflight.json"
            with patch(
                "scripts.run_guc_v2_preflight.DatabaseRuntimeTransport",
                FakeTransport,
            ), contextlib.redirect_stdout(io.StringIO()):
                exit_code = preflight_cli(["--output", str(output)])
            self.assertEqual(exit_code, 0)
            payload = json.loads(output.read_text(encoding="utf-8"))
            self.assertEqual(payload["kind"], "guc_v2_preflight_result")
            self.assertTrue(payload["connected"])
            self.assertTrue(payload["metadata_read"])
            self.assertEqual(payload["summary"]["query_count"], 27)
            self.assertEqual(payload["summary"]["success_count"], 27)
            self.assertEqual(payload["summary"]["domain_mismatch_count"], 0)
            self.assertFalse(payload["target_sql_executed"])
            self.assertFalse(payload["guc_changed"])

            audit_path = Path(directory) / "preflight_audit.json"
            self.assertTrue(audit_path.is_file())
            audit_payload = json.loads(audit_path.read_text(encoding="utf-8"))
            self.assertEqual(audit_payload["kind"], "guc_v2_preflight_audit")
            self.assertTrue(audit_payload["valid"])
            self.assertTrue(audit_payload["plan_verified"])
            self.assertEqual(audit_payload["summary"]["query_count"], 27)
            self.assertEqual(audit_payload["summary"]["success_count"], 27)
            self.assertEqual(audit_payload["summary"]["domain_mismatch_count"], 0)

    def test_preflight_cli_rejects_existing_audit_output(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "preflight.json"
            audit_output = Path(directory) / "preflight_audit.json"
            audit_output.write_text("{}", encoding="utf-8")
            with self.assertRaisesRegex(SystemExit, "audit output already exists"):
                preflight_cli(["--output", str(output)])

    def test_payload_with_drifted_summary_fails_closed(self):
        payload = json.loads(
            (ROOT / "generated/guc_environment_v2/preflight_plan.json").read_text(encoding="utf-8")
        )
        payload["summary"]["query_count"] += 1
        with self.assertRaises(GucV2PreflightError) as caught:
            GucV2PreflightRegistry(ROOT).load_payload(payload)
        self.assertIn("summary", str(caught.exception))


if __name__ == "__main__":
    unittest.main()
