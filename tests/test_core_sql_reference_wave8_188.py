"""SQL Reference Wave 8-188 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_188_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_188_v1/manifest.json'

class CoreSQLReferenceWave8188Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_mcompat_datatypes(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_188_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 39)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 3292)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 3331)
        self.assertEqual(self.manifest['scope']['sections'], ['4.4.2'])
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
                self.assertTrue(all(ref.startswith('w8_188_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_mcompat_datatype_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'mcompat_wave8_188_overview',
            'mcompat_wave8_188_int_types',
            'mcompat_wave8_188_decimal_types',
            'mcompat_wave8_188_float_types',
            'mcompat_wave8_188_datetime_types',
            'mcompat_wave8_188_string_types',
            'mcompat_wave8_188_binary_types',
            'mcompat_wave8_188_json_type',
            'mcompat_wave8_188_type_attributes',
            'mcompat_wave8_188_type_conversion',
            'mcompat_wave8_188_blob_detail',
            'mcompat_wave8_188_binary_hex_diff',
            'mcompat_wave8_188_json_limits',
            'mcompat_wave8_188_json_charset',
            'mcompat_wave8_188_json_orderby',
            'mcompat_wave8_188_zerofill_diff',
            'mcompat_wave8_188_text_default_diff',
            'mcompat_wave8_188_binary_fill_diff',
            'mcompat_wave8_188_datetime_precision_diff',
            'mcompat_wave8_188_timestamp_defaults',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_188.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
