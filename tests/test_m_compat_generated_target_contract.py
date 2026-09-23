"""Generated target declarations are not ordinary columns or coarse families."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from core.finite_sql_contract import inspect_write
ROOT = Path(__file__).resolve().parents[1]
SUFFIXES = ('generated','generated_omitted_values','generated_omitted_query')

class MGeneratedTargetContractTests(unittest.TestCase):
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

    def profile(self,g):
        return next(p for p in g.registry.matrices['matrix_m_insert_target_profile'].profiles
                    if p.id=='m_insert_target_profile_generated')

    def generate(self,g,suffix='generated'):
        return g.generate_with_report(g.registry.manifests['manifest_m_insert_'+suffix])[0]

    def setup_patch(self,g,transform):
        original = g._compile_fixture_lifecycle
        def changed(refs):
            setup, teardown = original(refs)
            return transform(setup), teardown
        return patch.object(g,'_compile_fixture_lifecycle',side_effect=changed)

    def test_numeric_family_cannot_erase_actual_generated_target_types(self):
        for suffix in SUFFIXES:
            g = self.generator()
            p = self.profile(g)
            p.properties['target_types'] = p.properties['available_types'] = ['NUMERIC']*3
            with self.subTest(suffix=suffix), self.assertRaisesRegex(GenerationValidationError,'target_type_mismatch'):
                self.generate(g,suffix)

    def test_actual_generated_or_plain_column_type_change_is_detected(self):
        for before,after in (('g INT GENERATED','g BIGINT GENERATED'),('qty INT,','qty BIGINT,')):
            g = self.generator()
            with self.subTest(before=before), self.setup_patch(g,lambda setup:[s.replace(before,after) for s in setup]):
                with self.assertRaisesRegex(GenerationValidationError,'target_type_mismatch'):
                    self.generate(g)

    def test_plain_table_cannot_impersonate_generated_target(self):
        g = self.generator()
        with self.setup_patch(g,lambda setup:[s.replace('g INT GENERATED ALWAYS AS (id + qty) STORED','g INT') for s in setup]):
            with self.assertRaisesRegex(GenerationValidationError,'target_kind_mismatch'):
                self.generate(g)

    def test_generated_flag_cannot_be_disabled_under_generated_contract(self):
        g = self.generator()
        self.profile(g).properties['generated'] = False
        with self.assertRaisesRegex(GenerationValidationError,'target_kind_mismatch'):
            self.generate(g)

    def test_target_lifecycle_invalidation_remains_strict(self):
        for tail in ('DROP TABLE m_b01_generated;', 'ALTER TABLE m_b01_generated ALTER COLUMN g TYPE BIGINT;'):
            g = self.generator()
            with self.subTest(tail=tail), self.setup_patch(g,lambda setup:setup+[tail]):
                with self.assertRaisesRegex(GenerationValidationError,'target_.*unknown'):
                    self.generate(g)

    def test_specific_generated_column_identity_cannot_move(self):
        g = self.generator()
        self.profile(g).properties['generated_columns'] = ['id']
        with self.assertRaisesRegex(GenerationValidationError,'target_generated_columns_mismatch'):
            self.generate(g)
        g = self.generator()
        replacement = 'CREATE TABLE m_b01_generated(id INT GENERATED ALWAYS AS(1) STORED,qty INT,g INT);'
        with self.setup_patch(g,lambda setup:[replacement if s.startswith('CREATE TABLE m_b01_generated') else s for s in setup]):
            with self.assertRaisesRegex(GenerationValidationError,'target_generated_columns_mismatch'):
                self.generate(g)

    def test_five_existing_candidates_keep_error_and_finite_not_runtime_boundaries(self):
        g = self.generator()
        p = self.profile(g)
        self.assertEqual(p.properties.get('target_column_contract'),'fixture_generated_columns')
        self.assertIn('m_insert_fact_generated_write',p.fact_refs)
        cases = [c for suffix in SUFFIXES for c in self.generate(g,suffix)]
        self.assertEqual(len(cases),3)
        self.assertTrue(all(c.expected=='success' for c in cases))
        for case in cases:
            if case.expected=='error':
                self.assertEqual(case.expected_error_category,'generated_write')
                self.assertFalse(case.expected_sqlstates)
            else:
                result=inspect_write(case.sql,case.setup_sqls,conflict_source_scope='m_compat')
                self.assertEqual(result['status'],'checked',result)
                self.assertIn('stored_generated_integer_sum',result['checks'])
                self.assertEqual(case.expected_scope,'syntax_only')

class GeneratedTargetEvidenceBoundaryTests(unittest.TestCase):
    def check(self, ddl):
        from core.shared_column_contract import check_rendered_insert_target
        return check_rendered_insert_target('INSERT INTO t VALUES(1,DEFAULT)',[ddl],
            profile_target='t',available_types=['INTEGER']*2,available_count=2,
            target_types=['INTEGER']*2,target_count=2,explicit_columns=False,
            contract='fixture_generated_columns',generated=True,generated_columns=['g'])

    def test_unknown_expression_and_storage_default_are_not_semantics_proof(self):
        for suffix in ('',' STORED',' VIRTUAL'):
            ddl = 'CREATE TABLE t(id INT,g INT AS (app.unknown_fn(id))'+suffix+');'
            with self.subTest(suffix=suffix):
                result = self.check(ddl)
                self.assertEqual(result['generated_columns'],['g'])
                self.assertFalse(result['generation_semantics_proven'])
                self.assertFalse(result['input_conversion_proven'])
                self.assertFalse(result['runtime_proven'])
                self.assertEqual(inspect_write('INSERT INTO t VALUES(1,DEFAULT)',[ddl])['status'],'needs_review')

    def test_positive_identity_does_not_create_ordinary_default_or_null_proof(self):
        from core.finite_sql_contract import ddl_tables
        from core.shared_column_contract import ordinary_columns, finite_generated_target_columns
        ddl = 'CREATE TABLE t(id INT,g INT AS(id+1) STORED);'
        self.assertIsNone(ordinary_columns(ddl))
        table = ddl_tables([ddl])['t']
        columns = finite_generated_target_columns(table)
        self.assertEqual(columns['g'], {'type':'INT','origin':('t','g'),'generated':True})
        self.assertNotIn('_column_contract',table)
        self.assertNotIn('nullable',columns['g'])
        self.assertNotIn('default_state',columns['g'])

    def test_unproved_type_clauses_and_suffixes_stay_unknown(self):
        from core.finite_sql_contract import ReviewNeeded
        for ddl in ('CREATE TABLE t(id INT DEFAULT 7,g INT AS(id+1) STORED);',
                    'CREATE TABLE t(id INT,g NUMERIC(10,2) AS(id+1) STORED);',
                    'CREATE TABLE t(id INT,g INT AS(id+1) STORED) WITH(fillfactor=70);',
                    'CREATE TABLE t(id INT,g INT AS(id+1) STORED nonsense);'):
            with self.subTest(ddl=ddl), self.assertRaises(ReviewNeeded):
                self.check(ddl)

if __name__ == '__main__':
    unittest.main()
