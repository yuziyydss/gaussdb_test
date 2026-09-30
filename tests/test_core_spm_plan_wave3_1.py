"""SPM Plan Management Wave 3-1 extraction is source-bound and complete."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_spm_plan_wave3_1_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_spm_plan_wave3_1_v1/manifest.json'


class CoreSPMPlanWave31Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_spm_plan_management(self):
        self.assertEqual(self.manifest['kind'], 'core_spm_plan_wave3_1_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 804)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 813)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 9)
        self.assertEqual(self.manifest['scope']['subsection'], '1.6.28 SPM计划管理函数')
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 21)
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
                self.assertEqual(fact['source_refs'], ['w3_1_1_6_28'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_spm_functions_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'spm_wave3_1_evolute_plan',
            'spm_wave3_1_evolute_plan_precondition',
            'spm_wave3_1_set_plan_status',
            'spm_wave3_1_set_plan_status_effect',
            'spm_wave3_1_display_plans',
            'spm_wave3_1_display_plans_status',
            'spm_wave3_1_display_plans_namespace',
            'spm_wave3_1_reload_plan',
            'spm_wave3_1_validate_plan',
            'spm_wave3_1_delete_plan',
            'spm_wave3_1_delete_plan_abort_risk',
            'spm_wave3_1_get_plan_history',
            'spm_wave3_1_plan_status_values',
            'spm_wave3_1_history_source_values',
            'spm_wave3_1_history_namespace_oids',
            'spm_wave3_1_accept_historical_plan',
            'spm_wave3_1_accept_historical_plan_status',
            'spm_wave3_1_accept_historical_plan_namespace',
            'spm_wave3_1_delete_plan_history',
            'spm_wave3_1_delete_plan_history_identity',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.28')
        self.assertEqual(source['physical_page_start'], 804)
        self.assertEqual(source['physical_page_end'], 813)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_spm_plan_wave3_1.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
