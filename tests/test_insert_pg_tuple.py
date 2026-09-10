"""Finite PG non-key tuple updates; no database connection or runtime claims."""
import unittest
from pathlib import Path
from unittest.mock import patch

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.finite_sql_contract import inspect_write
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_insert_pg_tuple_fresh'
FID = 'fixture_insert_pg_tuple_fresh'


class InsertPGTupleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def cases(self):
        self.assertTrue(MID in self.registry.manifests, MID)
        return self.generator.generate_with_report(self.registry.manifests[MID])

    def test_two_exact_candidates_share_actual_three_column_fixture(self):
        cases, report = self.cases()
        prefix = 'INSERT INTO g_insert_pg_tuple (id, note, aux) '
        suffix = ' ON CONFLICT (id) DO UPDATE SET (note, aux) = (EXCLUDED.note, EXCLUDED.aux);'
        self.assertEqual({c.sql for c in cases}, {
            prefix + "VALUES (101, 'alpha', 9)" + suffix,
            prefix + "VALUES (102, 'beta', 8)" + suffix,
        })
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(len({c.case_id for c in cases}), 2)
        for c in cases:
            self.assertEqual(c.setup_sqls, [
                'CREATE TABLE g_insert_pg_tuple (id INTEGER PRIMARY KEY, note VARCHAR(64), aux INTEGER);',
                "INSERT INTO g_insert_pg_tuple (id, note, aux) VALUES (101, 'existing', 7);"])
            self.assertEqual(c.teardown_sqls, ['DROP TABLE g_insert_pg_tuple;'])
            self.assertEqual((c.expected, c.expected_scope), ('success', 'syntax_only'))
            result = inspect_write(c.sql, c.setup_sqls)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('conflict_input_same_column_types', result['checks'])

    def test_arity_and_missing_incoming_column_mutations_rejected(self):
        cases, _ = self.cases()
        for old, new, code in [
            ('(EXCLUDED.note, EXCLUDED.aux)', '(EXCLUDED.note)', 'arity'),
            ('EXCLUDED.aux', 'EXCLUDED.missing', 'missing_column'),
        ]:
            c = cases[0]
            result = inspect_write(c.sql.replace(old, new), c.setup_sqls)
            self.assertEqual(result['status'], 'rejected', result)
            self.assertEqual(result['issues'][0]['code'], code)

    def test_mode_and_actual_key_required_not_just_profile_label(self):
        self.cases()
        manifest = self.registry.manifests[MID].model_copy(deep=True)
        manifest.environment_requirements = [g for g in manifest.environment_requirements if g.key != 'compatibility_mode']
        with self.assertRaisesRegex(GenerationValidationError, 'compatibility_mode=PG'):
            self.generator.generate_with_report(manifest)
        fixture = self.registry.fixtures[FID].model_copy(deep=True)
        fixture.execution.setup_sqls[0] = fixture.execution.setup_sqls[0].replace(' PRIMARY KEY', ' NOT NULL')
        with patch.dict(self.registry.fixtures, {FID: fixture}):
            with self.assertRaisesRegex(GenerationValidationError, 'primary_key'):
                self.cases()

    def test_local_scope_excludes_generic_key_update_and_wrong_target(self):
        cases, _ = self.cases()
        r = self.registry
        solver = self.generator._build_solver(r.factors['insert'], r.manifests[MID], r.resolve_dimension_values('insert'))
        for dimension, value in [('target_profile', 'insert_target_unique_columns'),
                                  ('conflict_clause', 'insert_on_conflict_tuple_update'),
                                  ('source_profile', 'insert_source_query')]:
            self.assertFalse(solver.is_valid(dict(cases[0].params, **{dimension: value}))[0])

    def test_oracles_remain_planned_and_generic_value_conditional(self):
        self.cases()
        s = self.registry.scenarios['scenario_insert_pg_tuple_fresh']
        self.assertEqual(s.status, 'planned')
        self.assertEqual([o['expected'] for o in s.oracles], [
            [[101, 'alpha', 9]], [[101, 'alpha', 9], [102, 'beta', 8]]])
        values = self.registry.resolve_dimension_values('insert')['conflict_clause']
        self.assertEqual(values['insert_on_conflict_tuple_update'].validity, 'conditional')


if __name__ == '__main__':
    unittest.main()
