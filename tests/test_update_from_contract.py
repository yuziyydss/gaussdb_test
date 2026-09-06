"""Only unambiguous target-side expressions gain UPDATE FROM shape evidence."""
import json
import unittest
from pathlib import Path

from core.finite_sql_contract import inspect_write


class UpdateFromContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t (id INT, qty INT, note TEXT);',
             'CREATE TABLE src (src_id INT, amount INT);',
             'CREATE TABLE a (id INT, note TEXT);']

    def check(self, sql, status, setup=None):
        result = inspect_write(sql, self.setup if setup is None else setup)
        self.assertEqual(result['status'], status, result)

    def test_unqualified_target_rhs_when_source_has_no_same_column(self):
        self.check("UPDATE t SET qty=qty+1 FROM src AS s WHERE id=s.src_id;", 'checked')
        self.check("UPDATE t SET qty=qty, note='x' FROM src;", 'checked')

    def test_target_qualification_resolves_overlap_but_not_source_rhs(self):
        setup = [self.setup[0], 'CREATE TABLE src (qty INT);']
        self.check('UPDATE t AS u SET qty=u.qty+1 FROM src AS s;', 'checked', setup)
        self.check('UPDATE t AS u SET qty=qty+1 FROM src AS s;', 'needs_review', setup)
        self.check('UPDATE t AS u SET qty=s.qty+1 FROM src AS s;', 'needs_review', setup)

    def test_source_only_expression_and_complex_sources_stay_review(self):
        for sql in [
            'UPDATE t SET qty=amount FROM src;',
            'UPDATE t SET qty=s.amount FROM src AS s;',
            'UPDATE t SET qty=qty+amount FROM src;',
            'UPDATE t SET qty=1 FROM missing;',
            'UPDATE t SET qty=qty+1 FROM src JOIN a ON src.src_id=a.id;',
            'UPDATE t SET qty=qty+1 FROM (SELECT src_id FROM src) AS s;',
            'UPDATE t SET qty=1 FROM src AS;',
            'UPDATE t SET qty=1 FROM src, a;',
        ]:
            with self.subTest(sql=sql):
                self.check(sql, 'needs_review')

    def test_single_target_alias_collision_and_self_from_need_review(self):
        self.check('UPDATE t AS u SET qty=1 FROM src AS u;', 'needs_review')
        for sql in ['UPDATE t SET qty=1 FROM t;',
                    'UPDATE t AS u SET qty=1 FROM t;']:
            with self.subTest(sql=sql):
                self.check(sql, 'rejected')
        self.check('UPDATE t AS u SET qty=1 FROM t AS s;', 'checked')

    def test_multi_target_literal_with_known_distinct_source(self):
        self.check("UPDATE t AS u,a AS v SET u.note='x' FROM src AS s;", 'checked')
        self.check("UPDATE t AS u,a AS v SET u.note='x',v.note='y' FROM src;", 'checked')

    def test_multi_target_from_stays_conservative(self):
        for suffix in ['src AS u', 'src AS v', 'missing', 'src JOIN a ON true',
                       '(SELECT src_id FROM src) AS s', 'src, a']:
            with self.subTest(suffix=suffix):
                self.check("UPDATE t AS u,a AS v SET u.note='x' FROM " + suffix + ';', 'needs_review')
        self.check('UPDATE t AS u,a AS v SET u.qty=u.qty+1 FROM src;', 'needs_review')
        self.check("UPDATE t AS u,a AS v SET u.note='x' FROM t;", 'rejected')

    def test_real_three_candidates_and_negative_self_join(self):
        report = json.loads((Path(__file__).resolve().parents[1] /
                             'generated/factor_packages/generation_report.json').read_text())
        cases = {c['case_id']: c for m in report['manifests'].values() for c in m['cases']}
        for case_id in ['manifest_update_from_source_positive_bc377512cd50',
                        'manifest_update_from_source_positive_41409ec06087',
                        'manifest_update_multi_syntax_positive_39a73c3bf1ed']:
            case = cases[case_id]
            self.assertEqual(inspect_write(case['sql'], case['setup_sqls'])['status'], 'checked')
        for case in report['manifests']['manifest_update_from_self_unaliased_negative']['cases']:
            self.assertEqual(inspect_write(case['sql'], case['setup_sqls'])['status'], 'rejected')


if __name__ == '__main__':
    unittest.main()
