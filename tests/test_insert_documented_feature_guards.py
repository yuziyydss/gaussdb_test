"""General INSERT L42-48 and L117; do not infer the ambiguous query-source ban."""
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from core.finite_sql_contract import inspect_write


class InsertDocumentedFeatureGuardTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT,qty INT)', 'CREATE VIEW v AS SELECT id,qty FROM t']

    def inspect(self, sql, scope='general', setup=None):
        return inspect_write(sql, self.setup if setup is None else setup, conflict_source_scope=scope)

    def test_known_view_or_derived_on_conflict_does_not_depend_on_action(self):
        for target in ('v', '(SELECT id,qty FROM t)'):
            for action in ('DO NOTHING', 'DO UPDATE SET qty=3'):
                with self.subTest(target=target, action=action):
                    result = self.inspect('INSERT INTO '+target+' VALUES(1,2) ON CONFLICT (id) '+action)
                    self.assertEqual(result['status'], 'rejected', result)
                    self.assertEqual(result['issues'][0]['code'], 'conflict_target_not_supported')

    def test_target_restriction_precedes_unknown_view_default(self):
        result = self.inspect('INSERT INTO v VALUES(1,DEFAULT) ON CONFLICT (id) DO NOTHING')
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'conflict_target_not_supported')

    def test_plain_table_named_like_view_is_not_forbidden(self):
        result = self.inspect('INSERT INTO v VALUES(1,2) ON CONFLICT (id) DO NOTHING',
                              setup=['CREATE TABLE v(id INT,qty INT)'])
        self.assertEqual(result['status'], 'checked', result)
        self.assertEqual(result['scope'], 'finite_write_shape_only')

    def test_stale_identity_and_keyword_strings_do_not_prove_forbidden_target(self):
        result = self.inspect('INSERT INTO v VALUES(1,2) ON CONFLICT (id) DO NOTHING',
                              setup=self.setup+['DROP VIEW v'])
        self.assertEqual(result['status'], 'needs_review', result)
        result = self.inspect("INSERT INTO v VALUES(1,'ON CONFLICT (id) DO NOTHING')",
                              setup=['CREATE TABLE t(id INT,qty TEXT)', 'CREATE VIEW v AS SELECT id,qty FROM t'])
        self.assertEqual(result['status'], 'checked', result)

    def test_outer_with_duplicate_is_forbidden_after_cte_identity_resolution(self):
        prefixes = ('WITH c AS (SELECT id,qty FROM t)',
                    'WITH RECURSIVE c(k) AS (VALUES(1) UNION ALL SELECT k+1 FROM c WHERE k<3)')
        for prefix in prefixes:
            with self.subTest(prefix=prefix):
                result = self.inspect(prefix+' INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE qty=3')
                self.assertEqual(result['status'], 'rejected', result)
                self.assertEqual(result['issues'][0]['code'], 'duplicate_with_not_supported')

    def test_with_without_duplicate_and_table_query_conflict_remain_finite(self):
        for tail in ('INSERT INTO t SELECT id,qty FROM c',
                     'INSERT INTO t SELECT id,qty FROM c ON CONFLICT (id) DO NOTHING'):
            result = self.inspect('WITH c AS (SELECT id,qty FROM t) '+tail)
            self.assertEqual(result['status'], 'checked', result)
            self.assertEqual(result['scope'], 'finite_write_shape_only')

    def test_m_and_unknown_scope_do_not_borrow_general_with_or_conflict_rule(self):
        for scope in ('m_compat', 'unreviewed'):
            for sql in ('INSERT INTO v VALUES(1,2) ON CONFLICT (id) DO NOTHING',
                        'WITH c AS (SELECT id,qty FROM t) INSERT INTO t VALUES(1,2) ON DUPLICATE KEY UPDATE qty=3'):
                self.assertNotEqual(self.inspect(sql, scope)['status'], 'rejected')

    def test_nested_or_literal_with_does_not_supply_outer_with(self):
        for sql in ("INSERT INTO t VALUES(1,'WITH c AS (SELECT 1)') ON DUPLICATE KEY UPDATE qty='x'",
                    "INSERT INTO t SELECT id,qty FROM (WITH c AS (SELECT id,qty FROM t) SELECT id,qty FROM c) q ON DUPLICATE KEY UPDATE qty='x'"):
            result = self.inspect(sql, setup=['CREATE TABLE t(id INT,qty TEXT)'])
            self.assertNotIn('duplicate_with_not_supported', [i['code'] for i in result['issues']])


if __name__ == '__main__':
    unittest.main()
