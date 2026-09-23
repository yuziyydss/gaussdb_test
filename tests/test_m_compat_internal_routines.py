from tests.evolved_asset_assertions import assert_evolved_asset
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

    def test_drop_signature_and_restrict_are_grammatically_related(self):
        for c in self.cases('drop_function_restricted_finite'):
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

    def test_current_specs_load_and_generate(self):
        for fid in ('m_create_function','m_drop_function','m_do'):
            for mid in self.r.factors[fid].manifest_refs:
                cases,report=self.g.generate_with_report(self.r.manifests[mid])
                self.assertTrue(cases)
                self.assertTrue(report.pairwise_complete)

