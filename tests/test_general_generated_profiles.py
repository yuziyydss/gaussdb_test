"""Actual general-mode generated-column consumers and unexecuted target oracles."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.finite_sql_contract import inspect_write


class GeneralGeneratedProfilesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.registry.load_all()

    def cases(self, name):
        mid='manifest_'+name
        self.assertTrue(mid in self.registry.manifests, mid)
        return FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[mid])

    def test_four_positive_candidates_have_actual_input_provenance(self):
        total=0
        for name,expected_count in [('insert_generated_values',2),('insert_generated_query',1),('update_generated_default',1)]:
            cases,report=self.cases(name)
            self.assertEqual(len(cases),expected_count)
            self.assertTrue(report.pairwise_complete)
            for c in cases:
                result=inspect_write(c.sql,c.setup_sqls)
                self.assertEqual(result['status'],'checked',result)
                self.assertIn('stored_generated_integer_sum',result['checks'])
                self.assertEqual(c.expected_scope,'syntax_only')
                self.assertNotIn('RETURNING',c.sql)
                self.assertTrue(all('CASCADE' not in s for s in c.teardown_sqls))
                self.assertFalse(any(s.startswith('DROP') for s in c.setup_sqls))
                total+=1
        self.assertEqual(total,4)

    def test_four_negatives_keep_target_identity_and_unverified_runtime_oracle(self):
        for name in ('insert_generated_negative','update_generated_negative'):
            cases,_=self.cases(name)
            self.assertEqual(len(cases),2)
            for c in cases:
                result=inspect_write(c.sql,c.setup_sqls)
                self.assertEqual(result['status'],'rejected',result)
                self.assertEqual(result['issues'][0]['code'],'generated_column_write')
                self.assertEqual(c.expected,'error')
                self.assertEqual(c.expected_error_category,'generated_write')
                self.assertEqual(c.expected_sqlstates,[])

    def test_every_candidate_has_its_own_planned_target_or_row_oracle(self):
        names=('insert_generated_values','insert_generated_query','update_generated_default',
               'insert_generated_negative','update_generated_negative')
        cases=[c for name in names for c in self.cases(name)[0]]
        scenarios=[s for s in self.registry.scenarios.values()
                   if s.id.startswith(('scenario_insert_finite_generated_','scenario_update_finite_generated_'))]
        self.assertEqual(len(scenarios),8)
        self.assertEqual({s.steps[0]['sql'] for s in scenarios},{c.sql for c in cases})
        for s in scenarios:
            self.assertEqual(s.status,'planned')
            self.assertIn('fresh_fixture_per_scenario',s.execution_requirements)
            self.assertIn('database_authorization',s.execution_requirements)
            if s.steps[0].get('expected')=='error':
                self.assertEqual(s.oracles[0]['kind'],'target_error')
                self.assertEqual(s.oracles[0]['expected']['error_category'],'generated_write')
                self.assertEqual(s.oracles[0]['calibration_status'],'needs_verification')
            else:
                self.assertEqual(s.oracles[0]['kind'],'result_set')
                expected=[[2,9,11],[3,8,11]] if s.factor_ref=='update' else [[2,9,11]]
                self.assertEqual(s.oracles[0]['expected'],expected)

    def test_real_cross_chapter_generation_and_cleanup_dependencies(self):
        self.cases('insert_generated_values')
        graph=self.registry.factor_dependency_graph()
        for fid in ('insert','update'):
            self.assertIn('create_table',graph[fid])
            self.assertIn('drop_table',graph[fid])
        fact=next(f for f in self.registry.factors['update'].facts if f.id=='update_open_generated_fixture')
        self.assertEqual(fact.status,'needs_verification')
        self.assertIn('STORED',fact.statement)


if __name__=='__main__': unittest.main()
