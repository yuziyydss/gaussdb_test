"""B2 real generator consumer: exact partial-expression index and three rows."""
import unittest
from pathlib import Path
from unittest.mock import patch

from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from core.insert_partial_index_contract import check_partial_index_insert
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_insert_partial_index_fresh'
FID = 'fixture_insert_partial_index_fresh'


class InsertPartialIndexGenerationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def generate(self, manifest=None):
        self.assertTrue(MID in self.r.manifests, MID)
        return self.g.generate_with_report(manifest or self.r.manifests[MID])

    def test_three_actual_candidates_and_partial_membership(self):
        cases, report = self.generate()
        self.assertEqual(len(cases), 3)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(len({c.case_id for c in cases}), 3)
        prefix = 'INSERT INTO g_insert_partial (id, flag) VALUES '
        suffix = ' ON CONFLICT ((id + 1)) WHERE flag > 0 DO NOTHING;'
        self.assertEqual({c.sql for c in cases}, {prefix+row+suffix for row in ['(1, 2)', '(2, 1)', '(1, 0)']})
        outcomes = set()
        for c in cases:
            result = check_partial_index_insert(c.sql, c.setup_sqls, c.teardown_sqls)
            outcomes.add((result['predicate_member'], result['conflict_in_finite_model']))
            self.assertEqual((c.expected, c.expected_scope), ('success', 'syntax_only'))
            self.assertFalse(result['runtime_proven'])
        self.assertEqual(outcomes, {(True, True), (True, False), (False, False)})

    def test_actual_ddl_not_profile_claims(self):
        self.generate()
        original = self.g._compile_fixture_lifecycle
        for old, new in [('CREATE UNIQUE INDEX', 'CREATE INDEX'), ('USING btree', 'USING gin'),
                         ('(id + 1)', '(id + 2)'), ('WHERE flag > 0', 'WHERE flag >= 0'),
                         ('INTEGER NOT NULL', 'TEXT NOT NULL')]:
            def changed(refs):
                setup, teardown = original(refs)
                return [s.replace(old, new) for s in setup], teardown
            with self.subTest(new=new), patch.object(self.g, '_compile_fixture_lifecycle', side_effect=changed):
                with self.assertRaisesRegex(GenerationValidationError, 'partial_index'):
                    self.generate()

    def test_actual_target_and_cleanup_not_just_bindings(self):
        self.generate(); original = self.g._render_sql_with_consumption
        for old, new in [('id + 1', 'id + 2'), ('flag > 0', 'flag >= 1'),
                         ('g_insert_partial', 'g_wrong'), ('DO NOTHING', 'DO UPDATE SET flag = 7')]:
            def changed(*args):
                sql, consumed = original(*args)
                return sql.replace(old, new), consumed
            with self.subTest(new=new), patch.object(self.g, '_render_sql_with_consumption', side_effect=changed):
                with self.assertRaisesRegex(GenerationValidationError, 'partial_index'):
                    self.generate()
        original_lifecycle = self.g._compile_fixture_lifecycle
        with patch.object(self.g, '_compile_fixture_lifecycle',
                          side_effect=lambda refs: (original_lifecycle(refs)[0], ['DROP TABLE g_wrong;'])):
            with self.assertRaisesRegex(GenerationValidationError, 'partial_index'):
                self.generate()

    def test_gates_and_explicit_contract_cannot_be_removed(self):
        self.generate()
        for key in ['compatibility_mode', 'operator_binding', 'case_namespace', 'actor_authority']:
            manifest = self.r.manifests[MID].model_copy(deep=True)
            manifest.environment_requirements = [g for g in manifest.environment_requirements if g.key != key]
            with self.subTest(key=key), self.assertRaisesRegex(GenerationValidationError, 'partial_index'):
                self.generate(manifest)
        manifest = self.r.manifests[MID].model_copy(deep=True)
        manifest.environment_requirements[0].allowed_values = ['M']
        with self.assertRaisesRegex(GenerationValidationError, 'partial_index'):
            self.generate(manifest)
        matrix = self.r.matrices['matrix_insert_target_profiles'].model_copy(deep=True)
        profile = next(p for p in matrix.profiles if p.id == 'insert_target_partial_index_fresh')
        profile.properties.pop('partial_index_contract')
        with patch.dict(self.r.matrices, {matrix.id: matrix}):
            with self.assertRaisesRegex(GenerationValidationError, 'partial_index'):
                self.generate()

    def test_planned_oracles_and_generic_value_not_promoted(self):
        self.generate()
        scenarios = [self.r.scenarios['scenario_insert_partial_index_'+suffix]
                     for suffix in ('conflict', 'new_key', 'outside')]
        self.assertTrue(all(s.status == 'planned' for s in scenarios))
        self.assertEqual([s.oracles[0]['expected'] for s in scenarios], [0, 1, 1])
        self.assertTrue(all(len(s.steps) == 1 for s in scenarios))
        value = self.r.resolve_dimension_values('insert')['conflict_clause']['insert_on_conflict_expression_predicate']
        self.assertEqual(value.validity, 'conditional')
        self.assertIn('create_index', self.r.factor_dependency_graph()['insert'])

    def test_sql_literal_is_not_a_conflict_clause(self):
        original = self.g._render_sql_with_consumption
        def changed(*args):
            sql, consumed = original(*args)
            return sql.replace("'alpha'", "'ON CONFLICT ((id + 1)) WHERE flag > 0'"), consumed
        with patch.object(self.g, '_render_sql_with_consumption', side_effect=changed):
            cases, _ = self.g.generate_with_report(self.r.manifests['manifest_insert_pg_conflict_fresh'])
        self.assertEqual(len(cases), 4)

    def test_duplicate_gates_fail_and_immutable_is_one_source_claim(self):
        self.generate()
        manifest = self.r.manifests[MID].model_copy(deep=True)
        manifest.environment_requirements.append(manifest.environment_requirements[0].model_copy(deep=True))
        with self.assertRaisesRegex(GenerationValidationError, 'partial_index'):
            self.generate(manifest)
        unit = next(u for u in self.r.source_ledgers['source_ledger_create_index'].units if u.id == 'ci_src_010')
        self.assertEqual(unit.atomicity, 'atomic')
        self.assertEqual(unit.fact_refs, ['ci_fact_immutable', 'ci_fact_immutable_environment'])


if __name__ == '__main__':
    unittest.main()
