"""SQL Reference Wave 8-60 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_60_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_60_v1/manifest.json'

class CoreSQLReferenceWave860Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_insert_all(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_60_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 8)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1753)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1761)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.14.8'])
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
                self.assertTrue(all(ref.startswith('w8_60_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_insert_all_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'insert_all_wave8_60_purpose',
            'insert_all_wave8_60_privileges',
            'insert_all_wave8_60_generated_columns',
            'insert_all_wave8_60_a_mode_only',
            'insert_all_wave8_60_syntax',
            'insert_all_wave8_60_plan_hint',
            'insert_all_wave8_60_all_first_semantics',
            'insert_all_wave8_60_when_condition',
            'insert_all_wave8_60_alias_name',
            'insert_all_wave8_60_partition_clause',
            'insert_all_wave8_60_column_name',
            'insert_all_wave8_60_values_single_row',
            'insert_all_wave8_60_expression_rules',
            'insert_all_wave8_60_default',
            'insert_all_wave8_60_subquery_required',
            'insert_all_wave8_60_example_unconditional',
            'insert_all_wave8_60_example_first',
            'insert_all_wave8_60_example_all_conditional',
            'insert_all_wave8_60_plsql',
            'insert_all_wave8_60_exceptions',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_60.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
