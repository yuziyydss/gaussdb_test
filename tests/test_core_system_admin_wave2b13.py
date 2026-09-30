"""Wave 2B-13 files, caches, replay and GIN diagnostics are source-bound."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_admin_wave2b13_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_admin_wave2b13_v1/manifest.json'


class CoreSystemAdminWave2B13Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_fourth_other_functions_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_system_admin_wave2b13_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 777)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 789)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 12)
        self.assertIn('1.6.27.17 其它函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 25)
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
                self.assertEqual(fact['source_refs'], ['w2b13_1_6_27'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'wave2b13_catalog_attribute_records',
            'wave2b13_comm_proxy_thread_status',
            'wave2b13_pg_ls_tmpdir_default',
            'wave2b13_pg_ls_tmpdir_tablespace',
            'wave2b13_pg_ls_waldir',
            'wave2b13_stat_anti_cache',
            'wave2b13_stat_vlog_buffer',
            'wave2b13_stat_vlog_related_io',
            'wave2b13_stat_vlog_file',
            'wave2b13_pause_anti_cache_recycle',
            'wave2b13_write_term_log',
            'wave2b13_stat_space',
            'wave2b13_stat_space_interpretation',
            'wave2b13_index_dump_read',
            'wave2b13_index_dump_read_modes',
            'wave2b13_redo_upage',
            'wave2b13_redo_upage_params',
            'wave2b13_xlogdump_bylastlsn',
            'wave2b13_xlogdump_bylastlsn_params',
            'wave2b13_xlogdump_bylastlsn_error',
            'wave2b13_shared_storage_flush_stat',
            'wave2b13_shared_storage_flush_stat_outputs',
            'wave2b13_full_sql_by_parent_id',
            'wave2b13_gin_clean_pending_list',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.27')
        self.assertEqual(source['physical_page_start'], 777)
        self.assertEqual(source['physical_page_end'], 789)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_admin_wave2b13.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
