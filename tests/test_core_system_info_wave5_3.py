"""System Information Functions Wave 5-3 definitions and visibility are traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_info_wave5_3_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_info_wave5_3_v1/manifest.json'


class CoreSystemInfoWave53Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_third_system_info_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_system_info_wave5_3_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 579)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 587)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 8)
        self.assertIn('1.6.26 系统信息函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 32)
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
                self.assertEqual(fact['source_refs'], ['w5_3_1_6_26'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sysinfo_wave5_3_visibility_general',
            'sysinfo_wave5_3_visibility_oid_aliases',
            'sysinfo_wave5_3_visibility_table_example',
            'sysinfo_wave5_3_visibility_functions',
            'sysinfo_wave5_3_format_type',
            'sysinfo_wave5_3_getdistributekey',
            'sysinfo_wave5_3_pg_check_authid',
            'sysinfo_wave5_3_pg_describe_object',
            'sysinfo_wave5_3_constraintdef',
            'sysinfo_wave5_3_pg_get_expr',
            'sysinfo_wave5_3_functiondef',
            'sysinfo_wave5_3_function_signature_helpers',
            'sysinfo_wave5_3_indexdef',
            'sysinfo_wave5_3_indexdef_dump_schema_only',
            'sysinfo_wave5_3_keywords',
            'sysinfo_wave5_3_keywords_boundary',
            'sysinfo_wave5_3_userbyid',
            'sysinfo_wave5_3_viewdef',
            'sysinfo_wave5_3_tabledef',
            'sysinfo_wave5_3_tabledef_boundary',
            'sysinfo_wave5_3_options_to_table',
            'sysinfo_wave5_3_tablespace_databases',
            'sysinfo_wave5_3_tablespace_location',
            'sysinfo_wave5_3_pg_typeof',
            'sysinfo_wave5_3_collation_for',
            'sysinfo_wave5_3_extension_update_paths',
            'sysinfo_wave5_3_serial_sequence',
            'sysinfo_wave5_3_sequence_parameters',
            'sysinfo_wave5_3_col_description',
            'sysinfo_wave5_3_obj_description',
            'sysinfo_wave5_3_shobj_description',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.26')
        self.assertEqual(source['physical_page_start'], 579)
        self.assertEqual(source['physical_page_end'], 587)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_info_wave5_3.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
