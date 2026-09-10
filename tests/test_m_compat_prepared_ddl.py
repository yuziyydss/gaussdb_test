"""Three bounded prepared DDL consumers, with actual chapter authority gates."""
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from scripts.build_m_compat_batch_03 import prepare, create_index
from scripts.build_m_compat_pilot import create_view
from scripts.build_m_compat_batch_06 import alter_table


EXPECTED = {
    'create_index': ("CREATE INDEX m_prepare_created_idx USING BTREE ON m_prepare_data (id)",
                     'm_create_index', 'create_any_index', ['id']),
    'create_view': ("CREATE VIEW m_prepare_created_view AS SELECT id,qty FROM m_prepare_data",
                    'm_create_view', 'create_any_table', ['id','qty']),
    'alter_relation': ("ALTER TABLE m_prepare_data ADD COLUMN extra INTEGER",
                       'm_alter_table', 'fixture_table_creator', []),
}


class PreparedDDLDefinitionTests(unittest.TestCase):
    def test_authority_is_an_exported_environment_fact_from_each_own_chapter(self):
        for builder, anchor in ((create_index, '2.4.2.8.11 L25-26'),
                                (create_view, '2.4.2.8.21 L16-16'),
                                (alter_table, '2.4.2.6.12 L9-12')):
            package = builder()
            fact = next(f for f in package.facts if f['id'] == package.fid('authority'))
            self.assertEqual(fact['source_anchor'], anchor)
            self.assertEqual(fact['type'], 'environment')
            self.assertIn(fact['id'], package.exports)

    def test_three_actual_profiles_do_not_close_other_body_families(self):
        package = prepare()
        matrix = package.files['matrices/body.matrix.yaml']
        self.assertEqual(len(matrix['profiles']), 17)
        self.assertEqual(sum(f['status'] == 'needs_profile' for f in matrix['documented_features']),5)
        for suffix, (sql, _, _, columns) in EXPECTED.items():
            profile = next(p for p in matrix['profiles'] if p['id'] == 'm_prepare_body_'+suffix)
            self.assertEqual(profile['render'], "'"+sql+"'")
            self.assertEqual(profile['properties']['source_tables'], ['m_prepare_data'])
            self.assertEqual(profile['properties']['source_columns'], columns)
            feature = next(f for f in matrix['documented_features'] if f['id'] == 'm_prepare_feature_body_'+suffix)
            self.assertEqual(feature['coverage_mode'], 'representative')
        self.assertEqual(package.files['manifests/finite.manifest.yaml']['bindings']['body'],
                         ['m_prepare_body_'+s for s in ('select','insert','update','delete')])


class PreparedDDLIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def test_actual_candidate_and_gate_not_just_a_paper_dependency(self):
        for suffix, (sql, provider, authority, _) in EXPECTED.items():
            manifest = self.registry.manifests['manifest_m_prepare_'+suffix]
            cases, report = self.generator.generate_with_report(manifest)
            self.assertEqual(len(cases),1)
            self.assertTrue(report.pairwise_complete)
            case = cases[0]
            self.assertEqual(case.sql, "PREPARE m_prepare_stmt FROM '"+sql+"';")
            self.assertEqual(case.setup_sqls, ['CREATE TABLE m_prepare_data (id INT,qty INT);',
                                             'INSERT INTO m_prepare_data VALUES (1,10),(2,20);'])
            self.assertEqual(case.teardown_sqls, ['DEALLOCATE PREPARE m_prepare_stmt;', 'DROP TABLE m_prepare_data;'])
            gates = {e['key']: e for e in case.environment_requirements}
            self.assertEqual(gates['compatibility_mode']['allowed_values'], ['M'])
            self.assertEqual(gates['session_lifecycle']['allowed_values'], ['isolated_connection'])
            self.assertEqual(gates['ddl_authority']['fact_refs'], [provider+'::'+provider+'_fact_authority'])
            self.assertEqual(gates['ddl_authority']['allowed_values'], [authority])
            self.assertEqual(case.expected_scope, 'syntax_only')
            self.assertNotIn('EXECUTE ', ' '.join(case.setup_sqls+[case.sql]))
            # Pure PREPARE must not run cleanup against never-created objects.
            self.assertNotIn('m_prepare_created_', ' '.join(case.setup_sqls+case.teardown_sqls))

    def test_actual_dependency_order_and_unfinished_coverage_are_retained(self):
        graph = self.registry.factor_dependency_graph()
        order = self.registry.factor_topological_order()
        for fid in ('m_create_index','m_create_view','m_alter_table'):
            self.assertIn(fid, graph['m_prepare'])
            self.assertLess(order.index(fid), order.index('m_prepare'))
        for fid in ('m_prepare','m_create_index','m_create_view','m_alter_table'):
            audit = FactorCoverageAuditor(self.registry).audit(fid)
            self.assertEqual(audit['facts']['wrong_consumer_type'], [], fid)
            self.assertFalse(audit['conclusions']['static_coverage_complete'])
            self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__ == '__main__':
    unittest.main()
