"""SQL Reference Wave 8-138 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_138_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_138_v1/manifest.json'

class CoreSQLReferenceWave8138Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_stored_procedure_basics(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_138_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 4)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 13)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 2539)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 2586)
        self.assertEqual(self.manifest['scope']['sections'], ['3.1', '3.2', '3.3', '3.5'])
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
                self.assertTrue(all(ref.startswith('w8_138_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_stored_procedure_fact_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sp_wave8_138_overview',
            'sp_wave8_138_datatype_xml',
            'sp_wave8_138_subtype_overview',
            'sp_wave8_138_subtype_limits',
            'sp_wave8_138_subtype_syntax',
            'sp_wave8_138_subtype_constraints',
            'sp_wave8_138_subtype_examples',
            'sp_wave8_138_typecast_overview',
            'sp_wave8_138_typecast_char_family',
            'sp_wave8_138_typecast_num_raw_clob',
            'sp_wave8_138_typecast_datea',
            'sp_wave8_138_block_structure',
            'sp_wave8_138_block_categories_anonymous',
            'sp_wave8_138_anonymous_memory',
            'sp_wave8_138_anonymous_jdbc',
            'sp_wave8_138_jdbc_version',
            'sp_wave8_138_subprogram_kinds',
            'sp_wave8_138_nested_limits',
            'sp_wave8_138_nested_syntax',
            'sp_wave8_138_nested_calls_vars',
        }
        self.assertEqual(expected, ids)

    def test_manifest_resolves_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 4)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_138.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
