"""Vector Database Wave 7-2 extraction is source-bound and traceable."""
import json, subprocess, sys, unittest
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]
FACTS_PATH = ROOT / 'docs/compat_facts/core_vector_wave7_2_v1.yaml'
MANIFEST_PATH = ROOT / 'generated/core_vector_wave7_2_v1/manifest.json'

class CoreVectorWave72Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.facts_payload = yaml.safe_load(FACTS_PATH.read_text(encoding='utf-8'))
        cls.manifest = json.loads(MANIFEST_PATH.read_text(encoding='utf-8'))
        cls.facts = cls.facts_payload['facts']

    def test_scope_covers_vector_database_functions(self):
        self.assertEqual(self.manifest['kind'], 'core_vector_wave7_2_extraction_manifest')
        self.assertEqual(self.manifest['scope']['chapter_count'], 1)
        self.assertEqual(self.manifest['scope']['physical_page_start'], 1006)
        self.assertEqual(self.manifest['scope']['physical_page_end_exclusive'], 1030)
        self.assertEqual(self.manifest['scope']['physical_page_count'], 24)
        self.assertIn('1.6.51 向量数据库函数与操作符', self.manifest['scope']['subsection'])
        self.assertEqual(self.manifest['summary']['fact_count'], len(self.facts))
        self.assertEqual(self.manifest['summary']['fact_count'], 30)
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
                self.assertEqual(fact['source_refs'], ['w7_2_1_6_51'])
                self.assertTrue(fact['source_anchor'])

    def test_expected_function_families_are_covered(self):
        ids = {item['id'] for item in self.facts}
        expected = {
            'vector_wave7_2_distance_functions',
            'vector_wave7_2_spherical_precondition',
            'vector_wave7_2_inner_product_functions',
            'vector_wave7_2_dims_norm',
            'vector_wave7_2_add_sub_functions',
            'vector_wave7_2_compare_functions',
            'vector_wave7_2_accumulate_functions',
            'vector_wave7_2_bool_functions',
            'vector_wave7_2_floatvector_cast',
            'vector_wave7_2_floatvector_io',
            'vector_wave7_2_type_constraints',
            'vector_wave7_2_boolvector_cast',
            'vector_wave7_2_boolvector_io',
            'vector_wave7_2_boolvector_constraints',
            'vector_wave7_2_index_inspect',
            'vector_wave7_2_operators',
            'vector_wave7_2_overflow_boundary',
            'bm25_wave7_2_similarity_operator',
            'bm25_wave7_2_dict_add_definition',
            'bm25_wave7_2_dict_add_boundary',
            'bm25_wave7_2_tokenize',
            'bm25_wave7_2_inspect',
            'bm25_wave7_2_distance_functions',
            'bm25_wave7_2_docid_info',
            'bm25_wave7_2_document_info',
            'bm25_wave7_2_index_hash_info',
            'bm25_wave7_2_token_info',
            'bm25_wave7_2_posting_info',
            'bm25_wave7_2_business_boundary',
        }
        self.assertTrue(expected.issubset(ids))

    def test_manifest_resolves_source_and_page_slice(self):
        self.assertEqual(len(self.manifest['sources']), 1)
        source = self.manifest['sources'][0]
        self.assertEqual(source['section_number'], '1.6.51')
        self.assertEqual(source['physical_page_start'], 1006)
        self.assertEqual(source['physical_page_end'], 1030)
        self.assertRegex(source['chapter_sha256'], r'[0-9a-f]{64}')
        self.assertEqual(source['chapter_sha256'], source['resolved_sha256'])
        self.assertGreater(source['page_line_count'], 0)

    def test_written_manifest_is_current(self):
        self.assertTrue(MANIFEST_PATH.is_file())
        result = subprocess.run(
            [sys.executable, str(ROOT / 'scripts/build_core_vector_wave7_2.py'), '--check'],
            cwd=ROOT, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(json.loads(MANIFEST_PATH.read_text(encoding='utf-8')), self.manifest)

if __name__ == '__main__':
    unittest.main()
