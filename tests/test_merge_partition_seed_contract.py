"""Closed literal seed history gives a sufficient route, not matching rows."""
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write, ddl_tables, ReviewNeeded
import core.shared_column_contract as shared


class ClosedLiteralSourceTests(unittest.TestCase):
    ddl = 'CREATE TABLE s (id INTEGER NOT NULL, note VARCHAR(8));'
    seed = "INSERT INTO s (note,id) VALUES ('one',1),('two',2);"

    def inspect(self, setup=None, scope='general'):
        setup = [self.ddl, self.seed] if setup is None else setup
        # Exercise this helper's own boundary, not ddl_tables' earlier rejection
        # of malformed seed SQL. End-to-end MERGE tests retain the real pipeline.
        declarations = [s for s in setup if s.startswith('CREATE TABLE s ')]
        table = shared.attach_shared_contracts(ddl_tables(declarations), declarations).get('s')
        helper = getattr(shared, 'closed_literal_source_rows', None)
        self.assertIsNotNone(helper)
        return helper(table, setup, source_scope=scope)

    def test_full_column_lists_are_reordered_and_history_is_fingerprinted(self):
        proof = self.inspect()
        self.assertEqual(proof['rows'], [{'note': "'one'", 'id': '1'}, {'note': "'two'", 'id': '2'}])
        self.assertEqual(proof['table'], 's')
        self.assertEqual(len(proof['setup_sha256']), 64)
        self.assertFalse(proof['database_executed'])
        other = self.inspect([self.ddl, self.seed.replace("'two'", "'new'")])
        self.assertNotEqual(proof['setup_sha256'], other['setup_sha256'])

    def test_unreviewed_unicode_numeric_or_whitespace_syntax_stays_unknown(self):
        for seed in ("INSERT INTO s VALUES(١,'one');", "INSERT INTO s VALUES(１,'one');",
                     "INSERT\u00a0INTO s VALUES(1,'one');", "\u00a0INSERT INTO s VALUES(1,'one');"):
            with self.subTest(seed=seed), self.assertRaises(ReviewNeeded):
                self.inspect([self.ddl,seed])

    def test_multiple_full_seed_statements_and_positional_values(self):
        p = self.inspect([self.ddl, "INSERT INTO s VALUES(1,'one');", "INSERT INTO s VALUES(2,'two');"])
        self.assertEqual(len(p['rows']), 2)

    def test_invalid_seed_is_setup_unknown_not_a_target_oracle(self):
        for seed in ("INSERT INTO s(id) VALUES(1);", "INSERT INTO s(id,id) VALUES(1,2);",
                     "INSERT INTO s VALUES(NULL,'one');", "INSERT INTO s VALUES(DEFAULT,'one');",
                     "INSERT INTO s VALUES(2147483648,'one');", "INSERT INTO s VALUES(1,'overlong-value');",
                     "INSERT INTO s VALUES(1+1,'one');", "INSERT INTO s VALUES(1,make_note());",
                     "INSERT INTO s SELECT 1,'one';", "INSERT INTO s VALUES(1,'one') RETURNING *;",
                     "INSERT INTO s VALUES(1,'one'); DELETE FROM s;", "INSERT INTO s VALUES(1,'中文');"):
            with self.subTest(seed=seed), self.assertRaises(ReviewNeeded) as raised:
                self.inspect([self.ddl, seed])
            self.assertEqual(raised.exception.code, 'source_rows_unknown')

    def test_nonclosed_history_empty_source_and_other_modes_are_reviewed(self):
        histories = [[self.ddl], [self.ddl,self.seed,'UPDATE s SET id=200;'],
                     [self.ddl,self.seed,'DELETE FROM s;'], [self.ddl,self.seed,'TRUNCATE s;'],
                     [self.ddl,self.seed,'CREATE TABLE unrelated(id INTEGER);'],
                     ['CALL install_behavior();',self.ddl,self.seed],
                     [self.ddl,self.seed,'SET search_path=public;'],
                     [self.ddl,self.seed,'DROP TABLE s;'], [self.ddl,self.seed,self.ddl]]
        for setup in histories:
            with self.subTest(setup=setup), self.assertRaises(ReviewNeeded):
                self.inspect(setup)
        for mode in ('m_compat', 'unknown', None):
            with self.assertRaises(ReviewNeeded):
                self.inspect(scope=mode)

    def test_constraints_and_dynamic_defaults_do_not_supply_successful_seed_history(self):
        for ddl in (self.ddl.replace('NOT NULL', 'PRIMARY KEY'),
                    self.ddl.replace('NOT NULL', 'DEFAULT nextval(\'seq\')'),
                    self.ddl.replace('note VARCHAR(8)', 'note VARCHAR(8) UNIQUE')):
            with self.assertRaises(ReviewNeeded):
                self.inspect([ddl,self.seed])

    def test_opaque_prefix_cannot_install_behavior_before_source_creation(self):
        for prefix in (['SELECT install_seed_trigger();'],
                       ['CREATE EVENT TRIGGER opaque ON ddl_command_end EXECUTE PROCEDURE f();'],
                       ['CREATE TABLE other(id INTEGER DEFAULT install_seed_trigger());',
                        'INSERT INTO other VALUES(DEFAULT);'],
                       ['CREATE TABLE other(id INTEGER);', 'INSERT INTO other VALUES(install_seed_trigger());'],
                       ['CREATE TABLE other(id custom_type);'],
                       ['INSERT INTO external_view VALUES(1);'],
                       ['CREATE TABLE other(id INTEGER);', 'INSERT INTO other SELECT 1;'],
                       ['CREATE TABLE other(id INTEGER);', 'UPDATE other SET id=install_seed_trigger();'],
                       ['BEGIN;', 'COMMIT;']):
            with self.subTest(prefix=prefix), self.assertRaises(ReviewNeeded):
                self.inspect(prefix+[self.ddl,self.seed])

    def test_finite_prefix_has_actual_table_identity_and_literal_inputs(self):
        p=self.inspect(['DROP TABLE IF EXISTS other;', 'CREATE TABLE other(id INTEGER);',
                        'INSERT INTO other VALUES(7);', self.ddl,self.seed])
        self.assertEqual(len(p['rows']),2)
        for prefix in (['CREATE TABLE other(id INTEGER);','DROP TABLE other;','INSERT INTO other VALUES(7);'],
                       ['CREATE TABLE other(id INTEGER);','CREATE TABLE other(id INTEGER);'],
                       ['CREATE TABLE other(id INTEGER);','INSERT INTO other VALUES(2147483648);'],
                       ['CREATE TABLE other(id INTEGER);','INSERT INTO other(id,id) VALUES(1,2);']):
            with self.subTest(prefix=prefix), self.assertRaises(ReviewNeeded):
                self.inspect(prefix+[self.ddl,self.seed])


