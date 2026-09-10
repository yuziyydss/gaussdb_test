"""Actual MODIFY prerequisites, not merely declared fixture column names."""
from pathlib import Path
import unittest
from core import shared_column_contract as shared
from core.finite_sql_contract import Contradiction, ReviewNeeded
from core.factor_package_generator import FactorPackageSQLGenerator, GenerationValidationError
from core.factor_package_model import FactorPackageRegistry

DDL='CREATE TABLE t (id INTEGER,note VARCHAR(64),amount INTEGER);'
SEED="INSERT INTO t VALUES (1,'alpha',10),(2,'beta',20);"
SQL='ALTER TABLE t MODIFY (note VARCHAR(96), amount NOT NULL);'


class ModifyColumnContractTests(unittest.TestCase):
    def check(self,sql=SQL,setup=None,**kwargs):
        function=getattr(shared,'check_rendered_column_modify',None)
        self.assertTrue(callable(function),'Finite MODIFY consumer is missing')
        opts=dict(profile_target='t',widen_column='note',not_null_column='amount',source_scope='general')
        opts.update(kwargs)
        return function(sql,[DDL,SEED] if setup is None else setup,**opts)

    def test_actual_prerequisites_are_derived_from_ddl_sql_and_seed(self):
        result=self.check()
        self.assertEqual(result['before_columns'],['id','note','amount'])
        self.assertEqual(result['widening'],{'column':'note','from_length':64,'to_length':96})
        self.assertEqual(result['not_null_column'],'amount')
        self.assertEqual(result['checked_seed_rows'],2)
        self.assertFalse(result['database_executed'])

    def test_null_seed_is_an_actual_target_precondition_contradiction(self):
        for value in ('NULL','DEFAULT'):
            with self.subTest(value=value):
                with self.assertRaises(Contradiction) as raised:
                    self.check(setup=[DDL,SEED.replace('20)',value+')')])
                self.assertEqual(raised.exception.code,'column_modify_seed_null')

    def test_empty_fresh_table_needs_no_invented_seed_rows(self):
        self.assertEqual(self.check(setup=[DDL])['checked_seed_rows'],0)

    def test_source_length_must_prove_widening_not_narrowing(self):
        for ddl in (DDL.replace('VARCHAR(64)','VARCHAR(128)'),DDL.replace('VARCHAR(64)','TEXT')):
            with self.subTest(ddl=ddl),self.assertRaises(ReviewNeeded):self.check(setup=[ddl,SEED])

    def test_identity_and_exact_affected_columns_are_checked(self):
        for sql in (SQL.replace('TABLE t','TABLE other'),SQL.replace('amount NOT','missing NOT'),
                    SQL.replace('note VARCHAR','id VARCHAR')):
            with self.subTest(sql=sql),self.assertRaises(Contradiction):self.check(sql)

    def test_unknown_or_dependent_fixture_does_not_inherit_contract(self):
        for setup in ([DDL,SEED,'CREATE INDEX idx ON t(note);'],
                      [DDL.replace('amount INTEGER','amount INTEGER DEFAULT 9'),SEED],
                      [DDL,'INSERT INTO t SELECT id,note,amount FROM t;'],
                      [DDL,'INSERT INTO t VALUES (id,\'alpha\',10);']):
            with self.subTest(setup=setup),self.assertRaises(ReviewNeeded):self.check(setup=setup)

    def test_seed_text_must_fit_original_column_not_only_widened_column(self):
        for value in ('a'*80,'中文'):
            with self.subTest(value=value),self.assertRaises(ReviewNeeded):
                self.check(setup=[DDL,SEED.replace('alpha',value)])

    def test_item_order_can_change_but_target_column_order_does_not(self):
        result=self.check(SQL.replace('note VARCHAR(96), amount NOT NULL','amount NOT NULL,note VARCHAR(96)'))
        self.assertEqual(result['before_columns'],['id','note','amount'])
        self.assertEqual(result['checked_seed_rows'],2)

    def test_mode_and_other_modify_grammars_are_not_borrowed(self):
        with self.assertRaises(ReviewNeeded):self.check(source_scope='m_compat')
        for sql in (SQL.replace('MODIFY (','MODIFY COLUMN ('),SQL.replace('VARCHAR(96)','VARCHAR(96) DEFAULT \'x\''),
                    SQL.replace('amount NOT NULL','amount INTEGER'),SQL+' DROP TABLE t;',
                    SQL.replace('amount NOT NULL','amount NOT NULL, id NOT NULL')):
            with self.subTest(sql=sql),self.assertRaises(ReviewNeeded):self.check(sql)


class ModifyColumnConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_actual_generator_rejects_null_seed_even_if_provides_is_unchanged(self):
        fixture=self.r.fixtures['fixture_alter_table_modify_multi_fresh']
        original=fixture.execution.setup_sqls
        try:
            fixture.execution.setup_sqls=[original[0],original[1].replace('20)','NULL)')]
            with self.assertRaisesRegex(GenerationValidationError,'column_modify_seed_null'):
                self.g.generate_with_report(self.r.manifests['manifest_alter_table_modify_multi_fresh'])
        finally:fixture.execution.setup_sqls=original

    def test_actual_generator_requires_real_widening_and_no_dependency(self):
        fixture=self.r.fixtures['fixture_alter_table_modify_multi_fresh']
        original=fixture.execution.setup_sqls
        try:
            for setup in ([original[0].replace('VARCHAR(64)','VARCHAR(128)'),original[1]],
                          [*original,'CREATE INDEX idx ON t_at_modify_multi(note);']):
                fixture.execution.setup_sqls=setup
                with self.subTest(setup=setup),self.assertRaises(GenerationValidationError):
                    self.g.generate_with_report(self.r.manifests['manifest_alter_table_modify_multi_fresh'])
        finally:fixture.execution.setup_sqls=original


if __name__=='__main__':unittest.main()
