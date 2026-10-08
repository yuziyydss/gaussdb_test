"""SQL Reference Wave 8-143 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_143_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_143_v1/manifest.json'

class CoreSQLReferenceWave8143Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_pkg_util_lob_slice(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_143_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 18)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 2651)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 2669)
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
                self.assertTrue(all(ref.startswith('w8_143_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_pkg_util_lob_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'pkgutil_wave8_143_interface_catalog',
            'pkgutil_wave8_143_lob_get_length',
            'pkgutil_wave8_143_lob_read',
            'pkgutil_wave8_143_lob_write_append',
            'pkgutil_wave8_143_lob_compare_match',
            'pkgutil_wave8_143_lob_reset',
            'pkgutil_wave8_143_lob_read_huge',
            'pkgutil_wave8_143_lob_writeappend_huge',
            'pkgutil_wave8_143_lob_append_huge',
            'pkgutil_wave8_143_read_bfile_to_blob',
            'pkgutil_wave8_143_lob_copy_huge',
            'pkgutil_wave8_143_blob_clob_reset',
            'pkgutil_wave8_143_loadblobfromfile',
            'pkgutil_wave8_143_loadclobfromfile',
            'pkgutil_wave8_143_lob_convert_huge',
            'pkgutil_wave8_143_bfile_ops',
            'pkgutil_wave8_143_lob_write_huge',
            'pkgutil_wave8_143_amount_units',
            'pkgutil_wave8_143_plain_vs_huge',
            'pkgutil_wave8_143_bfile_lifecycle',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_143.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
