"""ADD/RENAME/MODIFY share real finite seed admission, not shape-only INSERT."""
import unittest
from core import shared_column_contract as shared
from core.finite_sql_contract import ReviewNeeded, Contradiction

DDL='CREATE TABLE t (id INTEGER,code VARCHAR(32),note VARCHAR(64),amount INTEGER);'
SEED="INSERT INTO t VALUES (1,'alpha','one',10),(2,'beta','two',20);"


class FreshColumnFixtureContractTests(unittest.TestCase):
    def check(self,kind,seed=SEED):
        setup=[DDL,seed]
        if kind=='add':
            return shared.check_rendered_column_add('ALTER TABLE t ADD extra INTEGER FIRST;',setup,
                profile_target='t',added_column='extra',compatibility_modes=['B'])
        if kind=='rename':
            return shared.check_rendered_column_rename('ALTER TABLE t CHANGE code new_code VARCHAR(32);',setup,
                profile_target='t',source_column='code',target_column='new_code',compatibility_modes=['B'])
        return shared.check_rendered_column_modify('ALTER TABLE t MODIFY (note VARCHAR(96),amount NOT NULL);',setup,
            profile_target='t',widen_column='note',not_null_column='amount')

    def test_column_names_are_not_stored_values_in_fresh_seed(self):
        for kind in ('add','rename','modify'):
            with self.subTest(kind=kind),self.assertRaises(ReviewNeeded):
                self.check(kind,SEED.replace('(1,','(id,'))

    def test_old_string_limits_apply_to_all_transition_consumers(self):
        for kind in ('add','rename','modify'):
            for text in ('a'*80,'中文'):
                with self.subTest(kind=kind,text=text),self.assertRaises(ReviewNeeded):
                    self.check(kind,SEED.replace('one',text))

    def test_actual_finite_literals_keep_all_three_consumers(self):
        for kind in ('add','rename','modify'):
            self.assertEqual(self.check(kind)['before_columns'],['id','code','note','amount'])

    def test_null_seed_is_allowed_until_a_consumer_requires_not_null(self):
        seed=SEED.replace('20)','NULL)')
        for kind in ('add','rename'):
            self.assertEqual(self.check(kind,seed)['before_columns'],['id','code','note','amount'])
        with self.assertRaises(Contradiction) as raised:self.check('modify',seed)
        self.assertEqual(raised.exception.code,'column_modify_seed_null')

    def test_query_and_partial_seed_do_not_look_like_full_literal_rows(self):
        for kind in ('add','rename','modify'):
            for seed in ('INSERT INTO t SELECT id,code,note,amount FROM t;',
                         'INSERT INTO t(id) VALUES(1);'):
                with self.subTest(kind=kind,seed=seed),self.assertRaises(ReviewNeeded):self.check(kind,seed)


if __name__=='__main__':unittest.main()
