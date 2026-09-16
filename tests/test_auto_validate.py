"""Offline runner regressions: a successful client is not a successful Oracle."""
import contextlib
import io
import unittest
from unittest.mock import patch

from scripts import auto_validate as runner


class AutoValidateTests(unittest.TestCase):
    def setUp(self):
        runner.RESULTS.clear()

    def test_zero_exit_with_wrong_results_never_passes(self):
        with patch.object(runner, 'run_sql', return_value=(0, 'WRONG_RESULT', '')), \
                contextlib.redirect_stdout(io.StringIO()):
            runner.phase1('unused', 0, 'unused', 'unused', '', 'unused')
        self.assertTrue(runner.RESULTS)
        self.assertFalse(any(r['status'] == 'PASS' for r in runner.RESULTS))

    def test_result_rows_and_affected_rows_are_exact(self):
        rows = {'kind': 'result_set', 'rows': [['1', 'a'], ['2', 'b']]}
        self.assertEqual(runner.evaluate_result(0, '1\ta\n2\tb', '', rows)[0], 'PASS')
        for output in ('1\ta\n2\tx', '1\ta', '2\tb\n1\ta'):
            self.assertEqual(runner.evaluate_result(0, output, '', rows)[0], 'FAIL')
        affected = {'kind': 'affected_rows', 'command': 'UPDATE', 'count': 1}
        self.assertEqual(runner.evaluate_result(0, 'UPDATE 1', '', affected)[0], 'PASS')
        self.assertEqual(runner.evaluate_result(0, 'UPDATE 0', '', affected)[0], 'FAIL')

    def test_negative_requires_target_stage_and_exact_sqlstate(self):
        oracle = {'kind': 'target_error', 'sqlstates': ['23505']}
        error = 'ERROR:  23505: duplicate key'
        self.assertEqual(runner.evaluate_result(1, '', error, oracle)[0], 'PASS')
        for rc, err, stage in ((0, '', 'target'), (-1, error, 'target'),
                               (1, 'ERROR:  42703: no column', 'target'),
                               (1, error, 'setup')):
            self.assertEqual(runner.evaluate_result(rc, '', err, oracle, stage=stage)[0], 'FAIL')

    def test_missing_oracle_and_client_error_cannot_pass(self):
        for oracle in ({}, {'kind': 'target_error', 'sqlstates': []}):
            self.assertNotEqual(runner.evaluate_result(0, '', '', oracle)[0], 'PASS')
        self.assertEqual(runner.evaluate_result(0, '1', 'ERROR:  XX000: failure',
                         {'kind': 'result_set', 'rows': [['1']]})[0], 'FAIL')

    def test_unframed_empty_output_is_not_proof_of_an_empty_result_set(self):
        for rows in ([], [['']], [[]]):
            self.assertEqual(runner.evaluate_result(0, '', '',
                             {'kind': 'result_set', 'rows': rows})[0], 'FAIL')

    def test_setup_failure_blocks_targets_without_dropping_unowned_schema(self):
        with patch.object(runner, 'run_sql', return_value=(1, '', 'ERROR: setup failed')) as run, \
                contextlib.redirect_stdout(io.StringIO()):
            runner.phase1('unused', 0, 'unused', 'unused', '', 'unused')
        self.assertEqual(run.call_count, 1)
        self.assertEqual([r['status'] for r in runner.RESULTS], ['FAIL'] + ['BLOCKED'] * 10)

    def test_owned_cleanup_runs_on_target_failure_and_reports_cleanup_failure(self):
        with patch.object(runner, 'run_sql', side_effect=[(0, 'CREATE SCHEMA', ''),
                (1, '', 'ERROR: target failed'), (1, '', 'ERROR: cleanup failed')]) as run, \
                contextlib.redirect_stdout(io.StringIO()):
            runner.phase1('unused', 0, 'unused', 'unused', '', 'unused')
        self.assertEqual(run.call_count, 3)
        create_sql = run.call_args_list[0].args[5]
        self.assertEqual(run.call_args_list[-1].args[5],
                         create_sql.replace('CREATE SCHEMA', 'DROP SCHEMA') + ' CASCADE')
        self.assertEqual(runner.RESULTS[-1]['stage'], 'teardown')
        self.assertEqual(runner.RESULTS[-1]['status'], 'FAIL')
        self.assertFalse(any(r['status'] == 'PASS' for r in runner.RESULTS if r['stage'] == 'target'))

    def test_client_uses_machine_output_and_stops_on_first_sql_error(self):
        with patch.object(runner.subprocess, 'run') as run:
            run.return_value.returncode = 0
            run.return_value.stdout = '1\n'
            run.return_value.stderr = ''
            runner.run_sql('host', 1, 'db', 'user', '', 'SELECT 1')
        args = run.call_args.args[0]
        for flag in ('-X', '-A', '-t', 'ON_ERROR_STOP=1', 'VERBOSITY=verbose'):
            self.assertIn(flag, args)


if __name__ == '__main__':
    unittest.main()
