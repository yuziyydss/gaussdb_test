"""Actual AUTO_INCREMENT prerequisites must survive generator integration."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError


class AutoIncrementGenerationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)
        cls.m=cls.r.manifests['manifest_alter_table_autoincrement_fresh']

    def test_two_independent_fresh_candidates_keep_runtime_pending(self):
        cases, report=self.g.generate_with_report(self.m)
        self.assertEqual({c.sql for c in cases}, {'ALTER TABLE g_b_at_autoinc AUTO_INCREMENT = 10;',
                                                'ALTER TABLE g_b_at_autoinc AUTO_INCREMENT = 0;'})
        self.assertTrue(report.pairwise_complete)
        self.assertTrue(all(c.expected_scope=='syntax_only' for c in cases))
        self.assertTrue(all(len(c.setup_sqls)==1 for c in cases))
        self.assertEqual(self.r.scenarios['scenario_alter_table_autoincrement_fresh'].status,'planned')

    def test_ordinary_primary_key_cannot_fake_auto_column(self):
        f=self.r.fixtures['fixture_alter_table_autoincrement_fresh']
        old=list(f.execution.setup_sqls)
        try:
            f.execution.setup_sqls=[old[0].replace('PRIMARY KEY AUTO_INCREMENT','PRIMARY KEY')]
            with self.assertRaises(GenerationValidationError):
                self.g.generate_with_report(self.m)
        finally:f.execution.setup_sqls=old

    def test_prior_write_and_removed_contract_marker_are_rejected(self):
        f=self.r.fixtures['fixture_alter_table_autoincrement_fresh']
        p=next(p for p in self.r.matrices['matrix_alter_table_table_profiles'].profiles if p.id=='at_table_autoincrement_fresh')
        old=list(f.execution.setup_sqls)
        marker=p.properties.pop('auto_increment_contract')
        try:
            f.execution.setup_sqls=old+['INSERT INTO g_b_at_autoinc VALUES (100,1);']
            with self.assertRaises(GenerationValidationError):
                self.g.generate_with_report(self.m)
        finally:
            f.execution.setup_sqls=old
            p.properties['auto_increment_contract']=marker
