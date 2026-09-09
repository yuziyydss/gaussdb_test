"""M UPDATE generated-column consumers require real preconditions, not labels."""
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
        self.assertEqual(inspect_write(case.sql, case.setup_sqls)['status'], 'needs_review')

    def test_literal_and_null_target_only_the_generated_write_rule(self):
        cases = self.cases('generated_negative')
        self.assertEqual(len(cases), 2)
        self.assertEqual({c.sql.split('SET ')[1] for c in cases},
                         {'g = 99 WHERE id = 2;', 'g = NULL WHERE id = 2;'})
        for case in cases:
            self.assertEqual(case.expected, 'error')
            self.assertEqual(case.expected_error_category, 'generated_write')
            self.assertEqual(case.expected_oracle_status, 'needs_verification')
            self.assertFalse(case.expected_sqlstates)
            inspected = inspect_write(case.sql, case.setup_sqls)
            self.assertEqual(inspected['status'], 'rejected', inspected)
            self.assertEqual(inspected['issues'][0]['code'], 'generated_column_write')

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

    def test_scenarios_have_real_steps_and_unexecuted_oracles(self):
        for suffix in ('generated_default_result', 'generated_write', 'generated_null_write'):
            path = ROOT / f'specs/dml/m_update/scenarios/{suffix}.scenario.yaml'
            self.assertTrue(path.exists(), str(path))
            scenario = yaml.safe_load(path.read_text())
            self.assertEqual(scenario['status'], 'planned')
            self.assertTrue(scenario['fixture_refs'])
            self.assertTrue(all('sql' in step and 'action' not in step for step in scenario['steps']))
            self.assertTrue(scenario['oracles'])
            self.assertIn('database_authorization', scenario['execution_requirements'])

    def test_builder_reconstruction_and_finite_coverage_preserve_honest_gaps(self):
        self.cases('generated_default')
        for name, expected in update().finish().items():
            self.assertEqual(yaml.safe_load((ROOT / 'specs/dml/m_update' / name).read_text()), expected, name)
        audit = FactorCoverageAuditor(self.registry).audit('m_update')
        self.assertTrue(audit['conclusions']['generation_model_complete'], audit['rules'])
        self.assertFalse(audit['conclusions']['source_extraction_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__ == '__main__':
    unittest.main()
