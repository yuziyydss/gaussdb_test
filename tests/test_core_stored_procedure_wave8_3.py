"""Stored Procedure Wave 8-3 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_stored_procedure_wave8_3_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_stored_procedure_wave8_3_v1/manifest.json'

class CoreStoredProcedureWave83Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_lock_and_cursor_chapters(self):
        self.assertEqual(self.manifest['kind'], 'core_stored_procedure_wave8_3_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 2)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 14)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 2627)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 2641)
        self.assertEqual(self.manifest['scope']['sections'], ['3.10', '3.11'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 21)
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
                self.assertTrue(all(ref.startswith('w8_3_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_lock_and_cursor_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sp_lock_wave8_3_read_lock',
            'sp_lock_wave8_3_write_lock',
            'sp_lock_wave8_3_ddl_deadlock',
            'sp_lock_wave8_3_ddl_write_lock',
            'sp_lock_wave8_3_package_read_lock',
            'sp_lock_wave8_3_invalidation_deadlock',
            'sp_cursor_wave8_3_definition',
            'sp_cursor_wave8_3_jdbc_returns',
            'sp_cursor_wave8_3_commit_rollback_cache',
            'sp_cursor_wave8_3_rollback_fetch_error',
            'sp_cursor_wave8_3_extra_output_vars',
            'sp_cursor_wave8_3_hold_cursor_guc',
            'sp_cursor_wave8_3_sql_usage',
            'sp_cursor_wave8_3_explicit_steps',
            'sp_cursor_wave8_3_static_params',
            'sp_cursor_wave8_3_dynamic_cursor',
            'sp_cursor_wave8_3_open_semantics',
            'sp_cursor_wave8_3_implicit_attributes',
            'sp_cursor_wave8_3_compat_cursor_guc',
            'sp_cursor_wave8_3_for_as_loop',
            'sp_cursor_wave8_3_shared_attributes',
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
            [sys.executable, str(ROOT / 'scripts/build_core_stored_procedure_wave8_3.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
