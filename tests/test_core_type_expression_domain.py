"""Core type & expression extraction stays source-hash-bound and complete."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_type_expression_domain_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_type_expression_domain_v1/manifest.json'


class CoreTypeExpressionDomainTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_wave_1a_scope_is_complete(self):
        self.assertEqual(self.manifest['kind'], 'core_type_expression_domain_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 38)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 122)
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 99)
        self.assertEqual(self.manifest['summary']['open_question_count'], 3)
        self.assertTrue(self.manifest['summary']['all_sources_resolved'])
        self.assertTrue(self.manifest['summary']['all_chapters_have_facts'])

    def test_facts_are_unique_confirmed_and_traceable(self):
        ids = [item['id'] for item in self.facts]
        self.assertEqual(len(ids), len(set(ids)))
        source_refs = {item['source_ref'] for item in self.manifest['sources']}
        for fact in self.facts:
            with self.subTest(fact=fact['id']):
                self.assertIn(fact['status'], {'confirmed'})
                self.assertIn(fact['type'], {
                    'syntax', 'constraint', 'environment', 'behavior_oracle', 'example',
                })
                self.assertTrue(fact['source_anchor'])
                self.assertTrue(fact['source_refs'])
                for ref in fact['source_refs']:
                    self.assertIn(ref, source_refs)

    def test_every_selected_chapter_has_at_least_one_fact(self):
        refs = {item['source_ref'] for item in self.manifest['sources']}
        used = {ref for fact in self.facts for ref in fact['source_refs']}
        self.assertEqual(used, refs)

    def test_source_chapter_hashes_are_recorded(self):
        expected_prefixes = ('1.3.',)
        expected_exact = {'1.5', '1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.7.5', '1.7.6', '1.8', '1.9.1', '1.9.2', '1.9.3', '1.9.4', '1.9.5'}
        self.assertEqual(len(self.manifest['sources']), 38)
        for source in self.manifest['sources']:
            with self.subTest(source=source['source_ref']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertTrue(
                    source['section_number'].startswith(expected_prefixes)
                    or source['section_number'] in expected_exact
                )

    def test_manifest_is_current(self):
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_type_expression_domain.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == '__main__':
    unittest.main()
