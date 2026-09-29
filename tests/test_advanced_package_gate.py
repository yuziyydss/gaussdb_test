"""Advanced Package gate blocks execution until evidence, auth, and DB align."""
import os
import unittest
from pathlib import Path
from unittest.mock import patch

from core.advanced_package_gate import evaluate_advanced_package_gate


ROOT = Path(__file__).resolve().parents[1]


class AdvancedPackageGateTests(unittest.TestCase):
    def test_current_repository_blocks_execution_until_preflight_is_complete(self):
        gate = evaluate_advanced_package_gate(
            ROOT,
            authorized_flag=True,
            authorization_environment_set=True,
            database_enabled=True,
        )
        self.assertTrue(gate.static_ready)
        self.assertTrue(gate.runtime_plan_ready)
        self.assertTrue(gate.preflight_plan_valid)
        self.assertFalse(gate.preflight_result_present)
        self.assertFalse(gate.preflight_audit_present)
        self.assertFalse(gate.preflight_ready)
        self.assertTrue(gate.authorization_ready)
        self.assertTrue(gate.database_ready)
        self.assertFalse(gate.technical_ready)
        self.assertFalse(gate.ready_for_authorized_execution)
        self.assertFalse(gate.allowed)
        self.assertIn("Advanced package preflight result is missing.", gate.blockers)
        self.assertIn("Advanced package preflight audit is missing.", gate.blockers)

    def test_missing_authorization_blocks_execution(self):
        gate = evaluate_advanced_package_gate(
            ROOT,
            authorized_flag=False,
            authorization_environment_set=True,
            database_enabled=True,
        )
        self.assertFalse(gate.allowed)
        self.assertIn("Runtime execution authorization flag is missing.", gate.blockers)

    def test_missing_environment_authorization_blocks_execution(self):
        gate = evaluate_advanced_package_gate(
            ROOT,
            authorized_flag=True,
            authorization_environment_set=False,
            database_enabled=True,
        )
        self.assertFalse(gate.allowed)
        self.assertIn("GAUSSDB_RUNTIME_PILOT_AUTHORIZED is not set to true.", gate.blockers)

    def test_missing_database_blocks_execution(self):
        gate = evaluate_advanced_package_gate(
            ROOT,
            authorized_flag=True,
            authorization_environment_set=True,
            database_enabled=False,
        )
        self.assertFalse(gate.allowed)
        self.assertIn("GAUSSDB_ENABLED is not true.", gate.blockers)


if __name__ == "__main__":
    unittest.main()
