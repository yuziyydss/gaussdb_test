"""Actual INSERT SELECT output types cannot be invented by matching profiles."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]

class MInsertQueryContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def generator(self):
        registry = copy.copy(self.registry)
        registry.matrices = dict(registry.matrices)
        for key in ('matrix_m_insert_source_profile','matrix_m_insert_target_profile'):
            registry.matrices[key] = copy.deepcopy(registry.matrices[key])
        return FactorPackageSQLGenerator(registry)

    def profile(self, generator, dimension, suffix):
        return next(p for p in generator.registry.matrices['matrix_m_insert_'+dimension].profiles
                    if p.id == 'm_insert_'+dimension+'_'+suffix)

    def generate(self, generator, suffix='table_query'):
        return generator.generate_with_report(generator.registry.manifests['manifest_m_insert_'+suffix])[0]

    def test_self_consistent_text_metadata_cannot_override_actual_int_query(self):
        g = self.generator()
        self.profile(g,'source_profile','query').properties['output_types'] = ['TEXT','TEXT']
        target = self.profile(g,'target_profile','table')
        target.properties['target_types'] = target.properties['available_types'] = ['TEXT','TEXT']
        # Both profiles lie: target declaration validation now rejects first.
        with self.assertRaisesRegex(GenerationValidationError,'target_type_mismatch'):
            self.generate(g)

    def test_source_only_convertible_type_drift_still_reaches_source_guard(self):
        g = self.generator()
        self.profile(g,'source_profile','query').properties['output_types'] = ['NUMERIC','NUMERIC']
        # Target declarations are unchanged INTEGER; broad input compatibility
        # must not make the SELECT's actual INTEGER output become NUMERIC.
        with self.assertRaisesRegex(GenerationValidationError,'projection_type_mismatch'):
            self.generate(g)

    def test_rendered_projection_drift_is_rejected(self):
        g = self.generator()
        render = g._render_sql_with_consumption
        def changed(*args):
            sql, consumed = render(*args)
            return sql.replace('SELECT id,qty', 'SELECT qty,id'), consumed
        with patch.object(g,'_render_sql_with_consumption',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'query_projection_mismatch'):
                self.generate(g)

    def test_unresolved_source_cannot_borrow_profile_identity(self):
        g = self.generator()
        self.profile(g,'source_profile','query').render = 'SELECT id,qty FROM missing_source WHERE id = 1'
        with self.assertRaisesRegex(GenerationValidationError,'query_source_unknown'):
            self.generate(g)

    def test_aggregate_cannot_claim_direct_column_contract(self):
        g = self.generator()
        self.profile(g,'source_profile','query').render = 'SELECT id,SUM(qty) FROM m_b01_source WHERE id = 1'
        with self.assertRaisesRegex(GenerationValidationError,'query_projection_unknown'):
            self.generate(g)

    def test_formal_query_consumer_preserves_table_view_and_generated_cases(self):
        g = self.generator()
        profile = self.profile(g,'source_profile','query')
        self.assertEqual(profile.properties.get('query_output_contract'), 'fixture_direct_columns')
        self.assertEqual([len(self.generate(g,s)) for s in
                         ('table_query','view_query','generated_omitted_query')], [2,2,1])

class InsertQueryEvidenceBoundaryTests(unittest.TestCase):
    def check(self, **changes):
        from core.query_output_contract import check_rendered_insert_query
        args = dict(sql='INSERT INTO dest SELECT id AS x FROM src WHERE id = 1',
            setup=['CREATE TABLE src (id INT);'],
            profile_query='SELECT id AS x FROM src WHERE id = 1',
            output_types=['INTEGER'], source_tables=['src'], source_columns=['id'],
            contract='fixture_direct_columns')
        args.update(changes)
        return check_rendered_insert_query(**args)

    def test_evidence_does_not_prove_predicate_target_or_runtime(self):
        # Deliberately no dest in setup: this function proves query output only.
        result = self.check()
        self.assertEqual(result['checked_output_positions'], [0])
        self.assertEqual(result['unverified_predicate'], 'WHERE id = 1')
        self.assertFalse(result['target_acceptance_proven'])
        self.assertFalse(result['runtime_proven'])

    def test_wrong_metadata_width_and_dependency_identity_are_rejected(self):
        from core.finite_sql_contract import Contradiction
        for changes, code in (({'output_types':[]},'query_output_arity'),
                              ({'source_columns':['missing']},'query_source_columns_mismatch'),
                              ({'source_tables':['other']},'query_source_identity_mismatch')):
            with self.subTest(changes=changes), self.assertRaisesRegex(Contradiction, code):
                self.check(**changes)

    def test_unknown_contract_or_invalidated_source_cannot_claim_proof(self):
        from core.finite_sql_contract import ReviewNeeded
        for changes in ({'contract':'guess'},
                        {'setup':['CREATE TABLE src (id INT);','ALTER TABLE src ADD other INT;']},
                        {'setup':['CREATE TABLE src (id INT);','SET search_path TO other;']}):
            with self.subTest(changes=changes), self.assertRaises(ReviewNeeded):
                self.check(**changes)

if __name__ == '__main__':
    unittest.main()
