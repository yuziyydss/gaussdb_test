"""Non-SQL reference facts are typed, categorized, and hash-bound."""
import tempfile
import unittest
from pathlib import Path

import yaml

from core.non_sql_reference import NonSqlReferenceLoadError, NonSqlReferenceRegistry


ROOT = Path(__file__).resolve().parents[1]


class NonSqlReferenceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.inventory = NonSqlReferenceRegistry(ROOT).load_all()

    def test_all_existing_reference_files_are_typed_and_hash_bound(self):
        summary = self.inventory.summary
        self.assertEqual(self.inventory.kind, "non_sql_reference_inventory")
        self.assertEqual(summary.source_file_count, 67)
        self.assertEqual(summary.fact_count, 885)
        self.assertEqual(summary.fact_status_counts, {"confirmed": 882, "needs_verification": 3})
        self.assertEqual(
            summary.fact_type_counts,
            {
                "behavior_oracle": 277,
                "constraint": 111,
                "environment": 203,
                "lifecycle": 2,
                "metadata_oracle": 103,
                "syntax": 189,
            },
        )
        self.assertEqual(
            summary.category_counts,
            {
                "compatibility": 26,
                "log_reference": 1,
                "report": 1,
                "runtime_parameters": 12,
                "schema": 2,
                "stored_procedure": 16,
                "system_catalog": 6,
                "tool_reference": 3,
            },
        )
        self.assertEqual(
            summary.category_fact_counts,
            {
                "compatibility": 375,
                "log_reference": 6,
                "report": 6,
                "runtime_parameters": 174,
                "schema": 30,
                "stored_procedure": 220,
                "system_catalog": 53,
                "tool_reference": 21,
            },
        )
        self.assertEqual(summary.duplicate_bare_fact_id_count, 8)
        self.assertEqual(summary.unresolved_fact_ids, [
            "docs/compat_facts/runtime_params_connection_resource.yaml::guc_max_wal_size",
            "docs/compat_facts/runtime_params_lock_transaction.yaml::guc_td_compatible_truncation",
            "docs/compat_facts/tool_reference_monitoring.yaml::tool_gs_cgroup",
        ])
        self.assertTrue(all(len(source.sha256) == 64 for source in self.inventory.sources))

    def test_domain_specific_fact_properties_are_preserved(self):
        source = next(item for item in self.inventory.sources if item.path == "docs/compat_facts/mysql_m_data_types.yaml")
        fact = next(item for item in source.facts if "compatibility_mode" in item.properties)
        self.assertEqual(fact.properties["compatibility_mode"], "M")
        self.assertIn("source_physical_pages", fact.properties)

    def test_malformed_fact_fails_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            docs = root / "docs/compat_facts"
            docs.mkdir(parents=True)
            payload = {
                "document": "集中式版参考 / 7 数据库运行参数说明 / test",
                "version": "V1",
                "parent_pdf_sha256": "a" * 64,
                "extraction_date": "2026-01-01",
                "extraction_method": "test",
                "verification_status": "confirmed",
                "facts": [{"id": "bad", "type": "environment", "statement": "", "status": "confirmed", "source_anchor": "L1"}],
            }
            (docs / "test.yaml").write_text(yaml.safe_dump(payload), encoding="utf-8")
            with self.assertRaises(NonSqlReferenceLoadError) as caught:
                NonSqlReferenceRegistry(root).load_all()
            self.assertIn("statement", str(caught.exception))


if __name__ == "__main__":
    unittest.main()
