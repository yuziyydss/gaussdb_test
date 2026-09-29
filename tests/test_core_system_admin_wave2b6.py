"""Wave 2B-6 segment-page storage extraction is source-bound and complete."""
import json
import subprocess
import sys
import unittest
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_system_admin_wave2b6_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_system_admin_wave2b6_v1/manifest.json'


class CoreSystemAdminWave2B6Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_segment_page_storage_functions(self):
        self.assertEqual(self.manifest['kind'], 'core_system_admin_wave2b6_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 674)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 696)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 22)
        self.assertEqual(self.manifest['scope']['subsection'], '1.6.27.11 段页式存储函数')
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
                self.assertEqual(fact['source_refs'], ['w2b6_1_6_27'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'wave2b6_local_space_shrink',
            'wave2b6_gs_space_shrink',
            'wave2b6_dump_page_by_file',
            'wave2b6_dump_page_by_relid',
            'wave2b6_spc_location_overloads',
            'wave2b6_segment_layout',
            'wave2b6_datafile_layout',
            'wave2b6_slice_layout',
            'wave2b6_get_segment_overloads',
            'wave2b6_get_extents_overloads',
            'wave2b6_free_spc_remain_segment',
            'wave2b6_auto_free_remain_segment',
            'wave2b6_free_spc_remain_extent',
            'wave2b6_get_datafiles',
            'wave2b6_get_spc_extents',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.27')
        self.assertEqual(source['physical_page_start'], 674)
        self.assertEqual(source['physical_page_end'], 696)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_system_admin_wave2b6.py'), '--check'],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)


if __name__ == '__main__':
    unittest.main()
