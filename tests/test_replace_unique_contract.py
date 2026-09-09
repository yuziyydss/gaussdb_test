"""Finite plain INT keys and actual seed rows; no database or SQL executor."""
import unittest
from core.finite_sql_contract import Contradiction, ReviewNeeded
from core import shared_column_contract as contract

SETUP = ['CREATE TABLE t (id INT PRIMARY KEY, qty INT UNIQUE);',
         'INSERT INTO t (id,qty) VALUES (1,10),(2,20);']
SQL = 'REPLACE INTO t (id,qty) VALUES (1,20);'


class ReplaceUniqueContractTests(unittest.TestCase):
    def check(self, sql=SQL, setup=None, count=2):
        return contract.check_rendered_replace_unique_keys(sql, SETUP if setup is None else setup,
            profile_target='t (id,qty)', required_keys={'id':'PRIMARY KEY','qty':'UNIQUE'}, expected_conflicts=count)

    def test_distinct_conflicting_rows_and_control(self):
        self.assertEqual(self.check()['conflicting_rows'], 2)
        self.assertEqual(self.check()['expected_rows'], [[1,20]])
        result = self.check(sql='REPLACE INTO t (id,qty) VALUES (3,30);', count=0)
        self.assertEqual(result['expected_rows'], [[1,10],[2,20],[3,30]])
        self.assertFalse(result['runtime_proven'])

    def test_missing_key_does_not_become_a_profile_proof(self):
        with self.assertRaisesRegex(Contradiction, 'unique_key'):
            self.check(setup=[SETUP[0].replace(' UNIQUE',''), SETUP[1]])

    def test_changed_source_or_seed_rejects_false_multi_conflict(self):
        with self.assertRaisesRegex(Contradiction, 'conflict_rows'):
            self.check(sql=SQL.replace('(1,20)', '(1,99)'))
        with self.assertRaisesRegex(Contradiction, 'conflict_rows'):
            self.check(setup=[SETUP[0], SETUP[1].replace('(2,20)', '(2,21)')])

    def test_seed_must_itself_respect_keys(self):
        with self.assertRaisesRegex(Contradiction, 'seed_unique'):
            self.check(setup=[SETUP[0], SETUP[1].replace('(2,20)', '(1,20)')])

    def test_wrong_target_opaque_ddl_and_unsupported_types_remain_unproved(self):
        with self.assertRaises(Contradiction):
            self.check(sql=SQL.replace('INTO t ', 'INTO another '))
        for setup in (SETUP+['ALTER TABLE t DROP CONSTRAINT key;'],
                      [SETUP[0].replace('qty INT UNIQUE', 'qty INT UNIQUE DEFERRABLE'), SETUP[1]],
                      [SETUP[0].replace('qty INT UNIQUE', 'qty TEXT UNIQUE'), SETUP[1]],
                      [SETUP[0], SETUP[1].replace('(1,10)', '(1,NULL)')],
                      [SETUP[0], SETUP[1].replace('(1,10)', '(1,2147483648)')]):
            with self.subTest(setup=setup), self.assertRaises(ReviewNeeded):
                self.check(setup=setup)

    def test_single_row_scope_is_not_sequential_or_query_evaluation(self):
        for sql in (SQL.replace('(1,20)', '(1,20),(1,30)'),
                    'REPLACE INTO t (id,qty) SELECT 1,20;',
                    'REPLACE INTO t SET id=1,qty=20;',
                    SQL+' DROP TABLE t;'):
            with self.subTest(sql=sql), self.assertRaises(ReviewNeeded):
                self.check(sql=sql)


if __name__ == '__main__':
    unittest.main()
