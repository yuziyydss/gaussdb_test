"""Actual DDL/seed arbitration; finite static evidence, never database proof."""
import unittest

from core.finite_sql_contract import ReviewNeeded


class InsertPartialIndexContractTests(unittest.TestCase):
    def setUp(self):
        self.setup = [
            'CREATE TABLE g_partial (id INTEGER NOT NULL, flag INTEGER NOT NULL) WITH (storage_type=ASTORE);',
            'CREATE UNIQUE INDEX g_partial_idx ON g_partial USING btree ((id + 1)) WHERE flag > 0;',
            'INSERT INTO g_partial (id, flag) VALUES (1, 1), (1, 0);',
        ]
        self.cleanup = ['DROP TABLE g_partial RESTRICT;']

    def check(self, row='1, 2', *, setup=None, sql=None, cleanup=None):
        from core.insert_partial_index_contract import check_partial_index_insert
        sql = sql or ('INSERT INTO g_partial (id, flag) VALUES ('+row+
                      ') ON CONFLICT ((id + 1)) WHERE flag > 0 DO NOTHING;')
        return check_partial_index_insert(sql, setup if setup is not None else self.setup,
                                          cleanup if cleanup is not None else self.cleanup)

    def test_three_arbitration_outcomes_from_actual_seed(self):
        for row, member, conflict, affected in [('1, 2', True, True, 0),
                                               ('2, 1', True, False, 1),
                                               ('1, 0', False, False, 1)]:
            with self.subTest(row=row):
                result = self.check(row)
                self.assertEqual(result['predicate_member'], member)
                self.assertEqual(result['conflict_in_finite_model'], conflict)
                self.assertEqual(result['expected_affected_rows'], affected)
                self.assertFalse(result['runtime_proven'])
                self.assertFalse(result['operator_identity_proven'])
                self.assertEqual(result['required_compatibility_mode'], 'PG')

    def test_real_index_is_required_and_not_a_primary_key_label(self):
        for index in [self.setup[1].replace(' UNIQUE', ''),
                      self.setup[1].replace('btree', 'gin'),
                      self.setup[1].replace('ON g_partial ', 'ON other '),
                      self.setup[1].replace('id + 1', 'id + 2'),
                      self.setup[1].replace('flag > 0', 'flag >= 0'),
                      self.setup[1].replace(' WHERE flag > 0', '')]:
            with self.subTest(index=index), self.assertRaises(ReviewNeeded):
                self.check(setup=[self.setup[0], index, self.setup[2]])
        with self.assertRaises(ReviewNeeded):
            self.check(setup=[self.setup[0], self.setup[2]])

    def test_target_predicate_and_expression_are_not_text_labels(self):
        for tail in ['((id + 2)) WHERE flag > 0', '((id + 1)) WHERE flag >= 1',
                     '((lower(id))) WHERE flag > 0', '((id + 1))',
                     '((flag + 1)) WHERE flag > 0', '(id) WHERE flag > 0']:
            with self.subTest(tail=tail), self.assertRaises(ReviewNeeded):
                self.check(sql='INSERT INTO g_partial (id, flag) VALUES (1, 2) ON CONFLICT '+tail+' DO NOTHING;')

    def test_typed_input_and_overflow_fail_closed(self):
        for row in ['2147483647, 1', '2147483648, 1', 'NULL, 1', "'1', 2", '1, TRUE', '1', '1, 2), (1, 3']:
            with self.subTest(row=row), self.assertRaises(ReviewNeeded):
                self.check(row)
        self.assertFalse(self.check('-2147483648, 1')['conflict_in_finite_model'])

    def test_seed_partial_membership_and_duplicates_checked(self):
        # Equal expression keys outside the partial predicate do not collide.
        seed = self.setup[2].replace('(1, 1), (1, 0)', '(1, 0), (1, 0)')
        self.assertFalse(self.check(setup=self.setup[:2]+[seed])['conflict_in_finite_model'])
        for rows in ['(1, 1), (1, 2)', '(2147483647, 1), (1, 0)']:
            with self.subTest(rows=rows), self.assertRaises(ReviewNeeded):
                self.check(setup=self.setup[:2]+[self.setup[2].replace('(1, 1), (1, 0)', rows)])

    def test_fresh_typed_table_and_precise_lifecycle(self):
        for ddl in [self.setup[0].replace('INTEGER', 'TEXT', 1),
                    self.setup[0].replace('CREATE TABLE', 'CREATE TABLE IF NOT EXISTS'),
                    self.setup[0].replace('ASTORE', 'USTORE'),
                    self.setup[0].replace(' NOT NULL', '', 1)]:
            with self.subTest(ddl=ddl), self.assertRaises(ReviewNeeded):
                self.check(setup=[ddl]+self.setup[1:])
        for setup in [self.setup+['SELECT 1;'], ['DROP TABLE g_partial;']+self.setup]:
            with self.assertRaises(ReviewNeeded):
                self.check(setup=setup)
        for cleanup in [[], ['DROP TABLE other RESTRICT;'], ['DROP TABLE g_partial CASCADE;']]:
            with self.assertRaises(ReviewNeeded):
                self.check(cleanup=cleanup)

    def test_identifier_case_and_whitespace_not_expression_equivalence(self):
        setup = [s.replace('g_partial', 'g_other').replace('id', 'K').replace('flag', 'S') for s in self.setup]
        sql = 'insert into G_OTHER (k,s) values(1,2) on conflict (( k+1 )) where S>0 do nothing;'
        result = self.check(setup=setup, sql=sql, cleanup=['drop table G_OTHER restrict;'])
        self.assertTrue(result['conflict_in_finite_model'])

    def test_opaque_or_extra_sql_never_matches(self):
        base = 'INSERT INTO g_partial (id, flag) VALUES (1, 2) ON CONFLICT ((id + 1)) WHERE flag > 0 DO NOTHING'
        for sql in [base+'; SELECT 1;', base+' -- comment', base+' RETURNING id;',
                    base.replace('DO NOTHING', 'DO UPDATE SET flag = 3')]:
            with self.subTest(sql=sql), self.assertRaises(ReviewNeeded):
                self.check(sql=sql)


if __name__ == '__main__':
    unittest.main()
