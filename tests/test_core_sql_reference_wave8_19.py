"""SQL Reference Wave 8-19 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_19_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_19_v1/manifest.json'

class CoreSQLReferenceWave819Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_select_syntax(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_19_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 44)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1806)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1850)
        self.assertEqual(self.manifest['scope']['sections'], ['1.13.19.3'])
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
                self.assertTrue(all(ref.startswith('w8_19_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_select_clause_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sql_wave8_19_purpose',
            'sql_wave8_19_permissions',
            'sql_wave8_19_alias_rules',
            'sql_wave8_19_cte',
            'sql_wave8_19_plan_hint',
            'sql_wave8_19_distinct',
            'sql_wave8_19_into',
            'sql_wave8_19_from_sources',
            'sql_wave8_19_tablesample',
            'sql_wave8_19_timecapsule',
            'sql_wave8_19_partition_query',
            'sql_wave8_19_join_types',
            'sql_wave8_19_xmltable',
            'sql_wave8_19_pivot_unpivot',
            'sql_wave8_19_where_outer_join',
            'sql_wave8_19_connect_by',
            'sql_wave8_19_group_having',
            'sql_wave8_19_window_frame',
            'sql_wave8_19_set_operations',
            'sql_wave8_19_order_limit_lock',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_19.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
