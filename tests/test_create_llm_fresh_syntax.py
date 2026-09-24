"""CREATE LLM uses non-secret static syntax representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_create_llm_fresh_syntax'
OPTIONS="MODEL = 'static-syntax-model', URL = 'https://llm-static-syntax.invalid/path/to/api', API_KEY = 'STATIC_SYNTAX_ONLY_NOT_A_SECRET_0123456789'"
EXPECTED={
    f"CREATE LLM QUERY MODEL g_create_llm USING ({OPTIONS});",
    f"CREATE LLM EMBED MODEL g_create_llm USING ({OPTIONS});",
    f"CREATE LLM RERANK MODEL g_create_llm USING ({OPTIONS});",
}


class CreateLLMFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_three_model_kind_syntax_candidates_are_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),3)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED)
        self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_placeholder_is_non_secret_and_endpoint_is_non_resolving(self):
        cases,_=self.cases()
        for case in cases:
            self.assertEqual(case.setup_sqls,[])
            self.assertEqual(case.teardown_sqls,[])
            self.assertIn('STATIC_SYNTAX_ONLY_NOT_A_SECRET',case.sql)
            self.assertIn('https://llm-static-syntax.invalid',case.sql)
            self.assertNotIn("API_KEY = 'api_key'",case.sql)
            self.assertEqual(case.environment_requirements[0]['allowed_values'],['sysadmin'])

    def test_syntax_feature_is_covered_without_runtime_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_create_llm_coverage'].documented_features}
        feature=features['create_llm_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        audit=FactorCoverageAuditor(self.r).audit('create_llm')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('create_llm_feature_runtime',
                         audit['documented_features']['coverage_gaps'])


if __name__=='__main__':unittest.main()
