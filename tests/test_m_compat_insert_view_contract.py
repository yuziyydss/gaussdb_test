"""Direct view target type evidence must come from surviving base lineage."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
ROOT = Path(__file__).resolve().parents[1]

class MInsertViewContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def generator(self):
        r = copy.copy(self.registry)
        r.matrices = dict(r.matrices)
        key = 'matrix_m_insert_target_profile'
        r.matrices[key] = copy.deepcopy(r.matrices[key])
        return FactorPackageSQLGenerator(r)

    def profile(self, g):
        return next(p for p in g.registry.matrices['matrix_m_insert_target_profile'].profiles
                    if p.id=='m_insert_target_profile_view')

    def generate(self, g, suffix='view'):
        return g.generate_with_report(g.registry.manifests['manifest_m_insert_'+suffix])[0]

    def setup_patch(self,g,transform):
        original = g._compile_fixture_lifecycle
        def changed(refs):
            setup, teardown = original(refs)
            return transform(setup), teardown
        return patch.object(g,'_compile_fixture_lifecycle',side_effect=changed)

    def test_view_target_types_cannot_override_base_declarations(self):
        for suffix in ('view','view_set','view_query'):
            g = self.generator()
            p = self.profile(g)
            p.properties['target_types'] = p.properties['available_types'] = ['NUMERIC','NUMERIC']
            with self.subTest(suffix=suffix), self.assertRaisesRegex(GenerationValidationError,'target_type_mismatch'):
                self.generate(g,suffix)

    def test_changed_base_type_is_not_hidden_by_view_profile(self):
        g = self.generator()
        with self.setup_patch(g,lambda setup:[s.replace('qty INT DEFAULT 9','qty BIGINT DEFAULT 9') for s in setup]):
            with self.assertRaisesRegex(GenerationValidationError,'target_type_mismatch'):
                self.generate(g)

    def test_table_cannot_impersonate_view_contract(self):
        g = self.generator()
        with self.setup_patch(g,lambda setup:[
                'CREATE TABLE m_b01_view(id INT, qty INT);' if s.startswith('CREATE VIEW m_b01_view ') else s
                for s in setup]):
            with self.assertRaisesRegex(GenerationValidationError,'target_kind_mismatch'):
                self.generate(g)

    def test_false_is_view_flag_cannot_bypass_view_rules(self):
        g = self.generator()
        self.profile(g).properties['is_view'] = False
        with self.assertRaisesRegex(GenerationValidationError,'target_kind_mismatch'):
            self.generate(g)

    def test_dependency_mutation_revokes_old_view_evidence(self):
        for tail in ('DROP TABLE m_b01_source CASCADE;',
                     'ALTER TABLE m_b01_source ALTER COLUMN qty TYPE BIGINT;',
                     'DROP VIEW m_b01_view;',
                     'ALTER VIEW m_b01_view RENAME TO renamed_view;'):
            g = self.generator()
            with self.subTest(tail=tail), self.setup_patch(g,lambda setup:setup+[tail]):
                with self.assertRaisesRegex(GenerationValidationError,'target_.*unknown'):
                    self.generate(g)

    def test_expression_view_is_not_direct_column_evidence(self):
        g = self.generator()
        with self.setup_patch(g,lambda setup:[s.replace('AS SELECT id,qty','AS SELECT id+1 AS id,qty') for s in setup]):
            with self.assertRaisesRegex(GenerationValidationError,'target_.*unknown'):
                self.generate(g)

    def test_formal_view_contract_preserves_all_existing_cases_and_mode(self):
        g = self.generator()
        p = self.profile(g)
        self.assertEqual(p.properties.get('target_column_contract'),'fixture_direct_view_columns')
        self.assertIn('m_insert_fact_view_column', p.fact_refs)
        cases = [c for mid in g.registry.factors['m_insert'].manifest_refs
                 for c in g.generate_with_report(g.registry.manifests[mid])[0]]
        string_cases = [c for c in cases if c.case_id.startswith('manifest_m_insert_string_utf8_')]
        original_cases = [c for c in cases if c not in string_cases]
        self.assertEqual(len(original_cases),26)
        self.assertEqual(len(string_cases),9)
        view = [c for c in cases if c.params['target_profile']=='m_insert_target_profile_view']
        self.assertEqual(len(view),9)
        self.assertTrue(all(any(r['key']=='compatibility_mode' and r['allowed_values']==['M']
                               for r in c.environment_requirements) for c in view))

class ViewTargetEvidenceBoundaryTests(unittest.TestCase):
    setup = ['CREATE TABLE src(a INT DEFAULT 7,b TEXT);',
             'CREATE VIEW v(x,y) AS SELECT a,b FROM src;']

    def check(self, setup=None):
        from core.shared_column_contract import check_rendered_insert_target
        return check_rendered_insert_target("INSERT INTO v VALUES(1,'a')",self.setup if setup is None else setup,
            profile_target='v',available_types=['INTEGER','TEXT'],available_count=2,
            target_types=['INTEGER','TEXT'],target_count=2,explicit_columns=False,
            contract='fixture_direct_view_columns',is_view=True)

    def test_renamed_view_columns_retain_original_base_identity(self):
        result = self.check()
        self.assertEqual(result['column_order'],['x','y'])
        self.assertEqual(result['column_origins'],{'x':('src','a'),'y':('src','b')})
        self.assertTrue(result['view_lineage'])
        self.assertFalse(result['input_conversion_proven'])
        self.assertFalse(result['runtime_proven'])

    def test_same_ddl_after_base_drop_does_not_restore_old_view(self):
        from core.finite_sql_contract import ReviewNeeded
        with self.assertRaisesRegex(ReviewNeeded,'target_source_unknown'):
            self.check(self.setup+['DROP TABLE src CASCADE;',self.setup[0]])

    def test_lineage_does_not_prove_view_default_inheritance(self):
        from core.finite_sql_contract import ddl_tables, ReviewNeeded
        from core.shared_column_contract import attach_shared_contracts, default_literal
        self.check()
        view = attach_shared_contracts(ddl_tables(self.setup),self.setup)['v']
        with self.assertRaisesRegex(ReviewNeeded,'default_unknown'):
            default_literal(view,'x')

if __name__ == '__main__':
    unittest.main()
