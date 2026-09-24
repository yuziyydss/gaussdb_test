"""Documented self-FROM alias violations are not generic query unknowns."""
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write


class UpdateSelfFromContradictionTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT)', 'CREATE TABLE a(id INT)', 'CREATE TABLE other(id INT)']

    def test_unaliased_self_from_is_a_finite_contradiction(self):
        for target in ('t', 't AS u', 't AS u,a AS v'):
            lhs = 'u.id' if ',' in target else 'id'
            for sep in (' ', '\n', '\t'):
                with self.subTest(target=target, sep=repr(sep)):
                    result = inspect_write(f'UPDATE {target} SET {lhs}=1 FROM{sep}t;', self.setup)
                    self.assertEqual(result['status'], 'rejected', result)
                    self.assertEqual(result['issues'][0]['code'], 'self_from_requires_alias')

    def test_valid_self_alias_stays_checked_but_other_ambiguities_stay_review(self):
        for sql in ['UPDATE t SET id=1 FROM t AS src;',
                    'UPDATE t AS u SET id=1 FROM t src;']:
            self.assertEqual(inspect_write(sql, self.setup)['status'], 'checked')
        for sql in ['UPDATE t AS u SET id=1 FROM other AS u;',
                    'UPDATE t SET id=1 FROM missing;',
                    'UPDATE t SET id=1 FROM (SELECT id FROM t) AS src;']:
            self.assertEqual(inspect_write(sql, self.setup)['status'], 'needs_review')




if __name__ == '__main__':
    unittest.main()
