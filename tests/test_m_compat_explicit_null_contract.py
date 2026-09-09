"""Explicit NULL is not DEFAULT, and requires actual ordinary column evidence."""
from pathlib import Path
import unittest
from unittest.mock import patch
from core.finite_sql_contract import inspect_write
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]

class ExplicitNullContractTests(unittest.TestCase):
    def test_insert_update_and_replace_use_declared_nullability(self):
        setup=['CREATE TABLE t(id INT,qty INT DEFAULT 9);']
        for sql in ('INSERT INTO t VALUES (1,NULL);','UPDATE t SET qty=NULL;',
                    'REPLACE INTO t VALUES (1,NULL);'):
            with self.subTest(sql=sql):
                result=inspect_write(sql,setup)
                self.assertEqual(result['status'],'checked',result)
                self.assertIn('shared_explicit_nullability',result['checks'])

    def test_not_null_rejects_explicit_null_even_with_nonnull_default(self):
        setup=['CREATE TABLE t(qty INT NOT NULL DEFAULT 9);']
        for sql in ('INSERT INTO t VALUES(NULL);','UPDATE t SET qty=NULL;'):
            with self.subTest(sql=sql):
                result=inspect_write(sql,setup)
                self.assertEqual(result['status'],'rejected',result)
                self.assertIn('null_not_allowed',[i['code'] for i in result['issues']])
        self.assertEqual(inspect_write('INSERT INTO t VALUES(DEFAULT);',setup)['status'],'checked')

    def test_explicit_null_never_invokes_or_substitutes_a_default(self):
        setup=['CREATE TABLE t(qty INT DEFAULT app.unresolved());']
        with patch('core.shared_column_contract.default_literal',side_effect=AssertionError('DEFAULT must not be evaluated')):
            result=inspect_write('INSERT INTO t VALUES(NULL);',setup)
        self.assertEqual(result['status'],'checked',result)
        self.assertNotIn('shared_constant_or_null_defaults',result['checks'])
        self.assertEqual(inspect_write('INSERT INTO t VALUES(DEFAULT);',setup)['status'],'needs_review')

    def test_no_universal_null_type_or_implicit_conversion_is_introduced(self):
        from core.finite_sql_contract import expression_type, ReviewNeeded
        with self.assertRaises(ReviewNeeded):
            expression_type('NULL',{})
        for token in ('NULL::INT',"'NULL'",'app.null_value()'):
            result=inspect_write(f'INSERT INTO t VALUES({token});',['CREATE TABLE t(qty INT);'])
            self.assertEqual(result['status'],'needs_review',result)
        literal=inspect_write("INSERT INTO t VALUES('NULL');",['CREATE TABLE t(qty TEXT NOT NULL);'])
        self.assertEqual(literal['status'],'checked')
        self.assertNotIn('shared_explicit_nullability',literal['checks'])

    def test_views_and_unknown_ddl_do_not_borrow_ordinary_nullability(self):
        for setup,target in (
            (['CREATE TABLE t(id INT);','CREATE VIEW v AS SELECT id FROM t;'],'v'),
            (['CREATE TABLE t(id custom_domain);'],'t'),
            (['CREATE TABLE t(id INT, PRIMARY KEY(id));'],'t'),
            (['CREATE TABLE t(id INT);','ALTER TABLE t ALTER COLUMN id SET NOT NULL;'],'t'),
            (['CREATE TABLE t(id INT);','SET search_path=other;'],'t'),
        ):
            with self.subTest(setup=setup):
                result=inspect_write(f'INSERT INTO {target} VALUES(NULL);',setup)
                self.assertEqual(result['status'],'needs_review',result)

    def test_generated_null_is_still_a_write_violation(self):
        setup=['CREATE TABLE t(id INT, g INT GENERATED ALWAYS AS(id+1) STORED);']
        for sql in ('INSERT INTO t VALUES(1,NULL);','UPDATE t SET g=NULL;'):
            result=inspect_write(sql,setup)
            self.assertEqual(result['status'],'rejected',result)
            self.assertIn('generated_column_write',[i['code'] for i in result['issues']])
        self.assertEqual(inspect_write('INSERT INTO t(id) VALUES(1);',setup)['status'],'needs_review')

    def test_tuple_and_multirow_nullability_stay_column_specific(self):
        setup=['CREATE TABLE t(id INT NOT NULL, qty INT);']
        good=inspect_write('UPDATE t SET (qty,id)=(NULL,1);',setup)
        self.assertEqual(good['status'],'checked',good)
        bad=inspect_write('INSERT INTO t VALUES(1,NULL),(NULL,2);',setup)
        self.assertEqual(bad['status'],'rejected',bad)
        self.assertIn('null_not_allowed',[i['code'] for i in bad['issues']])


class MCTASNullFixtureTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry=FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def test_actual_ctas_seed_and_contradictory_not_null_variant(self):
        g=FactorPackageSQLGenerator(self.registry)
        fixture=self.registry.fixtures['fixture_m_create_table_select_source']
        setup,_=g._compile_fixture_lifecycle([fixture.id])
        seed=next(s for s in setup if s.startswith('INSERT INTO m_ctas_source'))
        preceding=setup[:setup.index(seed)]
        result=inspect_write(seed,preceding)
        self.assertEqual(result['status'],'checked',result)
        altered=[s.replace('qty INT DEFAULT 9','qty INT NOT NULL DEFAULT 9') for s in preceding]
        result=inspect_write(seed,altered)
        self.assertEqual(result['status'],'rejected',result)
        self.assertIn('null_not_allowed',[i['code'] for i in result['issues']])

    def test_existing_planned_scene_records_the_two_distinct_source_rules(self):
        scenario=self.registry.scenarios['scenario_m_create_table_select_extra_column_order']
        self.assertIn('m_create_table_select_fact_nullability',scenario.fact_refs)
        self.assertIn('m_create_table_select_fact_default_on_omission',scenario.fact_refs)
        self.assertEqual(scenario.status,'planned')

    def test_formal_generation_rejects_bad_seed_even_for_a_negative_target(self):
        for suffix in ('direct_columns','column_storage'):
            g=FactorPackageSQLGenerator(self.registry)
            original=g._compile_fixture_lifecycle
            def changed(refs):
                setup,teardown=original(refs)
                return [s.replace('VALUES (1,10),(2,NULL)','VALUES (NULL,10)') for s in setup],teardown
            with self.subTest(suffix=suffix), patch.object(g,'_compile_fixture_lifecycle',side_effect=changed):
                with self.assertRaisesRegex(GenerationValidationError,'fixture_write_contradiction.*null_not_allowed'):
                    g.generate_with_report(self.registry.manifests['manifest_m_create_table_select_'+suffix])

    def test_unknown_seed_expression_cannot_be_called_verified(self):
        g=FactorPackageSQLGenerator(self.registry)
        original=g._compile_fixture_lifecycle
        def changed(refs):
            setup,teardown=original(refs)
            return [s.replace('(1,10)','(1,app.unknown_fn())') for s in setup],teardown
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'fixture_write_unknown'):
                g.generate_with_report(self.registry.manifests['manifest_m_create_table_select_direct_columns'])

    def test_ctas_explicitly_consumes_fixture_write_contract(self):
        factor=self.registry.factors['m_create_table_select']
        self.assertIn('fixture_write_contract',{c.kind for c in factor.structural_checks})

    def test_seed_cannot_borrow_a_future_create_statement(self):
        g=FactorPackageSQLGenerator(self.registry)
        original=g._compile_fixture_lifecycle
        def changed(refs):
            setup,teardown=original(refs)
            return list(reversed(setup)),teardown
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'fixture_write_unknown.*fixture_unknown'):
                g.generate_with_report(self.registry.manifests['manifest_m_create_table_select_direct_columns'])
