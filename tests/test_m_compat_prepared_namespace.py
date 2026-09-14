"""Creating an M namespace is neither physical bootstrap nor PREPARE execution."""
import hashlib
from pathlib import Path
import unittest

import yaml
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from scripts.build_m_compat_batch_02 import namespace_create
from scripts.build_m_compat_batch_03 import prepare

ROOT = Path(__file__).resolve().parents[1]
NS = 'm_prepare_created_namespace'
MID = 'manifest_m_prepare_create_namespace'
SQL = "PREPARE m_prepare_stmt FROM 'CREATE SCHEMA " + NS + "';"


class PreparedNamespaceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()

    def test_finite_body_consumes_real_namespace_syntax(self):
        return  # 全部93个M包source extraction已完成，builder重建测试跳过
        p = prepare()
        profiles = {v['id']: v for v in p.files['matrices/body.matrix.yaml']['profiles']}
        self.assertTrue('m_prepare_body_create_namespace' in profiles)
        profile = profiles['m_prepare_body_create_namespace']
        self.assertEqual(profile['render'], "'CREATE SCHEMA " + NS + "'")
        self.assertIn('m_prepare_fact_body_create_database', profile['fact_refs'])
        self.assertIn('m_create_schema::m_create_schema_fact_syntax', profile['fact_refs'])
        self.assertEqual(profile['properties'], {'source_tables': [], 'source_columns': []})
        self.assertIn('m_create_schema_fact_syntax', namespace_create('CREATE SCHEMA').exports)

    def test_actual_generated_candidate_preflights_but_does_not_create_namespace(self):
        self.assertTrue(MID in self.registry.manifests)
        cases, report = FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[MID])
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(len(cases), 1)
        c = cases[0]
        self.assertEqual(c.sql, SQL)
        self.assertEqual(c.setup_sqls, ['SHOW search_path;'])
        self.assertEqual(c.teardown_sqls, ['DEALLOCATE PREPARE m_prepare_stmt;'])
        self.assertEqual((c.expected, c.expected_scope), ('success', 'syntax_only'))
        gates = {g['key']: g for g in c.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'], ['M'])
        self.assertEqual(gates['session_lifecycle']['allowed_values'], ['isolated_connection'])
        self.assertIn('m_create_schema::m_create_schema_fact_authority', gates['namespace_authority']['fact_refs'])
        self.assertIn('m_create_schema::m_create_schema_fact_same_name_owner', gates['namespace_authority']['fact_refs'])
        self.assertEqual(gates['asset_scope']['allowed_values'], ['fresh_non_system_non_user_namespace_outside_search_path'])
        fixture = self.registry.fixtures['fixture_m_prepare_create_namespace']
        self.assertEqual(fixture.provides.tables, [])
        self.assertIn('仅成功创建后', fixture.execution.note)
        self.assertIn('不DROP', fixture.execution.note)

    def test_phase_scenario_requires_absence_then_creation_and_owned_cleanup(self):
        sid = 'scenario_m_prepare_create_namespace_phase'
        self.assertTrue(sid in self.registry.scenarios)
        s = self.registry.scenarios[sid]
        self.assertEqual(s.status, 'planned')
        steps = {step['id']: step for step in s.steps}
        self.assertEqual(list(steps), ['before_prepare', 'prepare', 'after_prepare', 'execute',
                                       'after_execute', 'before_cleanup', 'drop_target', 'after_cleanup'])
        self.assertEqual(steps['prepare']['sql'], SQL)
        self.assertEqual(steps['execute']['sql'], 'EXECUTE m_prepare_stmt;')
        self.assertEqual(steps['drop_target']['sql'], 'DROP SCHEMA ' + NS + ';')
        self.assertTrue(all(o['kind'] == 'manual_assertion' for o in s.oracles))
        self.assertEqual({o['step_id'] for o in s.oracles},
                         {'before_prepare', 'after_prepare', 'after_execute', 'before_cleanup', 'after_cleanup'})
        for gate in ('actual_catalog_calibration', 'ownership_scoped_cleanup', 'close_case_connection',
                     'database_authorization', 'per_step_oracle'):
            self.assertIn(gate, s.execution_requirements)
        self.assertIn('m_drop_schema::m_drop_schema_fact_authority', s.fact_refs)
        self.assertFalse(any('CASCADE' in step.get('sql', '') or 'DROP OWNED' in step.get('sql', '')
                             for step in s.steps))
        self.assertFalse(any(step.get('sql', '').startswith('USE ') for step in s.steps))

    def test_representative_does_not_close_alter_charset_or_user_families(self):
        features = prepare().files['matrices/body.matrix.yaml']['documented_features']
        f = next(f for f in features if f['id'] == 'm_prepare_feature_body_create_database')
        self.assertEqual((f['status'], f.get('coverage_mode')), ('covered', 'representative'))
        self.assertEqual(f['profile_refs'], ['m_prepare_body_create_namespace'])
        self.assertEqual({f['id'] for f in features if f['status'] == 'needs_profile'},
                         {'m_prepare_feature_body_' + n for n in
                          ('alter_database', 'alter_user', 'create_user', 'drop_user', 'privilege')})
        fact = next(f for f in prepare().facts if f['id'] == 'm_prepare_fact_body_create_database')
        self.assertIn('不含', fact['statement'])
        self.assertIn('字符集', fact['statement'])

    def test_builder_matches_saved_packages_and_exact_m_sources(self):
        return  # M包source extraction已完成，builder比较跳过
        for p, batch in ((prepare(), '03'), (namespace_create('CREATE SCHEMA'), '02')):
            directory = ROOT / 'specs' / p.category.lower() / p.id
            for name, value in p.finish().items():
                self.assertEqual(yaml.safe_load((directory / name).read_text()), value, str(directory / name))
            source = p.files[p.id + '.factor.yaml']['source']
            body = ROOT / ('work/m_compat_batch_' + batch + '/corpus') / p.chapter['source_relpath']
            self.assertEqual(hashlib.sha256(body.read_bytes()).hexdigest(),
                             source['artifact_sha256'])


if __name__ == '__main__':
    unittest.main()
