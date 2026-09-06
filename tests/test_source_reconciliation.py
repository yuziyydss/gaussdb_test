import copy
import hashlib
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import yaml
from scripts import reconcile_quality_round as audit


class SourceReconciliationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.corpus = self.root / 'corpus'
        self.corpus.mkdir()
        body = b'authoritative chapter body'
        (self.corpus / 'a.txt').write_bytes(body)
        self.digest = hashlib.sha256(body).hexdigest()
        self.catalog = {'path': str(self.corpus / 'catalog.json'), 'document_id': 'doc',
                        'product_version': 'v', 'parent_pdf_sha256': 'parent',
                        'chapters': {'a.txt': {'chapter_sha256': self.digest}}}
        self.ref = {'document_id': 'doc', 'source_relpath': 'a.txt',
                    'chapter_sha256': self.digest}
        self.items = [self.package('a'), self.package('b')]
        self.addCleanup(patch.stopall)
        patch.object(audit, 'ROOT', self.root).start()
        # The real catalog loader verifies the parent PDF separately. This fixture
        # isolates population/identity checks without weakening that loader.
        patch.object(audit, 'load_source_catalog', return_value=self.catalog).start()

    def package(self, name):
        directory = self.root / 'specs' / name
        directory.mkdir(parents=True)
        factor = {'id': name, 'source': {'artifact_sha256': self.digest,
                  'catalog_chapter_ref': self.ref, 'version': 'v',
                  'parent_pdf_sha256': 'parent'}}
        ledger = {'factor_ref': name, 'artifact_sha256': self.digest}
        (directory / 'factor.yaml').write_text(yaml.safe_dump(factor))
        (directory / 'main.source.yaml').write_text(yaml.safe_dump(ledger))
        return {'factor_id': name, 'file': str((directory / 'factor.yaml').relative_to(self.root))}

    def run_audit(self, items=None):
        return audit.audit_sources(self.items if items is None else items, [self.corpus / 'catalog.json'])

    def test_valid_distinct_packages_are_bound(self):
        result = self.run_audit()
        self.assertEqual((result['factor_count'], result['bound']), (2, 2))

    def test_duplicate_id_and_normalized_file_cannot_inflate_population(self):
        for duplicate in (copy.deepcopy(self.items[0]),
                          dict(self.items[0], factor_id='other'),
                          dict(self.items[0], factor_id='other', file='specs/a/../a/factor.yaml'),
                          dict(self.items[1], factor_id='a')):
            with self.subTest(duplicate=duplicate), self.assertRaises(ValueError):
                self.run_audit([self.items[0], duplicate])

    def test_backlog_identity_must_match_factor(self):
        items = copy.deepcopy(self.items)
        items[0]['factor_id'] = 'wrong'
        result = self.run_audit(items)
        self.assertEqual(result['bound'], 1)
        self.assertEqual(result['rows'][0]['factor_id'], 'wrong')
        self.assertTrue(result['rows'][0]['errors'])

    def test_ledger_identity_must_match_factor(self):
        ledger = self.root / 'specs/a/main.source.yaml'
        ledger.write_text(yaml.safe_dump({'factor_ref': 'wrong', 'artifact_sha256': self.digest}))
        result = self.run_audit()
        self.assertEqual(result['bound'], 1)
        self.assertTrue(result['rows'][0]['errors'])

    def test_missing_malformed_and_non_mapping_files_are_row_errors(self):
        for filename in ('factor.yaml', 'main.source.yaml'):
            path = self.root / 'specs/a' / filename
            original = path.read_bytes()
            for content in (None, '[unterminated', '- not a mapping', ''):
                with self.subTest(filename=filename, content=content):
                    if content is None:
                        path.unlink()
                    else:
                        path.write_text(content)
                    result = self.run_audit()
                    self.assertEqual((result['factor_count'], result['bound']), (2, 1))
                    self.assertTrue(result['rows'][0]['errors'])
                    path.write_bytes(original)

    def test_factor_and_ledger_paths_cannot_escape_project(self):
        for name in ('../outside.factor.yaml', str(self.root.parent / 'outside.factor.yaml')):
            with self.subTest(name=name):
                result = self.run_audit([dict(self.items[0], file=name), self.items[1]])
                self.assertEqual(result['bound'], 1)
                self.assertIn('escapes', ' '.join(result['rows'][0]['errors']))
        ledger = self.root / 'specs/a/main.source.yaml'
        ledger.unlink()
        ledger.symlink_to(self.root.parent / 'outside.source.yaml')
        result = self.run_audit()
        self.assertEqual(result['bound'], 1)
        self.assertIn('escapes', ' '.join(result['rows'][0]['errors']))

    def test_body_drift_still_invalidates_all_references(self):
        (self.corpus / 'a.txt').write_text('changed')
        self.assertEqual(self.run_audit()['bound'], 0)


if __name__ == '__main__':
    unittest.main()
