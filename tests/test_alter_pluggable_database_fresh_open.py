"""ALTER PLUGGABLE DATABASE covers finite OPEN/CLOSE syntax representatives."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_alter_pluggable_database_fresh_open'; PDB='g_alter_pluggable_database'
EXPECTED={f'ALTER PLUGGABLE DATABASE {PDB} OPEN;',f'ALTER PLUGGABLE DATABASE {PDB} CLOSE;',f'ALTER PLUGGABLE DATABASE {PDB} CLOSE IMMEDIATE;'}


class AlterPluggableDatabaseFreshOpenTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all();cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertIn(MID,self.r.manifests);return self.g.generate_with_report(self.r.manifests[MID])

    def test_three_open_close_action_candidates_are_generated(self):
        cases,report=self.cases();self.assertEqual(len(cases),3);self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},EXPECTED)
        self.assertTrue(all(case.expected=='success' and case.expected_scope=='syntax_only' for case in cases))

    def test_environment_gates_match_documented_boundaries(self):
        cases,_=self.cases()
        for case in cases:
            gates={g['key']:g for g in case.environment_requirements}
            self.assertEqual(gates['mtd']['allowed_values'],['on']);self.assertEqual(gates['database_scope']['allowed_values'],['non_pdb_non_m'])
            self.assertEqual(gates['alter_pdb_privilege']['allowed_values'],['pdb_owner_or_sysadmin']);self.assertEqual(gates['resource_plan_directive']['allowed_values'],['present'])
            self.assertEqual(case.setup_sqls,[]);self.assertEqual(case.teardown_sqls,[])

    def test_syntax_feature_is_covered_without_state_machine_claim(self):
        self.cases();feature={f.id:f for f in self.r.matrices['matrix_alter_pluggable_database_coverage'].documented_features}['alter_pluggable_database_feature_syntax']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['alter_pluggable_database_pdb_name_dedicated','alter_pluggable_database_action_a0','alter_pluggable_database_action_a1','alter_pluggable_database_action_a2'])
        audit=FactorCoverageAuditor(self.r).audit('alter_pluggable_database');self.assertFalse(audit['conclusions']['behavior_coverage_complete']);self.assertTrue(audit['conclusions']['static_coverage_complete']);self.assertNotIn('alter_pluggable_database_feature_pdb_state_machine',audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
