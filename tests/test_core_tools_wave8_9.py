"""Tools Wave 8-9 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_tools_wave8_9_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_tools_wave8_9_v1/manifest.json'

class CoreToolsWave89Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_upgrade_tools(self):
        self.assertEqual(self.manifest['kind'], 'core_tools_wave8_9_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 37)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 3991)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 4028)
        self.assertEqual(self.manifest['scope']['sections'], ['5.9'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 20)
        self.assertEqual(self.manifest['summary']['open_question_count'], 1)
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
                self.assertTrue(all(ref.startswith('w8_9_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_upgrade_tool_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'tools_wave8_9_overview',
            'tools_wave8_9_hotpatch_scope',
            'tools_wave8_9_hotpatch_modes',
            'tools_wave8_9_hotpatch_params',
            'tools_wave8_9_hotpatch_single_node',
            'tools_wave8_9_upgrade_modes',
            'tools_wave8_9_inplace_stop_business',
            'tools_wave8_9_grey_upgrade',
            'tools_wave8_9_rolling_upgrade',
            'tools_wave8_9_upgrade_conflicts',
            'tools_wave8_9_roach_backup',
            'tools_wave8_9_upgrade_precondition',
            'tools_wave8_9_upgrade_commands',
            'tools_wave8_9_commit_irreversible',
            'tools_wave8_9_component_upgrade',
            'tools_wave8_9_admin_password_stdin',
            'tools_wave8_9_grey_limits',
            'tools_wave8_9_rollback_modes',
            'tools_wave8_9_dr_flags',
            'tools_wave8_9_om_rollback',
        }
        self.assertEqual(expected, ids)

    def test_manifest_resolves_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_tools_wave8_9.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
