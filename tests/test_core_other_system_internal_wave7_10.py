"""Other System internal Wave 7-10 extraction is source-bound and traceable."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_other_system_internal_wave7_10_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_other_system_internal_wave7_10_v1/manifest.json'

class CoreOtherSystemInternalWave710Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_internal_functions(self):
        self.assertEqual(self.manifest['kind'], 'core_other_system_internal_wave7_10_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1076)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1115)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 39)
        self.assertIn('1.6.60 其他系统函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 38)
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
                self.assertEqual(fact['source_refs'], ['w7_10_1_6_60'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'internal_wave7_10_scope',
            'internal_wave7_10_workload_lock_smgr',
            'internal_wave7_10_xid_io_functions',
            'internal_wave7_10_sql_job_fdw_functions',
            'internal_wave7_10_enum_functions',
            'internal_wave7_10_node_buffer_functions',
            'internal_wave7_10_threadpool_stream_info',
            'internal_wave7_10_listen_validation',
            'internal_wave7_10_libcomm_fd_memory',
            'internal_wave7_10_global_listen_info',
            'internal_wave7_10_comm_status_functions',
            'internal_wave7_10_clog_pooler_bkp',
            'internal_wave7_10_psort_xid_functions',
            'internal_wave7_10_cross_region_dblink_state',
            'internal_wave7_10_copy_summary_create',
            'internal_wave7_10_btree_cross_type_compare',
            'internal_wave7_10_timestamp_io',
            'internal_wave7_10_datea_compare',
            'internal_wave7_10_datea_add',
            'internal_wave7_10_datea_subtract',
            'internal_wave7_10_datea_larger_smaller',
            'internal_wave7_10_datea_io',
            'internal_wave7_10_rowid_compare',
            'internal_wave7_10_rowid_io',
            'internal_wave7_10_updatable_dep_partition',
            'internal_wave7_10_online_ddl_cleanup',
            'internal_wave7_10_nesttable_io',
            'internal_wave7_10_nesttable_delete_count',
            'internal_wave7_10_nesttable_compare',
            'internal_wave7_10_nesttable_exists_extend',
            'internal_wave7_10_nesttable_navigation',
            'internal_wave7_10_indexbytable_io_count',
            'internal_wave7_10_indexbytableint_delete',
            'internal_wave7_10_indexbytableint_navigation',
            'internal_wave7_10_indexbytablevarchar_delete',
            'internal_wave7_10_indexbytablevarchar_navigation',
            'internal_wave7_10_temp_filenode_backslash',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.60')
        self.assertEqual(source['physical_page_start'], 1076)
        self.assertEqual(source['physical_page_end'], 1115)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_other_system_internal_wave7_10.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
