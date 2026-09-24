"""A package gap closes only for its concrete, sourced static evidence."""
import ast
import hashlib
import json
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT = Path(__file__).resolve().parents[1]


class PackageClosureBatchTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()

    def test_pg_conflict_plan_has_collision_oracles_without_promoting_conditional_values(self):
        factor = self.registry.factors['insert']
        scenario = self.registry.scenarios['scenario_insert_conflict_pg_rows']
        self.assertIn(scenario.id, factor.scenario_refs)
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual(scenario.fixture_refs, ['fixture_insert_unique_target'])
        self.assertEqual(len(scenario.variants), 3)
        endings = {'ON CONFLICT (id) DO NOTHING', 'ON CONFLICT DO NOTHING',
                   'ON CONFLICT (id) DO UPDATE SET note = EXCLUDED.note'}
        self.assertEqual({v['sql'].rstrip(';') for v in scenario.variants}, {
            "INSERT INTO t_insert_unique (id, note) VALUES (101, 'alpha') " + tail
            for tail in endings})
        values = {v.id: v for c in factor.dimensions['conflict_clause'].classes for v in c.values}
        for variant in scenario.variants:
            value = values[variant['value_ref']]
            self.assertEqual(value.validity, 'conditional')
            self.assertTrue(variant['sql'].endswith(value.render.strip() + ';'))
            note = 'alpha' if variant['id'] == 'excluded_update' else 'existing'
            self.assertEqual(variant['expected_rows'], [[101, note, None]])
        fixture = self.registry.fixtures['fixture_insert_unique_target']
        self.assertIn('id INTEGER PRIMARY KEY', ' '.join(fixture.execution.setup_sqls))
        self.assertIn("VALUES (101, 'existing')", ' '.join(fixture.execution.setup_sqls))
        self.assertIn('PG', ' '.join(scenario.preconditions))
        self.assertFalse(any('conflict_pg' in mid for mid in factor.manifest_refs))

    def test_model_input_preserves_document_rows_not_training_claim(self):
        factor = self.registry.factors['create_model']
        fid = 'fixture_create_model_training_input'
        self.assertIn(fid, factor.fixture_refs)
        self.assertTrue(factor.manifest_refs)
        fixture = self.registry.fixtures[fid]
        self.assertEqual(fixture.status, 'needs_review')
        setup = fixture.execution.setup_sqls
        self.assertEqual(setup[0], 'BEGIN;')
        self.assertEqual(fixture.execution.teardown_sqls, ['ROLLBACK;'])
        compiled_setup, compiled_teardown = FactorPackageSQLGenerator(self.registry)._compile_fixture_lifecycle([fid])
        self.assertEqual(compiled_setup, setup)
        self.assertEqual(compiled_teardown, ['ROLLBACK;'])
        self.assertEqual(len(setup), 3)
        self.assertNotIn('CREATE MODEL', ' '.join(setup).upper())
        self.assertNotIn('DROP ', ' '.join(setup).upper())
        table = fixture.provides.tables[0]
        self.assertEqual([c.name for c in table.columns],
                         ['id', 'tax', 'bedroom', 'bath', 'price', 'size', 'lot', 'mark'])
        self.assertTrue(all(c.nullable for c in table.columns))
        self.assertEqual([c.type for c in table.columns],
                         ['INTEGER', 'INTEGER', 'INTEGER', 'DOUBLE PRECISION',
                          'INTEGER', 'INTEGER', 'INTEGER', 'TEXT'])
        for column in table.columns:
            self.assertIn(column.name + ' ' + column.type, setup[1])
        actual_values = setup[2].split('VALUES', 1)[1].rstrip().rstrip(';')
        rows = ast.literal_eval('[' + actual_values + ']')
        # Normalized hash independently calculated from frozen source L216-L230.
        # CI need not distribute the private PDF/text in order to guard the data.
        self.assertEqual(hashlib.sha256(json.dumps(rows, separators=(',', ':')).encode()).hexdigest(),
                         'c0c57d4a812cdc02c9ba80687782cc73f5a6eee5566e395e36820f54cbf72a5c')
        source_path = ROOT / 'work/doc2spec/full_general_corpus/general/ddl/create_model.txt'
        if source_path.exists():
            source_values = source_path.read_text().split('INSERT INTO houses(')[1].split('VALUES', 1)[1].split(';', 1)[0]
            self.assertEqual(rows, ast.literal_eval('[' + source_values + ']'))
        self.assertEqual(len(rows), 15)
        self.assertEqual({row[-1] for row in rows}, {'a+', 'a-'})
        scenario = self.registry.scenarios['scenario_create_model_training_input']
        self.assertEqual(scenario.status, 'planned')
        self.assertEqual(scenario.fixture_refs, [fid])
        self.assertIn(scenario.id, factor.scenario_refs)
        self.assertIn('create_model_fact_example_224', scenario.fact_refs)


if __name__ == '__main__':
    unittest.main()
