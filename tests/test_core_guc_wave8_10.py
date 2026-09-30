"""GUC Wave 8-10 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_guc_wave8_10_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_guc_wave8_10_v1/manifest.json'

class CoreGUCWave810Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_view_and_set_parameters(self):
        self.assertEqual(self.manifest['kind'], 'core_guc_wave8_10_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 2)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 7)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 4135)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 4142)
        self.assertEqual(self.manifest['scope']['sections'], ['7.1', '7.2'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 23)
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
                self.assertTrue(all(ref.startswith('w8_10_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_parameter_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'guc_wave8_10_show_single',
            'guc_wave8_10_show_all',
            'guc_wave8_10_pg_settings',
            'guc_wave8_10_cm_view_files',
            'guc_wave8_10_cm_view_command',
            'guc_wave8_10_name_types',
            'guc_wave8_10_boolean_values',
            'guc_wave8_10_enum_float',
            'guc_wave8_10_float_zero',
            'guc_wave8_10_units',
            'guc_wave8_10_internal_type',
            'guc_wave8_10_postmaster_type',
            'guc_wave8_10_sighup_type',
            'guc_wave8_10_backend_suset_userset',
            'guc_wave8_10_pdb_sighup',
            'guc_wave8_10_set_sql_levels',
            'guc_wave8_10_priority',
            'guc_wave8_10_pdb_set',
            'guc_wave8_10_pdb_priority',
            'guc_wave8_10_unsupported_units',
            'guc_wave8_10_cm_restart_mode',
            'guc_wave8_10_cm_reload_mode',
            'guc_wave8_10_cm_param_limit',
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
            [sys.executable, str(ROOT / 'scripts/build_core_guc_wave8_10.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
