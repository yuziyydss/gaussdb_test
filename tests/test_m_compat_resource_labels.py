import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MResourceLabelTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_actual_resource_paths_and_scoped_cleanup(self):
        for name in ('create_resource_label_finite','alter_resource_label_add','alter_resource_label_remove','drop_resource_label_finite'):
            for c in self.cases(name):
                self.assertIn('CREATE SCHEMA m_label_namespace;',c.setup_sqls)
                self.assertIn('CREATE TABLE m_label_namespace.source (id INTEGER, qty INTEGER);',c.setup_sqls)
                self.assertIn('CREATE VIEW m_label_namespace.source_view AS SELECT id, qty FROM m_label_namespace.source;',c.setup_sqls)
                clean=c.teardown_sqls
                self.assertEqual(clean[-3:],['DROP VIEW m_label_namespace.source_view;','DROP TABLE m_label_namespace.source;','DROP SCHEMA m_label_namespace;'])
                self.assertTrue(all(s.startswith('DROP RESOURCE LABEL IF EXISTS ') for s in clean[:-3]))
                self.assertNotIn('FUNCTION',c.sql)
                self.assertTrue(any(e['key']=='actor_authority' and e['allowed_values']==['sysadmin'] for e in c.environment_requirements))

    def test_creation_owns_only_its_target_cleanup(self):
        for c in self.cases('create_resource_label_finite'):
            self.assertEqual(c.teardown_sqls[0],'DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;')
        for name in ('alter_resource_label_add','alter_resource_label_remove','drop_resource_label_finite'):
            for c in self.cases(name):self.assertNotIn('DROP RESOURCE LABEL IF EXISTS m_create_resource_label_new;',c.teardown_sqls)

    def test_add_remove_initial_membership_and_nonempty_remainder(self):
        for action in ('add','remove'):
            for c in self.cases('alter_resource_label_'+action):
                setup=next(s for s in c.setup_sqls if s.startswith('CREATE RESOURCE LABEL m_alter_resource_label_existing'))
                self.assertIn('COLUMN (m_label_namespace.source.id)',setup)
                resource=c.sql.split(' '+action.upper()+' ',1)[1].removesuffix(';')
                if action=='add':self.assertNotIn(resource,setup)
                else:self.assertIn(resource,setup)

    def test_drop_list_targets_created_in_setup(self):
        cases=self.cases('drop_resource_label_finite');self.assertEqual(len(cases),4)
        for c in cases:
            self.assertTrue(any(s.startswith('CREATE RESOURCE LABEL m_drop_resource_label_one ') for s in c.setup_sqls))
            if 'm_drop_resource_label_two' in c.sql:self.assertTrue(any(s.startswith('CREATE RESOURCE LABEL m_drop_resource_label_two ') for s in c.setup_sqls))

    def test_exact_builder_reconstruction(self):
        from scripts.build_m_compat_batch_05 import BUILDERS
        for key in ('create_resource_label','alter_resource_label','drop_resource_label'):
            p=BUILDERS[key]()
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'):
                continue
            for name,obj in p.finish().items():
                self.assertEqual((ROOT/'specs/ddl'/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
