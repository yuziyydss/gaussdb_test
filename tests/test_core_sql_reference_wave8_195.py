"""SQL Reference Wave 8-191 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_195_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_195_v1/manifest.json'

class CoreSQLReferenceWave8195Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_mcompat_dcl_other_grant(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_195_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 3485)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 3495)
        self.assertEqual(self.manifest['scope']['sections'], ['4.4.2'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 14)
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
                self.assertTrue(all(ref.startswith('w8_195_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_mcompat_topics_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'mcompat_wave8_195_admin_roles_any_privilege',
            'mcompat_wave8_195_describe',
            'mcompat_wave8_195_grant_privilege_types',
            'mcompat_wave8_195_grant_public_owner',
            'mcompat_wave8_195_grant_syntax_diff',
            'mcompat_wave8_195_lock_mechanism',
            'mcompat_wave8_195_odbc_escape',
            'mcompat_wave8_195_pbe',
            'mcompat_wave8_195_set_names_collate',
            'mcompat_wave8_195_set_system_parameter',
            'mcompat_wave8_195_set_user_variable',
            'mcompat_wave8_195_show_grants_delete_recreate',
            'mcompat_wave8_195_start_transaction_snapshot',
            'mcompat_wave8_195_use_schema',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_195.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
