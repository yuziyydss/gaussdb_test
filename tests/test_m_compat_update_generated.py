"""M UPDATE generated-column consumers require real preconditions, not labels."""
from tests.evolved_asset_assertions import assert_evolved_asset
from pathlib import Path
import unittest

import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.finite_sql_contract import inspect_write
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_pilot import update

ROOT = Path(__file__).resolve().parents[1]


class MUpdateGeneratedTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()

    def cases(self, suffix):
        mid = 'manifest_m_update_' + suffix
        self.assertTrue(mid in self.registry.manifests, 'Missing real generated-column manifest: ' + mid)
        return FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[mid])[0]

    def test_seeded_fixture_and_default_marker_are_real(self):
        cases = self.cases('generated_default')
        self.assertEqual(len(cases), 1)
        case = cases[0]
        self.assertIn('GENERATED ALWAYS AS (id + qty) STORED', '\n'.join(case.setup_sqls))
        self.assertIn('INSERT INTO m_b01_update_generated(id,qty) VALUES (2,9);', case.setup_sqls)
        self.assertIn('SET g = DEFAULT WHERE id = 2', case.sql)
        self.assertEqual(case.teardown_sqls, ['DROP TABLE m_b01_update_generated;'])
        self.assertEqual(case.expected, 'success')
        self.assertTrue(any(r['key'] == 'compatibility_mode' and r['allowed_values'] == ['M']
                            for r in case.environment_requirements))
        checked = inspect_write(case.sql, case.setup_sqls, conflict_source_scope='m_compat')
        self.assertEqual(checked['status'], 'checked', checked)
        self.assertIn('fixture_seeded_generated_update', checked['checks'])
        self.assertEqual(case.expected_scope, 'syntax_only')

    def test_generator_checks_rendered_sql_not_just_positive_value_label(self):
        self.cases('generated_default')
        dimension = self.registry.factors['m_update'].dimensions['assignments']
        value = next(v for c in dimension.classes for v in c.values
                     if v.id == 'm_update_assignments_generated_default')
        original = value.properties['items']
        try:
            value.properties['items'] = ['g = 99']
            with self.assertRaisesRegex(GenerationValidationError, 'generated_column_write'):
                self.cases('generated_default')
        finally:
            value.properties['items'] = original

