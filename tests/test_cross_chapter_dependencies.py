"""Real-package regression contracts for the dependency-closed chapter pilot."""
import json
import unittest
from unittest.mock import patch
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from scripts.verify_cross_chapter_dependencies import (
    DEFAULT_CONFIG, expected_graph, fixture_sql_probes, load_fault_probes, review_fixture_closures, review_links,
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
        scheduling = expected_graph(self.config, scheduling=True)
        actual_scheduling = self.registry.factor_scheduling_graph()
        self.assertEqual({f: actual_scheduling[f] for f in scheduling}, scheduling)
        order = self.registry.factor_topological_order(self.config["factors"])
        self.assertEqual(set(order), set(self.config["factors"]))
        for consumer, dependencies in scheduling.items():
            for dependency in dependencies:
                self.assertLess(order.index(dependency), order.index(consumer))

    def test_invalid_fact_types_exports_and_cycles_are_rejected(self):
        result = load_fault_probes(self.registry)
        self.assertEqual(len(result), 6)
        self.assertTrue(all(p["detected"] for p in result))

    def test_reviewed_environment_import_is_read_from_its_actual_gate(self):
        link = next(l for l in self.config['fact_links'] if l['entity'] == 'manifest_create_index_gin_pending_control'
                    and l.get('gate_key') == 'compatibility_mode')
        config = dict(self.config, fact_links=[link],
                      fixture_links=[], fixture_closures=[])
        # Source provenance has independent real-PDF tests; isolate this selector.
        with patch('scripts.verify_cross_chapter_dependencies.fact_evidence', return_value={}):
            result = review_links(config, self.registry, {})
        self.assertEqual(result['facts'][0]['provider'],
                         'create_database::create_database_fact_compatibility_environment')

    def test_environment_import_on_another_gate_does_not_satisfy_review(self):
        import yaml
        link = next(l for l in self.config['fact_links'] if l['entity'] == 'manifest_create_index_gin_pending_control'
                    and l.get('gate_key') == 'compatibility_mode')
        config = dict(self.config, fact_links=[link], fixture_links=[], fixture_closures=[])
        raw = yaml.safe_load(self.registry.source_paths[link['entity']].read_text())
        gate = next(g for g in raw['environment_requirements'] if g['key']=='compatibility_mode')
        gate['fact_refs'] = []
        raw['environment_requirements'].append(dict(key='unrelated', fact_refs=[link['provider']]))
        with patch('yaml.safe_load', return_value=raw):
            with self.assertRaisesRegex(ValueError, 'missing import'):
                review_links(config, self.registry, {})

    def test_partition_profile_fixture_closures_match_reviewed_owners(self):
        result = review_fixture_closures(self.config, self.registry)
        self.assertEqual(len(result), 10)
        self.assertTrue(all(p["passed"] for p in result))

    def test_profile_import_is_read_from_the_exact_selected_profile(self):
        link=next(l for l in self.config['fact_links'] if l.get('profile_id') == 'tr_partition_table_two_owned')
        config=dict(self.config,fact_links=[link],fixture_links=[],fixture_closures=[])
        with patch('scripts.verify_cross_chapter_dependencies.fact_evidence',return_value={}):
            result=review_links(config,self.registry,{})
        self.assertEqual(result['facts'][0]['provider'],'create_table_partition::create_table_partition_fact_body_496')

    def test_parent_or_other_profile_import_cannot_satisfy_selected_profile(self):
        import yaml
        link=next(l for l in self.config['fact_links'] if l.get('profile_id') == 'tr_partition_table_two_owned')
        config=dict(self.config,fact_links=[link],fixture_links=[],fixture_closures=[])
        raw=yaml.safe_load(self.registry.source_paths[link['entity']].read_text())
        selected=next(p for p in raw['profiles'] if p['id']==link['profile_id'])
        selected['fact_refs'].remove(link['provider'])
        raw['fact_refs'].append(link['provider'])
        next(p for p in raw['profiles'] if p['id']!=link['profile_id'])['fact_refs'].append(link['provider'])
        with patch('yaml.safe_load',return_value=raw):
            with self.assertRaisesRegex(ValueError,'missing import'):
                review_links(config,self.registry,{})

    def test_generated_cross_package_view_fixtures_create_and_drop_in_order(self):
        result = fixture_sql_probes(self.registry, self.config)
        self.assertEqual(len(result), 2)
        self.assertTrue(all(p["case_count"] > 0 and p["passed"] for p in result))


if __name__ == "__main__":
    unittest.main()
