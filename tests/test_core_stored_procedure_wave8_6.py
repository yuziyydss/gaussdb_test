"""Stored Procedure Wave 8-6 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_stored_procedure_wave8_6_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_stored_procedure_wave8_6_v1/manifest.json'

class CoreStoredProcedureWave86Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_retry_debug_package(self):
        self.assertEqual(self.manifest['kind'], 'core_stored_procedure_wave8_6_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 3)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 6)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 3085)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 3091)
        self.assertEqual(self.manifest['scope']['sections'], ['3.13', '3.14', '3.15'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 18)
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
                self.assertTrue(all(ref.startswith('w8_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_retry_debug_package_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sp_retry_wave8_6_scope',
            'sp_retry_wave8_6_decision',
            'sp_retry_wave8_6_rollback',
            'sp_raise_wave8_6_forms',
            'sp_raise_wave8_6_levels',
            'sp_raise_wave8_6_message_controls',
            'sp_raise_wave8_6_format',
            'sp_raise_wave8_6_options',
            'sp_raise_wave8_6_default_sqlstate',
            'sp_raise_wave8_6_sqlstate_boundary',
            'sp_raise_wave8_6_exception_init',
            'sp_raise_wave8_6_exception_init_semantics',
            'sp_raise_wave8_6_exception_init_limits',
            'sp_package_wave8_6_definition',
            'sp_package_wave8_6_visibility',
            'sp_package_wave8_6_limits',
            'sp_package_wave8_6_pseudo_type_limit',
            'sp_package_wave8_6_param_signature',
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
            [sys.executable, str(ROOT / 'scripts/build_core_stored_procedure_wave8_6.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
