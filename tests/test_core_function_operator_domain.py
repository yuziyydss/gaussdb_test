"""Core function & operator extraction remains source-hash-bound and complete."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_function_operator_domain_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_function_operator_domain_v1/manifest.json'


class CoreFunctionOperatorDomainTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_wave_1b_scope_is_complete(self):
        self.assertEqual(self.manifest['kind'], 'core_function_operator_domain_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 16)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 312)
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 102)
        self.assertEqual(self.manifest['summary']['open_question_count'], 4)
        self.assertTrue(self.manifest['summary']['all_sources_resolved'])
        self.assertTrue(self.manifest['summary']['all_chapters_have_facts'])

    def test_facts_are_unique_confirmed_and_traceable(self):
        ids = [item['id'] for item in self.facts]
        self.assertEqual(len(ids), len(set(ids)))
        source_refs = {item['source_ref'] for item in self.manifest['sources']}
        for fact in self.facts:
            with self.subTest(fact=fact['id']):
                self.assertEqual(fact['status'], 'confirmed')
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

    def test_expected_sections_are_selected(self):
        expected = {
            '1.6.1', '1.6.2', '1.6.3', '1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.6.8',
            '1.6.9', '1.6.13', '1.6.14', '1.6.16', '1.6.17', '1.6.18', '1.6.19', '1.6.25',
        }
        self.assertEqual(
            {item['section_number'] for item in self.manifest['sources']},
            expected,
        )
        for source in self.manifest['sources']:
            with self.subTest(source=source['source_ref']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])

    def test_manifest_is_current(self):
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_function_operator_domain.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == '__main__':
    unittest.main()
