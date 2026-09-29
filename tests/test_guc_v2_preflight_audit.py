"""GUC V2 preflight results are audited against their read-only plan."""
import copy
import json
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace

from core.guc_preflight import (
    GucV2PreflightRegistry,
    ScriptedGucPreflightTransport,
    build_guc_v2_preflight_plan,
    run_guc_v2_preflight,
)
from core.guc_preflight_audit import audit_guc_v2_preflight_result


ROOT = Path(__file__).resolve().parents[1]


def ok(value):
    return SimpleNamespace(success=True, rows=[[value]], notices=[], error="")


def fail(error):
    return SimpleNamespace(success=False, rows=[], notices=[], error=error)


def valid_result(plan):
    registry = GucV2PreflightRegistry(ROOT)
    values = registry.current_values()
    transport = ScriptedGucPreflightTransport([ok(value) for value in values])
    return run_guc_v2_preflight(plan, transport)


class GucV2PreflightAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.plan = build_guc_v2_preflight_plan(ROOT)
        cls.result = valid_result(cls.plan)

    def test_valid_result_matches_plan_and_internal_counts(self):
        audit = audit_guc_v2_preflight_result(self.result, plan=self.plan)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)
        self.assertEqual(audit.summary.model_dump(), {
            "query_count": 27,
            "success_count": 27,
            "error_count": 0,
            "domain_mismatch_count": 0,
            "metadata_read": True,
            "connected": True,
        })

    def test_missing_plan_is_not_trusted(self):
        audit = audit_guc_v2_preflight_result(self.result)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn("plan not supplied", audit.errors[0])

    def test_environment_identity_mismatch_is_rejected(self):
        bad = copy.deepcopy(self.result.model_dump())
        bad["environment_id"] = "guc_environment_v1"
        audit = audit_guc_v2_preflight_result(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn("environment id mismatch", audit.errors[0])

    def test_query_identity_or_sql_drift_is_rejected(self):
        bad = copy.deepcopy(self.result.model_dump())
        bad["queries"][0]["parameter_name"] = "not_a_guc"
        audit = audit_guc_v2_preflight_result(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn("query identity mismatch", audit.errors[0])

        bad = copy.deepcopy(self.result.model_dump())
        bad["queries"][0]["sql"] = "SELECT 'tampered' AS value;"
        audit = audit_guc_v2_preflight_result(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertFalse(audit.plan_verified)
        self.assertIn("query SQL mismatch", audit.errors[0])

    def test_summary_count_drift_is_rejected(self):
        bad = copy.deepcopy(self.result.model_dump())
        bad["summary"]["success_count"] = 26
        audit = audit_guc_v2_preflight_result(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("summary success_count mismatch", audit.errors[0])

    def test_domain_mismatch_is_a_finding_not_a_schema_failure(self):
        registry = GucV2PreflightRegistry(ROOT)
        values = registry.current_values()
        values[0] = "not-a-valid-value"
        transport = ScriptedGucPreflightTransport([ok(value) for value in values])
        result = run_guc_v2_preflight(self.plan, transport)
        audit = audit_guc_v2_preflight_result(result, plan=self.plan)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)
        self.assertEqual(audit.summary.domain_mismatch_count, 1)

    def test_query_error_is_audited_and_blocks_metadata_read(self):
        registry = GucV2PreflightRegistry(ROOT)
        values = registry.current_values()
        responses = [ok(value) for value in values]
        responses[3] = fail("parameter unavailable")
        transport = ScriptedGucPreflightTransport(responses)
        result = run_guc_v2_preflight(self.plan, transport)
        audit = audit_guc_v2_preflight_result(result, plan=self.plan)
        self.assertTrue(audit.valid, audit.errors)
        self.assertTrue(audit.plan_verified)
        self.assertEqual(audit.summary.error_count, 1)
        self.assertFalse(audit.summary.metadata_read)

    def test_state_change_claim_is_rejected(self):
        bad = copy.deepcopy(self.result.model_dump())
        bad["guc_changed"] = True
        audit = audit_guc_v2_preflight_result(bad, plan=self.plan)
        self.assertFalse(audit.valid)
        self.assertIn("preflight cannot change GUC state", audit.errors)

    def test_cli_audits_result_against_plan(self):
        from scripts.audit_guc_v2_preflight_result import main as audit_main

        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            result_path = root / "result.json"
            plan_path = root / "plan.json"
            output_path = root / "audit.json"
            result_path.write_text(
                json.dumps(self.result.model_dump(), ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
            plan_path.write_text(
                json.dumps(self.plan.model_dump(), ensure_ascii=False) + "\n",
                encoding="utf-8",
            )
            audit_main([
                "--result", str(result_path),
                "--plan", str(plan_path),
                "--output", str(output_path),
            ])
            payload = json.loads(output_path.read_text(encoding="utf-8"))
            self.assertTrue(payload["valid"])
            self.assertTrue(payload["plan_verified"])
            self.assertEqual(payload["kind"], "guc_v2_preflight_audit")


if __name__ == "__main__":
    unittest.main()
