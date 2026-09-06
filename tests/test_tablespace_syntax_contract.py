"""Grammar repair does not provision a server directory or permit execution."""
from pathlib import Path
import unittest

from core.factor_package_model import FactorPackageRegistry

ROOT = Path(__file__).resolve().parents[1]


class TablespaceSyntaxContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT / 'specs')
        cls.registry.load_all()

    def test_required_target_location_and_action_are_not_optional(self):
        for fid, required in [('create_tablespace', ('tablespace_name', 'directory')),
                              ('alter_tablespace', ('tablespace_name', 'action')),
                              ('drop_tablespace', ('tablespace_name',))]:
            syntax = self.registry.syntaxes['syntax_' + fid]
            for slot in required:
                self.assertFalse(syntax.slots[slot].optional, (fid, slot))

    def test_maxsize_is_a_separate_optional_clause_before_with_options(self):
        syntax = self.registry.syntaxes['syntax_create_tablespace']
        self.assertIn('maxsize', syntax.slots)
        self.assertTrue(syntax.slots['maxsize'].optional)
        self.assertEqual(syntax.production_placeholders(),
                         {'tablespace_name', 'owner', 'relative', 'directory', 'maxsize', 'options'})
        # Unit-test-only template substitution: not a manifest/case or real path.
        bindings = dict(tablespace_name='unit_test_tablespace', owner='', relative='RELATIVE',
                        directory="'unit_test/no_asset'", maxsize="MAXSIZE '10GB'",
                        options='WITH (seq_page_cost = 1)')
        rendered = ' '.join(syntax.production.format(**bindings).split())
        self.assertEqual(rendered, "CREATE TABLESPACE unit_test_tablespace RELATIVE LOCATION "
                         "'unit_test/no_asset' MAXSIZE '10GB' WITH (seq_page_cost = 1)")
        bindings.update(maxsize='', options='')
        self.assertNotIn('MAXSIZE', syntax.production.format(**bindings))
        self.assertIn('create_tablespace_fact_grammar_line_28', syntax.source_fact_refs)

    def test_no_fake_fixture_or_manifest_and_original_conflicts_remain(self):
        for fid in ('create_tablespace', 'alter_tablespace', 'drop_tablespace'):
            factor = self.registry.factors[fid]
            self.assertEqual(factor.manifest_refs, [])
            self.assertEqual(factor.fixture_refs, [])
            self.assertEqual(factor.status, 'needs_review')
            self.assertEqual(self.registry.syntaxes[factor.syntax_ref].status, 'draft')
        facts = {f.id: f for f in self.registry.factors['create_tablespace'].facts}
        for fid in ('create_tablespace_fact_privilege_conflict', 'create_tablespace_fact_maxsize_conflict',
                    'create_tablespace_fact_runtime_contract'):
            self.assertEqual(facts[fid].status, 'needs_verification')


if __name__ == '__main__':
    unittest.main()
