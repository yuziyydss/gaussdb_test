"""ALTER SYSTEM SET uses one static resource plan syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_alter_system_set_fresh_syntax'
PLAN='g_alter_system_set_plan'


class AlterSystemSetFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_resource_plan_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,
                         f"ALTER SYSTEM SET resource_manager_plan TO '{PLAN}';")
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_environment_gates_match_documented_boundaries(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['alter_system_privilege']['allowed_values'],
                         ['initial_user_or_sysadmin'])
        self.assertIn('alter_system_set_fact_privilege',
                      gates['alter_system_privilege']['fact_refs'])
        self.assertEqual(gates['database_scope']['allowed_values'],['non_pdb'])
        self.assertIn('alter_system_set_fact_non_pdb',
                      gates['database_scope']['fact_refs'])
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['non_m'])
        self.assertIn('alter_system_set_fact_not_m',
                      gates['compatibility_mode']['fact_refs'])
        self.assertEqual(cases[0].setup_sqls,[])
        self.assertEqual(cases[0].teardown_sqls,[])

    def test_syntax_feature_is_covered_without_resource_switch_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_alter_system_set_coverage'].documented_features}
        feature=features['alter_system_set_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['alter_system_set_plan_name_dedicated'])
        audit=FactorCoverageAuditor(self.r).audit('alter_system_set')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('alter_system_set_feature_resource_plan_switch',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
