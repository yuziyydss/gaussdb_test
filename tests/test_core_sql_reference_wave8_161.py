"""SQL Reference Wave 8-161 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_161_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_161_v1/manifest.json'

class CoreSQLReferenceWave8161Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_dbe_sql_slice2(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_161_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 16)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 2874)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 2890)
        self.assertEqual(self.manifest['scope']['sections'], ['3.12'])
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
                self.assertTrue(all(ref.startswith('w8_161_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_dbe_sql_slice2_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'dbesql_wave8_161_get_result_any',
            'dbesql_wave8_161_get_result_char',
            'dbesql_wave8_161_get_result_int',
            'dbesql_wave8_161_get_result_long',
            'dbesql_wave8_161_get_result_raw',
            'dbesql_wave8_161_get_result_bytea_text',
            'dbesql_wave8_161_get_result_unknown',
            'dbesql_wave8_161_dbe_sql_get_result_variants',
            'dbesql_wave8_161_get_result_long2_note',
            'dbesql_wave8_161_is_active',
            'dbesql_wave8_161_last_row_count',
            'dbesql_wave8_161_run_and_next',
            'dbesql_wave8_161_sql_bind_variable',
            'dbesql_wave8_161_sql_bind_array',
            'dbesql_wave8_161_set_result_type_ints_texts',
            'dbesql_wave8_161_set_result_type_raws_byteas_chars',
            'dbesql_wave8_161_set_results_type',
            'dbesql_wave8_161_get_results_family',
            'dbesql_wave8_161_array_access_semantics',
            'dbesql_wave8_161_err_param_unimplemented',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_161.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
