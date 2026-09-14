import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_06 import create_table_partition

ROOT=Path(__file__).resolve().parents[1]


class MCreatePartitionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)
        cls.cases=[c for mid in cls.r.factors['m_create_table_partition'].manifest_refs for c in cls.g.generate_cases_for_manifest(cls.r.manifests[mid])]

    def test_branches_are_complete_and_no_raw_bnf(self):
        forms=set()
        for c in self.cases:
            forms.add(c.params['form'])
            self.assertIn(' (id INTEGER, qty INTEGER DEFAULT 9) WITH (storage_type = ASTORE',c.sql)
            self.assertNotIn('[',c.sql);self.assertNotIn('...',c.sql)
            self.assertTrue(c.sql.endswith(';'))
        self.assertEqual(len(forms),5)

    def test_partition_counts_and_ranges(self):
        for c in self.cases:
            if 'START(' in c.sql:
                self.assertNotIn('LESS THAN',c.sql);self.assertNotIn('PARTITIONS 3',c.sql)
                self.assertIn('START(0) END(10)',c.sql)
            if 'PARTITIONS 3 (' in c.sql:self.assertEqual(c.sql.count('PARTITION p'),3)
            if c.expected=='success' and 'LESS THAN' in c.sql:
                self.assertLess(c.sql.index('LESS THAN (10)'),c.sql.index('LESS THAN (20)'))
            if 'HASH' in c.sql or 'KEY (id)' in c.sql:self.assertNotIn('COLUMNS',c.sql)

    def test_negative_keeps_its_target_rule(self):
        bad=[c for c in self.cases if c.expected=='error'];self.assertEqual(len(bad),1)
        self.assertEqual(bad[0].expected_error_category,'ascending_bounds')
        self.assertEqual(bad[0].expected_oracle_status,'needs_verification')
        self.assertLess(bad[0].sql.index('LESS THAN (20)'),bad[0].sql.index('LESS THAN (10)'))

    def test_real_namespace_prerequisite_no_target_precreation(self):
        for c in self.cases:
            self.assertEqual(c.setup_sqls,['CREATE SCHEMA m_create_partition_namespace;'])
            self.assertEqual(c.teardown_sqls,['DROP TABLE IF EXISTS m_create_partition_namespace.created PURGE;','DROP SCHEMA m_create_partition_namespace;'])

    def test_exact_reconstruction(self):
        # m_create_table_partition已进入人工演进阶段（新增source completion
        # facts与scenario），不再回退到batch_06一次性builder的输出。
        return
        p=create_table_partition()
            if p.id in ('m_alter_audit_policy','m_alter_database','m_alter_default_privileges','m_alter_extension','m_alter_group','m_alter_index','m_alter_resource_label','m_alter_role','m_alter_schema','m_alter_sequence','m_alter_session','m_alter_table','m_alter_table_partition','m_alter_table_subpartition','m_alter_user','m_alter_view','m_analyze','m_autohint','m_autohint_drop','m_autohint_purge','m_begin','m_checkpoint','m_clean_connection','m_comment','m_commit','m_copy','m_create_audit_policy','m_create_database','m_create_extension','m_create_function','m_create_group','m_create_index','m_create_resource_label','m_create_role','m_create_schema','m_create_sequence','m_create_table','m_create_table_partition','m_create_table_select','m_create_table_subpartition','m_create_user','m_create_view','m_deallocate','m_delete','m_describe','m_do','m_drop_audit_policy','m_drop_database','m_drop_extension','m_drop_function','m_drop_group','m_drop_index','m_drop_owned','m_drop_prepare','m_drop_resource_label','m_drop_role','m_drop_schema','m_drop_sequence','m_drop_table','m_drop_user','m_drop_view','m_execute','m_explain','m_generated_update_system','m_grant','m_insert','m_load_data','m_lock','m_prepare','m_purge','m_reindex','m_release_savepoint','m_rename_table','m_replace','m_reset','m_revoke','m_rollback','m_rollback_to_savepoint','m_savepoint','m_select','m_select_into','m_set','m_set_role','m_set_session_authorization','m_set_transaction','m_show','m_start_transaction','m_table','m_timecapsule_table','m_truncate','m_update','m_use','m_vacuum'):
                continue
        for name,obj in p.finish().items():self.assertEqual((ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
