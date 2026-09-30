"""Wave 2B-15 GSTrace and final other-functions slice is source-bound."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_admin_wave2b15_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_admin_wave2b15_v1/manifest.json'


class CoreSystemAdminWave2B15Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_gstrace_and_final_functions(self):
        self.assertEqual(self.manifest['kind'], 'core_system_admin_wave2b15_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 795)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 805)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 10)
        self.assertIn('1.6.27.17 其它函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 21)
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
                self.assertEqual(fact['source_refs'], ['w2b15_1_6_27'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'wave2b15_gstrace_reg_sql',
            'wave2b15_gstrace_reg_sql_params',
            'wave2b15_gstrace_reg_func',
            'wave2b15_gstrace_reg_func_params',
            'wave2b15_gstrace_unreg_sql',
            'wave2b15_gstrace_unreg_func',
            'wave2b15_gstrace_unreg_all_sql',
            'wave2b15_gstrace_unreg_all_func',
            'wave2b15_gstrace_list_sql',
            'wave2b15_gstrace_list_func',
            'wave2b15_gstrace_show_traced_func',
            'wave2b15_gstrace_show_traced_func_semantics',
            'wave2b15_gstrace_show_mangled_func',
            'wave2b15_gstrace_show_subfunc',
            'wave2b15_gstrace_so_index_semantics',
            'wave2b15_last_demote_spent_time',
            'wave2b15_last_demote_spent_time_query_boundary',
            'wave2b15_last_demote_steps',
            'wave2b15_tcache_memory_flush',
            'wave2b15_tcache_memory_flush_boundaries',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.27')
        self.assertEqual(source['physical_page_start'], 795)
        self.assertEqual(source['physical_page_end'], 805)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_admin_wave2b15.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
