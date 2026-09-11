"""File preparation is bound to real steps, never a deployment receipt."""
import copy
from pathlib import Path
import unittest

from core.execution_preparation import prepare_unit
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT = Path(__file__).resolve().parents[1]


class FilePreparationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)
        cls.original = cls.generator.generate_with_report(
            cls.registry.manifests['manifest_load_data_two_int'])[0]

    def prepare(self, cases=None, scenario=None):
        return prepare_unit(scenario or self.registry.scenarios['scenario_load_data_two_int_rows'],
                            cases if cases is not None else copy.deepcopy(self.original), self.generator)

    def test_bound_file_has_separate_pending_server_receipts(self):
        unit = self.prepare()
        self.assertEqual(unit['static_blockers'], [])
        plan = unit['file_preparation_plan']
        self.assertFalse(plan['runtime_verified'])
        self.assertFalse(plan['deployment_authorized'])
        self.assertEqual(len(plan['assets']), 1)
        item = plan['assets'][0]
        self.assertEqual(item['required_by_steps'], ['step_1'])
        self.assertEqual(item['location'], 'database_server')
        self.assertFalse(item['runtime_ownership_proven'])
        self.assertFalse(item['asset']['deployed'])
        self.assertIn('server_file_sha256', item['required_receipts'])
        self.assertIn('safe_data_path_allowlist', item['required_receipts'])
        self.assertIn('file_deployment_and_verification', unit['required_runtime_evidence'])
        self.assertEqual(unit['failure_policy']['file'], 'stop_before_setup_and_target')

    def test_unbound_candidate_file_metadata_does_not_leak(self):
        cases = copy.deepcopy(self.original)
        unbound = next(c for c in cases if '(id,qty)' not in c.sql)
        unbound.file_assets[0]['target_path'] = '/tmp/factor_assets/unrelated.tsv'
        unit = self.prepare(cases)
        self.assertEqual(unit['static_blockers'], [])
        self.assertEqual(len(unit['file_preparation_plan']['assets']), 1)
        self.assertNotIn('unrelated', str(unit['file_preparation_plan']))

    def test_missing_or_forged_bound_payload_is_not_trusted(self):
        for mutation in ('missing', 'sha256', 'deployed'):
            cases = copy.deepcopy(self.original)
            bound = next(c for c in cases if '(id,qty)' in c.sql)
            if mutation == 'missing':
                bound.file_assets = []
            else:
                bound.file_assets[0][mutation] = True if mutation == 'deployed' else '0' * 64
            with self.subTest(mutation=mutation):
                self.assertIn('file_asset_identity:step_1', self.prepare(cases)['static_blockers'])

    def test_sql_path_must_match_fixture_bytes(self):
        cases = copy.deepcopy(self.original)
        bound = next(c for c in cases if '(id,qty)' in c.sql)
        bound.sql = bound.sql.replace('two_int.tsv', 'other.tsv')
        scenario = self.registry.scenarios['scenario_load_data_two_int_rows'].model_copy(deep=True)
        scenario.steps[0]['sql'] = bound.sql
        self.assertIn('file_asset_identity:step_1', self.prepare(cases, scenario)['static_blockers'])

    def test_local_does_not_inherit_server_deployment_contract(self):
        cases = copy.deepcopy(self.original)
        bound = next(c for c in cases if '(id,qty)' in c.sql)
        bound.sql = bound.sql.replace('LOAD DATA INFILE', 'LOAD DATA LOCAL INFILE')
        scenario = self.registry.scenarios['scenario_load_data_two_int_rows'].model_copy(deep=True)
        scenario.steps[0]['sql'] = bound.sql
        unit = self.prepare(cases, scenario)
        self.assertIn('file_location_contract_unreviewed:step_1', unit['static_blockers'])
        self.assertEqual(unit['file_preparation_plan']['assets'], [])

    def test_mode_and_conflicting_file_metadata_fail_closed(self):
        cases = copy.deepcopy(self.original)
        bound = next(c for c in cases if '(id,qty)' in c.sql)
        next(e for e in bound.environment_requirements if e['key'] == 'compatibility_mode')['allowed_values'] = ['M']
        self.assertIn('file_location_contract_unreviewed:step_1', self.prepare(cases)['static_blockers'])
        cases = copy.deepcopy(self.original)
        bound = next(c for c in cases if '(id,qty)' in c.sql)
        duplicate = copy.deepcopy(bound.file_assets[0])
        duplicate['sha256'] = '0' * 64
        bound.file_assets.append(duplicate)
        self.assertIn('file_asset_identity:step_1', self.prepare(cases)['static_blockers'])

    def test_reused_file_keeps_each_step_dependency(self):
        scenario = self.registry.scenarios['scenario_load_data_two_int_rows'].model_copy(deep=True)
        scenario.steps = [dict(id='first', sql=self.original[0].sql),
                          dict(id='second', sql=self.original[1].sql)]
        scenario.oracles = [dict(step_id=sid, kind='manual_assertion', expected='pending')
                            for sid in ('first', 'second')]
        unit = self.prepare(scenario=scenario)
        self.assertEqual(unit['static_blockers'], [])
        self.assertEqual(unit['file_preparation_plan']['assets'][0]['required_by_steps'], ['first', 'second'])
        self.assertEqual(len(unit['oracle_calibration_pending']), 2)

    def test_cleanup_receipt_is_not_a_pre_target_condition(self):
        item = self.prepare()['file_preparation_plan']['assets'][0]
        self.assertNotIn('owned_file_cleanup_and_residue_check', item['required_receipts'])
        self.assertEqual(item['cleanup_required_receipts'],
                         ['deployment_owner_receipt', 'server_file_identity_and_hash_recheck',
                          'owned_file_cleanup_and_residue_check'])


if __name__ == '__main__':
    unittest.main()
