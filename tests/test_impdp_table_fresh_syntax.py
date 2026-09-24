"""IMPDP TABLE uses keep-name and rename static syntax representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_impdp_table_fresh_syntax'
TABLE='g_impdp_table'; DIRECTORY='/tmp/gaussdb_static_import'; OWNER='g_impdp_owner'
EXPECTED={
    f"IMPDP TABLE SOURCE = '{DIRECTORY}' OWNER = {OWNER};",
    f"IMPDP TABLE AS {TABLE} SOURCE = '{DIRECTORY}' OWNER = {OWNER};",
}


class ImpdpTableFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_keep_name_and_rename_syntax_candidates_are_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),2)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED)
        self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_no_backup_tool_or_directory_fixture_is_attached(self):
        cases,_=self.cases()
        for case in cases:
            self.assertEqual(case.setup_sqls,[])
            self.assertEqual(case.teardown_sqls,[])
            self.assertEqual(case.environment_requirements,[])
            self.assertNotIn('mkdir',case.sql)
            self.assertNotIn('gs_restore',case.sql)
            self.assertNotIn('auxdb',case.sql)

    def test_syntax_feature_is_covered_without_restore_claim(self):
        self.cases()
        feature={f.id:f for f in self.r.matrices['matrix_impdp_table_coverage'].documented_features}['impdp_table_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'impdp_table_target_keep',
            'impdp_table_target_rename',
            'impdp_table_directory_path',
            'impdp_table_owner_dedicated',
        ])
        audit=FactorCoverageAuditor(self.r).audit('impdp_table')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('impdp_table_feature_physical_backup_restore',audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
