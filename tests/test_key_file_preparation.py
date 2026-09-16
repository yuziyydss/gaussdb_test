"""Actual candidate/oracle/file identity with no database or file deployment."""
from pathlib import Path
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.execution_preparation import prepare_unit
from core.insert_conflict_key_contract import check_same_key_tuple
from core.spec_generator import GenerationValidationError
from scripts.prepare_execution_batch import build_batch

ROOT = Path(__file__).resolve().parents[1]


class KeyFilePreparationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def unit(self, sid, mid, mutate=None):
        scenario=self.r.scenarios[sid].model_copy(deep=True)
        if mutate:mutate(scenario)
        cases=self.g.generate_with_report(self.r.manifests[mid])[0]
        return prepare_unit(scenario,cases,self.g)

    def test_three_key_cases_have_independent_derived_oracles(self):
        mid='manifest_insert_same_key_tuple';cases=self.g.generate_with_report(self.r.manifests[mid])[0]
        self.assertEqual(len(cases),3)
        for branch in ('conflict','new','filtered'):
            u=self.unit('scenario_insert_same_key_'+branch,mid)
            self.assertEqual(u['static_blockers'],[])
            self.assertEqual(len(u['steps']),1)
            self.assertTrue(u['oracle_calibration_pending'])
            self.assertFalse(u['execution_authorized'])
            self.assertEqual(u['finite_contract_evidence'][0]['contract'],'same_inline_integer_key_tuple_v1')
            self.assertFalse(u['finite_contract_evidence'][0]['runtime_proven'])

    def test_key_oracle_query_and_expected_mutations_are_blocked(self):
        for field,value in [('expected',[[999,'fake']]),('sql','SELECT 1;')]:
            u=self.unit('scenario_insert_same_key_conflict','manifest_insert_same_key_tuple',
                        lambda s:s.oracles[0].update({field:value}))
            self.assertIn('finite_oracle_identity:write',u['static_blockers'])

    def test_generator_checks_actual_key_assignment_mode_and_setup(self):
        render=self.g._render_sql_with_consumption
        with patch.object(self.g,'_render_sql_with_consumption',side_effect=lambda *a:
                          (render(*a)[0].replace('EXCLUDED.id','EXCLUDED.id + 1'),render(*a)[1])):
            with self.assertRaisesRegex(GenerationValidationError,'conflict_key'):
                self.g.generate_with_report(self.r.manifests['manifest_insert_same_key_tuple'])

    def test_file_target_creation_is_not_setup_creation_or_deployment(self):
        for fmt in ('text','csv'):
            u=self.unit('scenario_create_foreign_table_file_'+fmt,'manifest_create_foreign_table_file_'+fmt)
            self.assertEqual(u['static_blockers'],[])
            self.assertTrue(u['oracle_calibration_pending'])
            self.assertFalse(u['database_executed'])
            creates=u['ownership_plan']['creates']
            target=next(c for c in creates if c['kind']=='foreign_table')
            self.assertEqual(target['phase'],'target');self.assertEqual(target['step_id'],'create')
            self.assertNotIn('setup_index',target)
            self.assertFalse(u['ownership_plan']['runtime_ownership_proven'])
            self.assertEqual(target['depends_on'],['g_cft_file_ns','g_cft_file_server'])
            asset=u['file_preparation_plan']['assets'][0]
            self.assertFalse(asset['asset']['deployed'])
            self.assertIn('fdw_validator_options_accepted',asset['target_required_receipts'])
            self.assertIn('exclusive_file_fdw_namespace_serialization',u['required_runtime_evidence'])

    def test_bounded_profiles_prepare_offline_without_runtime_promotion(self):
        expected = {
            'insert_same_key': (3, 'same_inline_integer_key_tuple_v1'),
            'file_fdw_options': (2, 'file_fdw_two_integer_input_v1'),
        }
        for profile, (count, contract) in expected.items():
            with self.subTest(profile=profile):
                batch=build_batch(self.r,self.g,profile=profile)
                summary=batch['summary']
                self.assertEqual(summary['candidates'],count)
                self.assertEqual(summary['scenario_sequences'],count)
                self.assertEqual(summary['bound_candidate_ids'],count)
                self.assertEqual(summary['unbound_candidate_ids'],[])
                self.assertEqual(summary['unit_status_counts'],{'oracle_calibration_pending':count})
                self.assertEqual(summary['runtime_verified'],0)
                self.assertFalse(batch['database_executed'])
                self.assertFalse(batch['execution_authorized'])
                for unit in batch['units']:
                    self.assertEqual(unit['static_blockers'],[])
                    self.assertEqual(unit['finite_contract_evidence'][0]['contract'],contract)
                    self.assertTrue(unit['oracle_calibration_pending'])

    def test_file_oracle_and_extra_step_do_not_get_finite_credit(self):
        sid='scenario_create_foreign_table_file_csv';mid='manifest_create_foreign_table_file_csv'
        u=self.unit(sid,mid,lambda s:s.oracles[0].update(expected=[[999,999]]))
        self.assertIn('finite_oracle_identity:create',u['static_blockers'])
        u=self.unit(sid,mid,lambda s:s.steps.append(dict(s.steps[0],id='second')))
        self.assertIn('file_fdw_sequence_unreviewed',u['static_blockers'])

if __name__=='__main__':unittest.main()
