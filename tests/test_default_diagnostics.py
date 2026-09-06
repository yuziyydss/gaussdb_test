"""A view-default semantics gap must not look like missing fixture metadata."""
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write, ReviewNeeded
from core.shared_column_contract import default_literal


class DefaultDiagnosticTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT DEFAULT 1,note TEXT DEFAULT \'ok\')',
             'CREATE VIEW v AS SELECT id,note FROM t']

    def assert_semantics_gap(self, result):
        self.assertEqual(result['status'], 'needs_review', result)
        self.assertEqual(result['scope'], 'finite_write_shape_only')
        self.assertEqual(result['issues'][0]['code'], 'default_unknown')
        self.assertIn('View/derived DEFAULT application semantics', result['issues'][0]['detail'])
        self.assertIn('lineage does not prove inheritance', result['issues'][0]['detail'])

    def test_view_and_derived_insert_update_keep_unknown_semantics(self):
        for sql in ('INSERT INTO v VALUES (DEFAULT,DEFAULT)', 'UPDATE v SET note=DEFAULT',
                    'INSERT INTO (SELECT id,note FROM t) VALUES (DEFAULT,DEFAULT)',
                    'UPDATE (SELECT id,note FROM t) SET note=DEFAULT'):
            with self.subTest(sql=sql):
                self.assert_semantics_gap(inspect_write(sql, self.setup))

    def test_ordinary_absent_metadata_is_still_a_metadata_gap(self):
        with self.assertRaises(ReviewNeeded) as caught:
            default_literal({'columns': {'id': 'integer'}}, 'id')
        self.assertEqual(caught.exception.code, 'default_unknown')
        self.assertEqual(caught.exception.detail, 'No complete base-column default evidence: id')

    def test_ordinary_supported_and_dynamic_defaults_are_not_reclassified(self):
        self.assertEqual(inspect_write('UPDATE t SET note=DEFAULT', self.setup)['status'], 'checked')
        result = inspect_write('UPDATE t SET id=DEFAULT', ['CREATE TABLE t(id INT DEFAULT f())'])
        self.assertEqual(result['status'], 'needs_review')
        self.assertEqual(result['issues'], [{'code': 'default_unknown', 'detail': 'id: dynamic default'}])

    def test_exact_real_default_unknown_population_remains_ten(self):
        root = Path(__file__).resolve().parents[1]
        report = json.loads((root/'generated/factor_packages/generation_report.json').read_text())
        found = []
        for mid, manifest in report['manifests'].items():
            if mid not in ('manifest_insert_target_forms_positive', 'manifest_update_view_subquery_positive'):
                continue
            for case in manifest['cases']:
                result = inspect_write(case['sql'], case['setup_sqls'])
                if any(i['code'] == 'default_unknown' for i in result['issues']):
                    self.assert_semantics_gap(result)
                    found.append(case['case_id'])
        self.assertEqual(len(found), 10)


if __name__ == '__main__':
    unittest.main()
