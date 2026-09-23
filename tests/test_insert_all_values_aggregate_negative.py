"""INSERT ALL aggregate-in-VALUES negative uses a source-confirmed error."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_insert_all_values_aggregate_negative'


class InsertAllValuesAggregateNegativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_one_aggregate_values_negative_candidate_is_generated(self):
        self.assertIn(MID,self.r.manifests)
        cases,report=self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        case=cases[0]
        self.assertEqual(case.sql,
            "INSERT ALL INTO fp_cs_one.b11_ia_a (col_1,col_2) "
            "VALUES (max(col_1),'a') "
            "SELECT col_1,col_2 FROM fp_cs_one.b11_ia_source;")
        self.assertEqual(case.expected,'error')
        self.assertEqual(case.expected_scope,'syntax_and_semantics')
        self.assertEqual(case.expected_oracle_status,'confirmed')
        self.assertEqual(case.expected_error_category,'aggregate_function_in_values')
        self.assertEqual(case.expected_error_regex,'An aggregate function cannot be used in VALUES')

    def test_rule_is_targeted_and_fixture_is_transaction_scoped(self):
        cases,_=self.g.generate_with_report(self.r.manifests[MID])
        case=cases[0]
        self.assertIn('BEGIN;',case.setup_sqls)
        self.assertIn('CREATE TABLE fp_cs_one.b11_ia_source', '\n'.join(case.setup_sqls))
        self.assertIn('ROLLBACK;',case.teardown_sqls)
        rule=self.r.get_factor('insert_all').rules[0]
        self.assertEqual(rule.id,'insert_all_rule_values_no_aggregate')

    def test_negative_feature_remains_open_for_other_branches(self):
        self.g.generate_with_report(self.r.manifests[MID])
        audit=FactorCoverageAuditor(self.r).audit('insert_all')
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('insert_all_fact_negative_oracle',audit['facts']['unresolved'])
        self.assertNotIn('insert_all_feature_negative_and_nested',
                         audit['documented_features']['coverage_gaps'])


if __name__=='__main__':unittest.main()
