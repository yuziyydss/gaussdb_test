"""SQL Reference Wave 8-191 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_194_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_194_v1/manifest.json'

class CoreSQLReferenceWave8194Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_mcompat_dml(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_194_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 51)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 3434)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 3485)
        self.assertEqual(self.manifest['scope']['sections'], ['4.4.2'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 45)
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
                self.assertTrue(all(ref.startswith('w8_194_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_mcompat_topics_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'mcompat_wave8_194_backslash',
            'mcompat_wave8_194_delete_multi_table',
            'mcompat_wave8_194_fk_timestamp_datetime',
            'mcompat_wave8_194_force_use_ignore_index',
            'mcompat_wave8_194_ignore_feature',
            'mcompat_wave8_194_insert_fewer_values',
            'mcompat_wave8_194_insert_values_set_alias',
            'mcompat_wave8_194_join_syntax',
            'mcompat_wave8_194_limit',
            'mcompat_wave8_194_limit_null',
            'mcompat_wave8_194_load_data',
            'mcompat_wave8_194_natural_join',
            'mcompat_wave8_194_nested_subquery_unsigned',
            'mcompat_wave8_194_on_duplicate_key',
            'mcompat_wave8_194_only_full_group_by',
            'mcompat_wave8_194_orderby_groupby',
            'mcompat_wave8_194_replace_into',
            'mcompat_wave8_194_select_column_name',
            'mcompat_wave8_194_select_datetime_numeric',
            'mcompat_wave8_194_select_for_update',
            'mcompat_wave8_194_select_into',
            'mcompat_wave8_194_select_into_outfile',
            'mcompat_wave8_194_select_syntax_scope',
            'mcompat_wave8_194_select_variable',
            'mcompat_wave8_194_show_columns',
            'mcompat_wave8_194_show_create_database',
            'mcompat_wave8_194_show_create_table',
            'mcompat_wave8_194_show_create_view',
            'mcompat_wave8_194_show_databases_row_expr',
            'mcompat_wave8_194_show_index_variables_charset_collation',
            'mcompat_wave8_194_show_processlist_engines',
            'mcompat_wave8_194_show_tables_status',
            'mcompat_wave8_194_subquery_multi_column',
            'mcompat_wave8_194_subquery_precision',
            'mcompat_wave8_194_subquery_target_table',
            'mcompat_wave8_194_table_syntax',
            'mcompat_wave8_194_three_part_name',
            'mcompat_wave8_194_time_datetime_precision',
            'mcompat_wave8_194_union_except_type',
            'mcompat_wave8_194_union_order',
            'mcompat_wave8_194_update_delete_orderby_limit',
            'mcompat_wave8_194_update_multi_table',
            'mcompat_wave8_194_update_set_order',
            'mcompat_wave8_194_user_variable',
            'mcompat_wave8_194_with_as',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_194.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
