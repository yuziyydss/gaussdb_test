"""One admitted multi-column MODIFY shape, not a blanket B-mode or runtime claim."""
from pathlib import Path
import unittest

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError
from core.factor_package_model import FactorPackageRegistry
from core.shared_column_contract import ordinary_columns

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_alter_table_modify_multi_fresh'


class AlterTableModifyMultiTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()
        cls.generator = FactorPackageSQLGenerator(cls.registry)

    def case(self):
        manifest = self.registry.manifests[MID]
        cases, report = self.generator.generate_with_report(manifest)
        self.assertEqual(len(cases), 1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(manifest.status, 'needs_review')
        self.assertEqual(manifest.expected.scope, 'syntax_only')
        return cases[0]

    def test_single_actual_sql_and_fixture_have_real_before_state(self):
        case = self.case()
        self.assertEqual(case.sql, 'ALTER TABLE t_at_modify_multi MODIFY (note VARCHAR(96), amount NOT NULL);')
        self.assertEqual(case.setup_sqls, [
            'CREATE TABLE t_at_modify_multi (id INTEGER,note VARCHAR(64),amount INTEGER);',
            "INSERT INTO t_at_modify_multi VALUES (1,'alpha',10),(2,'beta',20);"])
        self.assertEqual(case.teardown_sqls, ['DROP TABLE t_at_modify_multi;'])
        columns = ordinary_columns(case.setup_sqls[0])
        self.assertEqual(set(columns), {'id', 'note', 'amount'})
        self.assertTrue(columns['amount']['nullable'])
        self.assertEqual(columns['note']['length'], 64)
        self.assertEqual(columns['note']['default_state'], 'absent')
        self.assertNotIn('CASCADE', ' '.join(case.setup_sqls+case.teardown_sqls))
        self.assertEqual(set(case.consumed_dimension_ids),
                         {'statement_form','ddl_mode','if_exists','table_profile','modify_column_items'})

    def test_declared_source_column_is_required_by_real_generator(self):
        manifest = self.registry.manifests[MID]
        fixture = self.registry.fixtures['fixture_alter_table_modify_multi_fresh']
        original = fixture.provides.tables[0].columns
        try:
            fixture.provides.tables[0].columns = [c for c in original if c.name != 'note']
            with self.assertRaises(GenerationValidationError):
                self.generator.generate_with_report(manifest)
        finally:
            fixture.provides.tables[0].columns = original

    def test_admission_does_not_extend_to_old_target_or_online(self):
        manifest = self.registry.manifests[MID]
        factor = self.registry.factors['alter_table']
        resolved = self.registry.resolve_dimension_values('alter_table')
        solver = self.generator._build_solver(factor,manifest,resolved)
        combo = {d: values[0] for d, values in self.generator.build_param_space(factor,manifest).items()}
        self.assertTrue(solver.is_valid(combo)[0])
        self.assertFalse(solver.is_valid(dict(combo,table_profile='at_table_regular'))[0])
        self.assertFalse(solver.is_valid(dict(combo,ddl_mode='at_mode_online'))[0])
        self.assertEqual(resolved['statement_form']['at_statement_modify_multi'].validity, 'conditional')

    def test_source_and_remaining_semantic_obligations_are_not_erased(self):
        self.case()
        facts = {f.id: f for f in self.registry.factors['alter_table'].facts}
        self.assertEqual(facts['at_fact_modify_multi_syntax'].source_anchor, 'L359-L361 column_clause/MODIFY 多列')
        self.assertEqual(facts['at_fact_modify_multi_statistics'].source_anchor, 'L362-L363 column_clause/MODIFY 多列')
        self.assertEqual(facts['at_open_modify_multi_contract'].status, 'needs_verification')
        scenario = self.registry.scenarios['scenario_alter_table_modify_multi_fresh']
        self.assertEqual(scenario.status, 'planned')
        audit = FactorCoverageAuditor(self.registry).audit('alter_table')
        self.assertEqual(audit['values']['valid_unselected'], [])
        self.assertEqual(len(audit['facts']['unresolved_open_questions']),21)
        self.assertEqual(audit['facts']['wrong_consumer_type'], [])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__ == '__main__':
    unittest.main()
