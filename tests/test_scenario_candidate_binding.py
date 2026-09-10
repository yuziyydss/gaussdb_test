"""Generated candidates, not duplicated literal SQL, own scenario target identity."""
import copy
import unittest
from pathlib import Path
from unittest.mock import patch
from pydantic import ValidationError
from core.factor_package_model import FactorPackageRegistry, FactorScenarioDef
from core.factor_package_generator import FactorPackageSQLGenerator
from core.execution_preparation import prepare_unit

ROOT = Path(__file__).resolve().parents[1]
SID = 'scenario_create_index_visibility_fresh'
MID = 'manifest_create_index_visibility_a_fresh'


class ScenarioCandidateBindingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT / 'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def scenario(self):
        s = self.r.scenarios[SID].model_copy(deep=True)
        s.steps = [dict(id=label, candidate={'manifest_ref': MID, 'params': {
            'visibility_clause': 'ci_visibility_'+label+'_a_fresh'}})
            for label in ('visible', 'invisible')]
        s.oracles = [dict(kind='manual_assertion', step_id=label, expected='Calibrate '+label+' metadata')
                     for label in ('visible', 'invisible')]
        return s

    def prepare(self, scenario=None, cases=None):
        return prepare_unit(scenario or self.scenario(),
            cases if cases is not None else self.g.generate_with_report(self.r.manifests[MID])[0], self.g)

    def test_real_generated_names_bound_without_literal_rewrite(self):
        cases = self.g.generate_with_report(self.r.manifests[MID])[0]
        result = self.prepare(cases=cases)
        self.assertEqual(result['static_blockers'], [])
        self.assertEqual({s['resolved_sql'] for s in result['steps']}, {c.sql for c in cases})
        self.assertEqual(len(result['oracle_calibration_pending']), 2)
        self.assertFalse(result['execution_authorized'])
        self.assertTrue(all('sql' not in s['source_step'] for s in result['steps']))

    def test_selector_ambiguity_missing_value_and_changed_seed_fail_closed(self):
        for values in ({}, {'visibility_clause': 'absent'}):
            s = self.scenario(); s.steps[0]['candidate']['params'] = values
            self.assertTrue(self.prepare(s)['static_blockers'])
        cases = copy.deepcopy(self.g.generate_with_report(self.r.manifests[MID])[0])
        cases[0].setup_sqls.append('INSERT INTO g_ci_visibility VALUES(999);')
        self.assertTrue(self.prepare(cases=cases)['static_blockers'])

    def test_candidate_cannot_impersonate_manifest_by_id_prefix_or_sql_change(self):
        cases = copy.deepcopy(self.g.generate_with_report(self.r.manifests[MID])[0])
        cases[0].sql = 'DROP TABLE g_ci_visibility;'
        result = self.prepare(cases=cases)
        self.assertTrue(result['static_blockers'])
        self.assertNotIn('DROP TABLE', ' '.join(s.get('resolved_sql') or '' for s in result['steps']))

    def test_generator_name_policy_changes_need_no_scenario_sql_patch(self):
        manifest = self.r.manifests[MID].model_copy(deep=True)
        manifest.identifier_policy['index_name'].prefix = 'idx_review_binding'
        with patch.dict(self.r.manifests, {MID: manifest}):
            result = self.prepare()
        self.assertEqual(result['static_blockers'], [])
        self.assertTrue(all('idx_review_binding_' in s['resolved_sql'] for s in result['steps']))
        self.assertTrue(all('sql' not in s['source_step'] for s in result['steps']))

    def test_model_rejects_dual_sql_unknown_fields_and_invalid_selector_shape(self):
        for mutation in ('sql', 'unknown', 'params'):
            raw = self.scenario().model_dump()
            if mutation == 'sql': raw['steps'][0]['sql'] = 'SELECT 1;'
            elif mutation == 'unknown': raw['steps'][0]['candidate']['typo'] = True
            else: raw['steps'][0]['candidate']['params'] = ['visible']
            with self.subTest(mutation=mutation), self.assertRaises(ValidationError):
                FactorScenarioDef(**raw)

    def test_registry_rejects_unknown_foreign_manifest_and_unbound_value(self):
        for mid, params in [('missing', {}), ('manifest_m_insert_generated', {}),
                            (MID, {'visibility_clause': 'absent'})]:
            s = self.scenario(); s.steps[0]['candidate'] = {'manifest_ref': mid, 'params': params}
            with patch.dict(self.r.scenarios, {SID: s}):
                errors = []; self.r._validate_references(errors)
            self.assertTrue(any('candidate' in e for e in errors), (mid, errors))


if __name__ == '__main__':
    unittest.main()
