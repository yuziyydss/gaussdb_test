"""SQL Reference Wave 8-179 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_179_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_179_v1/manifest.json'

class CoreSQLReferenceWave8179Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_keywords(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_179_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 35)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 51)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 86)
        self.assertEqual(self.manifest['scope']['sections'], ['1.2'])
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
                self.assertTrue(all(ref.startswith('w8_179_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_keyword_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'kw_wave8_179_overview',
            'kw_wave8_179_statistics',
            'kw_wave8_179_nonreserved_limits',
            'kw_wave8_179_variable_name_limits',
            'kw_wave8_179_sysrefcursor',
            'kw_wave8_179_func_type_limit',
            'kw_wave8_179_current_timestamp',
            'kw_wave8_179_mode_specific',
            'kw_wave8_179_identifier_rules',
            'kw_wave8_179_prohibited_columns',
            'kw_wave8_179_reserved_examples',
            'kw_wave8_179_nonreserved_func_type',
            'kw_wave8_179_gaussdb_only_nonreserved',
            'kw_wave8_179_reserved_func_or_type',
            'kw_wave8_179_sql1999_reserved',
            'kw_wave8_179_dual_standard_diff',
            'kw_wave8_179_type_name_keywords',
            'kw_wave8_179_xml_keywords',
            'kw_wave8_179_gaussdb_reserved_diff',
            'kw_wave8_179_keyword_table_structure',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_179.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
