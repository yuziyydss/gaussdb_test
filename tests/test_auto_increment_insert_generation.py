"""Mutations must not bypass the actual auto-column prerequisite."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError


class AutoIncrementInsertGenerationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)
        cls.m=cls.r.manifests['manifest_insert_autoincrement_fresh']

    def test_three_actual_triggers_have_independent_setup(self):
        cases, report=self.g.generate_with_report(self.m)
        self.assertEqual({c.sql for c in cases}, {
            f'INSERT INTO g_b_insert_autoinc (id, note) VALUES ({t}, 1);' for t in ['NULL','0','DEFAULT']})
        self.assertTrue(report.pairwise_complete)
        self.assertTrue(all(c.expected_scope=='syntax_only' and len(c.setup_sqls)==1 for c in cases))

    def test_omitted_auto_column_is_a_real_separate_candidate(self):
        from scripts.audit_rendered_sql_contracts import audit_report
        m=self.r.manifests['manifest_insert_autoincrement_omitted']
        cases, report=self.g.generate_with_report(m)
        self.assertEqual(len(cases),1)
        self.assertEqual(cases[0].sql,'INSERT INTO g_b_insert_autoinc (note) VALUES (1);')
        self.assertTrue(report.pairwise_complete)
        row=audit_report({'manifests':{m.id:{'cases':[vars(cases[0])]}}})['cases'][0]['write_contract']
        self.assertEqual(row['auto_increment']['allocation_trigger'],'omitted')
        self.assertFalse(row['auto_increment']['counter_value_proven'])

    def test_missing_auto_identity_cannot_be_ordinary_default(self):
        f=self.r.fixtures['fixture_insert_autoincrement_fresh'];old=list(f.execution.setup_sqls)
        try:
            f.execution.setup_sqls=[old[0].replace('PRIMARY KEY AUTO_INCREMENT','PRIMARY KEY DEFAULT 1')]
            with self.assertRaises(GenerationValidationError):self.g.generate_with_report(self.m)
        finally:f.execution.setup_sqls=old

    def test_removed_marker_and_m_mode_cannot_silently_fallthrough(self):
        p=next(p for p in self.r.matrices['matrix_insert_target_profiles'].profiles if p.id=='insert_target_autoincrement_fresh')
        marker=p.properties.pop('auto_increment_contract')
        try:
            with self.assertRaises(GenerationValidationError):self.g.generate_with_report(self.m)
        finally:p.properties['auto_increment_contract']=marker
        req=next(r for r in self.m.environment_requirements if r.key=='compatibility_mode')
        old=req.allowed_values
        try:
            req.allowed_values=['M']
            with self.assertRaises(GenerationValidationError):self.g.generate_with_report(self.m)
        finally:req.allowed_values=old

    def test_actual_history_and_misrendered_trigger_rejected(self):
        f=self.r.fixtures['fixture_insert_autoincrement_fresh'];old=list(f.execution.setup_sqls)
        try:
            f.execution.setup_sqls=old+['INSERT INTO g_b_insert_autoinc VALUES (100, 1);']
            with self.assertRaises(GenerationValidationError):self.g.generate_with_report(self.m)
        finally:f.execution.setup_sqls=old
        p=next(p for p in self.r.matrices['matrix_insert_source_profiles'].profiles if p.id=='insert_source_autoincrement_null')
        old=p.render
        try:
            p.render='VALUES (0, 1)'
            with self.assertRaises(GenerationValidationError):self.g.generate_with_report(self.m)
        finally:p.render=old
