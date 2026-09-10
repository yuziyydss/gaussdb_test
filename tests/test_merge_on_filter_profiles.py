"""A negative source key distinguishes ON filtering from source-row removal."""
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.finite_sql_contract import inspect_write


class MergeOnFilterProfilesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        mid='manifest_merge_on_filter_control'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_control_and_filtered_on_use_same_actions_and_new_owned_fixture(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),2);self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.params['on_condition'] for c in cases},{'merge_on_id_equal','merge_on_id_equal_positive'})
        for c in cases:
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
            self.assertEqual(inspect_write(c.sql,c.setup_sqls)['status'],'checked')
            self.assertEqual(len(c.setup_sqls),4)
            self.assertFalse(any(s.startswith('DROP') for s in c.setup_sqls))
            self.assertTrue(any("(-1, 'old-negative', 'old')" in s for s in c.setup_sqls))
            self.assertTrue(any("(-1, 'new-negative', 'incoming')" in s for s in c.setup_sqls))
            self.assertFalse(any('PRIMARY KEY' in s or 'UNIQUE' in s for s in c.setup_sqls))
            self.assertEqual(c.teardown_sqls,['DROP TABLE g_merge_on_source RESTRICT PURGE;',
                                            'DROP TABLE g_merge_on_target RESTRICT PURGE;'])

    def test_planned_result_does_not_drop_negative_source_row(self):
        sql={c.params['on_condition']:c.sql for c in self.cases()[0]}
        common=[[1,'new-one','incoming'],[2,'new-two','incoming'],[3,'keep-three','keep']]
        for suffix,condition,rows in [('control','merge_on_id_equal',[[-1,'new-negative','incoming']]+common),
                                     ('filtered','merge_on_id_equal_positive',
                                      [[-1,'new-negative','incoming'],[-1,'old-negative','old']]+common)]:
            s=self.r.scenarios['scenario_merge_on_'+suffix]
            self.assertEqual(s.status,'planned')
            self.assertEqual(s.steps,[{'id':'merge','sql':sql[condition]}])
            self.assertEqual(s.oracles[0]['expected'],rows)
            self.assertEqual(s.oracles[0]['step_id'],'merge')
            self.assertIn('ORDER BY id, name',s.oracles[0]['sql'])
            self.assertIn('fresh_fixture_per_scenario',s.execution_requirements)
            self.assertIn('target_oracle_calibration',s.execution_requirements)
            self.assertIn('database_authorization',s.execution_requirements)

    def test_both_profiles_share_one_owned_fixture_and_existing_source_rules(self):
        self.cases()
        for matrix,pid in [('matrix_merge_target_profiles','merge_target_on_filter'),
                           ('matrix_merge_source_profiles','merge_source_on_filter')]:
            p=next(p for p in self.r.matrices[matrix].profiles if p.id==pid)
            self.assertEqual(p.fixture_refs,['fixture_merge_on_filter'])
        f=self.r.fixtures['fixture_merge_on_filter']
        self.assertIn('ownership',f.execution.note)
        self.assertEqual(len(f.provides.tables),2)


if __name__=='__main__':unittest.main()
