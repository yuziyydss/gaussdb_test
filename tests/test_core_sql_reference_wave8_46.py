"""SQL Reference Wave 8-46 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_46_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_46_v1/manifest.json'

class CoreSQLReferenceWave846Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_drop_database_and_tablespace(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_46_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 2)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 5)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1662)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1695)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.10.10', '1.13.10.42'])
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
                self.assertTrue(all(ref.startswith('w8_46_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_drop_database_tablespace_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'dropdb_wave8_46_purpose',
            'dropdb_wave8_46_permissions',
            'dropdb_wave8_46_protected_databases',
            'dropdb_wave8_46_active_connections',
            'dropdb_wave8_46_transaction_block',
            'dropdb_wave8_46_failure_retry',
            'dropdb_wave8_46_recyclebin_off',
            'dropdb_wave8_46_recyclebin_on',
            'dropdb_wave8_46_syntax',
            'dropdb_wave8_46_if_exists',
            'dropdb_wave8_46_database_name',
            'dropdb_wave8_46_purge_keyword',
            'dropdb_wave8_46_recyclebin_example',
            'dropdb_wave8_46_purge_example',
            'dropdb_wave8_46_lifecycle',
            'droptbs_wave8_46_purpose',
            'droptbs_wave8_46_permissions',
            'droptbs_wave8_46_empty_required',
            'droptbs_wave8_46_no_transaction',
            'droptbs_wave8_46_syntax_semantics',
        }
        self.assertEqual(expected, ids)

    def test_manifest_resolves_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 2)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_46.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
