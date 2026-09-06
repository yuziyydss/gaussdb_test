"""Small DELETE CTE predicate proof, not a general DELETE or runtime oracle."""
import json
from pathlib import Path
import unittest
from core.finite_sql_contract import inspect_write


class DeleteCTEContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INT,note TEXT)', 'CREATE TABLE a (id INT,note TEXT)']

    def check(self, inner, status='checked', code=None, tail=None, setup=None):
        result = inspect_write('WITH c AS ('+inner+') '+(tail or "UPDATE t SET note='ok'"),
                               self.setup if setup is None else setup)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [i['code'] for i in result['issues']], result)
        return result

    def test_simple_equality_and_explicit_no_predicate_scope(self):
        result = self.check('DELETE FROM a WHERE id=9 RETURNING id')
        self.assertIn('dml_cte:delete_finite_equality_predicate', result['checks'])
        result = self.check('DELETE FROM a RETURNING *')
        self.assertIn('dml_cte:delete_no_predicate', result['checks'])
        self.check("DELETE FROM a WHERE note='x' RETURNING id AS k,note AS v",
                   tail='INSERT INTO t SELECT k,v FROM c')

    def test_real_candidate(self):
        report = json.loads((Path(__file__).resolve().parents[1]/'generated/factor_packages/generation_report.json').read_text())
        case = next(c for m in report['manifests'].values() for c in m['cases']
                    if c['case_id'] == 'manifest_update_cte_syntax_positive_2839d16e4e93')
        result = inspect_write(case['sql'], case['setup_sqls'])
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('dml_cte:delete_finite_equality_predicate', result['checks'])

    def test_predicate_and_returning_columns_both_checked(self):
        self.check('DELETE FROM a WHERE missing=9 RETURNING id', 'rejected', 'missing_column')
        self.check('DELETE FROM a WHERE id=9 RETURNING missing', 'rejected', 'missing_column')
        self.check("DELETE FROM a WHERE id='9' RETURNING id", 'needs_review', 'conversion_unknown')
        self.check('DELETE FROM a WHERE id=9', 'needs_review')

    def test_complex_target_predicate_and_tail_remain_unknown(self):
        for inner in ('DELETE FROM missing WHERE id=9 RETURNING id',
                      'DELETE FROM a AS x WHERE x.id=9 RETURNING id',
                      'DELETE FROM a USING t WHERE a.id=t.id RETURNING id',
                      'DELETE FROM a,t WHERE id=9 RETURNING id',
                      'DELETE FROM a PARTITION(p) WHERE id=9 RETURNING id',
                      'DELETE FROM a WHERE CURRENT OF cur RETURNING id',
                      'DELETE FROM a WHERE id=9 OR id=10 RETURNING id',
                      'DELETE FROM a WHERE id=fn() RETURNING id',
                      'DELETE FROM a WHERE id=NULL RETURNING id',
                      'DELETE FROM a WHERE id=9 LIMIT 1 RETURNING id',
                      'DELETE FROM a WHERE id=9 RETURNING id+1 AS id'):
            with self.subTest(inner=inner):
                self.check(inner, 'needs_review')

    def test_original_ddl_freshness_and_read_only_output_preserved(self):
        for change in ('DROP TABLE a', 'ALTER TABLE a DROP COLUMN id', 'ROLLBACK',
                       'CREATE TABLE a (id INT,note TEXT)'):
            self.check('DELETE FROM a WHERE id=9 RETURNING id', 'needs_review', setup=self.setup+[change])
        self.check('DELETE FROM a WHERE id=9 RETURNING id', 'needs_review', 'target_unknown',
                   tail='UPDATE c SET id=1')

    def test_top_level_delete_still_outside_existing_write_audit_scope(self):
        result = inspect_write('DELETE FROM a WHERE id=9 RETURNING id', self.setup)
        self.assertEqual(result['status'], 'needs_review')
        self.assertEqual(result['issues'][0]['code'], 'statement_not_supported')


if __name__ == '__main__':
    unittest.main()
