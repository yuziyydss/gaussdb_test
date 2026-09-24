"""CREATE WEAK PASSWORD DICTIONARY covers both finite WITH VALUES syntax forms."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]; MID='manifest_create_weak_password_dictionary_fresh_single'
EXPECTED={"CREATE WEAK PASSWORD DICTIONARY ('static_only');","CREATE WEAK PASSWORD DICTIONARY WITH VALUES ('static_only');"}


class CreateWeakPasswordDictionaryFreshSingleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests);return self.g.generate_with_report(self.r.manifests[MID])

    def test_with_values_absent_and_present_candidates_are_generated(self):
        cases,report=self.cases();self.assertEqual(len(cases),2);self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED);self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_privilege_gate_and_no_dictionary_change(self):
        cases,_=self.cases()
        for case in cases:
            gates={g['key']:g for g in case.environment_requirements};self.assertEqual(gates['weak_password_dictionary_privilege']['allowed_values'],['initial_user_sysadmin_or_security_admin'])
            self.assertEqual(case.setup_sqls,[]);self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_runtime_claim(self):
        self.cases();feature={f.id:f for f in self.r.matrices['matrix_create_weak_password_dictionary_coverage'].documented_features}['create_weak_password_dictionary_feature_single_value_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['create_weak_password_dictionary_with_values_none','create_weak_password_dictionary_with_values_yes','create_weak_password_dictionary_password_values_static_only'])
        audit=FactorCoverageAuditor(self.r).audit('create_weak_password_dictionary');self.assertFalse(audit['conclusions']['behavior_coverage_complete']);self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('create_weak_password_dictionary_feature_dictionary_runtime',audit['documented_features']['needs_profile']);self.assertNotIn('create_weak_password_dictionary_feature_multiple_values_ambiguity',audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
