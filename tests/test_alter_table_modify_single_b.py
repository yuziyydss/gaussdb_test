"""B definition-replacement MODIFY has its own mode/GUC and actual column contract."""
import copy
import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]
MID = 'manifest_alter_table_modify_single_b_fresh'
FID = 'fixture_alter_table_modify_single_b_fresh'


class ModifySingleBTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def case(self):
        self.assertTrue(MID in self.r.manifests, MID)
        cases, report = self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases), 1)
        self.assertTrue(report.pairwise_complete)
        return cases[0]

    def test_real_definition_seed_and_exact_mode_switch(self):
        c = self.case()
        self.assertEqual(c.sql, 'ALTER TABLE g_at_modify_single MODIFY COLUMN note VARCHAR(96);')
        self.assertEqual(c.teardown_sqls, ['DROP TABLE g_at_modify_single;'])
        self.assertIn('note VARCHAR(48)', c.setup_sqls[0])
        self.assertIn("(2,NULL)", c.setup_sqls[1])
        self.assertEqual(c.expected_scope, 'syntax_only')
        gates = {g['key']: g['allowed_values'] for g in c.environment_requirements}
        self.assertEqual(gates['compatibility_mode'], ['B'])
        self.assertEqual(gates['b_format_enable_modify_column'], ['enabled'])

    def test_missing_wrong_expanded_or_duplicate_gates_fail(self):
        self.case()
        m = self.r.manifests[MID]; old = copy.deepcopy(m.environment_requirements)
        try:
            for key in ('compatibility_mode', 'b_format_enable_modify_column', 'namespace'):
                for mutation in ('missing', 'wrong', 'expanded', 'duplicate'):
                    m.environment_requirements = copy.deepcopy(old)
                    gate = next(g for g in m.environment_requirements if g.key == key)
                    if mutation == 'missing': m.environment_requirements.remove(gate)
                    elif mutation == 'wrong': gate.allowed_values = ['unknown']
                    elif mutation == 'expanded': gate.allowed_values.append('unknown')
                    else: m.environment_requirements.append(copy.deepcopy(gate))
                    with self.subTest(key=key, mutation=mutation), self.assertRaises(GenerationValidationError):
                        self.case()
        finally: m.environment_requirements = old

    def test_original_definition_seed_or_hidden_dependencies_are_not_trusted(self):
        self.case()
        f = self.r.fixtures[FID]; old = list(f.execution.setup_sqls)
        try:
            mutations = [[old[0].replace('VARCHAR(48)', definition), old[1]] for definition in (
                'VARCHAR(120)', 'TEXT', "VARCHAR(48) DEFAULT 'x'", 'VARCHAR(48) NOT NULL')]
            mutations += [[*old, 'CREATE INDEX hidden_idx ON g_at_modify_single(note);'],
                          [old[0], old[1].replace('alpha', 'a'*49)]]
            for setup in mutations:
                f.execution.setup_sqls = setup
                with self.subTest(setup=setup), self.assertRaises(GenerationValidationError): self.case()
        finally: f.execution.setup_sqls = old

    def test_cleanup_and_missing_contract_fail_closed(self):
        self.case()
        f = self.r.fixtures[FID]; old = list(f.execution.teardown_sqls)
        try:
            for sql in ('ROLLBACK;', 'DROP TABLE other;', 'DROP TABLE g_at_modify_single CASCADE;'):
                f.execution.teardown_sqls = [sql]
                with self.subTest(sql=sql), self.assertRaises(GenerationValidationError): self.case()
        finally: f.execution.teardown_sqls = old
        p = next(p for p in self.r.matrices['matrix_alter_table_table_profiles'].profiles if p.id == 'at_table_modify_single_b_fresh')
        contract = p.properties.pop('column_modify_single_contract')
        try:
            with self.assertRaises(GenerationValidationError): self.case()
        finally: p.properties['column_modify_single_contract'] = contract

    def test_wrong_target_column_or_new_definition_is_not_accepted(self):
        self.case()
        p = next(p for p in self.r.matrices['matrix_alter_table_action_profiles'].profiles if p.id == 'at_action_modify_single_b_fresh')
        old = copy.deepcopy(p.properties['items'])
        try:
            for item in ('MODIFY COLUMN missing VARCHAR(96)', 'MODIFY COLUMN note VARCHAR(16)',
                         'MODIFY COLUMN note VARCHAR(96) DEFAULT NULL', 'MODIFY (note VARCHAR(96))'):
                p.properties['items'] = [item]
                with self.subTest(item=item), self.assertRaises(GenerationValidationError): self.case()
        finally: p.properties['items'] = old

    def test_old_generic_and_metadata_are_not_marked_complete(self):
        self.case()
        original = self.r.resolve_dimension_values('alter_table')['action_profile']['at_action_modify_b']
        self.assertEqual(original.validity, 'conditional')
        self.assertEqual(self.r.scenarios['scenario_alter_table_modify_single_b_fresh'].status, 'planned')
        ledger = self.r.source_ledgers[self.r.factors['alter_table'].source_ledger_ref]
        for uid in ('at_pdf_su_049', 'at_pdf_su_050', 'at_pdf_su_051'):
            unit = next(u for u in ledger.units if u.id == uid)
            self.assertEqual(unit.status, 'open_question')
            self.assertEqual(unit.atomicity, 'grouped')

    def test_shared_actual_column_result_is_not_runtime_proof(self):
        from core.shared_column_contract import check_rendered_column_modify_single_b
        case = self.case()
        result = check_rendered_column_modify_single_b(case.sql, case.setup_sqls, case.teardown_sqls,
            profile_target='g_at_modify_single', widen_column='note',
            requirements=self.r.manifests[MID].environment_requirements)
        self.assertEqual(result['widening'], {'column': 'note', 'from_length': 48, 'to_length': 96})
        self.assertEqual(result['checked_seed_rows'], 2)
        self.assertFalse(result['database_executed'])
        self.assertFalse(result['dependent_rebuild_proven'])


if __name__ == '__main__': unittest.main()
