"""DROP PLUGGABLE DATABASE uses one static destructive syntax representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_pluggable_database_including_datafiles_fresh_syntax'
PDB='g_drop_pluggable_database'


class DropPluggableDatabaseFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_destructive_syntax_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,
                         f'DROP PLUGGABLE DATABASE {PDB} INCLUDING DATAFILES;')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_environment_gates_match_documented_boundaries(self):
        cases,_=self.cases()
        case=cases[0]
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['mtd']['allowed_values'],['on'])
        self.assertIn('drop_pluggable_database_including_datafiles_fact_mtd',
                      gates['mtd']['fact_refs'])
        self.assertEqual(gates['database_scope']['allowed_values'],['non_pdb_non_m'])
        self.assertIn('drop_pluggable_database_including_datafiles_fact_non_pdb_not_m',
                      gates['database_scope']['fact_refs'])
        self.assertEqual(gates['drop_pdb_privilege']['allowed_values'],
                         ['pdb_owner_or_sysadmin'])
        self.assertIn('drop_pluggable_database_including_datafiles_fact_privilege',
                      gates['drop_pdb_privilege']['fact_refs'])
        self.assertEqual(case.setup_sqls,[])
        self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_destructive_claim(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_drop_pluggable_database_including_datafiles_coverage'].documented_features}
        feature=features['drop_pluggable_database_including_datafiles_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'drop_pluggable_database_including_datafiles_pdb_name_dedicated',
        ])
        audit=FactorCoverageAuditor(self.r).audit('drop_pluggable_database_including_datafiles')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('drop_pluggable_database_including_datafiles_feature_drop_pdb',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
