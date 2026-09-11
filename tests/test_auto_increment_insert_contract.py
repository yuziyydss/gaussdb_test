"""Explicit allocation triggers are neither ordinary DEFAULT nor NULL assignment."""
import unittest
from core import auto_increment_contract as contract
from tests.test_auto_increment_contract import DDL, DROP, GATES


class AutoIncrementInsertContractTests(unittest.TestCase):
    def check(self, body, setup=None, gates=None):
        return contract.check_autoincrement_insert(
            'INSERT INTO g_b_at_autoinc '+body+';',
            [DDL] if setup is None else setup, [DROP],
            GATES if gates is None else gates, 'g_b_at_autoinc')

    def test_three_explicit_triggers_and_omission_do_not_claim_counter_result(self):
        for trigger in ['NULL', '0', 'DEFAULT']:
            e=self.check(f'(id, note) VALUES ({trigger}, 1)')
            self.assertEqual(e['allocation_trigger'], trigger)
            self.assertFalse(e['counter_value_proven'])
            self.assertFalse(e['runtime_proven'])
        self.assertEqual(self.check('(note) VALUES (1)')['allocation_trigger'], 'omitted')

    def test_wrong_columns_arity_expression_and_extra_steps_rejected(self):
        for body in ['(note, id) VALUES (NULL, 1)', '(id, note) VALUES (1, NULL)',
                     '(id, note) VALUES (DEFAULT, DEFAULT)', '(id) VALUES (NULL, 1)',
                     '(id, note) VALUES (0+0, 1)', '(id, note) VALUES (0, 1), (0, 1)',
                     '(id, note) VALUES (0, 1) RETURNING id', '(id, note) VALUES (0, 1);;']:
            with self.subTest(body=body), self.assertRaises(ValueError): self.check(body)

    def test_default_declaration_ordinary_key_history_and_m_mode_not_accepted(self):
        for setup in [[DDL.replace('PRIMARY KEY AUTO_INCREMENT','PRIMARY KEY DEFAULT 1')],
                      [DDL.replace('PRIMARY KEY AUTO_INCREMENT','PRIMARY KEY')],
                      [DDL, 'INSERT INTO g_b_at_autoinc VALUES (100, 1);']]:
            with self.subTest(setup=setup), self.assertRaises(ValueError):
                self.check('(id, note) VALUES (NULL, 1)', setup=setup)
        with self.assertRaises(ValueError):
            self.check('(note) VALUES (1)', gates={**GATES,'compatibility_mode':['M']})
