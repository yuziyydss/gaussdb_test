"""XML Wave 7-8 extraction is source-bound and traceable."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_xml_wave7_8_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_xml_wave7_8_v1/manifest.json'

class CoreXMLWave78Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_xml_sections(self):
        self.assertEqual(self.manifest['kind'], 'core_xml_wave7_8_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 2)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 29)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 952)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 981)
        self.assertEqual(self.manifest['scope']['sections'], ['1.6.43', '1.6.44'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 29)
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
                self.assertTrue(all(ref.startswith('w7_8_1_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'xml_wave7_8_common_boundaries',
            'xml_wave7_8_parse_serialize',
            'xml_wave7_8_comment_concat',
            'xml_wave7_8_element_attributes',
            'xml_wave7_8_element_escape',
            'xml_wave7_8_forest_pi_root_agg',
            'xml_wave7_8_exists_wellformed',
            'xml_wave7_8_xpath_functions',
            'xml_wave7_8_query_cursor_mapping',
            'xml_wave7_8_schema_database_mapping',
            'xml_wave7_8_table_mapping',
            'xml_wave7_8_xpath_limitations',
            'xml_wave7_8_value_functions',
            'xml_wave7_8_cast',
            'xml_wave7_8_cast_limitations',
            'xmltype_wave7_8_constructors',
            'xmltype_wave7_8_constructor_boundaries',
            'xmltype_wave7_8_method_calls',
            'xmltype_wave7_8_getters',
            'xmltype_wave7_8_isfragment',
            'xmltype_wave7_8_path_functions',
            'xmltype_wave7_8_path_boundaries',
            'xmltype_wave7_8_extract_mode',
            'xmltype_wave7_8_sequence',
            'xmltype_wave7_8_cast',
            'xmltype_wave7_8_cast_limitations',
            'xmltype_wave7_8_query_sequence',
            'xmltype_wave7_8_query_xpath',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_two_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 2)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_xml_wave7_8.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
