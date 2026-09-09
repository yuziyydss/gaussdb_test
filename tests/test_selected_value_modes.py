"""Mode requirements on consumed values are static applicability, not a DB probe."""
import unittest
from types import SimpleNamespace as NS
from core.factor_package_generator import FactorPackageSQLGenerator as Generator
from core.spec_generator import GenerationValidationError


class SelectedValueModesTests(unittest.TestCase):
    def check(self, required=('B',), allowed=('B',), active=('x',), duplicate=False):
        attrs = {'x.properties.required_compatibility_modes': list(required)}
        resolved = {'x': {'v': NS(attributes=attrs)}}
        gates = [] if allowed is None else [NS(key='compatibility_mode', allowed_values=list(allowed))]
        if duplicate: gates += gates
        Generator._validate_selected_value_modes(NS(id='sample',environment_requirements=gates),
            {'x':'v'}, resolved, set(active))

    def test_exact_mode_and_narrow_subset(self):
        self.check()
        self.check(required=('B','PG'))

    def test_missing_wrong_and_broadened_gate_are_rejected(self):
        for allowed in (None, ('PG',), ('B','PG'), (), ('B','B')):
            with self.subTest(allowed=allowed), self.assertRaises(GenerationValidationError):
                self.check(allowed=allowed)

    def test_duplicate_gate_does_not_last_write_win(self):
        with self.assertRaises(GenerationValidationError): self.check(duplicate=True)

    def test_inactive_value_does_not_constrain_an_unused_branch(self):
        self.check(active=(), allowed=None)

    def test_invalid_contract_modes_and_conflicting_active_values_fail(self):
        for required in ((), ('B','B'), ('BOGUS',)):
            with self.subTest(required=required), self.assertRaises(GenerationValidationError):
                self.check(required=required)
        resolved = {d: {'v': NS(attributes={d+'.properties.required_compatibility_modes':[mode]})}
                    for d, mode in [('x','B'),('y','PG')]}
        with self.assertRaises(GenerationValidationError):
            Generator._validate_selected_value_modes(NS(id='conflict',environment_requirements=[
                NS(key='compatibility_mode',allowed_values=['B'])]), {'x':'v','y':'v'}, resolved, {'x','y'})


if __name__=='__main__': unittest.main()
