"""One dependency-owned seed extension tests both action-WHERE branches."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.finite_sql_contract import inspect_write


class MergeActionFilterProfilesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        mid='manifest_merge_action_filter_control'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_two_cases_only_differ_in_action_where_not_on_or_other_assignments(self):
        cases,report=self.cases();self.assertEqual(len(cases),2);self.assertTrue(report.pairwise_complete)
        sql={c.params['action_profile']:c.sql for c in cases}
        self.assertEqual(sql['merge_action_with_where'].replace(' WHERE src.id > 0',''),
                         sql['merge_action_name_only_both'])
        for c in cases:
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
            self.assertEqual(inspect_write(c.sql,c.setup_sqls)['status'],'checked')
            self.assertEqual(len(c.setup_sqls),5)
            self.assertEqual(c.setup_sqls[-1],"INSERT INTO g_merge_on_source (id, name, category) VALUES (-2, 'new-unmatched', 'incoming');")
            self.assertEqual(c.teardown_sqls,["DELETE FROM g_merge_on_source WHERE id = -2 AND name = 'new-unmatched' AND category = 'incoming';",
                                            'DROP TABLE g_merge_on_source RESTRICT PURGE;',
                                            'DROP TABLE g_merge_on_target RESTRICT PURGE;'])

    def test_wrapper_depends_on_actual_tables_without_owning_or_dropping_them_twice(self):
        self.cases();f=self.r.fixtures['fixture_merge_action_filter']
        self.assertEqual(f.requires_fixture_refs,['fixture_merge_on_filter'])
        self.assertEqual(f.provides.tables,[])
        self.assertEqual(f.execution.teardown_sqls,["DELETE FROM g_merge_on_source WHERE id = -2 AND name = 'new-unmatched' AND category = 'incoming';"])
        self.assertIn('独立',f.execution.note)

    def test_planned_rows_prove_both_negative_branches_not_just_command_success(self):
        sql={c.params['action_profile']:c.sql for c in self.cases()[0]}
        common=[[1,'new-one','old'],[2,'new-two','incoming'],[3,'keep-three','keep']]
        for suffix,profile,rows in [
            ('control','merge_action_name_only_both',[[-2,'new-unmatched','incoming'],[-1,'new-negative','old']]+common),
            ('filtered','merge_action_with_where',[[-1,'old-negative','old']]+common)]:
            s=self.r.scenarios['scenario_merge_action_'+suffix]
            self.assertEqual(s.status,'planned')
            self.assertEqual(s.steps,[{'id':'merge','sql':sql[profile]}])
            self.assertEqual(s.oracles[0]['expected'],rows)
            self.assertIn('fresh_fixture_per_scenario',s.execution_requirements)
            self.assertIn('database_authorization',s.execution_requirements)
            self.assertIn('target_oracle_calibration',s.execution_requirements)


if __name__=='__main__':unittest.main()
