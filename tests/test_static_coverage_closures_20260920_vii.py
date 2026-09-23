"""DROP GROUP closes static coverage with an explicit tool-context limit."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_group_fresh_group'


class StaticCoverageClosureVIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.auditor=FactorCoverageAuditor(cls.r)

    def test_drop_group_closes_static_coverage_without_behavior(self):
        audit=self.auditor.audit('drop_group')
        self.assertTrue(audit['conclusions']['source_extraction_complete'])
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(audit['values']['coverage_gaps'],[])
        self.assertEqual(audit['documented_features']['coverage_gaps'],[])
        self.assertEqual(audit['facts']['unresolved'],[])

    def test_management_tool_context_is_an_explicit_environment_gate(self):
        cases,_=FactorPackageSQLGenerator(self.r).generate_with_report(self.r.manifests[MID])
        gates={g['key']:g for case in cases for g in case.environment_requirements}
        self.assertEqual(gates['management_tool_context']['allowed_values'],['authorized_isolated_tool_session'])
        fact=next(f for f in self.r.get_factor('drop_group').facts if f.id=='drop_group_fact_tool_contract')
        self.assertEqual((fact.type,fact.status),('environment','confirmed'))

    def test_two_if_exists_candidates_are_generated(self):
        cases,report=FactorPackageSQLGenerator(self.r).generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),2)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({case.sql for case in cases},{'DROP GROUP g_drop_group;','DROP GROUP IF EXISTS g_drop_group;'})


if __name__=='__main__':unittest.main()
