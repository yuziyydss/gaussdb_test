"""Ordinary nullable ADD is a real general-B and M consumer, not profile decoration."""
import copy
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator,GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]
GENERAL='manifest_alter_table_add_position_fresh'
M='manifest_m_alter_table_add_position_fresh'

class ColumnAddConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,mid):
        self.assertTrue(mid in self.r.manifests,mid)
        cases,report=self.g.generate_with_report(self.r.manifests[mid]);self.assertTrue(report.pairwise_complete)
        return cases

    def test_real_candidates_and_targeted_cleanup(self):
        g=self.cases(GENERAL);m=self.cases(M)
        self.assertEqual({c.sql for c in g},{'ALTER TABLE t_at_add_position ADD COLUMN extra INTEGER FIRST;',
            'ALTER TABLE t_at_add_position ADD COLUMN extra INTEGER AFTER code;'})
        self.assertEqual({c.sql for c in m},{f'ALTER TABLE m_at_add_position ADD {column}extra INTEGER {position};'
            for column in ('','COLUMN ') for position in ('FIRST','AFTER id')})
        self.assertEqual((len(g),len(m)),(2,4))
        for cases,target in ((g,'t_at_add_position'),(m,'m_at_add_position')):
            for c in cases:
                self.assertEqual(len(c.setup_sqls),2)
                self.assertTrue(c.setup_sqls[0].startswith('CREATE TABLE '+target+' ('))
                self.assertNotIn('DEFAULT',c.setup_sqls[0]);self.assertNotIn('NOT NULL',c.setup_sqls[0])
                self.assertEqual(c.teardown_sqls,[f'DROP TABLE {target};'])
                self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))

    def test_actual_ddl_cannot_lie_about_new_name_or_position(self):
        for mid,fid in ((GENERAL,'fixture_alter_table_add_position_fresh'),(M,'fixture_m_alter_table_add_position_fresh')):
            self.cases(mid);fx=self.r.fixtures[fid];before=fx.execution.setup_sqls
            try:
                for ddl in (before[0].replace('id INTEGER','extra INTEGER'),
                            before[0].replace('id INTEGER','id INTEGER PRIMARY KEY')):
                    fx.execution.setup_sqls=[ddl,*before[1:]]
                    with self.subTest(mid=mid,ddl=ddl),self.assertRaises(GenerationValidationError):
                        self.g.generate_with_report(self.r.manifests[mid])
            finally:fx.execution.setup_sqls=before

    def test_source_mode_scope_is_enforced_for_each_consumer(self):
        for mid,bad_modes in ((GENERAL,[['PG'],['M'],['B','PG']]),(M,[['B'],['PG'],['B','M']])):
            self.cases(mid)
            for modes in bad_modes:
                manifest=copy.deepcopy(self.r.manifests[mid])
                next(e for e in manifest.environment_requirements if e.key=='compatibility_mode').allowed_values=modes
                with self.subTest(mid=mid,modes=modes),self.assertRaises(GenerationValidationError):
                    self.g.generate_with_report(manifest)

    def test_null_backfill_oracles_remain_planned_and_old_domains_preserved(self):
        self.cases(GENERAL);self.cases(M)
        g=self.r.scenarios['scenario_alter_table_add_position_fresh']
        m=self.r.scenarios['scenario_m_alter_table_add_position_fresh']
        for s in (g,m):self.assertEqual(s.status,'planned')
        self.assertEqual([o['expected'] for o in g.oracles if o.get('kind')=='result_set'],[
            [[None,1,'alpha','one'],[None,2,'beta','two']],[[1,'alpha',None,'one'],[2,'beta',None,'two']]])
        self.assertEqual([o['expected'] for o in m.oracles if o.get('kind')=='result_set'],[
            [[None,1,10,100],[None,2,20,200]],[[1,None,10,100],[2,None,20,200]]])
        values=self.r.resolve_dimension_values('alter_table')
        self.assertEqual(values['action_profile']['at_action_first_b'].validity,'conditional')
        old=self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_alter_table_add'])
        self.assertEqual(len(old),6);self.assertTrue(all('DEFAULT 7' in c.sql for c in old))

if __name__=='__main__':unittest.main()
