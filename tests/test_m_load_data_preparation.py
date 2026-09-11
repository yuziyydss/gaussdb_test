"""One real M server-file candidate: typed rows, not LOCAL or conflict behavior."""
import copy
from pathlib import Path
import unittest

from core.execution_preparation import prepare_unit
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator

ROOT = Path(__file__).resolve().parents[1]
SID = 'scenario_m_load_data_plain_rows'


class MLoadDataPreparationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)
        cls.cases = cls.g.generate_with_report(cls.r.manifests['manifest_m_load_data_empty'])[0]

    def test_plain_candidate_gets_real_three_row_oracle_without_rewriting_sql(self):
        self.assertTrue(SID in self.r.scenarios, SID)
        scenario = self.r.scenarios[SID]
        before = [c.to_dict() for c in self.cases]
        unit = prepare_unit(scenario, self.cases, self.g)
        self.assertEqual(unit['static_blockers'], [])
        self.assertEqual(unit['oracle_calibration_pending'], [])
        self.assertEqual(unit['steps'][0]['case_id'], 'manifest_m_load_data_empty_005f904071c2')
        self.assertEqual(unit['steps'][0]['oracles'][0]['expected'], [[1,10],[2,20],[3,30]])
        self.assertEqual([c.to_dict() for c in self.cases], before)
        self.assertTrue(unit['m_environment_plan_ref'])
        asset = unit['file_preparation_plan']['assets'][0]
        self.assertEqual(asset['location'], 'database_server')
        self.assertEqual(asset['required_by_steps'], ['load_plain'])
        self.assertIn('table_insert_delete_privileges', asset['target_required_receipts'])
        self.assertNotIn('table_insert_delete_privileges', asset['required_receipts'])
        self.assertFalse(unit['file_preparation_plan']['deployment_authorized'])
        self.assertFalse(unit['database_executed'])

    def test_mode_authority_and_guc_are_not_inherited_from_general_mode(self):
        from core.execution_preparation import file_preparation_plan
        base = next(c for c in self.cases if c.case_id.endswith('005f904071c2'))
        scenario = self.r.scenarios[SID]
        for key in ('compatibility_mode', 'actor_authority', 'enable_copy_server_files', 'server_file_access'):
            candidate = copy.deepcopy(base)
            candidate.environment_requirements = [g for g in candidate.environment_requirements if g['key'] != key]
            with self.subTest(key=key):
                plan, blockers = file_preparation_plan(scenario, {'load_plain': candidate}, candidate.setup_sqls, self.g)
                self.assertIn('file_location_contract_unreviewed:load_plain', blockers)
                self.assertEqual(plan['assets'], [])

    def test_actual_fixture_state_must_be_the_reviewed_empty_two_column_table(self):
        from core.execution_preparation import file_preparation_plan
        base = next(c for c in self.cases if c.case_id.endswith('005f904071c2'))
        for setup in (base.setup_sqls + ['INSERT INTO m_load_data_empty VALUES (1,99);'],
                      [base.setup_sqls[0].replace('id INTEGER PRIMARY KEY, qty INTEGER', 'qty INTEGER PRIMARY KEY, id INTEGER')]):
            with self.subTest(setup=setup):
                _, blockers = file_preparation_plan(self.r.scenarios[SID], {'load_plain': base}, setup, self.g)
                self.assertIn('file_location_contract_unreviewed:load_plain', blockers)

    def test_other_m_shapes_cannot_inherit_the_plain_input_contract(self):
        self.assertTrue(SID in self.r.scenarios, SID)
        base = next(c for c in self.cases if c.case_id.endswith('005f904071c2'))
        for replacement in ('LOCAL INFILE', 'INFILE'):
            scenario = self.r.scenarios[SID].model_copy(deep=True)
            candidate = copy.deepcopy(base)
            if replacement == 'LOCAL INFILE':
                candidate.sql = candidate.sql.replace('INFILE', replacement)
            else:
                candidate.sql = candidate.sql[:-1] + ' SET qty = 40;'
            scenario.steps = [dict(id='load_plain', sql=candidate.sql)]
            with self.subTest(replacement=replacement):
                unit = prepare_unit(scenario, [candidate], self.g)
                self.assertIn('file_location_contract_unreviewed:load_plain', unit['static_blockers'])

    def test_omitted_columns_have_source_and_old_gaps_remain(self):
        factor = self.r.factors['m_load_data']
        self.assertIn('m_load_data_fact_all_columns', {f.id for f in factor.facts})
        self.assertIn('scenario_m_load_data_results', factor.scenario_refs)
        self.assertIn('scenario_m_load_data_local_protocol', factor.scenario_refs)
        self.assertEqual(factor.status, 'needs_review')
        self.assertEqual(self.r.scenarios['scenario_m_load_data_results'].steps[0].keys(), {'action'})

    def test_all_other_generated_empty_table_variants_still_need_review(self):
        from core.execution_preparation import file_preparation_plan
        for candidate in self.cases:
            plan, blockers = file_preparation_plan(self.r.scenarios[SID],
                {'load_plain': candidate}, candidate.setup_sqls, self.g)
            with self.subTest(case_id=candidate.case_id):
                if candidate.case_id.endswith('005f904071c2'):
                    self.assertEqual(blockers, [])
                    self.assertEqual(len(plan['assets']), 1)
                else:
                    self.assertIn('file_location_contract_unreviewed:load_plain', blockers)
                    self.assertEqual(plan['assets'], [])

    def test_literal_lf_cannot_be_replaced_by_unreviewed_escape(self):
        from core.execution_preparation import file_preparation_plan
        candidate = copy.deepcopy(next(c for c in self.cases if c.case_id.endswith('005f904071c2')))
        candidate.sql = candidate.sql.replace("'\n'", "'\\n'")
        _, blockers = file_preparation_plan(self.r.scenarios[SID],
            {'load_plain': candidate}, candidate.setup_sqls, self.g)
        self.assertIn('file_location_contract_unreviewed:load_plain', blockers)


if __name__ == '__main__':
    unittest.main()
