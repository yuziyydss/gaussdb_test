"""GUC V2 capabilities are explicit, source-bound, and execution-safe."""
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from core.guc_capability import (
    GucCapabilityLoadError,
    GucCapabilityRegistry,
    build_guc_capability_matrix,
)


ROOT = Path(__file__).resolve().parents[1]


class GucCapabilityMatrixTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.matrix = build_guc_capability_matrix(ROOT)

    def test_matrix_contains_all_session_overlay_parameters(self):
        summary = self.matrix.summary
        self.assertEqual(self.matrix.schema_version, 1)
        self.assertEqual(self.matrix.kind, "guc_capability_matrix")
        self.assertEqual(summary.capability_count, 19)
        self.assertEqual(summary.runtime_fact_bound_count, 11)
        self.assertEqual(summary.needs_runtime_fact_count, 8)
        self.assertEqual(summary.allowed_value_count, 38)
        self.assertEqual(summary.plan_step_count, 95)
        self.assertEqual(len(self.matrix.capabilities), 19)
        self.assertEqual(
            len({item.requirement_key for item in self.matrix.capabilities}), 19
        )

    def test_each_capability_is_explicit_and_safe(self):
        for capability in self.matrix.capabilities:
            with self.subTest(parameter=capability.parameter_name):
                self.assertTrue(capability.requirement_key.startswith("guc_"))
                self.assertTrue(capability.allowed_values)
                self.assertEqual(len(capability.allowed_values), len(set(capability.allowed_values)))
                # Empty string is a valid option-set value in GUC V2; a future
                # Factor Package adapter must translate it explicitly.
                self.assertEqual(len(capability.plan.steps), 5)
                self.assertEqual(
                    [step.action for step in capability.plan.steps],
                    [
                        "capture_original", "apply", "verify_target",
                        "restore", "verify_restore",
                    ],
                )
                joined_sql = "\n".join(step.sql for step in capability.plan.steps)
                for forbidden in ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET "):
                    self.assertNotIn(forbidden, joined_sql)
                if capability.integration_status == "runtime_fact_bound":
                    self.assertTrue(capability.fact_refs)
                else:
                    self.assertEqual(capability.fact_refs, [])

    def test_runtime_fact_bound_capabilities_use_confirmed_runtime_facts(self):
        fact_bound = [
            item for item in self.matrix.capabilities
            if item.integration_status == "runtime_fact_bound"
        ]
        self.assertEqual(len(fact_bound), 11)
        self.assertEqual(
            {item.parameter_name for item in fact_bound},
            {
                "behavior_compat_options",
                "b_format_behavior_compat_options",
                "default_transaction_isolation",
                "default_transaction_read_only",
                "plan_cache_mode",
                "sql_beta_feature",
                "a_format_enable_copy_empty_lobs",
                "enable_copy_case_sensitive",
                "enable_copy_when_filler",
                "enable_log_copy_illegal_chars",
                "track_procedure_sql",
            },
        )

    def test_matrix_is_bound_to_environment_and_overlay_plans(self):
        source = self.matrix.source
        self.assertEqual(source.environment_relpath, "environments/guc_parameters_v2.yaml")
        self.assertEqual(
            source.overlay_plans_relpath,
            "generated/guc_environment_v2/overlay_plans.json",
        )
        environment_hash = hashlib.sha256(
            (ROOT / source.environment_relpath).read_bytes()
        ).hexdigest()
        overlay_hash = hashlib.sha256(
            (ROOT / source.overlay_plans_relpath).read_bytes()
        ).hexdigest()
        self.assertEqual(source.environment_sha256, environment_hash)
        self.assertEqual(source.overlay_plans_sha256, overlay_hash)

    def test_written_matrix_artifact_is_current(self):
        path = ROOT / "generated/guc_environment_v2/capability_matrix.json"
        self.assertTrue(path.is_file())
        payload = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(payload["kind"], "guc_capability_matrix")
        self.assertEqual(payload["summary"]["capability_count"], 19)
        self.assertEqual(payload["summary"]["runtime_fact_bound_count"], 11)
        self.assertEqual(payload["summary"]["needs_runtime_fact_count"], 8)

    def test_payload_with_drifted_summary_fails_closed(self):
        payload = json.loads(
            (ROOT / "generated/guc_environment_v2/capability_matrix.json").read_text(
                encoding="utf-8"
            )
        )
        payload["summary"]["capability_count"] += 1
        with self.assertRaises(GucCapabilityLoadError) as caught:
            GucCapabilityRegistry(ROOT).load_payload(payload)
        self.assertIn("summary", str(caught.exception))

    def test_registry_writes_and_loads_matrix(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "capability_matrix.json"
            registry = GucCapabilityRegistry(ROOT)
            written = registry.write(output)
            self.assertEqual(written, output)
            loaded = registry.load(output)
            self.assertEqual(loaded.kind, "guc_capability_matrix")
            self.assertEqual(len(loaded.capabilities), 19)


if __name__ == "__main__":
    unittest.main()
