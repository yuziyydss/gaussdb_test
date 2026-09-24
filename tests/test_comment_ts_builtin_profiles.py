"""COMMENT ON built-in text search parser/template uses transaction rollback."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]


class CommentTextSearchBuiltinTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self, mid):
        self.assertTrue(mid in self.r.manifests, mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def check_builtin_target(self, mid, target, feature_id, provider, provider_fact):
        cases, report = self.cases(mid)
        self.assertEqual(len(cases), 4)
        self.assertTrue(report.pairwise_complete)
        expected = {
            f'COMMENT ON {target} IS {text};'
            for text in ("'factor note'", "'测试注释'", "'owner''s note'", 'NULL')
        }
        self.assertEqual({c.sql for c in cases}, expected)
        self.assertTrue(all(c.expected == 'success' and c.expected_scope == 'syntax_only'
                            for c in cases))
        for c in cases:
            self.assertEqual(c.setup_sqls, ['BEGIN;'])
            self.assertEqual(c.teardown_sqls, ['ROLLBACK;'])
            self.assertFalse(any('DROP' in x or 'CASCADE' in x or 'DROP OWNED' in x
                                 for x in c.setup_sqls + c.teardown_sqls))
        gates = {g['key']: g for g in cases[0].environment_requirements}
        self.assertEqual(gates['internal_text_search_test']['allowed_values'], ['true'])
        self.assertIn(provider_fact, gates['internal_text_search_test']['fact_refs'])
        self.assertEqual(gates['comment_authority']['allowed_values'], ['sysadmin'])
        self.assertIn('comment_fact_authority', gates['comment_authority']['fact_refs'])
        graph = self.r.factor_dependency_graph()
        order = self.r.factor_topological_order()
        self.assertIn(provider, graph['comment'])
        self.assertLess(order.index(provider), order.index('comment'))
        features = {f.id: f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        feature = features[feature_id]
        self.assertEqual((feature.status, feature.coverage_mode), ('covered', 'any'))
        audit = FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        return cases


class CommentTextSearchParserTests(CommentTextSearchBuiltinTests):
    def test_builtin_parser_target_crosses_four_text_values(self):
        cases = self.check_builtin_target(
            'manifest_comment_ts_parser',
            'TEXT SEARCH PARSER pg_catalog.default',
            'comment_feature_object_text_search_parser',
            'create_text_search_configuration',
            'create_text_search_configuration::create_text_search_configuration_fact_internal',
        )
        fixture = self.r.fixtures['fixture_comment_ts_parser']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('pg_catalog.default', '不由本case创建', '事务', 'ROLLBACK'):
            self.assertIn(phrase, fixture.execution.note)
        scenario = self.r.scenarios['scenario_comment_ts_parser']
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual(len(scenario.steps), 1)
        self.assertEqual(len(scenario.oracles), 1)
        self.assertTrue(all(o['kind'] == 'manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration', scenario.execution_requirements)


class CommentTextSearchTemplateTests(CommentTextSearchBuiltinTests):
    def test_builtin_template_target_crosses_four_text_values(self):
        cases = self.check_builtin_target(
            'manifest_comment_ts_template',
            'TEXT SEARCH TEMPLATE pg_catalog.simple',
            'comment_feature_object_text_search_template',
            'create_text_search_dictionary',
            'create_text_search_dictionary::create_text_search_dictionary_fact_internal',
        )
        fixture = self.r.fixtures['fixture_comment_ts_template']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('pg_catalog.simple', '不由本case创建', '事务', 'ROLLBACK'):
            self.assertIn(phrase, fixture.execution.note)
        scenario = self.r.scenarios['scenario_comment_ts_template']
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual(len(scenario.steps), 1)
        self.assertEqual(len(scenario.oracles), 1)
        self.assertTrue(all(o['kind'] == 'manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration', scenario.execution_requirements)


if __name__ == '__main__':
    unittest.main()
