"""PL/SQL runtime and recompile Wave 6-2 extraction is source-bound."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_plsql_wave6_2_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_plsql_wave6_2_v1/manifest.json'


class CorePLSQLWave62Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_five_plsql_sections(self):
        self.assertEqual(self.manifest['kind'], 'core_plsql_wave6_2_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 5)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 15)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 980)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1059)
        self.assertEqual(
            self.manifest['scope']['sections'],
            ['1.6.45', '1.6.46', '1.6.47', '1.6.48', '1.6.59'],
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
                self.assertTrue(all(ref.startswith('w6_2_1_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'plsql_wave6_2_invalidate_object',
            'plsql_wave6_2_invalidate_noargs',
            'plsql_wave6_2_invalidate_args',
            'plsql_wave6_2_invalidate_observation',
            'plsql_wave6_2_memory_object_detail',
            'plsql_wave6_2_memory_object_detail_params',
            'plsql_wave6_2_memory_object_detail_fields',
            'plsql_wave6_2_dump_compiled_object',
            'plsql_wave6_2_dump_compiled_object_types',
            'plsql_wave6_2_dump_bytecode',
            'plsql_wave6_2_dump_bytecode_boundary',
            'plsql_wave6_2_bytecode_values',
            'plsql_wave6_2_tablefunc_extension',
            'plsql_wave6_2_crosstab_source_n',
            'plsql_wave6_2_crosstab_n',
            'plsql_wave6_2_crosstab_category',
            'plsql_wave6_2_sys_guid',
            'plsql_wave6_2_uuid',
            'plsql_wave6_2_uuid_short',
            'plsql_wave6_2_uuid_short_upgrade_boundary',
            'plsql_wave6_2_transform_view_dep_source',
            'plsql_wave6_2_compile_schema',
            'plsql_wave6_2_compile_schema_params',
            'plsql_wave6_2_compile_schema_boundary',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_five_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 5)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_plsql_wave6_2.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
