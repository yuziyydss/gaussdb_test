"""SQL Reference Wave 8-88 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_118_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_118_v1/manifest.json'

class CoreSQLReferenceWave8118Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_mcompat_tcl_set(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_118_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 8)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 13)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 2238)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 2279)
        self.assertEqual(self.manifest['scope']['sections'], ['2.4.2.15.2', '2.4.2.15.7', '2.4.2.15.8', '2.4.2.16.1', '2.4.2.16.4', '2.4.2.16.5', '2.4.2.16.6', '2.4.2.16.7'])
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
                self.assertTrue(all(ref.startswith('w8_118_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_mcompat_tcl_set_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'm_release_savepoint_wave8_118_syntax',
            'm_release_savepoint_wave8_118_limits',
            'm_rollback_wave8_118_syntax',
            'm_rollback_savepoint_wave8_118_syntax',
            'm_savepoint_wave8_118_syntax',
            'm_savepoint_wave8_118_rollback_limits',
            'm_savepoint_wave8_118_same_name',
            'm_savepoint_wave8_118_example',
            'm_set_wave8_118_forms',
            'm_set_wave8_118_session_local',
            'm_set_wave8_118_user_variables',
            'm_set_wave8_118_at_at_syntax',
            'm_set_wave8_118_example',
            'm_set_role_wave8_118_syntax',
            'm_set_role_wave8_118_example',
            'm_set_session_auth_wave8_118_syntax',
            'm_set_session_auth_wave8_118_example',
            'm_set_transaction_wave8_118_syntax',
            'm_set_transaction_wave8_118_s2_note',
            'm_set_transaction_wave8_118_example',
        }
        self.assertEqual(expected, ids)

    def test_manifest_resolves_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 8)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_118.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
