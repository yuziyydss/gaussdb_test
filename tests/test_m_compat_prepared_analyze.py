"""One actual ordinary-table ANALYZE representative, never a database execution."""
import unittest
from pathlib import Path

from scripts.build_m_compat_batch_03 import prepare
from scripts.build_m_compat_batch_05 import analyze
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor


class PreparedAnalyzeDefinitionTests(unittest.TestCase):
    def test_documented_analyze_has_real_profile_without_erasing_other_gaps(self):
        p = prepare()
        matrix = p.files['matrices/body.matrix.yaml']
        features = {f['id']: f for f in matrix['documented_features']}
        feature = features['m_prepare_feature_body_analyze']
        self.assertEqual(feature['status'], 'covered')
        self.assertEqual(feature['coverage_mode'], 'representative')
        self.assertEqual(feature['profile_refs'], ['m_prepare_body_analyze'])
        self.assertEqual(sum(f['status'] == 'needs_profile' for f in features.values()), 7)
        self.assertEqual(len(matrix['profiles']), 12)
        self.assertEqual(p.files['manifests/finite.manifest.yaml']['bindings']['body'],
                         ['m_prepare_body_'+s for s in ('select', 'insert', 'update', 'delete')])

    def test_environment_facts_are_exported_from_the_actual_analyze_chapter(self):
        p = analyze()
        facts = {f['id']: f for f in p.facts}
        for suffix, anchor in [('transaction', 'L49-50'), ('owner', 'L63-67'),
                               ('row_storage', 'L151-151')]:
            fact = facts[p.fid(suffix)]
            self.assertIn(fact['id'], p.exports)
            self.assertEqual(fact['type'], 'environment')
            self.assertEqual(fact['source_anchor'], '2.4.2.6.17 '+anchor)


class PreparedAnalyzeIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def test_new_manifest_generates_only_one_owned_row_table_prepare(self):
        manifest = self.registry.manifests['manifest_m_prepare_analyze']
        cases = self.generator.generate_cases_for_manifest(manifest)
        self.assertEqual(len(cases), 1)
        case = cases[0]
        self.assertEqual(case.sql, "PREPARE m_prepare_stmt FROM 'ANALYZE m_prepare_data';")
        self.assertEqual(case.setup_sqls, [
            'CREATE TABLE m_prepare_data (id INT,qty INT) WITH (ORIENTATION = ROW);',
            'INSERT INTO m_prepare_data VALUES (1,10),(2,20);'])
        self.assertEqual(case.teardown_sqls, ['DEALLOCATE PREPARE m_prepare_stmt;',
                                            'DROP TABLE m_prepare_data;'])
        gates = {g['key']: g for g in case.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'], ['M'])
        self.assertEqual(gates['session_lifecycle']['allowed_values'], ['isolated_connection'])
        for key, suffix in [('table_authority', 'owner'), ('execution_context', 'transaction'),
                            ('table_storage', 'row_storage')]:
            self.assertEqual(gates[key]['fact_refs'], ['m_analyze::m_analyze_fact_'+suffix])
        self.assertEqual(gates['table_authority']['allowed_values'], ['fixture_table_creator'])
        self.assertEqual(gates['execution_context']['allowed_values'], ['ordinary_analyze_prepare'])
        self.assertEqual(gates['table_storage']['allowed_values'], ['row'])

    def test_dependency_and_audit_do_not_claim_whole_chapter_or_execution(self):
        self.assertIn('m_analyze', self.registry.factor_dependency_graph()['m_prepare'])
        order = self.registry.factor_topological_order()
        self.assertLess(order.index('m_analyze'), order.index('m_prepare'))
        for fid in ('m_analyze', 'm_prepare'):
            result = FactorCoverageAuditor(self.registry).audit(fid)
            self.assertEqual(result['facts']['wrong_consumer_type'], [], fid)
            self.assertFalse(result['conclusions']['static_coverage_complete'])
            self.assertFalse(result['conclusions']['behavior_coverage_complete'])


if __name__ == '__main__':
    unittest.main()
