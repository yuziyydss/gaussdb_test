"""Preparing TRUNCATE is distinct from executing it and observing empty data."""
from pathlib import Path
import unittest

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from scripts.build_m_compat_batch_02 import truncate
from scripts.build_m_compat_batch_03 import prepare


class PreparedTruncateDefinitionTests(unittest.TestCase):
    def test_owner_and_purge_are_exported_from_real_m_truncate_source(self):
        package = truncate()
        facts = {f['id']: f for f in package.facts}
        for suffix, kind, anchor in [('owner', 'environment', 'L12-14'),
                                     ('purge', 'behavior_oracle', 'L54-54'),
                                     ('rows_removed', 'behavior_oracle', 'L22-22')]:
            fact = facts[package.fid(suffix)]
            self.assertEqual(fact['type'], kind)
            self.assertEqual(fact['source_anchor'], '2.4.2.17.3 '+anchor)
            self.assertIn(fact['id'], package.exports)
        self.assertEqual(facts[package.fid('source_conflict')]['status'], 'needs_verification')

    def test_remaining_families_not_erased_and_original_bindings_unchanged(self):
        package = prepare()
        matrix = package.files['matrices/body.matrix.yaml']
        self.assertEqual(len(matrix['profiles']), 17)
        features = {f['id']: f for f in matrix['documented_features']}
        self.assertEqual(sum(f['status'] == 'needs_profile' for f in features.values()), 5)
        feature = features['m_prepare_feature_body_truncate']
        self.assertEqual(feature['coverage_mode'], 'representative')
        self.assertEqual(feature['profile_refs'], ['m_prepare_body_truncate'])
        self.assertEqual(package.files['manifests/finite.manifest.yaml']['bindings']['body'],
                         ['m_prepare_body_'+s for s in ('select', 'insert', 'update', 'delete')])


class PreparedTruncateIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def test_actual_candidate_only_prepares_owned_seeded_table_truncate(self):
        manifest = self.registry.manifests['manifest_m_prepare_truncate']
        cases, report = self.generator.generate_with_report(manifest)
        self.assertEqual(len(cases), 1)
        self.assertTrue(report.pairwise_complete)
        case = cases[0]
        self.assertEqual(case.sql, "PREPARE m_prepare_stmt FROM 'TRUNCATE TABLE m_prepare_data PURGE';")
        self.assertEqual(case.setup_sqls, ['CREATE TABLE m_prepare_data (id INT,qty INT);',
                                         'INSERT INTO m_prepare_data VALUES (1,10),(2,20);'])
        self.assertEqual(case.teardown_sqls, ['DEALLOCATE PREPARE m_prepare_stmt;', 'DROP TABLE m_prepare_data;'])
        gates = {g['key']: g for g in case.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'], ['M'])
        self.assertEqual(gates['session_lifecycle']['allowed_values'], ['isolated_connection'])
        self.assertEqual(gates['table_authority']['allowed_values'], ['fixture_table_creator'])
        self.assertEqual(gates['table_authority']['fact_refs'], ['m_truncate::m_truncate_fact_owner'])
        self.assertNotIn('EXECUTE ', ' '.join(case.setup_sqls+[case.sql]))

    def test_planned_oracle_separates_prepare_and_execute_and_keeps_real_dependency(self):
        scenario = self.registry.scenarios['scenario_m_prepare_truncate_execution']
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual([step['id'] for step in scenario.steps], ['prepare', 'before_execute', 'execute', 'after_execute'])
        self.assertEqual([o['expected'] for o in scenario.oracles], [[[2]], [[0]]])
        self.assertEqual([o['step_id'] for o in scenario.oracles], ['before_execute', 'after_execute'])
        self.assertIn('m_truncate::m_truncate_fact_rows_removed', scenario.fact_refs)
        self.assertIn('m_truncate::m_truncate_fact_purge', scenario.fact_refs)
        self.assertIn('m_truncate', self.registry.factor_dependency_graph()['m_prepare'])
        for fid in ('m_prepare', 'm_truncate'):
            audit = FactorCoverageAuditor(self.registry).audit(fid)
            self.assertEqual(audit['facts']['wrong_consumer_type'], [])
            self.assertTrue(audit['conclusions']['static_coverage_complete'])
            self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__ == '__main__':
    unittest.main()
