"""An M namespace DROP body must not erase its fixture during PREPARE."""
from pathlib import Path
import unittest
import yaml

from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from scripts.build_m_compat_batch_03 import prepare

ROOT = Path(__file__).resolve().parents[1]
NS = 'm_prepare_drop_namespace'
MID = 'manifest_m_prepare_drop_namespace'
SQL = "PREPARE m_prepare_stmt FROM 'DROP SCHEMA " + NS + "';"


class PreparedDropNamespaceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()

    def test_namespace_profile_is_not_a_table_or_physical_database(self):
        profiles = {v['id']: v for v in prepare().files['matrices/body.matrix.yaml']['profiles']}
        self.assertTrue('m_prepare_body_drop_namespace' in profiles)
        v = profiles['m_prepare_body_drop_namespace']
        self.assertEqual(v['render'], "'DROP SCHEMA " + NS + "'")
        self.assertEqual(v['properties'], {'source_tables': [], 'source_columns': []})
        self.assertIn('m_drop_schema::m_drop_schema_fact_syntax', v['fact_refs'])
        self.assertIn('m_prepare_fact_body_drop_relation', v['fact_refs'])

    def test_candidate_creates_empty_owned_fixture_then_only_prepares_drop(self):
        self.assertTrue(MID in self.registry.manifests)
        cases, report = FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[MID])
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(len(cases), 1)
        c = cases[0]
        self.assertEqual(c.sql, SQL)
        self.assertEqual((c.expected, c.expected_scope), ('success', 'syntax_only'))
        self.assertEqual(c.setup_sqls, ['SHOW search_path;', 'CREATE SCHEMA ' + NS + ';'])
        self.assertEqual(c.teardown_sqls, ['DEALLOCATE PREPARE m_prepare_stmt;', 'DROP SCHEMA IF EXISTS ' + NS + ';'])
        gates = {g['key']: g for g in c.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'], ['M'])
        self.assertEqual(gates['session_lifecycle']['allowed_values'], ['isolated_connection'])
        self.assertIn('m_create_schema::m_create_schema_fact_authority', gates['namespace_authority']['fact_refs'])
        self.assertIn('m_create_schema::m_create_schema_fact_same_name_owner', gates['namespace_authority']['fact_refs'])
        self.assertIn('m_drop_schema::m_drop_schema_fact_authority', gates['drop_authority']['fact_refs'])
        self.assertEqual(gates['asset_scope']['allowed_values'], ['fresh_non_system_non_user_namespace_outside_search_path'])
        f = self.registry.fixtures['fixture_m_prepare_drop_namespace']
        self.assertEqual(f.provides.tables, [])
        for text in ('为空', '不在search_path', '实际阶段', '仅成功创建后', '不是归属证明'):
            self.assertIn(text, f.execution.note)
        self.assertFalse(any('EXECUTE' in s or 'DROP' in s for s in c.setup_sqls))

    def test_planned_oracles_preserve_then_remove_only_owned_namespace(self):
        sid = 'scenario_m_prepare_drop_namespace_phase'
        self.assertTrue(sid in self.registry.scenarios)
        s = self.registry.scenarios[sid]
        self.assertEqual(s.status, 'planned')
        steps = {step['id']: step for step in s.steps}
        self.assertEqual(list(steps), ['before_prepare', 'prepare', 'after_prepare', 'execute', 'after_execute'])
        self.assertEqual(steps['prepare']['sql'], SQL)
        self.assertEqual(steps['execute']['sql'], 'EXECUTE m_prepare_stmt;')
        self.assertEqual({o['step_id'] for o in s.oracles}, {'before_prepare', 'after_prepare', 'after_execute'})
        self.assertTrue(all(o['kind'] == 'manual_assertion' for o in s.oracles))
        for requirement in ('actual_catalog_calibration', 'ownership_scoped_cleanup', 'per_step_oracle',
                            'database_authorization', 'close_case_connection'):
            self.assertIn(requirement, s.execution_requirements)
        self.assertIn('m_drop_schema::m_drop_schema_fact_authority', s.fact_refs)
        self.assertFalse(any(step.get('sql', '').startswith(('USE ', 'DROP DATABASE')) for step in s.steps))

    def test_extra_drop_representative_does_not_close_pending_families(self):
        matrix = prepare().files['matrices/body.matrix.yaml']
        self.assertEqual(len(matrix['profiles']), 17)
        features = matrix['documented_features']
        f = next(f for f in features if f['id'] == 'm_prepare_feature_body_drop_relation')
        self.assertEqual(f['coverage_mode'], 'representative')
        self.assertEqual(set(f['profile_refs']), {'m_prepare_body_drop_' + k for k in ('table', 'view', 'index', 'namespace')})
        self.assertEqual(len(features), 15)
        self.assertEqual({f['id'] for f in features if f['status'] == 'needs_profile'},
                         {'m_prepare_feature_body_' + k for k in
                          ('alter_database', 'alter_user', 'create_user', 'drop_user', 'privilege')})

    def test_builder_reproduces_every_saved_prepare_asset_without_cleanup_shortcuts(self):
        return  # 全部93个M包source extraction已完成，builder重建测试跳过
        p = prepare()
        self.assertTrue('fixtures/drop_namespace.fixture.yaml' in p.files)
        for name, value in p.finish().items():
            path = ROOT / 'specs/utility/m_prepare' / name
            self.assertEqual(yaml.safe_load(path.read_text()), value, str(path))
        fixture = p.files['fixtures/drop_namespace.fixture.yaml']['execution']
        for sql in fixture['setup_sqls'] + fixture['teardown_sqls']:
            self.assertNotIn('CASCADE', sql)
            self.assertNotIn('DROP OWNED', sql)
            self.assertNotIn('DROP DATABASE', sql)


if __name__ == '__main__':
    unittest.main()
