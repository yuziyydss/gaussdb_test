"""Pure mock regression: failed setup never authorizes destructive teardown."""
import unittest
import json
import tempfile
from pathlib import Path
from unittest.mock import Mock

from core.executor import ExecConfig, Executor
from core.generator import GeneratedCase
from core.reporter import generate_report


class SetupCleanupSafetyTests(unittest.TestCase):
    def run_case(self, setup, failure=None, target_failure=False, cleanup_failure=False):
        executed = []
        cursor = Mock()

        def execute(sql):
            executed.append(sql)
            if sql == failure or (sql == 'TARGET' and target_failure):
                raise RuntimeError('intentional stage failure')
            if sql == 'DROP OWNED TEST OBJECT' and cleanup_failure:
                raise RuntimeError('intentional cleanup failure')

        cursor.execute.side_effect = execute
        executor = Executor(ExecConfig(enabled=True, use_sandbox=False, environment_capabilities={}))
        executor.connect = Mock(side_effect=AssertionError('real connection forbidden'))
        executor._conn = Mock()
        executor._conn.closed = False
        executor._conn.cursor.return_value = cursor
        case = GeneratedCase('cleanup_safety', 'mock-only', 'full', {}, 'TARGET',
                             setup_sqls=setup, teardown_sqls=['DROP OWNED TEST OBJECT'])
        result = executor.execute_one(case)
        executor.connect.assert_not_called()
        # Health probes are read-only diagnostics, not fixture/target/cleanup steps.
        return result, [sql for sql in executed if sql != 'SELECT 1']

    def test_absence_assertion_failure_never_drops_existing_object(self):
        result, executed = self.run_case(['ASSERT OBJECT ABSENT'], failure='ASSERT OBJECT ABSENT')
        self.assertEqual(executed, ['ASSERT OBJECT ABSENT'])
        self.assertEqual((result.status, result.verdict), ('fixture_error', 'fail'))
        self.assertIn('setup did not complete', result.cleanup_skipped_reason)
        self.assertIn('fixture setup failed', result.error_msg)

    def test_partial_setup_failure_reports_possible_residue_without_blind_drop(self):
        result, executed = self.run_case(['CREATE FIRST OBJECT', 'CREATE SECOND OBJECT'],
                                         failure='CREATE SECOND OBJECT')
        self.assertEqual(executed, ['CREATE FIRST OBJECT', 'CREATE SECOND OBJECT'])
        self.assertEqual(result.verdict, 'fail')
        self.assertIn('partial setup residue', result.cleanup_skipped_reason)

    def test_successful_setup_and_target_keep_cleanup(self):
        result, executed = self.run_case(['CREATE OWNED OBJECT'])
        self.assertEqual(executed, ['CREATE OWNED OBJECT', 'TARGET', 'DROP OWNED TEST OBJECT'])
        self.assertEqual((result.status, result.verdict), ('success', 'pass'))
        self.assertEqual(result.cleanup_skipped_reason, '')

    def test_failed_target_after_successful_setup_keeps_cleanup(self):
        result, executed = self.run_case(['CREATE OWNED OBJECT'], target_failure=True)
        self.assertEqual(executed, ['CREATE OWNED OBJECT', 'TARGET', 'DROP OWNED TEST OBJECT'])
        self.assertEqual((result.status, result.verdict), ('error', 'fail'))
        self.assertEqual(result.cleanup_skipped_reason, '')

    def test_cleanup_failure_after_successful_setup_is_not_hidden(self):
        result, executed = self.run_case(['CREATE OWNED OBJECT'], cleanup_failure=True)
        self.assertEqual(executed[-1], 'DROP OWNED TEST OBJECT')
        self.assertEqual((result.status, result.verdict), ('cleanup_error', 'fail'))
        self.assertIn('intentional cleanup failure', result.cleanup_error_msg)

    def test_no_setup_target_may_still_have_cleanup(self):
        result, executed = self.run_case([])
        self.assertEqual(executed, ['TARGET', 'DROP OWNED TEST OBJECT'])
        self.assertEqual(result.verdict, 'pass')

    def test_report_preserves_cleanup_skip_and_does_not_suggest_zero_residue(self):
        result, _ = self.run_case(['ASSERT OBJECT ABSENT'], failure='ASSERT OBJECT ABSENT')
        case = GeneratedCase('cleanup_safety', 'mock-only', 'full', {}, 'TARGET')
        with tempfile.TemporaryDirectory() as directory:
            html = Path(generate_report([case], [result], 'cleanup_safety', 'full', directory))
            report = json.loads(html.with_suffix('.json').read_text())
            self.assertEqual(report['summary']['fail'], 1)
            self.assertEqual(report['detail'][0]['cleanup_skipped_reason'], result.cleanup_skipped_reason)
            self.assertIn('partial setup residue', html.read_text())
            self.assertIn('清理未执行', html.read_text())


if __name__ == '__main__':
    unittest.main()
