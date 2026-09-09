"""M index storage bounds must constrain rendered SQL, not just value IDs."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]

class MIndexFillfactorContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def generator(self):
        r = copy.copy(self.registry)
        r.factors = dict(r.factors)
        r.factors['m_create_index'] = copy.deepcopy(r.factors['m_create_index'])
        return FactorPackageSQLGenerator(r)

    def storage(self,g,suffix):
        return next(v for c in g.registry.factors['m_create_index'].dimensions['storage'].classes
                    for v in c.values if v.id=='m_create_index_storage_'+suffix)

    def generate(self,g,suffix='finite',manifest=None):
        return g.generate_with_report(manifest or g.registry.manifests['manifest_m_create_index_'+suffix])[0]

    def test_valid_label_cannot_hide_out_of_range_render(self):
        for number in (9,101):
            g = self.generator()
            self.storage(g,'min').render = f'WITH (fillfactor={number})'
            with self.subTest(number=number), self.assertRaisesRegex(GenerationValidationError,'index_fillfactor_range'):
                self.generate(g)

    def test_negative_label_requires_actual_target_violation(self):
        g = self.generator()
        self.storage(g,'below').render = 'WITH (fillfactor=70)'
        with self.assertRaisesRegex(GenerationValidationError,'index_fillfactor_target_not_violated'):
            self.generate(g,'fillfactor_below')

    def test_actual_renderer_cannot_diverge_from_selected_storage(self):
        g = self.generator()
        original = g._render_sql_with_consumption
        def changed(*args,**kwargs):
            sql, consumed = original(*args,**kwargs)
            return sql.replace('fillfactor=10','fillfactor=9'), consumed
        with patch.object(g,'_render_sql_with_consumption',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'index_storage_mismatch'):
                self.generate(g)

    def test_m_contract_requires_exact_mode_gate(self):
        for values in ([],['M','general']):
            g = self.generator()
            m = copy.deepcopy(g.registry.manifests['manifest_m_create_index_finite'])
            m.environment_requirements[0].allowed_values = values
            with self.subTest(values=values), self.assertRaisesRegex(GenerationValidationError,'index_fillfactor_mode'):
                self.generate(g,manifest=m)

    def test_registered_fact_guard_preserves_all_existing_candidates(self):
        g = self.generator()
        checks = g.registry.factors['m_create_index'].structural_checks
        self.assertTrue(any(c.kind=='index_fillfactor_contract' and
                            c.fact_refs==['m_create_index_fact_fillfactor'] for c in checks))
        positive = self.generate(g)
        negative = self.generate(g,'fillfactor_below')
        self.assertEqual((len(positive),len(negative)),(17,1))
        self.assertTrue(all(c.expected=='success' for c in positive))
        self.assertEqual(negative[0].expected_error_category,'fillfactor')
        self.assertFalse(negative[0].expected_sqlstates)
        self.assertIn('fillfactor=9',negative[0].sql)

    def test_negative_does_not_excuse_unknown_storage_or_render_mismatch(self):
        for render in ('WITH (fillfactor=9, other=1)', 'WITH (fillfactor=app.fn())'):
            g = self.generator()
            self.storage(g,'below').render = render
            with self.subTest(render=render), self.assertRaisesRegex(GenerationValidationError,'index_storage_unknown'):
                self.generate(g,'fillfactor_below')
        g = self.generator()
        original = g._render_sql_with_consumption
        def changed(*args,**kwargs):
            sql, consumed = original(*args,**kwargs)
            return sql.replace('fillfactor=9','fillfactor=70'), consumed
        with patch.object(g,'_render_sql_with_consumption',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'index_storage_mismatch'):
                self.generate(g,'fillfactor_below')

    def test_guard_cannot_borrow_an_unrelated_fact_or_unconfirmed_rule(self):
        for change in ('fact','status'):
            g = self.generator()
            f = g.registry.factors['m_create_index']
            check = next(c for c in f.structural_checks if c.kind=='index_fillfactor_contract')
            if change=='fact':
                check.fact_refs=['m_create_index_fact_method']
            else:
                next(fact for fact in f.facts if fact.id=='m_create_index_fact_fillfactor').status='needs_verification'
            with self.subTest(change=change), self.assertRaisesRegex(GenerationValidationError,'index_fillfactor_fact_rule'):
                self.generate(g)


class IndexStorageEvidenceBoundaryTests(unittest.TestCase):
    def check(self,sql,profile=''):
        from core.index_storage_contract import check_rendered_index_fillfactor
        return check_rendered_index_fillfactor(sql,profile)

    def test_bounds_are_inclusive_and_do_not_prove_runtime_engine_or_defaults(self):
        for value,valid in ((9,False),(10,True),(70,True),(100,True),(101,False)):
            fragment=f'WITH (fillfactor={value})'
            result=self.check('CREATE INDEX i ON t(a) '+fragment+';',fragment)
            self.assertEqual(result['range_valid'],valid)
            self.assertFalse(result['engine_proven'])
            self.assertFalse(result['runtime_proven'])
            self.assertFalse(result['key_contract_proven'])
            self.assertFalse(result['default_value_proven'])
        absent=self.check('CREATE INDEX i ON t(a);')
        self.assertIsNone(absent['fillfactor'])

    def test_comment_keywords_are_not_storage_and_numeric_format_is_not_identity(self):
        result=self.check("CREATE INDEX i ON t(a) COMMENT 'WITH (fillfactor=9); it''s data' LOCK DEFAULT;")
        self.assertIsNone(result['fillfactor'])
        result=self.check('CREATE UNIQUE INDEX i USING BTREE ON t(a) WITH (FILLFACTOR = +010) ALGORITHM=DEFAULT;',
                          'with (fillfactor=10)')
        self.assertEqual(result['fillfactor'],10)

    def test_unsupported_forms_never_become_a_range_proof(self):
        from core.finite_sql_contract import ReviewNeeded
        for sql,profile in (
            ('CREATE INDEX i ON t(a) WITH (fillfactor=9,fillfactor=70);','WITH (fillfactor=9)'),
            ('CREATE INDEX i ON t(a) WITH (fillfactor=10.5);','WITH (fillfactor=10.5)'),
            ('CREATE INDEX i ON t(a) LOCAL;',''),
            ('CREATE INDEX i ON t(a) ALGORITHM=INPLACE;',''),
            ('CREATE INDEX i ON t(a); DROP TABLE t;',''),
            ('CREATE INDEX "i" ON t(a);',''),
        ):
            with self.subTest(sql=sql), self.assertRaises(ReviewNeeded):
                self.check(sql,profile)
