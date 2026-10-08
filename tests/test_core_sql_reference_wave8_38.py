"""SQL Reference Wave 8-38 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_38_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_38_v1/manifest.json'

class CoreSQLReferenceWave838Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_create_procedure(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_38_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 7)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1495)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1502)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.9.37'])
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
                self.assertTrue(all(ref.startswith('w8_38_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_create_procedure_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'proc_wave8_38_purpose_syntax',
            'proc_wave8_38_precision',
            'proc_wave8_38_schema_search_path',
            'proc_wave8_38_locking',
            'proc_wave8_38_out_arg_call',
            'proc_wave8_38_overload_rules',
            'proc_wave8_38_style_body_limits',
            'proc_wave8_38_noarg_outfunc_call',
            'proc_wave8_38_out_expression_contexts',
            'proc_wave8_38_comments',
            'proc_wave8_38_any_permission',
            'proc_wave8_38_out_variable_required',
            'proc_wave8_38_security_mode',
            'proc_wave8_38_out_override_effects',
            'proc_wave8_38_dependency_replace',
            'proc_wave8_38_separation_rebuild',
            'proc_wave8_38_complex_call_length',
            'proc_wave8_38_guc_session',
            'proc_wave8_38_args_defaults',
            'proc_wave8_38_body_end_name',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_38.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
