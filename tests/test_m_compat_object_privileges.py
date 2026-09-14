import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MObjectPrivilegeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_real_roles_schema_table_and_usage(self):
        for cmd in ('grant','revoke'):
            for scope in ('table','columns'):
                for c in self.cases(cmd+'_'+scope):
                    setup=c.setup_sqls
                    self.assertIn('CREATE ROLE m_b04_role_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;',setup)
                    self.assertIn('CREATE SCHEMA m_grant_namespace;',setup)
                    self.assertIn('CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);',setup)
                    self.assertIn('GRANT USAGE ON SCHEMA m_grant_namespace TO m_b04_role_existing, m_b04_role_second;',setup)
                    self.assertLess(setup.index('CREATE SCHEMA m_grant_namespace;'),setup.index('CREATE TABLE m_grant_namespace.source (id INTEGER, qty INTEGER);'))

    def test_revoke_has_matching_non_masking_initial_grants(self):
        for scope,privs in [('table','SELECT, UPDATE'),('columns','SELECT (id, qty), UPDATE (id, qty)')]:
            for c in self.cases('revoke_'+scope):
                grants=[s for s in c.setup_sqls if s.startswith('GRANT ') and ' ON TABLE ' in s]
                self.assertEqual(grants,[f'GRANT {privs} ON TABLE m_grant_namespace.source TO m_b04_role_existing, m_b04_role_second WITH GRANT OPTION;'])
                self.assertEqual(c.teardown_sqls[0],f'REVOKE {privs} ON TABLE m_grant_namespace.source FROM m_b04_role_existing, m_b04_role_second RESTRICT;')
                self.assertTrue(any(e['key']=='grantor_identity' and e['allowed_values']==['same_setup_and_target_session'] for e in c.environment_requirements))

    def test_cleanup_topology_removes_acl_objects_before_roles(self):
        for cmd in ('grant','revoke'):
            for scope in ('table','columns'):
                for c in self.cases(cmd+'_'+scope):
                    clean=c.teardown_sqls
                    self.assertLess(clean.index('DROP TABLE m_grant_namespace.source;'),clean.index('DROP SCHEMA m_grant_namespace;'))
                    self.assertLess(clean.index('DROP SCHEMA m_grant_namespace;'),clean.index('DROP ROLE IF EXISTS m_b04_role_existing;'))

    def test_only_scoped_object_permissions_are_generated(self):
        for cmd in ('grant','revoke'):
            for scope in ('table','columns'):
                for c in self.cases(cmd+'_'+scope):
                    self.assertIn('m_grant_namespace.source',c.sql)
                    for sql in [c.sql]+c.setup_sqls+c.teardown_sqls:
                        self.assertNotRegex(sql,r'\b(?:PUBLIC|ANY|CASCADE|ALL PRIVILEGES|SYSADMIN)\b')
                        self.assertNotIn('DROP OWNED',sql)
                    if cmd=='grant':self.assertNotIn('GRANT OPTION FOR',c.sql)
                    else:self.assertNotIn('WITH GRANT OPTION',c.sql)

    def test_effective_privilege_oracles_not_marked_executed(self):
        for fid in ('m_grant','m_revoke'):
            self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in self.r.factors[fid].scenario_refs))
            for mid in self.r.factors[fid].manifest_refs:
                self.assertEqual(self.r.manifests[mid].expected.scope,'syntax_only')

    def test_exact_builder_reconstruction(self):
        # m_grant已进入人工演进阶段（新增source completion facts与
        # scenario），不再回退到batch_04一次性builder的输出。
        from scripts.build_m_compat_batch_04 import BUILDERS,rendered_files
        for key in ('grant','revoke'):
            p=BUILDERS[key]()
            if p.id in ('m_drop_audit_policy','m_drop_database','m_drop_owned','m_drop_schema','m_drop_sequence',
'm_rename_table','m_rollback_to_savepoint','m_deallocate','m_do','m_drop_user',
'm_drop_view','m_drop_role','m_grant','m_create_function','m_analyze','m_copy',
'm_alter_table','m_create_table','m_create_table_partition','m_checkpoint','m_drop_prepare',
'm_autohint_purge','m_prepare','m_reset','m_drop_extension','m_drop_group',
'm_rollback','m_autohint','m_comment','m_drop_table','m_use',
'm_alter_resource_label','m_alter_schema','m_create_database','m_set_role','m_alter_database'):
                continue
            if p.id == 'm_grant':
                continue
            for name,obj in rendered_files(p).items():
                self.assertEqual((ROOT/'specs/dcl'/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
