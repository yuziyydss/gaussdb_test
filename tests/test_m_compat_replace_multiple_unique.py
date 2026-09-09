"""Two-key REPLACE means two actual conflicting rows, not a profile label."""
import unittest
from pathlib import Path
from unittest.mock import patch

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_m_replace_multiple_unique'
FID = 'fixture_m_replace_multiple_unique'


class MReplaceMultipleUniqueTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / 'specs')
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests, MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_two_exact_candidates_and_real_fresh_keys(self):
        cases, report = self.cases()
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases}, {
            'REPLACE INTO m_replace_multi (id,qty) VALUES (1,20);',
            'REPLACE INTO m_replace_multi (id,qty) VALUES (3,30);'})
        self.assertEqual(len(cases), 2)
        for c in cases:
            self.assertEqual(c.setup_sqls, [
                'CREATE TABLE m_replace_multi (id INT PRIMARY KEY, qty INT UNIQUE);',
                'INSERT INTO m_replace_multi (id,qty) VALUES (1,10),(2,20);'])
            self.assertEqual(c.teardown_sqls, ['DROP TABLE m_replace_multi;'])
            self.assertEqual((c.expected, c.expected_scope), ('success', 'syntax_only'))
            gates = {g['key']: g for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode']['allowed_values'], ['M'])
            self.assertEqual(gates['object_authority']['allowed_values'], ['case_object_owner'])

    def test_actual_second_unique_key_is_required(self):
        self.cases()
        fixture = self.r.fixtures[FID].model_copy(deep=True)
        fixture.execution.setup_sqls[0] = fixture.execution.setup_sqls[0].replace('qty INT UNIQUE', 'qty INT')
        with patch.dict(self.r.fixtures, {FID: fixture}):
            with self.assertRaisesRegex(GenerationValidationError, 'unique_key'):
                self.g.generate_with_report(self.r.manifests[MID])

    def test_actual_seed_must_conflict_with_two_distinct_rows(self):
        self.cases()
        fixture = self.r.fixtures[FID].model_copy(deep=True)
        fixture.execution.setup_sqls[1] = fixture.execution.setup_sqls[1].replace('(2,20)', '(2,21)')
        with patch.dict(self.r.fixtures, {FID: fixture}):
            with self.assertRaisesRegex(GenerationValidationError, 'conflict_rows'):
                self.g.generate_with_report(self.r.manifests[MID])

    def test_two_oracles_not_mixed_with_deferrable_placeholder(self):
        self.cases()
        conflict = self.r.scenarios['scenario_m_replace_multiple_unique']
        control = self.r.scenarios['scenario_m_replace_multiple_unique_control']
        for scenario, rows, tag in [(conflict, [[1,20]], 'REPLACE 0 3'),
                                    (control, [[1,10],[2,20],[3,30]], 'REPLACE 0 1')]:
            self.assertEqual(scenario.status, 'planned')
            self.assertEqual(scenario.fixture_refs, [FID])
            self.assertTrue(all('sql' in s for s in scenario.steps))
            self.assertEqual(scenario.oracles[0]['expected'], rows)
            self.assertIn(tag, scenario.oracles[1]['expected'])
            self.assertNotIn('m_replace_fact_deferrable', scenario.fact_refs)
        delayed = self.r.scenarios['scenario_m_replace_deferrable_unsupported']
        self.assertEqual(delayed.status, 'planned')
        self.assertIn('m_replace_fact_deferrable', delayed.fact_refs)
        self.assertFalse(delayed.fixture_refs)

    def test_m_mode_cannot_be_removed_from_selected_key_contract(self):
        self.cases()
        manifest = self.r.manifests[MID].model_copy(deep=True)
        manifest.environment_requirements = [g for g in manifest.environment_requirements if g.key != 'compatibility_mode']
        with self.assertRaisesRegex(GenerationValidationError, 'compatibility_mode=M'):
            self.g.generate_with_report(manifest)

    def test_real_grammar_and_cross_chapter_key_sources(self):
        self.cases()
        facts = {f.id: f for f in self.r.factors['m_replace'].facts}
        self.assertTrue(facts['m_replace_fact_syntax'].source_anchor.endswith('L83-88'))
        self.assertTrue(facts['m_replace_fact_query_syntax'].source_anchor.endswith('L93-99'))
        self.assertTrue(facts['m_replace_fact_set_syntax'].source_anchor.endswith('L102-108'))
        exported = self.r.factors['m_create_table'].exported_fact_refs
        self.assertIn('m_create_table_fact_inline_unique', exported)
        self.assertIn('m_create_table_fact_inline_primary_key', exported)


if __name__ == '__main__':
    unittest.main()
