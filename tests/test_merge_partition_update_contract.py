"""A selected RANGE partition is not an INSERT row-routing proof."""
import hashlib
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write, finite_insert_partition, ddl_tables


class MergePartitionUpdateTests(unittest.TestCase):
    ddl = ('CREATE TABLE t (id INTEGER NOT NULL, note VARCHAR(64), n INTEGER DEFAULT 7) '
           'PARTITION BY RANGE(id) (PARTITION p_low VALUES LESS THAN(100), '
           'PARTITION p_high VALUES LESS THAN(MAXVALUE));')
    source = 'CREATE TABLE s (id INTEGER NOT NULL, note VARCHAR(64), n INTEGER);'
    update = 'WHEN MATCHED THEN UPDATE SET note=src.note, n=DEFAULT'

    def sql(self, selector='PARTITION(p_low)', action=None, alias='AS dst', source='s AS src'):
        return ('MERGE INTO t ' + selector + ' ' + alias + ' USING ' + source +
                ' ON (dst.id=src.id) ' + (self.update if action is None else action) + ';')

    def check(self, sql=None, setup=None, scope='general'):
        return inspect_write(sql or self.sql(), [self.ddl, self.source] if setup is None else setup,
                             conflict_source_scope=scope)

    def test_named_and_for_selectors_share_range_definition_without_insert_alias_rule(self):
        for selector in ('PARTITION(p_low)', 'PARTITION FOR(1)', 'PARTITION FOR(100)', 'PARTITION(p_high)'):
            for alias in ('AS dst', 'dst'):
                with self.subTest(selector=selector, alias=alias):
                    r = self.check(self.sql(selector, alias=alias))
                    self.assertEqual(r['status'], 'checked', r)
                    self.assertIn('merge_range_partition_target_columns', r['checks'])
                    self.assertIn('merge_partition_key_unchanged', r['checks'])
                    self.assertNotIn('merge_ordinary_source_target_columns', r['checks'])

    def test_query_source_and_branch_filter_retain_their_own_evidence(self):
        sql = self.sql(source='(SELECT id,note,n FROM s) AS src', action=self.update+' WHERE src.id > 0')
        r = self.check(sql)
        self.assertEqual(r['status'], 'checked', r)
        self.assertIn('merge_direct_query_source_columns', r['checks'])
        self.assertIn('merge_source_integer_action_filter', r['checks'])

    def test_missing_partition_and_outside_for_bounds_are_not_silent(self):
        r = self.check(self.sql('PARTITION(absent)'))
        self.assertEqual(r['status'], 'rejected', r)
        self.assertEqual(r['issues'][0]['code'], 'missing_partition')
        r = self.check(self.sql('PARTITION FOR(100)'),
                       setup=[self.ddl.replace('MAXVALUE', '100'), self.source])
        self.assertEqual(r['status'], 'needs_review', r)  # duplicate upper bound, not a valid DDL
        r = self.check(self.sql('PARTITION FOR(101)'),
                       setup=[self.ddl.replace('MAXVALUE', '101'), self.source])
        self.assertEqual(r['status'], 'rejected', r)
        self.assertEqual(r['issues'][0]['code'], 'partition_out_of_range')

    def test_partition_key_update_does_not_borrow_nonmoving_column_proof(self):
        # The original ON-key ban still wins when the key is actually in ON.
        r = self.check(self.sql(action='WHEN MATCHED THEN UPDATE SET id=src.id'))
        self.assertEqual(r['issues'][0]['code'], 'merge_join_key_update_not_supported')
        for assignment in ('id=src.id', '(id,note)=(src.id,src.note)'):
            sql = self.sql(action='WHEN MATCHED THEN UPDATE SET '+assignment).replace('dst.id=src.id', 'dst.n=src.n')
            r = self.check(sql)
            self.assertEqual(r['status'], 'needs_review', r)
            self.assertEqual(r['issues'][0]['code'], 'partition_movement')

    def test_insert_branches_require_separate_closed_seed_routing(self):
        insert = 'WHEN NOT MATCHED THEN INSERT(id,note) VALUES(src.id,src.note)'
        for action in (insert, self.update+' '+insert):
            r = self.check(self.sql(action=action), setup=[self.ddl, self.source,
                "INSERT INTO s(id,note,n) VALUES(1,'x',2);"])
            self.assertEqual(r['status'], 'checked', r)
            self.assertIn('merge_closed_seed_partition_sufficiency', r['checks'])
        for action in (insert, 'WHEN NOT MATCHED THEN INSERT DEFAULT VALUES'):
            r = self.check(self.sql(action=action))
            self.assertEqual(r['status'], 'needs_review', r)
            self.assertEqual(r['issues'][0]['code'], 'partition_routing_unknown')
        r = self.check(self.sql(action='WHEN NOT MATCHED THEN INSERT DEFAULT VALUES'),
                       setup=[self.ddl,self.source,"INSERT INTO s(id,note,n) VALUES(1,'x',2);"])
        self.assertEqual(r['status'], 'needs_review', r)

    def test_ddl_must_be_fully_consumed_and_finite(self):
        for ddl in (self.ddl.replace('RANGE(id)', 'HASH(id)'),
                    self.ddl.replace('RANGE(id)', 'RANGE(id,n)'),
                    self.ddl.replace('RANGE(id)', 'RANGE(id) SUBPARTITION BY RANGE(n)'),
                    self.ddl.replace('p_high', 'p_low'),
                    self.ddl.replace(';', ' WITH(append_mode=on);'),
                    self.ddl.replace('100', '2147483648'),
                    self.ddl.replace('id INTEGER NOT NULL', 'id TEXT'),
                    self.ddl.replace('n INTEGER DEFAULT 7', 'n INTEGER GENERATED ALWAYS AS(id+1) STORED')):
            with self.subTest(ddl=ddl):
                self.assertEqual(self.check(setup=[ddl, self.source])['status'], 'needs_review')
        for selector in ('SUBPARTITION(p_low)', 'PARTITION(p_low,p_high)', 'PARTITION FOR(1+1)'):
            self.assertEqual(self.check(self.sql(selector))['status'], 'needs_review')

    def test_mode_invalidated_ddl_and_shared_evidence_guards_remain(self):
        for scope in ('m_compat', 'unknown', None):
            self.assertEqual(self.check(scope=scope)['status'], 'needs_review')
        for mutation in ('ALTER TABLE t ADD COLUMN extra INTEGER;', 'SET search_path=public;',
                         'CREATE TRIGGER opaque BEFORE UPDATE ON t EXECUTE PROCEDURE unknown();',
                         'CALL mutate_assets();', 'DROP TABLE t;', 'COMMIT;'):
            self.assertEqual(self.check(setup=[self.ddl, self.source, mutation])['status'], 'needs_review')

    def test_assignment_domains_and_original_negative_rules_are_not_bypassed(self):
        for action, code in (('WHEN MATCHED THEN UPDATE SET n=NULL', 'null_not_allowed'),
                             ('WHEN MATCHED THEN UPDATE SET missing=1', 'missing_column'),
                             ('', 'merge_action_required'),
                             (self.update+' '+self.update, 'duplicate_merge_when_clause')):
            r = self.check(self.sql(action=action), setup=[self.ddl.replace('n INTEGER DEFAULT 7', 'n INTEGER NOT NULL DEFAULT 7'),self.source])
            self.assertEqual(r['status'], 'rejected', r)
            self.assertEqual(r['issues'][0]['code'], code)

    def test_insert_wrapper_still_requires_as_after_partition(self):
        from core.finite_sql_contract import ReviewNeeded
        t = ddl_tables([self.ddl])['t']
        with self.assertRaisesRegex(ReviewNeeded, 'requires AS'):
            finite_insert_partition('PARTITION(p_low) dst (id)', t)

    def test_for_selector_value_must_fit_actual_key_type(self):
        for value in ('2147483648', '-2147483649', '1'*33):
            r = self.check(self.sql('PARTITION FOR('+value+')'))
            self.assertEqual(r['status'], 'needs_review', r)

    def test_invalid_ddl_cannot_supply_missing_partition_error_evidence(self):
        ddl = self.ddl.replace('100', '2147483648').replace('MAXVALUE', '2147483649')
        for selector in ('PARTITION(absent)', 'PARTITION FOR(2147483650)'):
            r = self.check(self.sql(selector), setup=[ddl, self.source])
            self.assertEqual(r['status'], 'needs_review', r)

    def test_six_real_candidates_distinguish_update_and_seed_route_evidence(self):
        root = Path(__file__).resolve().parents[1]
        report = json.loads((root/'generated/factor_packages/generation_report.json').read_text())
        cases = report['manifests']['manifest_merge_partition_positive']['cases']
        self.assertEqual(len(cases), 6)
        checked = set()
        for c in cases:
            r = inspect_write(c['sql'], c['setup_sqls'])
            self.assertEqual(r['status'], 'checked', r)
            if 'WHEN NOT MATCHED' in c['sql']:
                self.assertIn('merge_closed_seed_partition_sufficiency', r['checks'])
            else:
                self.assertNotIn('merge_closed_seed_partition_sufficiency', r['checks'])
                checked.add(c['case_id'])
        self.assertEqual(checked, {'manifest_merge_partition_positive_'+s for s in ('b6ebe19905fb','00c0b4e423e5')})
        for name, digest in (
            ('dml/merge_into', '93f70c3df5248a9a586af7372d871b94e165afcdb1eb17344bfba7dd59dfd85b'),
            ('ddl/create_table_partition', '91cfbfe0e38657456505b8d7dc02b85fb652c2f1703b7bfb1c13461122a95a67')):
            p = root/'work/doc2spec/full_general_corpus/general'/ (name+'.txt')
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(), digest)


if __name__ == '__main__':
    unittest.main()
