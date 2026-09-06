"""Native boolean predicates, not the solver, supply the truth oracle."""
from itertools import combinations, product
import unittest

from core.combinator import generate_constraint_aware_pairwise, PairwiseGenerationError
from core.constraint_solver import ConstraintRule, ConstraintSolver, ConstraintEvaluationError


class ConstraintBooleanSemanticsTests(unittest.TestCase):
    values = ('', 'x', 0, 1, None, [], ['x'], False, True)
    predicates = (
        ('a and b', lambda a, b: bool(a and b)),
        ('a or b', lambda a, b: bool(a or b)),
        ('not a', lambda a, b: not a),
        ('a => b', lambda a, b: not a or bool(b)),
        ('not (a or b)', lambda a, b: not (a or b)),
        ('a and (b or False)', lambda a, b: bool(a and (b or False))),
    )

    def test_complete_assignments_match_independent_boolean_predicates(self):
        for raw, predicate in self.predicates:
            rule = ConstraintRule(raw)
            for a, b in product(self.values, repeat=2):
                with self.subTest(rule=raw, a=a, b=b):
                    self.assertEqual(rule.evaluate({'a': a, 'b': b}), predicate(a, b))

    def test_ast_literals_match_values_used_as_variables(self):
        for value in self.values:
            for operator in ('and', 'or'):
                for right in (False, True):
                    expected = bool(value and right) if operator == 'and' else bool(value or right)
                    with self.subTest(value=value, op=operator, right=right):
                        self.assertEqual(ConstraintRule(f'{value!r} {operator} {right!r}').evaluate({}), expected)

    def test_partial_assignments_never_prune_a_satisfiable_completion(self):
        for raw, predicate in self.predicates:
            rule = ConstraintRule(raw)
            for a, b in product(self.values, repeat=2):
                for partial in ({}, {'a': a}, {'b': b}, {'a': a, 'b': b}):
                    completions = product([partial['a']] if 'a' in partial else self.values,
                                          [partial['b']] if 'b' in partial else self.values)
                    possible = any(predicate(left, right) for left, right in completions)
                    with self.subTest(raw=raw, partial=partial):
                        self.assertEqual(rule.can_still_be_satisfied(partial), possible)

    def test_known_falsey_roots_prune_but_unknown_does_not(self):
        rule = ConstraintRule('a')
        self.assertTrue(rule.can_still_be_satisfied({}))
        for value in self.values:
            self.assertEqual(rule.can_still_be_satisfied({'a': value}), bool(value))
        with self.assertRaises(ConstraintEvaluationError):
            rule.evaluate({})

    def test_implication_trigger_uses_same_known_truth_as_evaluation(self):
        rule = ConstraintRule('a => b')
        for value in self.values:
            self.assertEqual(rule.is_triggered({'a': value, 'b': True}), bool(value))
        with self.assertRaises(ConstraintEvaluationError):
            rule.is_triggered({'b': True})

    def test_pairwise_uses_independent_feasible_pairs_for_non_boolean_operands(self):
        domains = {'a': ['', 'x'], 'b': ['', 'y'], 'c': ['0', '1']}
        names = list(domains)
        for raw, predicate in self.predicates:
            feasible = [dict(zip(names, vals)) for vals in product(*domains.values())
                        if predicate(vals[0], vals[1])]
            expected = {(left, row[left], right, row[right]) for row in feasible
                        for left, right in combinations(names, 2)}
            result = generate_constraint_aware_pairwise(domains, ConstraintSolver([raw]))
            with self.subTest(raw=raw):
                self.assertEqual(result.feasible_pairs, expected)
                self.assertEqual(result.covered_pairs, expected)
                self.assertTrue(all(predicate(row['a'], row['b']) for row in result.suite))
        with self.assertRaises(PairwiseGenerationError):
            generate_constraint_aware_pairwise(domains, ConstraintSolver(["'' and a == 'x'"]))


if __name__ == '__main__':
    unittest.main()
