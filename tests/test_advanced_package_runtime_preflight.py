"""Advanced package runtime preflight remains read-only and fail-closed."""
import json
import unittest
from pathlib import Path

from core.advanced_package_runtime_preflight import (
    build_advanced_package_runtime_preflight,
    verify_advanced_package_runtime_preflight,
)

ROOT = Path(__file__).resolve().parents[1]


class AdvancedPackageRuntimePreflightTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_advanced_package_runtime_preflight(ROOT)

    def test_every_runtime_case_has_a_preflight_contract(self):
        self.assertEqual(self.plan.summary.runtime_plan_unit_count, 29)
        self.assertEqual(self.plan.summary.guc_overlay_unit_count, 2)
        self.assertEqual(self.plan.summary.advanced_case_count, 27)
        self.assertEqual(self.plan.summary.preflight_case_count, 27)
        self.assertEqual(self.plan.summary.advanced_interface_reference_count, 77)
        self.assertEqual(self.plan.summary.global_query_count, 8)
        self.assertEqual(self.plan.summary.low_risk_case_count, 22)
        self.assertEqual(self.plan.summary.medium_risk_case_count, 5)
        self.assertEqual(self.plan.summary.expansion_runtime_candidate_count, 38)
        self.assertEqual(self.plan.summary.covered_expansion_runtime_candidate_count, 38)
        self.assertTrue(self.plan.summary.coverage_complete)

    def test_global_queries_are_read_only_and_purposeful(self):
        self.assertEqual(
            [item.key for item in self.plan.global_queries],
            [
                "server_version", "current_database", "current_user",
                "sql_compatibility", "server_encoding", "client_encoding",
                "behavior_compat_options", "enable_ilm",
            ],
        )
        for query in self.plan.global_queries:
            with self.subTest(query=query.key):
                self.assertTrue(query.sql.startswith("SELECT "))
                self.assertTrue(query.sql.endswith(";"))
                for forbidden in ("INSERT ", "UPDATE ", "DELETE ", "CREATE ", "ALTER ", "DROP ", "TRUNCATE ", "SET ", "RESET ", "CALL ", "GRANT ", "REVOKE "):
                    self.assertNotIn(forbidden, query.sql.upper())
                self.assertTrue(query.purpose)
                self.assertTrue(query.validation_rule)

    def test_package_preflight_contracts_are_explicit(self):
        contracts = {item.package_ref: item for item in self.plan.case_plans}
        self.assertEqual(contracts["dbe_output"].execution_class, "session_buffer_lifecycle")
        self.assertEqual(contracts["dbe_raw"].execution_class, "pure_function_value")
        self.assertEqual(contracts["dbe_sql"].execution_class, "dynamic_sql_context")
        self.assertEqual(contracts["dbe_sql"].risk_tier, "medium")
        self.assertEqual(contracts["dbe_xmldom"].execution_class, "xml_document_lifecycle")
        self.assertEqual(contracts["dbe_xmlparser"].execution_class, "xml_parser_lifecycle")
        self.assertEqual(contracts["dbe_stats"].execution_class, "statistics_history_read")

        for item in self.plan.case_plans:
            with self.subTest(unit=item.unit_id):
                self.assertEqual(item.global_query_keys, [query.key for query in self.plan.global_queries])
                self.assertTrue(item.permissions)
                self.assertTrue(item.fixture_requirements)
                self.assertTrue(item.execution_boundaries)
                self.assertTrue(item.cleanup_requirements)
                self.assertNotIn("DBMS_", item.unit_id)

        self.assertIn("dbe_sql.sql_unregister_context", " ".join(contracts["dbe_sql"].cleanup_requirements).lower())
        self.assertIn("freeparser", " ".join(contracts["dbe_xmlparser"].cleanup_requirements).lower())
        self.assertIn("file-writing", " ".join(contracts["dbe_xmldom"].execution_boundaries).lower())

    def test_written_plan_is_current_and_verifiable(self):
        path = ROOT / "generated/advanced_package_pilot/runtime_preflight_plan.json"
        self.assertTrue(path.is_file())
        result = verify_advanced_package_runtime_preflight(ROOT)
        self.assertEqual(result.summary.advanced_case_count, 27)
        self.assertTrue(result.summary.coverage_complete)

    def test_verification_detects_stale_artifact(self):
        path = ROOT / "generated/advanced_package_pilot/runtime_preflight_plan.json"
        original = path.read_text(encoding="utf-8")
        try:
            payload = json.loads(original)
            payload["summary"]["advanced_case_count"] += 1
            path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "stale|invalid"):
                verify_advanced_package_runtime_preflight(ROOT)
        finally:
            path.write_text(original, encoding="utf-8")


if __name__ == "__main__":
    unittest.main()


class AdvancedPackageRuntimePreflightRunAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_advanced_package_runtime_preflight(ROOT)

    @staticmethod
    def ok(value):
        from types import SimpleNamespace
        return SimpleNamespace(success=True, rows=[[value]], notices=[], error="")

    @staticmethod
    def fail(error="query failed"):
        from types import SimpleNamespace
        return SimpleNamespace(success=False, rows=[], notices=[], error=error)

    def test_all_passed_result_audits_against_plan(self):
        from core.advanced_package_runtime_preflight import (
            run_advanced_package_runtime_preflight,
            audit_advanced_package_runtime_preflight_result,
        )

        values = {
            "server_version": "GaussDB test",
            "current_database": "authorized_db",
            "current_user": "authorized_user",
            "sql_compatibility": "A",
            "server_encoding": "UTF8",
            "client_encoding": "UTF8",
            "behavior_compat_options": "",
            "enable_ilm": "off",
        }
        ok = self.ok
        class Transport:
            def __init__(self):
                self.calls = []
            def run(self, sql):
                self.calls.append(sql)
                if "version()" in sql:
                    return ok(values["server_version"])
                if "current_database()" in sql:
                    return ok(values["current_database"])
                if "current_user" in sql:
                    return ok(values["current_user"])
                for key, value in values.items():
                    if f"current_setting('{key}'" in sql:
                        return ok(value)
                raise AssertionError(sql)

        transport = Transport()
        result = run_advanced_package_runtime_preflight(self.plan, transport)
        audit = audit_advanced_package_runtime_preflight_result(result, plan=self.plan)
        self.assertEqual(transport.calls, [query.sql for query in self.plan.global_queries])
        self.assertTrue(result.connected)
        self.assertTrue(result.metadata_read)
        self.assertFalse(result.runtime_sql_executed)
        self.assertEqual(result.summary.query_count, 8)
        self.assertEqual(result.summary.success_count, 8)
        self.assertEqual(result.summary.error_count, 0)
        self.assertEqual(result.summary.finding_count, 0)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)

    def test_compatibility_finding_does_not_become_query_failure(self):
        from core.advanced_package_runtime_preflight import (
            run_advanced_package_runtime_preflight,
            audit_advanced_package_runtime_preflight_result,
        )

        def run(sql):
            if "sql_compatibility" in sql:
                return self.ok("B")
            return self.ok("recorded")

        result = run_advanced_package_runtime_preflight(self.plan, type("T", (), {"run": staticmethod(run)}))
        audit = audit_advanced_package_runtime_preflight_result(result, plan=self.plan)
        self.assertEqual(result.summary.success_count, 8)
        self.assertEqual(result.summary.finding_count, 1)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)

    def test_query_error_blocks_metadata_read(self):
        from core.advanced_package_runtime_preflight import (
            run_advanced_package_runtime_preflight,
            audit_advanced_package_runtime_preflight_result,
        )

        def run(sql):
            if "current_user" in sql:
                return self.fail("permission denied")
            return self.ok("recorded")

        result = run_advanced_package_runtime_preflight(self.plan, type("T", (), {"run": staticmethod(run)}))
        audit = audit_advanced_package_runtime_preflight_result(result, plan=self.plan)
        self.assertTrue(result.connected)
        self.assertFalse(result.metadata_read)
        self.assertEqual(result.summary.error_count, 1)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)

    def test_audit_rejects_runtime_sql_claim_and_plan_drift(self):
        from core.advanced_package_runtime_preflight import (
            run_advanced_package_runtime_preflight,
            audit_advanced_package_runtime_preflight_result,
        )

        result = run_advanced_package_runtime_preflight(
            self.plan,
            type("T", (), {"run": staticmethod(lambda sql: self.ok("recorded"))}),
        )
        bad = result.model_dump()
        bad["runtime_sql_executed"] = True
        audit = audit_advanced_package_runtime_preflight_result(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("preflight cannot execute runtime SQL", audit.errors)

        bad = result.model_dump()
        bad["plan_id"] = "wrong_plan"
        audit = audit_advanced_package_runtime_preflight_result(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn("plan id mismatch", audit.errors)

    def test_audit_cli_writes_report(self):
        import io
        import contextlib
        import tempfile
        from core.advanced_package_runtime_preflight import (
            run_advanced_package_runtime_preflight,
        )
        from scripts.audit_advanced_package_runtime_preflight_result import main as audit_main

        def run(sql):
            return self.ok("recorded")

        result = run_advanced_package_runtime_preflight(self.plan, type("T", (), {"run": staticmethod(run)}))
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            result_path = root / "result.json"
            plan_path = root / "plan.json"
            output_path = root / "audit.json"
            result_path.write_text(json.dumps(result.model_dump(), ensure_ascii=False), encoding="utf-8")
            plan_path.write_text(json.dumps(self.plan.model_dump(), ensure_ascii=False), encoding="utf-8")
            with contextlib.redirect_stdout(io.StringIO()):
                exit_code = audit_main([
                    "--result", str(result_path),
                    "--plan", str(plan_path),
                    "--output", str(output_path),
                ])
            payload = json.loads(output_path.read_text(encoding="utf-8"))
            self.assertEqual(exit_code, 0)
            self.assertTrue(payload["valid"])
            self.assertTrue(payload["plan_verified"])
