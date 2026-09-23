"""Four source-conflict packages close static coverage without behavior claims."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
FACTORS=[
 'm_alter_session',
 'm_select_into',
 'm_table',
 'm_truncate',
]
EXPECTED_FACTS={
 'm_alter_session':['m_alter_session_fact_schema_conflict','m_alter_session_fact_transaction_braces'],
 'm_select_into':['m_select_into_fact_duplicate_into'],
 'm_table':['m_table_fact_scalar_scope'],
 'm_truncate':['m_truncate_fact_source_conflict'],
}


class StaticCoverageClosureIIITests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.auditor=FactorCoverageAuditor(cls.r)

    def test_four_packages_close_static_coverage_without_behavior(self):
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

    def test_source_conflicts_become_confirmed_modeling_limits(self):
        for factor,fact_ids in EXPECTED_FACTS.items():
            with self.subTest(factor=factor):
                facts={f.id:f for f in self.r.get_factor(factor).facts}
                for fact_id in fact_ids:
                    fact=facts[fact_id]
                    self.assertEqual(fact.status,'confirmed')
                    self.assertNotEqual(fact.type,'open_question')


if __name__=='__main__':unittest.main()
