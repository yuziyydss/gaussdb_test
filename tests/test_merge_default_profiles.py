"""PDF MERGE DEFAULT uses real target DDL and explicit, unexecuted row oracles."""
import hashlib
from pathlib import Path
import unittest

from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from core.finite_sql_contract import inspect_write


class MergeDefaultProfilesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root=Path(__file__).resolve().parents[1]
        cls.registry=FactorPackageRegistry(cls.root/'specs');cls.registry.load_all()

    def new_cases(self):
        key='manifest_merge_constant_defaults'
        self.assertTrue(key in self.registry.manifests,key)
        return FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[key])

    def test_three_explicit_profiles_generate_checked_distinct_cases(self):
        cases,report=self.new_cases()
        self.assertEqual(len(cases),3)
        self.assertEqual(len({c.case_id for c in cases}),3)
        self.assertEqual(len({c.sql for c in cases}),3)
        self.assertTrue(report.pairwise_complete)
        for c in cases:
            self.assertEqual(c.expected,'success')
            result=inspect_write(c.sql,c.setup_sqls)
            self.assertEqual(result['status'],'checked',result)
            self.assertIn('shared_ordinary_defaults',result['checks'])
        self.assertTrue(any('SET name = DEFAULT' in c.sql for c in cases))
        self.assertTrue(any('SET (name, category) = (DEFAULT, DEFAULT)' in c.sql for c in cases))
        self.assertTrue(any('INSERT DEFAULT VALUES' in c.sql for c in cases))

    def test_actual_fixture_defaults_seed_and_owned_cleanup(self):
        cases,_=self.new_cases()
        for c in cases:
            self.assertEqual(len(c.setup_sqls),4)
            ddl=next(s for s in c.setup_sqls if s.startswith('CREATE TABLE g_merge_default_target'))
            self.assertIn("name VARCHAR(64) DEFAULT 'fallback-name'",ddl)
            self.assertIn('category VARCHAR(64)',ddl)
            self.assertNotIn('category VARCHAR(64) DEFAULT',ddl)
            self.assertTrue(any("(1, 'old-one', 'old'), (3, 'keep-three', 'keep')" in s for s in c.setup_sqls))
            self.assertTrue(any("(1, 'new-one', 'updated'), (2, 'new-two', 'inserted')" in s for s in c.setup_sqls))
            self.assertEqual(c.teardown_sqls,['DROP TABLE g_merge_default_source RESTRICT PURGE;',
                                            'DROP TABLE g_merge_default_target RESTRICT PURGE;'])
            self.assertFalse(any(s.startswith('DROP') for s in c.setup_sqls))
        fixture=self.registry.fixtures['fixture_merge_constant_defaults']
        self.assertIn('ownership',fixture.execution.note)
        self.assertEqual(len(fixture.provides.tables),2)

    def test_separate_planned_scenarios_have_exact_seed_based_oracles(self):
        cases,_=self.new_cases()
        sql={c.params['action_profile']:c.sql for c in cases}
        expected={
            'scalar': [[1,'fallback-name','matched'],[2,'fallback-name',None],[3,'keep-three','keep']],
            'tuple_omitted': [[1,'fallback-name',None],[2,'fallback-name',None],[3,'keep-three','keep']],
            'row': [[1,'old-one','old'],[3,'keep-three','keep'],[None,'fallback-name',None]],
        }
        profile={'scalar':'merge_action_scalar_defaults','tuple_omitted':'merge_action_tuple_omitted_defaults',
                 'row':'merge_action_default_values'}
        for name,rows in expected.items():
            s=self.registry.scenarios['scenario_merge_defaults_'+name]
            self.assertEqual(s.status,'planned')
            self.assertEqual(s.fixture_refs,['fixture_merge_constant_defaults'])
            self.assertEqual(len(s.steps),1)
            self.assertEqual(s.steps[0]['sql'],sql[profile[name]])
            self.assertEqual(s.oracles[0]['expected'],rows)
            self.assertEqual(s.oracles[0]['kind'],'result_set')
            self.assertIn('ORDER BY id NULLS LAST',s.oracles[0]['sql'])
            self.assertIn('database_authorization',s.execution_requirements)
            self.assertIn('fresh_fixture_per_scenario',s.execution_requirements)

    def test_sources_dependencies_and_unbounded_domains_stay_honest(self):
        self.new_cases()
        graph=self.registry.factor_dependency_graph()
        self.assertIn('create_table',graph['merge_into'])
        self.assertIn('drop_table',graph['merge_into'])
        ledger=self.registry.source_ledgers['source_ledger_merge_into']
        for source in ledger.supplemental_sources:
            path=self.root/'work/doc2spec/full_general_corpus'/source.catalog_chapter_ref.source_relpath
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(),source.catalog_chapter_ref.chapter_sha256)
        matrix=self.registry.matrices['matrix_merge_action_profiles']
        features={f.id:f for f in matrix.documented_features}
        self.assertEqual(features['merge_feature_assignment_expression_domain'].status,'needs_profile')
        self.assertEqual(features['merge_feature_insert_value_expression_domain'].status,'needs_profile')


if __name__=='__main__': unittest.main()
