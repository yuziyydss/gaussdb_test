"""Real-package regression contracts for the dependency-closed chapter pilot."""
import json
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from scripts.verify_cross_chapter_dependencies import (
    DEFAULT_CONFIG, expected_graph, fixture_sql_probes, load_fault_probes, review_fixture_closures,
)


class CrossChapterDependencyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.config = json.loads(DEFAULT_CONFIG.read_text(encoding="utf-8"))
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / "specs")
        cls.registry.load_all()

    def test_reviewed_edges_match_registry_and_batch_is_closed(self):
        expected = expected_graph(self.config)
        actual = self.registry.factor_dependency_graph()
        self.assertEqual({f: actual[f] for f in expected}, expected)
        order = self.registry.factor_topological_order(self.config["factors"])
        self.assertEqual(set(order), set(self.config["factors"]))
        for consumer, dependencies in expected.items():
            for dependency in dependencies:
                self.assertLess(order.index(dependency), order.index(consumer))

    def test_invalid_fact_types_exports_and_cycles_are_rejected(self):
        result = load_fault_probes(self.registry)
        self.assertEqual(len(result), 6)
        self.assertTrue(all(p["detected"] for p in result))

    def test_partition_profile_fixture_closures_match_reviewed_owners(self):
        result = review_fixture_closures(self.config, self.registry)
        self.assertEqual(len(result), 10)
        self.assertTrue(all(p["passed"] for p in result))

    def test_generated_cross_package_view_fixtures_create_and_drop_in_order(self):
        result = fixture_sql_probes(self.registry, self.config)
        self.assertEqual(len(result), 2)
        self.assertTrue(all(p["case_count"] > 0 and p["passed"] for p in result))


if __name__ == "__main__":
    unittest.main()
