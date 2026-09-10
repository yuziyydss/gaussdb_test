"""Shared output contracts must not silently truncate positional evidence."""
import unittest

from core.finite_sql_contract import Contradiction
from core.shared_column_contract import check_direct_projection_types
from core.query_output_contract import check_documented_sum_types, check_rendered_sum_source


class QueryContractArityTests(unittest.TestCase):
    def sum_types(self, items, outputs, columns=None, types=None):
        return check_documented_sum_types(items, outputs,
                                         ['id'] if columns is None else columns,
                                         ['INT'] if types is None else types,
                                         mode='M', identity='m_builtin_sum')

    def test_direct_projection_rejects_short_and_long_output_type_lists(self):
        for outputs in ([], ['INT'], ['INT', 'INT', 'INT']):
            with self.subTest(outputs=outputs), self.assertRaises(Contradiction):
                check_direct_projection_types(['id', 'missing'], outputs, ['id'], ['INT'])

    def test_direct_source_mapping_rejects_short_and_long_type_lists(self):
        for types in ([], ['INT', 'TEXT']):
            with self.subTest(types=types), self.assertRaises(Contradiction):
                check_direct_projection_types(['id'], ['INT'], ['id'], types)

    def test_sum_rejects_short_and_long_output_type_lists(self):
        for outputs in ([], ['DECIMAL'], ['DECIMAL', 'DECIMAL', 'DECIMAL']):
            with self.subTest(outputs=outputs), self.assertRaises(Contradiction):
                self.sum_types(['SUM(id)', 'SUM(missing)'], outputs)

    def test_sum_source_mapping_rejects_short_and_long_type_lists(self):
        for types in ([], ['INT', 'TEXT']):
            with self.subTest(types=types), self.assertRaises(Contradiction):
                self.sum_types(['SUM(id)'], ['DECIMAL'], types=types)

    def test_rendered_sum_consumer_cannot_ignore_untyped_projection(self):
        with self.assertRaises(Contradiction):
            check_rendered_sum_source('SELECT SUM(id),SUM(missing) FROM t',
                ['CREATE TABLE t(id INT)'], items=['SUM(id)', 'SUM(missing)'],
                output_types=['DECIMAL'], available_columns=['id'], available_types=['INT'],
                source_tables=['t'], mode='M', identity='m_builtin_sum')

    def test_rendered_sum_consumer_rejects_extra_source_type(self):
        with self.assertRaises(Contradiction):
            check_rendered_sum_source('SELECT SUM(id) FROM t',
                ['CREATE TABLE t(id INT)'], items=['SUM(id)'], output_types=['DECIMAL'],
                available_columns=['id'], available_types=['INT', 'TEXT'],
                source_tables=['t'], mode='M', identity='m_builtin_sum')

    def test_complete_mappings_still_return_every_checked_position(self):
        self.assertEqual(check_direct_projection_types(['id', 'qty'], ['INT', 'TEXT'],
                                                       ['id', 'qty'], ['INT', 'TEXT']), [0, 1])
        self.assertEqual(self.sum_types(['SUM(id)', 'SUM(qty)'], ['DECIMAL', 'DOUBLE'],
                                        ['id', 'qty'], ['INT', 'FLOAT']), [0, 1])

    def test_matching_arity_does_not_promote_unknown_expressions(self):
        self.assertEqual(check_direct_projection_types(['id+1'], ['INT'], ['id'], ['INT']), [])


if __name__ == '__main__':
    unittest.main()
