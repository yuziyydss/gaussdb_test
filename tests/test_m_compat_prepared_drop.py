"""PREPARE DROP owns only fresh objects and does not execute the inner DDL."""
from tests.evolved_asset_assertions import assert_evolved_asset
from pathlib import Path
import unittest

import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from scripts.build_m_compat_batch_02 import drop_object, namespace_drop
from scripts.build_m_compat_batch_03 import prepare, drop_index

ROOT=Path(__file__).resolve().parents[1]
KINDS=('table','view','index')


class PreparedDropTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry=FactorPackageRegistry(ROOT/'specs');cls.registry.load_all()

    def test_each_body_has_its_own_m_syntax_authority_and_fresh_fixture(self):
        p=prepare();profiles={v['id']:v for v in p.files['matrices/body.matrix.yaml']['profiles']}
        for kind in KINDS:
            vid='m_prepare_body_drop_'+kind
            self.assertTrue(vid in profiles,vid)
            for suffix in ('syntax','authority'):
                self.assertIn(f'm_drop_{kind}::m_drop_{kind}_fact_{suffix}',profiles[vid]['fact_refs'])
            provider=drop_index() if kind=='index' else drop_object('DROP '+kind.upper())
            self.assertIn(provider.fid('authority'),provider.exports)
            self.assertIn(provider.fid('syntax'),provider.exports)
            self.assertTrue(any(f['id']==provider.fid('authority') and f['type']=='environment'
                                and f['status']=='confirmed' for f in provider.facts))

    def test_three_actual_generated_cases_are_prepare_only_and_m_gated(self):
        for kind in KINDS:
            mid='manifest_m_prepare_drop_'+kind
            self.assertTrue(mid in self.registry.manifests,mid)
            cases,report=FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[mid])
            self.assertEqual(len(cases),1);self.assertTrue(report.pairwise_complete)
            c=cases[0]
            self.assertTrue(c.sql.startswith("PREPARE m_prepare_stmt FROM 'DROP "+kind.upper()+' '))
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
            gates={g['key']:g for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode']['allowed_values'],['M'])
            self.assertEqual(gates['session_lifecycle']['allowed_values'],['isolated_connection'])
            self.assertIn(f'm_drop_{kind}::m_drop_{kind}_fact_authority',gates['drop_authority']['fact_refs'])
            self.assertIn('m_drop_schema::m_drop_schema_fact_authority',gates['cleanup_authority']['fact_refs'])
            self.assertTrue(all(not s.upper().startswith(('DROP','EXECUTE','PREPARE')) for s in c.setup_sqls))
            self.assertTrue(c.setup_sqls[0].startswith('CREATE SCHEMA m_prepare_drop_'+kind+'_ns;'))
            self.assertEqual(c.teardown_sqls[0],'DEALLOCATE PREPARE m_prepare_stmt;')
            self.assertFalse(any('CASCADE' in s or 'DROP OWNED' in s for s in c.teardown_sqls))

    def test_only_drop_family_representatives_not_database_or_all_features(self):
        features=prepare().files['matrices/body.matrix.yaml']['documented_features']
        f=next(f for f in features if f['id']=='m_prepare_feature_body_drop_relation')
        self.assertEqual(f['coverage_mode'],'representative')
        self.assertEqual(set(f['profile_refs']),{'m_prepare_body_drop_'+k for k in KINDS} |
                         {'m_prepare_body_drop_namespace'})
        pending={f['id'] for f in features if f['status']=='needs_profile'}
        self.assertEqual(pending,{'m_prepare_feature_body_'+k for k in
            ('alter_database','alter_user','create_user','drop_user','privilege')})

    def test_scenarios_separate_prepare_read_execute_and_unverified_catalog_oracle(self):
        for kind in KINDS:
            sid='scenario_m_prepare_drop_'+kind+'_phase'
            self.assertTrue(sid in self.registry.scenarios,sid)
            scenario=self.registry.scenarios[sid]
            self.assertEqual(scenario.status,'planned')
            ids=[step['id'] for step in scenario.steps]
            self.assertLess(ids.index('prepare'),ids.index('before_execute'))
            self.assertLess(ids.index('before_execute'),ids.index('execute'))
            self.assertLess(ids.index('execute'),ids.index('after_execute'))
            self.assertIn('database_authorization',scenario.execution_requirements)
            self.assertIn('ownership_scoped_cleanup',scenario.execution_requirements)
            self.assertTrue(any(o['kind']=='manual_assertion' and o.get('step_id')=='after_execute'
                                for o in scenario.oracles))
            self.assertFalse(any(o['kind']=='target_error' for o in scenario.oracles))

    def test_drop_table_purge_and_cleanup_do_not_depend_on_recycle_bin_or_cascade(self):
        p=prepare()
        self.assertTrue('fixtures/drop_table.fixture.yaml' in p.files)
        table=p.files['fixtures/drop_table.fixture.yaml']
        self.assertTrue(any(sql.endswith(' PURGE;') for sql in table['execution']['teardown_sqls']))
        self.assertIn('m_drop_table::m_drop_table_fact_purge',
            p.files['scenarios/drop_table_phase.scenario.yaml']['fact_refs'])
        self.assertIn('m_drop_table::m_drop_table_fact_syntax',
            next(v for v in p.files['matrices/body.matrix.yaml']['profiles'] if v['id']=='m_prepare_body_drop_table')['fact_refs'])


if __name__=='__main__':
    unittest.main()
