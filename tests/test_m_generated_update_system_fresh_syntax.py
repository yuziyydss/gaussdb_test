"""M GENERATED UPDATE SYSTEM gets a fixed syntax-only representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_m_generated_update_system_fresh_syntax'


class MGeneratedUpdateSystemFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_fixed_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,'GENERATED UPDATE SYSTEM;')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_om_context_gates_are_explicit_and_no_fixture_runs(self):
        cases,_=self.cases()
        case=cases[0]
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['M'])
        self.assertEqual(gates['upgrade_context']['allowed_values'],['authoritative_OM_upgrade'])
        self.assertEqual(gates['initial_user_identity']['allowed_values'],['true'])
        self.assertEqual(gates['command_usage']['allowed_values'],['internal_static_review_only'])
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])

    def test_static_closes_without_behavior_claim(self):
        self.cases()
        audit=FactorCoverageAuditor(self.r).audit('m_generated_update_system')
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(audit['facts']['unresolved'],[])


if __name__=='__main__':unittest.main()
