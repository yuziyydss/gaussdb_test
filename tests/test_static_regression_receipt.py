"""A test receipt must bind real process results and both input endpoints."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from scripts import run_static_regression as runner


class StaticRegressionReceiptTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name).resolve()
        (self.root/'tests').mkdir()
        (self.root/'tests/test_example.py').write_text('# fixture input\n')
        self.output = self.root/'work/run1'

    def invoke(self, *, code=0, log='Ran 2 tests in 0.001s\n\nOK\n', change=None, failure=None,
               timeout_seconds=1800):
        def process(command, **kwargs):
            self.assertEqual(kwargs['env']['GAUSSDB_ENABLED'], 'false')
            self.assertEqual(kwargs['cwd'], self.root)
            self.assertNotIn('shell', kwargs)
            self.assertEqual(kwargs['timeout'], timeout_seconds)
            self.assertEqual(command[1:], ['-m', 'unittest', 'discover', '-s', 'tests', '-v'])
            self.assertTrue((self.output/'start.json').exists())
            kwargs['stdout'].write(log.encode())
            if change:
                change()
            if failure:
                raise failure
            return subprocess.CompletedProcess(command, code)
        with patch.object(runner.subprocess, 'run', side_effect=process) as child:
            result = runner.run(self.root, self.output, timeout_seconds=timeout_seconds)
        return result, child

    def test_explicit_bounded_budget_is_recorded_and_reaches_process(self):
        result, child = self.invoke(timeout_seconds=7200)
        child.assert_called_once()
        self.assertEqual(result['status'], 'passed')
        self.assertEqual(result['timeout_seconds'], 7200)
        self.assertEqual(json.loads((self.output/'start.json').read_text())['timeout_seconds'], 7200)

    def test_invalid_budget_never_creates_output_or_launches(self):
        for value in (0, -1, None, True, 1.5, '7200', 86401):
            with self.subTest(value=value), patch.object(runner.subprocess, 'run') as child:
                with self.assertRaises(ValueError):
                    runner.run(self.root, self.output, timeout_seconds=value)
                child.assert_not_called()
                self.assertFalse(self.output.exists())

    def test_extended_timeout_still_fails_even_with_ok_log(self):
        result, _ = self.invoke(timeout_seconds=7200,
                                failure=subprocess.TimeoutExpired(['python'], 7200))
        self.assertEqual(result['status'], 'error')
        self.assertEqual(result['error_type'], 'TimeoutExpired')
        self.assertEqual(result['timeout_seconds'], 7200)

    def test_pass_records_exit_log_and_both_endpoints(self):
        result, child = self.invoke()
        child.assert_called_once()
        self.assertEqual(result['status'], 'passed')
        self.assertEqual(result['exit_code'], 0)
        self.assertEqual(result['tests_run'], 2)
        self.assertEqual(result['before_inputs'], result['after_inputs'])
        self.assertIn('tests/test_example.py', result['before_inputs'])
        self.assertEqual(result['log_sha256'], runner.digest(self.output/'tests.log'))
        self.assertFalse(result['database_verified'])
        self.assertEqual(json.loads((self.output/'receipt.json').read_text()), result)

    def test_exit_failure_wins_even_if_log_claims_ok(self):
        result, _ = self.invoke(code=1)
        self.assertEqual(result['status'], 'failed')

    def test_reference_facts_and_builder_source_changes_revoke_receipt(self):
        for index, name in enumerate(('docs/compat_facts/sample.yaml',
                                     'work/m_compat_batch_02/corpus/sample.txt')):
            self.output = self.root/f'work/source_run{index}'
            path = self.root/name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text('original source')
            result, _ = self.invoke(change=lambda: path.write_text('changed source'))
            self.assertEqual(result['status'], 'inputs_changed')
            self.assertIn(name, result['changed_inputs'])

    def test_missing_zero_or_failed_summary_never_passes(self):
        for i, log in enumerate(('still running\n', 'Ran 0 tests in 0.001s\n\nOK\n',
                                 'Ran 2 tests in 0.001s\n\nFAILED (failures=1)\n')):
            self.output = self.root/f'work/run{i}'
            self.assertNotEqual(self.invoke(log=log)[0]['status'], 'passed')

    def test_skips_and_expected_failures_are_not_all_passed(self):
        for i, tail in enumerate(('OK (skipped=1)', 'OK (expected failures=1)')):
            self.output = self.root/f'work/run{i}'
            result, _ = self.invoke(log='Ran 2 tests in 0.001s\n\n'+tail+'\n')
            self.assertEqual(result['status'], 'incomplete')
            self.assertEqual(result['tests_run'], 2)

    def test_changed_added_or_removed_input_revokes_pass(self):
        path = self.root/'tests/test_example.py'
        for i, change in enumerate((lambda: path.write_text('# changed\n'),
                                   lambda: (self.root/'tests/added.py').write_text('# added\n'),
                                   lambda: path.unlink())):
            self.output = self.root/f'work/run{i}'
            result, _ = self.invoke(change=change)
            self.assertEqual(result['status'], 'inputs_changed')
            self.assertTrue(result['changed_inputs'])

    def test_existing_output_and_non_work_path_never_launch(self):
        for target in (self.output, self.root/'specs/forbidden'):
            self.output.mkdir(parents=True, exist_ok=True)
            with patch.object(runner.subprocess, 'run') as child, self.assertRaises(ValueError):
                runner.run(self.root, target)
            child.assert_not_called()

    def test_timeout_launch_error_and_interruption_preserve_failure_receipt(self):
        for i, failure in enumerate((subprocess.TimeoutExpired(['python'], 1800),
                                     OSError('not available'), KeyboardInterrupt())):
            self.output = self.root/f'work/run{i}'
            result, _ = self.invoke(failure=failure)
            self.assertEqual(result['status'], 'error')
            self.assertIsNone(result['exit_code'])
            self.assertTrue((self.output/'receipt.json').exists())

    def test_report_outputs_and_bytecode_do_not_invalidate_inputs(self):
        def change():
            (self.root/'reports').mkdir()
            (self.root/'reports/example.json').write_text('{}')
            (self.root/'tests/__pycache__').mkdir()
            (self.root/'tests/__pycache__/x.pyc').write_bytes(b'cache')
        self.assertEqual(self.invoke(change=change)[0]['status'], 'passed')

    def test_retired_spec_history_is_a_real_input_not_an_ignored_report(self):
        path = self.root/'archive/spec_reviews/retired.yaml'
        path.parent.mkdir(parents=True)
        path.write_text('original: true\n')
        result, _ = self.invoke(change=lambda: path.write_text('original: false\n'))
        self.assertEqual(result['status'], 'inputs_changed')
        self.assertIn('archive/spec_reviews/retired.yaml', result['changed_inputs'])

    def test_fixture_bytes_without_code_suffix_revoke_old_receipt(self):
        path=self.root/'specs/utility/example/fixtures/assets/seed.tsv'
        path.parent.mkdir(parents=True);path.write_text('1\t2\n')
        result,_=self.invoke(change=lambda:path.write_text('3\t4\n'))
        self.assertEqual(result['status'],'inputs_changed')
        self.assertIn(str(path.relative_to(self.root)),result['changed_inputs'])

    def test_selected_modules_are_explicit_and_not_shell_commands(self):
        self.assertEqual(runner.test_command(self.root, ['tests.test_example'])[1:],
                         ['-m', 'unittest', 'tests.test_example', '-v'])
        for name in ('os', 'tests.test_missing', 'tests.test_example;echo bad'):
            with self.assertRaises(ValueError):
                runner.test_command(self.root, [name])

    def test_source_input_output_directory_is_forbidden(self):
        with patch.object(runner.subprocess, 'run') as child, self.assertRaises(ValueError):
            runner.run(self.root, self.root/'work/doc2spec/new_receipt')
        child.assert_not_called()

    def test_input_symlink_is_not_silently_omitted_or_followed(self):
        (self.root/'tests/link.py').symlink_to(self.root/'tests/test_example.py')
        with patch.object(runner.subprocess, 'run') as child:
            result = runner.run(self.root, self.output)
        child.assert_not_called()
        self.assertEqual(result['status'], 'error')
        self.assertIsNone(result['exit_code'])

    def test_one_test_summary_is_recognized(self):
        result, _ = self.invoke(log='Ran 1 test in 0.001s\n\nOK\n')
        self.assertEqual(result['status'], 'passed')
        self.assertEqual(result['tests_run'], 1)


if __name__ == '__main__':
    unittest.main()
