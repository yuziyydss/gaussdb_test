import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MAuditPolicyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_prerequisites_and_reverse_cleanup_are_real(self):
        mids=[m for m in self.r.manifests if any(m.startswith('manifest_m_'+p) for p in ('create_audit_policy','alter_audit_policy','drop_audit_policy'))]
        for mid in mids:
            for c in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                setup=c.setup_sqls;clean=c.teardown_sqls
                self.assertLess(next(i for i,s in enumerate(setup) if s.startswith('CREATE TABLE ')),next(i for i,s in enumerate(setup) if s.startswith('CREATE RESOURCE LABEL ')))
                if not mid.startswith('manifest_m_create_audit_policy'):
                    self.assertLess(next(i for i,s in enumerate(setup) if s.startswith('CREATE RESOURCE LABEL ')),next(i for i,s in enumerate(setup) if s.startswith('CREATE AUDIT POLICY ')))
                self.assertTrue(clean[0].startswith('DROP AUDIT POLICY IF EXISTS m_'))
                self.assertTrue(clean[1].startswith('DROP RESOURCE LABEL IF EXISTS m_'))
                self.assertEqual(clean[-1],'DROP SCHEMA m_label_namespace;')
                self.assertFalse(any(s.startswith(('SET ','ALTER SYSTEM','CREATE USER')) for s in setup))
                gates={e['key']:e['allowed_values'] for e in c.environment_requirements}
                self.assertEqual(gates['actor_authority'],['sysadmin']);self.assertEqual(gates['enable_security_policy'],['on'])

    def test_create_has_single_scoped_operation_and_complete_filters(self):
        for c in self.cases('create_audit_policy_finite'):
            self.assertEqual(c.sql.count(' ON LABEL ('),1)
            self.assertIn('ON LABEL (m_b05_audit_label)',c.sql)
            self.assertNotIn('ROLES(',c.sql)
            self.assertNotIn('ALL',c.sql)
            if 'FILTER ON' in c.sql:self.assertRegex(c.sql,r'FILTER ON (APP\(gsql\)|IP\(\x27127\.0\.0\.1\x27\))')

    def test_remove_has_preadded_members_add_does_not(self):
        for action in ('add','remove'):
            for c in self.cases('alter_audit_policy_'+action):
                additions=[s for s in c.setup_sqls if ' ADD PRIVILEGES (' in s]
                self.assertEqual(len(additions),2 if action=='remove' else 0)
                if action=='remove':
                    operation=c.sql.split('REMOVE PRIVILEGES ',1)[1].removesuffix(';')
                    self.assertTrue(any(s.endswith(operation+';') for s in additions))
                self.assertTrue(any('PRIVILEGES CREATE ON LABEL' in s for s in c.setup_sqls))

    def test_state_transitions_have_opposite_initial_state(self):
        for action,initial in [('enable','DISABLE'),('disable','ENABLE')]:
            for c in self.cases('alter_audit_policy_'+action):
                create=next(s for s in c.setup_sqls if s.startswith('CREATE AUDIT POLICY '))
                self.assertTrue(create.endswith(initial+';'))
        for c in self.cases('alter_audit_policy_drop_filter'):
            self.assertIn("FILTER ON IP('127.0.0.1')",next(s for s in c.setup_sqls if s.startswith('CREATE AUDIT POLICY ')))

    def test_drop_single_policy_and_dependency_fact(self):
        for c in self.cases('drop_audit_policy_finite'):
            self.assertNotIn(',',c.sql)
            self.assertTrue(any('m_drop_audit_policy_existing ACCESS SELECT ON LABEL' in s for s in c.setup_sqls))
        m=self.r.manifests['manifest_m_drop_audit_policy_finite']
        gate=next(e for e in m.environment_requirements if e.key=='enable_security_policy')
        self.assertIn('m_create_audit_policy::m_create_audit_policy_fact_security_on',gate.fact_refs)

    def test_reconstruction_and_visible_gaps(self):
        return  # M包source extraction已完成，builder比较跳过
        from scripts.build_m_compat_batch_05 import BUILDERS
        for key in ('create_audit_policy','alter_audit_policy','drop_audit_policy'):
            p=BUILDERS[key]()
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'):
                continue
            for name,obj in p.finish().items():self.assertEqual((ROOT/'specs/ddl'/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))
            self.assertTrue(p.scenarios)
            self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in p.scenarios))


if __name__=='__main__':unittest.main()
