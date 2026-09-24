"""TIMECAPSULE DATABASE uses one static database-name syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_timecapsule_database_fresh_syntax'
DB='g_timecapsule_database'


class TimecapsuleDatabaseFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_timecapsule_database_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,f'TIMECAPSULE DATABASE {DB} TO BEFORE DROP;')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_recovery_privilege_gate_and_no_rename(self):
        cases,_=self.cases()
        case=cases[0]
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['database_recovery_privilege']['allowed_values'],
                         ['admin_or_target_create_privilege'])
        self.assertIn('timecapsule_database_fact_body_43',
                      gates['database_recovery_privilege']['fact_refs'])
        self.assertNotIn('RENAME TO',case.sql)
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_recovery_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_timecapsule_database_coverage'].documented_features}
        feature=features['timecapsule_database_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'timecapsule_database_database_name_fresh',
            'timecapsule_database_rename_none',
        ])
        audit=FactorCoverageAuditor(self.r).audit('timecapsule_database')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('timecapsule_database_feature_runtime',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
