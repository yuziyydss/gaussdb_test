"""Mock-only proof: absence precheck does not own a failed CREATE target."""
import inspect,json
from pathlib import Path
import unittest
from unittest.mock import Mock
from core.executor import Executor,ExecConfig
from core.generator import GeneratedCase

ROOT=Path(__file__).resolve().parents[1]

class TargetCreateCleanupSafetyTests(unittest.TestCase):
    def simulate(self,sql='CREATE TABLE own_target (id INTEGER);',failure=True,expected='success',teardown=True):
        class TargetError(Exception):pgcode='42710'
        cursor=Mock();executed=[]
        def execute(statement):
            executed.append(statement)
            if statement==sql and failure:raise TargetError('target failed')
        cursor.execute.side_effect=execute
        e=Executor(ExecConfig(enabled=True,use_sandbox=False));e.connect=Mock(side_effect=AssertionError('real DB forbidden'))
        e._conn=Mock();e._conn.cursor.return_value=cursor;e._check_alive=Mock(return_value=True)
        case=GeneratedCase('cleanup_probe','mock-create-failure','full',{},sql,expected=expected,
            expected_sqlstates=['42710'] if expected=='error' else [],
            setup_sqls=['CREATE TABLE owned_source (id INTEGER);'],
            teardown_sqls=['DROP TABLE own_target;','DROP TABLE owned_source;'] if teardown else [])
        result=e.execute_one(case);e.connect.assert_not_called()
        return case,result,executed

    def test_failed_create_preserves_target_error_but_does_not_run_teardown(self):
        case,result,executed=self.simulate()
        self.assertEqual(executed,case.setup_sqls+[case.sql])
        self.assertEqual((result.status,result.actual_sqlstate,result.verdict),('error','42710','fail'))
        self.assertIn('CREATE target failed',result.cleanup_skipped_reason)

    def test_confirmed_negative_oracle_is_not_lifecycle_pass_when_cleanup_blocked(self):
        _,result,_=self.simulate(expected='error')
        self.assertEqual(result.actual_sqlstate,'42710')
        self.assertEqual(result.verdict,'pending')
        self.assertTrue(result.cleanup_skipped_reason)

    def test_comments_do_not_bypass_failed_create_guard(self):
        for prefix in ('-- note\n','/* note */ ','/* outer /* inner */ end */\n','\ufeff  '):
            case,result,executed=self.simulate(sql=prefix+'CREATE TABLE own_target (id INTEGER);')
            with self.subTest(prefix=prefix):
                self.assertEqual(executed,case.setup_sqls+[case.sql])
                self.assertTrue(result.cleanup_skipped_reason)

    def test_successful_plain_create_still_cleans(self):
        case,result,executed=self.simulate(failure=False)
        self.assertEqual(executed,case.setup_sqls+[case.sql]+case.teardown_sqls)
        self.assertEqual(result.verdict,'pass');self.assertEqual(result.cleanup_skipped_reason,'')

    def test_dml_target_failure_retains_existing_setup_cleanup(self):
        for prefix in ('','-- CREATE is only a comment\n','/* CREATE TABLE x */ '):
            case,result,executed=self.simulate(sql=prefix+'INSERT INTO owned_source VALUES (1);')
            with self.subTest(prefix=prefix):
                self.assertEqual(executed,case.setup_sqls+[case.sql]+case.teardown_sqls)
                self.assertEqual(result.verdict,'fail');self.assertEqual(result.cleanup_skipped_reason,'')

    def test_cleanup_block_does_not_hide_wrong_target_oracle(self):
        _,result,_=self.simulate(expected='error')
        result.expected_sqlstate='23505';result.expected_sqlstates=['23505'];result.compute_verdict()
        self.assertEqual(result.verdict,'fail')

    def test_no_teardown_obligation_does_not_invent_cleanup_failure(self):
        _,result,_=self.simulate(expected='error',teardown=False)
        self.assertEqual(result.verdict,'pass');self.assertEqual(result.cleanup_skipped_reason,'')

    def test_report_records_pending_cleanup_not_zero_residue(self):
        import tempfile
        from core.reporter import generate_report
        case,result,_=self.simulate(expected='error')
        with tempfile.TemporaryDirectory() as directory:
            html=Path(generate_report([case],[result],'cleanup_probe','full',directory))
            report=json.loads(html.with_suffix('.json').read_text())
            self.assertEqual(report['summary']['pending'],1)
            self.assertTrue(report['detail'][0]['cleanup_skipped_reason'])
            self.assertIn('清理未执行',html.read_text())

    def test_failed_resource_pool_create_does_not_authorize_drop(self):
        report=json.loads((ROOT/'generated/factor_packages/generation_report.json').read_text())
        raw=next(c for m in report['manifests'].values() for c in m['cases']
                 if c['factor_id']=='create_resource_pool' and c['expected']=='success')
        keys=set(inspect.signature(GeneratedCase).parameters)
        case=GeneratedCase(**{k:v for k,v in raw.items() if k in keys})
        caps={e['key']:e['allowed_values'][0] for e in case.environment_requirements}
        executor=Executor(ExecConfig(enabled=True,environment_capabilities=caps))
        executor.connect=Mock(side_effect=AssertionError('REAL DATABASE FORBIDDEN'))
        executor._conn=Mock();executor._check_alive=Mock(return_value=True)
        target_cursor,cleanup_cursor=Mock(),Mock()
        executor._conn.cursor.side_effect=[target_cursor,cleanup_cursor]
        class DuplicateTarget(Exception):pgcode='42710'
        def target_execute(sql):
            if sql==case.sql:raise DuplicateTarget('another actor created the target after absence precheck')
        target_cursor.execute.side_effect=target_execute
        result=executor.execute_one(case)
        executor.connect.assert_not_called()
        self.assertEqual(result.actual_sqlstate,'42710')
        self.assertEqual(result.status,'error')
        self.assertEqual(target_cursor.execute.call_count,len(case.setup_sqls)+1)
        self.assertTrue(case.teardown_sqls)
        self.assertEqual(cleanup_cursor.execute.call_count,0,
            'Successful absence precheck plus failed CREATE cannot authorize DROP of its target; mock only, no DB was connected.')

if __name__=='__main__':unittest.main()
