"""A user column named rowid is not evidence of a system column."""
import unittest
from core.system_column_contract import check_rowid_source, check_sequence_system_target


class SystemColumnContractTests(unittest.TestCase):
    table = 'g_a3_cs_system_owner'
    setup = ['CREATE TABLE g_a3_cs_system_owner (id INTEGER) WITH (hasrowid = on);']
    teardown = ['DROP TABLE g_a3_cs_system_owner RESTRICT;']
    gates = {'compatibility_mode':['A'], 'case_namespace':['fresh_user_schema'],
             'executor_authority':['create_any_table_and_sequence']}

    def test_documented_storage_creates_identity_without_guessing_type(self):
        p = check_rowid_source(self.setup,self.teardown,self.gates,self.table)
        self.assertEqual(p['system_column_names'],['rowid','rowno'])
        self.assertIsNone(p['system_column_types'])
        self.assertFalse(p['catalog_identity_proven'])
        self.assertTrue(p['requires_owned_dependency_inventory'])

    def test_user_columns_modes_and_extra_storage_options_cannot_fake_identity(self):
        for old,new in [('id INTEGER','id INTEGER, rowid INTEGER'),
                        ('id INTEGER','rowno INTEGER'), ('hasrowid = on','hasrowid = off'),
                        ('hasrowid = on','hasrowid = on, oids = false'),
                        ('hasrowid = on','hasrowid = on, hasuids = false'),
                        ('CREATE TABLE','CREATE TEMP TABLE'), ('CREATE TABLE','CREATE UNLOGGED TABLE')]:
            with self.subTest(new=new),self.assertRaises(ValueError):
                check_rowid_source([s.replace(old,new) for s in self.setup],self.teardown,self.gates,self.table)
        for mode in [[],['B'],['M'],['PG'],['A','B']]:
            with self.subTest(mode=mode),self.assertRaises(ValueError):
                check_rowid_source(self.setup,self.teardown,{**self.gates,'compatibility_mode':mode},self.table)

    def test_target_sequence_is_unqualified_and_exactly_same_fresh_namespace(self):
        for column in ('rowid','rowno'):
            p=check_sequence_system_target('CREATE SEQUENCE seq_test OWNED BY '+self.table+'.'+column+';',
                                          self.setup,self.teardown,self.gates,self.table,column)
            self.assertEqual(p['target_column'],column)
            self.assertFalse(p['target_error_proven'])
        for sql in ['CREATE SEQUENCE public.seq_test OWNED BY '+self.table+'.rowid;',
                    'CREATE SEQUENCE seq_test OWNED BY other.rowid;',
                    'CREATE SEQUENCE seq_test OWNED BY '+self.table+'.id;',
                    'CREATE SEQUENCE IF NOT EXISTS seq_test OWNED BY '+self.table+'.rowid;']:
            with self.subTest(sql=sql),self.assertRaises(ValueError):
                check_sequence_system_target(sql,self.setup,self.teardown,self.gates,self.table,'rowid')

    def test_seed_cleanup_and_namespace_drift_remain_blocked(self):
        for setup,cleanup in [(self.setup+['SELECT 1;'],self.teardown),
                              (self.setup,['DROP TABLE '+self.table+' CASCADE;']),
                              (self.setup,[]), (['DROP TABLE '+self.table+';']+self.setup,self.teardown)]:
            with self.subTest(setup=setup),self.assertRaises(ValueError):
                check_rowid_source(setup,cleanup,self.gates,self.table)
        with self.assertRaises(ValueError):
            check_rowid_source(self.setup,self.teardown,{'compatibility_mode':['A']},self.table)
