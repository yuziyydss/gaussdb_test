"""GUC V2 API exposes local artifacts without claiming database execution."""
import os
import unittest
from unittest.mock import patch

try:
    from fastapi.testclient import TestClient
    from main import app
    HAS_FASTAPI = True
except ImportError:
    HAS_FASTAPI = False


@unittest.skipUnless(HAS_FASTAPI, "fastapi or httpx dependencies are unavailable")
class GucV2ApiTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.client = TestClient(app)

    def test_guc_page_shows_v2_summary_and_static_boundary(self):
        response = self.client.get("/guc")
        self.assertEqual(response.status_code, 200)
        self.assertIn("GUC 参数与环境计划", response.text)
        self.assertIn("当前页面只读取本地 GUC V2 产物", response.text)
        self.assertIn("Session overlay", response.text)
        self.assertIn("a_format_enable_copy_empty_lobs", response.text)
        self.assertIn("enable_plan_trace", response.text)
        self.assertIn("跨层静态审计", response.text)
        self.assertIn("session_overlay_plan_coverage", response.text)
        self.assertIn("只读 Preflight", response.text)
        self.assertIn("SELECT current_setting(", response.text)
        self.assertIn("执行就绪分层", response.text)
        self.assertIn("GUC V2 preflight result is missing.", response.text)
        self.assertIn("Runtime Pilot", response.text)
        self.assertIn("runtime_guc_v2_pilot_v1", response.text)
        self.assertIn("guc_v2_overlay_", response.text)
        self.assertIn("Execution Gate", response.text)
        self.assertIn("技术就绪", response.text)
        self.assertIn("Preflight审计", response.text)
        self.assertIn("Missing or invalid", response.text)
        self.assertIn("Evidence Bundle", response.text)
        self.assertIn("Capability Adapter", response.text)
        self.assertIn("Requirement Adapter", response.text)
        self.assertIn("converted", response.text)
        self.assertIn("empty_value_not_supported", response.text)
        self.assertIn("guc_enable_seqscan", response.text)
        self.assertIn("needs fact", response.text)
        self.assertIn("静态证据", response.text)
        self.assertIn("Preflight证据", response.text)
        self.assertIn("Runtime证据", response.text)
        self.assertIn("授权请求", response.text)
        self.assertIn("数据库", response.text)

    def test_summary_api_reports_environment_and_plan_counts(self):
        response = self.client.get("/api/guc/v2/summary")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["environment"]["schema_version"], 2)
        self.assertEqual(payload["environment"]["id"], "guc_environment_v2")
        self.assertEqual(payload["overlay_plans"]["summary"]["environment_parameter_count"], 27)
        self.assertEqual(payload["overlay_plans"]["summary"]["exported_plan_count"], 19)
        self.assertEqual(payload["overlay_plans"]["summary"]["step_count"], 95)
        self.assertEqual(payload["overlay_plans"]["summary"]["excluded_parameter_count"], 8)

    def test_parameters_api_supports_policy_filter(self):
        all_response = self.client.get("/api/guc/v2/parameters")
        self.assertEqual(all_response.status_code, 200)
        all_payload = all_response.json()
        self.assertEqual(all_payload["total"], 27)

        overlay_response = self.client.get(
            "/api/guc/v2/parameters",
            params={"policy": "session_overlay"},
        )
        self.assertEqual(overlay_response.status_code, 200)
        overlay_payload = overlay_response.json()
        self.assertEqual(overlay_payload["total"], 19)
        self.assertTrue(all(
            parameter["execution_policy"] == "session_overlay"
            for parameter in overlay_payload["parameters"]
        ))

        manual_response = self.client.get(
            "/api/guc/v2/parameters",
            params={"policy": "manual_review"},
        )
        self.assertEqual(manual_response.status_code, 200)
        manual_names = {
            parameter["name"]
            for parameter in manual_response.json()["parameters"]
        }
        self.assertEqual(manual_names, {
            "synchronous_commit",
            "m_format_behavior_compat_options",
            "enable_plan_trace",
            "enable_save_datachanged_timestamp",
            "b_format_version",
            "b_format_dev_version",
        })

    def test_parameter_detail_and_missing_parameter(self):
        response = self.client.get("/api/guc/v2/parameters/guc_track_procedure_sql")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["name"], "track_procedure_sql")
        self.assertEqual(payload["execution_policy"], "session_overlay")

        missing = self.client.get("/api/guc/v2/parameters/guc_missing")
        self.assertEqual(missing.status_code, 404)
        self.assertEqual(missing.json(), {"detail": "GUC parameter not found"})

    def test_audit_api_reports_cross_layer_static_validity(self):
        response = self.client.get("/api/guc/v2/audit")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertTrue(payload["valid"])
        self.assertTrue(payload["checks"])
        self.assertTrue(all(check["passed"] for check in payload["checks"]))
        self.assertEqual(payload["summary"]["environment_parameter_count"], 27)
        self.assertEqual(payload["summary"]["exported_plan_count"], 19)

    def test_preflight_plan_api_is_read_only_and_covers_all_parameters(self):
        response = self.client.get("/api/guc/v2/preflight-plan")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "guc_v2_preflight_plan")
        self.assertEqual(payload["summary"]["query_count"], 27)
        self.assertTrue(payload["summary"]["read_only"])
        self.assertEqual(len(payload["queries"]), 27)
        for query in payload["queries"]:
            with self.subTest(parameter=query["parameter_name"]):
                self.assertTrue(query["sql"].startswith("SELECT current_setting("))
                for forbidden in ("SET ", "INSERT ", "UPDATE ", "DELETE ", "CREATE ", "DROP ", "ALTER "):
                    self.assertNotIn(forbidden, query["sql"])

    def test_readiness_api_separates_static_preflight_authorization_and_runtime(self):
        response = self.client.get("/api/guc/v2/readiness")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "guc_v2_readiness")
        self.assertTrue(payload["static_audit_valid"])
        self.assertTrue(payload["environment_v2_valid"])
        self.assertTrue(payload["overlay_plans_valid"])
        self.assertTrue(payload["preflight_plan_valid"])
        self.assertFalse(payload["preflight_result_present"])
        self.assertFalse(payload["ready_for_authorized_execution"])
        self.assertFalse(payload["execution_authorized"])
        self.assertFalse(payload["runtime_verified"])
        self.assertIn("GUC V2 preflight result is missing.", payload["blockers"])

    def test_capabilities_api_reports_fact_bound_and_unbound_parameters(self):
        response = self.client.get("/api/guc/v2/capabilities")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "guc_capability_matrix")
        self.assertEqual(payload["summary"]["capability_count"], 19)
        self.assertEqual(payload["summary"]["runtime_fact_bound_count"], 11)
        self.assertEqual(payload["summary"]["needs_runtime_fact_count"], 8)
        self.assertEqual(payload["summary"]["allowed_value_count"], 38)
        self.assertEqual(payload["summary"]["plan_step_count"], 95)
        by_key = {item["requirement_key"]: item for item in payload["capabilities"]}
        self.assertEqual(
            by_key["guc_enable_seqscan"]["integration_status"],
            "needs_runtime_fact",
        )
        self.assertEqual(
            by_key["guc_track_procedure_sql"]["integration_status"],
            "runtime_fact_bound",
        )

    def test_requirement_adapter_api_converts_safe_capabilities_only(self):
        response = self.client.get("/api/guc/v2/requirement-adapter")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "guc_requirement_adapter")
        self.assertEqual(payload["summary"]["capability_count"], 19)
        self.assertEqual(payload["summary"]["requirement_count"], 9)
        self.assertEqual(payload["summary"]["blocked_count"], 10)
        self.assertEqual(payload["summary"]["missing_fact_blocked_count"], 8)
        self.assertEqual(payload["summary"]["empty_value_blocked_count"], 2)
        converted = {item["parameter_name"] for item in payload["requirements"]}
        self.assertNotIn("enable_seqscan", converted)
        self.assertNotIn("behavior_compat_options", converted)
        self.assertIn("track_procedure_sql", converted)

    def test_evidence_bundle_api_reports_present_and_missing_artifacts(self):
        response = self.client.get("/api/guc/v2/evidence-bundle")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "guc_v2_evidence_bundle")
        self.assertEqual(payload["summary"]["artifact_count"], 15)
        self.assertEqual(payload["summary"]["present_count"], 11)
        self.assertEqual(payload["summary"]["missing_count"], 4)
        self.assertTrue(payload["summary"]["static_complete"])
        self.assertFalse(payload["summary"]["preflight_complete"])
        self.assertFalse(payload["summary"]["runtime_complete"])
        self.assertFalse(payload["summary"]["all_complete"])
        missing_names = {
            artifact["name"]
            for artifact in payload["artifacts"]
            if not artifact["exists"]
        }
        self.assertEqual(missing_names, {
            "preflight_result",
            "preflight_audit",
            "runtime_receipt",
            "runtime_receipt_audit",
        })

    def test_evidence_bundle_verification_api_matches_current_artifacts(self):
        response = self.client.get("/api/guc/v2/evidence-bundle/verify")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "guc_v2_evidence_bundle_verification")
        self.assertTrue(payload["valid"])
        self.assertEqual(payload["recorded_summary"]["artifact_count"], 15)
        self.assertEqual(payload["current_summary"]["artifact_count"], 15)
        self.assertEqual(payload["current_summary"]["present_count"], 11)
        self.assertEqual(payload["current_summary"]["missing_count"], 4)

    def test_execution_gate_api_previews_blockers_without_executing(self):
        with patch.dict(os.environ, {
            "GAUSSDB_ENABLED": "true",
            "GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED": "true",
        }):
            response = self.client.get(
                "/api/guc/v2/execution-gate",
                params={"authorized": "true"},
            )
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["kind"], "guc_v2_execution_gate")
        self.assertTrue(payload["static_ready"])
        self.assertTrue(payload["runtime_plan_ready"])
        self.assertFalse(payload["preflight_ready"])
        self.assertFalse(payload["technical_ready"])
        self.assertTrue(payload["authorization_requested"])
        self.assertTrue(payload["authorization_environment_set"])
        self.assertTrue(payload["authorization_ready"])
        self.assertTrue(payload["database_enabled"])
        self.assertTrue(payload["database_ready"])
        self.assertFalse(payload["allowed"])
        self.assertIn("GUC V2 preflight is not ready.", payload["blockers"])

    def test_execution_gate_defaults_to_not_requested(self):
        response = self.client.get("/api/guc/v2/execution-gate")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertFalse(payload["authorization_requested"])
        self.assertFalse(payload["allowed"])
        self.assertIn(
            "Runtime execution authorization flag is missing.",
            payload["blockers"],
        )

    def test_runtime_plan_api_exposes_dry_run_without_execution_claims(self):
        response = self.client.get("/api/guc/v2/runtime-plan")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(payload["profile"], "runtime_guc_v2_pilot_v1")
        self.assertEqual(payload["kind"], "runtime_validation_pilot")
        self.assertEqual(len(payload["units"]), 19)
        self.assertEqual(sum(len(unit["execution_plan"]) for unit in payload["units"]), 95)
        self.assertFalse(payload["database_executed"])
        self.assertFalse(payload["execution_authorized"])
        self.assertEqual(payload["runtime_verified"], 0)
        for unit in payload["units"]:
            with self.subTest(unit=unit["id"]):
                self.assertEqual(unit["kind"], "guc_overlay")
                self.assertEqual(
                    [step["phase"] for step in unit["execution_plan"]],
                    [
                        "capture_original", "apply", "verify_target",
                        "restore", "verify_restore",
                    ],
                )

    def test_plans_api_and_plain_sql_export(self):
        response = self.client.get("/api/guc/v2/plans")
        self.assertEqual(response.status_code, 200)
        payload = response.json()
        self.assertEqual(len(payload["plans"]), 19)
        self.assertEqual(payload["summary"]["step_count"], 95)

        sql_response = self.client.get("/api/guc/v2/plans.sql")
        self.assertEqual(sql_response.status_code, 200)
        self.assertIn("SET track_procedure_sql = 'off';", sql_response.text)
        for forbidden in ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET "):
            self.assertNotIn(forbidden, sql_response.text)


if __name__ == "__main__":
    unittest.main()
