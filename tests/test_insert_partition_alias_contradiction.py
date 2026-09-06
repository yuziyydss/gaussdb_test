"""Bare aliases with explicit partition selection violate a documented rule."""
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write


class InsertPartitionAliasContradictionTests(unittest.TestCase):
    setup = ['CREATE TABLE p(id INT, note TEXT) PARTITION BY RANGE(id) '
             '(PARTITION low VALUES LESS THAN(5), PARTITION high VALUES LESS THAN(MAXVALUE));']

    def test_bare_alias_and_explicit_partition_is_a_finite_contradiction(self):
        for clause in ('dst PARTITION(low)', 'dst\nPARTITION FOR(1)', 'dst\tPARTITION (low)'):
            with self.subTest(clause=clause):
                result = inspect_write(f"INSERT INTO p {clause} (dst.id,dst.note) VALUES(1,'x');", self.setup)
                self.assertEqual(result['status'], 'rejected', result)
                self.assertEqual(result['issues'][0]['code'], 'partition_alias_form_not_supported')

    def test_explicit_as_and_bare_alias_without_selector_stay_supported(self):
        for clause in ('PARTITION(low) AS dst', 'dst'):
            with self.subTest(clause=clause):
                result = inspect_write(f"INSERT INTO p {clause} (dst.id,dst.note) VALUES(1,'x');", self.setup)
                self.assertEqual(result['status'], 'checked', result)

    def test_no_partition_ddl_or_malformed_selector_does_not_get_target_rule_proof(self):
        result = inspect_write("INSERT INTO p dst PARTITION(low) (id,note) VALUES(1,'x');",
                               ['CREATE TABLE p(id INT,note TEXT);'])
        self.assertEqual(result['status'], 'needs_review', result)
        result = inspect_write("INSERT INTO p dst PARTITION low (id,note) VALUES(1,'x');", self.setup)
        self.assertEqual(result['status'], 'needs_review', result)

    def test_real_negative_retains_expected_error_and_pending_oracle(self):
        report = json.loads((Path(__file__).resolve().parents[1] /
                             'generated/factor_packages/generation_report.json').read_text())
        cases = report['manifests']['manifest_insert_partition_alias_negative']['cases']
        self.assertEqual(len(cases), 1)
        case = cases[0]
        self.assertEqual(case['case_id'], 'manifest_insert_partition_alias_negative_45c4f1a101a4')
        self.assertEqual(case['expected'], 'error')
        self.assertEqual(case['expected_oracle_status'], 'needs_verification')
        self.assertEqual(case['expected_error_category'], 'partition_alias_form_not_supported')
        self.assertEqual(inspect_write(case['sql'], case['setup_sqls'])['status'], 'rejected')


if __name__ == '__main__':
    unittest.main()
