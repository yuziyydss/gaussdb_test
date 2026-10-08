"""SQL Reference Wave 8-39 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_39_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_39_v1/manifest.json'

class CoreSQLReferenceWave839Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_create_trigger(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_39_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 8)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1614)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1622)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.9.56'])
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
                self.assertTrue(all(ref.startswith('w8_39_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_create_trigger_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'trig_wave8_39_purpose',
            'trig_wave8_39_supported_objects',
            'trig_wave8_39_same_event_order',
            'trig_wave8_39_performance',
            'trig_wave8_39_execution_identity',
            'trig_wave8_39_creation_permission',
            'trig_wave8_39_before_row_null',
            'trig_wave8_39_before_old_new',
            'trig_wave8_39_normal_return',
            'trig_wave8_39_instead_of',
            'trig_wave8_39_overload_limit',
            'trig_wave8_39_merge_replace_support',
            'trig_wave8_39_main_syntax',
            'trig_wave8_39_or_replace_limit',
            'trig_wave8_39_constraint_trigger',
            'trig_wave8_39_name_events',
            'trig_wave8_39_referenced_deferrable',
            'trig_wave8_39_row_statement_when',
            'trig_wave8_39_anonyblock_function',
            'trig_wave8_39_kind_matrix_variables',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_39.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
