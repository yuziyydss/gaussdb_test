"""AI, sensitive data, masking and hierarchy Wave 6-5 extraction is traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_ai_security_wave6_5_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_ai_security_wave6_5_v1/manifest.json'


class CoreAISecurityWave65Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_four_ai_and_security_sections(self):
        self.assertEqual(self.manifest['kind'], 'core_ai_security_wave6_5_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 4)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 909)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 919)
        self.assertEqual(
            self.manifest['scope']['sections'],
            ['1.6.35', '1.6.36', '1.6.37', '1.6.38'],
        )
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 20)
        self.assertEqual(self.manifest['summary']['open_question_count'], 2)
        self.assertTrue(self.manifest['summary']['all_sources_resolved'])
        self.assertTrue(self.manifest['summary']['all_facts_bound_to_scope'])

    def test_facts_are_unique_confirmed_and_traceable(self):
        ids = [item['id'] for item in self.facts]
        self.assertEqual(len(ids), len(set(ids)))
        for fact in self.facts:
            with self.subTest(fact=fact['id']):
                self.assertEqual(fact['status'], 'confirmed')
                self.assertIn(fact['type'], {'syntax', 'constraint', 'environment', 'behavior_oracle'})
                self.assertTrue(fact['source_refs'])
                self.assertTrue(all(ref.startswith('w6_5_1_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'ai_wave6_5_index_advisor',
            'ai_wave6_5_plan_encoding',
            'ai_wave6_5_db4ai_predict_family',
            'ai_wave6_5_model_explain',
            'ai_wave6_5_acm_feedback',
            'ai_wave6_5_acm_feedback_fields',
            'ai_wave6_5_costmodel_calibration',
            'ai_wave6_5_costmodel_parameters',
            'ai_wave6_5_autohint_aplan',
            'ai_wave6_5_watchdog',
            'ai_wave6_5_llm_functions',
            'sensitive_wave6_5_discovery',
            'sensitive_wave6_5_discovery_params',
            'masking_wave6_5_functions',
            'masking_wave6_5_semantics',
            'masking_wave6_5_regexp_params',
            'hierarchy_wave6_5_sys_connect_by_path',
            'hierarchy_wave6_5_connect_by_root',
            'hierarchy_wave6_5_return_types',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_four_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 4)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_ai_security_wave6_5.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
