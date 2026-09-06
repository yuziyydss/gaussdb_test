"""Shared evidence must not confuse unknowns, statement semantics or execution."""
import unittest

from core.finite_sql_contract import inspect_write


class SharedColumnContractTests(unittest.TestCase):
    ddl = "CREATE TABLE t (id INTEGER NOT NULL, note VARCHAR(8) DEFAULT 'ok', qty INT DEFAULT 7);"

    def check(self, sql, status='checked', setup=None, code=None):
        result = inspect_write(sql, setup or [self.ddl])
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [i['code'] for i in result['issues']], result)
        self.assertEqual(result['scope'], 'finite_write_shape_only')
        return result

    def test_insert_and_update_share_explicit_defaults(self):
        for sql in ("INSERT INTO t VALUES (1, DEFAULT, DEFAULT)",
                    "UPDATE t SET (note, qty) = (DEFAULT, DEFAULT)"):
            self.check(sql)

    def test_update_does_not_fill_unassigned_nonnull_column(self):
        self.check('UPDATE t SET note = DEFAULT')
        self.check('INSERT INTO t (note) VALUES (DEFAULT)', 'rejected', code='null_not_allowed')

    def test_insert_omitted_reordered_and_prefix_columns(self):
        for sql in ("INSERT INTO t (note,id) VALUES ('x',1)",
                    'INSERT INTO t VALUES (1)',
                    'INSERT INTO t SELECT 1',
                    'INSERT INTO t (id) VALUES (1),(2)'):
            self.check(sql)

    def test_default_values_and_proven_absence(self):
        self.check('INSERT INTO t DEFAULT VALUES', setup=[
            "CREATE TABLE t (id INT DEFAULT 701, note TEXT, enabled BOOL DEFAULT TRUE)"])
        self.check('UPDATE t SET note = DEFAULT')
        self.check('UPDATE t SET id = DEFAULT', 'rejected', code='null_not_allowed')

    def test_explicit_null_not_null_is_a_contradiction(self):
        self.check('UPDATE t SET id = DEFAULT', 'rejected',
                   setup=['CREATE TABLE t (id INT DEFAULT NULL NOT NULL)'], code='null_not_allowed')

    def test_unknown_default_and_unsupported_ddl_remain_review(self):
        for ddl in ('CREATE TABLE t (id INT DEFAULT nextval(\'seq\'))',
                    'CREATE TABLE t (id custom_domain)',
                    'CREATE TABLE t (id INT GENERATED ALWAYS AS (1) STORED)',
                    'CREATE TABLE t (id INT) WITH (fillfactor=70)',
                    'CREATE TABLE t (id INT DEFAULT 1 garbage)',
                    'CREATE TABLE t (id INT, PRIMARY KEY(id))'):
            with self.subTest(ddl=ddl):
                self.check('INSERT INTO t DEFAULT VALUES', 'needs_review', setup=[ddl])

    def test_narrow_default_not_proved_by_type_family(self):
        for ddl in ('CREATE TABLE t (id SMALLINT DEFAULT 40000)',
                    "CREATE TABLE t (id VARCHAR(2) DEFAULT 'long')",
                    "CREATE TABLE t (id INT DEFAULT '1')"):
            self.check('INSERT INTO t DEFAULT VALUES', 'needs_review', setup=[ddl])

    def test_view_projection_names_and_write_types(self):
        setup = [self.ddl, 'CREATE VIEW v (key, label) AS SELECT id, note FROM t']
        self.check("INSERT INTO v VALUES (1,'ok')", setup=setup)
        self.check("UPDATE v SET label='ok'", setup=setup)
        self.check('UPDATE v SET missing=1', 'rejected', setup, 'missing_column')
        self.check('UPDATE v SET label=1', 'needs_review', setup, 'conversion_unknown')

    def test_view_hidden_required_base_column_is_not_ignored(self):
        setup = [self.ddl, 'CREATE VIEW v AS SELECT note FROM t']
        self.check("INSERT INTO v VALUES ('ok')", 'rejected', setup, 'null_not_allowed')
        self.check("UPDATE v SET note='ok'", setup=setup)

    def test_complex_readonly_and_unknown_view_defaults_stay_review(self):
        for view in ('SELECT id+1 AS id FROM t', 'SELECT id FROM t WITH READ ONLY',
                     'SELECT id FROM t WITH CHECK OPTION', 'SELECT id FROM t WHERE id>0',
                     'SELECT t.id FROM t JOIN t x ON t.id=x.id'):
            self.check('UPDATE v SET id=1', 'needs_review', setup=[self.ddl, 'CREATE VIEW v AS '+view])
        self.check('UPDATE v SET id=DEFAULT', 'needs_review', setup=[self.ddl, 'CREATE VIEW v AS SELECT id FROM t'])

    def test_base_or_view_ddl_change_invalidates_evidence(self):
        setup = [self.ddl, 'CREATE VIEW v AS SELECT id,note FROM t']
        for suffix in (['ALTER TABLE t ALTER COLUMN note SET DEFAULT \'new\''],
                       ['DROP TABLE t', self.ddl], ['DROP VIEW v'],
                       ['ALTER VIEW v RENAME TO another'], ['PREPARE TRANSACTION \'x\''],
                       ['CREATE TRIGGER tr BEFORE UPDATE ON t EXECUTE PROCEDURE f()']):
            self.check("UPDATE v SET note='ok'", 'needs_review', setup + suffix)
        self.check('UPDATE t SET note=DEFAULT', 'needs_review',
                   [self.ddl, "ALTER TABLE t ALTER COLUMN note SET DEFAULT 'new'"])
        self.check('UPDATE t SET note=DEFAULT', setup=[self.ddl, 'DROP TABLE t', self.ddl])

    def test_no_default_expansion_in_replace_or_cte(self):
        self.check('REPLACE INTO t VALUES (1,DEFAULT,DEFAULT)', 'needs_review')
        self.check('WITH c(x) AS (VALUES (DEFAULT)) INSERT INTO t(id) SELECT x FROM c', 'rejected',
                   code='default_in_values_cte')

    def test_multirow_values_cannot_use_different_prefix_widths(self):
        self.check("INSERT INTO t VALUES (1),(2,'ok')", 'rejected', code='arity')

    def test_view_aliases_do_not_swallow_incomplete_keywords(self):
        for keyword in ('WHERE', 'JOIN', 'LIMIT', 'GROUP', 'UNION', 'WITH'):
            self.check('UPDATE v SET id=1', 'needs_review',
                       setup=[self.ddl, 'CREATE VIEW v AS SELECT id FROM t '+keyword])

    def test_ddl_evidence_preserves_default_states_and_hashes(self):
        from core.shared_column_contract import ordinary_columns
        import hashlib
        ddl = "CREATE TABLE t (a INT, b INT DEFAULT NULL, c INT DEFAULT 1, d INT DEFAULT f(), e INT DEFAULT unknown)"
        columns = ordinary_columns(ddl)
        self.assertEqual([c['default_state'] for c in columns.values()],
                         ['absent', 'null', 'constant', 'dynamic', 'unparsed'])
        self.assertEqual(columns['a']['ddl_sha256'], hashlib.sha256(ddl.encode()).hexdigest())
        self.assertNotEqual(columns['a']['ddl_sha256'], ordinary_columns(ddl.replace('DEFAULT 1', 'DEFAULT 2'))['a']['ddl_sha256'])

    def test_missing_or_invalidated_evidence_does_not_become_null(self):
        self.check('UPDATE t SET id=DEFAULT', 'needs_review', setup=['BEGIN'])
        self.check('UPDATE t SET id=DEFAULT', 'needs_review', setup=[self.ddl, 'ROLLBACK'])
        self.check('UPDATE t SET note=DEFAULT', 'needs_review',
                   setup=[self.ddl, 'SET search_path TO another'])


if __name__ == '__main__':
    unittest.main()
