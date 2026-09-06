"""Whitespace cannot bypass source or transaction-boundary checks."""
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write, inspect_lifecycle


class FiniteKeywordBoundaryTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT)', 'CREATE TABLE s(id INT)',
             'CREATE TABLE distinct_source(other_id INT)']
    separators = (' ', '\n', '\t', '\r\n', '  \n\t')

    def test_unknown_from_is_reviewed_for_every_separator(self):
        for sep in self.separators:
            for prefix in ('UPDATE t SET id=1', 'UPDATE t AS x, s AS y SET x.id=1'):
                with self.subTest(sep=repr(sep), prefix=prefix):
                    result = inspect_write(prefix + ' FROM' + sep + 'missing;', self.setup)
                    self.assertEqual(result['status'], 'needs_review', result)
                    self.assertEqual(result['issues'][0]['code'], 'fixture_unknown')

    def test_ambiguous_from_rhs_is_not_bypassed_by_whitespace(self):
        for sep in self.separators:
            with self.subTest(sep=repr(sep)):
                result = inspect_write('UPDATE t SET id=id+1 FROM' + sep + 's;', self.setup)
                self.assertEqual(result['status'], 'needs_review', result)
                self.assertEqual(result['issues'][0]['code'], 'query_unknown')

    def test_known_disjoint_source_keeps_finite_proof(self):
        for sep in self.separators:
            with self.subTest(sep=repr(sep)):
                result = inspect_write('UPDATE t SET id=id+1 FROM' + sep + 'distinct_source;', self.setup)
                self.assertEqual(result['status'], 'checked', result)

    def test_from_inside_literal_does_not_become_source(self):
        result = inspect_write("UPDATE t SET note='FROM\nmissing';", ['CREATE TABLE t(note TEXT)'])
        self.assertEqual(result['status'], 'checked', result)

    def test_abort_and_two_phase_prepare_are_not_scoped(self):
        for statement in ('ABORT;', 'abort work;', 'ABORT TRANSACTION;',
                          "PREPARE TRANSACTION 'pt_test';", "prepare\ntransaction 'pt_test';"):
            with self.subTest(statement=statement):
                result = inspect_lifecycle(['BEGIN;', statement, 'CREATE TABLE t(id INT);'], ['ROLLBACK;'])
                self.assertEqual(result['status'], 'needs_review', result)
                self.assertFalse(result['database_executed'])

    def test_transaction_start_whitespace_cannot_hide_nested_boundary(self):
        for sep in self.separators:
            with self.subTest(sep=repr(sep)):
                result = inspect_lifecycle(['BEGIN;', 'START' + sep + 'TRANSACTION;',
                                            'CREATE TABLE t(id INT);'], ['ROLLBACK;'])
                self.assertEqual(result['status'], 'needs_review', result)

    def test_literal_boundary_words_do_not_change_transaction_shape(self):
        setup = ['BEGIN;', 'CREATE TABLE t(note TEXT);',
                 "INSERT INTO t VALUES ('ABORT; PREPARE TRANSACTION; START TRANSACTION');"]
        result = inspect_lifecycle(setup, ['ROLLBACK;'])
        self.assertEqual(result['status'], 'transaction_scoped', result)

    def test_real_prepared_cases_do_not_inherit_transaction_scoped_evidence(self):
        report = json.loads((Path(__file__).resolve().parents[1] /
                             'generated/factor_packages/generation_report.json').read_text())
        for mid in ('manifest_commit_prepared_owned_transaction',
                    'manifest_rollback_prepared_owned_transaction'):
            cases = report['manifests'][mid]['cases']
            self.assertEqual(len(cases), 1)
            case = cases[0]
            self.assertEqual(case['expected'], 'success')
            self.assertEqual(inspect_lifecycle(case['setup_sqls'], case['teardown_sqls'])['status'],
                             'needs_review')

    def test_prepared_transaction_cannot_keep_prior_visible_table_proof(self):
        for sep in self.separators:
            with self.subTest(sep=repr(sep)):
                setup = ['BEGIN;', 'CREATE TABLE t(id INT);',
                         "PREPARE" + sep + "TRANSACTION 'pt_test';"]
                result = inspect_write('UPDATE t SET id=1;', setup)
                self.assertEqual(result['status'], 'needs_review', result)
                self.assertEqual(result['issues'][0]['code'], 'fixture_unknown')
        # SQL statement preparation is distinct from two-phase preparation.
        result = inspect_write('UPDATE t SET id=1;',
                               ['CREATE TABLE t(id INT);', 'PREPARE q AS SELECT 1;'])
        self.assertEqual(result['status'], 'checked', result)


if __name__ == '__main__':
    unittest.main()
