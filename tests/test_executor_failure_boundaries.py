"""Mock-only: failure never widens namespace or prepared-object authority."""
import hashlib
from pathlib import Path
import unittest
from unittest.mock import Mock

from core.executor import Executor, ExecConfig
from core.generator import GeneratedCase


class ExecutorFailureBoundaryTests(unittest.TestCase):
    def engine(self, fail=None, *, enabled=True, sandbox=True):
        e = Executor(ExecConfig(enabled=enabled, use_sandbox=sandbox, environment_capabilities={}))
        e.connect = Mock(side_effect=AssertionError('REAL DATABASE FORBIDDEN'))
        e._conn = Mock()
        cursor, calls = Mock(), []
        def execute(sql):
            calls.append(sql)
            if fail and fail(sql):
                # A deliberately synthetic target code, never real GaussDB calibration.
                class MockFailure(Exception):
                    pgcode = '42P05'
                raise MockFailure('mock phase failure')
        cursor.execute.side_effect = execute
        e._conn.cursor.return_value = cursor
        e._check_alive = Mock(return_value=True)
        self.addCleanup(e.connect.assert_not_called)
        return e, cursor, calls

    def case(self, sql='SELECT 7;', *, expected='success', teardown=True):
        return GeneratedCase('failure_boundary_probe', 'mock-only', 'full', {}, sql,
            expected=expected, expected_sqlstates=['42P05'] if expected=='error' else [],
            setup_sqls=['CREATE TABLE owned_source(id INTEGER);'],
            teardown_sqls=['DROP TABLE owned_source;'] if teardown else [])

    def test_create_sandbox_failure_blocks_every_case_and_all_cleanup(self):
        e, cursor, calls = self.engine(lambda s: s.startswith('CREATE SCHEMA '))
        cases = [self.case(), self.case('SELECT 8;', expected='error')]
        results = e.execute_batch(cases)
        self.assertEqual(len(results), 2)
        self.assertEqual(len(calls), 1, calls)
        self.assertEqual([(r.status, r.verdict) for r in results], [('fixture_error', 'fail')]*2)
        for case, r in zip(cases, results):
            self.assertEqual((r.case_id, r.sql, r.expected, r.expected_sqlstates),
                             (case.case_id, case.sql, case.expected, case.expected_sqlstates))
            self.assertIn('sandbox', r.error_msg.lower())
            self.assertIn('not authorized', r.cleanup_skipped_reason)
            self.assertEqual(r.actual_sqlstate, '')  # setup code is not the target Oracle
        cursor.close.assert_called()

    def test_search_path_failure_retains_partial_residue_and_does_not_drop(self):
        e, cursor, calls = self.engine(lambda s: s.startswith('SET search_path TO "'))
        results = e.execute_batch([self.case()])
        self.assertEqual(len(calls), 2, calls)
        self.assertEqual(results[0].status, 'fixture_error')
        self.assertIn(calls[0].split('"')[1], results[0].error_msg)
        self.assertIn('partial', results[0].cleanup_skipped_reason)
        self.assertFalse(any(s.startswith('DROP') for s in calls))
        cursor.close.assert_called()

    def test_sandbox_error_preserves_scope_and_oracle_metadata(self):
        e, _, _ = self.engine(lambda s: s.startswith('CREATE SCHEMA '))
        c = self.case(expected='error')
        c.expected_scope = 'syntax_only'
        c.expected_oracle_status = 'needs_verification'
        c.expected_error_category = 'mock_target_only'
        r = e.execute_batch([c])[0]
        self.assertEqual((r.expected_scope, r.expected_oracle_status, r.expected_error_category),
                         ('syntax_only', 'needs_verification', 'mock_target_only'))
        self.assertEqual(r.verdict, 'fail')

    def test_explicit_disabled_and_no_sandbox_routes_do_not_invent_setup_failure(self):
        e, _, calls = self.engine(enabled=False)
        self.assertEqual(e.execute_batch([self.case()])[0].verdict, 'skip')
        self.assertEqual(calls, [])
        e, _, calls = self.engine(sandbox=False)
        c = self.case()
        self.assertEqual(e.execute_batch([c])[0].verdict, 'pass')
        self.assertEqual(calls, c.setup_sqls+[c.sql]+c.teardown_sqls)

    def test_successful_sandbox_keeps_existing_target_and_cleanup_sequence(self):
        e, _, calls = self.engine()
        c = self.case()
        self.assertEqual(e.execute_batch([c])[0].verdict, 'pass')
        self.assertTrue(calls[0].startswith('CREATE SCHEMA '))
        self.assertEqual(calls[2:5], c.setup_sqls+[c.sql]+c.teardown_sqls)
        self.assertTrue(calls[-1].startswith('DROP SCHEMA IF EXISTS '))

    def test_m_gate_precedes_sandbox_even_in_mixed_batch(self):
        e, _, calls = self.engine(lambda _: True)
        c = self.case("PREPARE q FROM 'SELECT 1';")
        c.environment_requirements = [dict(key='compatibility_mode', allowed_values=['M'])]
        results = e.execute_batch([self.case(), c])
        self.assertTrue(all(r.verdict=='skip' for r in results))
        self.assertEqual(calls, [])

    def test_failed_prepare_cannot_deallocate_unproved_existing_name(self):
        for sql in ('PREPARE q AS SELECT 1;', "PREPARE q FROM 'SELECT 1';", "PREPARE TRANSACTION 'mock_pt';"):
            e, _, calls = self.engine(lambda s: s==sql, sandbox=False)
            c = self.case(sql, expected='error'); c.teardown_sqls = ['DEALLOCATE q;']
            r = e.execute_one(c)
            self.assertEqual(calls, c.setup_sqls+[sql])
            self.assertEqual((r.status, r.actual_sqlstate, r.verdict), ('error', '42P05', 'pending'))
            self.assertIn('PREPARE target failed', r.cleanup_skipped_reason)

    def test_comments_case_and_bom_cannot_hide_failed_prepare(self):
        for prefix in ('-- note\n', '/* outer /* inner */ end */ ', '\ufeff\t'):
            sql = prefix+'prepare q AS SELECT 1;'
            e, _, calls = self.engine(lambda s: s==sql, sandbox=False)
            c = self.case(sql)
            r = e.execute_one(c)
            self.assertEqual(calls, c.setup_sqls+[sql])
            self.assertEqual(r.verdict, 'fail')
            self.assertTrue(r.cleanup_skipped_reason)

    def test_wrong_target_oracle_does_not_become_pending_success(self):
        c = self.case('PREPARE q AS SELECT 1;', expected='error')
        c.expected_sqlstates = ['23505']
        c.expected_sqlstate = '23505'
        e, _, _ = self.engine(lambda s:s==c.sql, sandbox=False)
        r = e.execute_one(c)
        self.assertEqual(r.verdict, 'fail')
        self.assertTrue(r.cleanup_skipped_reason)

    def test_no_cleanup_obligation_and_successful_prepare_keep_existing_verdicts(self):
        c = self.case('PREPARE q AS SELECT 1;', expected='error', teardown=False)
        e, _, _ = self.engine(lambda s:s==c.sql, sandbox=False)
        self.assertEqual(e.execute_one(c).verdict, 'pass')
        c = self.case('PREPARE q AS SELECT 1;');c.teardown_sqls = ['DEALLOCATE q;','DROP TABLE owned_source;']
        e, _, calls = self.engine(sandbox=False)
        self.assertEqual(e.execute_one(c).verdict, 'pass')
        self.assertEqual(calls, c.setup_sqls+[c.sql]+c.teardown_sqls)

    def test_prepare_in_literal_or_comment_is_not_a_creator(self):
        for sql in ("SELECT 'PREPARE q AS SELECT 1';", '-- PREPARE\nSELECT 1;', '/* PREPARE */ SELECT 1;'):
            e, _, calls = self.engine(lambda s:s==sql, sandbox=False)
            c = self.case(sql)
            r = e.execute_one(c)
            self.assertEqual(calls, c.setup_sqls+[sql]+c.teardown_sqls)
            self.assertEqual(r.cleanup_skipped_reason, '')

    def test_general_prepare_uses_own_source_not_m_inference(self):
        source = Path(__file__).resolve().parents[1]/'work/doc2spec/full_general_corpus/general/utility/prepare.txt'
        self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(),
                         '9d1daf19bfd95093a640a412542ab1b25894c9a8076a7353ca3c7832206ea4f8')

    def test_file_asset_gate_precedes_sandbox(self):
        e, _, calls = self.engine(lambda _: True)
        c = self.case(); c.file_assets = [{'id': 'mock_file_asset'}]
        results = e.execute_batch([c])
        self.assertEqual(results[0].verdict, 'skip')
        self.assertEqual(calls, [])

    def test_cursor_acquisition_failure_is_still_a_batch_precondition_failure(self):
        e, _, calls = self.engine()
        e._conn.cursor.side_effect = RuntimeError('mock cursor unavailable')
        results = e.execute_batch([self.case()])
        self.assertEqual((results[0].status, results[0].verdict), ('fixture_error','fail'))
        self.assertEqual(calls, [])


if __name__ == '__main__':
    unittest.main()
