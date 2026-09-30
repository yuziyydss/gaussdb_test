"""Wave 2B-8 row-store compression and HTAP extraction is traceable."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_admin_wave2b8_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_admin_wave2b8_v1/manifest.json'


class CoreSystemAdminWave2B8Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_rowstore_compression_and_htap(self):
        self.assertEqual(self.manifest['kind'], 'core_system_admin_wave2b8_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 715)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 738)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 23)
        self.assertEqual(
            self.manifest['scope']['subsections'],
            ['1.6.27.14 行存压缩系统函数', '1.6.27.15 HTAP系统函数'],
        )
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 17)
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
                self.assertEqual(fact['source_refs'], ['w2b8_1_6_27'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'wave2b8_pg_get_ilmdef',
            'wave2b8_htap_imcv_info',
            'wave2b8_htap_common_precondition',
            'wave2b8_imcv_flush_overloads',
            'wave2b8_imcv_flush_constraints',
            'wave2b8_imcv_flush_rebuild_mode',
            'wave2b8_htap_tmu_data',
            'wave2b8_htap_tmu_chunk_meta',
            'wave2b8_imcv_bgworker_status',
            'wave2b8_htap_scan_hit_status',
            'wave2b8_imcu_meta',
            'wave2b8_imcu_meta_fields',
            'wave2b8_imcv_status',
            'wave2b8_htap_file_status',
            'wave2b8_htap_data_maintenance',
            'wave2b8_imcu_size_estimation',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.27')
        self.assertEqual(source['physical_page_start'], 715)
        self.assertEqual(source['physical_page_end'], 738)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_admin_wave2b8.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
