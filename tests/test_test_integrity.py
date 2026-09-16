"""A disabled test must not masquerade as a passing regression."""
import ast
from pathlib import Path
import unittest


def bypasses(source):
    found = []
    for node in ast.walk(ast.parse(source)):
        if not isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)) or not node.name.startswith('test_'):
            continue
        body = list(node.body)
        if body and isinstance(body[0], ast.Expr) and isinstance(body[0].value, ast.Constant) \
                and isinstance(body[0].value.value, str):
            body = body[1:]
        if body and isinstance(body[0], (ast.Return, ast.Pass)):
            found.append((node.name, node.lineno, 'unconditional_test_bypass'))
        for branch in ast.walk(node):
            if not isinstance(branch, ast.If) or not any(isinstance(s, ast.Continue) for s in branch.body):
                continue
            for values in ast.walk(branch.test):
                if isinstance(values, (ast.Tuple, ast.List, ast.Set)) and len(values.elts) >= 50 \
                        and all(isinstance(v, ast.Constant) and str(v.value).startswith('m_') for v in values.elts):
                    found.append((node.name, branch.lineno, 'blanket_package_skip'))
    return found


class TestIntegrityTests(unittest.TestCase):
    def test_current_suite_has_no_silent_entry_bypasses(self):
        errors = [(str(p), item) for p in Path(__file__).parent.glob('test_*.py')
                  for item in bypasses(p.read_text())]
        self.assertEqual(errors, [])

    def test_guard_detects_docstring_then_return(self):
        self.assertTrue(bypasses('def test_hidden():\n    "docs"\n    return\n    assert False\n'))
        self.assertFalse(bypasses('def test_real():\n    assert True\n'))
