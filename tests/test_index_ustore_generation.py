"""Generation must consume actual USTORE RANGE DDL, tracking and target shape."""
import copy
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_create_index_ustore_local_fresh'


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
