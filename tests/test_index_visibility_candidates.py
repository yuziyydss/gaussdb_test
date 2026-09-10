"""Two A-mode visibility candidates, not optimizer or runtime verification."""
import unittest
from pathlib import Path
from types import SimpleNamespace as NS
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator as Generator
from core.spec_generator import GenerationValidationError

MID='manifest_create_index_visibility_a_fresh'


class SelectedEnvironmentRequirementTests(unittest.TestCase):
    def check(self, required=None, gates=None, active=True):
        attrs={'x.properties.required_environment_capabilities':
               {'disable_keyword_options_state':['empty']} if required is None else required}
        Generator._validate_selected_value_modes(
            NS(id='test',environment_requirements=[] if gates is None else gates),
            {'x':'v'},{'x':{'v':NS(attributes=attrs)}},{'x'} if active else set())

    def test_exact_requirement_is_consumed(self):
        self.check(gates=[NS(key='disable_keyword_options_state',allowed_values=['empty'])])

    def test_missing_wrong_broadened_duplicate_and_empty_gates_fail(self):
        for gates in ([],[NS(key='disable_keyword_options_state',allowed_values=['visible'])],
                      [NS(key='disable_keyword_options_state',allowed_values=['empty','visible'])],
                      [NS(key='disable_keyword_options_state',allowed_values=[])],
                      [NS(key='disable_keyword_options_state',allowed_values=['empty'])]*2):
            with self.subTest(gates=gates),self.assertRaises(GenerationValidationError):self.check(gates=gates)

    def test_invalid_requirement_is_not_silently_ignored(self):
        for required in ([],{'k':[]},{'k':['']},{'k':['x','x']},{'k':'x'},{'k':[{}]}):
            with self.subTest(required=required),self.assertRaises(GenerationValidationError):self.check(required)

    def test_unconsumed_branch_does_not_introduce_an_environment_gate(self):
        self.check(active=False)

    def test_two_active_values_cannot_overwrite_each_others_requirements(self):
        resolved={d:{'v':NS(attributes={d+'.properties.required_environment_capabilities':{'k':[v]}})}
                  for d,v in [('x','one'),('y','two')]}
        with self.assertRaises(GenerationValidationError):
            Generator._validate_selected_value_modes(NS(id='test',environment_requirements=[
                NS(key='k',allowed_values=['two'])]),{'x':'v','y':'v'},resolved,{'x','y'})


class IndexVisibilityCandidateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=Generator(cls.r)

    def manifest(self):
        self.assertTrue(MID in self.r.manifests, MID)
        return self.r.manifests[MID]

    def test_two_fresh_candidates_with_all_three_environment_conditions(self):
        cases,report=self.g.generate_with_report(self.manifest())
        self.assertEqual(len(cases),2);self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.params['visibility_clause'] for c in cases},
                         {'ci_visibility_visible_a_fresh','ci_visibility_invisible_a_fresh'})
        for c in cases:
            self.assertRegex(c.sql,r'^CREATE INDEX idx_ci_visibility_[0-9a-f]+ ON g_ci_visibility USING btree \(id\) (?:IN)?VISIBLE;$')
            self.assertEqual(c.setup_sqls,['CREATE TABLE g_ci_visibility (id INTEGER) WITH (storage_type=astore);'])
            self.assertEqual(c.teardown_sqls,['DROP TABLE g_ci_visibility;'])
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
            gates={g['key']:g['allowed_values'] for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode'],['A'])
            self.assertEqual(gates['disable_keyword_options_state'],['empty'])
            self.assertEqual(gates['upgrade_phase'],['not_upgrading'])

    def test_removing_or_broadening_any_gate_fails_generation(self):
        for key,wrong in (('compatibility_mode','M'),('disable_keyword_options_state','visible'),
                          ('upgrade_phase','upgrade_uncommitted')):
            for action in ('remove','broaden'):
                m=self.manifest().model_copy(deep=True)
                if action=='remove':m.environment_requirements=[g for g in m.environment_requirements if g.key!=key]
                else:next(g for g in m.environment_requirements if g.key==key).allowed_values.append(wrong)
                with self.subTest(key=key,action=action),self.assertRaises(GenerationValidationError):
                    self.g.generate_with_report(m)

    def test_atomic_source_conditions_and_planned_oracle_remain_separate(self):
        self.manifest()
        f=self.r.factors['create_index'];ledger=self.r.source_ledgers[f.source_ledger_ref]
        units={u.id:u for u in ledger.units}
        for prefix in ('ci_src_110','ci_src_111'):
            for suffix in ('b','c','d'):
                self.assertEqual(units[prefix+suffix].atomicity,'atomic')
        scenario=self.r.scenarios['scenario_create_index_visibility_fresh']
        self.assertEqual(scenario.status,'planned')
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))


if __name__=='__main__':unittest.main()
