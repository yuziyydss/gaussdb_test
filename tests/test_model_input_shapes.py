"""Documented input projections are not trained-model capability evidence."""
import ast
import hashlib
import json
from pathlib import Path
import re
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

    def test_shared_seed_matches_all_three_source_examples_not_only_its_oracle(self):
        fixture = self.registry.fixtures[FID]
        sql = fixture.execution.setup_sqls[2]
        fixture_rows = ast.literal_eval('['+sql.split('VALUES',1)[1].strip().rstrip(';')+']')
        for fid in ('create_model','predict_by','drop_model'):
            source = self.registry.factors[fid].source.catalog_chapter_ref
            path = ROOT/'work/doc2spec/full_general_corpus'/source.source_relpath
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(),source.chapter_sha256)
            body = path.read_text()
            match = re.search(r'INSERT\s+INTO\s+houses\s*\(([^)]+)\)\s+VALUES\s*(.*?);',body,re.S|re.I)
            self.assertIsNotNone(match,fid)
            columns = [n.strip() for n in match[1].split(',')]
            self.assertEqual(columns,['id','tax','bedroom','bath','price','size','lot','mark'])
            rows = ast.literal_eval('['+match[2]+']')
            self.assertEqual(len(rows),15)
            self.assertTrue(all(len(r)==8 for r in rows))
            self.assertEqual(fixture_rows,rows,fid)
            # Same-family columns are not interchangeable: source order matters.
            self.assertNotEqual([[r[5],r[6]] for r in rows],[[r[6],r[5]] for r in rows])

    def test_three_examples_share_features_target_order_without_training_evidence(self):
        for fid in ('create_model','predict_by','drop_model'):
            source = self.registry.factors[fid].source.catalog_chapter_ref
            body = (ROOT/'work/doc2spec/full_general_corpus'/source.source_relpath).read_text()
            self.assertRegex(body,r'FEATURES\s+size,\s*lot\s+TARGET\s+mark')
            self.assertEqual(self.registry.factors[fid].manifest_refs,[])
        self.assertNotIn('models',self.registry.fixtures[FID].provides.model_dump())

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
