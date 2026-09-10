"""General INSERT L42-48 has a distinct view/derived target production.

Recognizing its absent IGNORE option is not proving IGNORE runtime behavior.
"""
import unittest
from core.finite_sql_contract import inspect_write
from scripts.audit_rendered_sql_contracts import audit_report


class InsertIgnoreTargetContractTests(unittest.TestCase):
    setup = ['CREATE TABLE t(id INT,qty TEXT)', 'CREATE VIEW v AS SELECT id,qty FROM t']

    def inspect(self, sql, setup=None, scope='general'):
        return inspect_write(sql, self.setup if setup is None else setup,
                             conflict_source_scope=scope)

    def test_known_named_and_derived_target_detect_documented_grammar_conflict(self):
        for target in ('v', '(SELECT id,qty FROM t)'):
            for source in ("VALUES(1,'x')", 'DEFAULT VALUES'):
                result = self.inspect('INSERT IGNORE INTO '+target+' '+source)
                self.assertEqual(result['status'], 'rejected', result)
                self.assertEqual(result['issues'][0]['code'], 'ignore_target_not_supported')

    def test_alias_and_multiline_keep_same_target_identity(self):
        result=self.inspect("INSERT\nIGNORE\tINTO v AS dst(id,qty) VALUES(1,'x')")
        self.assertEqual(result['status'],'rejected',result)
        self.assertEqual(result['issues'][0]['code'],'ignore_target_not_supported')

    def test_plain_table_ignore_is_not_proved_or_rewritten(self):
        for target,setup in (('t',self.setup),('v',['CREATE TABLE v(id INT,qty TEXT)'])):
            result=self.inspect("INSERT IGNORE INTO "+target+" VALUES(1,'x')",setup)
            self.assertEqual(result['status'],'needs_review',result)

    def test_m_and_unknown_source_do_not_borrow_general_production(self):
        for scope in ('m_compat','unreviewed'):
            for target in ('v','(SELECT id,qty FROM t)'):
                result=self.inspect("INSERT IGNORE INTO "+target+" VALUES(1,'x')",scope=scope)
                self.assertEqual(result['status'],'needs_review',result)

    def test_unknown_stale_and_complex_view_identity_stay_review(self):
        for setup in (self.setup+['DROP VIEW v'],
                      ['CREATE TABLE t(id INT,qty TEXT)','CREATE VIEW v AS SELECT id+1,qty FROM t'],
                      ['CREATE TABLE v(id INT,qty TEXT)']):
            self.assertEqual(self.inspect("INSERT IGNORE INTO v VALUES(1,'x')",setup)['status'],
                             'needs_review')

    def test_string_contents_and_non_ignore_prefix_do_not_trigger_guard(self):
        result=self.inspect("INSERT INTO v VALUES(1,'INSERT IGNORE INTO v')")
        self.assertEqual(result['status'],'checked',result)
        for sql in ("INSERT IGNORED INTO v VALUES(1,'x')", "INSERT IGNORE v VALUES(1,'x')"):
            self.assertNotEqual(self.inspect(sql)['status'],'rejected',sql)

    def test_unreviewed_derived_projection_and_malformed_group_stay_review(self):
        for sql in ("INSERT IGNORE INTO (SELECT id+1,qty FROM t) VALUES(1,'x')",
                    "INSERT IGNORE INTO (SELECT id,qty FROM t VALUES(1,'x')"):
            self.assertEqual(self.inspect(sql)['status'],'needs_review',sql)

    def test_actual_audit_preserves_negative_oracle_and_execution_boundaries(self):
        case=dict(case_id='ignore_view_negative',factor_id='insert',expected='error',
                  sql="INSERT IGNORE INTO v VALUES(1,'x')",setup_sqls=self.setup,teardown_sqls=[])
        result=audit_report({'manifests':{'ignore':{'cases':[case]}}})
        self.assertEqual(result['summary']['write_contract'],{'rejected':1})
        self.assertFalse(result['database_executed'])
        self.assertEqual(result['cases'][0]['expected'],'error')
        self.assertEqual(result['summary']['positive_rejected'],0)


if __name__=='__main__':
    unittest.main()
