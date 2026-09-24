"""AUTOHINT commands get non-executing static syntax representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
STATIC_CLOSED={'autohint', 'autohint_drop_model'}
CASES={
    'autohint':{
        'mid':'manifest_autohint_fresh_syntax',
        'sql':'AUTOHINT (ANALYZE FALSE) SELECT 1;',
        'matrix':'matrix_autohint_coverage',
        'feature':'autohint_feature_syntax',
        'values':['autohint_options_analyze_false','autohint_query_select_one'],
        'runtime':'autohint_feature_runtime',
    },
    'autohint_drop_model':{
        'mid':'manifest_autohint_drop_model_fresh_syntax',
        'sql':'AUTOHINT DROP MODEL SELECT 1;',
        'matrix':'matrix_autohint_drop_model_coverage',
        'feature':'autohint_drop_model_feature_syntax',
        'values':['autohint_drop_model_query_select_one'],
        'runtime':'autohint_drop_model_feature_runtime',
    },
}


class AutohintStaticSyntaxBatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_each_static_syntax_candidate_is_generated(self):
        for factor,cfg in CASES.items():
            with self.subTest(factor=factor):
                cases,report=self.g.generate_with_report(self.r.manifests[cfg['mid']])
                self.assertEqual([case.sql for case in cases],[cfg['sql']])
                self.assertTrue(report.pairwise_complete)
                self.assertEqual(cases[0].expected,'success')
                self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_no_query_execution_or_history_fixture_is_attached(self):
        for factor,cfg in CASES.items():
            with self.subTest(factor=factor):
                cases,_=self.g.generate_with_report(self.r.manifests[cfg['mid']])
                case=cases[0]
                self.assertEqual(case.setup_sqls,[])
                self.assertEqual(case.teardown_sqls,[])
                self.assertEqual(case.environment_requirements[0]['allowed_values'],['super_or_admin'])

    def test_syntax_feature_is_covered_and_runtime_gap_remains(self):
        for factor,cfg in CASES.items():
            with self.subTest(factor=factor):
                self.g.generate_with_report(self.r.manifests[cfg['mid']])
                features={f.id:f for f in self.r.matrices[cfg['matrix']].documented_features}
                feature=features[cfg['feature']]
                self.assertEqual(feature.status,'covered')
                self.assertIn(feature.coverage_mode,{'any','representative'})
                self.assertEqual(feature.value_refs,cfg['values'])
                audit=FactorCoverageAuditor(self.r).audit(factor)
                self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
                self.assertEqual(audit['conclusions']['static_coverage_complete'],factor in STATIC_CLOSED)
                if factor in STATIC_CLOSED:
                    self.assertNotIn(cfg['runtime'],audit['documented_features']['needs_profile'])
                else:
                    self.assertIn(cfg['runtime'],audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
