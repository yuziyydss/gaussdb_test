"""GUC V2 execution separates technical readiness from explicit authorization."""
import os
import unittest
from pathlib import Path
from unittest.mock import patch

from core.guc_execution_gate import evaluate_guc_v2_execution_gate
from core.guc_readiness import build_guc_v2_readiness


ROOT = Path(__file__).resolve().parents[1]


class GucV2ExecutionGateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.readiness = build_guc_v2_readiness(ROOT)

    def test_current_repo_is_technically_blocked_by_missing_preflight(self):
        gate = evaluate_guc_v2_execution_gate(
            self.readiness,
            authorized_flag=True,
            authorization_environment_set=True,
            database_enabled=True,
        )
        self.assertFalse(gate.allowed)
        self.assertTrue(gate.static_ready)
        self.assertTrue(gate.runtime_plan_ready)
        self.assertFalse(gate.preflight_ready)
        self.assertFalse(gate.technical_ready)
        self.assertTrue(gate.authorization_ready)
        self.assertTrue(gate.database_ready)
        self.assertIn("GUC V2 preflight is not ready.", gate.blockers)

    def test_gate_requires_all_three_readiness_layers(self):
        ready = self.readiness.model_copy(update={
            "preflight_result_present": True,
            "preflight_result_valid": True,
            "preflight_audit_valid": True,
            "preflight_connected": True,
            "preflight_metadata_read": True,
            "ready_for_authorized_execution": True,
            "summary": {
                **self.readiness.summary,
                "preflight_domain_mismatch_count": 0,
                "preflight_error_count": 0,
            },
        })
        gate = evaluate_guc_v2_execution_gate(
            ready,
            authorized_flag=True,
            authorization_environment_set=True,
            database_enabled=True,
        )
        self.assertTrue(gate.static_ready)
        self.assertTrue(gate.preflight_ready)
        self.assertTrue(gate.runtime_plan_ready)
        self.assertTrue(gate.technical_ready)
        self.assertTrue(gate.authorization_ready)
        self.assertTrue(gate.database_ready)
        self.assertTrue(gate.allowed)
        self.assertEqual(gate.blockers, [])

    def test_missing_authorization_blocks_even_when_technical_readiness_passes(self):
        ready = self.readiness.model_copy(update={
            "preflight_result_present": True,
            "preflight_result_valid": True,
            "preflight_audit_valid": True,
            "preflight_connected": True,
            "preflight_metadata_read": True,
            "ready_for_authorized_execution": True,
            "summary": {
                **self.readiness.summary,
                "preflight_domain_mismatch_count": 0,
                "preflight_error_count": 0,
            },
        })
        gate = evaluate_guc_v2_execution_gate(
            ready,
            authorized_flag=False,
            authorization_environment_set=True,
            database_enabled=True,
        )
        self.assertTrue(gate.technical_ready)
        self.assertFalse(gate.authorization_ready)
        self.assertFalse(gate.allowed)
        self.assertIn("Runtime execution authorization flag is missing.", gate.blockers)

    def test_missing_environment_authorization_blocks_execution(self):
        ready = self.readiness.model_copy(update={
            "preflight_result_present": True,
            "preflight_result_valid": True,
            "preflight_audit_valid": True,
            "preflight_connected": True,
            "preflight_metadata_read": True,
            "ready_for_authorized_execution": True,
            "summary": {
                **self.readiness.summary,
                "preflight_domain_mismatch_count": 0,
                "preflight_error_count": 0,
            },
        })
        gate = evaluate_guc_v2_execution_gate(
            ready,
            authorized_flag=True,
            authorization_environment_set=False,
            database_enabled=True,
        )
        self.assertTrue(gate.technical_ready)
        self.assertFalse(gate.authorization_ready)
        self.assertFalse(gate.allowed)
        self.assertIn("GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED is not set to true.", gate.blockers)

    def test_database_must_be_enabled(self):
        ready = self.readiness.model_copy(update={
            "preflight_result_present": True,
            "preflight_result_valid": True,
            "preflight_audit_valid": True,
            "preflight_connected": True,
            "preflight_metadata_read": True,
            "ready_for_authorized_execution": True,
            "summary": {
                **self.readiness.summary,
                "preflight_domain_mismatch_count": 0,
                "preflight_error_count": 0,
            },
        })
        gate = evaluate_guc_v2_execution_gate(
            ready,
            authorized_flag=True,
            authorization_environment_set=True,
            database_enabled=False,
        )
        self.assertTrue(gate.technical_ready)
        self.assertTrue(gate.authorization_ready)
        self.assertFalse(gate.database_ready)
        self.assertFalse(gate.allowed)
        self.assertIn("GAUSSDB_ENABLED is not true.", gate.blockers)

    def test_runtime_cli_is_blocked_before_database_connection(self):
        from scripts.run_guc_v2_runtime_pilot import main as runtime_cli

        with patch.dict(os.environ, {
            "GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED": "true",
            "GAUSSDB_ENABLED": "true",
        }):
            with self.assertRaisesRegex(SystemExit, "GUC V2 preflight is not ready"):
                runtime_cli(["--execute", "--authorized", "--output", "/tmp/unused.json"])


if __name__ == "__main__":
    unittest.main()
