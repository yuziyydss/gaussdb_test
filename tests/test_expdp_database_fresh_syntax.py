"""EXPDP DATABASE uses one static syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_expdp_database_fresh_syntax'
DB='g_expdp_database'
DIRECTORY='/tmp/gaussdb_static_export'


class ExpdpDatabaseFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_static_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,
                         f"EXPDP DATABASE {DB} LOCATION = '{DIRECTORY}';")
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_no_backup_tool_or_directory_fixture_is_attached(self):
        cases,_=self.cases()
        case=cases[0]
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])
        self.assertEqual(case.environment_requirements,[])
        self.assertNotIn('mkdir',case.sql)
        self.assertNotIn('gs_dump',case.sql)
        self.assertNotIn('auxdb',case.sql)

    def test_syntax_feature_is_covered_without_backup_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_expdp_database_coverage'].documented_features}
        feature=features['expdp_database_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'expdp_database_db_name_dedicated',
            'expdp_database_directory_path',
        ])
        audit=FactorCoverageAuditor(self.r).audit('expdp_database')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('expdp_database_feature_physical_backup_restore',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
