"""Documented input projections are not trained-model capability evidence."""
import ast
import hashlib
import json
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.finite_sql_contract import ddl_tables, expression_type, finite_projection

ROOT = Path(__file__).resolve().parents[1]
FID = 'fixture_create_model_training_input'


class ModelInputShapeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()

    def scenario(self, factor_id):
        sid = 'scenario_' + factor_id + '_input_projection'
        self.assertIn(sid, self.registry.factors[factor_id].scenario_refs)
        return self.registry.scenarios[sid]

    def test_training_and_prediction_keep_distinct_ordered_projections(self):
        fixture = self.registry.fixtures[FID]
        setup = fixture.execution.setup_sqls
        tables = ddl_tables(setup)
        for factor_id, names in [('create_model', ['size', 'lot', 'mark']),
                                 ('predict_by', ['size', 'lot'])]:
            scenario = self.scenario(factor_id)
            query = next(s['sql'] for s in scenario.steps if s['id'] == 'project')
            self.assertEqual(query, 'SELECT ' + ', '.join(names) + ' FROM fp_model_houses_input;')
            projected, source_columns = finite_projection(query.rstrip(';'), tables)
            oracle = next(o for o in scenario.oracles if o['kind'] == 'ordered_input_columns')
            expected = [{'name': n, 'type': 'TEXT' if n == 'mark' else 'INTEGER', 'nullable': True}
                        for n in names]
            self.assertEqual(oracle['expected'], expected)
            self.assertEqual(projected, names)
            for column in expected:
                source = next(c for c in fixture.provides.tables[0].columns if c.name == column['name'])
                self.assertEqual(source.type, column['type'])
                self.assertEqual(source.nullable, column['nullable'])
            self.assertEqual([expression_type(n, source_columns) for n in names],
                             ['integer', 'integer'] + (['text'] if factor_id == 'create_model' else []))

    def test_projection_oracles_are_derived_from_all_fifteen_seed_rows(self):
        fixture = self.registry.fixtures[FID]
        seed = fixture.execution.setup_sqls[2].split('VALUES', 1)[1].strip().rstrip(';')
        rows = sorted(ast.literal_eval('[' + seed + ']'))
        for fid, indices in [('create_model', (5, 6, 7)), ('predict_by', (5, 6))]:
            scenario = self.scenario(fid)
            oracle = next(o for o in scenario.oracles if o['kind'] == 'ordered_seed_projection')
            projected = [[r[i] for i in indices] for r in rows]
            digest = hashlib.sha256(json.dumps(projected, separators=(',', ':')).encode()).hexdigest()
            self.assertEqual(oracle['expected']['row_count'], 15)
            self.assertEqual(oracle['expected']['normalized_sha256'], digest)
            self.assertEqual(oracle['order_by'], 'id')
            self.assertIn('ORDER BY id', oracle['query'])

    def test_cross_package_input_is_shared_without_model_creation_or_ready_claims(self):
        fixture = self.registry.fixtures[FID]
        self.assertIsNone(fixture.factor_ref)
        for fid in ('create_model', 'predict_by'):
            scenario = self.scenario(fid)
            self.assertEqual(scenario.fixture_refs, [FID])
            self.assertEqual(scenario.status, 'planned')
            self.assertEqual(self.registry.factors[fid].manifest_refs, [])
            self.assertEqual(self.registry.factors[fid].status, 'needs_review')
            sqls = [s['sql'] for s in scenario.steps if 'sql' in s] + fixture.execution.setup_sqls
            self.assertNotIn('CREATE MODEL', ' '.join(sqls).upper())
            self.assertNotIn('PREDICT BY', ' '.join(sqls).upper())
            self.assertNotIn('DROP ', ' '.join(sqls).upper())
            self.assertEqual(fixture.execution.teardown_sqls, ['ROLLBACK;'])
        self.assertIn('create_model', self.registry.factor_dependency_graph()['predict_by'])
        refs = self.scenario('predict_by').fact_refs
        self.assertIn('create_model::create_model_fact_body_27', refs)
        self.assertIn('create_model::create_model_fact_example_232', refs)
        values = self.registry.resolve_dimension_values('create_model')['architecture']
        self.assertTrue(all(v.validity == 'conditional' for v in values.values()))


if __name__ == '__main__':
    unittest.main()
