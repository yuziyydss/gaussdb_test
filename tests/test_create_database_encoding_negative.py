"""Client-only encodings: generated negatives, deliberately uncalibrated."""
import unittest
from pathlib import Path

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.executor import ExecResult

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_create_database_client_encoding_negative'


class CreateDatabaseEncodingNegativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / 'specs')
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def generate(self):
        self.assertTrue(MID in self.r.manifests, MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_five_client_only_encodings_have_targeted_negative_candidates(self):
        cases, report = self.generate()
        encodings = {'BIG5', 'JOHAB', 'SHIFT_JIS_2004', 'SJIS', 'UHC'}
        self.assertEqual(len(cases), 5)
        self.assertEqual(len({c.case_id for c in cases}), 5)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases}, {
            "CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = '" + e +
            "' LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;"
            for e in encodings})
        self.assertEqual(self.r.manifests[MID].violates_rule_refs, ['create_database_rule_server_encoding'])

    def test_unknown_oracle_has_no_fabricated_sqlstate(self):
        cases, _ = self.generate()
        for case in cases:
            self.assertEqual(case.expected, 'error')
            self.assertEqual(case.expected_oracle_status, 'needs_verification')
            self.assertEqual(case.expected_error_category, 'database_encoding_not_server_supported')
            self.assertEqual(case.expected_sqlstates, [])
            self.assertEqual(case.expected_error_regex, '')

    def test_preflight_is_read_only_and_no_blanket_database_cleanup(self):
        cases, _ = self.generate()
        for case in cases:
            self.assertEqual(case.setup_sqls, [
                "SELECT 1 / (1 - COUNT(*)) AS assert_test_database_absent FROM pg_database WHERE datname = 'b8_database';"])
            self.assertEqual(case.teardown_sqls, [
                "SELECT 1 / (1 - COUNT(*)) AS assert_negative_database_absent FROM pg_database WHERE datname = 'b8_database';"])
            gates = {g['key']: g['allowed_values'] for g in case.environment_requirements}
            self.assertEqual(gates['createdb_authorized'], ['true'])
            self.assertEqual(gates['autocommit_no_transaction_block'], ['true'])

    def test_arbitrary_error_cannot_become_a_pass(self):
        cases, _ = self.generate()
        case = cases[0]
        for status, expected_verdict in [('error', 'pending'), ('fixture_error', 'fail'), ('cleanup_error', 'fail')]:
            result = ExecResult(case_id=case.case_id, sql=case.sql, status=status,
                                expected=case.expected, expected_oracle_status=case.expected_oracle_status,
                                actual_sqlstate='42501')
            result.compute_verdict()
            self.assertEqual(result.verdict, expected_verdict)

    def test_rule_discriminates_server_encoding_without_reclassifying_conditional(self):
        cases, _ = self.generate()
        resolved = self.r.resolve_dimension_values('create_database')
        normal = self.r.manifests['manifest_create_database_encoding_limit']
        solver = self.g._build_solver(self.r.factors['create_database'], normal, resolved)
        self.assertFalse(solver.is_valid(cases[0].params)[0])
        self.assertTrue(solver.is_valid(dict(cases[0].params, encoding='create_database_encoding_utf8'))[0])
        self.assertEqual(sum(v.validity == 'conditional' for v in resolved['encoding'].values()), 37)

    def test_value_coverage_does_not_hide_oracle_calibration_gap(self):
        self.generate()
        audit = FactorCoverageAuditor(self.r).audit('create_database')
        self.assertEqual(len(audit['values']['coverage_gaps']), 37)
        self.assertIn(MID, audit['manifests']['unresolved_error_oracles'])
        self.assertFalse(audit['conclusions']['generation_model_complete'])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__ == '__main__':
    unittest.main()
