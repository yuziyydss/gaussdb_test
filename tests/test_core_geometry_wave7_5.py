"""Geometry Functions Wave 7-5 extraction is source-bound and traceable."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_geometry_wave7_5_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_geometry_wave7_5_v1/manifest.json'

class CoreGeometryWave75Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_geometry_functions_and_operators(self):
        self.assertEqual(self.manifest['kind'], 'core_geometry_wave7_5_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 381)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 392)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 11)
        self.assertIn('1.6.10 几何函数和操作符', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 15)
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
                self.assertEqual(fact['source_refs'], ['w7_5_1_6_10'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'geometry_wave7_5_transform_operators',
            'geometry_wave7_5_intersection_count',
            'geometry_wave7_5_length_center_distance',
            'geometry_wave7_5_overlap_position',
            'geometry_wave7_5_vertical_position',
            'geometry_wave7_5_intersection_adjacency',
            'geometry_wave7_5_contains_same',
            'geometry_wave7_5_measurement_functions',
            'geometry_wave7_5_box_conversions',
            'geometry_wave7_5_circle_conversions',
            'geometry_wave7_5_lseg_slope',
            'geometry_wave7_5_path_conversion',
            'geometry_wave7_5_point_conversions',
            'geometry_wave7_5_polygon_conversions',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.10')
        self.assertEqual(source['physical_page_start'], 381)
        self.assertEqual(source['physical_page_end'], 392)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_geometry_wave7_5.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
