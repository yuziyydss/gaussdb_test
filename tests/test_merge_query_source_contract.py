"""Finite read projections do not prove arbitrary SELECT or derived writes."""
import hashlib
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write


class MergeQuerySourceContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INTEGER, note VARCHAR(64), n INTEGER DEFAULT 7)',
             'CREATE TABLE s (id INTEGER NOT NULL, note VARCHAR(64), n INTEGER)']
    query = 'SELECT id, note, n FROM s'
    action = ('WHEN MATCHED THEN UPDATE SET note = src.note, n = DEFAULT '
              'WHEN NOT MATCHED THEN INSERT (id, note) VALUES (src.id, src.note)')

    def sql(self, query=None):
        return 'MERGE INTO t dst USING ('+(query or self.query)+') AS src ON (dst.id = src.id) '+self.action

    def check(self, sql=None, setup=None, scope='general'):
        return inspect_write(self.sql() if sql is None else sql,
                             self.setup if setup is None else setup,
                             conflict_source_scope=scope)

    def test_read_projection_has_its_own_identity(self):
        r = self.check()
        self.assertEqual(r['status'], 'checked', r)
        self.assertIn('merge_direct_query_source_columns', r['checks'])
        self.assertNotIn('merge_direct_view_source_columns', r['checks'])
        self.assertNotIn('merge_ordinary_source_target_columns', r['checks'])
        self.assertEqual(r['scope'], 'finite_write_shape_only')
        self.assertIn('shared_ordinary_defaults', r['checks'])

    def test_star_qualified_columns_and_renaming(self):
        for query in ('SELECT * FROM s', 'SELECT x.id, x.note, x.n FROM s AS x',
                      'SELECT id AS key, note, n FROM s'):
            sql = self.sql(query)
            if 'AS key' in query:
                sql = sql.replace('src.id', 'src.key')
            self.assertEqual(self.check(sql)['status'], 'checked', sql)

    def test_source_alias_is_separate_from_inner_alias(self):
        sql = self.sql('SELECT inner_s.id, inner_s.note, inner_s.n FROM s inner_s')
        self.assertEqual(self.check(sql.replace(') AS src', ') src'))['status'], 'checked')
        for bad in (sql.replace('src.note', 'inner_s.note'),
                    sql.replace(') AS src', ')'), sql.replace(') AS src', ') AS dst'),
                    sql.replace(') AS src', ') AS SELECT')):
            self.assertEqual(self.check(bad)['status'], 'needs_review', bad)

    def test_subquery_predicates_and_opaque_projections_stay_review(self):
        for query in ('SELECT id, note, n FROM s WHERE id > 0',
                      'SELECT id + 1 AS id, note, n FROM s',
                      'SELECT DISTINCT id, note, n FROM s',
                      'SELECT id, note, n FROM s ORDER BY id',
                      'SELECT id, note, n FROM (SELECT * FROM s) x',
                      'SELECT id, note, n FROM s UNION SELECT id, note, n FROM s',
                      'SELECT id, note, n FROM s JOIN t ON s.id=t.id',
                      'SELECT id, id AS n, note FROM s'):
            self.assertEqual(self.check(self.sql(query))['status'], 'needs_review', query)

    def test_missing_output_and_action_restrictions_are_not_bypassed(self):
        r = self.check(self.sql('SELECT id, n FROM s'))
        self.assertEqual(r['status'], 'rejected', r)
        self.assertEqual(r['issues'][0]['code'], 'missing_column')
        r = self.check(self.sql().replace('note = src.note', 'id = src.id'))
        self.assertEqual(r['status'], 'rejected', r)
        self.assertEqual(r['issues'][0]['code'], 'merge_join_key_update_not_supported')

    def test_on_and_action_where_are_outside_the_source_query(self):
        sql = self.sql().replace('dst.id = src.id', 'dst.id = src.id AND src.id > 0')+' WHERE src.id > 0'
        r = self.check(sql)
        self.assertEqual(r['status'], 'checked', r)
        self.assertIn('merge_source_integer_on_filter', r['checks'])
        self.assertIn('merge_source_integer_action_filter', r['checks'])
        self.assertEqual(self.check(sql.replace('WHERE src.id > 0', 'WHERE dst.id > 0'))['status'], 'needs_review')

    def test_unknown_views_ctes_and_stale_source_remain_review(self):
        for query in ('SELECT * FROM missing', 'SELECT * FROM v'):
            setup = self.setup+['CREATE VIEW v AS SELECT * FROM s']
            self.assertEqual(self.check(self.sql(query), setup)['status'], 'needs_review')
        for tail in (['ALTER TABLE s ADD COLUMN x INTEGER'], ['DROP TABLE s'],
                     ['SET search_path = public'], ['DO $$ BEGIN NULL; END $$']):
            self.assertEqual(self.check(setup=self.setup+tail)['status'], 'needs_review')
        self.assertEqual(self.check('WITH q AS (SELECT * FROM s) '+self.sql('SELECT * FROM q'))['status'], 'needs_review')

    def test_physical_domains_and_nullability_are_preserved(self):
        for setup in ([self.setup[0], self.setup[1].replace('VARCHAR(64)', 'VARCHAR(128)')],
                      [self.setup[0].replace('note VARCHAR(64)', 'note VARCHAR(64) NOT NULL'), self.setup[1]],
                      [self.setup[0], self.setup[1].replace('id INTEGER', 'id BIGINT')]):
            self.assertEqual(self.check(setup=setup)['status'], 'needs_review')

    def test_target_partition_and_other_modes_are_still_gated(self):
        for sql in (self.sql().replace('INTO t dst', 'INTO t PARTITION(p1) dst'),
                    self.sql().replace('INTO t dst', 'INTO (SELECT * FROM t) dst')):
            self.assertEqual(self.check(sql)['status'], 'needs_review')
        for mode in ('m_compat', 'unknown', None):
            self.assertEqual(self.check(scope=mode)['status'], 'needs_review')

    def test_unparsed_source_suffix_and_second_statement_stay_review(self):
        for sql in (self.sql().replace(') AS src ON', ') garbage AS src ON'),
                    self.sql().replace(') AS src ON', ') AS src(extra) ON'),
                    self.sql('SELECT id, note, n FROM s; SELECT 1'),
                    self.sql().replace('USING (', 'USING ((')):
            self.assertEqual(self.check(sql)['status'], 'needs_review')


