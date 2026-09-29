"""SQL control and tools Wave 6-6 extraction is source-bound and traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_control_wave6_6_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_control_wave6_6_v1/manifest.json'


class CoreSQLControlWave66Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_sql_control_and_tools(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_control_wave6_6_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 2)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 15)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 991)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1006)
        self.assertEqual(self.manifest['scope']['sections'], ['1.6.49', '1.6.50'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 28)
        self.assertEqual(self.manifest['summary']['open_question_count'], 2)
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
                self.assertTrue(all(ref.startswith('w6_6_1_6_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'sqlcontrol_wave6_6_add_workload_rule',
            'sqlcontrol_wave6_6_rule_types',
            'sqlcontrol_wave6_6_rule_priority',
            'sqlcontrol_wave6_6_common_params',
            'sqlcontrol_wave6_6_database_scope',
            'sqlcontrol_wave6_6_time_boundary',
            'sqlcontrol_wave6_6_option_val',
            'sqlcontrol_wave6_6_update_rule',
            'sqlcontrol_wave6_6_delete_rule',
            'sqlcontrol_wave6_6_add_abnormal_sql',
            'sqlcontrol_wave6_6_add_abnormal_sql_state',
            'sqlcontrol_wave6_6_clean_abnormal_sql',
            'sqlcontrol_wave6_6_abnormal_allowlist',
            'sqlcontrol_wave6_6_abnormal_cpu_limit',
            'sqlcontrol_wave6_6_workload_rule_stat',
            'sqlcontrol_wave6_6_refresh_cache',
            'sqlpatch_wave6_6_create_hint_patch',
            'sqlpatch_wave6_6_create_hint_permissions',
            'sqlpatch_wave6_6_parent_scope',
            'sqlpatch_wave6_6_create_abort_patch',
            'sqlpatch_wave6_6_drop_enable_disable',
            'sqlpatch_wave6_6_drop_enable_disable_permissions',
            'sqlpatch_wave6_6_show_patch',
            'sqlpatch_wave6_6_query_hash',
            'sqlpatch_wave6_6_query_hash_cursor_sharing',
            'sqlpatch_wave6_6_show_plan_by_hash',
            'sqlpatch_wave6_6_show_plan_boundary',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_two_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 2)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_sql_control_wave6_6.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
