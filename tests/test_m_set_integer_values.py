"""Integer SET representatives do not prove the full variable conversion domain."""
from tests.evolved_asset_assertions import assert_evolved_asset
from pathlib import Path
import unittest
import yaml

from scripts.build_m_compat_batch_03 import set_command
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator


class MSetIntegerDefinitionTests(unittest.TestCase):
    def test_integer_values_have_direct_source_and_separate_selection(self):
        p = set_command()
        files = p.finish()
        self.assertTrue('manifests/user_variable_integer.manifest.yaml' in files)
        values = {v['id']: v for c in p.dims['variable_value']['classes'] for v in c['values']}
        for suffix, render in [('integer_positive', '7'), ('integer_negative', '-7')]:
            v = values[p.vid('variable_value', suffix)]
            self.assertEqual(v['render'], render)
            self.assertEqual(v['fact_refs'], [p.fid('user_variable_integer')])
        fact = next(f for f in p.facts if f['id'] == p.fid('user_variable_integer'))
        self.assertEqual(fact['source_anchor'], '2.4.2.16.4 L109-109')
        for suffix in ('user_variable', 'user_variable_list', 'user_variable_chain'):
            self.assertEqual(files['manifests/'+suffix+'.manifest.yaml']['bindings']['variable_value'],
                             ['m_set_variable_value_string', 'm_set_variable_value_null'])


class MSetIntegerIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = Path(__file__).resolve().parents[1]
        cls.r = FactorPackageRegistry(cls.root / 'specs')
        cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def cases(self):
        mid = 'manifest_m_set_user_variable_integer'
        self.assertTrue(mid in self.r.manifests, mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_four_integer_assignments_keep_original_m_connection_contract(self):
        cases, report = self.cases()
        self.assertEqual({c.sql for c in cases},
                         {f'SET @m_set_value {op} {v};' for op in (':=', '=') for v in ('7', '-7')})
        self.assertEqual(len(cases), 4)
        self.assertTrue(report.pairwise_complete)
        for c in cases:
            self.assertEqual((c.expected, c.expected_scope), ('success', 'syntax_only'))
            self.assertEqual(c.setup_sqls, ["SET @m_set_value := 'initial value';"])
            self.assertEqual(c.teardown_sqls, ['SET @m_set_value := NULL;'])
            gates = {g['key']: g['allowed_values'] for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode'], ['M'])
            self.assertEqual(gates['session_lifecycle'], ['isolated_connection'])
            self.assertEqual(gates['variable_lifecycle'], ['close_case_connection'])
            self.assertEqual(set(c.consumed_dimension_ids), {'form','assignment_operator','variable_value'})

    def test_planned_readback_is_per_step_not_a_claim_of_driver_type(self):
        self.cases()
        s = self.r.scenarios['scenario_m_set_user_variable_integer_values']
        self.assertEqual(s.status, 'planned')
        self.assertEqual([o['expected'] for o in s.oracles], [[[7]], [[-7]]])
        self.assertEqual([o['step_id'] for o in s.oracles], ['positive', 'negative'])
        self.assertTrue(all(o['sql'] == 'SELECT @m_set_value;' for o in s.oracles))
        self.assertIn('per_step_oracle', s.execution_requirements)
        self.assertIn('close_case_connection', s.execution_requirements)
        self.assertIn('target_oracle_calibration', s.execution_requirements)

    def test_integer_feature_is_representative_and_extended_domain_stays_open(self):
        self.cases()
        features = {f.id:f for f in self.r.matrices['matrix_m_set_user_variable_coverage'].documented_features}
        self.assertEqual(features['m_set_feature_user_variable_integer'].coverage_mode, 'representative')
        self.assertEqual(features['m_set_feature_user_variable_extended_domain'].status, 'needs_profile')
        gap = next(f for f in self.r.factors['m_set'].facts if f.id == 'm_set_fact_user_variable_profile_gap')
        self.assertEqual(gap.status, 'needs_verification')

    def test_curated_builder_and_saved_package_match_exactly(self):
        self.cases()
        for name, expected in set_command().finish().items():
            path = self.root / 'specs/utility/m_set' / name
            assert_evolved_asset(self, yaml.safe_load(path.read_text()), expected, name)
