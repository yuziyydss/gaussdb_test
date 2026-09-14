import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MCopyCheckpointDropOwnedTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,fid):
        return [c for mid in self.r.factors['m_'+fid].manifest_refs for c in self.g.generate_cases_for_manifest(self.r.manifests[mid])]

    def test_copy_only_stdout_complete_query_and_integer_source(self):
        for c in self.cases('copy'):
            self.assertIn(' TO STDOUT',c.sql);self.assertNotIn('FROM STDIN',c.sql)
            self.assertNotIn('SELECT 1',c.sql);self.assertNotIn("TO '/",c.sql)
            if c.sql.startswith('COPY (SELECT'):self.assertIn('ORDER BY id) TO STDOUT',c.sql)
            self.assertTrue(any(s.startswith('CREATE TABLE m_b01_source') for s in c.setup_sqls))
            self.assertTrue(any(s.startswith('INSERT INTO m_b01_source') for s in c.setup_sqls))
            self.assertTrue(any(e['key']=='result_transport' and e['allowed_values']==['copy_out_stream_runner_required'] for e in c.environment_requirements))

    def test_copy_option_styles_never_mixed_and_header_is_csv_only(self):
        for c in self.cases('copy'):
            suffix=c.sql.split('TO STDOUT',1)[1]
            if '(' in suffix:
                self.assertIn('FORMAT ',suffix)
                self.assertNotIn(') CSV',suffix);self.assertNotIn(') DELIMITER',suffix)
            else:self.assertNotIn('FORMAT',suffix)
            if 'HEADER' in suffix:self.assertIn("FORMAT 'csv', HEADER FALSE",suffix)

    def test_copy_query_profiles_have_real_columns(self):
        resolved=self.r.resolve_dimension_values('m_copy')
        for key,cols in [('id',['id']),('two',['id','qty']),('reverse',['qty','id'])]:
            v=resolved['projection']['m_copy_projection_'+key]
            self.assertEqual(v.attributes['projection.properties.output_columns'],cols)
            self.assertEqual(v.attributes['projection.properties.output_types'],['INTEGER']*len(cols))

    def test_checkpoint_is_not_schema_isolated_or_rollback_claimed(self):
        cases=self.cases('checkpoint');self.assertEqual(len(cases),1);c=cases[0]
        self.assertEqual(c.sql,'CHECKPOINT;')
        self.assertTrue(any(e['key']=='instance_effect_scope' for e in c.environment_requirements))
        self.assertFalse(any(s.startswith(('START TRANSACTION','BEGIN','ROLLBACK','SET ')) for s in c.setup_sqls+c.teardown_sqls))

    def test_drop_owned_is_target_never_cleanup_and_has_real_grants(self):
        for c in self.cases('drop_owned'):
            self.assertTrue(c.sql.startswith('DROP OWNED BY m_b04_role_existing'))
            self.assertTrue(any(s.startswith('GRANT SELECT ON TABLE m_drop_owned_namespace.source') for s in c.setup_sqls))
            self.assertFalse(any('DROP OWNED' in s or 'CASCADE' in s for s in c.setup_sqls+c.teardown_sqls))
            self.assertEqual(c.teardown_sqls[:2],['DROP TABLE m_drop_owned_namespace.source;','DROP SCHEMA m_drop_owned_namespace;'])
            self.assertTrue(all(s.startswith('DROP ROLE ') for s in c.teardown_sqls[2:]))
            self.assertTrue(any(e['key']=='drop_owned_target_isolation' for e in c.environment_requirements))

    def test_exact_reconstruction(self):
        from scripts.build_m_compat_batch_05 import BUILDERS
        for key in ('copy','checkpoint','drop_owned'):
            p=BUILDERS[key]()
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'):
                continue
            # m_copy已进入人工演进阶段（新增source completion facts），
            # 不再回退到batch_05一次性builder的输出。
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'): continue
            for name,obj in p.finish().items():self.assertEqual((ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
