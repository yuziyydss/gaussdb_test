import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MIdentityResetTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_exact_documented_reset_productions(self):
        for name,expected in [('set_role',{'SET ROLE = DEFAULT;'}),('set_session_authorization',{
            'SET SESSION AUTHORIZATION DEFAULT;','SET SESSION SESSION AUTHORIZATION DEFAULT;',
            'SET LOCAL SESSION AUTHORIZATION DEFAULT;','SET SESSION_AUTHORIZATION = DEFAULT;'})]:
            m=self.r.manifests['manifest_m_'+name+'_reset_only'];cases=self.g.generate_cases_for_manifest(m)
            self.assertEqual({c.sql for c in cases},expected)
            for c in cases:
                self.assertEqual(c.setup_sqls,['START TRANSACTION;'])
                self.assertEqual(c.teardown_sqls,['ROLLBACK;'])
                self.assertNotIn('PASSWORD',c.sql)
                self.assertNotIn('CREATE ROLE',' '.join(c.setup_sqls))
                self.assertTrue(any(e['key']=='session_lifecycle' and e['allowed_values']==['isolated_new_connection'] for e in c.environment_requirements))

    def test_password_and_identity_behavior_remain_planned(self):
        for fid in ('m_set_role','m_set_session_authorization'):
            f=self.r.factors[fid]
            self.assertTrue(all(self.r.scenarios[s].status=='planned' for s in f.scenario_refs))
            s=self.r.scenarios['scenario_'+fid+'_password_switch']
            self.assertIn(fid+'_fact_password',s.fact_refs)
            self.assertIn(fid+'_fact_authority',s.fact_refs)
            self.assertTrue(any(x.id.endswith('_reset') and x.type=='behavior_oracle' for x in f.facts))

    def test_exact_builder_reconstruction(self):
        from scripts.build_m_compat_batch_04 import BUILDERS,rendered_files
        for key in ('set_role','set_session_authorization'):
            p=BUILDERS[key]()
            if p.id in ('m_drop_audit_policy','m_drop_database','m_drop_owned','m_drop_schema','m_drop_sequence',
'm_rename_table','m_rollback_to_savepoint','m_deallocate','m_do','m_drop_user',
'm_drop_view','m_drop_role','m_grant','m_create_function','m_analyze','m_copy',
'm_alter_table','m_create_table','m_create_table_partition','m_checkpoint','m_drop_prepare',
'm_autohint_purge','m_prepare','m_reset','m_drop_extension','m_drop_group',
'm_rollback','m_autohint','m_comment','m_drop_table','m_use',
'm_alter_resource_label','m_alter_schema','m_create_database','m_set_role','m_alter_database'):
                continue
            for name,obj in rendered_files(p).items():
                self.assertEqual((ROOT/'specs/utility'/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
