"""Actual index keys require surviving table declarations, not profile labels."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]

class MIndexKeyContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.registry = FactorPackageRegistry(ROOT/'specs')
        cls.registry.load_all()

    def generator(self):
        r=copy.copy(self.registry)
        r.factors=dict(r.factors)
        r.factors['m_create_index']=copy.deepcopy(r.factors['m_create_index'])
        return FactorPackageSQLGenerator(r)

    def key(self,g,suffix='id'):
        return next(v for c in g.registry.factors['m_create_index'].dimensions['key_profile'].classes
                    for v in c.values if v.id=='m_create_index_key_profile_'+suffix)

    def generate(self,g,suffix='finite'):
        return g.generate_with_report(g.registry.manifests['manifest_m_create_index_'+suffix])[0]

    def setup_patch(self,g,transform):
        original=g._compile_fixture_lifecycle
        def changed(refs):
            setup,teardown=original(refs)
            return transform(setup),teardown
        return patch.object(g,'_compile_fixture_lifecycle',side_effect=changed)

    def test_actual_key_cannot_hide_behind_existing_dependency_label(self):
        for suffix in ('finite',):
            g=self.generator()
            self.key(g).properties['items']=['missing_actual_key']
            with self.subTest(suffix=suffix), self.assertRaisesRegex(GenerationValidationError,'index_key_missing_column'):
                self.generate(g,suffix)

    def test_actual_renderer_must_match_selected_items_and_source(self):
        for before,after,error in (('ON m_b01_source (id','ON m_b01_source (qty','index_key_items_mismatch'),
                                   ('ON m_b01_source','ON another_table','index_source_identity_mismatch')):
            g=self.generator()
            original=g._render_sql_with_consumption
            def changed(*args,**kwargs):
                sql,consumed=original(*args,**kwargs)
                return sql.replace(before,after),consumed
            with self.subTest(after=after), patch.object(g,'_render_sql_with_consumption',side_effect=changed):
                with self.assertRaisesRegex(GenerationValidationError,error):
                    self.generate(g)

    def test_profile_count_and_dependency_columns_cannot_drift(self):
        for key,value,error in (('key_column_count',2,'index_key_count_mismatch'),
                                ('source_columns',['qty'],'index_key_columns_mismatch')):
            g=self.generator()
            self.key(g).properties[key]=value
            with self.subTest(key=key), self.assertRaisesRegex(GenerationValidationError,error):
                self.generate(g)

    def test_fixture_lifecycle_and_session_resolution_invalidate_evidence(self):
        for tail in ('DROP TABLE m_b01_source;', 'ALTER TABLE m_b01_source DROP COLUMN id;',
                     'SET search_path=elsewhere;', 'DO $$ BEGIN NULL; END $$;'):
            g=self.generator()
            with self.subTest(tail=tail), self.setup_patch(g,lambda setup:setup+[tail]):
                with self.assertRaisesRegex(GenerationValidationError,'index_source_unknown'):
                    self.generate(g)

    def test_real_fixture_column_removal_is_not_hidden_by_provides(self):
        g=self.generator()
        with self.setup_patch(g,lambda setup:[s.replace('id INT DEFAULT 7, ','') for s in setup]):
            with self.assertRaisesRegex(GenerationValidationError,'index_key_missing_column'):
                self.generate(g)

    def test_formal_source_fact_guard_preserves_existing_cases(self):
        g=self.generator()
        f=g.registry.factors['m_create_index']
        self.assertTrue(any(c.kind=='index_key_source_contract' and 'm_create_index_fact_key_source' in c.fact_refs
                            for c in f.structural_checks))
        self.assertEqual(len(self.generate(g)),17)

    def test_key_guard_independently_requires_confirmed_facts_and_m_gate(self):
        for change in ('fact','gate'):
            g=self.generator()
            f=g.registry.factors['m_create_index']
            f.structural_checks=[c for c in f.structural_checks if c.kind=='index_key_source_contract']
            m=copy.deepcopy(g.registry.manifests['manifest_m_create_index_finite'])
            if change=='fact':
                next(fact for fact in f.facts if fact.id=='m_create_index_fact_key_source').status='needs_verification'
                error='index_key_facts'
            else:
                m.environment_requirements=[]
                error='index_key_mode'
            with self.subTest(change=change), self.assertRaisesRegex(GenerationValidationError,error):
                g.generate_with_report(m)


class IndexKeyEvidenceBoundaryTests(unittest.TestCase):
    def check(self,sql,setup,items=('id',),source=('t',)):
        from core.index_storage_contract import check_rendered_index_keys
        return check_rendered_index_keys(sql,setup,items=list(items),key_count=len(items),
                                         source_tables=list(source),source_columns=list(items))

    def test_direct_column_provenance_does_not_prove_engine_or_method_type(self):
        result=self.check('CREATE INDEX i USING UBTREE ON t(ID DESC NULLS LAST);',['CREATE TABLE t(id INT);'])
        self.assertEqual(result['column_origins'],{'id':('t','id')})
        self.assertEqual(result['declaration_types'],['INT'])
        for name in ('ordering_proven','engine_proven','method_type_compatibility_proven','runtime_proven'):
            self.assertFalse(result[name])

    def test_actual_ordinary_key_limit_includes_32_but_not_33(self):
        from core.finite_sql_contract import Contradiction
        for count in (32,33):
            names=['c'+str(i) for i in range(count)]
            sql='CREATE INDEX i ON t('+','.join(names)+');'
            ddl='CREATE TABLE t('+','.join(n+' INT' for n in names)+');'
            if count==32:
                self.assertEqual(len(self.check(sql,[ddl],names)['keys']),32)
            else:
                with self.assertRaisesRegex(Contradiction,'Ordinary index has more than 32 keys'):
                    self.check(sql,[ddl],names)

    def test_fresh_recreated_ordinary_table_is_not_stale_view_lineage(self):
        setup=['CREATE TABLE t(id INT);','DROP TABLE t;','CREATE TABLE t(id BIGINT);']
        result=self.check('CREATE INDEX i ON t(id);',setup)
        self.assertEqual(result['declaration_types'],['BIGINT'])

    def test_unknown_source_and_complex_keys_never_gain_declaration_proof(self):
        from core.finite_sql_contract import ReviewNeeded
        ordinary=['CREATE TABLE t(id INT);']
        for sql,setup,items in (
            ('CREATE INDEX i ON t((id+1));',ordinary,['id']),
            ('CREATE INDEX i ON t(id(2));',ordinary,['id']),
            ('CREATE INDEX i ON t(id);',['CREATE TABLE t(id INT) PARTITION BY RANGE(id);'],['id']),
            ('CREATE INDEX i ON t(id);',['CREATE TABLE t(id INT GENERATED ALWAYS AS (1) STORED);'],['id']),
            ('CREATE INDEX i ON t(id);',['CREATE TABLE s(id INT);','CREATE VIEW t AS SELECT id FROM s;'],['id']),
            ('CREATE INDEX i ON t(id);',ordinary+ordinary,['id']),
        ):
            with self.subTest(sql=sql,setup=setup), self.assertRaises(ReviewNeeded):
                self.check(sql,setup,items)
