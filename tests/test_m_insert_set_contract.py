"""INSERT SET supplies a new row, not an UPDATE of existing target values."""
import unittest

from core.finite_sql_contract import inspect_write
from tests.test_m_string_storage_contract import REQUIREMENTS


class MInsertSetContractTests(unittest.TestCase):
    def inspect(self, assignments, setup=None, scope='m_compat', into='INTO ', requirements=None):
        return inspect_write('INSERT '+into+'t SET '+assignments,
                             setup or ['CREATE TABLE t(id INT PRIMARY KEY,qty INT DEFAULT 7)'],
                             conflict_source_scope=scope, environment_requirements=requirements)

    def test_finite_set_inputs_work_with_and_without_into(self):
        for into in ('INTO ', ''):
            result = self.inspect('id=1,qty=DEFAULT', into=into)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('insert_set_input_columns', result['checks'])
            self.assertIn('shared_constant_or_null_defaults', result['checks'])

    def test_general_source_does_not_gain_m_set_grammar(self):
        self.assertEqual(self.inspect('id=1,qty=2', scope='general')['status'], 'needs_review')

    def test_omitted_not_null_column_is_not_silently_left_unchanged(self):
        result = self.inspect('qty=2')
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'null_not_allowed')

    def test_omission_uses_real_defaults_and_keeps_dynamic_unknown(self):
        result = self.inspect('id=1')
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('insert_omitted_base_columns', result['checks'])
        result = self.inspect('id=1', ['CREATE TABLE t(id INT,qty INT DEFAULT app.next_value())'])
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['issues'][0]['code'], 'default_unknown')

    def test_source_column_or_order_semantics_are_not_existing_row_proofs(self):
        for assignment in ('id=1,qty=id', 'id=1,qty=id+1', 'id=1,id=2,qty=3',
                           'id=1,qty=VALUES(qty)', 'id=(SELECT 1),qty=2'):
            self.assertEqual(self.inspect(assignment)['status'], 'needs_review', assignment)

    def test_missing_column_and_explicit_null_remain_contradictions(self):
        for assignment, code in (('missing=1', 'missing_column'), ('id=NULL,qty=2', 'null_not_allowed')):
            result = self.inspect(assignment)
            self.assertEqual(result['status'], 'rejected', result)
            self.assertEqual(result['issues'][0]['code'], code)

    def test_generated_input_guard_is_not_bypassed(self):
        setup = ['CREATE TABLE t(id INT,qty INT GENERATED ALWAYS AS(id+1) STORED)']
        result = self.inspect('id=1,qty=99', setup)
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'generated_column_write')
        for assignment in ('id=1,qty=DEFAULT', 'id=1'):
            result = self.inspect(assignment, setup)
            self.assertEqual(result['status'], 'needs_review', result)
            self.assertEqual(result['issues'][0]['code'], 'generated_default_unknown')

    def test_conflict_update_and_insert_inputs_both_checked(self):
        result = self.inspect('id=1,qty=2 ON DUPLICATE KEY UPDATE qty=VALUES(qty)')
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('conflict_input_same_column_types', result['checks'])
        result = self.inspect('id=1,qty=2 ON DUPLICATE KEY UPDATE qty=DEFAULT',
                              ['CREATE TABLE t(id INT,qty INT NOT NULL DEFAULT NULL)'])
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'null_not_allowed')

    def test_view_default_stays_unknown_not_inherited(self):
        setup = ['CREATE TABLE base(id INT,qty INT DEFAULT 7)', 'CREATE VIEW t AS SELECT id,qty FROM base']
        result = self.inspect('id=1,qty=DEFAULT', setup)
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['issues'][0]['code'], 'default_unknown')

    def test_literal_commas_keywords_and_equals_are_not_clauses(self):
        result = self.inspect("id=1,qty='AS x, ON y = DEFAULT'", ['CREATE TABLE t(id INT,qty TEXT)'])
        self.assertEqual(result['issues'][0]['code'], 'm_string_environment_unknown')
        self.assertEqual(result['status'], 'needs_review', result)
        result = self.inspect("id=1,qty='AS x, ON y = DEFAULT'", ['CREATE TABLE t(id INT,qty TEXT)'],
                              requirements=REQUIREMENTS)
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('shared_m_utf8_string_storage', result['checks'])

    def test_unhandled_row_alias_tail_or_incomplete_assignment_stays_review(self):
        for assignment in ('id=1,qty=2 AS incoming', 'id=1,qty=2 RETURNING id',
                           'id=1,qty=2 ON nonsense', 'id=1,', 'id=1,qty=', '(id,qty)=(1,2)'):
            self.assertEqual(self.inspect(assignment)['status'], 'needs_review', assignment)

    def test_incomplete_ddl_does_not_establish_omitted_defaults(self):
        result = self.inspect('id=1', ['CREATE TABLE t(id INT,qty INT) WITH (fillfactor=70)'])
        self.assertEqual(result['status'], 'needs_review', result)

    def test_set_keyword_whitespace_and_reordered_inputs(self):
        for separator in (' ', '\n', '\t'):
            result = inspect_write('INSERT t SET'+separator+'qty=DEFAULT,id=1',
                                   ['CREATE TABLE t(id INT,qty INT DEFAULT 7)'],
                                   conflict_source_scope='m_compat')
            self.assertEqual(result['status'], 'checked', result)


if __name__ == '__main__':
    unittest.main()
