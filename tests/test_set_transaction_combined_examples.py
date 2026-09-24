"""SET TRANSACTION combined examples stay syntax-only."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
CASES={
 'manifest_set_transaction_combined_local':
   'SET LOCAL TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;',
 'manifest_set_transaction_combined_session':
   'SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;',
 'manifest_set_transaction_combined_global':
   'SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED READ ONLY;',
}


class SetTransactionCombinedExampleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_three_scope_combination_candidates_are_generated(self):
        for mid,sql in CASES.items():
            with self.subTest(manifest=mid):
                cases,report=self.g.generate_with_report(self.r.manifests[mid])
                self.assertEqual([case.sql for case in cases],[sql])
                self.assertTrue(report.pairwise_complete)
                self.assertEqual(cases[0].expected,'success')
                self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_session_and_global_b_mode_gates_are_preserved(self):
        session,_=self.g.generate_with_report(
            self.r.manifests['manifest_set_transaction_combined_session'])
        gates={g['key']:g for g in session[0].environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['B'])
        self.assertEqual(gates['b_format_behavior_compat_options']['allowed_values'],
                         ['set_session_transaction'])
        global_case,_=self.g.generate_with_report(
            self.r.manifests['manifest_set_transaction_combined_global'])
        gates={g['key']:g for g in global_case[0].environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['B'])

    def test_combined_example_closes_static_model_without_behavior_claim(self):
        for mid in CASES:
            self.g.generate_with_report(self.r.manifests[mid])
        audit=FactorCoverageAuditor(self.r).audit('set_transaction')
        self.assertTrue(audit['conclusions']['source_extraction_complete'])
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(audit['values']['coverage_gaps'],[])


if __name__=='__main__':unittest.main()
