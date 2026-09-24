"""Body-only dependencies must accompany the pilot without inflating task count."""
import copy
import json
import unittest
from scripts.verify_cross_chapter_dependencies import DEFAULT_CONFIG, ROOT, load_inputs, source_input_closure, select_batch_tasks


@unittest.skipUnless((ROOT / 'gaussdb-rf-cent.pdf').is_file(), 'source PDF is not tracked in CI')
class DependencySourceClosureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from scripts.verify_cross_chapter_dependencies import ROOT
        cls.config = json.loads(DEFAULT_CONFIG.read_text())
        cls.registry, cls.inputs = load_inputs(cls.config, ROOT / 'specs')

    def test_all_declared_pdf_bodies_are_selected(self):
        body = source_input_closure(self.config, self.registry, self.inputs)
        primary = {v['chapter']['source_relpath'] for v in self.inputs.values()}
        self.assertEqual(len(primary), 21)
        self.assertEqual(set(body) - primary, {'general/utility/section_1_4_3.txt',
                                              'general/ddl/create_masking_policy.txt',
                                              'general/ddl/create_tablespace.txt',
                                              'general/ddl/drop_sequence.txt',
                                              'general/utility/section_1_9_4.txt',
                                              'general/utility/union_case.txt'})
        self.assertEqual(len(body), 27)

    def test_wrong_supplemental_hash_cannot_be_ignored(self):
        registry = copy.deepcopy(self.registry)
        ledger = registry.source_ledgers[registry.factors['create_schema'].source_ledger_ref]
        ledger.supplemental_sources[0].catalog_chapter_ref.chapter_sha256 = '0' * 64
        with self.assertRaisesRegex(ValueError, 'supplemental.*hash'):
            source_input_closure(self.config, registry, self.inputs)

    def test_body_only_chapters_are_not_promoted_to_factor_tasks(self):
        state = {'tasks': [{'factor_id': f, 'source_relpath': f + '.txt'}
                           for f in [*self.config['factors'], 'section_1_4_3', 'create_tablespace', 'drop_sequence',
                                     'section_1_9_4', 'union_case']]}
        excluded = select_batch_tasks(state, self.config['factors'])
        self.assertEqual(len(state['tasks']), 21)
        self.assertEqual({t['factor_id'] for t in excluded}, {'section_1_4_3', 'create_tablespace', 'drop_sequence',
                                                            'section_1_9_4', 'union_case'})

    def test_missing_requested_task_is_not_silently_filtered(self):
        with self.assertRaisesRegex(ValueError, 'requested tasks'):
            select_batch_tasks({'tasks': [{'factor_id': 'select'}]}, self.config['factors'])

    def test_supplemental_invalidation_expectations_are_independently_declared(self):
        actual = {}
        for fid in self.config['factors']:
            ledger = self.registry.source_ledgers[self.registry.factors[fid].source_ledger_ref]
            for source in ledger.supplemental_sources:
                actual.setdefault(source.catalog_chapter_ref.source_relpath, set()).add(fid)
        expected = {p: set(fids) for p, fids in self.config['supplemental_body_consumers'].items()}
        self.assertEqual(actual, expected)


if __name__ == '__main__':
    unittest.main()
