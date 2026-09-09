"""Conditional M builtin SUM typing must not bleed into other identities."""
import copy
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]


class MSumContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def check(self, expression='SUM(qty) AS total', input_type='INTEGER',
              output_type='DECIMAL', mode='M', identity='m_builtin_sum'):
        factor = copy.deepcopy(self.registry.factors['m_select'])
        if mode != 'M':
            factor.source.catalog_chapter_ref.source_relpath = 'general/dml/select.txt'
        resolved = copy.deepcopy(self.registry.resolve_dimension_values('m_select'))
        combo = {k: v.default_value_id for k, v in factor.dimensions.items()}
        resolved['source_form'][combo['source_form']].attributes[
            'source_form.properties.available_types'] = ['INTEGER', input_type]
        resolved['target_list'][combo['target_list']].attributes.update({
            'target_list.properties.items': [expression],
            'target_list.properties.output_columns': ['total'],
            'target_list.properties.output_types': [output_type],
            'target_list.properties.referenced_columns': ['qty'],
            'target_list.properties.nonaggregate_columns': [],
            'target_list.properties.has_aggregate': True,
            'target_list.properties.function_output_contract': identity,
        })
        FactorPackageSQLGenerator._validate_structural_contract(factor, combo, resolved)

    def test_m_integer_sum_is_not_integer_bigint_or_text(self):
        for wrong in ('INTEGER', 'BIGINT', 'TEXT'):
            with self.subTest(wrong=wrong), self.assertRaisesRegex(
                GenerationValidationError, 'function_output_type_mismatch'):
                self.check(output_type=wrong)

    def test_exact_and_approximate_inputs_have_distinct_return_types(self):
        for typ in ('INT', 'INTEGER', 'INT4', 'DECIMAL', 'NUMERIC'):
            self.check(input_type=typ)
        for typ in ('FLOAT', 'DOUBLE'):
            self.check(input_type=typ, output_type='DOUBLE')
        with self.assertRaisesRegex(GenerationValidationError, 'function_output_type_mismatch'):
            self.check(input_type='FLOAT')

    def test_other_mode_and_user_function_cannot_borrow_m_identity(self):
        for changes in ({'mode':'general'}, {'identity':'user_function'},
                        {'expression':'app.sum(qty)'}, {'expression':'pg_catalog.sum(qty)'}):
            with self.subTest(changes=changes), self.assertRaisesRegex(
                GenerationValidationError, 'function_.*unknown'):
                self.check(**changes)

    def test_only_reviewed_direct_argument_forms(self):
        for expr in ('SUM(qty)', 'SUM(ALL qty)', 'SUM(DISTINCT qty) AS total'):
            self.check(expression=expr)
        for expr in ('SUM(qty + 1)', 'SUM(qty) OVER ()', 'SUM(NULL)', 'AVG(qty)',
                     'SUM(qty,qty)', 'SUM("qty")'):
            with self.subTest(expr=expr), self.assertRaisesRegex(
                GenerationValidationError, 'function_.*unknown'):
                self.check(expression=expr)

    def test_missing_argument_is_a_real_column_contradiction(self):
        with self.assertRaisesRegex(GenerationValidationError, 'function_missing_column'):
            self.check(expression='SUM(absent_col)')

    def test_unreviewed_input_family_is_not_assumed_numeric(self):
        for typ in ('TEXT', 'BOOLEAN', 'INTERVAL', 'BIGINT'):
            with self.subTest(typ=typ), self.assertRaisesRegex(
                GenerationValidationError, 'function_argument_type_unknown'):
                self.check(input_type=typ)

    def sum_manifest(self):
        mid = 'manifest_m_select_sum_builtin'
        self.assertTrue(mid in self.registry.manifests, 'Missing manifest: '+mid)
        return self.registry.manifests[mid]

    def test_formal_consumer_retains_runtime_identity_gate_and_real_source(self):
        cases, report = FactorPackageSQLGenerator(self.registry).generate_with_report(self.sum_manifest())
        self.assertEqual(len(cases), 2)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases}, {
            'SELECT SUM(id) AS total FROM m_b01_source;',
            'SELECT SUM(qty) AS total FROM m_b01_source;',
        })
        for case in cases:
            requirements = {r['key']: r['allowed_values'] for r in case.environment_requirements}
            self.assertEqual(requirements['compatibility_mode'], ['M'])
            self.assertEqual(requirements['function_resolution'], ['m_builtin_sum'])
            self.assertTrue(any('CREATE TABLE m_b01_source' in sql for sql in case.setup_sqls))

    def test_manifest_cannot_remove_or_widen_the_identity_gate(self):
        for mutation in ('remove', 'widen'):
            manifest = copy.deepcopy(self.sum_manifest())
            if mutation == 'remove':
                manifest.environment_requirements = [r for r in manifest.environment_requirements
                                                     if r.key != 'function_resolution']
            else:
                next(r for r in manifest.environment_requirements if r.key == 'function_resolution').allowed_values.append('unknown')
            with self.subTest(mutation=mutation), self.assertRaisesRegex(
                GenerationValidationError, 'function_resolution'):
                FactorPackageSQLGenerator(self.registry).generate_with_report(manifest)

    def test_supplemental_m_source_is_not_a_general_mode_signature(self):
        self.sum_manifest()
        ledger = self.registry.source_ledgers['source_ledger_m_select']
        source = next(s for s in ledger.supplemental_sources if s.id == 'm_select_sum_signature_source')
        self.assertEqual(source.catalog_chapter_ref.source_relpath, 'm_compat/utility/section_2_5_11.txt')
        self.assertEqual(source.catalog_chapter_ref.chapter_sha256,
                         'ca0c02156ff890f3b89fb2e200133acde2be0b10f7d5bb06af2c67d8c9900db9')
        scenario = self.registry.scenarios['scenario_m_select_sum_result']
        self.assertEqual(scenario.status, 'planned')


if __name__ == '__main__':
    unittest.main()
