"""SQL Reference Wave 8-67 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_67_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_67_v1/manifest.json'

class CoreSQLReferenceWave867Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_savepoint_seclabel_selectinto(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_67_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 3)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 7)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1803)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1853)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.19.1', '1.13.19.2', '1.13.19.4'])
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
                self.assertTrue(all(ref.startswith('w8_67_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_savepoint_seclabel_selectinto_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'savepoint_wave8_67_purpose',
            'savepoint_wave8_67_rollback_release',
            'savepoint_wave8_67_txblock',
            'savepoint_wave8_67_unrecoverable_errors',
            'savepoint_wave8_67_same_name',
            'savepoint_wave8_67_nesting',
            'savepoint_wave8_67_example',
            'security_label_wave8_67_purpose',
            'security_label_wave8_67_privileges',
            'security_label_wave8_67_syntax',
            'security_label_wave8_67_example',
            'select_into_wave8_67_purpose',
            'select_into_wave8_67_ctas_preferred',
            'select_into_wave8_67_syntax',
            'select_into_wave8_67_unlogged',
            'select_into_wave8_67_temp_types',
            'select_into_wave8_67_global_temp',
            'select_into_wave8_67_local_temp',
            'select_into_wave8_67_temp_notes',
            'select_into_wave8_67_example',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_67.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
