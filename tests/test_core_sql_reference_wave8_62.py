"""SQL Reference Wave 8-62 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_62_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_62_v1/manifest.json'

class CoreSQLReferenceWave862Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_load_lock(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_62_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 3)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1760)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1770)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.15.1', '1.13.15.2', '1.13.15.3'])
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
                self.assertTrue(all(ref.startswith('w8_62_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_load_lock_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'load_data_wave8_62_purpose',
            'load_data_wave8_62_compat_modes',
            'load_data_wave8_62_privileges',
            'load_data_wave8_62_table_only_typefail',
            'load_data_wave8_62_outfile_combo',
            'load_data_wave8_62_local_path',
            'load_data_wave8_62_replace_ignore',
            'load_data_wave8_62_partition_charset',
            'load_data_wave8_62_field_line_options',
            'load_data_wave8_62_ignore_rows_cols_set',
            'load_data_wave8_62_example',
            'lock_wave8_62_purpose',
            'lock_wave8_62_transaction_boundary',
            'lock_wave8_62_default_privileges_maintenance',
            'lock_wave8_62_syntax_name_only',
            'lock_wave8_62_modes',
            'lock_wave8_62_nowait',
            'lock_wave8_62_example',
            'lock_buckets_wave8_62_purpose',
            'lock_buckets_wave8_62_not_supported',
        }
        self.assertEqual(expected, ids)

    def test_manifest_resolves_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 3)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_62.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
