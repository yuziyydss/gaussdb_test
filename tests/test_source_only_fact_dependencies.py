"""Explicit source-only imports preserve provenance without inventing runtime order."""
import copy
import unittest
from pathlib import Path
from unittest.mock import patch

from core.factor_package_model import FactorPackageRegistry, FactorPackageDef
from scripts.manage_extraction_queue import refresh_task_dependencies, dependency_verification_snapshot

ROOT = Path(__file__).resolve().parents[1]
REF = 'create_table_subpartition::create_table_subpartition_fact_body_12'


class SourceOnlyFactDependencyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.base = FactorPackageRegistry(ROOT/'specs'); cls.base.load_all()

    def registry(self, declared=True):
        r = copy.deepcopy(self.base)
        profile = next(p for p in r.matrices['matrix_create_index_table_profiles'].profiles if p.id == 'ci_table_subpartitioned')
        if REF not in profile.fact_refs:
            profile.fact_refs.append(REF)
        r.factors['create_index'].source_only_fact_refs = []
        if declared:
            raw = r.factors['create_index'].model_dump()
            raw['source_only_fact_refs'] = list(self.base.factors['create_index'].source_only_fact_refs)
            r.factors['create_index'] = FactorPackageDef(**raw)
        return r

    def test_unannotated_mixed_cycle_still_fails(self):
        r = self.registry(False)
        with self.assertRaisesRegex(ValueError, '因子依赖存在环'):
            r.factor_topological_order()

    def test_annotated_import_preserves_provenance_but_not_package_wait(self):
        r = self.registry()
        errors = []; r._validate_references(errors)
        self.assertEqual(errors, [])
        self.assertIn('create_table_subpartition', r.factor_dependency_graph()['create_index'])
        self.assertNotIn('create_table_subpartition', r.factor_scheduling_graph()['create_index'])
        self.assertEqual(len(r.factor_topological_order()), 317)
        self.assertEqual(r.fixture_topological_order(['fixture_create_table_subpartition_range_range_source']),
                         ['fixture_create_schema_pair', 'fixture_create_table_subpartition_range_range_source'])

    def test_source_only_cannot_erase_real_fixture_dependency(self):
        r = self.registry()
        r.factors['create_index'].fixture_refs.append('fixture_create_table_subpartition_range_range_source')
        self.assertIn('create_table_subpartition', r.factor_scheduling_graph()['create_index'])
        with self.assertRaisesRegex(ValueError, '因子依赖存在环'):
            r.factor_topological_order()

    def test_invalid_unconsumed_or_unmapped_import_is_rejected(self):
        for mutation in ('unknown', 'unconsumed', 'duplicate', 'unconfirmed', 'unmapped'):
            with self.subTest(mutation=mutation):
                r = self.registry()
                f = r.factors['create_index']
                if mutation == 'unknown':
                    f.source_only_fact_refs = ['missing::missing']
                elif mutation == 'unconsumed':
                    f.source_only_fact_refs = ['create_table::ct_fact_not_null']
                elif mutation == 'duplicate':
                    f.source_only_fact_refs = [REF, REF]
                elif mutation == 'unconfirmed':
                    next(x for x in r.factors['create_table_subpartition'].facts if x.id == REF.split('::')[1]).status = 'needs_verification'
                else:
                    ledger = r.source_ledgers[r.factors['create_table_subpartition'].source_ledger_ref]
                    for unit in ledger.units:
                        if REF.split('::')[1] in unit.fact_refs:
                            unit.status = 'open_question'
                errors = []; r._validate_references(errors)
                self.assertTrue(any('source_only_fact_refs' in error for error in errors), errors[:2])

    def test_another_package_phase_fact_keeps_provider_dependency(self):
        r = self.registry()
        # Independent reference to same provider remains package-phase unless explicitly reviewed.
        r.factors['create_index'].source_only_fact_refs.remove('create_table_subpartition::create_table_subpartition_fact_body_12_1')
        profile = next(p for p in r.matrices['matrix_create_index_table_profiles'].profiles if p.id == 'ci_table_subpartitioned')
        profile.fact_refs.append('create_table_subpartition::create_table_subpartition_fact_body_12_1')
        self.assertIn('create_table_subpartition', r.factor_scheduling_graph()['create_index'])

    def state(self, r):
        return {'specs_root': str(ROOT/'specs'),
                'corpus_root': str(ROOT/'work/doc2spec/full_general_corpus'),
                'source_catalog_path': str(ROOT/'work/doc2spec/full_general_corpus/catalog.json'),
                'tasks': [{'factor_id': f, 'output_dir': str(r.source_paths[f].parent),
                           'source_relpath': r.factors[f].source.catalog_chapter_ref.source_relpath,
                           'source_sha256': r.factors[f].source.artifact_sha256}
                          for f in ('create_index','create_schema','create_table_subpartition')]}

    def test_queue_orders_packages_but_snapshots_all_provenance(self):
        r = self.registry(); state = self.state(r)
        # Supplemental catalogs have separate disk/hash regressions. Isolate
        # package/source invalidation here; do not claim full source closure.
        with patch('scripts.manage_extraction_queue.FactorPackageRegistry', return_value=r), patch.object(r, 'load_all'), \
                patch('scripts.manage_extraction_queue.supplemental_verification_snapshot', return_value={}):
            self.assertTrue(refresh_task_dependencies(state, strict=True))
            task = next(t for t in state['tasks'] if t['factor_id'] == 'create_index')
            self.assertNotIn('create_table_subpartition', task['depends_on_factor_refs'])
            self.assertEqual(task['source_only_fact_refs'], sorted(self.base.factors['create_index'].source_only_fact_refs))
            before = dependency_verification_snapshot(state, task)
            self.assertIn('create_table_subpartition', before)
            self.assertNotIn('create_index', before)
            from scripts.manage_extraction_queue import factor_package_sha256
            def changed(path):
                return 'a'*64 if path.name == 'create_table_subpartition' else factor_package_sha256(path)
            with patch('scripts.manage_extraction_queue.factor_package_sha256', side_effect=changed):
                after = dependency_verification_snapshot(state, task)
            self.assertNotEqual(before['create_table_subpartition'], after['create_table_subpartition'])

    def test_source_phase_does_not_fallback_when_registry_is_invalid(self):
        from scripts.manage_extraction_queue import QueueError
        r = self.registry(); state = self.state(r)
        task = state['tasks'][0]; task['source_only_fact_refs'] = [REF]
        with patch('scripts.manage_extraction_queue.FactorPackageRegistry', side_effect=ValueError('bad source')):
            with self.assertRaisesRegex(QueueError, 'valid current registry'):
                dependency_verification_snapshot(state, task)


if __name__ == '__main__':
    unittest.main()
