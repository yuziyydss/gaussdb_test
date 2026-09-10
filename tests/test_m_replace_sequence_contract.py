"""Finite M REPLACE SET new-input values, not old rows or runtime effects."""
import unittest
from unittest.mock import patch
from core.finite_sql_contract import inspect_write, check_types, finite_replace_set_values, Contradiction


class MReplaceSequenceContractTests(unittest.TestCase):
    setup=['CREATE TABLE t(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9)',
           'INSERT INTO t VALUES(1,10),(2,20)']

    def inspect(self, assignments, setup=None, scope='m_compat', verb='REPLACE'):
        return inspect_write(verb+' INTO t SET '+assignments,
                             self.setup if setup is None else setup,conflict_source_scope=scope)

    def resolved(self, assignments, expected, setup=None):
        with patch('core.finite_sql_contract.check_types',wraps=check_types) as checked:
            result=self.inspect(assignments,setup)
        self.assertEqual(result['status'],'checked',result)
        self.assertIn('replace_sequential_input_literals',result['checks'])
        self.assertTrue(any(list(call.args[1])==expected for call in checked.call_args_list),
                        'Resolved new input must be validated as a whole')

    def test_actual_chain_reads_defaults_then_new_values_not_seed_rows(self):
        self.resolved('id=id+1,qty=id',['3','3'])

    def test_reverse_order_reads_default_before_later_assignment(self):
        self.resolved('qty=id,id=id+1',['2','3'])

    def test_explicit_prior_assignment_overrides_default_for_reference(self):
        self.resolved('id=7,qty=id',['7','7'])

    def test_unassigned_nullable_reference_stays_null(self):
        self.resolved('id=id+1,qty=id',['NULL','NULL'],['CREATE TABLE t(id INT,qty INT)'])

    def test_default_keyword_in_mixed_chain_remains_declared_default(self):
        self.resolved('id=id+1,qty=DEFAULT',['3','9'])

    def test_increment_and_cross_column_range_are_checked(self):
        for sql,setup in (
            ('id=id+1,qty=id',['CREATE TABLE t(id INT DEFAULT 2147483647,qty INT)']),
            ('id=id+1,qty=id',['CREATE TABLE t(id INT DEFAULT 32767,qty SMALLINT)']),
        ):
            result=self.inspect(sql,setup)
            self.assertEqual(result['status'],'needs_review',result)
            self.assertEqual(result['issues'][0]['code'],'assignment_range_unknown')

    def test_wider_destination_does_not_prove_source_arithmetic_overflow(self):
        result=self.inspect('qty=id+1,id=1',
                            ['CREATE TABLE t(id BIGINT DEFAULT 9223372036854775807,qty NUMERIC(30,0))'])
        self.assertEqual(result['status'],'needs_review',result)
        self.assertEqual(result['issues'][0]['code'],'assignment_range_unknown')

    def test_helper_does_not_zip_truncate(self):
        with self.assertRaises(Contradiction) as raised:
            finite_replace_set_values({'columns':{}},['id','qty'],['1'])
        self.assertEqual(raised.exception.code,'arity')

    def test_long_leading_zero_literal_is_bounded_before_integer_conversion(self):
        self.resolved('id='+'0'*5000+'2,qty=id+1',['0'*5000+'2','3'])

    def test_unknown_target_identity_does_not_acquire_sequence_proof(self):
        for setup in (
            ['CREATE TABLE b(id INT DEFAULT 2,qty INT)','CREATE VIEW t AS SELECT id,qty FROM b'],
            ['CREATE TABLE t(id INT DEFAULT 2,qty INT)','ALTER TABLE t ALTER COLUMN id SET DEFAULT 5'],
            ['CREATE TABLE t(id INT DEFAULT 2,qty INT) WITH (fillfactor=70)'],
        ):
            self.assertEqual(self.inspect('id=id+1,qty=id',setup)['status'],'needs_review')

    def test_missing_reference_is_not_silently_a_function_or_old_row(self):
        result=self.inspect('id=absent+1,qty=id')
        self.assertEqual(result['status'],'rejected',result)
        self.assertEqual(result['issues'][0]['code'],'missing_column')

    def test_dynamic_zero_and_noninteger_reference_remain_unknown(self):
        for ddl in ('CREATE TABLE t(id INT DEFAULT app.f(),qty INT)',
                    'CREATE TABLE t(id INT NOT NULL,qty INT)',
                    'CREATE TABLE t(id INT NOT NULL DEFAULT NULL,qty INT)',
                    'CREATE TABLE t(id DECIMAL DEFAULT 2,qty DECIMAL)'):
            result=self.inspect('id=id+1,qty=id',[ddl])
            self.assertEqual(result['status'],'needs_review',result)

    def test_repeated_qualified_and_arbitrary_expression_remain_unknown(self):
        for assignment in ('id=id+1,id=7,qty=id','id=t.id+1,qty=id','id=id+2,qty=id',
                           'id=id*2,qty=id','id=(SELECT 3),qty=id'):
            self.assertEqual(self.inspect(assignment)['status'],'needs_review',assignment)

    def test_m_insert_and_general_replace_do_not_borrow_m_sequence_contract(self):
        for scope,verb in (('m_compat','INSERT'),('general','REPLACE')):
            result=self.inspect('id=id+1,qty=id',scope=scope,verb=verb)
            self.assertNotIn('replace_sequential_input_literals',result['checks'])
        self.assertEqual(self.inspect('id=id+1,qty=id',verb='INSERT')['status'],'needs_review')

    def test_strings_containing_expressions_remain_literal_inputs(self):
        result=self.inspect("id=1,qty='id+1'",['CREATE TABLE t(id INT,qty TEXT)'])
        self.assertEqual(result['status'],'checked',result)
        self.assertNotIn('replace_sequential_input_literals',result['checks'])


if __name__=='__main__':unittest.main()
