"""M CREATE/ALTER/DROP USER contracts after static closure."""
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry

ROOT=Path(__file__).resolve().parents[1]


class MUserTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):
        return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_create_user_cleans_implicit_schema_before_identity(self):
        for case in self.cases('create_user_finite'):
            self.assertTrue(case.sql.startswith('CREATE USER m_create_user_new '))
            self.assertIn('CREATE ROLE m_create_user_parent NOLOGIN NOSYSADMIN PASSWORD DISABLE;',case.setup_sqls)
            self.assertEqual(case.teardown_sqls,['DROP SCHEMA IF EXISTS m_create_user_new;',
                'DROP USER IF EXISTS m_create_user_new RESTRICT;','DROP ROLE m_create_user_parent;'])

    def test_alter_user_reuses_actual_user_not_role_only(self):
        for suffix in ('options','set','reset'):
            for case in self.cases('alter_user_'+suffix):
                self.assertEqual(case.setup_sqls,['CREATE USER m_b04_user_existing NOLOGIN NOSYSADMIN PASSWORD DISABLE;'])
                self.assertEqual(case.teardown_sqls,['DROP SCHEMA IF EXISTS m_b04_user_existing;',
                    'DROP USER IF EXISTS m_b04_user_existing RESTRICT;'])
                self.assertNotIn(' RENAME ',case.sql)
                self.assertNotIn(' PASSWORD ',case.sql)
                self.assertNotIn(' IDENTIFIED BY ',case.sql)

    def test_drop_user_positive_precleans_schema_without_cascade(self):
        for case in self.cases('drop_user_dependency_free'):
            self.assertEqual(case.setup_sqls,[
                'CREATE USER m_drop_user_one NOLOGIN NOSYSADMIN PASSWORD DISABLE;',
                'CREATE USER m_drop_user_two NOLOGIN NOSYSADMIN PASSWORD DISABLE;',
                'DROP SCHEMA m_drop_user_one;','DROP SCHEMA m_drop_user_two;'])
            self.assertTrue(case.sql.startswith('DROP USER '))
            self.assertTrue(any(e['key']=='user_dependencies' and
                e['allowed_values']==['none_after_explicit_schema_cleanup'] for e in case.environment_requirements))
            self.assertTrue(any(e['key']=='identity_scope' for e in case.environment_requirements))

    def test_no_login_password_or_destructive_cleanup(self):
        for fid in ('m_create_user','m_alter_user','m_drop_user'):
            for mid in self.r.factors[fid].manifest_refs:
                for case in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                    for sql in [case.sql]+case.setup_sqls+case.teardown_sqls:
                        self.assertNotRegex(sql,r"(?:PASSWORD|IDENTIFIED BY)\s+['\"]")
                        self.assertNotRegex(sql,r'\b(?:LOGIN|SYSADMIN|CREATEDB|CREATEROLE|PERSISTENCE|CASCADE)\b')
                        self.assertNotIn('DROP OWNED',sql)
                    self.assertTrue(any(e['key']=='actor_authority' for e in case.environment_requirements))
                    self.assertTrue(any(e['key']=='compatibility_mode' and e['allowed_values']==['M'] for e in case.environment_requirements))

    def test_static_closure_keeps_runtime_boundary_false(self):
        for fid in ('m_create_user','m_alter_user','m_drop_user'):
            audit=FactorCoverageAuditor(self.r).audit(fid)
            self.assertTrue(audit['conclusions']['generation_model_complete'],fid)
            self.assertTrue(audit['conclusions']['static_coverage_complete'],fid)
            self.assertFalse(audit['conclusions']['behavior_coverage_complete'],fid)


if __name__=='__main__':
    unittest.main()
