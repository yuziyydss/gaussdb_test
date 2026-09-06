"""Finite inline DDL non-null evidence must not contradict existing metadata."""
from pathlib import Path
import unittest

from core import finite_sql_contract as finite
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError


class InlineNonNullEvidenceTests(unittest.TestCase):
    def test_inline_not_null_and_primary_key_are_evidence(self):
        evidence = finite.finite_inline_nonnull_columns([
            'CREATE TABLE s.t(id INT PRIMARY KEY DEFAULT 0, note TEXT NOT NULL, other INT);'])
        self.assertEqual(evidence, {'s.t': {'id', 'note'}})

    def test_strings_and_check_expressions_are_not_column_constraints(self):
        evidence = finite.finite_inline_nonnull_columns([
            "CREATE TABLE t(note TEXT DEFAULT 'NOT NULL PRIMARY KEY', id INT CHECK(id IS NOT NULL));"])
        self.assertEqual(evidence, {'t': set()})

    def test_changed_or_opaque_ddl_cannot_retain_old_nonnull_evidence(self):
        for extra in ['ALTER TABLE t ALTER COLUMN id DROP NOT NULL;', 'DROP TABLE t;',
                      'DO opaque_program;', "PREPARE TRANSACTION 'pt';"]:
            with self.subTest(extra=extra):
                self.assertNotIn('t', finite.finite_inline_nonnull_columns([
                    'CREATE TABLE t(id INT NOT NULL);', extra]))
        self.assertEqual(finite.finite_inline_nonnull_columns([
            'CREATE TABLE t(id INT NOT NULL); DROP TABLE t;']), {})

    def test_no_inline_evidence_is_not_a_nullable_proof(self):
        # Table constraints/domains are deliberately not inferred by this helper.
        result = finite.finite_inline_nonnull_columns([
            'CREATE TABLE t(id INT, PRIMARY KEY(id));'])
        self.assertEqual(result, {'t': set()})


class RealFixtureNullabilityTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.registry.load_all()

    def test_replace_primary_key_metadata_matches_actual_fixture(self):
        fixture = self.registry.fixtures['fixture_replace_conflict_source']
        target = next(t for t in fixture.provides.tables if t.name.endswith('b11_replace_target'))
        column = next(c for c in target.columns if c.name == 'col_1')
        self.assertFalse(column.nullable)
        self.assertIn('col_1 INT PRIMARY KEY DEFAULT 0', ' '.join(fixture.execution.setup_sqls))

    def test_generator_rejects_nullable_metadata_against_inline_primary_key(self):
        fixture = self.registry.fixtures['fixture_replace_conflict_source']
        bad = fixture.model_copy(deep=True)
        bad.provides.tables[0].columns[0].nullable = True
        self.registry.fixtures[fixture.id] = bad
        try:
            with self.assertRaisesRegex(GenerationValidationError, 'nullable.*DDL'):
                FactorPackageSQLGenerator(self.registry)._compile_fixture_lifecycle([fixture.id])
        finally:
            self.registry.fixtures[fixture.id] = fixture

    def test_truncate_plain_columns_do_not_inherit_unstated_nonnull_constraints(self):
        cases = [
            ('fixture_truncate_foreign_key', 't_tr_fk_child',
             'CREATE TABLE t_tr_fk_child (id INTEGER, parent_id INTEGER REFERENCES t_tr_fk_parent(id));'),
            ('fixture_truncate_partitioned', 't_tr_partitioned',
             'CREATE TABLE t_tr_partitioned (id INTEGER, note VARCHAR(32)) PARTITION BY RANGE (id) '
             '(PARTITION p_low VALUES LESS THAN (10), PARTITION p_max VALUES LESS THAN (MAXVALUE));'),
        ]
        for fixture_id, name, ddl in cases:
            with self.subTest(fixture=fixture_id):
                fixture = self.registry.fixtures[fixture_id]
                table = next(t for t in fixture.provides.tables if t.name == name)
                self.assertTrue(next(c for c in table.columns if c.name == 'id').nullable)
                self.assertIn(ddl, fixture.execution.setup_sqls)
        parent = self.registry.fixtures['fixture_truncate_foreign_key'].provides.tables[0]
        self.assertEqual(parent.name, 't_tr_fk_parent')
        self.assertFalse(parent.columns[0].nullable)  # Actual parent PRIMARY KEY stays non-null.


if __name__ == '__main__':
    unittest.main()
