"""M CREATE INDEX finite key contract; uncalibrated fillfactor negative archived."""
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry

ROOT=Path(__file__).resolve().parents[1]


class MIndexFillfactorContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry=FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()
        cls.generator=FactorPackageSQLGenerator(cls.registry)

    def test_finite_positive_manifest_is_generated(self):
        cases,report=self.generator.generate_with_report(
            self.registry.manifests['manifest_m_create_index_finite'])
        self.assertEqual(len(cases),17)
        self.assertTrue(report.pairwise_complete)
        for case in cases:
            self.assertTrue(case.sql.startswith('CREATE '))
            self.assertNotIn('FILLFACTOR = 9',case.sql)

    def test_fillfactor_negative_is_archived_not_active(self):
        mid='manifest_m_create_index_fillfactor_below'
        self.assertNotIn(mid,self.registry.manifests)
        path=ROOT/'archive/spec_reviews/20260923/generated_sql/m_create_index'/f'{mid}.sql'
        self.assertTrue(path.is_file())
        self.assertIn('fillfactor=9',path.read_text())

    def test_static_closure_keeps_behavior_boundary_false(self):
        audit=FactorCoverageAuditor(self.registry).audit('m_create_index')
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__=='__main__':
    unittest.main()
