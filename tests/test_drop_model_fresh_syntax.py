"""DROP MODEL uses one static syntax representative without model deletion."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_model_fresh_syntax'
MODEL='g_drop_model'


class DropModelFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_drop_model_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,f'DROP MODEL {MODEL};')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_no_fixture_or_model_lifecycle_is_attached(self):
        cases,_=self.cases()
        case=cases[0]
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])
        self.assertEqual(case.environment_requirements,[])
        self.assertFalse(any('CREATE MODEL' in x or 'DROP TABLE' in x
                              for x in case.setup_sqls+case.teardown_sqls))

    def test_syntax_feature_is_covered_without_model_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_drop_model_coverage'].documented_features}
        feature=features['drop_model_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['drop_model_model_name_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('drop_model')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('drop_model_feature_model',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
