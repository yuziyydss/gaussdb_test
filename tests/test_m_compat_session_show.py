import unittest
from pathlib import Path
import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]


class MSessionShowTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):
        return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_set_timezone_all_scopes_real_transaction(self):
        cases=self.cases('set_timezone')
        expected={f'SET {scope}TIME ZONE {zone};' for scope in ('','LOCAL ','SESSION ')
                  for zone in ("'PRC'",'LOCAL','DEFAULT')}
        self.assertEqual({c.sql for c in cases},expected)
        for c in cases:
            self.assertEqual(c.setup_sqls,['START TRANSACTION;'])
            self.assertEqual(c.teardown_sqls,['ROLLBACK;'])
            self.assertIn('isolated_connection',next(x['allowed_values'] for x in c.environment_requirements if x['key']=='session_lifecycle'))

    def test_reset_named_parameter_is_not_a_positive(self):
        positive=self.cases('reset_all');negative=self.cases('reset_named_negative')
        self.assertEqual([c.sql for c in positive],['RESET ALL;'])
        self.assertEqual([c.sql for c in negative],['RESET TimeZone;'])
        m=self.r.manifests['manifest_m_reset_named_negative']
        self.assertEqual(m.expected.oracle_status,'needs_verification')
        self.assertEqual(m.violates_rule_refs,['m_reset_rule_only_all'])
        f=self.r.factors['m_reset'];resolved=self.r.resolve_dimension_values(f.id)
        combo={'target':'m_reset_target_named'}
        self.assertFalse(self.g._build_solver(f,self.r.manifests['manifest_m_reset_all'],resolved).is_valid(combo)[0])
        self.assertTrue(self.g._build_solver(f,m,resolved).is_valid(combo)[0])

    def test_reset_cleanup_survives_lost_search_path(self):
        for name in ('reset_all','reset_named_negative'):
            for c in self.cases(name):
                self.assertEqual(c.setup_sqls,['START TRANSACTION;',"SET LOCAL TIME ZONE 'PRC';"])
                self.assertEqual(c.teardown_sqls,['ROLLBACK;'])
                self.assertFalse(any('TABLE' in s or 'SCHEMA' in s for s in c.teardown_sqls))
                self.assertTrue(any(e['key']=='session_lifecycle' for e in c.environment_requirements))

    def test_transaction_not_confused_with_set_local_or_global(self):
        cases=self.cases('set_transaction_session')
        self.assertEqual(len(cases),12)
        for c in cases:
            self.assertRegex(c.sql,r'^SET (LOCAL|SESSION) TRANSACTION ')
            self.assertNotIn('GLOBAL',c.sql)
            self.assertEqual(c.setup_sqls,['START TRANSACTION;'])
            self.assertEqual(c.teardown_sqls,['ROLLBACK;'])
            self.assertTrue(any(e['key']=='transaction_stage' and e['allowed_values']==['before_first_data_statement'] for e in c.environment_requirements))
        serial=[c for c in cases if 'SERIALIZABLE' in c.sql]
        self.assertEqual(len(serial),2)
        self.assertEqual(self.r.manifests['manifest_m_set_transaction_session'].expected.default,'success')
        f=self.r.factors['m_set_transaction']
        aliases=[v.statement for v in f.facts if v.id.endswith('serializable_alias')]
        self.assertIn('REPEATABLE READ',aliases[0])

    def test_show_depends_on_real_object_not_dummy_setup(self):
        for suite,ddl in [('table_columns','CREATE TABLE m_b01_source '),
                          ('view_columns','CREATE VIEW m_b01_view '),
                          ('definitions','CREATE VIEW m_b01_view '),
                          ('indexes','CREATE INDEX m_b03_existing_index ')]:
            for c in self.cases('show_'+suite):
                self.assertTrue(any(s.startswith(ddl) for s in c.setup_sqls),(suite,c.setup_sqls))
                self.assertTrue(any(e['key']=='object_authority' for e in c.environment_requirements))
                if suite=='indexes':
                    self.assertRegex(c.sql,r'^SHOW (INDEX|INDEXES|KEYS) (FROM|IN) m_b01_source;$')
        for c in self.cases('show_parameters'):
            self.assertIn("SET LOCAL TIME ZONE 'PRC';",c.setup_sqls)
            self.assertFalse(any('CREATE TABLE' in s for s in c.setup_sqls))

    def test_show_form_specific_options_and_lifecycles(self):
        self.assertEqual(len(self.cases('show_definitions')),3)
        for c in self.cases('show_table_status'):
            self.assertNotIn('FULL',c.sql)
            self.assertTrue(c.sql.startswith('SHOW TABLE STATUS'))
        for suite in ('table_columns','view_columns'):
            sql={c.sql for c in self.cases('show_'+suite)}
            self.assertEqual(len(sql),6)
            self.assertTrue(any("WHERE Field = 'id'" in s for s in sql))
            self.assertTrue(any("LIKE 'id'" in s for s in sql))

    def test_all_new_scenarios_remain_unexecuted(self):
        for fid in ('m_set','m_reset','m_set_transaction','m_show'):
            for sid in self.r.factors[fid].scenario_refs:
                self.assertEqual(self.r.scenarios[sid].status,'planned')

    def test_curated_builder_matches_all_third_batch_artifacts(self):
        from scripts.build_m_compat_batch_03 import BUILDERS
        self.assertEqual(len(BUILDERS),18)
        for builder in BUILDERS.values():
            p=builder()
            for name,obj in p.finish().items():
                path=ROOT/'specs'/p.category.lower()/p.id/name
                self.assertEqual(path.read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110),str(path))


if __name__=='__main__':unittest.main()
