from tests.evolved_asset_assertions import assert_evolved_asset
import unittest
from pathlib import Path
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_06 import BUILDERS,HINT_QUERIES

ROOT=Path(__file__).resolve().parents[1]
HINT_NAMES=('autohint','autohint_drop','autohint_purge')


class MAutohintTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):
        return [c for mid in self.r.factors['m_'+name].manifest_refs for c in self.g.generate_cases_for_manifest(self.r.manifests[mid])]

    def test_real_queries_and_exact_history_producer(self):
        for name in HINT_NAMES:
            for c in self.cases(name):
                self.assertTrue(any(s.startswith('CREATE TABLE m_autohint_left') for s in c.setup_sqls))
                self.assertTrue(any(s.startswith('INSERT INTO m_autohint_right') for s in c.setup_sqls))
                for q in HINT_QUERIES.values():
                    self.assertIn('AUTOHINT (ANALYZE TRUE, TEST FALSE, SQLPATCH FALSE, DEBUG FALSE) '+q+';',c.setup_sqls)
                self.assertTrue(all('AUTOHINT PURGE' not in s for s in c.setup_sqls+c.teardown_sqls))

    def test_options_parenthesized_test_and_patch_explicitly_off(self):
        cases=self.cases('autohint');self.assertGreater(len(cases),1)
        for c in cases:
            self.assertTrue(c.sql.startswith('AUTOHINT (ANALYZE '))
            self.assertIn('SQLPATCH FALSE, TEST FALSE',c.sql)
            self.assertIn(') SELECT MIN(l.qty)',c.sql)
            self.assertNotIn('SQLPATCH TRUE',c.sql)
        self.assertTrue(any('ANALYZE FALSE' in c.sql for c in cases))

    def test_purge_is_explicit_global_target_not_cleanup(self):
        c=self.cases('autohint_purge')[0]
        self.assertEqual(c.sql,'AUTOHINT PURGE;')
        self.assertTrue(any(e['key']=='instance_effect_scope' and e['allowed_values']==['dedicated_disposable_instance_no_foreign_hint_models'] for e in c.environment_requirements))
        self.assertTrue(all('PURGE' not in s for s in c.teardown_sqls))

    def test_teardown_exact_history_before_objects(self):
        for name in HINT_NAMES:
            for c in self.cases(name):
                self.assertEqual(c.teardown_sqls[:2],['AUTOHINT DROP '+q+';' for q in HINT_QUERIES.values()])
                self.assertEqual(c.teardown_sqls[-2:],['DROP TABLE m_autohint_right;','DROP TABLE m_autohint_left;'])

    def test_behavior_not_falsely_verified(self):
        for name in HINT_NAMES:
            f=self.r.factors['m_'+name]
            self.assertTrue(f.scenario_refs)
            for sid in f.scenario_refs:self.assertEqual(self.r.scenarios[sid].status,'planned')
            for c in self.cases(name):self.assertEqual(c.expected_scope,'syntax_only')

    def test_exact_reconstruction(self):
        for key in HINT_NAMES:
            p=BUILDERS[key]()
            for name,obj in p.finish().items():
                assert_evolved_asset(self, (ROOT/'specs'/p.category.lower()/p.id/name).read_text(),yaml.safe_dump(obj,allow_unicode=True,sort_keys=False,width=110))


if __name__=='__main__':unittest.main()
