"""Declared projection metadata must agree with actual direct-column items."""
import copy
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from core.shared_column_contract import check_direct_projection_types
from core.finite_sql_contract import Contradiction

ROOT = Path(__file__).resolve().parents[1]


class MProjectionContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def context(self, **changes):
        factor = self.registry.factors['m_select']
        combo = {key: value.default_value_id for key, value in factor.dimensions.items()}
        combo.update(changes)
        return factor, combo, copy.deepcopy(self.registry.resolve_dimension_values(factor.id))

    def test_direct_source_type_cannot_be_relabelled(self):
        factor, combo, resolved = self.context()
        resolved['target_list'][combo['target_list']].attributes['target_list.properties.output_types'] = ['TEXT']
        with self.assertRaisesRegex(GenerationValidationError, 'projection_type_mismatch'):
            FactorPackageSQLGenerator._validate_structural_contract(factor, combo, resolved)

    def test_both_set_sides_cannot_agree_on_a_forged_type(self):
        factor, combo, resolved = self.context(set_operator='m_select_set_operator_union')
        for dim in ('target_list', 'right_target_list'):
            resolved[dim][combo[dim]].attributes[dim+'.properties.output_types'] = ['TEXT']
        with self.assertRaisesRegex(GenerationValidationError, 'projection_type_mismatch'):
            FactorPackageSQLGenerator._validate_structural_contract(factor, combo, resolved)

    def test_actual_missing_column_cannot_hide_behind_reference_metadata(self):
        factor, combo, resolved = self.context()
        resolved['target_list'][combo['target_list']].attributes['target_list.properties.items'] = ['absent_col']
        with self.assertRaisesRegex(GenerationValidationError, 'projection_missing_column'):
            FactorPackageSQLGenerator._validate_structural_contract(factor, combo, resolved)

    def test_alias_does_not_change_the_source_type(self):
        factor, combo, resolved = self.context()
        target = resolved['target_list'][combo['target_list']].attributes
        target['target_list.properties.items'] = ['id AS item_id']
        target['target_list.properties.output_columns'] = ['item_id']
        FactorPackageSQLGenerator._validate_structural_contract(factor, combo, resolved)
        target['target_list.properties.output_types'] = ['TEXT']
        with self.assertRaisesRegex(GenerationValidationError, 'projection_type_mismatch'):
            FactorPackageSQLGenerator._validate_structural_contract(factor, combo, resolved)

    def test_unknown_projection_is_not_claimed_as_checked(self):
        for expr in ('SUM(id)', 't.id', '"id"', 'NULL', 'TRUE', "'id'", 'id + 1',
                     'CURRENT_TIMESTAMP', 'CURRENT_USER AS who'):
            with self.subTest(expr=expr):
                self.assertEqual(check_direct_projection_types([expr], ['INTEGER'],
                    ['id'], ['INTEGER']), [])

    def test_type_aliases_do_not_allow_numeric_promotion(self):
        self.assertEqual(check_direct_projection_types(['id AS n'], ['INTEGER'],
            ['id'], ['INT4']), [0])
        with self.assertRaises(Contradiction):
            check_direct_projection_types(['id'], ['NUMERIC'], ['id'], ['INTEGER'])

    def test_right_source_is_not_assumed_to_be_the_left_source(self):
        factor, combo, resolved = self.context(set_operator='m_select_set_operator_union')
        right = resolved['right_target_list'][combo['right_target_list']].attributes
        right['right_target_list.properties.items'] = ['other_id']
        right['right_target_list.properties.output_columns'] = ['other_id']
        # This shape check alone cannot prove the right fixture; no left-source
        # lookup is permitted to invent a missing-column contradiction here.
        FactorPackageSQLGenerator._validate_structural_contract(factor, combo, resolved)


if __name__ == '__main__':
    unittest.main()
