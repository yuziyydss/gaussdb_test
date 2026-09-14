import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MGroupTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_create_group_real_membership_and_cleanup(self):
        for suite in ('finite','connection_below'):
            for c in self.cases('create_group_'+suite):
                self.assertIn(' IN ROLE m_create_group_parent ',c.sql)
                self.assertIn('CREATE ROLE m_create_group_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;',c.setup_sqls)
                self.assertEqual(c.teardown_sqls,['DROP ROLE IF EXISTS m_create_group_new;','DROP ROLE m_create_group_parent;'])

    def test_add_drop_have_opposite_initial_membership(self):
        for action in ('add','drop'):
            cases=self.cases('alter_group_'+action);self.assertEqual(len(cases),2)
            for c in cases:
                members=[s for s in c.setup_sqls if s.startswith('CREATE ROLE m_alter_group_member')]
                self.assertEqual(len(members),2)
                self.assertEqual(all(' IN ROLE m_alter_group_existing ' in s for s in members),action=='drop')
                self.assertTrue(c.sql.startswith('ALTER GROUP m_alter_group_existing '+action.upper()+' USER '))
                self.assertEqual(c.teardown_sqls[-1],'DROP ROLE IF EXISTS m_alter_group_existing;')

    def test_rename_both_names_cleaned(self):
        for c in self.cases('alter_group_rename'):
            self.assertIn('CREATE GROUP m_alter_group_before NOLOGIN NOSYSADMIN PASSWORD DISABLE;',c.setup_sqls)
            self.assertEqual(c.teardown_sqls,['DROP ROLE IF EXISTS m_alter_group_after;','DROP ROLE IF EXISTS m_alter_group_before;'])

    def test_drop_group_is_not_ordinary_user_support(self):
        cases=self.cases('drop_group_restricted_finite');self.assertEqual(len(cases),4)
        for c in cases:
            self.assertIn(dict(key='command_applicability',allowed_values=['m_management_tool_reviewed'],
                fact_refs=['m_drop_group_fact_management']),c.environment_requirements)
            self.assertEqual(len(c.setup_sqls),2)
            self.assertTrue(all(s.startswith('CREATE GROUP m_drop_group_') for s in c.setup_sqls))

    def test_shared_range_rule_and_no_password_or_escalation(self):
        f=self.r.factors['m_create_group'];resolved=self.r.resolve_dimension_values(f.id)
        combo={k:d.default_value_id for k,d in f.dimensions.items()};combo['connection_limit']='m_create_group_connection_limit_below'
        for suite,valid in [('finite',False),('connection_below',True)]:
            m=self.r.manifests['manifest_m_create_group_'+suite]
            self.assertEqual(self.g._build_solver(f,m,resolved).is_valid(combo)[0],valid)
        for fid in ('m_create_group','m_alter_group','m_drop_group'):
            for mid in self.r.factors[fid].manifest_refs:
                for c in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                    for sql in [c.sql]+c.setup_sqls+c.teardown_sqls:
                        self.assertNotRegex(sql,r"(?:PASSWORD|IDENTIFIED BY)\s+['\"]")
                        self.assertNotRegex(sql,r'\b(?:SYSADMIN|CREATEROLE|CREATEDB|LOGIN|PERSISTENCE)\b')
                        self.assertNotIn('DROP OWNED',sql);self.assertNotIn('CASCADE',sql)
                    self.assertTrue(any(e['key']=='actor_authority' and e['allowed_values']==['sysadmin'] for e in c.environment_requirements))

    def test_exact_builder_reconstruction(self):
        from scripts.build_m_compat_batch_04 import BUILDERS,rendered_files
        for key in ('create_group','alter_group','drop_group'):
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
                self.assertEqual((ROOT/'specs/ddl'/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
