"""Actual DDL evidence for a bounded ordinary-column rename transition."""
import unittest
from core import shared_column_contract as contract
from core.finite_sql_contract import Contradiction, ReviewNeeded

DDL='CREATE TABLE rename_source (id INTEGER,code VARCHAR(32),note VARCHAR(64));'
SEED="INSERT INTO rename_source VALUES (1,'alpha','one'),(2,'beta','two');"
RENAME='ALTER TABLE rename_source RENAME COLUMN code TO code_new;'
CHANGE='ALTER TABLE rename_source CHANGE COLUMN code code_new VARCHAR(32);'


class ColumnRenameContractTests(unittest.TestCase):
    def check(self,sql=RENAME,setup=None,**kw):
        options=dict(profile_target='rename_source',source_column='code',target_column='code_new',
                     compatibility_modes=['B'])
        options.update(kw)
        return contract.check_rendered_column_rename(sql,[DDL,SEED] if setup is None else setup,**options)

    def test_two_syntax_forms_share_same_real_column_transition(self):
        for sql in (RENAME,CHANGE):
            result=self.check(sql)
            self.assertEqual(result['before_columns'],['id','code','note'])
            self.assertEqual(result['after_columns'],['id','code_new','note'])
            self.assertEqual(result['definition_changed'],False)

    def test_missing_source_and_existing_destination_reject_actual_ddl(self):
        for ddl in (DDL.replace('code VARCHAR(32)','other VARCHAR(32)'),
                    DDL.replace('note VARCHAR(64)','code_new VARCHAR(64)')):
            with self.subTest(ddl=ddl),self.assertRaises(Contradiction):self.check(setup=[ddl])

    def test_actual_sql_must_match_declared_target_and_mapping(self):
        for sql in (RENAME.replace('rename_source','other_table'),RENAME.replace('code_new','newer'),
                    RENAME.replace('COLUMN code ','COLUMN note ')):
            with self.subTest(sql=sql),self.assertRaises(Contradiction):self.check(sql)

    def test_change_definition_and_dependent_shapes_remain_unreviewed(self):
        for sql,ddl in ((CHANGE.replace('(32)','(96)'),DDL),
                        (CHANGE,DDL.replace('code VARCHAR(32)','code VARCHAR(32) DEFAULT \'x\'')),
                        (CHANGE,DDL.replace('code VARCHAR(32)','code VARCHAR(32) NOT NULL')),
                        (RENAME,DDL.replace('id INTEGER','id INTEGER PRIMARY KEY')),
                        (RENAME,DDL.replace('code VARCHAR(32)','code VARCHAR(32) UNIQUE'))):
            with self.subTest(sql=sql,ddl=ddl),self.assertRaises(ReviewNeeded):self.check(sql,[ddl])

    def test_opaque_or_mutating_setup_cannot_supply_fresh_shape(self):
        for setup in ([DDL,DDL],[DDL,'ALTER TABLE rename_source DROP COLUMN code;'],
                      [DDL,'CREATE INDEX idx ON rename_source (code);'],
                      [DDL,'CALL change_table();'],[DDL,'DROP TABLE rename_source;'],
                      [DDL,"INSERT INTO rename_source VALUES (1,'x','y',4);"],
                      [DDL.replace('rename_source','other_table')]):
            with self.subTest(setup=setup),self.assertRaises(ReviewNeeded):self.check(setup=setup)

    def test_complex_target_and_statement_boundaries_are_not_guessed(self):
        for sql in (RENAME+' DROP TABLE rename_source;',RENAME.replace('RENAME','/*c*/ RENAME'),
                    CHANGE.replace(';',' FIRST;'),RENAME.replace('code TO','"code" TO')):
            with self.subTest(sql=sql),self.assertRaises(ReviewNeeded):self.check(sql)

    def test_b_only_change_cannot_inherit_general_rename_mode(self):
        for modes in ([],['PG'],['M'],['B','PG'],['B','B']):
            with self.subTest(modes=modes),self.assertRaises(ReviewNeeded):
                self.check(CHANGE,compatibility_modes=modes)
        self.check(RENAME,compatibility_modes=['PG'])

    def test_explicit_m_scope_shares_identity_but_not_general_b_gate(self):
        result=self.check(CHANGE,compatibility_modes=['M'],change_compatibility_mode='M')
        self.assertEqual(result['after_columns'],['id','code_new','note'])
        for modes,scope in ((['B'],'M'),(['M'],'B'),(['PG'],'PG'),(['M'],'arbitrary')):
            with self.subTest(modes=modes,scope=scope),self.assertRaises(ReviewNeeded):
                self.check(CHANGE,compatibility_modes=modes,change_compatibility_mode=scope)

    def test_m_change_scope_does_not_authorize_unreviewed_rename_production(self):
        with self.assertRaises(ReviewNeeded):
            self.check(RENAME,compatibility_modes=['M'],change_compatibility_mode='M')


if __name__=='__main__':unittest.main()
