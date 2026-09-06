"""Fixture composition must not guess away ambiguous unquoted SQL names."""
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError


class FixtureIdentifierCollisionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.registry.load_all()

    def pair(self, first_name, second_name, shrink=False):
        original = self.registry.fixtures['fixture_create_view_source_two_ints']
        first, second = original.model_copy(deep=True), original.model_copy(deep=True)
        first.id, second.id = 'fixture_identifier_probe_one', 'fixture_identifier_probe_two'
        first.provides.tables[0].name = first_name
        second.provides.tables[0].name = second_name
        for fixture in (first, second):
            fixture.seed.rows = []
            fixture.seed.required = False
            self.registry.fixtures[fixture.id] = fixture
            self.addCleanup(self.registry.fixtures.pop, fixture.id, None)
        if shrink:
            second.provides.tables[0].columns = second.provides.tables[0].columns[:1]
        return [first.id, second.id]

    def test_case_only_name_collision_cannot_overwrite_column_contract(self):
        refs = self.pair('t_probe', 'T_PROBE', shrink=True)
        with self.assertRaisesRegex(GenerationValidationError, '大小写'):
            FactorPackageSQLGenerator(self.registry)._compile_fixture_lifecycle(refs)

    def test_same_shape_still_requires_one_unquoted_spelling(self):
        refs = self.pair('t_probe', 'T_PROBE')
        with self.assertRaisesRegex(GenerationValidationError, '大小写'):
            FactorPackageSQLGenerator(self.registry)._fixture_table_contracts(refs)

    def test_qualified_unquoted_names_include_schema_in_comparison(self):
        refs = self.pair('schema_one.t_probe', 'SCHEMA_ONE.T_PROBE')
        with self.assertRaisesRegex(GenerationValidationError, '大小写'):
            FactorPackageSQLGenerator(self.registry)._fixture_table_contracts(refs)

    def test_different_schemas_and_quoted_names_are_not_folded_together(self):
        for first, second in [('schema_one.t', 'schema_two.T'), ('"t"', '"T"')]:
            with self.subTest(first=first, second=second):
                refs = self.pair(first, second)
                contracts = FactorPackageSQLGenerator(self.registry)._fixture_table_contracts(refs)
                self.assertEqual(set(contracts), {first, second})
                for ref in refs:
                    self.registry.fixtures.pop(ref)

    def test_identical_spelling_and_shape_retains_existing_deduplication(self):
        refs = self.pair('t_probe', 't_probe')
        setup, _ = FactorPackageSQLGenerator(self.registry)._compile_fixture_lifecycle(refs)
        self.assertEqual(sum(sql.startswith('CREATE TABLE t_probe ') for sql in setup), 1)

    def test_auto_ddl_rejects_case_only_duplicate_column_names(self):
        refs = self.pair('t_probe', 'unrelated')
        table = self.registry.fixtures[refs[0]].provides.tables[0]
        table.columns.append(table.columns[0].model_copy(update={'name': 'COL_1'}))
        with self.assertRaisesRegex(GenerationValidationError, '列名.*重复'):
            FactorPackageSQLGenerator(self.registry)._compile_fixture_lifecycle([refs[0]])


if __name__ == '__main__':
    unittest.main()
