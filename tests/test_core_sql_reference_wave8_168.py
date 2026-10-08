"""SQL Reference Wave 8-168 extraction is source-bound."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_sql_reference_wave8_168_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_sql_reference_wave8_168_v1/manifest.json'

class CoreSQLReferenceWave8168Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_dbe_task(self):
        self.assertEqual(self.manifest['kind'], 'core_sql_reference_wave8_168_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 11)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 2971)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 2982)
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
                self.assertTrue(all(ref.startswith('w8_168_') for ref in fact['source_refs']))
                self.assertTrue(fact['source_anchor'])

    def test_expected_dbe_task_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'dbetask_wave8_168_overview',
            'dbetask_wave8_168_submit',
            'dbetask_wave8_168_submit_notes',
            'dbetask_wave8_168_submit_examples',
            'dbetask_wave8_168_job_submit',
            'dbetask_wave8_168_id_submit',
            'dbetask_wave8_168_cancel_run',
            'dbetask_wave8_168_finish',
            'dbetask_wave8_168_update',
            'dbetask_wave8_168_change',
            'dbetask_wave8_168_content',
            'dbetask_wave8_168_next_time_interval',
            'dbetask_wave8_168_running_lock',
            'dbetask_wave8_168_dml_constraint',
            'dbetask_wave8_168_node_failover',
            'dbetask_wave8_168_sync_overhead',
            'dbetask_wave8_168_concurrency_delay',
            'dbetask_wave8_168_call_forms',
            'dbetask_wave8_168_finish_next_time',
            'dbetask_wave8_168_what_types',
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
            [sys.executable, str(ROOT / 'scripts/build_core_sql_reference_wave8_168.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
