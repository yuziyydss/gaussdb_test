"""COMMENT schema/constraint representatives use an owned, non-current namespace."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator


class CommentNamespaceConstraintTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        mid='manifest_comment_namespace_constraint'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_two_targets_cross_four_texts_with_real_constraint_name(self):
        cases,report=self.cases()
        targets=['SCHEMA g_comment_contract_ns',
                 'CONSTRAINT g_comment_pk ON g_comment_contract_ns.base_table']
        texts=["'factor note'","'测试注释'","'owner''s note'",'NULL']
        self.assertEqual({c.sql for c in cases},{f'COMMENT ON {t} IS {v};' for t in targets for v in texts})
        self.assertEqual(len(cases),8);self.assertTrue(report.pairwise_complete)
        self.assertTrue(all(c.expected_scope=='syntax_only' for c in cases))

    def test_only_fresh_assets_and_reverse_scoped_cleanup(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                'CREATE SCHEMA g_comment_contract_ns;',
                'CREATE TABLE g_comment_contract_ns.base_table (id INTEGER NOT NULL, CONSTRAINT g_comment_pk PRIMARY KEY (id));'])
            self.assertEqual(c.teardown_sqls,[
                'DROP TABLE g_comment_contract_ns.base_table PURGE;',
                'DROP SCHEMA g_comment_contract_ns RESTRICT;'])
            self.assertNotIn('CASCADE',' '.join(c.teardown_sqls))
            gates={g['key']:g for g in c.environment_requirements}
            self.assertEqual(gates['cleanup_namespace']['allowed_values'],['owned_fresh_non_current_schema'])
            self.assertIn('drop_schema::drop_schema_fact_current',gates['cleanup_namespace']['fact_refs'])

    def test_dependency_graph_contains_actual_creation_and_cleanup_providers(self):
        self.cases()
        graph=self.r.factor_dependency_graph()
        self.assertTrue({'create_schema','create_table','drop_table','drop_schema'}<=graph['comment'])
        order=self.r.factor_topological_order()
        self.assertTrue(all(order.index(p)<order.index('comment') for p in graph['comment']))

    def test_two_new_features_are_only_representative_and_old_candidates_survive(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        for name in ('schema','constraint'):
            self.assertEqual((features['comment_feature_object_'+name].status,
                              features['comment_feature_object_'+name].coverage_mode),('covered','representative'))
        self.assertEqual(features['comment_feature_object_database'].status,'needs_profile')
        self.assertEqual(len(self.g.generate_cases_for_manifest(self.r.manifests['manifest_comment_table_and_columns'])),12)
        self.assertEqual(len(self.g.generate_cases_for_manifest(self.r.manifests['manifest_comment_owned_relations'])),16)

    def test_metadata_oracle_and_cleanup_remain_separately_authorized(self):
        self.cases()
        s=self.r.scenarios['scenario_comment_namespace_constraint']
        self.assertEqual(s.status,'planned')
        self.assertIn('target_oracle_calibration',s.execution_requirements)
        self.assertIn('ownership_scoped_cleanup',s.execution_requirements)
        self.assertIn('drop_table::dt_fact_purge',s.fact_refs)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in s.oracles))


if __name__=='__main__':unittest.main()
