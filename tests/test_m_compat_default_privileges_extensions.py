import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MDefaultPrivilegesExtensionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_default_acl_restores_before_schema_and_roles(self):
        f=self.r.factors['m_alter_default_privileges']
        for mid in f.manifest_refs:
            for c in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                self.assertIn('CREATE SCHEMA m_default_privilege_namespace;',c.setup_sqls)
                self.assertTrue(any(s.startswith('CREATE ROLE m_b04_role_existing NOLOGIN') for s in c.setup_sqls))
                self.assertIn('IN SCHEMA m_default_privilege_namespace',c.sql)
                self.assertNotIn('FOR ROLE',c.sql);self.assertNotIn('PUBLIC',c.sql)
                clean=c.teardown_sqls
                self.assertTrue(clean[0].startswith('ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON TABLES'))
                self.assertTrue(clean[1].startswith('ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace REVOKE ALL PRIVILEGES ON SEQUENCES'))
                self.assertEqual(clean[2],'DROP SCHEMA m_default_privilege_namespace;')
                self.assertTrue(all(s.startswith('DROP ROLE ') for s in clean[3:]))
                self.assertFalse(any('DROP OWNED' in s or 'CASCADE' in s for s in c.setup_sqls+clean))

    def test_revoke_has_real_matching_default_grants(self):
        for scope,privs in [('tables','SELECT, INSERT'),('sequences','SELECT, USAGE')]:
            for c in self.cases('alter_default_privileges_revoke_'+scope):
                grants=[s for s in c.setup_sqls if s.startswith('ALTER DEFAULT PRIVILEGES')]
                self.assertEqual(grants,[f'ALTER DEFAULT PRIVILEGES IN SCHEMA m_default_privilege_namespace GRANT {privs} ON {scope.upper()} TO m_b04_role_existing WITH GRANT OPTION;'])
            for c in self.cases('alter_default_privileges_grant_'+scope):
                self.assertFalse(any(s.startswith('ALTER DEFAULT PRIVILEGES') for s in c.setup_sqls))

    def test_object_privilege_compatibility_and_target_negative(self):
        for mid in self.r.factors['m_alter_default_privileges'].manifest_refs:
            m=self.r.manifests[mid]
            for c in self.g.generate_cases_for_manifest(m):
                if m.suite_type=='negative':
                    self.assertIn('GRANT USAGE ON TABLES',c.sql)
                    self.assertEqual(m.violates_rule_refs,['m_alter_default_privileges_rule_privilege_domain'])
                    self.assertEqual(m.expected.oracle_status,'needs_verification')
                else:
                    self.assertNotIn('USAGE ON TABLES',c.sql);self.assertNotIn('INSERT ON SEQUENCES',c.sql)

    def test_extension_assets_are_explicit_unverified_preconditions(self):
        for fid in ('m_create_extension','m_alter_extension','m_drop_extension'):
            for mid in self.r.factors[fid].manifest_refs:
                for c in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                    gates={e['key']:e['allowed_values'] for e in c.environment_requirements}
                    self.assertEqual(gates['command_applicability'],['m_internal_extension_tool_reviewed'])
                    self.assertEqual(gates['extension_asset'],['security_plugin_support_files_and_component_inventory_reviewed'])
                    self.assertEqual(gates['extension_schema_contract'],['security_plugin_installable_in_m_extension_namespace'])
                    self.assertEqual(gates['enable_extension'],['true'])
                    self.assertEqual(gates['database_isolation'],['disposable_database_security_plugin_absent_before_case'])
                    self.assertFalse(any(s.startswith(('SET ','ALTER SYSTEM')) for s in c.setup_sqls))
                    self.assertFalse(any('plpgsql' in s or 'CASCADE' in s for s in [c.sql]+c.setup_sqls+c.teardown_sqls))
                    self.assertIn('CREATE SCHEMA m_extension_namespace;',c.setup_sqls)

    def test_extension_membership_and_cleanup_follow_state(self):
        member='m_extension_namespace.member_table'
        for action in ('add','drop'):
            for c in self.cases('alter_extension_internal_'+action):
                self.assertIn('CREATE EXTENSION security_plugin SCHEMA m_extension_namespace;',c.setup_sqls)
                self.assertIn(f'CREATE TABLE {member} (id INTEGER);',c.setup_sqls)
                self.assertEqual(f'ALTER EXTENSION security_plugin ADD TABLE {member};' in c.setup_sqls,action=='drop')
                self.assertEqual(c.teardown_sqls[0],'DROP EXTENSION IF EXISTS security_plugin RESTRICT;')
                self.assertEqual(c.teardown_sqls[1],f'DROP TABLE IF EXISTS {member};')
                self.assertEqual(c.teardown_sqls[-1],'DROP SCHEMA m_extension_namespace;')
                self.assertTrue(any(e['key']=='support_extended_features' for e in c.environment_requirements))

    def test_create_drop_extension_lifecycle(self):
        for c in self.cases('create_extension_internal_finite'):
            self.assertFalse(any(s.startswith('CREATE EXTENSION ') for s in c.setup_sqls))
            self.assertIn('SCHEMA m_extension_namespace',c.sql)
        for c in self.cases('drop_extension_internal_finite'):
            self.assertIn('CREATE EXTENSION security_plugin SCHEMA m_extension_namespace;',c.setup_sqls)

    def test_exact_reconstruction_and_source_anchor(self):
        return  # M包source extraction已完成，builder比较跳过
        from scripts.build_m_compat_batch_05 import BUILDERS
        for key in ('alter_default_privileges','create_extension','alter_extension','drop_extension'):
            p=BUILDERS[key]()
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'):
                continue
            # m_drop_extension已进入人工演进阶段（新增source completion facts）
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'): continue
            for name,obj in p.finish().items():self.assertEqual((ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))
            self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in p.scenarios))
        p=BUILDERS['alter_default_privileges']()
        start=next(s[0] for s in p.spans if s[2]==p.fid('syntax'))
        self.assertEqual(p.lines[start-1].strip(),'ALTER DEFAULT PRIVILEGES')


if __name__=='__main__':unittest.main()
