"""All supported advanced packages are inventoried for expansion."""
import json
import unittest
from pathlib import Path

from core.advanced_package_candidate import build_advanced_package_candidate_matrix


ROOT = Path(__file__).resolve().parents[1]


class AdvancedPackageCandidateMatrixTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.matrix = build_advanced_package_candidate_matrix(ROOT)

    def test_all_22_supported_packages_are_inventoried(self):
        summary = self.matrix.summary
        self.assertEqual(self.matrix.schema_version, 1)
        self.assertEqual(self.matrix.kind, "advanced_package_candidate_matrix")
        self.assertEqual(summary.supported_package_count, 22)
        self.assertEqual(summary.modeled_package_count, 22)
        self.assertEqual(summary.unmodeled_package_count, 0)
        self.assertEqual(len(self.matrix.packages), 22)
        self.assertEqual(len({item.package_id for item in self.matrix.packages}), 22)

    def test_modeled_pilot_packages_are_marked(self):
        modeled = {
            item.package_id: item
            for item in self.matrix.packages
            if item.modeled
        }
        self.assertEqual(
            set(modeled),
            {
                "dbe_output", "dbe_raw", "dbe_sql", "dbe_match", "dbe_utility",
                "dbe_lob", "dbe_file", "dbe_obfuscation", "dbe_xmlgen", "dbe_alert",
                "dbe_session", "dbe_random", "dbe_application_info", "dbe_scheduler",
                "dbe_compression", "dbe_describe", "dbe_heat_map", "dbe_ilm",
                "dbe_ilm_admin", "dbe_stats", "dbe_xmldom", "dbe_xmlparser",
            },
        )
        for item in modeled.values():
            with self.subTest(package=item.package_id):
                self.assertEqual(item.candidate_tier, "modeled_pilot")
                self.assertIn(item.source_files[0], item.source_files)
                self.assertGreater(item.fact_count, 0)

    def test_no_unmodeled_packages_remain(self):
        summary = self.matrix.summary
        self.assertEqual(summary.near_term_candidate_count, 0)
        self.assertEqual(summary.later_batch_count, 0)
        self.assertEqual(summary.needs_extraction_count, 0)
        self.assertEqual(
            {item.package_id for item in self.matrix.packages if not item.modeled},
            set(),
        )

    def test_matrix_is_hash_bound_to_authoritative_sources(self):
        self.assertEqual(
            self.matrix.source.interface_inventory_relpath,
            "environments/advanced_packages_v1.yaml",
        )
        self.assertEqual(
            self.matrix.source.supported_package_relpath,
            "docs/compat_facts/oracle_advanced_packages.yaml",
        )

    def test_written_matrix_artifact_is_current(self):
        path = ROOT / "generated/advanced_package_pilot/candidate_matrix.json"
        self.assertTrue(path.is_file())
        payload = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(payload["kind"], "advanced_package_candidate_matrix")
        self.assertEqual(payload["summary"]["supported_package_count"], 22)
        self.assertEqual(payload["summary"]["modeled_package_count"], 22)
        self.assertEqual(payload["summary"]["near_term_candidate_count"], 0)


if __name__ == "__main__":
    unittest.main()
