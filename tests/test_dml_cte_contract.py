"""Inner write evidence and returned column shape are separate obligations."""
import json
from pathlib import Path
import unittest
from unittest.mock import patch
from core.finite_sql_contract import inspect_write


class DMLCTEContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INT, note TEXT)', 'CREATE TABLE a (id INT, note TEXT)']

    def check(self, inner, status='checked', code=None, tail=None, setup=None):
        result = inspect_write('WITH c AS ('+inner+') '+(tail or 'INSERT INTO t SELECT k,v FROM c'),
                               self.setup if setup is None else setup)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [i['code'] for i in result['issues']], result)
        return result

    def test_insert_and_update_returning_direct_aliases(self):
        for query in ("INSERT INTO a (id,note) VALUES (1,'x') RETURNING id AS k,note AS v",
                      "UPDATE a SET note='x' WHERE id=1 RETURNING id AS k,note AS v"):
            result = self.check(query)
            self.assertIn('finite_dml_cte_write_and_returning_columns', result['checks'])
            self.assertTrue(any(c.startswith('dml_cte:') for c in result['checks']))
            self.assertEqual(result['scope'], 'finite_write_shape_only')

    def test_inner_missing_column_arity_and_default_cannot_hide_behind_returning(self):
        self.check("INSERT INTO a (id,missing) VALUES (1,'x') RETURNING id AS k,note AS v",
                   'rejected', 'missing_column')
        self.check("INSERT INTO a (id,note) VALUES (1) RETURNING id AS k,note AS v", 'rejected', 'arity')
        self.check("UPDATE a SET missing=1 RETURNING id AS k,note AS v", 'rejected', 'missing_column')
        setup = ['CREATE TABLE t (id INT, note TEXT)', 'CREATE TABLE a (id INT DEFAULT clock_fn(), note TEXT)']
        self.check("INSERT INTO a VALUES (DEFAULT,'x') RETURNING id AS k,note AS v",
                   'needs_review', 'default_unknown', setup=setup)

    def test_returning_requires_actual_columns_and_unambiguous_labels(self):
        prefix = "INSERT INTO a VALUES (1,'x')"
        self.check(prefix+' RETURNING missing AS k,note AS v', 'rejected', 'missing_column')
        for output in ('', ' RETURNING', ' RETURNING id AS k,note AS k',
                       ' RETURNING id+1 AS k,note AS v', ' RETURNING id AS k,*',
                       ' RETURNING id AS k,note AS v ORDER BY id'):
            self.check(prefix+output, 'needs_review')

    def test_star_expansion_and_explicit_cte_output_names(self):
        self.check("INSERT INTO a VALUES (1,'x') RETURNING *", tail='INSERT INTO t SELECT id,note FROM c')
        sql = "WITH c(k,v) AS (INSERT INTO a VALUES (1,'x') RETURNING *) INSERT INTO t SELECT k,v FROM c"
        self.assertEqual(inspect_write(sql, self.setup)['status'], 'checked')

    def test_original_ordered_setup_not_reconstructed_ddl(self):
        inner = "INSERT INTO a VALUES (1,'x') RETURNING id AS k,note AS v"
        for setup in (self.setup+['ALTER TABLE a DROP COLUMN note'],
                      self.setup+['DROP TABLE a'], self.setup+['ROLLBACK'],
                      self.setup+['CREATE TABLE a (id INT,note TEXT)']):
            self.check(inner, 'needs_review', setup=setup)

    def test_inner_inspection_reuses_actual_sql_and_original_setup_once(self):
        inner = "INSERT INTO a VALUES (1,'x') RETURNING id AS k,note AS v"
        with patch('core.finite_sql_contract.inspect_write', wraps=inspect_write) as nested:
            self.check(inner)
        nested.assert_called_once_with(inner, self.setup, conflict_source_scope='general')
        self.assertIs(nested.call_args.args[1], self.setup)

    def test_cte_output_is_read_only_and_unused_inner_is_still_checked(self):
        self.check("UPDATE a SET note='x' RETURNING id AS k,note AS v", 'needs_review',
                   'target_unknown', tail='UPDATE c SET k=1')
        self.check("UPDATE a SET missing='x' RETURNING id AS k,note AS v", 'rejected',
                   'missing_column', tail="UPDATE t SET note='x'")

    def test_complex_delete_recursion_and_multi_cte_dependencies_remain_unknown(self):
        result = self.check('DELETE FROM a WHERE id=1 RETURNING id AS k,note AS v')
        self.assertIn('dml_cte:delete_finite_equality_predicate', result['checks'])
        self.check('DELETE FROM a USING t WHERE a.id=t.id RETURNING id AS k,note AS v', 'needs_review')
        for sql in ("WITH a0 AS (SELECT id,note FROM a), c AS (INSERT INTO t SELECT id,note FROM a0 RETURNING *) SELECT * FROM c",
                    "WITH c AS (INSERT INTO a VALUES (1,'x') RETURNING *), d AS (SELECT * FROM c) INSERT INTO t SELECT * FROM d",
                    "WITH RECURSIVE c AS (INSERT INTO a VALUES (1,'x') RETURNING *) INSERT INTO t SELECT * FROM c"):
            self.assertEqual(inspect_write(sql, self.setup)['status'], 'needs_review')

    def test_existing_candidates_include_finite_delete_scope(self):
        report = json.loads((Path(__file__).resolve().parents[1]/'generated/factor_packages/generation_report.json').read_text())
        ids = {'manifest_insert_cte_syntax_positive_7ca6df0d1a24',
               'manifest_update_cte_syntax_positive_35c1c493158b', 'manifest_update_cte_syntax_positive_78b558cee1d0'}
        cases = {c['case_id']: c for m in report['manifests'].values() for c in m['cases']}
        for cid in ids:
            c = cases[cid]
            result = inspect_write(c['sql'], c['setup_sqls'])
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('finite_dml_cte_write_and_returning_columns', result['checks'])
        c = cases['manifest_update_cte_syntax_positive_2839d16e4e93']
        result = inspect_write(c['sql'], c['setup_sqls'])
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('dml_cte:delete_finite_equality_predicate', result['checks'])


if __name__ == '__main__':
    unittest.main()
