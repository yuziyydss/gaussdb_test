"""DROP LLM uses one static model-name syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_llm_fresh_syntax'
MODEL='g_drop_llm'


class DropLLMFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_drop_llm_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,f'DROP LLM MODEL {MODEL};')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_privilege_and_compatibility_gates(self):
        cases,_=self.cases()
        case=cases[0]
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['llm_drop_privilege']['allowed_values'],['sysadmin'])
        self.assertIn('drop_llm_fact_body_8',
                      gates['llm_drop_privilege']['fact_refs'])
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['non_m'])
        self.assertIn('drop_llm_fact_body_9',
                      gates['compatibility_mode']['fact_refs'])
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_runtime_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_drop_llm_coverage'].documented_features}
        feature=features['drop_llm_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['drop_llm_model_name_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('drop_llm')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('drop_llm_feature_runtime',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
