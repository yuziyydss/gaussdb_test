"""Ambiguous source interpretations must not become hard negative oracles."""
from pathlib import Path
import json
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from core.factor_package_model import FactorPackageRegistry


class AmbiguousInsertSourceReviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.factor = cls.registry.factors['insert']

    def test_original_ambiguous_line_is_not_mapped_as_a_proven_query_ban(self):
        ledger = self.registry.source_ledgers[self.factor.source_ledger_ref]
        unit = next(u for u in ledger.units if u.id == 'insert_v10_140')
        self.assertEqual((unit.line_start, unit.line_end), (367, 367))
        self.assertEqual(unit.status, 'mapped')
        facts = {f.id: f for f in self.factor.facts}
        boundaries = [facts[ref] for ref in unit.fact_refs
                      if facts[ref].type == 'environment' and facts[ref].status == 'confirmed']
        self.assertTrue(boundaries)
        self.assertIn('query', ' '.join(f.statement for f in boundaries))
        self.assertIn('subquery', ' '.join(f.statement for f in boundaries))

    def test_ambiguous_interpretation_does_not_filter_the_global_feasible_domain(self):
        self.assertNotIn('insert_rule_conflict_rejects_query_source', [r.id for r in self.factor.rules])
        fact = next(f for f in self.factor.facts if f.id == 'insert_fact_conflict_restrictions')
        self.assertEqual(fact.status, 'confirmed')
        self.assertNotIn('query 输入', fact.statement)

    def test_old_negative_is_not_exposed_as_an_active_manifest(self):
        mid = 'manifest_insert_conflict_query_negative'
        self.assertNotIn(mid, self.factor.manifest_refs)
        self.assertNotIn(mid, self.registry.manifests)

    def test_original_sql_and_error_hypothesis_survive_in_a_planned_review(self):
        sid = 'scenario_insert_conflict_query_review'
        self.assertIn(sid, self.factor.scenario_refs)
        scenario = self.registry.scenarios[sid]
        self.assertEqual(scenario.status, 'planned')
        text = json.dumps(scenario.model_dump(), ensure_ascii=False)
        self.assertIn('manifest_insert_conflict_query_negative_d77629272b13', text)
        self.assertIn('INSERT INTO t_insert_unique (id, note) SELECT col_1, name FROM t_insert_source ON CONFLICT (id) DO NOTHING;', text)
        self.assertIn('conflict_query_not_supported', text)
        self.assertIn('needs_verification', text)
        self.assertIn('t_insert_unique', text)
        self.assertIn('PG', text)


if __name__ == '__main__':
    unittest.main()
