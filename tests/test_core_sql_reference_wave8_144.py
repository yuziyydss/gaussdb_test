"""SQL Reference Wave 8-144 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_144_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_144_v1/manifest.json'

class CoreSQLReferenceWave8144Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_pkg_util_io_raw_random_file_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_144_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 13)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 2669)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 2682)
        self.assertEqual(self.manifest['scope']['sections'], ['3.12'])
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
                self.assertTrue(all(ref.startswith('w8_144_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_io_raw_random_file_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'pkgutil_wave8_144_io_print',
            'pkgutil_wave8_144_raw_get_length',
            'pkgutil_wave8_144_raw_cast_from_varchar2',
            'pkgutil_wave8_144_raw_cast_from_bi',
            'pkgutil_wave8_144_raw_cast_to_bi',
            'pkgutil_wave8_144_random_funcs',
            'pkgutil_wave8_144_file_set_dirname',
            'pkgutil_wave8_144_file_open',
            'pkgutil_wave8_144_file_set_max_line_size',
            'pkgutil_wave8_144_file_is_close',
            'pkgutil_wave8_144_file_read',
            'pkgutil_wave8_144_file_readline',
            'pkgutil_wave8_144_file_write',
            'pkgutil_wave8_144_file_newline_writeline',
            'pkgutil_wave8_144_file_raw_io',
            'pkgutil_wave8_144_file_flush_close',
            'pkgutil_wave8_144_file_remove_rename',
            'pkgutil_wave8_144_file_size_block_exists',
            'pkgutil_wave8_144_file_getpos_seek_closeall',
            'pkgutil_wave8_144_safety_constraints',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_144.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
