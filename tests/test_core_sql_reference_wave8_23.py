"""SQL Reference Wave 8-23 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_23_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_23_v1/manifest.json'

class CoreSQLReferenceWave823Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_alter_table_syntax(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_23_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 30)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1272)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1302)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.7.36'])
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
                self.assertTrue(all(ref.startswith('w8_23_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_alter_table_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'alt_wave8_23_purpose_actions',
            'alt_wave8_23_permissions',
            'alt_wave8_23_object_boundaries',
            'alt_wave8_23_add_column_defaults',
            'alt_wave8_23_add_column_position',
            'alt_wave8_23_table_constraint_limits',
            'alt_wave8_23_online_ddl_restrictions',
            'alt_wave8_23_online_ddl_fallback',
            'alt_wave8_23_online_ddl_parameters',
            'alt_wave8_23_online_ddl_failure',
            'alt_wave8_23_table_actions',
            'alt_wave8_23_cluster_rowid_storage',
            'alt_wave8_23_trigger_rls_encryption',
            'alt_wave8_23_replica_identity',
            'alt_wave8_23_auto_increment_charset',
            'alt_wave8_23_ilm_policies',
            'alt_wave8_23_column_clause',
            'alt_wave8_23_modify_change_bmode',
            'alt_wave8_23_type_using_stats',
            'alt_wave8_23_constraints_identity',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_23.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
