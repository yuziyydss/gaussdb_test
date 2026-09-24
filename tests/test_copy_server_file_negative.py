"""COPY server-file negative uses a source-confirmed security error."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_copy_server_file_negative'


class CopyServerFileNegativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_one_server_file_negative_candidate_is_generated(self):
        self.assertIn(MID,self.r.manifests)
        cases,report=self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        case=cases[0]
        self.assertEqual(case.sql,
                         "COPY fp_cs_one.b11_copy_source "
                         "FROM '/tmp/gaussdb_copy_static_input.csv';")
        self.assertEqual(case.expected,'error')
        self.assertEqual(case.expected_scope,'syntax_and_semantics')
        self.assertEqual(case.expected_oracle_status,'confirmed')
        self.assertEqual(case.expected_error_category,'server_file_copy_prohibited')
        self.assertEqual(case.expected_error_regex,
                         'COPY to or from a file is prohibited for security concerns')

    def test_authority_gate_and_rule_are_explicit(self):
        cases,_=self.g.generate_with_report(self.r.manifests[MID])
        case=cases[0]
        gates={g['key']:g for g in case.environment_requirements}
        self.assertEqual(gates['server_file_copy_authorization']['allowed_values'],
                         ['disabled_for_non_initial_user_without_role'])
        self.assertIn('copy_fact_body_997',
                      gates['server_file_copy_authorization']['fact_refs'])
        self.assertIn('copy_fact_body_1003',
                      gates['server_file_copy_authorization']['fact_refs'])
        rule=next(r for r in self.r.get_factor('copy').rules
                  if r.id=='copy_rule_server_file_requires_authority')
        self.assertEqual(rule.expression,"direction != 'copy_direction_server_file'")

    def test_runtime_file_and_stream_gaps_remain_open(self):
        self.g.generate_with_report(self.r.manifests[MID])
        audit=FactorCoverageAuditor(self.r).audit('copy')
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn('copy_fact_boundary_protocol',audit['facts']['unresolved'])
        self.assertNotIn('copy_fact_stream_contract',audit['facts']['unresolved'])
        self.assertNotIn('copy_feature_stream_and_import',
                         audit['documented_features']['needs_profile'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__=='__main__':unittest.main()
