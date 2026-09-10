"""Finite field evidence must not case-fold another function into a builtin."""
import unittest

from core.finite_sql_contract import Contradiction, ReviewNeeded
from core.query_output_contract import (
    check_documented_aggregate_types, check_documented_sum_types,
    check_rendered_aggregate_source,
)
from core.shared_column_contract import NON_COLUMN_EXPRESSIONS


class AggregateFieldIdentityTests(unittest.TestCase):
    def check(self, fn='SUM', item=None, name='qty', typ='INT', output=None):
        return check_documented_aggregate_types([item or f'{fn}({name})'],
            [output or ('DECIMAL' if fn == 'SUM' else 'INTEGER')], [name], [typ],
            mode='M', identity='m_builtin_' + fn.lower())

    def test_special_expression_names_do_not_become_integer_table_fields(self):
        # M 2.5.8 L144-199/L642-681 explicitly permits bare date/time calls.
        # Other names retain the existing direct-projection review boundary;
        # this is not a claim that each name is illegal in every SQL context.
        for fn in ('SUM', 'MIN', 'MAX'):
            for name in sorted(NON_COLUMN_EXPRESSIONS):
                for modifier in ('', 'ALL ', 'DISTINCT '):
                    with self.subTest(fn=fn, name=name, modifier=modifier):
                        with self.assertRaisesRegex(ReviewNeeded, 'function_expression_unknown'):
                            self.check(fn, item=f'{fn}({modifier}{name.lower()})', name=name)

    def test_ascii_spelling_is_not_unicode_ignore_case_equivalence(self):
        for item in ('ſUM(qty)', 'SUM(qtſ)', 'SUM(qtK)', 'SUM(qtı)', 'SUM(qtİ)',
                     'SUM(qty) AS reſult', 'SUM(DIſTINCT qty)', 'SUM(qty) Aſ result'):
            # Supply the exact apparent column too: absence must not conceal
            # accidental acceptance as an ASCII identifier.
            name = item.split('(')[1].split(')')[0]
            if ' ' in name: name = 'qty'
            with self.subTest(item=item), self.assertRaisesRegex(ReviewNeeded, 'function_expression_unknown'):
                self.check(item=item, name=name)

    def test_sum_source_and_output_types_keep_original_ascii_identity(self):
        for typ in ('ınt', 'ınteger', 'ınt4', 'decımal', 'numerıc'):
            with self.subTest(typ=typ), self.assertRaisesRegex(ReviewNeeded, 'function_argument_type_unknown'):
                self.check(typ=typ)
        for output in ('decımal', 'numerıc'):
            with self.subTest(output=output), self.assertRaisesRegex(ReviewNeeded, 'function_output_type_unknown'):
                self.check(output=output)

    def test_real_render_cannot_borrow_profile_ascii_sum_identity(self):
        for profile in ('SUM(qty)', 'ſUM(qty)'):
            # An ASCII profile already fails the earlier token-identity gate;
            # matching Unicode profile/SQL must fail the builtin contract too.
            error, code = ((Contradiction, 'query_projection_mismatch') if profile == 'SUM(qty)'
                           else (ReviewNeeded, 'function_expression_unknown'))
            with self.subTest(profile=profile), self.assertRaisesRegex(error, code):
                check_rendered_aggregate_source('SELECT ſUM(qty) FROM t',
                    ['CREATE TABLE t (qty INT);'], items=[profile], output_types=['DECIMAL'],
                    available_columns=['qty'], available_types=['INT'], source_tables=['t'],
                    mode='M', identity='m_builtin_sum')

    def test_ascii_case_spacing_modifiers_and_similar_column_names_remain_valid(self):
        for fn in ('SUM', 'MIN', 'MAX'):
            for name in ('qty', 'current_date_value', 'current_timestamp_col', 'username', 'allqty'):
                for modifier in ('', 'all ', 'distinct '):
                    with self.subTest(fn=fn, name=name, modifier=modifier):
                        self.assertEqual(self.check(fn, item=f'{fn.lower()} ( {modifier}{name} ) AS result',
                                                    name=name, typ='integer'), [0])
        for typ in (' int ', 'integer', 'int4', 'decimal', 'numeric'):
            self.assertEqual(self.check(typ=typ, output='decimal'), [0])
        for typ in ('float', 'double'):
            self.assertEqual(self.check(typ=typ, output='double'), [0])

    def test_legacy_sum_entry_and_missing_columns_keep_distinct_outcomes(self):
        with self.assertRaisesRegex(ReviewNeeded, 'function_expression_unknown'):
            check_documented_sum_types(['SUM(current_date)'], ['DECIMAL'], ['current_date'], ['INT'],
                                       mode='M', identity='m_builtin_sum')
        for fn in ('SUM', 'MIN', 'MAX'):
            with self.subTest(fn=fn), self.assertRaisesRegex(Contradiction, 'function_missing_column'):
                self.check(fn, item=f'{fn}(absent)')
        with self.assertRaisesRegex(Contradiction, 'function_output_type_mismatch'):
            self.check(output='INTEGER')


if __name__ == '__main__':
    unittest.main()
