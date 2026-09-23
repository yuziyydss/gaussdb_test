"""INSERT ALL view-target negative uses a source-confirmed error."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_insert_all_view_target_negative'


class InsertAllViewTargetNegativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_one_view_target_negative_candidate_is_generated(self):
        self.assertIn(MID,self.r.manifests)
        cases,report=self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        case=cases[0]
        self.assertEqual(case.sql,
            "INSERT ALL INTO fp_cs_one.b11_ia_view (col_1,col_2) "
            "VALUES (col_1,col_2) "
            "SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;")
        self.assertEqual(case.expected,'error')
        self.assertEqual(case.expected_scope,'syntax_and_semantics')
        self.assertEqual(case.expected_oracle_status,'confirmed')
        self.assertEqual(case.expected_error_category,'view_target_not_allowed')
        self.assertEqual(case.expected_error_regex,'Not allowed to insert into view')

    def test_view_fixture_is_transaction_scoped_and_rule_is_targeted(self):
        cases,_=self.g.generate_with_report(self.r.manifests[MID])
        case=cases[0]
        setup='\n'.join(case.setup_sqls)
        self.assertIn('BEGIN;',setup)
        self.assertIn('CREATE TABLE fp_cs_one.b11_ia_source',setup)
        self.assertIn('CREATE VIEW fp_cs_one.b11_ia_view',setup)
        self.assertIn('ROLLBACK;',case.teardown_sqls)
        rule=next(r for r in self.r.get_factor('insert_all').rules
                  if r.id=='insert_all_rule_target_not_view')
        self.assertEqual(rule.expression,"targets != 'insert_all_targets_view'")

    def test_remaining_negative_branches_stay_open(self):
        self.g.generate_with_report(self.r.manifests[MID])
        audit=FactorCoverageAuditor(self.r).audit('insert_all')
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertEqual(audit['documented_features']['coverage_gaps'],[])
        self.assertNotIn('insert_all_fact_negative_oracle',audit['facts']['unresolved'])
        self.assertNotIn('insert_all_feature_negative_and_nested',
                         audit['documented_features']['needs_profile'])


if __name__=='__main__':unittest.main()
