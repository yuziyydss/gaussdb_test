"""SQL Reference Wave 8-45 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_45_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_45_v1/manifest.json'

class CoreSQLReferenceWave845Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_alter_database(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_45_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 6)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1200)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1206)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.7.6'])
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
                self.assertTrue(all(ref.startswith('w8_45_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_alter_database_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'altdb_wave8_45_purpose',
            'altdb_wave8_45_general_permissions',
            'altdb_wave8_45_rename_permission',
            'altdb_wave8_45_owner_permissions',
            'altdb_wave8_45_tablespace_permissions',
            'altdb_wave8_45_current_database_rename',
            'altdb_wave8_45_templatem_rename',
            'altdb_wave8_45_connection_limit_syntax',
            'altdb_wave8_45_rename_syntax',
            'altdb_wave8_45_owner_syntax',
            'altdb_wave8_45_tablespace_syntax',
            'altdb_wave8_45_tablespace_conflict',
            'altdb_wave8_45_set_parameter_syntax',
            'altdb_wave8_45_reset_parameter_syntax',
            'altdb_wave8_45_private_object_syntax',
            'altdb_wave8_45_private_object_behavior',
            'altdb_wave8_45_dbtimezone_syntax',
            'altdb_wave8_45_move_buckets',
            'altdb_wave8_45_ilm',
            'altdb_wave8_45_parameter_timing',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_45.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
