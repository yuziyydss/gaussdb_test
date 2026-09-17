"""Generation must consume actual USTORE RANGE DDL, tracking and target shape."""
import copy
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_create_index_ustore_local_fresh'
ACTIVE_MID = 'manifest_create_index_active_pages_manual'


class UstoreIndexGenerationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs')
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def generate(self):
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_new_candidate_without_statistics_or_runtime_claim(self):
        cases, report = self.generate()
        self.assertEqual(len(cases), 1)
        self.assertTrue(report.pairwise_complete)
        c = cases[0]
        self.assertIn(' ON g_ci_ustore_local USING ubtree (id) LOCAL;', c.sql)
        self.assertNotIn('active_pages', c.sql.lower())
        self.assertEqual(c.expected_scope, 'syntax_only')
        self.assertEqual(c.teardown_sqls, ['DROP TABLE g_ci_ustore_local RESTRICT;'])
        self.assertEqual(self.r.scenarios['scenario_create_index_ustore_local_fresh'].status, 'planned')

    def test_active_pages_manual_is_a_separate_syntax_only_profile(self):
        cases, report = self.g.generate_with_report(self.r.manifests[ACTIVE_MID])
        self.assertEqual(len(cases), 1)
        self.assertTrue(report.pairwise_complete)
        case = cases[0]
        self.assertIn(' ON g_ci_ustore_local USING ubtree (id) LOCAL WITH (active_pages = 16);', case.sql)
        self.assertEqual(case.expected_scope, 'syntax_only')
        self.assertEqual(case.params['storage_profile'], 'ci_active_pages_manual')
        self.assertEqual(case.setup_sqls[0],
            'CREATE TABLE g_ci_ustore_local (id INTEGER) WITH (storage_type=ustore) '
            'PARTITION BY RANGE (id) (PARTITION p1 VALUES LESS THAN (10), '
            'PARTITION p2 VALUES LESS THAN (20));')
        self.assertEqual(case.teardown_sqls, ['DROP TABLE g_ci_ustore_local RESTRICT;'])
        gates = {gate['key']: gate['allowed_values'] for gate in case.environment_requirements}
        self.assertEqual(gates['active_pages_manual_profile'], ['syntax_only_not_recommended'])
        from core.factor_coverage_auditor import FactorCoverageAuditor
        audit = FactorCoverageAuditor(self.r).audit('create_index')
        self.assertEqual(audit['values']['coverage_gaps'], ['storage_profile.ci_enable_tde_on'])
        self.assertIn('ci_feature_active_pages_execution_profile',
                      audit['documented_features']['coverage_gaps'])

    def test_actual_wrong_engine_cannot_hide_behind_missing_marker(self):
        self.generate()
        fixture = self.r.fixtures['fixture_create_index_ustore_local_fresh']
        p = next(p for p in self.r.matrices['matrix_create_index_table_profiles'].profiles
                 if p.id == 'ci_table_ustore_local_fresh')
        old_sql, old_props = list(fixture.execution.setup_sqls), copy.deepcopy(p.properties)
        try:
            p.properties.pop('index_partition_contract')
            fixture.execution.setup_sqls = [old_sql[0].replace('ustore', 'astore')]
            with self.assertRaises(GenerationValidationError):
                self.generate()
        finally:
            fixture.execution.setup_sqls, p.properties = old_sql, old_props

    def test_tracking_gate_or_expectation_cannot_be_relaxed(self):
        self.generate()
        m = self.r.manifests[MID]
        gates = list(m.environment_requirements)
        scope = m.expected.scope
        try:
            m.environment_requirements = [g for g in gates if g.key != 'track_counts']
            with self.assertRaises(GenerationValidationError):
                self.generate()
            m.environment_requirements = gates
            m.expected.scope = 'syntax_and_semantics'
            with self.assertRaises(GenerationValidationError):
                self.generate()
        finally:
            m.environment_requirements, m.expected.scope = gates, scope

    def test_partition_source_is_not_a_foreign_fixture_prerequisite(self):
        self.assertIn('create_table_partition', self.r.factor_dependency_graph()['create_index'])
        self.assertNotIn('create_table_partition', self.r.factor_scheduling_graph()['create_index'])
        self.assertEqual(self.r.fixture_topological_order(['fixture_create_index_ustore_local_fresh']),
                         ['fixture_create_index_ustore_local_fresh'])
