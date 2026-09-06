"""Automatic seed serialization cannot turn special floats into SQL names."""
from pathlib import Path
import unittest
import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError


class SeedLiteralTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.registry.load_all()

    def test_yaml_nonfinite_floats_require_explicit_typed_handling(self):
        for token in ('.nan', '.inf', '-.inf'):
            with self.subTest(token=token):
                value = yaml.safe_load(token)
                self.assertIsInstance(value, float)
                with self.assertRaisesRegex(GenerationValidationError, '非有限'):
                    FactorPackageSQLGenerator._sql_literal(value)

    def test_existing_scalar_and_string_literals_are_unchanged(self):
        for value, expected in [(None, 'NULL'), (True, 'TRUE'), (False, 'FALSE'),
                                (1, '1'), (-2, '-2'), (1.25, '1.25'),
                                ('NaN', "'NaN'"), ('Infinity', "'Infinity'"),
                                ("O'Brien; SELECT 1", "'O''Brien; SELECT 1'")]:
            with self.subTest(value=value):
                self.assertEqual(FactorPackageSQLGenerator._sql_literal(value), expected)

    def test_auto_fixture_rejects_nonfinite_seed_before_returning_sql(self):
        registry = self.registry
        original = registry.fixtures['fixture_create_view_source_two_ints']
        self.addCleanup(registry.fixtures.__setitem__, original.id, original)
        fixture = registry.fixtures['fixture_create_view_source_two_ints'].model_copy(deep=True)
        registry.fixtures[fixture.id] = fixture
        for value in (float('nan'), float('inf'), float('-inf')):
            with self.subTest(value=value):
                fixture.seed.rows[0]['col_1'] = value
                with self.assertRaisesRegex(GenerationValidationError, '非有限'):
                    FactorPackageSQLGenerator(registry)._compile_fixture_lifecycle([fixture.id])

    def test_auto_seed_cannot_supply_null_or_omit_a_nonnull_column(self):
        registry = self.registry
        original = registry.fixtures['fixture_create_view_source_two_ints']
        self.addCleanup(registry.fixtures.__setitem__, original.id, original)
        fixture = original.model_copy(deep=True)
        fixture.provides.tables[0].columns[0].nullable = False
        registry.fixtures[fixture.id] = fixture
        for row in ({'col_2': 2}, {'col_1': None, 'col_2': 2}):
            with self.subTest(row=row):
                fixture.seed.rows = [row]
                with self.assertRaisesRegex(GenerationValidationError, 'seed.*非空列'):
                    FactorPackageSQLGenerator(registry)._compile_fixture_lifecycle([fixture.id])
        fixture.provides.tables[0].columns[0].nullable = True
        setup, _ = FactorPackageSQLGenerator(registry)._compile_fixture_lifecycle([fixture.id])
        self.assertIn('VALUES (NULL, 2)', ' '.join(setup))


if __name__ == '__main__':
    unittest.main()
