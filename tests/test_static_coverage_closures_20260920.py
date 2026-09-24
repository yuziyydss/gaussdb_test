"""Source-limited packages close static coverage without behavior claims."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
FACTORS=[
 'commit_end',
 'm_execute',
 'm_create_database',
 'm_create_schema',
 'm_set_transaction',
]


class StaticCoverageClosureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.auditor=FactorCoverageAuditor(cls.r)

    def test_five_packages_close_static_coverage_without_behavior(self):
        for factor in FACTORS:
            with self.subTest(factor=factor):
                audit=self.auditor.audit(factor)
                self.assertTrue(audit['conclusions']['source_extraction_complete'])
                self.assertTrue(audit['conclusions']['generation_model_complete'])
                self.assertTrue(audit['conclusions']['static_coverage_complete'])
                self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
                self.assertEqual(audit['values']['coverage_gaps'],[])
                self.assertEqual(audit['documented_features']['coverage_gaps'],[])
                self.assertEqual(audit['facts']['unresolved'],[])

    def test_source_limitations_remain_explicit(self):
        expected={
         'commit_end':'commit_end_open_cross_session_mechanism',
         'm_execute':'m_execute_fact_parameter_gap',
         'm_create_database':'m_create_database_fact_charset_description',
         'm_create_schema':'m_create_schema_fact_charset_description',
         'm_set_transaction':'m_set_transaction_fact_combined_gap',
        }
        for factor,fact_id in expected.items():
            with self.subTest(factor=factor):
                fact=next(f for f in self.r.get_factor(factor).facts if f.id==fact_id)
                self.assertEqual(fact.status,'confirmed')
                self.assertNotEqual(fact.type,'open_question')


if __name__=='__main__':unittest.main()
