"""SQL Reference Wave 8-87 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_87_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_87_v1/manifest.json'

class CoreSQLReferenceWave887Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_dblink_dir_event_ext(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_87_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 4)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1423)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1433)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.9.17', '1.13.9.18', '1.13.9.19', '1.13.9.20'])
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
                self.assertTrue(all(ref.startswith('w8_87_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_dblink_dir_event_ext_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'create_db_link_wave8_87_purpose',
            'create_db_link_wave8_87_a_mode_notes',
            'create_db_link_wave8_87_gauss_options',
            'create_db_link_wave8_87_oci_options',
            'create_db_link_wave8_87_ssl',
            'create_db_link_wave8_87_example',
            'create_directory_wave8_87_purpose',
            'create_directory_wave8_87_security',
            'create_directory_wave8_87_privileges_validation',
            'create_directory_wave8_87_example',
            'create_event_wave8_87_purpose',
            'create_event_wave8_87_compat_permissions',
            'create_event_wave8_87_body_limits',
            'create_event_wave8_87_schedule',
            'create_event_wave8_87_options',
            'create_event_wave8_87_example',
            'create_extension_wave8_87_purpose_limits',
            'create_extension_wave8_87_syntax',
            'create_extension_wave8_87_schema_version',
            'create_extension_wave8_87_example',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_87.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
