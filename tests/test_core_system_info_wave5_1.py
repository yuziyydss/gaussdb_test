"""System Information Functions Wave 5-1 extraction is source-bound and traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_info_wave5_1_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_info_wave5_1_v1/manifest.json'


class CoreSystemInfoWave51Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_first_system_info_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_system_info_wave5_1_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 560)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 572)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 12)
        self.assertIn('1.6.26 系统信息函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 37)
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
                self.assertEqual(fact['source_refs'], ['w5_1_1_6_26'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sysinfo_wave5_1_sys_context',
            'sysinfo_wave5_1_sys_context_supported',
            'sysinfo_wave5_1_userenv',
            'sysinfo_wave5_1_userenv_unsupported',
            'sysinfo_wave5_1_current_catalog_database',
            'sysinfo_wave5_1_current_query',
            'sysinfo_wave5_1_current_schema',
            'sysinfo_wave5_1_current_schemas',
            'sysinfo_wave5_1_database_b_mode',
            'sysinfo_wave5_1_current_user',
            'sysinfo_wave5_1_definer_current_user',
            'sysinfo_wave5_1_pg_current_sessionid',
            'sysinfo_wave5_1_pg_current_sessid',
            'sysinfo_wave5_1_pg_current_userid',
            'sysinfo_wave5_1_version_number',
            'sysinfo_wave5_1_tablespace_oid_name',
            'sysinfo_wave5_1_inet_client_server',
            'sysinfo_wave5_1_inet_remote_only',
            'sysinfo_wave5_1_backend_pid',
            'sysinfo_wave5_1_conf_load_time',
            'sysinfo_wave5_1_temp_schema',
            'sysinfo_wave5_1_listening_channels',
            'sysinfo_wave5_1_postmaster_start_time',
            'sysinfo_wave5_1_ruledef',
            'sysinfo_wave5_1_sessionid2pid',
            'sysinfo_wave5_1_session_context',
            'sysinfo_wave5_1_trigger_depth',
            'sysinfo_wave5_1_session_user',
            'sysinfo_wave5_1_user_current_user',
            'sysinfo_wave5_1_user_projection_a_mode',
            'sysinfo_wave5_1_username_encoding',
            'sysinfo_wave5_1_version_functions',
            'sysinfo_wave5_1_node_info',
            'sysinfo_wave5_1_schema_oid_client_info',
            'sysinfo_wave5_1_session_memory_detail',
            'sysinfo_wave5_1_session_memory_detail_fields',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.26')
        self.assertEqual(source['physical_page_start'], 560)
        self.assertEqual(source['physical_page_end'], 572)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_info_wave5_1.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
