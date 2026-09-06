from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.finite_sql_contract import inspect_write


class UpdateViewFixtureProvidesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.registry.load_all()

    def test_created_update_view_declares_its_direct_projection(self):
        fixture = self.registry.fixtures['fixture_update_view']
        tables = {t.name: t for t in fixture.provides.tables}
        self.assertIn('v_update_target', tables)
        view, base = tables['v_update_target'], tables['t_update_view_base']
        self.assertEqual(view.table_kind, 'view')
        self.assertEqual(view.persistence, 'permanent')
        self.assertEqual([c.model_dump() for c in view.columns],
                         [c.model_dump() for c in base.columns])
        self.assertIn('CREATE VIEW v_update_target AS SELECT id, note, qty FROM t_update_view_base;',
                      fixture.execution.setup_sqls)

    def test_provides_does_not_recreate_view_as_table_or_prove_writability(self):
        fixture = self.registry.fixtures['fixture_update_view']
        setup, teardown = FactorPackageSQLGenerator(self.registry)._compile_fixture_lifecycle([fixture.id])
        self.assertEqual(setup, fixture.execution.setup_sqls)
        self.assertEqual(teardown, fixture.execution.teardown_sqls)
        result = inspect_write("UPDATE v_update_target SET note = 'changed';", setup)
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('single_base_direct_view_columns', result['checks'])
        # The proof comes from ordered real DDL, never from provides alone.
        without_view = [s for s in setup if not s.startswith('CREATE VIEW')]
        missing = inspect_write("UPDATE v_update_target SET note = 'changed';", without_view)
        self.assertEqual(missing['status'], 'needs_review')
        self.assertEqual(missing['issues'][0]['code'], 'fixture_unknown')


if __name__ == '__main__':
    unittest.main()
