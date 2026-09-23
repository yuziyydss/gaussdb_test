"""PREDICT BY uses one static syntax representative without model training."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_predict_by_fresh_syntax'
MODEL='g_predict_by_model'
TABLE='fp_model_houses_input'


class PredictByFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_predict_by_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,
            f'SELECT PREDICT BY {MODEL} (FEATURES size, lot) FROM {TABLE};')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_input_fixture_is_transaction_scoped_and_no_model_is_created(self):
        cases,_=self.cases()
        case=cases[0]
        self.assertEqual(case.setup_sqls[0],'BEGIN;')
        self.assertIn(f'CREATE TABLE {TABLE}',case.setup_sqls[1])
        self.assertIn(f'INSERT INTO {TABLE}',case.setup_sqls[2])
        self.assertEqual(case.teardown_sqls,['ROLLBACK;'])
        self.assertFalse(any('CREATE MODEL' in x or 'DROP MODEL' in x or 'CASCADE' in x
                              for x in case.setup_sqls+case.teardown_sqls))
        fixture=self.r.fixtures['fixture_create_model_training_input']
        self.assertEqual(fixture.provides.tables[0].name,TABLE)
        for phrase in ('独立新连接','无外层事务','不包含训练','不是实机验证'):
            self.assertIn(phrase,fixture.execution.note)

    def test_feature_and_audit_do_not_claim_model_behavior(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_predict_by_coverage'].documented_features}
        feature=features['predict_by_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'predict_by_model_name_fresh',
            'predict_by_features_size_lot',
            'predict_by_source_table_fixture',
        ])
        audit=FactorCoverageAuditor(self.r).audit('predict_by')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('predict_by_feature_model',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
