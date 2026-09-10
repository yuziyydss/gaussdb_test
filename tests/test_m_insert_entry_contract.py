"""M INSERT entry syntax must reach, not bypass, shared input contracts."""
import unittest
from pathlib import Path

from core.finite_sql_contract import inspect_write
from scripts.audit_rendered_sql_contracts import audit_report


class MInsertEntryContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT PRIMARY KEY,qty INT DEFAULT 7)']

    def inspect(self, sql, setup=None, scope='m_compat'):
        return inspect_write(sql, self.setup if setup is None else setup,
                             conflict_source_scope=scope)

    def test_optional_into_values_and_value_share_same_checks(self):
        for source in ('VALUES(1,DEFAULT)', 'VALUE(1,2),(3,4)', 'SELECT 1,2'):
            with self.subTest(source=source):
                explicit = self.inspect('INSERT INTO t '+source)
                omitted = self.inspect('INSERT t '+source)
                self.assertEqual(explicit['status'], 'checked', explicit)
                self.assertEqual(omitted, explicit)

    def test_optional_into_does_not_extend_general_source(self):
        self.assertEqual(self.inspect('INSERT t VALUES(1,2)', scope='general')['status'], 'needs_review')

    def test_optional_into_keeps_wrong_arity_and_missing_columns_visible(self):
        for sql, code in (('INSERT t(missing) VALUES(1)', 'missing_column'),
                          ('INSERT t(id,qty) VALUES(1)', 'arity'),
                          ('INSERT t(id,id) VALUES(1,2)', 'duplicate_column')):
            result = self.inspect(sql)
            self.assertEqual(result['status'], 'rejected', result)
            self.assertEqual(result['issues'][0]['code'], code)

    def test_optional_into_reaches_default_and_conflict_source_contracts(self):
        result = self.inspect('INSERT t VALUES(1,2) ON DUPLICATE KEY UPDATE qty=VALUES(qty),id=DEFAULT',
                              setup=['CREATE TABLE t(id INT DEFAULT 8,qty INT)'])
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('conflict_input_same_column_types', result['checks'])
        self.assertIn('shared_constant_or_null_defaults', result['checks'])
        result = self.inspect('INSERT t VALUES(1,DEFAULT)',
                              setup=['CREATE TABLE t(id INT,qty INT NOT NULL DEFAULT NULL)'])
        self.assertEqual(result['status'], 'rejected', result)
        self.assertEqual(result['issues'][0]['code'], 'null_not_allowed')

    def test_keywords_cannot_be_reinterpreted_as_target_tables(self):
        for word in ('IGNORE', 'ALL', 'FIRST', 'WHEN', 'INTO', 'SELECT', 'SET', 'VALUES', 'VALUE'):
            result = self.inspect(f'INSERT {word} VALUES(1,2)',
                                  setup=[f'CREATE TABLE {word}(id INT,qty INT)'])
            self.assertEqual(result['status'], 'needs_review', (word,result))

    def test_hints_and_ignore_semantics_stay_review(self):
        for sql in ('INSERT IGNORE INTO t VALUES(1,NULL)',
                    'INSERT IGNORE t VALUES(1,NULL)', 'INSERT /*+ hint */ t VALUES(1,2)'):
            self.assertEqual(self.inspect(sql)['status'], 'needs_review')

    def test_schema_qualified_target_is_preserved(self):
        result = self.inspect('INSERT app.t VALUES(1,2)',
                              setup=['CREATE TABLE app.t(id INT,qty INT)'])
        self.assertEqual(result['status'], 'checked', result)

    def test_actual_audit_routes_optional_into_to_m_only(self):
        cases = [dict(case_id=fid,factor_id=fid,expected='success',
                      sql='INSERT t VALUES(1,2)',setup_sqls=self.setup,teardown_sqls=[])
                 for fid in ('m_insert','insert')]
        result = audit_report({'manifests':{'test':{'cases':cases}}})
        self.assertEqual([c['write_contract']['status'] for c in result['cases']],
                         ['checked','needs_review'])
        self.assertFalse(result['database_executed'])


class MInsertEntryConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        cls.registry = FactorPackageRegistry(Path(__file__).resolve().parents[1] / 'specs')
        cls.registry.load_all()

    def test_existing_ordinary_generated_cases_reach_shared_contracts(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        generator = FactorPackageSQLGenerator(self.registry)
        for suffix in ('table','table_query','table_set','upsert_conflict'):
            cases, report = generator.generate_with_report(self.registry.manifests['manifest_m_insert_'+suffix])
            self.assertTrue(cases)
            self.assertTrue(report.pairwise_complete)
            for case in cases:
                result = inspect_write(case.sql, case.setup_sqls, conflict_source_scope='m_compat')
                self.assertEqual(result['status'], 'checked', (case.case_id,result))

    def test_opt_in_fixture_seed_uses_insert_not_update_omission_rules(self):
        from core.factor_package_generator import FactorPackageSQLGenerator
        from core.spec_generator import GenerationValidationError
        factor = self.registry.factors['m_create_table_select']
        FactorPackageSQLGenerator._validate_fixture_write_contract(factor, [
            'CREATE TABLE t(id INT NOT NULL,qty INT DEFAULT 7)', 'INSERT t SET id=1'])
        with self.assertRaisesRegex(GenerationValidationError, 'fixture_write_contradiction.*null_not_allowed'):
            FactorPackageSQLGenerator._validate_fixture_write_contract(factor, [
                'CREATE TABLE t(id INT NOT NULL,qty INT)', 'INSERT t SET qty=2'])


if __name__ == '__main__':
    unittest.main()
