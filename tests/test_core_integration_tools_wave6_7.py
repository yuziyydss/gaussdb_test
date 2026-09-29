"""Integration and tools Wave 6-7 extraction is source-bound and traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_integration_tools_wave6_7_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_integration_tools_wave6_7_v1/manifest.json'


class CoreIntegrationToolsWave67Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_six_integration_tool_sections(self):
        self.assertEqual(self.manifest['kind'], 'core_integration_tools_wave6_7_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 6)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 18)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1039)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1057)
        self.assertEqual(
            self.manifest['scope']['sections'],
            ['1.6.53', '1.6.54', '1.6.55', '1.6.56', '1.6.57', '1.6.58'],
        )
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 25)
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
                self.assertTrue(all(ref.startswith('w6_7_1_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'integration_wave6_7_close_dblink',
            'integration_wave6_7_ora_diag',
            'integration_wave6_7_oci_memory',
            'integration_wave6_7_connection_status',
            'integration_wave6_7_fdw_handler_validator',
            'integration_wave6_7_dblink_state_functions',
            'monitor_wave6_7_cpustat',
            'monitor_wave6_7_procstat',
            'monitor_wave6_7_iostat',
            'monitor_wave6_7_memstat',
            'monitor_wave6_7_netstat',
            'autonomous_wave6_7_detail',
            'autonomous_wave6_7_count',
            'autonomous_wave6_7_reset',
            'dsl_wave6_7_add_rule',
            'dsl_wave6_7_add_rule_params',
            'dsl_wave6_7_del_set_reload',
            'dsl_wave6_7_permissions_attrs',
            'mq_wave6_7_model_boundaries',
            'mq_wave6_7_params_limits',
            'mq_wave6_7_register_send_query',
            'mq_wave6_7_query_consumption',
            'mq_wave6_7_admin_sync_functions',
            'rowid_wave6_7_functions',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_six_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 6)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_integration_tools_wave6_7.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
