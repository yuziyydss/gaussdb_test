"""A proved direct VIEW is a read source, not a proved writable VIEW target."""
import hashlib
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write


class MergeViewSourceContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INTEGER, note VARCHAR(64), n INTEGER DEFAULT 7)',
             'CREATE TABLE b (id INTEGER NOT NULL, note VARCHAR(64), n INTEGER DEFAULT 99)',
             'CREATE VIEW v AS SELECT id, note, n FROM b']
    sql = ('MERGE INTO t dst USING v src ON (dst.id = src.id) '
           'WHEN MATCHED THEN UPDATE SET note = src.note, n = DEFAULT '
           'WHEN NOT MATCHED THEN INSERT (id, note) VALUES (src.id, src.note)')

    def check(self, sql=None, setup=None, scope='general'):
        return inspect_write(self.sql if sql is None else sql,
                             self.setup if setup is None else setup,
                             conflict_source_scope=scope)

    def test_direct_read_source_uses_distinct_identity_and_target_defaults(self):
        r = self.check()
        self.assertEqual(r['status'], 'checked', r)
        self.assertIn('merge_direct_view_source_columns', r['checks'])
        self.assertNotIn('merge_ordinary_source_target_columns', r['checks'])
        self.assertIn('shared_ordinary_defaults', r['checks'])
        self.assertEqual(r['scope'], 'finite_write_shape_only')

    def test_star_qualified_projection_and_explicit_renaming(self):
        for ddl in ('CREATE VIEW v AS SELECT * FROM b',
                    'CREATE VIEW v AS SELECT x.id, x.note, x.n FROM b AS x',
                    'CREATE VIEW v (id, note, n) AS SELECT id AS key, note AS label, n AS value FROM b'):
            r = self.check(setup=self.setup[:2]+[ddl])
            self.assertEqual(r['status'], 'checked', r)

    def test_filters_do_not_bypass_source_identity_or_action_checks(self):
        sql = self.sql.replace('dst.id = src.id', 'dst.id = src.id AND src.id > 0')
        sql += ' WHERE src.id > 0'
        r = self.check(sql)
        self.assertEqual(r['status'], 'checked', r)
        self.assertIn('merge_source_integer_on_filter', r['checks'])
        self.assertIn('merge_source_integer_action_filter', r['checks'])
        r = self.check(sql.replace('note = src.note', 'id = src.id'))
        self.assertEqual(r['status'], 'rejected', r)
        self.assertEqual(r['issues'][0]['code'], 'merge_join_key_update_not_supported')

    def test_source_projection_missing_column_is_not_hidden(self):
        r = self.check(setup=self.setup[:2]+['CREATE VIEW v AS SELECT id, n FROM b'])
        self.assertEqual(r['status'], 'rejected', r)
        self.assertEqual(r['issues'][0]['code'], 'missing_column')

    def test_width_and_nullable_domain_still_require_proof(self):
        for setup in ([self.setup[0], self.setup[1].replace('VARCHAR(64)', 'VARCHAR(128)'), self.setup[2]],
                      [self.setup[0].replace('note VARCHAR(64)', 'note VARCHAR(64) NOT NULL')]+self.setup[1:]):
            self.assertEqual(self.check(setup=setup)['status'], 'needs_review')

    def test_view_target_and_default_inheritance_remain_unknown(self):
        sql = self.sql.replace('INTO t dst USING v', 'INTO v dst USING t')
        self.assertEqual(self.check(sql)['status'], 'needs_review')
        for sql in ('INSERT INTO v (id, n) VALUES (1, DEFAULT)',
                    'UPDATE v SET n = DEFAULT'):
            self.assertEqual(self.check(sql)['status'], 'needs_review')

    def test_computed_filtered_nested_or_ambiguous_source_stays_review(self):
        for ddl in ('CREATE VIEW v AS SELECT id + 1 AS id, note, n FROM b',
                    'CREATE VIEW v AS SELECT id, note, n FROM b WHERE id > 0',
                    'CREATE VIEW v AS SELECT id, id AS n, note FROM b'):
            self.assertEqual(self.check(setup=self.setup[:2]+[ddl])['status'], 'needs_review')
        self.assertEqual(self.check(setup=self.setup+['CREATE VIEW w AS SELECT * FROM v'],
                                   sql=self.sql.replace('USING v', 'USING w'))['status'], 'needs_review')

    def test_ordered_ddl_invalidation_cannot_supply_a_view_proof(self):
        for tail in (['DROP VIEW v'], ['ALTER TABLE b ADD COLUMN extra INTEGER'],
                     ['DROP TABLE b', self.setup[1]], [self.setup[2]],
                     ['SET search_path = public'], ['DO $$ BEGIN NULL; END $$']):
            self.assertEqual(self.check(setup=self.setup+tail)['status'], 'needs_review', tail)
        self.assertEqual(self.check(setup=[self.setup[0], self.setup[2], self.setup[1]])['status'], 'needs_review')

    def test_unknown_source_and_other_modes_do_not_borrow_view_proof(self):
        self.assertEqual(self.check(setup=self.setup[:2])['status'], 'needs_review')
        for mode in ('m_compat', 'unknown', None):
            self.assertEqual(self.check(scope=mode)['status'], 'needs_review')


class MergeViewSourceConsumersTests(unittest.TestCase):
    def test_seven_actual_view_consumers_have_source_backed_read_identity(self):
        from core.factor_package_model import FactorPackageRegistry
        from core.factor_package_generator import FactorPackageSQLGenerator
        root = Path(__file__).resolve().parents[1]
        registry = FactorPackageRegistry(root/'specs')
        registry.load_all()
        cases = FactorPackageSQLGenerator(registry).generate_cases_for_manifest(
            registry.manifests['manifest_merge_regular_positive'])
        selected = [c for c in cases if 'USING v_merge_source ' in c.sql]
        suffixes = {'1a9662a51ea2', '6435d1c70629', '00b6e21ee739', 'ab62d8bc9e3a',
                    '7c5f153bc59f', '88f3320b2f70', '58445c29efc4'}
        self.assertEqual({c.case_id for c in selected},
                         {'manifest_merge_regular_positive_'+s for s in suffixes})
        for case in selected:
            r = inspect_write(case.sql, case.setup_sqls)
            self.assertEqual(r['status'], 'checked', r)
            self.assertIn('merge_direct_view_source_columns', r['checks'])
            self.assertEqual(case.expected, 'success')
            self.assertTrue(any(s.startswith('CREATE VIEW v_merge_source AS SELECT') for s in case.setup_sqls))
        source = root/'work/doc2spec/full_general_corpus/general/dml/merge_into.txt'
        self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(),
                         registry.factors['merge_into'].source.artifact_sha256)
        self.assertIn('源表可以为表、视图或子查询', source.read_text())


if __name__ == '__main__':
    unittest.main()
