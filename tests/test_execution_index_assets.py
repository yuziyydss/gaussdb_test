"""Finite index inventory describes receipt requirements, not permission."""
import unittest

from core.execution_preparation import ownership_plan


class IndexAssetTests(unittest.TestCase):
    def setup_sql(self):
        return ['CREATE SCHEMA g_ns;',
                'CREATE TABLE g_ns.t (id INTEGER NOT NULL, flag INTEGER NOT NULL);',
                'CREATE UNIQUE INDEX idx ON g_ns.t USING btree ((id + 1)) WHERE flag > 0;',
                'INSERT INTO g_ns.t VALUES (1, 1);']

    def test_index_has_table_dependency_and_conditional_implicit_cleanup(self):
        plan = ownership_plan(self.setup_sql(), ['DROP TABLE g_ns.t RESTRICT;', 'DROP SCHEMA g_ns;'])
        self.assertEqual(plan['blockers'], [])
        index = next(c for c in plan['creates'] if c['kind'] == 'index')
        self.assertEqual(index['object'], 'g_ns.idx')
        self.assertEqual(index['depends_on'], ['g_ns.t'])
        self.assertTrue(index['requires_success_receipt'])
        self.assertEqual(plan['cleanup'][0]['dependent_indexes'], ['g_ns.idx'])
        self.assertTrue(plan['cleanup'][0]['requires_dependency_inventory_check'])
        self.assertFalse(plan['runtime_ownership_proven'])

    def test_explicit_index_cleanup_precedes_table_without_double_drop(self):
        plan = ownership_plan(self.setup_sql(), ['DROP INDEX g_ns.idx RESTRICT;',
                                               'DROP TABLE g_ns.t;', 'DROP SCHEMA g_ns;'])
        self.assertEqual(plan['blockers'], [])
        self.assertEqual(plan['cleanup'][0]['kind'], 'index')
        self.assertEqual(plan['cleanup'][1]['dependent_indexes'], [])

    def test_unqualified_table_and_index_have_same_isolated_namespace(self):
        plan = ownership_plan(['CREATE TABLE g_t (id INT);', 'CREATE INDEX g_i ON g_t (id);'],
                              ['DROP TABLE g_t RESTRICT;'])
        self.assertEqual(plan['blockers'], [])
        self.assertEqual(plan['creates'][1]['depends_on'], ['g_t'])

    def test_unknown_external_or_out_of_order_index_is_not_owned(self):
        cases = [
            ['CREATE INDEX idx ON external_table (id);'],
            [self.setup_sql()[2]] + self.setup_sql()[:2],
            self.setup_sql()[:2] + ['CREATE INDEX other.idx ON g_ns.t (id);'],
            self.setup_sql()[:2] + ['CREATE INDEX idx ON g_ns.t USING gin (id);'],
            self.setup_sql()[:2] + ['CREATE INDEX CONCURRENTLY idx ON g_ns.t (id);'],
            self.setup_sql()[:2] + ['CREATE INDEX IF NOT EXISTS idx ON g_ns.t (id);'],
            self.setup_sql()[:2] + ['CREATE INDEX idx ON g_ns.t ((user_function(id)));'],
            self.setup_sql() + [self.setup_sql()[2]],
        ]
        for setup in cases:
            with self.subTest(setup=setup):
                self.assertTrue(ownership_plan(setup, ['DROP TABLE g_ns.t;', 'DROP SCHEMA g_ns;'])['blockers'])

    def test_invalid_cleanup_and_name_collision_fail_closed(self):
        for cleanup in [
            ['DROP TABLE g_ns.t;', 'DROP INDEX g_ns.idx;', 'DROP SCHEMA g_ns;'],
            ['DROP SCHEMA g_ns;', 'DROP TABLE g_ns.t;'],
            ['DROP INDEX other.idx;', 'DROP TABLE g_ns.t;', 'DROP SCHEMA g_ns;'],
            ['DROP INDEX g_ns.idx CASCADE;', 'DROP TABLE g_ns.t;', 'DROP SCHEMA g_ns;'],
        ]:
            with self.subTest(cleanup=cleanup):
                self.assertTrue(ownership_plan(self.setup_sql(), cleanup)['blockers'])
        setup = self.setup_sql()[:2] + ['CREATE INDEX t ON g_ns.t (id);']
        self.assertTrue(ownership_plan(setup, ['DROP TABLE g_ns.t;', 'DROP SCHEMA g_ns;'])['blockers'])


if __name__ == '__main__':
    unittest.main()
