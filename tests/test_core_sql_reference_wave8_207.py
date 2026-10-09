"""SQL Reference Wave 8-191 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_207_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_207_v1/manifest.json'

class CoreSQLReferenceWave8207Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_guc_adio_import_wal(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_207_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 35)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 4237)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 4272)
        self.assertEqual(self.manifest['scope']['sections'], ['7.3'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 19)
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
                self.assertTrue(all(ref.startswith('w8_207_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_mcompat_topics_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'guc_wave8_207_adio_prefetch',
            'guc_wave8_207_archive_interval',
            'guc_wave8_207_copy_batch_index_lobs',
            'guc_wave8_207_copy_encoding',
            'guc_wave8_207_copy_filler_constraints',
            'guc_wave8_207_copy_import',
            'guc_wave8_207_dcf_redo_bind_crc',
            'guc_wave8_207_incremental_checkpoint',
            'guc_wave8_207_ondemand_rto',
            'guc_wave8_207_recovery_check_delay',
            'guc_wave8_207_recovery_extreme_rto',
            'guc_wave8_207_recovery_flow_control',
            'guc_wave8_207_sync_commit_full_page',
            'guc_wave8_207_wal_buffers_writer',
            'guc_wave8_207_wal_file_init_shared_storage',
            'guc_wave8_207_wal_flush_checkpoint',
            'guc_wave8_207_wal_internal_bind',
            'guc_wave8_207_wal_level_fsync',
            'guc_wave8_207_xlog_prune',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_207.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
