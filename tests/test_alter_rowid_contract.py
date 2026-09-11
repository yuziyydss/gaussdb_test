"""Existing hasrowid tables cannot stand in for a fresh ROWID transition."""
import unittest
from core.system_column_contract import check_alter_rowid_target


class AlterRowidContractTests(unittest.TestCase):
    table='g_a3_at_rowid'
    setup=['CREATE TABLE g_a3_at_rowid (id INTEGER) WITH (hasrowid = off);']
    cleanup=['DROP TABLE g_a3_at_rowid RESTRICT;']
    gates={'compatibility_mode':['A'],'case_namespace':['fresh_user_schema'],
           'table_authority':['fixture_table_creator']}
    sql='ALTER TABLE g_a3_at_rowid SET WITH ROWID;'

    def check(self,sql=None,setup=None,gates=None):
        return check_alter_rowid_target(sql or self.sql,self.setup if setup is None else setup,
                                       self.cleanup,self.gates if gates is None else gates,self.table)

    def test_finite_transition_is_planned_not_observed(self):
        p=self.check()
        self.assertEqual(p['planned_transition'],{'hasrowid_before':False,'hasrowid_after':True})
        self.assertFalse(p['catalog_identity_proven'])
        self.assertFalse(p['transition_executed'])
        self.assertTrue(p['requires_owned_dependency_inventory'])

    def test_already_on_or_fake_system_columns_are_not_valid_preconditions(self):
        for old,new in [('off','on'),('id INTEGER','id INTEGER,rowid INTEGER'),
                        ('hasrowid = off','hasrowid = off,oids=false'),
                        ('CREATE TABLE','CREATE TEMP TABLE'),('CREATE TABLE','CREATE FOREIGN TABLE')]:
            with self.subTest(new=new),self.assertRaises(ValueError):
                self.check(setup=[s.replace(old,new) for s in self.setup])

    def test_only_reviewed_action_and_mode_are_admitted(self):
        for sql in ['ALTER TABLE g_a3_at_rowid SET (hasrowid=on);',
                    'ALTER TABLE other SET WITH ROWID;',
                    'ALTER TABLE ONLY g_a3_at_rowid SET WITH ROWID;',
                    'ALTER TABLE g_a3_at_rowid SET WITH ROWID, ADD COLUMN extra INTEGER;']:
            with self.subTest(sql=sql),self.assertRaises(ValueError):self.check(sql=sql)
        for mode in (['M'],['A','B'],[]):
            with self.subTest(mode=mode),self.assertRaises(ValueError):
                self.check(gates={**self.gates,'compatibility_mode':mode})
