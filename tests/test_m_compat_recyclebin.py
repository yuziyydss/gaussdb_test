import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_06 import BUILDERS

ROOT=Path(__file__).resolve().parents[1]


class MRecyclebinTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):
        return [c for mid in self.r.factors['m_'+name].manifest_refs for c in self.g.generate_cases_for_manifest(self.r.manifests[mid])]

    def test_purge_real_dropped_table_and_no_global_cleanup(self):
        c=self.cases('purge')[0]
        self.assertEqual(c.sql,'PURGE TABLE m_purge_namespace.source;')
        self.assertEqual(c.setup_sqls[-1],'DROP TABLE m_purge_namespace.source;')
        self.assertTrue(any(s.startswith('INSERT INTO ') for s in c.setup_sqls))
        self.assertEqual(c.teardown_sqls,['DROP SCHEMA m_purge_namespace;'])
        self.assertEqual(self.r.fixtures['fixture_m_purge_dropped_table'].provides.tables,[])

    def test_flashback_has_correct_deleted_or_truncated_state(self):
        for c in self.cases('timecapsule_table'):
            op='TRUNCATE' if 'BEFORE TRUNCATE' in c.sql else 'DROP'
            self.assertEqual(c.setup_sqls[-1],op+' TABLE m_timecapsule_namespace.source;')
            self.assertTrue(any('VALUES (1,10),(2,20)' in s for s in c.setup_sqls))
            self.assertFalse(any('SET ' in s or 'VACUUM ' in s for s in c.setup_sqls))
            self.assertNotIn('TO CSN',c.sql);self.assertNotIn('TO TIMESTAMP',c.sql)

    def test_rename_truncate_is_target_negative_only(self):
        cases=self.cases('timecapsule_table');self.assertEqual(len(cases),4)
        bad=[c for c in cases if 'BEFORE TRUNCATE RENAME' in c.sql]
        self.assertEqual(len(bad),1);self.assertEqual(bad[0].expected,'error')
        self.assertEqual(bad[0].expected_error_category,'rename_only_drop')
        self.assertEqual(bad[0].expected_oracle_status,'needs_verification')
        self.assertEqual(sum(c.expected=='success' for c in cases),3)

    def test_exact_cleanup_and_environment_gates(self):
        for name in ['purge','timecapsule_table']:
            for c in self.cases(name):
                self.assertTrue(any(e['key']=='enable_recyclebin' and e['allowed_values']==['on'] for e in c.environment_requirements))
                self.assertFalse(any('RECYCLEBIN;' in s or 'CASCADE' in s for s in c.teardown_sqls))
        for c in self.cases('timecapsule_table'):
            self.assertEqual(c.teardown_sqls,['DROP TABLE IF EXISTS m_timecapsule_namespace.source PURGE;','DROP TABLE IF EXISTS m_timecapsule_namespace.restored PURGE;','DROP SCHEMA m_timecapsule_namespace;'])

    def test_exact_reconstruction(self):
        for key in ['purge','timecapsule_table']:
            p=BUILDERS[key]()
            for name,obj in p.finish().items():
                self.assertEqual((ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
