"""Finite contract: actual plain nullable ADD identity and ordinal position."""
import unittest
from core import shared_column_contract as contract
from core.finite_sql_contract import Contradiction, ReviewNeeded

DDL='CREATE TABLE add_source (id INTEGER,code VARCHAR(32),note VARCHAR(64));'
SEED="INSERT INTO add_source VALUES (1,'alpha','one'),(2,'beta','two');"
FIRST='ALTER TABLE add_source ADD COLUMN extra INTEGER FIRST;'
AFTER='ALTER TABLE add_source ADD extra INTEGER AFTER code;'

class AddPositionContractTests(unittest.TestCase):
    def check(self,sql=FIRST,setup=None,**kw):
        options=dict(profile_target='add_source',added_column='extra',compatibility_modes=['B'])
        options.update(kw)
        return contract.check_rendered_column_add(sql,[DDL,SEED] if setup is None else setup,**options)

    def test_actual_first_and_after_define_two_different_orders(self):
        for sql,names in ((FIRST,['extra','id','code','note']),(AFTER,['id','code','extra','note'])):
            result=self.check(sql)
            self.assertEqual(result['before_columns'],['id','code','note'])
            self.assertEqual(result['after_columns'],names)
            self.assertTrue(result['added_nullable'])
            self.assertEqual(result['added_default_state'],'absent')

    def test_new_name_and_after_anchor_must_match_actual_ddl(self):
        for sql,ddl in ((FIRST,DDL.replace('note VARCHAR(64)','extra VARCHAR(64)')),
                        (AFTER.replace('AFTER code','AFTER missing'),DDL)):
            with self.subTest(sql=sql),self.assertRaises(Contradiction):self.check(sql,[ddl])

    def test_actual_target_and_added_column_cannot_drift(self):
        for sql in (FIRST.replace('add_source','other'),FIRST.replace('extra INTEGER','wrong INTEGER')):
            with self.subTest(sql=sql),self.assertRaises(Contradiction):self.check(sql)

    def test_definitions_and_unreviewed_shapes_are_not_silent_success(self):
        for sql in (FIRST.replace('INTEGER','INTEGER DEFAULT 7'),FIRST.replace('INTEGER','INTEGER NOT NULL'),
                    FIRST.replace('INTEGER','BIGINT'),FIRST.replace('ADD COLUMN','ADD COLUMN IF NOT EXISTS'),
                    FIRST.replace(' FIRST',''),FIRST+' DROP TABLE add_source;',FIRST.replace('ADD','/*x*/ ADD')):
            with self.subTest(sql=sql),self.assertRaises(ReviewNeeded):self.check(sql)

    def test_only_plain_fresh_ddl_and_finite_seed_are_accepted(self):
        for setup in ([DDL,DDL],[DDL,'ALTER TABLE add_source DROP COLUMN code;'],
                      [DDL,'CREATE INDEX idx ON add_source (code);'],[DDL,'CALL change_table();'],
                      [DDL.replace('id INTEGER','id INTEGER PRIMARY KEY')],
                      [DDL.replace('code VARCHAR(32)','code VARCHAR(32) DEFAULT \'x\'')],
                      [DDL,"INSERT INTO add_source VALUES (1,'x','y',4);"]):
            with self.subTest(setup=setup),self.assertRaises(ReviewNeeded):self.check(setup=setup)

    def test_mode_is_explicitly_source_scoped(self):
        self.check(compatibility_modes=['M'],position_compatibility_mode='M')
        for modes,scope in ((['PG'],'B'),(['M'],'B'),(['B'],'M'),(['M','B'],'M'),(['PG'],'PG')):
            with self.subTest(modes=modes,scope=scope),self.assertRaises(ReviewNeeded):
                self.check(compatibility_modes=modes,position_compatibility_mode=scope)


if __name__=='__main__':unittest.main()
