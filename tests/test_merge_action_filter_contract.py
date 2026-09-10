"""Typed action WHERE is not ON matching, input filtering, or a row oracle."""
import unittest
from core.finite_sql_contract import inspect_write


class MergeActionFilterTests(unittest.TestCase):
    setup=['CREATE TABLE t (id INTEGER,n INTEGER,note VARCHAR(64))',
           'CREATE TABLE s (id INTEGER,n INTEGER,note VARCHAR(64))']
    update='WHEN MATCHED THEN UPDATE SET n=src.n'
    insert='WHEN NOT MATCHED THEN INSERT (id,n,note) VALUES (src.id,src.n,src.note)'
    def check(self, action, *, condition='dst.id=src.id', setup=None, scope='general'):
        return inspect_write('MERGE INTO t dst USING s src ON ('+condition+') '+action,
                             self.setup if setup is None else setup,conflict_source_scope=scope)

    def test_each_action_and_both_orders_keep_their_own_filter(self):
        u=self.update+' WHERE src.n > -7';i=self.insert+' WHERE src.id > 0'
        for body in (u,i,u+' '+i,i+' '+u,u+' '+self.insert,self.update+' '+i):
            r=self.check(body)
            self.assertEqual(r['status'],'checked',r)
            self.assertIn('merge_source_integer_action_filter',r['checks'])
            self.assertEqual(r['scope'],'finite_write_shape_only')
            self.assertNotIn('expected_rows',r)

    def test_on_and_action_filter_evidence_are_separate(self):
        r=self.check(self.update+' WHERE src.n > 0',condition='dst.id=src.id AND src.id > 0')
        self.assertEqual(r['status'],'checked',r)
        self.assertIn('merge_source_integer_on_filter',r['checks'])
        self.assertIn('merge_source_integer_action_filter',r['checks'])

    def test_filter_cannot_hide_action_target_errors(self):
        for body,code in [('WHEN MATCHED THEN UPDATE SET id=src.id WHERE src.n > 0','merge_join_key_update_not_supported'),
                          ('WHEN MATCHED THEN UPDATE SET absent=src.id WHERE src.n > 0','missing_column'),
                          ('WHEN NOT MATCHED THEN INSERT (id,n) VALUES (src.id) WHERE src.n > 0','arity')]:
            r=self.check(body);self.assertEqual(r['status'],'rejected',r)
            self.assertEqual(r['issues'][0]['code'],code)

    def test_no_implicit_system_column_coercion_or_arbitrary_predicates(self):
        for predicate in ('src.ctid > 0','src.absent > 0','dst.n > 0','other.n > 0',
                          'src.note > 0','src.n > NULL',"src.n > '0'",'src.n > 1.5',
                          'src.n > 2147483648','src.n >= 0','src.n > 0 OR src.id > 0',
                          'src.n > (SELECT 0)','src.n > 0 WHERE src.id > 0','',
                          'src.n > 0 AND src.id > 0'):
            self.assertEqual(self.check(self.update+' WHERE '+predicate)['status'],'needs_review',predicate)

    def test_typed_nullable_predicate_does_not_prove_assignment_nullability(self):
        target='CREATE TABLE t (id INTEGER,n INTEGER NOT NULL,note VARCHAR(64))'
        r=self.check(self.update+' WHERE src.n > 0',setup=[target,self.setup[1]])
        self.assertEqual(r['status'],'needs_review',r)

    def test_default_values_and_literal_keyword_do_not_confuse_clause_split(self):
        for body in ('WHEN NOT MATCHED THEN INSERT DEFAULT VALUES WHERE src.id > 0',
                     "WHEN MATCHED THEN UPDATE SET note='WHERE src.n > 0' WHERE src.id > 0"):
            self.assertEqual(self.check(body)['status'],'checked',body)

    def test_unknown_modes_are_not_changed(self):
        for scope in ('m_compat','unknown',None):
            self.assertEqual(self.check(self.update+' WHERE src.n > 0',scope=scope)['status'],'needs_review')


if __name__=='__main__':unittest.main()
