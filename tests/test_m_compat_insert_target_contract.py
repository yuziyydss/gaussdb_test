"""Target declaration identity is separate from assignment convertibility."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
ROOT = Path(__file__).resolve().parents[1]

class MInsertTargetContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def generator(self):
        r = copy.copy(self.registry)
        r.matrices = dict(r.matrices)
        key = 'matrix_m_insert_target_profile'
        r.matrices[key] = copy.deepcopy(r.matrices[key])
        return FactorPackageSQLGenerator(r)

    def profile(self, g, suffix='table'):
        return next(p for p in g.registry.matrices['matrix_m_insert_target_profile'].profiles
                    if p.id == 'm_insert_target_profile_'+suffix)

    def generate(self, g, suffix='table_query'):
        return g.generate_with_report(g.registry.manifests['manifest_m_insert_'+suffix])[0]

    def test_convertible_target_metadata_is_not_real_declaration(self):
        self.assertTrue(FactorPackageSQLGenerator._types_compatible('NUMERIC','INTEGER'))
        for suffix in ('table','table_set','table_query','upsert_conflict'):
            g = self.generator()
            p = self.profile(g,'upsert' if suffix=='upsert_conflict' else 'table')
            p.properties['target_types'] = p.properties['available_types'] = ['NUMERIC','NUMERIC']
            with self.subTest(manifest=suffix), self.assertRaisesRegex(GenerationValidationError,'target_type_mismatch'):
                self.generate(g,suffix)

    def test_even_implicit_target_types_cannot_drift_independently(self):
        g = self.generator()
        self.profile(g).properties['target_types'] = ['NUMERIC','NUMERIC']
        with self.assertRaisesRegex(GenerationValidationError,'target_type_mismatch'):
            self.generate(g)

    def test_declared_extra_available_column_is_rejected(self):
        g = self.generator()
        p = self.profile(g)
        p.properties.update(available_column_count=3,target_column_count=3,
                            available_types=['INTEGER']*3,target_types=['INTEGER']*3)
        with self.assertRaisesRegex(GenerationValidationError,'target_arity_mismatch'):
            self.generate(g)

    def test_changed_actual_fixture_types_are_not_hidden_by_provides(self):
        g = self.generator()
        compile_fixture = g._compile_fixture_lifecycle
        def changed(refs):
            setup, teardown = compile_fixture(refs)
            return [s.replace('qty INT DEFAULT 9','qty BIGINT DEFAULT 9') for s in setup], teardown
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'target_type_mismatch'):
                self.generate(g,'table')

    def test_different_existing_target_cannot_inherit_profile(self):
        g = self.generator()
        compile_fixture, render = g._compile_fixture_lifecycle, g._render_sql_with_consumption
        def setup(refs):
            stmts, teardown = compile_fixture(refs)
            return stmts+['CREATE TABLE other_target(id INT, qty INT);'], teardown
        def changed(*args):
            sql, consumed = render(*args)
            return sql.replace('INSERT INTO m_b01_source','INSERT INTO other_target'), consumed
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=setup), patch.object(g,'_render_sql_with_consumption',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'target_identity_mismatch'):
                self.generate(g)

    def test_only_ordinary_targets_select_this_contract(self):
        g = self.generator()
        for suffix in ('table','upsert','string_utf8'):
            self.assertEqual(self.profile(g,suffix).properties.get('target_column_contract'), 'fixture_ordinary_columns')
        self.assertNotEqual(self.profile(g,'view').properties.get('target_column_contract'),
                            'fixture_ordinary_columns')
        self.assertNotEqual(self.profile(g,'generated').properties.get('target_column_contract'),
                            'fixture_ordinary_columns')
        cases = [c for mid in g.registry.factors['m_insert'].manifest_refs
                 for c in g.generate_with_report(g.registry.manifests[mid])[0]]
        string_cases = [c for c in cases if c.case_id.startswith('manifest_m_insert_string_utf8_')]
        original_cases = [c for c in cases if c not in string_cases]
        self.assertEqual(len(original_cases),29)
        self.assertEqual(len(string_cases),9)
        self.assertTrue(all(c.params['target_profile'] == 'm_insert_target_profile_string_utf8'
                            for c in string_cases))

class InsertTargetEvidenceBoundaryTests(unittest.TestCase):
    def check(self, **changes):
        from core.shared_column_contract import check_rendered_insert_target
        args = dict(sql='INSERT INTO t VALUES(1)',setup=['CREATE TABLE t(id INT);'],
                    profile_target='t',available_types=['INTEGER'],available_count=1,
                    target_types=['INTEGER'],target_count=1,explicit_columns=False,
                    contract='fixture_ordinary_columns')
        args.update(changes)
        return check_rendered_insert_target(**args)

    def test_only_declaration_identity_is_proved(self):
        result = self.check(sql="INSERT t VALUES('not_an_integer')")
        self.assertEqual(result['column_order'],['id'])
        self.assertEqual(result['declaration_types'],['INT'])
        self.assertFalse(result['input_conversion_proven'])
        self.assertFalse(result['runtime_proven'])

    def test_explicit_lists_aliases_and_other_contracts_stay_unknown(self):
        from core.finite_sql_contract import ReviewNeeded
        for changes in ({'sql':'INSERT INTO t(id) VALUES(1)','explicit_columns':True},
                        {'sql':'INSERT INTO t AS x VALUES(1)'}, {'contract':'guess'}):
            with self.subTest(changes=changes), self.assertRaises(ReviewNeeded):
                self.check(**changes)

    def test_changed_lifecycle_view_and_generated_are_not_ordinary_proof(self):
        from core.finite_sql_contract import ReviewNeeded
        for setup in (['CREATE TABLE t(id INT);','DROP TABLE t;'],
                      ['CREATE TABLE t(id INT);','ALTER TABLE t ADD qty INT;'],
                      ['CREATE TABLE t(id INT);','SET search_path TO elsewhere;'],
                      ['CREATE TABLE src(id INT);','CREATE VIEW t AS SELECT id FROM src;'],
                      ['CREATE TABLE t(id INT GENERATED ALWAYS AS(1) STORED);']):
            with self.subTest(setup=setup), self.assertRaises(ReviewNeeded):
                self.check(setup=setup)

if __name__ == '__main__':
    unittest.main()
