"""SQL Reference Wave 8-88 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_95_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_95_v1/manifest.json'

class CoreSQLReferenceWave895Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_adp_dir_event_ext_func(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_95_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 5)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 15)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1207)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1225)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.7.8', '1.13.7.9', '1.13.7.10', '1.13.7.11', '1.13.7.14'])
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
                self.assertTrue(all(ref.startswith('w8_95_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_adp_dir_event_ext_func_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'alter_default_privileges_wave8_95_syntax',
            'alter_default_privileges_wave8_95_grant_clauses',
            'alter_default_privileges_wave8_95_revoke_clauses',
            'alter_default_privileges_wave8_95_params_example',
            'alter_directory_wave8_95_syntax',
            'alter_directory_wave8_95_permission',
            'alter_event_wave8_95_syntax',
            'alter_event_wave8_95_restrictions',
            'alter_event_wave8_95_definer_options',
            'alter_event_wave8_95_interval_note',
            'alter_event_wave8_95_example',
            'alter_extension_wave8_95_prereq',
            'alter_extension_wave8_95_forms',
            'alter_extension_wave8_95_member_objects',
            'alter_extension_wave8_95_params_example',
            'alter_function_wave8_95_syntax',
            'alter_function_wave8_95_permission',
            'alter_function_wave8_95_action_semantics',
            'alter_function_wave8_95_params',
            'alter_function_wave8_95_example',
        }
        self.assertEqual(expected, ids)

    def test_manifest_resolves_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 5)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_95.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
