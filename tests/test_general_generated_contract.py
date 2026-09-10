"""General chapter evidence, not automatic reuse of M entry grammar."""
import hashlib
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write, ddl_tables
from core.generated_column_contract import inspect_stored_integer_insert, inspect_stored_seeded_write


class GeneralGeneratedContractTests(unittest.TestCase):
    ddl = 'CREATE TABLE dst(id INT,qty INT,total INT GENERATED ALWAYS AS(id+qty) STORED)'
    source = 'CREATE TABLE src(x INT,y INT)'
    seed = 'INSERT INTO src VALUES(2,9),(3,8)'
    target_seed = 'INSERT INTO dst(id,qty) VALUES(2,9),(3,8)'

    def inspect(self, sql, setup=None, scope='general'):
        return inspect_write(sql, [self.ddl] if setup is None else setup,
                             conflict_source_scope=scope)

    def test_general_explicit_default_and_omission_use_actual_integer_inputs(self):
        for sql in ('INSERT INTO dst VALUES(2,9,DEFAULT)',
                    'INSERT INTO dst(id,qty) VALUES(2,9)',
                    'INSERT INTO dst VALUES(2,9)',
                    'INSERT INTO dst(qty,id,total) VALUES(9,2,DEFAULT),(4,-7,DEFAULT)'):
            result = self.inspect(sql)
            self.assertEqual(result['status'], 'checked', result)
            self.assertIn('stored_generated_integer_sum', result['checks'])
            self.assertNotIn('shared_constant_or_null_defaults', result['checks'])

    def test_general_seeded_select_and_update_prove_real_selected_inputs(self):
        cases = [
            ('INSERT INTO dst(id,qty) SELECT x,y FROM src WHERE x=2',
             [self.source,self.seed,self.ddl]),
            ('UPDATE dst SET total=DEFAULT WHERE id=2', [self.ddl,self.target_seed]),
        ]
        for sql, setup in cases:
            self.assertEqual(self.inspect(sql, setup)['status'], 'checked')
            evidence = inspect_stored_seeded_write(sql, setup, ddl_tables(setup), 'general')
            self.assertEqual(evidence['generated_values'], [11])
            self.assertFalse(evidence['runtime_proven'])

    def test_mode_specific_ddl_does_not_borrow_optional_m_generated_keywords(self):
        shortened = self.ddl.replace('GENERATED ALWAYS ', '')
        result = self.inspect('INSERT INTO dst VALUES(2,9,DEFAULT)', [shortened])
        self.assertNotIn('stored_generated_integer_sum', result['checks'])
        self.assertEqual(self.inspect('INSERT INTO dst VALUES(2,9,DEFAULT)',
                                     [shortened], 'm_compat')['status'], 'checked')

    def test_general_insert_requires_into_even_in_seed_history(self):
        sql = 'INSERT dst VALUES(2,9,DEFAULT)'
        self.assertNotEqual(self.inspect(sql)['status'], 'checked')
        self.assertEqual(self.inspect(sql, scope='m_compat')['status'], 'checked')
        for sql, setup in [
            ('INSERT dst SELECT x,y FROM src WHERE x=2', [self.source,self.seed,self.ddl]),
            ('INSERT INTO dst SELECT x,y FROM src WHERE x=2',
             [self.source,self.seed.replace('INSERT INTO','INSERT'),self.ddl]),
            ('UPDATE dst SET total=DEFAULT WHERE id=2',
             [self.ddl,self.target_seed.replace('INSERT INTO','INSERT')]),
        ]:
            self.assertNotIn('stored_generated_integer_sum', self.inspect(sql, setup)['checks'])

    def test_generated_direct_literal_or_null_is_targeted_negative(self):
        for value in ('99','NULL'):
            for sql, setup in [
                ('INSERT INTO dst VALUES(2,9,'+value+')',[self.ddl]),
                ('UPDATE dst SET total='+value+' WHERE id=2',[self.ddl,self.target_seed]),
            ]:
                result = self.inspect(sql, setup)
                self.assertEqual(result['status'], 'rejected', result)
                self.assertEqual(result['issues'][0]['code'], 'generated_column_write')

    def test_returning_is_proved_separately_and_conflict_tail_cannot_hide(self):
        valid=self.inspect('INSERT INTO dst VALUES(2,9,DEFAULT) RETURNING total')
        self.assertIn('finite_returning_output_columns',valid['checks'])
        invalid=self.inspect('INSERT INTO dst VALUES(2,9,DEFAULT) RETURNING missing')
        self.assertEqual(invalid['status'],'rejected')
        for tail in (' ON DUPLICATE KEY UPDATE qty=5',):
            self.assertNotIn('stored_generated_integer_sum', self.inspect('INSERT INTO dst VALUES(2,9,DEFAULT)'+tail)['checks'])
        for tail in (' RETURNING missing', ' LIMIT 1'):
            result = self.inspect('UPDATE dst SET total=DEFAULT WHERE id=2'+tail,
                                  [self.ddl,self.target_seed])
            self.assertNotIn('fixture_seeded_generated_update', result['checks'])

    def test_source_mode_and_generation_expression_still_have_explicit_limits(self):
        sql = 'INSERT INTO dst VALUES(2,9,DEFAULT)'
        for scope in ('unreviewed','pg','M'):
            self.assertNotIn('stored_generated_integer_sum', self.inspect(sql,scope=scope)['checks'])
        for ddl in (self.ddl.replace('STORED','VIRTUAL'),
                    self.ddl.replace('id+qty','id-qty'),
                    self.ddl.replace('GENERATED ALWAYS AS(id+qty) STORED','GENERATED ALWAYS AS IDENTITY')):
            self.assertNotIn('stored_generated_integer_sum', self.inspect(sql,[ddl])['checks'])

    def test_overflow_null_defaults_and_unknown_setup_do_not_become_checked(self):
        for values in ('(2147483647,1,DEFAULT)', '(NULL,9,DEFAULT)', '(DEFAULT,9,DEFAULT)'):
            self.assertEqual(self.inspect('INSERT INTO dst VALUES'+values)['status'], 'needs_review')
        for extra in ('ALTER TABLE dst ADD x INT', 'UPDATE dst SET id=1', 'SET search_path=other'):
            result = self.inspect('UPDATE dst SET total=DEFAULT WHERE id=2',
                                  [self.ddl,self.target_seed,extra])
            self.assertNotIn('stored_generated_integer_sum', result['checks'])

    def test_literal_calculation_is_not_a_runtime_oracle(self):
        sql = 'INSERT INTO dst VALUES(2,9,DEFAULT)'
        evidence = inspect_stored_integer_insert(sql,[self.ddl],ddl_tables([self.ddl]),'general')
        self.assertEqual(evidence['generated_values'], [11])
        self.assertFalse(evidence['runtime_proven'])

    def test_raw_values_null_identity_is_not_a_declared_type_guess(self):
        from core.shared_column_contract import finite_rendered_values_null_positions
        from core.finite_sql_contract import ReviewNeeded
        self.assertEqual(finite_rendered_values_null_positions('VALUES (2,9,NULL),(3,8,NULL)',3),{2})
        for raw in ("VALUES (2,9,'NULL')", 'VALUES (2,9,NULL),(3,8,99)',
                    'VALUES (2,9,CAST(NULL AS INTEGER))'):
            self.assertNotIn(2, finite_rendered_values_null_positions(raw,3))
        for raw in ('SELECT 2,9,NULL','VALUES (2,9,NULL) RETURNING NULL',
                    'VALUES (2,9,NULL); DELETE FROM dst','VALUES (2,9,NULL) /* ignored */',
                    'VALUES (2,NULL)','VALUES 2,9,NULL',
                    'VALUES (2,9,NULL) UNION VALUES (3,8,NULL)'):
            with self.assertRaises(ReviewNeeded):
                finite_rendered_values_null_positions(raw,3)

    def test_actual_local_general_sources_remain_hash_pinned(self):
        root=Path(__file__).resolve().parents[1]/'work/doc2spec/full_general_corpus/general'
        for rel,digest,phrase in [
            ('ddl/create_table.txt','72695d2ef4e74ead050103c403da14ae56d378333a41f421336d5e64a3215bc6',
             'STORED关键字可省略，与不省略STORED语义相同'),
            ('dml/insert.txt','5383f2eca79ecbe64ce3e880c8e3a2a39178a6bd93ca328401740bf36c16fae5','生成列不能被直接写入'),
            ('dml/update.txt','91336a8f0ba512576379ccc807be7ca0acf94a015ae07e14537f832d7ff61d25','生成列不能被直接写入'),
        ]:
            data=(root/rel).read_bytes()
            self.assertEqual(hashlib.sha256(data).hexdigest(),digest)
            self.assertIn(phrase,data.decode())


if __name__ == '__main__':
    unittest.main()
