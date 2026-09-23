"""Conditional values retain real blockers, not unrelated branch conditions."""
from pathlib import Path
import unittest
import yaml

ROOT = Path(__file__).resolve().parents[1]
PACKAGE = ROOT / 'specs/ddl/alter_table'


def find_id(node, wanted):
    if isinstance(node, dict):
        if node.get('id') == wanted:
            return node
        children = node.values()
    elif isinstance(node, list):
        children = node
    else:
        return None
    for child in children:
        found = find_id(child, wanted)
        if found is not None:
            return found
    return None


class AlterTableConditionScopeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.factor = yaml.safe_load((PACKAGE / 'alter_table.factor.yaml').read_text())
        cls.matrix = yaml.safe_load((PACKAGE / 'matrices/action_profiles.matrix.yaml').read_text())
        cls.ledger = yaml.safe_load((PACKAGE / 'alter_table.source.yaml').read_text())

    def test_modify_parent_does_not_borrow_b_extended_syntax_condition(self):
        value = find_id(self.factor, 'at_statement_modify_multi')
        self.assertEqual(value['validity'], 'conditional')
        self.assertNotIn('at_open_b_compat_fixture', value['fact_refs'])
        self.assertIn('at_open_modify_multi_contract', value['fact_refs'])
        fact = find_id(self.factor, 'at_open_modify_multi_contract')
        self.assertEqual(fact['status'], 'confirmed')
        self.assertEqual(fact['type'], 'environment')
        unit = find_id(self.ledger, 'at_pdf_su_048')
        self.assertIn(fact['id'], unit['fact_refs'])
        self.assertNotIn('at_open_b_compat_fixture', unit['fact_refs'])
        self.assertEqual((unit['line_start'], unit['line_end']), (359, 361))
        # ADD and statistics now have their own atomic units, not a borrowed B gate.
        self.assertEqual(find_id(self.ledger, 'at_pdf_su_048_add')['line_end'], 358)
        self.assertEqual(find_id(self.ledger, 'at_pdf_su_048_statistics')['line_start'], 362)

    def test_ilm_without_expression_does_not_require_expression_whitelist(self):
        value = find_id(self.matrix, 'at_action_ilm')
        self.assertEqual(value['validity'], 'unknown')
        self.assertNotIn('ON (', value['render'])
        self.assertNotIn('at_open_ilm_whitelist', value['fact_refs'])
        self.assertIn('at_open_ilm_policy_lifecycle', value['fact_refs'])
        fact = find_id(self.factor, 'at_open_ilm_policy_lifecycle')
        self.assertEqual(fact['status'], 'confirmed')
        self.assertEqual(fact['type'], 'environment')
        self.assertIn(fact['id'], find_id(self.ledger, 'at_pdf_su_041')['fact_refs'])

    def test_other_branch_requirements_and_original_values_are_preserved(self):
        for vid in ('at_action_modify_b', 'at_action_change_b', 'at_action_first_b',
                    'at_action_auto_increment_b'):
            self.assertIn('at_open_b_compat_fixture', find_id(self.matrix, vid)['fact_refs'])
        self.assertEqual(find_id(self.factor, 'at_open_ilm_whitelist')['status'], 'confirmed')
        self.assertEqual(find_id(self.factor, 'at_open_ilm_whitelist')['type'], 'environment')
        self.assertEqual(find_id(self.factor, 'at_modify_columns_two')['validity'], 'valid')
        self.assertEqual(self.factor['status'], 'needs_review')


if __name__ == '__main__':
    unittest.main()
