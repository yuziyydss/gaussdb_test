"""Wave 2A extraction remains source-hash-bound and complete."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_function_operator_wave2a_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_function_operator_wave2a_v1/manifest.json'


class CoreFunctionOperatorWave2ATests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_wave_2a_scope_is_complete(self):
        self.assertEqual(self.manifest['kind'], 'core_function_operator_wave2a_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 13)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 112)
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 45)
        self.assertEqual(self.manifest['summary']['open_question_count'], 3)
        self.assertTrue(self.manifest['summary']['all_sources_resolved'])
        self.assertTrue(self.manifest['summary']['all_chapters_have_facts'])

    def test_expected_sections_are_selected(self):
        expected = {
            '1.6.10', '1.6.11', '1.6.12', '1.6.15', '1.6.20', '1.6.23',
            '1.6.24', '1.6.26', '1.6.31', '1.6.43', '1.6.44', '1.6.50', '1.6.58',
        }
        self.assertEqual({item['section_number'] for item in self.manifest['sources']}, expected)

    def test_facts_are_unique_confirmed_and_traceable(self):
        ids = [item['id'] for item in self.facts]
        self.assertEqual(len(ids), len(set(ids)))
        source_refs = {item['source_ref'] for item in self.manifest['sources']}
        for fact in self.facts:
            with self.subTest(fact=fact['id']):
                self.assertEqual(fact['status'], 'confirmed')
                self.assertIn(fact['type'], {'syntax', 'constraint', 'environment', 'behavior_oracle'})
                self.assertTrue(fact['source_anchor'])
                self.assertTrue(fact['source_refs'])
                for ref in fact['source_refs']:
                    self.assertIn(ref, source_refs)

    def test_every_selected_chapter_has_at_least_one_fact(self):
        refs = {item['source_ref'] for item in self.manifest['sources']}
        used = {ref for fact in self.facts for ref in fact['source_refs']}
        self.assertEqual(used, refs)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_function_operator_wave2a.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
