"""SQL Reference Wave 8-85 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_85_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_85_v1/manifest.json'

class CoreSQLReferenceWave885Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_drop_tail_call_family(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_85_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 3)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 7)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1374)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1403)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.9.7', '1.13.9.8', '1.13.9.10'])
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
                self.assertTrue(all(ref.startswith('w8_85_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_commit_createagg_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'commit_end_wave8_85_purpose',
            'commit_end_wave8_85_visibility',
            'commit_end_wave8_85_privileges',
            'commit_end_wave8_85_example',
            'commit_prepared_wave8_85_purpose',
            'commit_prepared_wave8_85_privileges',
            'commit_prepared_wave8_85_example_prepare',
            'commit_prepared_wave8_85_example_commit',
            'create_aggregate_wave8_85_purpose',
            'create_aggregate_wave8_85_syntax',
            'create_aggregate_wave8_85_name_input',
            'create_aggregate_wave8_85_basetype',
            'create_aggregate_wave8_85_sfunc',
            'create_aggregate_wave8_85_state_ffunc',
            'create_aggregate_wave8_85_initcond',
            'create_aggregate_wave8_85_sortop',
            'create_aggregate_wave8_85_cfunc_collection',
            'create_aggregate_wave8_85_initfunc',
            'create_aggregate_wave8_85_shippable',
            'create_aggregate_wave8_85_example',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_85.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
