"""Tools Wave 8-18 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_tools_wave8_18_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_tools_wave8_18_v1/manifest.json'

class CoreToolsWave818Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_operations_management_tools(self):
        self.assertEqual(self.manifest['kind'], 'core_tools_wave8_18_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 131)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 3655)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 3786)
        self.assertEqual(self.manifest['scope']['sections'], ['5.4'])
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
                self.assertTrue(all(ref.startswith('w8_18_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_operations_management_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'tools_wave8_18_overview',
            'tools_wave8_18_collector_scope',
            'tools_wave8_18_collector_speed_limit',
            'tools_wave8_18_guc_scope',
            'tools_wave8_18_guc_constraints',
            'tools_wave8_18_om_scope',
            'tools_wave8_18_om_switch_prereq',
            'tools_wave8_18_om_change_mode_constraints',
            'tools_wave8_18_ctl_scope',
            'tools_wave8_18_ctl_safety',
            'tools_wave8_18_switch_ddb_topology',
            'tools_wave8_18_controldata',
            'tools_wave8_18_resetxlog_risk',
            'tools_wave8_18_node_execution',
            'tools_wave8_18_etcd_io',
            'tools_wave8_18_gaussdb_process',
            'tools_wave8_18_replace_scope',
            'tools_wave8_18_rescue_boundary',
            'tools_wave8_18_gns_maintenance',
            'tools_wave8_18_auxiliary_diagnostics',
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
            [sys.executable, str(ROOT / 'scripts/build_core_tools_wave8_18.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
