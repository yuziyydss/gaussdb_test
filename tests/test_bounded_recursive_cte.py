"""A small closed recurrence is not a general recursive SQL execution proof."""
import json
from pathlib import Path
import unittest
from core.finite_sql_contract import inspect_write


class BoundedRecursiveCTETests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INT, note TEXT)']

    def check(self, body, status='checked', code=None, tail=None, columns='k,v'):
        sql = 'WITH RECURSIVE c('+columns+') AS ('+body+') '+(tail or 'INSERT INTO t SELECT k,v FROM c')
        result = inspect_write(sql, self.setup)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [i['code'] for i in result['issues']], result)
        return result

    def test_single_integer_progression_and_identity_columns(self):
        for body in ("VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3",
                     "VALUES (-2,'x') UNION ALL SELECT k+2,v FROM c WHERE k<=3",
                     "VALUES (9,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3"):
            result = self.check(body)
            self.assertIn('bounded_recursive_cte_columns', result['checks'])
            self.assertEqual(result['scope'], 'finite_write_shape_only')

    def test_recursive_width_and_missing_columns_are_not_hidden_by_target(self):
        self.check("VALUES (1,'x') UNION ALL SELECT k+1 FROM c WHERE k<3", 'rejected', 'arity')
        self.check("VALUES (1,'x') UNION ALL SELECT k+1,missing FROM c WHERE k<3", 'rejected', 'missing_column')
        self.check("VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE missing<3", 'rejected', 'missing_column')

    def test_type_or_projection_changes_need_separate_contract(self):
        for seed, projection in (("'1','x'", 'k+1,v'), ('1,2', 'k+1,k'),
                                 ("1,'x'", "k+1,'y'"), ("1,'x'", 'k+1,v+1')):
            self.check('VALUES ('+seed+') UNION ALL SELECT '+projection+' FROM c WHERE k<3', 'needs_review')

    def test_termination_and_int32_overflow_are_not_guessed(self):
        for body in ("VALUES (1,'x') UNION ALL SELECT k,v FROM c WHERE k<3",
                     "VALUES (1,'x') UNION ALL SELECT k+0,v FROM c WHERE k<3",
                     "VALUES (1,'x') UNION ALL SELECT k-1,v FROM c WHERE k<3",
                     "VALUES (1,'x') UNION ALL SELECT k+1,v FROM c",
                     "VALUES (2147483646,'x') UNION ALL SELECT k+2,v FROM c WHERE k<2147483647",
                     "VALUES (2147483647,'x') UNION ALL SELECT k+1,v FROM c WHERE k<=2147483647",
                     "VALUES (2147483648,'x') UNION ALL SELECT k+1,v FROM c WHERE k<2147483649"):
            self.check(body, 'needs_review')

    def test_unknown_recursion_forms_remain_review(self):
        for body in ("VALUES (1,'x'),(2,'y') UNION ALL SELECT k+1,v FROM c WHERE k<3",
                     "VALUES (1,'x') UNION SELECT k+1,v FROM c WHERE k<3",
                     "VALUES (1,'x') UNION ALL SELECT k+1,v FROM t WHERE k<3",
                     "VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3 ORDER BY k",
                     "VALUES (1,'x') UNION ALL SELECT a.k+1,a.v FROM c a JOIN c b ON a.k=b.k WHERE a.k<3",
                     "VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<limit_fn()"):
            self.check(body, 'needs_review')
        self.check("VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3", 'needs_review', columns='k,k')

    def test_seed_defaults_nulls_and_extra_ctes_are_not_assumed(self):
        self.check("VALUES (DEFAULT,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3",
                   'rejected', 'default_in_values_cte')
        self.check("VALUES (NULL,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3", 'needs_review')
        sql = ("WITH RECURSIVE c(k,v) AS (VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3), "
               "d AS (SELECT k,v FROM c) INSERT INTO t SELECT k,v FROM d")
        self.assertEqual(inspect_write(sql, self.setup)['status'], 'needs_review')

    def test_large_bounded_input_uses_closed_form_not_generated_rows(self):
        self.check("VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<2000000000")

    def test_recursive_output_is_not_writable_fixture(self):
        self.check("VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3", 'needs_review',
                   'target_unknown', tail='UPDATE c SET k=2')

    def test_unused_cte_still_checked_and_outer_write_type_still_checked(self):
        self.check("VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3", tail="UPDATE t SET note='ok'")
        self.check("VALUES (1,'x') UNION ALL SELECT k+1,v FROM c WHERE k<3", 'needs_review',
                   'conversion_unknown', tail='INSERT INTO t SELECT v,k FROM c')

    def test_three_real_candidates(self):
        report = json.loads((Path(__file__).resolve().parents[1]/'generated/factor_packages/generation_report.json').read_text())
        ids = {'manifest_insert_cte_positive_4bf4805cf25e', 'manifest_insert_cte_positive_05be08bfc362',
               'manifest_update_cte_syntax_positive_2b825e1e9d8f'}
        cases = [c for m in report['manifests'].values() for c in m['cases'] if c['case_id'] in ids]
        self.assertEqual(len(cases), 3)
        for c in cases:
            result = inspect_write(c['sql'], c['setup_sqls'])
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('bounded_recursive_cte_columns', result['checks'])


if __name__ == '__main__':
    unittest.main()
