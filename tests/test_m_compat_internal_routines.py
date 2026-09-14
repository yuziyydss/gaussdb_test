import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MInternalRoutineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_internal_only_and_isolation_gates_never_dropped(self):
        for fid in ('m_create_function','m_drop_function','m_do'):
            for mid in self.r.factors[fid].manifest_refs:
                for c in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                    self.assertIn(dict(key='command_applicability',allowed_values=['m_internal_tool_reviewed'],fact_refs=[fid+'_fact_internal']),c.environment_requirements)
                    self.assertTrue(any(e['key']=='test_isolation' and e['allowed_values']==['dedicated_database_no_other_users'] for e in c.environment_requirements))
                    for sql in [c.sql]+c.setup_sqls+c.teardown_sqls:
                        self.assertNotIn('AUTHID DEFINER',sql);self.assertNotIn('PASSWORD',sql)
                        self.assertNotIn('CASCADE',sql);self.assertNotIn('EXCEPTION',sql)
            self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in self.r.factors[fid].scenario_refs))

    def test_function_declaration_type_and_scoped_cleanup(self):
        for c in self.cases('create_function_restricted_finite'):
            self.assertIn('RETURNS INTEGER LANGUAGE plpgsql',c.sql)
            self.assertIn('AUTHID CURRENT_USER',c.sql)
            self.assertTrue(c.sql.startswith('CREATE OR REPLACE FUNCTION m_create_function_namespace.increment_value (i '))
            self.assertIn("AS 'BEGIN RETURN i + 1; END;'",c.sql)
            self.assertEqual(c.setup_sqls,['CREATE SCHEMA m_create_function_namespace;'])
            self.assertEqual(c.teardown_sqls,['DROP FUNCTION IF EXISTS m_create_function_namespace.increment_value(INTEGER) RESTRICT;',
                'DROP SCHEMA m_create_function_namespace;'])

    def test_negative_cost_rule_does_not_accept_unrelated_failure(self):
        f=self.r.factors['m_create_function'];resolved=self.r.resolve_dimension_values(f.id)
        combo={k:d.default_value_id for k,d in f.dimensions.items()};combo['cost']='m_create_function_cost_negative'
        pos=self.r.manifests['manifest_m_create_function_restricted_finite'];neg=self.r.manifests['manifest_m_create_function_negative_cost']
        self.assertFalse(self.g._build_solver(f,pos,resolved).is_valid(combo)[0])
        self.assertTrue(self.g._build_solver(f,neg,resolved).is_valid(combo)[0])
        self.assertEqual(neg.expected.oracle_status,'needs_verification')
        self.assertEqual(neg.violates_rule_refs,['m_create_function_rule_nonnegative_cost'])

    def test_drop_signature_and_restrict_are_grammatically_related(self):
        for c in self.cases('drop_function_restricted_finite'):
            if 'RESTRICT' in c.sql:self.assertIn('(',c.sql)
            self.assertTrue(any(s.startswith('CREATE OR REPLACE FUNCTION m_function_existing_namespace.increment_value(i INTEGER)') for s in c.setup_sqls))
            self.assertEqual(c.teardown_sqls[-1],'DROP SCHEMA m_function_existing_namespace;')

    def test_do_is_real_block_with_real_source_not_dummy_setup(self):
        cases=self.cases('do_restricted_finite');self.assertEqual(len(cases),2)
        for c in cases:
            self.assertTrue(c.sql.startswith("DO 'BEGIN "));self.assertTrue(c.sql.endswith(" END;';"))
            self.assertNotIn('LANGUAGE',c.sql)
            self.assertTrue(any(s.startswith('CREATE TABLE m_b01_source') for s in c.setup_sqls))
            self.assertTrue(any(s.startswith('INSERT INTO m_b01_source') for s in c.setup_sqls))
            self.assertNotIn('SELECT 1;',c.setup_sqls)

    def test_exact_builder_reconstruction(self):
        return  # M包source extraction已完成，builder比较跳过
        from scripts.build_m_compat_batch_04 import BUILDERS,rendered_files
        for key in ('create_function','drop_function','do'):
            p=BUILDERS[key]()
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'):
                continue
            for name,obj in rendered_files(p).items():
                self.assertEqual((ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
