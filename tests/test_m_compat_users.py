import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MUserTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_create_user_cleans_implicit_schema_before_identity(self):
        for suffix in ('finite','connection_below'):
            for c in self.cases('create_user_'+suffix):
                self.assertTrue(c.sql.startswith('CREATE USER m_create_user_new '))
                self.assertIn('CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;',c.setup_sqls)
                self.assertEqual(c.teardown_sqls,['DROP SCHEMA IF EXISTS m_create_user_new;',
                    'DROP USER IF EXISTS m_create_user_new RESTRICT;','DROP ROLE m_create_user_parent;'])

    def test_alter_user_reuses_actual_user_not_role_only(self):
        for suffix in ('options','connection_below','set','reset'):
            for c in self.cases('alter_user_'+suffix):
                self.assertEqual(c.setup_sqls,['CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;'])
                self.assertEqual(c.teardown_sqls,['DROP SCHEMA IF EXISTS m_b04_user_existing;',
                    'DROP USER IF EXISTS m_b04_user_existing RESTRICT;'])
                self.assertNotIn(' RENAME ',c.sql)
                self.assertNotIn(' PASSWORD ',c.sql)
                self.assertNotIn(' IDENTIFIED BY ',c.sql)

    def test_drop_user_positive_precleans_schema_without_cascade(self):
        for c in self.cases('drop_user_dependency_free'):
            self.assertEqual(c.setup_sqls,[
                'CREATE USER m_drop_user_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;',
                'CREATE USER m_drop_user_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;',
                'DROP SCHEMA m_drop_user_one;','DROP SCHEMA m_drop_user_two;'])
            self.assertTrue(c.sql.startswith('DROP USER '))
            self.assertTrue(any(e['key']=='user_dependencies' and
                e['allowed_values']==['none_after_explicit_schema_cleanup'] for e in c.environment_requirements))
            self.assertTrue(any(e['key']=='identity_scope' for e in c.environment_requirements))

    def test_shared_limit_negatives_are_targeted(self):
        for fid,dim in [('m_create_user','connection_limit'),('m_alter_user','option')]:
            f=self.r.factors[fid];resolved=self.r.resolve_dimension_values(fid)
            combo={k:d.default_value_id for k,d in f.dimensions.items()};combo[dim]=fid+'_'+dim+'_below'
            pos=self.r.manifests['manifest_'+fid+('_finite' if fid=='m_create_user' else '_options')]
            neg=self.r.manifests['manifest_'+fid+'_connection_below']
            self.assertFalse(self.g._build_solver(f,pos,resolved).is_valid(combo)[0])
            self.assertTrue(self.g._build_solver(f,neg,resolved).is_valid(combo)[0])
            self.assertEqual(neg.expected.oracle_status,'needs_verification')
            self.assertEqual(neg.violates_rule_refs,[fid+'_rule_connection_range'])

    def test_no_login_password_or_destructive_cleanup(self):
        for fid in ('m_create_user','m_alter_user','m_drop_user'):
            for mid in self.r.factors[fid].manifest_refs:
                for c in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                    for sql in [c.sql]+c.setup_sqls+c.teardown_sqls:
                        self.assertNotRegex(sql,r"(?:PASSWORD|IDENTIFIED BY)\s+['\"]")
                        self.assertNotRegex(sql,r'\b(?:LOGIN|SYSADMIN|CREATEDB|CREATEROLE|PERSISTENCE|CASCADE)\b')
                        self.assertNotIn('DROP OWNED',sql)
                    self.assertTrue(any(e['key']=='actor_authority' for e in c.environment_requirements))
                    self.assertTrue(any(e['key']=='compatibility_mode' and e['allowed_values']==['M'] for e in c.environment_requirements))

    def test_source_gaps_are_preserved_and_builder_matches(self):
        from scripts.build_m_compat_batch_04 import BUILDERS,rendered_files
        for key in ('create_user','alter_user','drop_user'):
            p=BUILDERS[key]()
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'):
                continue
            for name,obj in rendered_files(p).items():
                self.assertEqual((ROOT/'specs/ddl'/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))
        f=self.r.factors['m_alter_user']
        self.assertTrue(any(x.id.endswith('_password_production') and x.status=='needs_verification' for x in f.facts))
        self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in self.r.factors['m_drop_user'].scenario_refs))


if __name__=='__main__':unittest.main()
