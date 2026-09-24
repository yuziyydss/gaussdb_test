"""CREATE MODEL uses one static logistic_regression syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_create_model_fresh_logistic'
MODEL='g_create_model_price'
TABLE='fp_model_houses_input'


class CreateModelFreshLogisticTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_logistic_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,
            f'CREATE MODEL {MODEL} USING logistic_regression '
            f'FEATURES size, lot TARGET mark FROM {TABLE} '
            'WITH learning_rate=0.88, max_iterations=default;')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_training_input_fixture_is_transaction_scoped(self):
        cases,_=self.cases()
        case=cases[0]
        self.assertEqual(case.setup_sqls[0],'BEGIN;')
        self.assertIn(f'CREATE TABLE {TABLE}',case.setup_sqls[1])
        self.assertIn(f'INSERT INTO {TABLE}',case.setup_sqls[2])
        self.assertEqual(case.teardown_sqls,['ROLLBACK;'])
        self.assertFalse(any('DROP MODEL' in x or 'CASCADE' in x or 'DROP OWNED' in x
                              for x in case.setup_sqls+case.teardown_sqls))
        fixture=self.r.fixtures['fixture_create_model_training_input']
        self.assertEqual(fixture.provides.tables[0].name,TABLE)
        for phrase in ('独立新连接','无外层事务','不包含训练','不是实机验证'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_and_audit_do_not_claim_training(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['statement_timeout']['allowed_values'],['0'])
        self.assertIn('create_model_fact_body_8_1',
                      gates['statement_timeout']['fact_refs'])
        features={f.id:f for f in self.r.matrices['matrix_create_model_coverage'].documented_features}
        feature=features['create_model_feature_logistic_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'create_model_architecture_logistic',
            'create_model_model_name_fresh',
            'create_model_features_size_lot',
            'create_model_target_mark',
            'create_model_training_source_fixture',
            'create_model_hyperparameters_example',
        ])
        audit=FactorCoverageAuditor(self.r).audit('create_model')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('create_model_feature_runtime',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
