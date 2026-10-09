"""SQL Reference Wave 8-172 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_172_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_172_v1/manifest.json'

class CoreSQLReferenceWave8172Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_dbe_xmldom_tail_and_patch(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_172_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 2)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 19)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 2792)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 3046)
        self.assertEqual(self.manifest['scope']['sections'], ['3.12', '3.12'])
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
                self.assertTrue(all(ref.startswith('w8_172_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'dbelob_wave8_172_patch_2792',
            'dbexmldom_wave8_172_newdomdocument_protos',
            'dbexmldom_wave8_172_newdomdocument_limits',
            'dbexmldom_wave8_172_newdomdocument_examples',
            'dbexmldom_wave8_172_setattribute',
            'dbexmldom_wave8_172_setcharset',
            'dbexmldom_wave8_172_setcharset_charsets',
            'dbexmldom_wave8_172_setdoctype',
            'dbexmldom_wave8_172_setdoctype_limits',
            'dbexmldom_wave8_172_setnodevalue',
            'dbexmldom_wave8_172_writetobuffer',
            'dbexmldom_wave8_172_writetoclob',
            'dbexmldom_wave8_172_writetofile',
            'dbexmldom_wave8_172_writetofile_limits',
            'dbexmldom_wave8_172_writetofile_examples',
            'dbexmldom_wave8_172_getsessiontreenum',
            'dbexmldom_wave8_172_getdoctreesinfo',
            'dbexmldom_wave8_172_getdetaildoctreeinfo',
            'dbexmldom_wave8_172_getelementsbytagname',
            'dbexmldom_wave8_172_getelementsbytagname_examples',
        }
        self.assertEqual(expected, ids)

    def test_manifest_resolves_sources_and_page_slices(self):
        self.assertEqual(len(self.manifest['sources']), 2)
        for source in self.manifest['sources']:
            with self.subTest(source=source['section_number']):
                self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
                self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
                self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_172.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
