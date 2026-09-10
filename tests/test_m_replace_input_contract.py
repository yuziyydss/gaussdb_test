"""M REPLACE consumes a new input row; deletion/zero defaults are not proved."""
import unittest
from core.finite_sql_contract import inspect_write


class MReplaceInputContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT PRIMARY KEY DEFAULT 2,qty INT DEFAULT 9)']

    def inspect(self, body, setup=None, scope='m_compat'):
        return inspect_write('REPLACE '+body, self.setup if setup is None else setup,
                             conflict_source_scope=scope)

    def test_explicit_defaults_reach_shared_resolver_in_values_and_set(self):
        for body in ('t VALUES(1,DEFAULT)', 'INTO t(id,qty) VALUE(1,DEFAULT)',
                     't SET id=1,qty=DEFAULT', 'INTO t SET id=1,qty=DEFAULT'):
            result = self.inspect(body)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('shared_constant_or_null_defaults', result['checks'])
            self.assertNotIn('partition_key_assignment', result['checks'])

    def test_omitted_columns_need_new_row_defaults_not_old_row_preservation(self):
        for body in ('t SET id=1', 't(id) VALUES(1)', 't VALUES(1)', 't SELECT 1'):
            result = self.inspect(body)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('insert_omitted_base_columns', result['checks'])

    def test_set_self_reference_and_order_are_not_update_identity(self):
        for body in ('t SET id=1,qty=qty+1', 't SET id=1,qty=id'):
            result = self.inspect(body)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('replace_sequential_input_literals', result['checks'])
        self.assertEqual(self.inspect('t SET id=1,id=2,qty=3')['status'], 'needs_review')

    def test_implicit_zero_or_invalid_null_default_remains_environment_review(self):
        for ddl in ('CREATE TABLE t(id INT NOT NULL,qty INT)',
                    'CREATE TABLE t(id INT NOT NULL DEFAULT NULL,qty INT)'):
            for body in ('t SET qty=1', 't SET id=DEFAULT,qty=1', 't(qty) VALUES(1)'):
                result = self.inspect(body,[ddl])
                self.assertEqual(result['status'],'needs_review',result)
                self.assertEqual(result['issues'][0]['code'],'replace_zero_default_unknown')

    def test_dynamic_defaults_are_not_evaluated(self):
        for body in ('t SET id=1,qty=DEFAULT','t VALUES(1,DEFAULT)'):
            result = self.inspect(body,['CREATE TABLE t(id INT,qty INT DEFAULT app.value())'])
            self.assertEqual(result['status'],'needs_review',result)
            self.assertEqual(result['issues'][0]['code'],'default_unknown')

    def test_general_replace_scope_is_not_extended_by_m_defaults(self):
        for body in ('t VALUES(1,DEFAULT)','t SET id=1,qty=DEFAULT'):
            self.assertEqual(self.inspect(body,scope='general')['status'],'needs_review')

    def test_view_and_incomplete_ddl_do_not_acquire_default_proof(self):
        for setup in (['CREATE TABLE base(id INT,qty INT DEFAULT 9)','CREATE VIEW t AS SELECT id,qty FROM base'],
                      ['CREATE TABLE t(id INT,qty INT) WITH (fillfactor=70)']):
            self.assertEqual(self.inspect('t SET id=1,qty=DEFAULT',setup)['status'],'needs_review')

    def test_default_resolution_does_not_hide_missing_column_or_arity(self):
        for body,code in (('t(missing) VALUES(DEFAULT)','missing_column'),
                          ('t(id,qty) VALUES(DEFAULT)','arity')):
            result = self.inspect(body)
            self.assertEqual(result['status'],'rejected',result)
            self.assertEqual(result['issues'][0]['code'],code)

    def test_null_is_not_rewritten_to_a_zero_value(self):
        result=self.inspect('t VALUES(NULL,1)')
        self.assertEqual(result['status'],'rejected',result)
        self.assertEqual(result['issues'][0]['code'],'null_not_allowed')

    def test_replace_set_does_not_borrow_insert_conflict_tail(self):
        result=self.inspect('t SET id=1,qty=2 ON DUPLICATE KEY UPDATE qty=3')
        self.assertEqual(result['status'],'needs_review',result)


if __name__ == '__main__':
    unittest.main()
