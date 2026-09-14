import unittest
from pathlib import Path
import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MRoleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_create_role_target_and_parent_are_both_cleaned(self):
        for suite in ('finite','connection_below'):
            for c in self.cases('create_role_'+suite):
                self.assertIn('DROP ROLE IF EXISTS m_create_role_new;',c.teardown_sqls)
                self.assertTrue(any(s.startswith('CREATE ROLE ') and 'parent' in s for s in c.setup_sqls))
                self.assertRegex(c.sql,r' IN (ROLE|GROUP) m_b04_role_parent\b')

    def test_rename_cleanup_includes_the_new_role_name(self):
        for c in self.cases('alter_role_rename'):
            self.assertIn('DROP ROLE IF EXISTS m_alter_role_renamed;',c.teardown_sqls)
            self.assertTrue(any(s.startswith('CREATE ROLE ') for s in c.setup_sqls))

    def test_no_plaintext_passwords_escalation_or_broad_cleanup(self):
        import re
        for name in ('create_role','alter_role','drop_role'):
            for mid in self.r.factors['m_'+name].manifest_refs:
                for c in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                    for sql in [c.sql]+c.setup_sqls+c.teardown_sqls:
                        self.assertNotRegex(sql,r"(?:PASSWORD|IDENTIFIED BY)\s+['\"]")
                        self.assertFalse(re.search(r'\b(?:SYSADMIN|CREATEDB|CREATEROLE|LOGIN|PERSISTENCE)\b',sql),sql)
                        self.assertNotIn('DROP OWNED',sql);self.assertNotIn('CASCADE',sql)
                        self.assertNotIn('SELECT 1',sql)
                    self.assertTrue(any(e['key']=='actor_authority' and e['allowed_values']==['sysadmin'] for e in c.environment_requirements))
                    self.assertTrue(any(e['key']=='separation_of_duties' and e['allowed_values']==['off'] for e in c.environment_requirements))

    def test_negative_limit_only_inverts_its_target_rule(self):
        for fid,dimension,value in [('m_create_role','connection_limit','below'),('m_alter_role','option','below')]:
            f=self.r.factors[fid];resolved=self.r.resolve_dimension_values(fid)
            combo={k:v.default_value_id for k,v in f.dimensions.items()};combo[dimension]=fid+'_'+dimension+'_'+value
            m=self.r.manifests['manifest_'+fid+'_connection_below']
            positive=self.r.manifests['manifest_'+fid+('_finite' if fid=='m_create_role' else '_options')]
            self.assertFalse(self.g._build_solver(f,positive,resolved).is_valid(combo)[0])
            self.assertTrue(self.g._build_solver(f,m,resolved).is_valid(combo)[0])
            self.assertEqual(m.expected.oracle_status,'needs_verification')
            self.assertEqual(m.violates_rule_refs,[fid+'_rule_connection_range'])

    def test_drop_targets_have_actual_role_setup(self):
        for c in self.cases('drop_role_finite'):
            self.assertTrue(any(s.startswith('CREATE ROLE m_b04_role_existing ') for s in c.setup_sqls))
            if 'm_b04_role_second' in c.sql:self.assertTrue(any(s.startswith('CREATE ROLE m_b04_role_second ') for s in c.setup_sqls))
            self.assertIn('DROP ROLE IF EXISTS m_b04_role_existing;',c.teardown_sqls)

    def test_no_silent_auto_fixture_sql(self):
        for fixture in self.r.fixtures.values():
            if fixture.factor_ref not in ('m_create_role','m_alter_role','m_drop_role'):continue
            if fixture.execution.mode=='auto':
                self.assertEqual(fixture.execution.setup_sqls,[])
                self.assertEqual(fixture.execution.teardown_sqls,[])

    def test_builder_artifacts_match(self):
        from scripts.build_m_compat_batch_04 import BUILDERS,rendered_files
        for builder in BUILDERS.values():
            p=builder()
            # m_drop_role已进入人工演进阶段（新增source completion facts）
            if p.id in ('m_drop_audit_policy','m_drop_database','m_drop_owned','m_drop_schema','m_drop_sequence',
'm_rename_table','m_rollback_to_savepoint','m_deallocate','m_do','m_drop_user',
'm_drop_view','m_drop_role','m_grant','m_create_function','m_analyze','m_copy',
'm_alter_table','m_create_table','m_create_table_partition','m_checkpoint','m_drop_prepare',
'm_autohint_purge','m_prepare','m_reset','m_drop_extension','m_drop_group',
'm_rollback','m_autohint','m_comment','m_drop_table','m_use',
'm_alter_resource_label','m_alter_schema','m_create_database','m_set_role','m_alter_database'):
                continue
            for name,obj in rendered_files(p).items():
                path=ROOT/'specs'/p.category.lower()/p.id/name
                self.assertEqual(path.read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110),str(path))


if __name__=='__main__':unittest.main()
