"""Tools Wave 8-14 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_tools_wave8_14_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_tools_wave8_14_v1/manifest.json'

class CoreToolsWave814Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_import_export_tools(self):
        self.assertEqual(self.manifest['kind'], 'core_tools_wave8_14_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 55)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 3921)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 3976)
        self.assertEqual(self.manifest['scope']['sections'], ['5.7'])
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
                self.assertTrue(all(ref.startswith('w8_14_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_import_export_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'tools_wave8_14_overview',
            'tools_wave8_14_copy_scope',
            'tools_wave8_14_gs_loader_intro',
            'tools_wave8_14_gs_loader_mode',
            'tools_wave8_14_gs_loader_version',
            'tools_wave8_14_gs_loader_log_level',
            'tools_wave8_14_gs_loader_privilege_guc',
            'tools_wave8_14_gs_dump_intro',
            'tools_wave8_14_gs_dump_scope',
            'tools_wave8_14_gs_dump_formats',
            'tools_wave8_14_gs_dump_data_only',
            'tools_wave8_14_gs_dump_clean',
            'tools_wave8_14_gs_dump_create',
            'tools_wave8_14_gs_dump_parallel',
            'tools_wave8_14_gs_dumpall_intro',
            'tools_wave8_14_gs_dumpall_restore',
            'tools_wave8_14_gs_restore_intro',
            'tools_wave8_14_gs_restore_scope',
            'tools_wave8_14_gs_restore_jobs',
            'tools_wave8_14_gs_restore_parallel_format',
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
            [sys.executable, str(ROOT / 'scripts/build_core_tools_wave8_14.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
