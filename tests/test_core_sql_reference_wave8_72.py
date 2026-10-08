"""SQL Reference Wave 8-72 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_72_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_72_v1/manifest.json'

class CoreSQLReferenceWave872Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_timecapsule_truncate(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_72_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 3)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1871)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1881)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.20.1', '1.13.20.2', '1.13.20.3'])
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
                self.assertTrue(all(ref.startswith('w8_72_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_timecapsule_truncate_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'timecapsule_table_wave8_72_purpose',
            'timecapsule_table_wave8_72_unsupported_objects',
            'timecapsule_table_wave8_72_ddl_gap',
            'timecapsule_table_wave8_72_privileges',
            'timecapsule_table_wave8_72_unsuitable_scenarios',
            'timecapsule_table_wave8_72_drop_truncate_constraints',
            'timecapsule_table_wave8_72_vacuum_upgrade',
            'timecapsule_table_wave8_72_syntax',
            'timecapsule_table_wave8_72_example',
            'truncate_wave8_72_purpose',
            'truncate_wave8_72_privileges',
            'truncate_wave8_72_vs_delete',
            'truncate_wave8_72_ddl_diff',
            'truncate_wave8_72_syntax',
            'truncate_wave8_72_example',
            'timecapsule_database_wave8_72_purpose',
            'timecapsule_database_wave8_72_unsuitable',
            'timecapsule_database_wave8_72_constraints',
            'timecapsule_database_wave8_72_syntax',
            'timecapsule_database_wave8_72_example',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_72.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
