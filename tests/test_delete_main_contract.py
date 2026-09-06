"""DELETE column proof is independent of INSERT omissions and execution."""
import json
from pathlib import Path
import unittest
from core.finite_delete_contract import inspect_delete
from core.finite_sql_contract import inspect_write


class DeleteMainContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INT NOT NULL,note VARCHAR(64),required INT NOT NULL)']

    def check(self, sql, status='checked', code=None, setup=None):
        result = inspect_delete(sql, self.setup if setup is None else setup)
        self.assertEqual(result['status'], status, result)
        self.assertEqual(result['scope'], 'finite_delete_shape_only')
        if code:
            self.assertIn(code, [i['code'] for i in result['issues']], result)
        return result

    def test_finite_single_target_modifiers_aliases_predicate_and_returning(self):
        for target in ('t', 'FROM t', 'ONLY t', 'FROM ONLY t *', 'FROM t d', 'FROM t AS d'):
            with self.subTest(target=target):
                self.check('DELETE '+target+' WHERE id=2 RETURNING id,note AS removed_note')
        self.check('DELETE FROM t AS d WHERE d.id=2 RETURNING d.id AS removed_id')
        result = self.check('DELETE FROM t')
        self.assertIn('delete_no_predicate', result['checks'])
        self.assertNotIn('insert_omitted_base_columns', result['checks'])

    def test_view_and_derived_targets_share_columns_without_insert_defaults(self):
        setup = self.setup+['CREATE VIEW v AS SELECT id,note FROM t']
        result = self.check('DELETE FROM v WHERE id=2', setup=setup)
        self.assertIn('single_base_direct_view_columns', result['checks'])
        result = self.check('DELETE FROM (SELECT id AS k,note FROM t) AS d WHERE d.k=2 RETURNING note')
        self.assertIn('single_base_direct_derived_target_columns', result['checks'])
        self.check('DELETE FROM (SELECT id AS k FROM t) WHERE id=2', 'rejected', 'missing_column')

    def test_missing_columns_and_qualifiers_are_not_passed(self):
        self.check('DELETE FROM t WHERE missing=2', 'rejected', 'missing_column')
        self.check('DELETE FROM t RETURNING missing', 'rejected', 'missing_column')
        self.check('DELETE FROM t d WHERE t.id=2', 'needs_review', 'qualifier_unknown')
        self.check("DELETE FROM t WHERE id='2'", 'needs_review', 'conversion_unknown')
        self.check('DELETE FROM missing', 'needs_review', 'fixture_unknown')

    def test_original_setup_freshness_and_unproved_view_shapes(self):
        for change in ('DROP TABLE t', 'ALTER TABLE t DROP COLUMN id', 'ROLLBACK',
                       'CREATE TABLE t (id INT,note TEXT)'):
            self.check('DELETE FROM t WHERE id=2', 'needs_review', setup=self.setup+[change])
        for view in ('CREATE VIEW v AS SELECT id FROM t WITH READ ONLY',
                     'CREATE VIEW v AS SELECT id FROM t WHERE id>0'):
            self.check('DELETE FROM v WHERE id=2', 'needs_review', setup=self.setup+[view])
        self.check('DELETE FROM v WHERE id=2', 'needs_review', setup=self.setup+[
            'CREATE VIEW v AS SELECT id FROM t', 'DROP TABLE t CASCADE', self.setup[0]])

    def test_complex_or_malformed_tails_are_not_removed_to_obtain_a_pass(self):
        for sql in ('DELETE FROM t USING a', 'DELETE FROM t ORDER BY id+1', 'DELETE FROM t LIMIT ALL',
                    'DELETE FROM t PARTITION (p)', 'DELETE FROM t,a',
                    'DELETE FROM t WHERE CURRENT OF cur', 'DELETE FROM t WHERE id=2 OR id=3',
                    'DELETE FROM t WHERE id=fn()', 'DELETE FROM t WHERE id=NULL',
                    'DELETE FROM t RETURNING id+1 AS n', 'DELETE FROM t RETURNING id AS n,note AS n',
                    'DELETE FROM t AS', 'DELETE FROM t WHERE', 'DELETE FROM t RETURNING',
                    'DELETE FROM t; DELETE FROM t', 'DELETE FROM t /* comment */',
                    'DELETE FROM (SELECT id FROM t) *', 'DELETE FROM ONLY (SELECT id FROM t)',
                    'UPDATE t SET id=1'):
            with self.subTest(sql=sql):
                self.check(sql, 'needs_review')
        self.check("DELETE FROM t WHERE note='WHERE RETURNING ORDER BY' RETURNING note")

    def test_direct_order_columns_and_positive_literal_limits_have_limited_scope(self):
        for order in ('id', 'id ASC', 'id DESC', 'd.id DESC'):
            result = self.check('DELETE FROM t d ORDER BY '+order+' LIMIT 1 RETURNING id')
            self.assertIn('delete_order_target_column', result['checks'])
            self.assertIn('delete_limit_literal_shape', result['checks'])
        self.check('DELETE FROM t LIMIT 2147483647')
        self.check('DELETE FROM t WHERE id=2 ORDER BY note')
        self.check("DELETE FROM t WHERE note='ORDER BY LIMIT RETURNING' ORDER BY id LIMIT 1 RETURNING note")
        self.check('DELETE FROM t ORDER BY missing', 'rejected', 'missing_column')
        self.check('DELETE FROM t d ORDER BY t.id', 'needs_review', 'qualifier_unknown')

    def test_order_limit_unknown_shapes_and_wrong_order_are_not_simplified(self):
        tails = ('ORDER BY', 'ORDER id', 'ORDER BY 1', 'ORDER BY id+1', 'ORDER BY id,note',
                 'ORDER BY id USING >', 'ORDER BY id NULLS FIRST', 'ORDER BY id ASC DESC',
                 'LIMIT', 'LIMIT 0', 'LIMIT -1', 'LIMIT +1', 'LIMIT 1.5', 'LIMIT 2147483648',
                 'LIMIT $1', 'LIMIT ALL', 'LIMIT (1)', 'LIMIT 1 OFFSET 1', 'OFFSET 1',
                 'LIMIT 1 ORDER BY id', 'ORDER BY id WHERE id=1', 'WHERE id=1 WHERE id=2',
                 'ORDER BY id ORDER BY note', 'LIMIT 1 LIMIT 2', 'RETURNING id LIMIT 1',
                 'ORDER BY id LIMIT 1 USING a', 'RETURNING id RETURNING note')
        for tail in tails:
            with self.subTest(tail=tail):
                self.check('DELETE FROM t '+tail, 'needs_review')

    def test_single_using_source_checks_real_columns_and_full_clauses(self):
        setup = self.setup+['CREATE TABLE lookup (lookup_id INT, marker TEXT)']
        for target in ('t', 't d', 'ONLY t *'):
            result = self.check('DELETE FROM '+target+' USING lookup AS l WHERE id=2 ORDER BY id LIMIT 1 RETURNING *', setup=setup)
            self.assertIn('delete_using_single_ordinary_source', result['checks'])
        self.check('DELETE FROM t USING lookup', setup=setup)
        self.check('DELETE FROM t USING lookup WHERE missing=2', 'rejected', 'missing_column', setup=setup)
        self.check('DELETE FROM t USING lookup WHERE l.lookup_id=2', 'needs_review', setup=setup)
        self.check('DELETE FROM t USING lookup WHERE id=2', 'needs_review', setup=setup+['DROP TABLE lookup'])

    def test_using_ambiguous_scopes_and_repeated_targets_remain_unknown(self):
        setup = self.setup+['CREATE TABLE lookup (id INT, note TEXT)']
        for tail in ('WHERE id=2', 'ORDER BY id', 'RETURNING note', 'RETURNING *'):
            self.check('DELETE FROM t d USING lookup l '+tail, 'needs_review', 'using_scope_unknown', setup=setup)
        self.check('DELETE FROM t d USING lookup l WHERE d.id=2 ORDER BY d.id RETURNING d.note', setup=setup)
        for source in ('t', 't src', 'lookup d', 'lookup AS', 'lookup AS SELECT',
                       'lookup l, t x', '(SELECT id FROM lookup) l', 'lookup l JOIN t x ON l.id=x.id'):
            self.check('DELETE FROM t d USING '+source, 'needs_review', setup=setup)
        schema_setup = ['CREATE TABLE a.t (id INT)', 'CREATE TABLE t (other INT)']
        self.check('DELETE FROM a.t d USING t s', 'needs_review', setup=schema_setup)
        self.check('DELETE FROM a.t d USING b.t s WHERE d.id=2', setup=[
            'CREATE TABLE a.t (id INT)', 'CREATE TABLE b.t (other INT)'])

    def test_using_nonordinary_sources_or_targets_and_misordered_tails_stay_unknown(self):
        setup = self.setup+['CREATE TABLE lookup (lookup_id INT)', 'CREATE VIEW v AS SELECT id FROM t']
        for sql in ('DELETE FROM t USING v', 'DELETE FROM v USING lookup',
                    'WITH c AS (SELECT lookup_id FROM lookup) DELETE FROM t USING c',
                    'DELETE FROM t WHERE id=1 USING lookup', 'DELETE FROM t USING lookup USING lookup',
                    'DELETE FROM t USING lookup ORDER BY id USING <',
                    'DELETE FROM t USING lookup RETURNING id LIMIT 1'):
            self.check(sql, 'needs_review', setup=setup)

    def test_cte_output_is_never_a_writable_fixture_and_inner_errors_propagate(self):
        self.check('WITH c AS (SELECT id FROM t) DELETE FROM c', 'needs_review', 'target_unknown')
        self.check('WITH c AS (DELETE FROM t WHERE missing=2 RETURNING id) DELETE FROM t',
                   'rejected', 'missing_column')
        result = self.check('WITH c AS (DELETE FROM t WHERE id=2 RETURNING id) DELETE FROM t WHERE id=3')
        self.assertIn('finite_dml_cte_write_and_returning_columns', result['checks'])

    def test_real_initial_candidates_and_original_write_scope_stays_unchanged(self):
        root = Path(__file__).resolve().parents[1]
        report = json.loads((root/'generated/factor_packages/generation_report.json').read_text())
        picked = 0
        for mid, manifest in report['manifests'].items():
            for case in manifest['cases']:
                if case['factor_id'] != 'delete':
                    continue
                if (mid in ('manifest_delete_cte_syntax_positive', 'manifest_delete_view_subquery_positive')
                    or case['case_id'] in {'manifest_delete_core_positive_'+s for s in (
                        'db4eb52a1f26', 'd5c3a0cf25b2', '009c466b2e47', '53052e408050',
                        'abb9229d4a72', '423c9e2b33e9', '4430341424e1', '0273797c0e4b',
                        '2f6a866589b3', '1f90b834e4c3', '732ad60a9804', 'cb2c7d5691ef',
                        'a1cbaf48c0b2', 'a785fafb77c1', '545e2193fbdf', 'a51a699c9e29',
                        '6e0e5889065e', '6e78eba46b91', 'fce79a9188b9', '5df6a881b3c8',
                        'd92ea7ac2220', 'aab31d797e55', '980118a930f6', 'b6ce2bf65903',
                        '2fd3c728bdf5')}):
                    with self.subTest(case=case['case_id']):
                        self.check(case['sql'], setup=case['setup_sqls'])
                    picked += 1
                else:
                    self.check(case['sql'], 'needs_review', setup=case['setup_sqls'])
        self.assertEqual(picked, 35)
        self.assertEqual(inspect_write('DELETE FROM t', self.setup)['status'], 'needs_review')


if __name__ == '__main__':
    unittest.main()
