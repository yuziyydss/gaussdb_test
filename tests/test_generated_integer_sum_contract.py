"""M stored generated values require actual new inputs, not ordinary DEFAULT."""
import json
import hashlib
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from core.finite_sql_contract import inspect_write


class GeneratedIntegerSumContractTests(unittest.TestCase):
    ddl = 'CREATE TABLE t(id INT,qty INT,g INT GENERATED ALWAYS AS(id+qty) STORED);'

    def inspect(self, sql, setup=None, scope='m_compat'):
        return inspect_write(sql, [self.ddl] if setup is None else setup,
                             conflict_source_scope=scope)

    def test_explicit_default_and_omitted_generated_value_have_a_shared_contract(self):
        for sql in ('INSERT INTO t VALUES(7,9,DEFAULT)', 'INSERT t VALUES(7,9)',
                    'INSERT INTO t(id,qty) VALUES(7,9)',
                    'INSERT INTO t(qty,id,g) VALUE(9,7,DEFAULT)'):
            with self.subTest(sql=sql):
                result = self.inspect(sql)
                self.assertEqual(result['status'], 'checked', result)
                self.assertIn('stored_generated_integer_sum', result['checks'])
                self.assertNotIn('shared_constant_or_null_defaults', result['checks'])

    def test_names_and_operand_order_are_actual_not_profile_labels(self):
        ddl = 'CREATE TABLE dst(left_col INTEGER,right_col INT,total INTEGER AS(right_col+left_col) STORED)'
        result = self.inspect('INSERT INTO dst(right_col,left_col) VALUES(4,-7)', [ddl])
        self.assertEqual(result['status'], 'checked', result)
        self.assertIn('stored_generated_integer_sum', result['checks'])

    def test_every_row_must_fit_input_and_generated_result_ranges(self):
        for values in ('(2147483647,1,DEFAULT)', '(2147483648,-1,DEFAULT)',
                       '(7,9,DEFAULT),(2147483647,1,DEFAULT)', '(NULL,9,DEFAULT)',
                       '(DEFAULT,9,DEFAULT)', '(7,app.unknown_fn(),DEFAULT)'):
            with self.subTest(values=values):
                self.assertEqual(self.inspect('INSERT INTO t VALUES'+values)['status'], 'needs_review')

    def test_literal_assignment_to_generated_column_stays_targeted_negative(self):
        for value in ('NULL','0','16'):
            result = self.inspect('INSERT INTO t VALUES(7,9,'+value+')')
            self.assertEqual(result['status'], 'rejected', result)
            self.assertEqual(result['issues'][0]['code'], 'generated_column_write')

    def test_no_storage_default_or_virtual_or_unknown_expression_inference(self):
        for ddl in (self.ddl.replace(' STORED',''), self.ddl.replace('STORED','VIRTUAL'),
                    self.ddl.replace('id+qty','id-qty'), self.ddl.replace('id+qty','id+g'),
                    self.ddl.replace('id+qty','app.unknown_fn(id)'),
                    self.ddl.replace('id INT','id INT DEFAULT 7')):
            with self.subTest(ddl=ddl):
                result = self.inspect('INSERT INTO t VALUES(7,9,DEFAULT)', [ddl])
                self.assertEqual(result['status'], 'needs_review', result)

    def test_extra_setup_and_cte_do_not_disappear_behind_new_input_math(self):
        for extra in ('INSERT INTO t(id,qty) VALUES(1,2)', 'ALTER TABLE t ALTER COLUMN id TYPE BIGINT',
                      'DROP TABLE t', 'CREATE INDEX i ON t(id)'):
            result = self.inspect('INSERT INTO t VALUES(7,9,DEFAULT)', [self.ddl,extra])
            self.assertEqual(result['status'], 'needs_review', result)
        result = self.inspect('WITH c AS(SELECT 1) INSERT INTO t VALUES(7,9,DEFAULT)')
        self.assertNotIn('stored_generated_integer_sum', result['checks'])

    def test_modes_and_nonliteral_statement_families_keep_existing_boundaries(self):
        for scope in ('unreviewed',):
            self.assertEqual(self.inspect('INSERT INTO t VALUES(7,9,DEFAULT)', scope=scope)['status'], 'needs_review')
        for sql in ('UPDATE t SET g=DEFAULT', 'INSERT INTO t SELECT 7,9',
                    'INSERT INTO t VALUES(7,9,DEFAULT) ON DUPLICATE KEY UPDATE id=8'):
            self.assertNotIn('stored_generated_integer_sum', self.inspect(sql)['checks'])

    def test_sql_token_boundaries_are_not_inferred_by_regex_backtracking(self):
        result = self.inspect('INSERT INTO tVALUES(7,9,DEFAULT)')
        self.assertNotEqual(result['status'],'checked',result)

    def test_integer_boundaries_and_long_zero_padding_are_checked_without_runtime_claim(self):
        for values in ('(2147483647,0,DEFAULT)', '(-2147483648,0,DEFAULT)',
                       '('+'0'*5000+'7,9,DEFAULT)'):
            result = self.inspect('INSERT INTO t VALUES'+values)
            self.assertEqual(result['status'],'checked',result)
        for values in ('(-2147483648,-1,DEFAULT)', '('+'9'*5000+',0,DEFAULT)'):
            self.assertEqual(self.inspect('INSERT INTO t VALUES'+values)['status'],'needs_review')

    def test_actual_candidates_have_distinct_literal_and_seeded_provenance(self):
        from core.generated_column_contract import inspect_stored_integer_insert
        from core.finite_sql_contract import ddl_tables
        path = Path(__file__).resolve().parents[1]/'generated/factor_packages/generation_report.json'
        report = json.loads(path.read_text())
        mids = ('manifest_m_insert_generated','manifest_m_insert_generated_omitted_values',
                'manifest_m_insert_generated_omitted_query','manifest_m_update_generated_default')
        statuses, literal_supported = [], []
        for mid in mids:
            cases = report['manifests'][mid]['cases']
            self.assertEqual(len(cases),1)
            case = cases[0]
            self.assertEqual(case['expected'],'success')
            statuses.append(self.inspect(case['sql'],case['setup_sqls'])['status'])
            literal_supported.append(inspect_stored_integer_insert(case['sql'],case['setup_sqls'],
                ddl_tables(case['setup_sqls']),'m_compat') is not None)
        self.assertEqual(statuses,['checked']*4)
        self.assertEqual(literal_supported,[True,True,False,False])

    def test_arithmetic_evidence_is_finite_and_not_a_database_oracle(self):
        from core.generated_column_contract import inspect_stored_integer_insert
        from core.finite_sql_contract import ddl_tables
        sql = 'INSERT INTO t VALUES(7,9,DEFAULT),(-7,4,DEFAULT)'
        evidence = inspect_stored_integer_insert(sql, [self.ddl], ddl_tables([self.ddl]), 'm_compat')
        self.assertEqual(evidence['generated_values'],[16,-3])
        self.assertFalse(evidence['runtime_proven'])

    def test_cli_audit_fingerprints_the_actual_generated_checker(self):
        root = Path(__file__).resolve().parents[1]
        case = dict(factor_id='m_insert',case_id='generated_sum_fingerprint',
                    sql='INSERT INTO t VALUES(7,9,DEFAULT)',setup_sqls=[self.ddl],
                    teardown_sqls=[],expected='success')
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory)/'report.json'
            output = Path(directory)/'audit.json'
            source.write_text(json.dumps({'manifests':{'m':{'cases':[case]}}}))
            result = subprocess.run([sys.executable,str(root/'scripts/audit_rendered_sql_contracts.py'),
                '--generation-report',str(source),'--output',str(output)],cwd=root,
                capture_output=True,text=True,timeout=30)
            self.assertEqual(result.returncode,0,result.stderr)
            report = json.loads(output.read_text())
            path = 'core/generated_column_contract.py'
            self.assertEqual(report['checker_files_sha256'].get(path),
                             hashlib.sha256((root/path).read_bytes()).hexdigest())


if __name__ == '__main__':
    unittest.main()
