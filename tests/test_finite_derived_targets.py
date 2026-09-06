"""One direct base projection is not arbitrary writable SELECT syntax."""
import unittest
from core.finite_sql_contract import inspect_write


class FiniteDerivedTargetTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INT NOT NULL, note TEXT, qty INT DEFAULT 7)']

    def check(self, sql, status='checked', code=None, setup=None):
        result = inspect_write(sql, self.setup if setup is None else setup)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [i['code'] for i in result['issues']], result)
        return result

    def test_insert_literal_and_query_sources_share_projection(self):
        for sql in ("INSERT INTO (SELECT id,note FROM t) (id,note) VALUES (1,'ok')",
                    "INSERT INTO (SELECT id,note FROM t) AS dst (dst.note,dst.id) VALUES ('ok',1)",
                    'INSERT INTO (SELECT id,note FROM t) SELECT id,note FROM t'):
            result = self.check(sql)
            self.assertIn('single_base_direct_derived_target_columns', result['checks'])

    def test_update_literal_and_alias_reference(self):
        self.check("UPDATE (SELECT id,note FROM t) SET note='ok'")
        self.check('UPDATE (SELECT id,qty FROM t) AS dst SET dst.qty=dst.qty+1')
        self.check('UPDATE (SELECT b.id AS key,b.qty AS amount FROM t AS b) AS dst SET dst.amount=1')

    def test_target_columns_width_and_types_are_checked(self):
        self.check('UPDATE (SELECT id,note FROM t) SET missing=1', 'rejected', 'missing_column')
        self.check('INSERT INTO (SELECT id,note FROM t) (id,note) VALUES (1)', 'rejected', 'arity')
        self.check('UPDATE (SELECT id,note FROM t) SET note=1', 'needs_review', 'conversion_unknown')
        self.check('UPDATE (SELECT id,note FROM t) AS dst SET other.note=1', 'needs_review', 'qualifier_unknown')

    def test_hidden_required_column_checked_only_for_insert(self):
        self.check("INSERT INTO (SELECT note FROM t) VALUES ('ok')", 'rejected', 'null_not_allowed')
        self.check("UPDATE (SELECT note FROM t) SET note='ok'")

    def test_derived_defaults_are_not_assumed_to_be_base_defaults(self):
        self.check('UPDATE (SELECT qty FROM t) SET qty=DEFAULT', 'needs_review', 'default_unknown')
        self.check('INSERT INTO (SELECT id,qty FROM t) VALUES (1,DEFAULT)', 'needs_review', 'default_unknown')
        self.check('INSERT INTO (SELECT id,note FROM t) DEFAULT VALUES', 'needs_review')

    def test_complex_queries_and_unknown_objects_remain_review(self):
        for query in ('SELECT qty+1 AS qty FROM t', 'SELECT DISTINCT qty FROM t',
                      'SELECT qty FROM t WHERE id>0', 'SELECT t.qty FROM t JOIN t x ON t.id=x.id',
                      'SELECT qty FROM (SELECT qty FROM t) s', 'SELECT qty FROM t WITH READ ONLY',
                      'SELECT qty FROM t WITH CHECK OPTION', 'SELECT qty FROM missing',
                      'SELECT qty FROM t WHERE'):
            self.check('UPDATE ('+query+') SET qty=1', 'needs_review')
        self.check('WITH c AS (SELECT qty FROM t) UPDATE (SELECT qty FROM c) SET qty=1', 'needs_review')

    def test_partition_from_and_multiple_targets_not_silently_consumed(self):
        self.check('UPDATE (SELECT id,qty FROM t) PARTITION (p1) SET qty=1', 'needs_review')
        self.check('UPDATE (SELECT id,qty FROM t) AS dst SET qty=1 FROM t', 'needs_review')
        self.check('UPDATE (SELECT id,qty FROM t) AS dst, t AS b SET dst.qty=1', 'needs_review')

    def test_dangling_as_and_clause_keywords_are_not_target_aliases(self):
        for target in ('t', '(SELECT id,qty FROM t)'):
            for alias in ('AS', 'WHERE', 'JOIN'):
                self.check('UPDATE '+target+' '+alias+' SET qty=1', 'needs_review')
                self.check('INSERT INTO '+target+' '+alias+' VALUES (1,2)', 'needs_review')


if __name__ == '__main__':
    unittest.main()