class MergeSeedRouteTests(unittest.TestCase):
    ddl = ('CREATE TABLE t(id INTEGER NOT NULL, note VARCHAR(8)) PARTITION BY RANGE(id) '
           '(PARTITION p_low VALUES LESS THAN(100), PARTITION p_high VALUES LESS THAN(MAXVALUE));')
    source = ClosedLiteralSourceTests.ddl
    seed = ClosedLiteralSourceTests.seed
    update = 'WHEN MATCHED THEN UPDATE SET note=src.note '
    insert = 'WHEN NOT MATCHED THEN INSERT(id,note) VALUES(src.id,src.note)'

    def sql(self, source='s src', selector='PARTITION(p_low)', action=None):
        return 'MERGE INTO t '+selector+' dst USING '+source+' ON(dst.id=src.id) '+(self.insert if action is None else action)+';'

    def inspect(self, sql=None, setup=None, scope='general'):
        return inspect_write(sql or self.sql(), [self.ddl,self.source,self.seed] if setup is None else setup,
                             conflict_source_scope=scope)

    def test_all_seed_keys_in_partition_are_sufficient_for_any_insert_subset(self):
        for action in (self.insert, self.update+self.insert, self.insert+' '+self.update,
                       self.insert+' WHERE src.id > 0'):
            r = self.inspect(self.sql(action=action))
            self.assertEqual(r['status'], 'checked', r)
            self.assertIn('merge_closed_seed_partition_sufficiency', r['checks'])
            self.assertNotIn('matched_rows', r)

    def test_query_projection_tracks_actual_origin_not_output_name(self):
        sql = self.sql(source='(SELECT id AS k,note FROM s) src').replace('src.id','src.k')
        r = self.inspect(sql)
        self.assertEqual(r['status'], 'checked', r)
        self.assertIn('merge_direct_query_source_columns', r['checks'])
        self.assertIn('merge_closed_seed_partition_sufficiency', r['checks'])

    def test_outside_seed_only_fails_sufficient_condition_not_target_sqlstate(self):
        setup = [self.ddl,self.source,self.seed.replace("'two',2", "'two',100")]
        for action in (self.insert, self.insert+' WHERE src.id > 200', self.update+self.insert):
            r = self.inspect(self.sql(action=action),setup)
            self.assertEqual(r['status'], 'needs_review', r)
            self.assertEqual(r['issues'][0]['code'], 'partition_routing_unknown')
        # A source-side WHERE might filter a row: do not classify it as failure.

    def test_key_must_be_direct_and_source_history_nonempty_and_closed(self):
        for key in ('DEFAULT','1+1','1'):
            r = self.inspect(self.sql().replace('VALUES(src.id,src.note)','VALUES('+key+',src.note)'))
            self.assertEqual(r['status'], 'needs_review', r)
        for setup in ([self.ddl,self.source], [self.ddl,self.source,self.seed,'UPDATE s SET id=101;']):
            self.assertEqual(self.inspect(setup=setup)['status'], 'needs_review')
        for mode in ('m_compat','unknown'):
            self.assertEqual(self.inspect(scope=mode)['status'], 'needs_review')

    def test_view_or_filtered_source_and_partition_movement_stay_separate(self):
        setup = [self.ddl,self.source,self.seed,'CREATE VIEW v AS SELECT id,note FROM s;']
        self.assertEqual(self.inspect(self.sql(source='v src'),setup)['status'],'needs_review')
        self.assertEqual(self.inspect(self.sql(source='(SELECT id,note FROM s WHERE id>0) src'))['status'],'needs_review')
        r = self.inspect(self.sql(action='WHEN MATCHED THEN UPDATE SET id=src.id '+self.insert))
        self.assertEqual(r['issues'][0]['code'], 'merge_join_key_update_not_supported')

    def test_opaque_prefix_is_reviewed_in_the_real_merge_pipeline(self):
        r=self.inspect(setup=['SELECT install_seed_trigger();',self.ddl,self.source,self.seed])
        self.assertEqual(r['status'],'needs_review',r)
        self.assertEqual(r['issues'][0]['code'],'partition_routing_unknown')

    def test_prefix_partition_seed_is_checked_without_manufacturing_target_error(self):
        ddl=self.ddl.replace('MAXVALUE','101')
        for key,status in (('1','checked'),('200','needs_review'),('NULL','needs_review'),
                           ('install_seed_trigger()','needs_review')):
            r=self.inspect(setup=[ddl,"INSERT INTO t VALUES("+key+",'old');",self.source,self.seed])
            self.assertEqual(r['status'],status,r)
            if status=='needs_review':
                self.assertEqual(r['issues'][0]['code'],'partition_routing_unknown')

    def test_all_six_real_partition_candidates_keep_scope_and_oracle(self):
        p = Path(__file__).resolve().parents[1]/'generated/factor_packages/generation_report.json'
        cases = json.loads(p.read_text())['manifests']['manifest_merge_partition_positive']['cases']
        self.assertEqual(len(cases),6)
        routed = []
        for c in cases:
            r = inspect_write(c['sql'],c['setup_sqls'])
            self.assertEqual(r['status'],'checked',r)
            if 'WHEN NOT MATCHED' in c['sql']:
                self.assertIn('merge_closed_seed_partition_sufficiency',r['checks'])
                routed.append(c['case_id'])
        self.assertEqual(set(routed), {'manifest_merge_partition_positive_'+s for s in
                                     ('b6398f118924','67bd1ac408d2','ed005b85af34','08dcc307d031')})


if __name__ == '__main__':
    unittest.main()
