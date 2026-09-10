"""Actual seed rows supply generated inputs; fixture labels cannot do so."""
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write


class GeneratedSeededRowContractTests(unittest.TestCase):
    target = 'CREATE TABLE dst(a INT,b INT,total INT GENERATED ALWAYS AS(a+b) STORED)'
    source = 'CREATE TABLE src(x INT DEFAULT 7,y INTEGER DEFAULT 9)'
    seed = 'INSERT INTO src(x,y) VALUES(1,10),(2,20),(3,30)'
    query = 'INSERT INTO dst SELECT x,y FROM src WHERE x=1'
    update_seed = 'INSERT INTO dst(a,b) VALUES(2,9),(3,8)'
    update = 'UPDATE dst SET total=DEFAULT WHERE a=2'

    def inspect(self, sql=None, setup=None, scope='m_compat'):
        return inspect_write(self.query if sql is None else sql,
            [self.source,self.seed,self.target] if setup is None else setup,
            conflict_source_scope=scope)

    def test_seeded_query_checks_actual_projection_and_generated_sum(self):
        for sql in (self.query, 'INSERT dst(b,a) SELECT y,x FROM src WHERE x=1',
                    'INSERT INTO dst SELECT y,x FROM src WHERE y=20'):
            result=self.inspect(sql)
            self.assertEqual(result['status'],'checked',result)
            self.assertIn('stored_generated_integer_sum',result['checks'])
            self.assertIn('fixture_seeded_projection',result['checks'])

    def test_update_reuses_seeded_inputs_but_does_not_treat_default_as_null(self):
        for predicate in ('a=2','b=8'):
            result=self.inspect('UPDATE dst SET total=DEFAULT WHERE '+predicate,
                                [self.target,self.update_seed])
            self.assertEqual(result['status'],'checked',result)
            self.assertIn('fixture_seeded_generated_update',result['checks'])
            self.assertNotIn('shared_constant_or_null_defaults',result['checks'])

    def test_query_needs_fresh_complete_actual_seed_history(self):
        for setup in ([self.source,self.target], [self.seed,self.source,self.target],
                      [self.source,self.seed,self.target,self.seed],
                      [self.source,self.seed,self.target,'TRUNCATE src'],
                      [self.source,self.seed,self.target,'UPDATE src SET x=9'],
                      [self.source,self.seed,self.target,'SET search_path=elsewhere'],
                      [self.source,self.seed,self.target,'ALTER TABLE src ADD z INT']):
            self.assertEqual(self.inspect(setup=setup)['status'],'needs_review')

    def test_query_does_not_guess_unsupported_selection_or_expressions(self):
        for sql in ('INSERT INTO dst SELECT x,y FROM src',
                    'INSERT INTO dst SELECT x,y FROM src WHERE x<2',
                    'INSERT INTO dst SELECT x,y FROM src WHERE missing=1',
                    'INSERT INTO dst SELECT x+1,y FROM src WHERE x=1',
                    'INSERT INTO dst SELECT x,y FROM src WHERE x=1 ORDER BY y',
                    'INSERT INTO dst SELECT x,y FROM src WHERE x=1 UNION SELECT 1,2',
                    'INSERT INTO dst SELECT x,y FROM src WHERE x=1 ON DUPLICATE KEY UPDATE a=2'):
            self.assertNotIn('fixture_seeded_projection',self.inspect(sql)['checks'])

    def test_seed_arity_null_default_type_range_and_generated_expression_are_not_guessed(self):
        for seed in ('INSERT INTO src(x) VALUES(1)', 'INSERT INTO src(x,y) VALUES(NULL,10)',
                     'INSERT INTO src(x,y) VALUES(DEFAULT,10)',
                     "INSERT INTO src(x,y) VALUES('1',10)",
                     'INSERT INTO src(x,y) VALUES(2147483648,0)',
                     'INSERT INTO src(x,y) VALUES(1,2147483647)'):
            self.assertEqual(self.inspect(setup=[self.source,seed,self.target])['status'],'needs_review')
        for target in (self.target.replace('STORED','VIRTUAL'),self.target.replace('a+b','a-b')):
            self.assertEqual(self.inspect(setup=[self.source,self.seed,target])['status'],'needs_review')

    def test_update_unknown_history_or_additional_assignments_not_inferred(self):
        for setup in ([self.target], [self.update_seed,self.target],
                      [self.target,self.update_seed,'UPDATE dst SET a=10'],
                      [self.target,self.update_seed,self.update_seed]):
            self.assertEqual(self.inspect(self.update,setup)['status'],'needs_review')
        for sql in ('UPDATE dst SET a=2147483647,total=DEFAULT WHERE a=2',
                    'UPDATE dst SET total=DEFAULT WHERE a>2',
                    'UPDATE dst SET total=DEFAULT WHERE missing=2',
                    'UPDATE dst SET total=DEFAULT WHERE a=2 LIMIT 1'):
            self.assertNotIn('fixture_seeded_generated_update',
                self.inspect(sql,[self.target,self.update_seed])['checks'])

    def test_generated_literal_negative_is_not_reclassified(self):
        for value in ('NULL','99'):
            result=self.inspect(self.update.replace('DEFAULT',value),[self.target,self.update_seed])
            self.assertEqual(result['status'],'rejected',result)
            self.assertEqual(result['issues'][0]['code'],'generated_column_write')

    def test_unknown_modes_and_missing_seed_matches_stay_review(self):
        for scope in ('unreviewed',):
            self.assertEqual(self.inspect(scope=scope)['status'],'needs_review')
        self.assertEqual(self.inspect(self.query.replace('x=1','x=999'))['status'],'needs_review')

    def test_actual_two_candidates_are_checked_without_changing_expected_or_oracle(self):
        root=Path(__file__).resolve().parents[1]
        report=json.loads((root/'generated/factor_packages/generation_report.json').read_text())
        for mid in ('manifest_m_insert_generated_omitted_query','manifest_m_update_generated_default'):
            case=report['manifests'][mid]['cases'][0]
            result=self.inspect(case['sql'],case['setup_sqls'])
            self.assertEqual(result['status'],'checked',result)
            self.assertEqual(case['expected_scope'],'syntax_only')
            self.assertEqual(case['expected_sqlstates'],[])

    def test_literal_evidence_keeps_query_and_update_runtime_unproved(self):
        from core.generated_column_contract import inspect_stored_seeded_write
        from core.finite_sql_contract import ddl_tables
        for sql,setup,values in ((self.query,[self.source,self.seed,self.target],[11]),
                                (self.update,[self.target,self.update_seed],[11])):
            evidence=inspect_stored_seeded_write(sql,setup,ddl_tables(setup),'m_compat')
            self.assertEqual(evidence['generated_values'],values)
            self.assertFalse(evidence['runtime_proven'])

    def test_all_setup_rows_are_valid_even_when_where_would_not_select_them(self):
        invalid_source='INSERT INTO src(x,y) VALUES(1,10),(2,2147483648)'
        self.assertEqual(self.inspect(setup=[self.source,invalid_source,self.target])['status'],'needs_review')
        invalid_generated_seed='INSERT INTO dst(a,b) VALUES(2,9),(2147483647,1)'
        self.assertEqual(self.inspect(self.update,[self.target,invalid_generated_seed])['status'],'needs_review')

    def test_reordered_seed_columns_and_schema_names_use_actual_identity(self):
        result=self.inspect(setup=[self.source,'INSERT INTO src(y,x) VALUES(10,1)',self.target])
        self.assertEqual(result['status'],'checked',result)
        setup=[self.source.replace('src','ns.src'),self.seed.replace('src','ns.src'),
               self.target.replace('dst','ns.dst')]
        result=self.inspect(self.query.replace('dst','ns.dst').replace('src','ns.src'),setup)
        self.assertEqual(result['status'],'checked',result)
        for source in (self.source.replace('DEFAULT 7',"DEFAULT app.f()"),
                       self.source.replace('DEFAULT 9','DEFAULT 2147483648'),
                       self.source.replace('x INT','x BIGINT')):
            self.assertNotEqual(self.inspect(setup=[source,self.seed,self.target])['status'],'checked')


if __name__=='__main__':
    unittest.main()
