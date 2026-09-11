"""Mutations must be rejected at the real generator/fixture boundary."""
import unittest
from pathlib import Path
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_alter_table_rowid_off_fresh'


class AlterRowidGenerationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_real_candidate_preserves_unexecuted_metadata_scope(self):
        cases,report=self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),1)
        c=cases[0]
        self.assertEqual(c.sql,'ALTER TABLE g_a3_at_rowid SET WITH ROWID;')
        self.assertEqual(c.expected_scope,'syntax_only')
        self.assertIn('hasrowid = off',c.setup_sqls[0])
        self.assertFalse(report.missing_pairs)
        self.assertEqual(self.r.scenarios['scenario_alter_table_rowid_off_fresh'].status,'planned')

    def test_actual_setup_already_on_cannot_fake_transition(self):
        original=self.g._compile_fixture_lifecycle
        def wrong(refs):
            setup,teardown=original(refs)
            return [s.replace('hasrowid = off','hasrowid = on') for s in setup],teardown
        with patch.object(self.g,'_compile_fixture_lifecycle',side_effect=wrong):
            with self.assertRaisesRegex(GenerationValidationError,'system_column_contract'):
                self.g.generate_with_report(self.r.manifests[MID])

    def test_missing_namespace_or_claimed_semantic_scope_is_not_admitted(self):
        for changed in ('namespace','scope'):
            m=self.r.manifests[MID].model_copy(deep=True)
            if changed=='namespace':m.environment_requirements=[r for r in m.environment_requirements if r.key!='case_namespace']
            else:m.expected.scope='syntax_and_semantics'
            with self.subTest(changed=changed),self.assertRaises(GenerationValidationError):
                self.g.generate_with_report(m)
