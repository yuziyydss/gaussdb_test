"""Multi-tenant Database Wave 7-3 extraction is source-bound and traceable."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_multitenant_wave7_3_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_multitenant_wave7_3_v1/manifest.json'

class CoreMultitenantWave73Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_multitenant_functions(self):
        self.assertEqual(self.manifest['kind'], 'core_multitenant_wave7_3_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1029)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1040)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 11)
        self.assertIn('1.6.52 多租数据库函数', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 19)
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
                self.assertEqual(fact['source_refs'], ['w7_3_1_6_52'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'mtd_wave7_3_reload_pdb_conf',
            'mtd_wave7_3_resplan_cgroup_info',
            'mtd_wave7_3_resplan_cgroup_visibility',
            'mtd_wave7_3_resplan_stat_info',
            'mtd_wave7_3_resplan_stat_fields',
            'mtd_wave7_3_resplan_stat_visibility',
            'mtd_wave7_3_resplan_shared_cache_boundary',
            'mtd_wave7_3_pdb_tablespace_location',
            'mtd_wave7_3_pdb_tablespace_boundary',
            'mtd_wave7_3_get_mtd_user',
            'mtd_wave7_3_get_mtd_user_visibility',
            'mtd_wave7_3_get_mtd_user_fields',
            'mtd_wave7_3_instr_sql_count',
            'mtd_wave7_3_instr_sql_count_visibility',
            'mtd_wave7_3_db_rt_percentile',
            'mtd_wave7_3_user_login_info',
            'mtd_wave7_3_shared_memory_info',
            'mtd_wave7_3_shared_memory_fields',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.52')
        self.assertEqual(source['physical_page_start'], 1029)
        self.assertEqual(source['physical_page_end'], 1040)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_multitenant_wave7_3.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
