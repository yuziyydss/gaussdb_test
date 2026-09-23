"""DROP WEAK PASSWORD DICTIONARY uses one fixed static syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_weak_password_dictionary_fresh_syntax'


class DropWeakPasswordDictionaryFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_fixed_command_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,'DROP WEAK PASSWORD DICTIONARY;')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_privilege_gate_and_no_dictionary_clear(self):
        cases,_=self.cases()
        case=cases[0]
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['weak_password_dictionary_privilege']['allowed_values'],
                         ['initial_user_sysadmin_or_security_admin'])
        self.assertIn('drop_weak_password_dictionary_fact_privilege',
                      gates['weak_password_dictionary_privilege']['fact_refs'])
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_security_restore_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_drop_weak_password_dictionary_coverage'].documented_features}
        feature=features['drop_weak_password_dictionary_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['drop_weak_password_dictionary_command_fixed'])
        audit=FactorCoverageAuditor(self.r).audit('drop_weak_password_dictionary')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('drop_weak_password_dictionary_feature_global_dictionary_clear',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
