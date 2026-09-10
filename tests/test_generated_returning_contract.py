"""Compose proved generated inputs with separately proved RETURNING outputs."""
import unittest
from core.finite_sql_contract import inspect_write


class GeneratedReturningContractTests(unittest.TestCase):
    ddl='CREATE TABLE t(id INT,qty INT,total INT GENERATED ALWAYS AS(id+qty) STORED)'
    seed='INSERT INTO t(id,qty) VALUES(2,9),(3,8)'

    def inspect(self,sql,setup=None,scope='general'):
        return inspect_write(sql,[self.ddl] if setup is None else setup,conflict_source_scope=scope)

    def test_literal_default_and_omitted_insert_have_separate_output_evidence(self):
        for body in ('INSERT INTO t VALUES(2,9,DEFAULT)','INSERT INTO t(id,qty) VALUES(2,9)'):
            r=self.inspect(body+' RETURNING total AS computed')
            self.assertEqual(r['status'],'checked',r)
            self.assertIn('stored_generated_integer_sum',r['checks'])
            self.assertIn('finite_returning_output_columns',r['checks'])
            self.assertEqual(r['returning_output']['columns'],[{'name':'computed','type_family':'integer'}])

    def test_seeded_update_and_query_retain_their_own_input_provenance(self):
        examples=[('UPDATE t SET total=DEFAULT WHERE id=2',[self.ddl,self.seed],
                   'fixture_seeded_generated_update'),
                  ('INSERT INTO t SELECT x,y FROM src WHERE x=2',
                   ['CREATE TABLE src(x INT,y INT)','INSERT INTO src VALUES(2,9)',self.ddl],
                   'fixture_seeded_projection')]
        for body,setup,check in examples:
            r=self.inspect(body+' RETURNING *',setup)
            self.assertEqual(r['status'],'checked',r)
            self.assertIn(check,r['checks'])
            self.assertEqual([c['name'] for c in r['returning_output']['columns']],['id','qty','total'])

    def test_missing_output_cannot_be_hidden_by_successful_input_proof(self):
        for body,setup in [('INSERT INTO t VALUES(2,9,DEFAULT)',[self.ddl]),
                           ('UPDATE t SET total=DEFAULT WHERE id=2',[self.ddl,self.seed])]:
            r=self.inspect(body+' RETURNING missing',setup)
            self.assertEqual(r['status'],'rejected',r)
            self.assertEqual(r['issues'][0]['code'],'missing_column')

    def test_unproved_output_expressions_keep_review_and_mode_gate(self):
        for output in ('app.f(total)','NULL','CURRENT_DATE','src.total','total INTO dst',
                       'total; DELETE FROM t'):
            self.assertEqual(self.inspect('INSERT INTO t VALUES(2,9,DEFAULT) RETURNING '+output)['status'],
                             'needs_review',output)
        for scope in ('m_compat','unreviewed'):
            r=self.inspect('INSERT INTO t VALUES(2,9,DEFAULT) RETURNING total',scope=scope)
            self.assertEqual(r['issues'][0]['code'],'returning_source_unknown')

    def test_invalid_input_is_not_repaired_by_valid_returning(self):
        for values in ('(2147483647,1,DEFAULT)','(NULL,9,DEFAULT)','(DEFAULT,9,DEFAULT)'):
            self.assertEqual(self.inspect('INSERT INTO t VALUES'+values+' RETURNING total')['status'],'needs_review')
        r=self.inspect('INSERT INTO t VALUES(2,9,99) RETURNING total')
        self.assertEqual(r['issues'][0]['code'],'generated_column_write')

    def test_hidden_tail_and_seed_history_do_not_gain_finite_input_evidence(self):
        for sql in ('INSERT INTO t VALUES(2,9,DEFAULT) ON DUPLICATE KEY UPDATE id=4 RETURNING total',
                    'UPDATE t SET total=DEFAULT WHERE id=2 LIMIT 1 RETURNING total'):
            self.assertNotIn('stored_generated_integer_sum',self.inspect(sql,[self.ddl,self.seed])['checks'])
        r=self.inspect('UPDATE t SET total=DEFAULT WHERE id=2 RETURNING total',
                       [self.ddl,self.seed,'UPDATE t SET qty=100'])
        self.assertNotIn('stored_generated_integer_sum',r['checks'])


class GeneratedReturningProfilesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from pathlib import Path
        from core.factor_package_model import FactorPackageRegistry
        cls.registry=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs')
        cls.registry.load_all()

    def generate(self,fid):
        from core.factor_package_generator import FactorPackageSQLGenerator
        mid='manifest_'+fid+'_generated_returning'
        self.assertTrue(mid in self.registry.manifests,mid)
        return FactorPackageSQLGenerator(self.registry).generate_with_report(self.registry.manifests[mid])

    def test_six_actual_combinations_have_both_contracts(self):
        for fid,count in [('insert',4),('update',2)]:
            cases,report=self.generate(fid)
            self.assertEqual(len(cases),count)
            self.assertTrue(report.pairwise_complete)
            for c in cases:
                r=inspect_write(c.sql,c.setup_sqls)
                self.assertEqual(r['status'],'checked',r)
                self.assertIn('stored_generated_integer_sum',r['checks'])
                self.assertIn('finite_returning_output_columns',r['checks'])
                self.assertEqual(c.expected_scope,'syntax_only')

    def test_generator_rejects_forged_positive_output_and_restores_control(self):
        from core.spec_generator import GenerationValidationError
        for fid in ('insert','update'):
            self.generate(fid)
            dimension=self.registry.factors[fid].dimensions['returning_clause']
            value=next(v for cl in dimension.classes for v in cl.values if v.id==fid+'_returning_generated_total')
            before=value.render
            try:
                value.render=' RETURNING missing_output'
                with self.assertRaisesRegex(GenerationValidationError,'missing_column'):
                    self.generate(fid)
            finally:
                value.render=before
            self.generate(fid)

    def test_planned_oracle_captures_the_target_output_not_a_repeated_write(self):
        for fid in ('insert','update'):
            cases,_=self.generate(fid)
            prefix='scenario_'+fid+'_generated_returning_'
            scenarios=[s for s in self.registry.scenarios.values() if s.id.startswith(prefix)]
            self.assertEqual(len(scenarios),len(cases))
            self.assertEqual({s.steps[0]['sql'] for s in scenarios},{c.sql for c in cases})
            for s in scenarios:
                self.assertEqual(s.status,'planned')
                self.assertIn('target_statement_result_capture',s.execution_requirements)
                self.assertIn('database_authorization',s.execution_requirements)
                oracle=s.oracles[0]
                self.assertEqual(oracle['kind'],'result_set')
                self.assertEqual(oracle['step_id'],'target_write')
                self.assertNotIn('sql',oracle)
                self.assertEqual(oracle['expected'],[[2,9,11]] if 'RETURNING *' in s.steps[0]['sql'] else [[11]])


if __name__=='__main__': unittest.main()
