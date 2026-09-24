"""M role family static contracts; uncalibrated negatives are archived."""
import re
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry

ROOT=Path(__file__).resolve().parents[1]


class MRoleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):
        return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_create_role_target_and_parent_are_both_cleaned(self):
        for case in self.cases('create_role_finite'):
            self.assertIn('DROP ROLE IF EXISTS m_create_role_new;',case.teardown_sqls)
            self.assertTrue(any(sql.startswith('CREATE ROLE ') and 'parent' in sql for sql in case.setup_sqls))
            self.assertRegex(case.sql,r' IN (ROLE|GROUP) m_b04_role_parent\b')

    def test_rename_cleanup_includes_the_new_role_name(self):
        for case in self.cases('alter_role_rename'):
            self.assertIn('DROP ROLE IF EXISTS m_alter_role_renamed;',case.teardown_sqls)
            self.assertTrue(any(sql.startswith('CREATE ROLE ') for sql in case.setup_sqls))

    def test_no_plaintext_passwords_escalation_or_broad_cleanup(self):
        for name in ('create_role','alter_role','drop_role'):
            for mid in self.r.factors['m_'+name].manifest_refs:
                for case in self.g.generate_cases_for_manifest(self.r.manifests[mid]):
                    for sql in [case.sql]+case.setup_sqls+case.teardown_sqls:
                        self.assertNotRegex(sql,r"(?:PASSWORD|IDENTIFIED BY)\s+['\"]")
                        self.assertFalse(re.search(r'\b(?:SYSADMIN|CREATEDB|CREATEROLE|LOGIN|PERSISTENCE)\b',sql),sql)
                        self.assertNotIn('DROP OWNED',sql)
                        self.assertNotIn('CASCADE',sql)
                        self.assertNotIn('SELECT 1',sql)
                    self.assertTrue(any(e['key']=='actor_authority' and e['allowed_values']==['sysadmin'] for e in case.environment_requirements))
                    self.assertTrue(any(e['key']=='separation_of_duties' and e['allowed_values']==['off'] for e in case.environment_requirements))

    def test_drop_targets_have_actual_role_setup(self):
        for case in self.cases('drop_role_finite'):
            self.assertTrue(any(sql.startswith('CREATE ROLE m_b04_role_existing ') for sql in case.setup_sqls))
            if 'm_b04_role_second' in case.sql:
                self.assertTrue(any(sql.startswith('CREATE ROLE m_b04_role_second ') for sql in case.setup_sqls))
            self.assertIn('DROP ROLE IF EXISTS m_b04_role_existing;',case.teardown_sqls)

    def test_no_silent_auto_fixture_sql(self):
        for fixture in self.r.fixtures.values():
            if fixture.factor_ref not in ('m_create_role','m_alter_role','m_drop_role'):
                continue
            if fixture.execution.mode=='auto':
                self.assertEqual(fixture.execution.setup_sqls,[])
                self.assertEqual(fixture.execution.teardown_sqls,[])

    def test_static_closure_keeps_runtime_boundary_false(self):
        for fid in ('m_create_role','m_alter_role','m_drop_role'):
            audit=FactorCoverageAuditor(self.r).audit(fid)
            self.assertTrue(audit['conclusions']['generation_model_complete'],fid)
            self.assertTrue(audit['conclusions']['static_coverage_complete'],fid)
            self.assertFalse(audit['conclusions']['behavior_coverage_complete'],fid)


if __name__=='__main__':
    unittest.main()
