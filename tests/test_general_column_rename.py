"""RENAME and B CHANGE consume one real-DDL column identity contract."""
import copy
from pathlib import Path
import unittest
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError
from core.factor_package_model import FactorPackageRegistry
from core.factor_coverage_auditor import FactorCoverageAuditor

RENAME='manifest_alter_table_rename_fresh'
CHANGE='manifest_alter_table_change_b_fresh'
FIXTURE='fixture_alter_table_rename_fresh'


class GeneralColumnRenameTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,mid):
        self.assertTrue(mid in self.r.manifests,mid)
        cases,report=self.g.generate_with_report(self.r.manifests[mid])
        self.assertTrue(report.pairwise_complete)
        return cases

    def test_actual_candidates_and_fresh_fixture(self):
        cases=self.cases(RENAME)+self.cases(CHANGE)
        self.assertEqual({c.sql for c in cases},{
            'ALTER TABLE t_at_rename_fresh RENAME code TO code_new;',
            'ALTER TABLE t_at_rename_fresh RENAME COLUMN code TO code_new;',
            'ALTER TABLE t_at_rename_fresh CHANGE COLUMN code code_new VARCHAR(32);'})
        self.assertEqual(len(cases),3)
        for c in cases:
            self.assertEqual(c.setup_sqls,['CREATE TABLE t_at_rename_fresh (id INTEGER,code VARCHAR(32),note VARCHAR(64));',
                "INSERT INTO t_at_rename_fresh VALUES (1,'alpha','one'),(2,'beta','two');"])
            self.assertEqual(c.teardown_sqls,['DROP TABLE t_at_rename_fresh;'])
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))

    def test_generator_checks_actual_ddl_not_only_provides(self):
        self.cases(RENAME)
        fixture=self.r.fixtures[FIXTURE];original=fixture.execution.setup_sqls
        try:
            for ddl in (original[0].replace('note VARCHAR(64)','code_new VARCHAR(64)'),
                        original[0].replace('code VARCHAR(32)','other VARCHAR(32)'),
                        original[0].replace('code VARCHAR(32)','code VARCHAR(32) NOT NULL')):
                fixture.execution.setup_sqls=[ddl,*original[1:]]
                for mid in (RENAME,CHANGE):
                    with self.subTest(ddl=ddl,mid=mid),self.assertRaises(GenerationValidationError):
                        self.g.generate_with_report(self.r.manifests[mid])
        finally:fixture.execution.setup_sqls=original

    def test_change_mode_and_target_mapping_are_not_decorative(self):
        self.cases(CHANGE)
        original=self.r.manifests[CHANGE]
        for modes in ([],['PG'],['M'],['B','PG']):
            m=copy.deepcopy(original)
            next(r for r in m.environment_requirements if r.key=='compatibility_mode').allowed_values=modes
            with self.subTest(modes=modes),self.assertRaises(GenerationValidationError):self.g.generate_with_report(m)
        resolved=self.r.resolve_dimension_values('alter_table')
        props=resolved['table_profile']['at_table_rename_fresh'].attributes
        self.assertEqual(props['table_profile.properties.column_rename_contract'],
            {'kind':'ordinary_same_definition','source_column':'code','target_column':'code_new'})

    def test_original_gaps_and_planned_oracles_remain_honest(self):
        self.cases(RENAME);self.cases(CHANGE)
        resolved=self.r.resolve_dimension_values('alter_table')
        self.assertEqual(resolved['action_profile']['at_action_change_b'].validity,'conditional')
        for suffix,mid in [('rename_fresh',RENAME),('change_b_fresh',CHANGE)]:
            s=self.r.scenarios['scenario_alter_table_'+suffix]
            self.assertEqual(s.status,'planned')
            self.assertTrue(any(x.get('manifest_ref')==mid for x in s.steps))
            self.assertTrue(any(o.get('step_id')=='rows' and o.get('expected')==[[1,'alpha','one'],[2,'beta','two']]
                                for o in s.oracles))
        audit=FactorCoverageAuditor(self.r).audit('alter_table')
        self.assertEqual(audit['facts']['wrong_consumer_type'],[])
        self.assertEqual(len(audit['facts']['unresolved_open_questions']),21)
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__=='__main__':unittest.main()
