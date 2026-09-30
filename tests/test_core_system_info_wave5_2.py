"""System Information Functions Wave 5-2 privilege extraction is traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_info_wave5_2_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_info_wave5_2_v1/manifest.json'


class CoreSystemInfoWave52Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_privilege_functions(self):
        self.assertEqual(self.manifest['kind'], 'core_system_info_wave5_2_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 571)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 579)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 8)
        self.assertIn('1.6.26 系统信息函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 22)
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
                self.assertEqual(fact['source_refs'], ['w5_2_1_6_26'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_privilege_functions_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sysinfo_wave5_2_owner_implicit_ddl',
            'sysinfo_wave5_2_has_any_column_privilege',
            'sysinfo_wave5_2_has_any_column_privilege_types',
            'sysinfo_wave5_2_has_column_privilege',
            'sysinfo_wave5_2_has_column_privilege_types',
            'sysinfo_wave5_2_has_cek_privilege',
            'sysinfo_wave5_2_has_cmk_privilege',
            'sysinfo_wave5_2_has_database_privilege',
            'sysinfo_wave5_2_has_directory_privilege',
            'sysinfo_wave5_2_has_foreign_data_wrapper_privilege',
            'sysinfo_wave5_2_has_function_privilege',
            'sysinfo_wave5_2_has_language_privilege',
            'sysinfo_wave5_2_has_nodegroup_privilege',
            'sysinfo_wave5_2_has_schema_privilege',
            'sysinfo_wave5_2_has_server_privilege',
            'sysinfo_wave5_2_has_table_privilege',
            'sysinfo_wave5_2_has_table_privilege_types',
            'sysinfo_wave5_2_has_tablespace_privilege',
            'sysinfo_wave5_2_pg_has_role',
            'sysinfo_wave5_2_has_any_privilege',
            'sysinfo_wave5_2_has_any_privilege_list',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.26')
        self.assertEqual(source['physical_page_start'], 571)
        self.assertEqual(source['physical_page_end'], 579)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_info_wave5_2.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
