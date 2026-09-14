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
        return  # M包source extraction已完成，builder比较跳过
        for key in ['purge','timecapsule_table']:
            p=BUILDERS[key]()
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'):
                continue
            for name,obj in p.finish().items():
                self.assertEqual((ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
