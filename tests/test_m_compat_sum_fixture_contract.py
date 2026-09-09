"""A conditional function profile still needs a real source-column contract."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]


class MSumFixtureContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def generator(self):
        registry = copy.copy(self.registry)
        registry.factors = dict(registry.factors)
        registry.factors['m_select'] = copy.deepcopy(registry.factors['m_select'])
        return FactorPackageSQLGenerator(registry)

    def value(self, generator, dim, suffix):
        return next(v for group in generator.registry.factors['m_select'].dimensions[dim].classes
                    for v in group.values if v.id == 'm_select_'+dim+'_'+suffix)

    def generate(self, generator):
        return generator.generate_with_report(generator.registry.manifests['manifest_m_select_sum_builtin'])

    def test_float_profile_cannot_override_real_integer_fixture(self):
        generator = self.generator()
        self.value(generator, 'source_form', 'table').properties['available_types'] = ['INTEGER','FLOAT']
        self.value(generator, 'target_list', 'sum_qty').properties['output_types'] = ['DOUBLE']
        with self.assertRaisesRegex(GenerationValidationError, 'source_type_mismatch'):
            self.generate(generator)

    def test_actual_fixture_change_is_not_hidden_by_unchanged_provides(self):
        generator = self.generator()
        compile_fixture = generator._compile_fixture_lifecycle
        def changed(refs):
            setup, teardown = compile_fixture(refs)
            return [s.replace('qty INT DEFAULT 9', 'qty BIGINT DEFAULT 9') for s in setup], teardown
        with patch.object(generator, '_compile_fixture_lifecycle', side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError, 'source_type_mismatch'):
                self.generate(generator)

    def test_drop_or_alter_after_create_invalidates_source_evidence(self):
        for tail in ('DROP TABLE m_b01_source;', 'ALTER TABLE m_b01_source ALTER COLUMN qty TYPE BIGINT;'):
            generator = self.generator()
            compile_fixture = generator._compile_fixture_lifecycle
            def changed(refs):
                setup, teardown = compile_fixture(refs)
                return setup+[tail], teardown
            with self.subTest(tail=tail), patch.object(generator, '_compile_fixture_lifecycle', side_effect=changed):
                with self.assertRaisesRegex(GenerationValidationError, 'source_.*unknown'):
                    self.generate(generator)

    def test_rendered_query_cannot_switch_to_an_unproven_source(self):
        generator = self.generator()
        render = generator._render_sql_with_consumption
        def changed(*args):
            sql, consumed = render(*args)
            return sql.replace('FROM m_b01_source', 'FROM missing_source'), consumed
        with patch.object(generator, '_render_sql_with_consumption', side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError, 'source_.*unknown'):
                self.generate(generator)

    def test_real_fixture_still_generates_two_gated_candidates(self):
        cases, report = self.generate(self.generator())
        self.assertEqual(len(cases), 2)
        self.assertTrue(report.pairwise_complete)
        self.assertTrue(all('function_resolution' in {r['key'] for r in c.environment_requirements} for c in cases))

    def test_changed_rendered_projection_cannot_inherit_profile_proof(self):
        generator = self.generator()
        render = generator._render_sql_with_consumption
        def changed(*args):
            sql, consumed = render(*args)
            return sql.replace('SUM(qty)', 'SUM(id)'), consumed
        with patch.object(generator, '_render_sql_with_consumption', side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError, 'query_projection_mismatch'):
                self.generate(generator)


class FiniteSourceBoundaryTests(unittest.TestCase):
    def test_unproven_source_forms_and_session_changes_stay_unknown(self):
        from core.query_output_contract import finite_query_source_columns
        from core.finite_sql_contract import ReviewNeeded
        setup = ['CREATE TABLE t (id INT);']
        for query, extra in (
            ('SELECT SUM(id) FROM t WHERE id > 0', []),
            ('SELECT SUM(id) FROM (SELECT id FROM t) q', []),
            ('WITH q AS (SELECT id FROM t) SELECT SUM(id) FROM q', []),
            ('SELECT SUM(id) FROM v', ['CREATE VIEW v AS SELECT id FROM t;']),
            ('SELECT SUM(id) FROM t', ['SET search_path TO other;']),
            ('SELECT SUM(id) FROM t', ['CREATE TABLE t (id INT);']),
        ):
            with self.subTest(query=query, extra=extra), self.assertRaises(ReviewNeeded):
                finite_query_source_columns(query, setup+extra)

    def test_existing_other_table_is_not_the_selected_source(self):
        from core.query_output_contract import check_rendered_sum_source
        from core.finite_sql_contract import Contradiction
        with self.assertRaisesRegex(Contradiction, 'query_source_identity_mismatch'):
            check_rendered_sum_source('SELECT SUM(id) FROM other',
                ['CREATE TABLE other (id INT);'], items=['SUM(id)'],
                output_types=['DECIMAL'], available_columns=['id'],
                available_types=['INTEGER'], source_tables=['t'],
                mode='M', identity='m_builtin_sum')


if __name__ == '__main__':
    unittest.main()
