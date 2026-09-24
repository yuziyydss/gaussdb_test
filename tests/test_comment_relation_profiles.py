"""COMMENT ordinary relation representatives require real fresh objects, not labels."""
import hashlib
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor


class CommentRelationProfileTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = Path(__file__).resolve().parents[1]
        cls.registry = FactorPackageRegistry(cls.root/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def cases(self):
        mid = 'manifest_comment_owned_relations'
        self.assertTrue(mid in self.registry.manifests, mid)
        return self.generator.generate_with_report(self.registry.manifests[mid])

    def test_selected_values_supply_fixture_even_without_manifest_fixture_hint(self):
        self.cases()
        manifest = self.registry.manifests['manifest_comment_owned_relations'].model_copy(deep=True)
        manifest.fixture_refs = []
        cases, _ = self.generator.generate_with_report(manifest)
        self.assertEqual(len(cases), 16)
        self.assertTrue(all(len(c.setup_sqls) == 4 and len(c.teardown_sqls) == 3 for c in cases))

    def test_cross_chapter_sources_and_dependency_graph_are_consistent(self):
        self.cases()
        graph = self.registry.factor_dependency_graph()
        self.assertTrue({'create_view', 'create_index'} <= graph['comment'])
        for fid in ('create_view', 'create_index'):
            source = self.root/'intranet_corpus/general/ddl'/(fid+'.txt')
            factor = self.registry.factors[fid]
            self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(), factor.source.artifact_sha256)
            ledger = self.registry.source_ledgers[factor.source_ledger_ref]
            self.assertTrue(all(any(ref in unit.fact_refs for unit in ledger.units)
                                for ref in factor.exported_fact_refs))

    def test_all_four_targets_cross_all_four_text_values(self):
        cases, report = self.cases()
        targets = ('INDEX g_comment_rel_idx', 'VIEW g_comment_rel_view',
                   'COLUMN g_comment_rel_view.col_1', 'COLUMN g_comment_rel_view.col_2')
        texts = ("'factor note'", "'测试注释'", "'owner''s note'", 'NULL')
        self.assertEqual({c.sql for c in cases},
                         {f'COMMENT ON {target} IS {text};' for target in targets for text in texts})
        self.assertEqual(len(cases), 16)
        self.assertEqual(len({c.case_id for c in cases}), 16)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual((report.feasible_pair_count, report.covered_pair_count), (16, 16))
        self.assertTrue(all((c.expected, c.expected_scope) == ('success', 'syntax_only') for c in cases))

    def test_fixture_creates_actual_view_index_and_uses_owned_cleanup_order(self):
        cases, _ = self.cases()
        setup = ['CREATE TABLE g_comment_rel_base (col_1 INTEGER, col_2 INTEGER) WITH (storage_type=astore);',
                 'INSERT INTO g_comment_rel_base VALUES (1,2),(3,4);',
                 'CREATE INDEX g_comment_rel_idx ON g_comment_rel_base USING btree (col_1);',
                 'CREATE VIEW g_comment_rel_view AS SELECT col_1,col_2 FROM g_comment_rel_base;']
        teardown = ['DROP VIEW g_comment_rel_view;', 'DROP INDEX g_comment_rel_idx;',
                    'DROP TABLE g_comment_rel_base;']
        for case in cases:
            self.assertEqual(case.setup_sqls, setup)
            self.assertEqual(case.teardown_sqls, teardown)
        fixture = self.registry.fixtures['fixture_comment_owned_relations']
        self.assertEqual([t.name for t in fixture.provides.tables], ['g_comment_rel_base'])
        self.assertIn('ownership', fixture.execution.note)

    def test_table_and_column_feature_domain_is_finite_and_complete(self):
        self.cases()
        feature=next(f for f in self.registry.matrices['matrix_comment_coverage'].documented_features
                     if f.id=='comment_feature_table_and_column')
        self.assertEqual((feature.status,feature.coverage_mode),('covered','all'))
        self.assertEqual(feature.value_refs,['comment_target_table','comment_target_c1','comment_target_c2'])
        audit=FactorCoverageAuditor(self.registry).audit('comment')
        detail=audit['documented_features']['details']['comment_feature_table_and_column']
        self.assertTrue(detail['domain_complete'])
        self.assertEqual(detail['missing_refs'],[])
        self.assertNotIn('comment_feature_table_and_column',audit['documented_features']['coverage_gaps'])

    def test_old_table_cases_unchanged_and_domains_not_claimed_complete(self):
        self.cases()
        old, _ = self.generator.generate_with_report(self.registry.manifests['manifest_comment_table_and_columns'])
        self.assertEqual(len(old), 12)
        features = {f.id:f for f in self.registry.matrices['matrix_comment_coverage'].documented_features}
        for suffix in ('index', 'view'):
            f = features['comment_feature_object_'+suffix]
            self.assertEqual((f.status, f.coverage_mode), ('covered', 'any'))
        view_column = features['comment_feature_object_view_column']
        self.assertEqual((view_column.status,view_column.coverage_mode),('covered','all'))
        self.assertEqual(view_column.value_refs,
                         ['comment_target_view_column_fresh','comment_target_view_column_2_fresh'])
        function = features['comment_feature_object_function']
        self.assertEqual((function.status,function.coverage_mode),('covered','any'))
        self.assertEqual(function.value_refs,['comment_target_function_fresh'])
        database = features['comment_feature_object_database']
        self.assertEqual((database.status, database.coverage_mode), ('covered', 'any'))
        self.assertEqual(database.value_refs, ['comment_target_database_fresh'])
        role=features['comment_feature_object_role']
        self.assertEqual((role.status,role.coverage_mode),('covered','any'))
        foreign_table=features['comment_feature_object_foreign_table']
        self.assertEqual((foreign_table.status,foreign_table.coverage_mode),('covered','any'))
        server=features['comment_feature_object_server']
        self.assertEqual((server.status,server.coverage_mode),('covered','any'))
        self.assertEqual(features['comment_feature_other_objects'].status, 'covered')

    def test_lifecycle_is_planned_and_directory_oracle_requires_calibration(self):
        self.cases()
        scenario = self.registry.scenarios['scenario_comment_owned_relations']
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual(len(scenario.steps), 9)
        self.assertEqual(len(scenario.oracles), 9)
        steps = {step['id']:step['sql'] for step in scenario.steps}
        for oracle in scenario.oracles:
            self.assertEqual(oracle['kind'], 'manual_assertion')
            self.assertIn(oracle['after_step'], steps)
        self.assertIn('target_oracle_calibration', scenario.execution_requirements)
        self.assertIn('database_authorization', scenario.execution_requirements)

    def test_source_identity_and_cross_chapter_consumers_are_real(self):
        self.cases()
        factor = self.registry.factors['comment']
        source = self.root/'work/doc2spec/batches/batch_05/corpus/general/ddl/comment.txt'
        self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(), factor.source.artifact_sha256)
        values = {v.id:v for c in factor.dimensions['target'].classes for v in c.values}
        self.assertIn('create_index::ci_fact_main_grammar', values['comment_target_index_fresh'].fact_refs)
        self.assertIn('create_view::cv_fact_main_grammar', values['comment_target_view_fresh'].fact_refs)
        gates = {g.key:g for g in self.registry.manifests['manifest_comment_owned_relations'].environment_requirements}
        self.assertEqual(gates['comment_authority'].allowed_values, ['fixture_object_owner'])
        self.assertIn('comment_fact_authority', gates['comment_authority'].fact_refs)
        self.assertIn('create_index::ci_fact_permissions', gates['index_create_authority'].fact_refs)
        self.assertIn('create_view::cv_fact_create_any_table_permission', gates['view_create_authority'].fact_refs)


if __name__ == '__main__':
    unittest.main()