class MergeQuerySourceConsumersTests(unittest.TestCase):
    def test_seven_ordinary_consumers_and_three_partition_consumers_stay_distinct(self):
        from core.factor_package_model import FactorPackageRegistry
        from core.factor_package_generator import FactorPackageSQLGenerator
        root = Path(__file__).resolve().parents[1]
        registry = FactorPackageRegistry(root/'specs'); registry.load_all()
        gen = FactorPackageSQLGenerator(registry)
        regular = gen.generate_cases_for_manifest(registry.manifests['manifest_merge_regular_positive'])
        selected = [c for c in regular if 'USING (SELECT ' in c.sql]
        expected = {'05c55ec2ae1b', '9a1e67b81028', '7ea324b42a63', '5115fd60b8eb',
                    '26d429395db3', 'd131a3b094bc', 'a3020be6fedb'}
        self.assertEqual({c.case_id for c in selected},
                         {'manifest_merge_regular_positive_'+s for s in expected})
        for c in selected:
            r = inspect_write(c.sql, c.setup_sqls)
            self.assertEqual(r['status'], 'checked', r)
            self.assertIn('merge_direct_query_source_columns', r['checks'])
            self.assertEqual(c.expected, 'success')
        partitions = gen.generate_cases_for_manifest(registry.manifests['manifest_merge_partition_positive'])
        subset = [c for c in partitions if 'USING (SELECT ' in c.sql]
        self.assertEqual(len(subset), 3)
        for c in subset:
            r = inspect_write(c.sql, c.setup_sqls)
            if c.case_id == 'manifest_merge_partition_positive_b6ebe19905fb':
                self.assertEqual(r['status'], 'checked')
                self.assertIn('merge_range_partition_target_columns', r['checks'])
            else:
                self.assertEqual(r['status'], 'checked')
                self.assertIn('merge_closed_seed_partition_sufficiency', r['checks'])
        source = root/'work/doc2spec/full_general_corpus/general/dml/merge_into.txt'
        self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(),
                         registry.factors['merge_into'].source.artifact_sha256)


if __name__ == '__main__':
    unittest.main()
