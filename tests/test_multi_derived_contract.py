"""Finite multi-target binding does not establish write order or cardinality."""
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write


class MultiDerivedContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INT NOT NULL, note TEXT)',
             'CREATE TABLE aux (id INT, note TEXT)',
             'CREATE TABLE src (sid INT, label TEXT)']

    def check(self, sql, status='checked', code=None, setup=None, scope='general'):
        result = inspect_write(sql, self.setup if setup is None else setup,
                               conflict_source_scope=scope)
        self.assertEqual(result['status'], status, result)
        if code:
            self.assertIn(code, [i['code'] for i in result['issues']], result)
        return result

    def test_base_and_direct_derived_with_inheritance_spelling(self):
        for suffix in ('', ' FROM src AS s'):
            result = self.check("UPDATE ONLY t * AS u, (SELECT id,note FROM aux) AS a SET u.note='ok'"+suffix)
            self.assertIn('finite_multi_target_relations', result['checks'])

    def test_derived_assignment_uses_projected_columns_not_hidden_base_columns(self):
        self.check("UPDATE t AS u, (SELECT note AS label FROM aux) AS a SET a.label='ok'")
        self.check("UPDATE t AS u, (SELECT note AS label FROM aux) AS a SET a.id=1", 'rejected', 'missing_column')
        self.check("UPDATE t AS u, (SELECT note AS label FROM aux) AS a SET a.label=1", 'needs_review', 'conversion_unknown')

    def test_unknown_or_ambiguous_relations_and_aliases_remain_review(self):
        for target in ('(SELECT id FROM missing) AS a', '(SELECT missing FROM aux) AS a',
                       '(SELECT id FROM aux) AS u', '(SELECT id FROM aux)',
                       '(SELECT id FROM aux) AS', '(SELECT id FROM aux) WHERE',
                       '(SELECT id FROM aux WHERE id>0) AS a',
                       '(SELECT id+1 AS id FROM aux) AS a',
                       '(SELECT id FROM aux WITH READ ONLY) AS a',
                       '(SELECT id FROM aux) AS a junk'):
            with self.subTest(target=target):
                self.check("UPDATE t AS u, "+target+" SET u.note='ok'", 'needs_review')

    def test_same_base_in_multiple_targets_is_not_independent_evidence(self):
        for target in ('t AS a', '(SELECT id,note FROM t) AS a'):
            self.check("UPDATE t AS u, "+target+" SET u.note='ok'", 'needs_review')

    def test_named_view_ban_is_source_scoped_without_hiding_same_base(self):
        setup = self.setup + ['CREATE VIEW v AS SELECT id,note FROM t']
        sql = "UPDATE t AS u, v AS a SET u.note='ok'"
        # General UPDATE L16 forbids a known named-view target independently
        # of aliasing. M's own L16 supplies the same restriction independently.
        for scope in ('general','m_compat'):
            with self.subTest(scope=scope):
                self.check(sql, 'rejected', 'multi_update_view_not_supported', setup=setup, scope=scope)
        self.check(sql, 'needs_review', 'target_unknown', setup=setup, scope='unreviewed')

    def test_schema_ambiguity_does_not_hide_same_base(self):
        setup = self.setup + ['CREATE TABLE public.t (id INT, note TEXT)']
        self.check("UPDATE t AS u, public.t AS a SET u.note='ok'", 'needs_review', setup=setup)
        setup = ['CREATE TABLE s1.t (id INT, note TEXT)', 'CREATE TABLE s2.t (id INT, note TEXT)']
        self.check("UPDATE s1.t AS u, s2.t AS a SET u.note='ok'", setup=setup)

    def test_from_source_still_requires_its_own_binding(self):
        prefix = "UPDATE t AS u, (SELECT id,note FROM aux) AS a SET u.note='ok' FROM "
        self.check(prefix+'missing AS s', 'needs_review')
        self.check(prefix+'src AS u', 'needs_review')

    def test_cross_target_rhs_and_defaults_remain_outside_literal_scope(self):
        prefix = 'UPDATE t AS u, (SELECT id,note FROM aux) AS a SET '
        for rhs in ('u.note=a.note', 'a.id=u.id+1', 'a.note=DEFAULT'):
            self.check(prefix+rhs, 'needs_review')

    def test_two_real_cases_gain_binding_not_database_oracle(self):
        path = Path(__file__).resolve().parents[1] / 'generated/factor_packages/generation_report.json'
        report = json.loads(path.read_text())
        ids = {'manifest_update_multi_syntax_positive_07f6ce88a2fe',
               'manifest_update_multi_syntax_positive_d9578a392d1f'}
        cases = [c for m in report['manifests'].values() for c in m['cases'] if c['case_id'] in ids]
        self.assertEqual(len(cases), 2)
        for case in cases:
            result = self.check(case['sql'], setup=case['setup_sqls'])
            self.assertEqual(result['scope'], 'finite_write_shape_only')


if __name__ == '__main__':
    unittest.main()
