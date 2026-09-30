"""GUC V2 requirement adapter stays Factor Package schema-compatible."""
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from core.factor_package_model import EnvironmentRequirementDef
from core.guc_requirement_adapter import (
    GucRequirementAdapterError,
    GucRequirementAdapterRegistry,
    build_guc_requirement_adapter,
)


ROOT = Path(__file__).resolve().parents[1]


class GucRequirementAdapterTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.adapter = build_guc_requirement_adapter(ROOT)

    def test_adapter_converts_only_safe_fact_bound_capabilities(self):
        summary = self.adapter.summary
        self.assertEqual(self.adapter.schema_version, 1)
        self.assertEqual(self.adapter.kind, "guc_requirement_adapter")
        self.assertEqual(summary.capability_count, 19)
        self.assertEqual(summary.requirement_count, 9)
        self.assertEqual(summary.blocked_count, 10)
        self.assertEqual(summary.missing_fact_blocked_count, 8)
        self.assertEqual(summary.empty_value_blocked_count, 2)

    def test_requirements_are_factor_package_schema_compatible(self):
        self.assertEqual(len(self.adapter.requirements), 9)
        for item in self.adapter.requirements:
            with self.subTest(parameter=item.parameter_name):
                requirement = EnvironmentRequirementDef(
                    key=item.requirement.key,
                    allowed_values=item.requirement.allowed_values,
                    fact_refs=item.requirement.fact_refs,
                )
                self.assertTrue(requirement.key.startswith("guc_"))
                self.assertTrue(requirement.allowed_values)
                self.assertTrue(requirement.fact_refs)
                self.assertNotIn("", requirement.allowed_values)

    def test_blocked_capabilities_are_explicit_and_do_not_disappear(self):
        blocked = {item.parameter_name: item.reason for item in self.adapter.blocked}
        self.assertEqual(len(blocked), 10)
        self.assertEqual(
            {name for name, reason in blocked.items() if reason == "missing_runtime_fact"},
            {
                "enable_hashjoin",
                "enable_indexscan",
                "enable_indexonlyscan",
                "enable_material",
                "enable_nestloop",
                "enable_seqscan",
                "enable_sort",
                "enable_tidscan",
            },
        )
        self.assertEqual(
            {name for name, reason in blocked.items() if reason == "empty_value_not_supported"},
            {"behavior_compat_options", "b_format_behavior_compat_options"},
        )

    def test_adapter_is_bound_to_capability_matrix(self):
        source = self.adapter.source
        self.assertEqual(
            source.capability_matrix_relpath,
            "generated/guc_environment_v2/capability_matrix.json",
        )
        actual_hash = hashlib.sha256(
            (ROOT / source.capability_matrix_relpath).read_bytes()
        ).hexdigest()
        self.assertEqual(source.capability_matrix_sha256, actual_hash)

    def test_written_adapter_artifact_is_current(self):
        path = ROOT / "generated/guc_environment_v2/requirement_adapter.json"
        self.assertTrue(path.is_file())
        payload = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(payload["kind"], "guc_requirement_adapter")
        self.assertEqual(payload["summary"]["requirement_count"], 9)
        self.assertEqual(payload["summary"]["blocked_count"], 10)

    def test_payload_with_drifted_summary_fails_closed(self):
        payload = json.loads(
            (ROOT / "generated/guc_environment_v2/requirement_adapter.json").read_text(
                encoding="utf-8"
            )
        )
        payload["summary"]["requirement_count"] += 1
        with self.assertRaises(GucRequirementAdapterError) as caught:
            GucRequirementAdapterRegistry(ROOT).load_payload(payload)
        self.assertIn("summary", str(caught.exception))

    def test_registry_writes_and_loads_adapter(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "requirement_adapter.json"
            registry = GucRequirementAdapterRegistry(ROOT)
            written = registry.write(output)
            self.assertEqual(written, output)
            loaded = registry.load(output)
            self.assertEqual(loaded.kind, "guc_requirement_adapter")
            self.assertEqual(len(loaded.requirements), 9)
            self.assertEqual(len(loaded.blocked), 10)


if __name__ == "__main__":
    unittest.main()
