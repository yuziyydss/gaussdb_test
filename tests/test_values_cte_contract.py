"""VALUES CTEs expose finite typed columns, never writable fixture state."""
import json
import unittest
from pathlib import Path

from core.finite_sql_contract import inspect_write


class ValuesCTEContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INT, note TEXT);']

    def check(self, cte, status, code=None):
        result = inspect_write(cte + ' INSERT INTO t (id,note) SELECT k,v FROM c;', self.setup)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [x['code'] for x in result['issues']], result)

    def test_explicit_columns_and_homogeneous_literal_rows(self):
        self.check("WITH c(k,v) AS (VALUES(1,'x'),(2,'y'))", 'checked')
        self.check("WITH c(k,v) AS MATERIALIZED (VALUES(-1,'a,b'),(+2,'it''s'))", 'checked')
        self.check("WITH c(k,v) AS NOT MATERIALIZED (VALUES(1,'x'))", 'checked')

    def test_width_mismatch_is_a_finite_contradiction(self):
        self.check("WITH c(k,v) AS (VALUES(1,'x'),(2))", 'rejected', 'arity')

    def test_default_is_forbidden_in_values_cte_not_treated_as_target_default(self):
        self.check("WITH c(k,v) AS (VALUES(DEFAULT,'x'))", 'rejected', 'default_in_values_cte')

    def test_unknown_types_expressions_names_and_tails_stay_unknown(self):
        for cte in [
            "WITH c(k,v) AS (VALUES(1,'x'),('2','y'))",
            "WITH c(k,v) AS (VALUES(1,'x'),(2.0,'y'))",
            "WITH c(k,v) AS (VALUES(NULL,'x'))",
            "WITH c(k,v) AS (VALUES(id,'x'))",
            "WITH c(k,v) AS (VALUES(1+1,'x'))",
            "WITH c(k,v) AS (VALUES(1,'x') ORDER BY 1)",
            "WITH c(k,v) AS (VALUES(1,'x') LIMIT 1)",
            "WITH c(k) AS (VALUES(1,'x'))",
            "WITH c(k,k) AS (VALUES(1,'x'))",
            "WITH c AS (VALUES(1,'x'))",
            "WITH RECURSIVE c(k,v) AS (VALUES(1,'x'))",
            "WITH c(k,v) AS (DELETE FROM t WHERE id=1 OR id=2 RETURNING id,note)",
        ]:
            with self.subTest(cte=cte):
                self.check(cte, 'needs_review')

    def test_values_output_can_feed_following_select_cte(self):
        self.check("WITH a(k,v) AS (VALUES(1,'x')), c AS (SELECT k,v FROM a)", 'checked')

    def test_finite_insert_returning_retains_explicit_output_names(self):
        self.check("WITH c(k,v) AS (INSERT INTO t VALUES(1,'x') RETURNING id,note)", 'checked')

    def test_finite_delete_returning_retains_explicit_output_names(self):
        sql = 'WITH c(k,v) AS (DELETE FROM t RETURNING id,note) INSERT INTO t SELECT k,v FROM c'
        result = inspect_write(sql, self.setup)
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('dml_cte:delete_no_predicate', result['checks'])

    def test_values_cte_is_not_writable_table(self):
        result = inspect_write("WITH c(k,v) AS (VALUES(1,'x')) UPDATE c SET k=2;", self.setup)
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['issues'][0]['code'], 'target_unknown')

    def test_real_values_and_finite_dml_candidates_keep_scope_boundaries(self):
        path = Path(__file__).resolve().parents[1] / 'generated/factor_packages/generation_report.json'
        report = json.loads(path.read_text())
        values_cases, recursive_values_cases, dml_cases = [], [], []
        for mid in ('manifest_insert_cte_syntax_positive', 'manifest_update_cte_syntax_positive'):
            for case in report['manifests'][mid]['cases']:
                if ' AS (VALUES ' in case['sql']:
                    if case['sql'].startswith('WITH RECURSIVE '):
                        recursive_values_cases.append(case)
                    else:
                        values_cases.append(case)
                elif any(f' AS ({kind} ' in case['sql'] for kind in ('INSERT', 'UPDATE', 'DELETE')):
                    dml_cases.append(case)
        self.assertEqual(len(values_cases), 2)
        self.assertEqual(len(recursive_values_cases), 1)
        self.assertEqual(len(dml_cases), 4)
        for case in values_cases:
            self.assertEqual(inspect_write(case['sql'], case['setup_sqls'])['status'], 'checked')
        for case in dml_cases:
            result = inspect_write(case['sql'], case['setup_sqls'])
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('finite_dml_cte_write_and_returning_columns', result['checks'])
            if ' AS (DELETE ' in case['sql']:
                self.assertIn('dml_cte:delete_finite_equality_predicate', result['checks'])
        for case in recursive_values_cases:
            result = inspect_write(case['sql'], case['setup_sqls'])
            self.assertEqual(result['status'], 'checked')
            self.assertIn('bounded_recursive_cte_columns', result['checks'])


if __name__ == '__main__':
    unittest.main()
