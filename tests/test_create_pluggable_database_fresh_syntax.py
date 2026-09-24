"""CREATE PLUGGABLE DATABASE covers finite standalone option syntax forms."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]; MID='manifest_create_pluggable_database_fresh_syntax'; PDB='g_create_pluggable_database'
OPTIONS=['',"ENCODING = 'UTF8'","DBCOMPATIBILITY = 'A'","DBCOMPATIBILITY = 'C'","DBCOMPATIBILITY = 'PG'","DBCOMPATIBILITY = 'M'","LC_COLLATE = 'C'","LC_CTYPE = 'C'","DBTIMEZONE = 'PRC'"]
EXPECTED={f'CREATE PLUGGABLE DATABASE {PDB} {option};'.replace(' ;',';') for option in OPTIONS}


class CreatePluggableDatabaseFreshSyntaxTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests);return self.g.generate_with_report(self.r.manifests[MID])

    def test_nine_standalone_option_candidates_are_generated(self):
        cases,report=self.cases();self.assertEqual(len(cases),9);self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED);self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_environment_gates_match_documented_boundaries(self):
        cases,_=self.cases()
        for case in cases:
            gates={g['key']:g for g in case.environment_requirements};self.assertEqual(gates['mtd']['allowed_values'],['on']);self.assertEqual(gates['database_scope']['allowed_values'],['non_pdb']);self.assertEqual(gates['transaction_scope']['allowed_values'],['outside_transaction']);self.assertEqual(gates['create_pdb_privilege']['allowed_values'],['gs_role_create_pdb_or_sysadmin'])
            self.assertEqual(case.setup_sqls,[]);self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_resource_lifecycle_claim(self):
        self.cases();feature={f.id:f for f in self.r.matrices['matrix_create_pluggable_database_coverage'].documented_features}['create_pluggable_database_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['create_pluggable_database_pdb_name_dedicated','create_pluggable_database_option_none','create_pluggable_database_option_utf8','create_pluggable_database_option_compat_A','create_pluggable_database_option_compat_C','create_pluggable_database_option_compat_PG','create_pluggable_database_option_compat_M','create_pluggable_database_option_collate','create_pluggable_database_option_ctype','create_pluggable_database_option_timezone'])
        audit=FactorCoverageAuditor(self.r).audit('create_pluggable_database');self.assertFalse(audit['conclusions']['behavior_coverage_complete']);self.assertTrue(audit['conclusions']['static_coverage_complete'])
        for feature_id in ('create_pluggable_database_feature_pdb_create','create_pluggable_database_feature_with_option_combinations','create_pluggable_database_feature_timezone_environment','create_pluggable_database_feature_name_and_128_boundaries'):self.assertNotIn(feature_id,audit['documented_features']['coverage_gaps'])


if __name__=='__main__':unittest.main()
