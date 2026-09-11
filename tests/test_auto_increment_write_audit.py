"""The report must carry mode evidence; ordinary DEFAULT cannot supply it."""
from copy import deepcopy
import unittest
from core.finite_sql_contract import inspect_write
from scripts.audit_rendered_sql_contracts import audit_report
from tests.test_auto_increment_contract import DDL, DROP, GATES


def case(trigger='NULL'):
    return dict(case_id='auto_'+trigger, factor_id='insert', expected='success',
                params={'target_profile':'insert_target_autoincrement_fresh'},
                sql=f'INSERT INTO g_b_at_autoinc (id, note) VALUES ({trigger}, 1);',
                setup_sqls=[DDL], teardown_sqls=[DROP],
                environment_requirements=[{'key':k,'allowed_values':v,'fact_refs':[]} for k,v in GATES.items()])


def audit(c):
    return audit_report({'manifests':{'test':{'cases':[c]}}})['cases'][0]['write_contract']


class AutoIncrementWriteAuditTests(unittest.TestCase):
    def test_real_three_trigger_cases_gain_specific_evidence_not_runtime_pass(self):
        for trigger in ['NULL','0','DEFAULT']:
            result=audit(case(trigger))
            self.assertEqual(result['status'],'checked',result)
            self.assertIn('finite_b_auto_increment_allocation_input',result['checks'])
            self.assertEqual(result['auto_increment']['allocation_trigger'],trigger)
            self.assertFalse(result['auto_increment']['runtime_proven'])
            self.assertNotIn('shared_constant_or_null_defaults',result['checks'])

    def test_missing_wrong_duplicate_mode_or_changed_ddl_cannot_pass(self):
        mutations=[]
        c=case('0');c['environment_requirements']=[];mutations.append(c)
        c=case('0');c['environment_requirements'][0]['allowed_values']=['M'];mutations.append(c)
        c=case('0');c['environment_requirements']+=deepcopy(c['environment_requirements'][:1]);mutations.append(c)
        c=case('0');c['setup_sqls']=[DDL.replace('PRIMARY KEY AUTO_INCREMENT','PRIMARY KEY DEFAULT 1').replace(' AUTO_INCREMENT = 1','')];mutations.append(c)
        c=case('0');c['setup_sqls']+=['INSERT INTO g_b_at_autoinc VALUES (100, 1);'];mutations.append(c)
        c=case('0');c['factor_id']='m_insert';mutations.append(c)
        for c in mutations:
            with self.subTest(case=c):self.assertEqual(audit(c)['status'],'needs_review')

    def test_no_context_does_not_infer_b_from_name_or_zero(self):
        c=case('0')
        self.assertEqual(inspect_write(c['sql'],c['setup_sqls'])['status'],'needs_review')

    def test_cte_and_returning_cannot_reuse_outer_fresh_context(self):
        for change in [lambda s:'WITH x AS (SELECT 1) '+s,
                       lambda s:s.removesuffix(';')+' RETURNING id;',
                       lambda s:s.replace('VALUES (NULL, 1)','SELECT NULL, 1')]:
            c=case();c['sql']=change(c['sql'])
            with self.subTest(sql=c['sql']):self.assertEqual(audit(c)['status'],'needs_review')

    def test_unrelated_ordinary_default_keeps_old_contract(self):
        c=case('DEFAULT');c['params']={}
        c['setup_sqls']=['CREATE TABLE ordinary (id INTEGER DEFAULT 1, note INTEGER);']
        c['sql']='INSERT INTO ordinary (id, note) VALUES (DEFAULT, 1);'
        self.assertEqual(audit(c)['status'],'checked')
        self.assertIn('shared_constant_or_null_defaults',audit(c)['checks'])

    def test_synthetic_cte_target_does_not_crash_or_inherit_identity(self):
        result=inspect_write('WITH x(id) AS (VALUES (1)) INSERT INTO x VALUES (0)', [])
        self.assertEqual(result['status'],'needs_review')
        self.assertEqual(result['issues'][0]['code'],'target_unknown')

    def test_literal_keyword_and_another_auto_table_do_not_claim_target_identity(self):
        setup=[DDL, "CREATE TABLE ordinary (id INTEGER, note TEXT DEFAULT 'AUTO_INCREMENT');"]
        result=inspect_write("INSERT INTO ordinary VALUES (1, DEFAULT)",setup)
        self.assertEqual(result['status'],'checked')
        self.assertNotIn('auto_increment',result)

    def test_bad_context_shape_and_wrong_cleanup_stay_review(self):
        c=case('0')
        for context in [{}, {'environment_requirements':None,'teardown_sqls':[DROP]},
                        {'environment_requirements':c['environment_requirements'],'teardown_sqls':DROP},
                        {'environment_requirements':c['environment_requirements'],'teardown_sqls':['DROP TABLE other RESTRICT;']}]:
            with self.subTest(context=context):
                self.assertEqual(inspect_write(c['sql'],c['setup_sqls'],auto_increment_context=context)['status'],'needs_review')
