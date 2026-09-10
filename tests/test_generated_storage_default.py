"""General omitted STORED is explicit source evidence, not M default inference."""
import hashlib
from pathlib import Path
import unittest
from core.finite_sql_contract import inspect_write, ddl_tables
from core.generated_column_contract import inspect_stored_integer_insert, inspect_stored_seeded_write


class GeneratedStorageDefaultTests(unittest.TestCase):
    ddl='CREATE TABLE t(id INT,qty INT,total INT GENERATED ALWAYS AS(id+qty))'
    seed='INSERT INTO t(id,qty) VALUES(2,9),(3,8)'

    def inspect(self,sql,setup=None,scope='general'):
        return inspect_write(sql,[self.ddl] if setup is None else setup,conflict_source_scope=scope)

    def test_general_literal_default_omission_and_returning_share_the_same_contract(self):
        for sql in ('INSERT INTO t VALUES(2,9,DEFAULT)', 'INSERT INTO t VALUES(2,9)',
                    'INSERT INTO t(qty,id) VALUES(9,2) RETURNING total AS calculated'):
            r=self.inspect(sql)
            self.assertEqual(r['status'],'checked',r)
            self.assertIn('stored_generated_integer_sum',r['checks'])
        evidence=inspect_stored_integer_insert('INSERT INTO t VALUES(2,9,DEFAULT)',
                   [self.ddl],ddl_tables([self.ddl]),'general')
        self.assertEqual(evidence['generated_values'],[11])
        self.assertFalse(evidence['runtime_proven'])

    def test_general_query_and_update_need_real_seed_rows_even_without_storage_keyword(self):
        examples=[('UPDATE t SET total=DEFAULT WHERE id=2',[self.ddl,self.seed]),
                  ('INSERT INTO t SELECT x,y FROM src WHERE x=2',
                   ['CREATE TABLE src(x INT,y INT)','INSERT INTO src VALUES(2,9)',self.ddl])]
        for sql,setup in examples:
            self.assertEqual(self.inspect(sql+' RETURNING *',setup)['status'],'checked')
            evidence=inspect_stored_seeded_write(sql,setup,ddl_tables(setup),'general')
            self.assertEqual(evidence['generated_values'],[11])
            self.assertFalse(evidence['runtime_proven'])
        self.assertEqual(self.inspect('UPDATE t SET total=DEFAULT WHERE id=2')['status'],'needs_review')

    def test_m_omission_cannot_borrow_general_default_even_with_same_expression(self):
        for scope in ('m_compat','unreviewed'):
            for sql,setup in [('INSERT INTO t VALUES(2,9,DEFAULT)',[self.ddl]),
                              ('UPDATE t SET total=DEFAULT WHERE id=2',[self.ddl,self.seed])]:
                self.assertEqual(self.inspect(sql,setup,scope)['status'],'needs_review')
        explicit=self.ddl[:-1]+' STORED)'
        self.assertEqual(self.inspect('INSERT INTO t VALUES(2,9,DEFAULT)',[explicit],'m_compat')['status'],'checked')

    def test_unknown_generation_and_bad_inputs_remain_outside_finite_proof(self):
        for ddl in (self.ddl.replace('id+qty','id-qty'),self.ddl.replace('ALWAYS AS','AS'),
                    self.ddl[:-1]+' VIRTUAL)',self.ddl[:-1]+' DEFAULT 11)'):
            self.assertNotIn('stored_generated_integer_sum',self.inspect('INSERT INTO t VALUES(2,9,DEFAULT)',[ddl])['checks'])
        for values in ('(2147483647,1,DEFAULT)','(NULL,9,DEFAULT)','(DEFAULT,9,DEFAULT)'):
            self.assertEqual(self.inspect('INSERT INTO t VALUES'+values)['status'],'needs_review')

    def test_direct_generated_write_and_missing_returning_still_target_the_actual_error(self):
        for value in ('NULL','99'):
            r=self.inspect('INSERT INTO t VALUES(2,9,'+value+')')
            self.assertEqual(r['issues'][0]['code'],'generated_column_write')
        r=self.inspect('INSERT INTO t VALUES(2,9,DEFAULT) RETURNING missing')
        self.assertEqual(r['issues'][0]['code'],'missing_column')

    def test_general_and_m_body_evidence_explicitly_disagree_on_default_scope(self):
        root=Path(__file__).resolve().parents[1]
        general=(root/'work/doc2spec/full_general_corpus/general/ddl/create_table.txt').read_bytes()
        self.assertEqual(hashlib.sha256(general).hexdigest(),'72695d2ef4e74ead050103c403da14ae56d378333a41f421336d5e64a3215bc6')
        self.assertIn('STORED关键字可省略，与不省略STORED语义相同',general.decode())
        m=(root/'work/m_compat_batch_01/corpus/m_compat/ddl/create_table.txt').read_text()
        self.assertIn('s2条件下缺省为VIRTUAL',m)


class GeneratedStorageDefaultProfilesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        cls.registry=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.registry.load_all()

    def cases(self,fid):
        from core.factor_package_generator import FactorPackageSQLGenerator
        mid='manifest_'+fid+'_generated_storage_default'
        self.assertTrue(mid in self.registry.manifests,mid)
        return FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[mid])[0]

    def test_three_actual_profiles_reuse_input_contract_without_inventing_m_semantics(self):
        for fid,count in [('insert',2),('update',1)]:
            cases=self.cases(fid)
            self.assertEqual(len(cases),count)
            for c in cases:
                r=inspect_write(c.sql,c.setup_sqls)
                self.assertEqual(r['status'],'checked',r)
                self.assertIn('stored_generated_integer_sum',r['checks'])
                ddl=next(s for s in c.setup_sqls if s.startswith('CREATE TABLE'))
                self.assertIn('GENERATED ALWAYS AS',ddl)
                self.assertNotIn('STORED',ddl)
                self.assertEqual(c.expected_scope,'syntax_only')
                self.assertTrue(all('RESTRICT PURGE' in s for s in c.teardown_sqls))

    def test_storage_fact_has_its_own_atomic_source_unit_and_actual_consumers(self):
        factor=self.registry.factors['create_table']
        fact=next((f for f in factor.facts if f.id=='ct_fact_generated_storage_default'),None)
        self.assertIsNotNone(fact)
        self.assertEqual(fact.source_anchor,'L751')
        ledger=self.registry.source_ledgers[factor.source_ledger_ref]
        units=[u for u in ledger.units if u.line_start<=751<=u.line_end]
        self.assertEqual(len(units),1)
        self.assertEqual((units[0].line_start,units[0].line_end),(751,751))
        self.assertEqual(units[0].fact_refs,['ct_fact_generated_storage_default'])
        self.assertEqual(units[0].atomicity,'atomic')
        for fid in ('insert','update'):
            self.cases(fid)
            matrix=self.registry.matrices['matrix_insert_target_profiles' if fid=='insert' else 'matrix_update_single_targets']
            profile=next(p for p in matrix.profiles if p.id==fid+'_target_generated_storage_default')
            self.assertIn('create_table::ct_fact_generated_storage_default',profile.fact_refs)

    def test_planned_scenarios_are_independent_and_have_finite_expected_rows(self):
        for fid in ('insert','update'):
            cases=self.cases(fid)
            scenarios=[s for s in self.registry.scenarios.values() if s.id.startswith('scenario_'+fid+'_generated_storage_default_')]
            self.assertEqual({s.steps[0]['sql'] for s in scenarios},{c.sql for c in cases})
            for s in scenarios:
                self.assertEqual(s.status,'planned')
                self.assertIn('database_authorization',s.execution_requirements)
                self.assertEqual(s.oracles[0]['expected'],[[2,9,11]] if fid=='insert' else [[2,9,11],[3,8,11]])


if __name__=='__main__': unittest.main()
