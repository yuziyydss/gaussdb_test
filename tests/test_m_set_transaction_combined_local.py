"""M SET TRANSACTION combined local example stays syntax-only."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_m_set_transaction_combined_local'


class MSetTransactionCombinedLocalTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_one_combined_local_candidate_is_generated(self):
        cases,report=self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,
                         'SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_static_closes_without_behavior_claim(self):
        self.g.generate_with_report(self.r.manifests[MID])
        audit=FactorCoverageAuditor(self.r).audit('m_set_transaction')
        self.assertTrue(audit['conclusions']['source_extraction_complete'])
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(audit['values']['coverage_gaps'],[])


if __name__=='__main__':unittest.main()
