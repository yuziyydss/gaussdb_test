"""General INSERT L294 forbids incoming VALUES as an IN/NOT IN operand."""
from pathlib import Path
import re
import unittest

from core.finite_sql_contract import inspect_write


class IncomingValuesPredicateTests(unittest.TestCase):
    setup=['CREATE TABLE t(id INT PRIMARY KEY,note TEXT)',"INSERT INTO t VALUES(1,'old')"]

    def inspect(self,expr,scope='general',clause='ON DUPLICATE KEY UPDATE',setup=None):
        return inspect_write("INSERT INTO t VALUES(1,'new') "+clause+' note='+expr,
                             self.setup if setup is None else setup,conflict_source_scope=scope)

    def test_documented_in_and_not_in_are_not_generic_expression_unknown(self):
        for predicate in ("VALUES(note) IN ('x')", "values ( note ) not in ('x','y')"):
            result=self.inspect("CASE WHEN "+predicate+" THEN 'x' ELSE note END")
            self.assertEqual(result['status'],'rejected',result)
            self.assertEqual(result['issues'][0]['code'],'duplicate_values_predicate_not_supported')
            self.assertIn('General INSERT L294',result['issues'][0]['detail'])

    def test_parenthesized_predicate_does_not_need_case_evaluation(self):
        result=self.inspect("(VALUES(note) IN ('x'))")
        self.assertEqual(result['status'],'rejected',result)
        self.assertEqual(result['issues'][0]['code'],'duplicate_values_predicate_not_supported')

    def test_unknown_and_m_sources_do_not_borrow_general_rule(self):
        for scope in ('m_compat','unreviewed'):
            result=self.inspect("CASE WHEN VALUES(note) IN ('x') THEN 'x' ELSE note END",scope)
            self.assertEqual(result['status'],'needs_review',result)

    def test_quoted_text_and_qualified_function_are_not_incoming_values(self):
        for expr in ("'VALUES(note) IN (''x'')'", "'a'' VALUES(note) IN (''x'')'",
                     "CASE WHEN app.VALUES(note) IN ('x') THEN 'x' ELSE note END",
                     "CASE WHEN app . VALUES(note) IN ('x') THEN 'x' ELSE note END",
                     "CASE WHEN xVALUES(note) IN ('x') THEN 'x' ELSE note END",
                     "$tag$VALUES(note) IN ('x')$tag$"):
            result=self.inspect(expr)
            self.assertNotIn('duplicate_values_predicate_not_supported',[i['code'] for i in result['issues']],expr)

    def test_unproved_shapes_keep_review_and_do_not_gain_type_or_row_claims(self):
        for expr in ("VALUES(note)||'x'", "note IN (VALUES(note))",
                     "CAST(VALUES(note) AS TEXT) IN ('x')", "VALUES(missing) IN ('x')"):
            self.assertEqual(self.inspect(expr)['status'],'needs_review',expr)
        self.assertEqual(self.inspect('VALUES(note)')['status'],'checked')
        result=self.inspect("VALUES(note) IN ('x')",clause='ON CONFLICT(id) DO UPDATE SET')
        self.assertNotIn('duplicate_values_predicate_not_supported',[i['code'] for i in result['issues']])


class IncomingValuesPredicateIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        from core.factor_package_model import FactorPackageRegistry
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.root=Path(__file__).resolve().parents[1]

    def test_actual_negative_is_archived_with_uncalibrated_target_oracle(self):
        mid='manifest_insert_duplicate_values_predicate_negative'
        self.assertNotIn(mid,self.r.manifests)
        self.assertNotIn(mid,self.r.factors['insert'].manifest_refs)
        snapshot=(self.root/'archive/spec_reviews/20260923/generated_sql/insert'/f'{mid}.sql').read_text()
        self.assertIn('case_id: manifest_insert_duplicate_values_predicate_negative_dfe140e4bb0d',snapshot)
        self.assertIn('expected_error_category: duplicate_values_predicate_not_supported',snapshot)
        self.assertIn('expected_oracle_status: needs_verification',snapshot)
        sql=re.search(r'^-- test_sql:\n(.*?)^-- fixture_teardown:',snapshot,
                      re.MULTILINE|re.DOTALL).group(1).rstrip('\n')
        setup=re.search(r'^-- fixture_setup:\n(.*?)^-- test_sql:',snapshot,
                        re.MULTILINE|re.DOTALL).group(1).splitlines()
        result=inspect_write(sql,setup,conflict_source_scope='general')
        self.assertEqual(result['status'],'rejected',result)
        self.assertEqual(result['issues'][0]['code'],'duplicate_values_predicate_not_supported')
        factor=self.r.factors['insert']
        fact=next(f for f in factor.facts if f.id=='insert_fact_duplicate_values_restrictions')
        self.assertEqual((fact.type,fact.status),('constraint','confirmed'))
        self.assertTrue(any(fact.id in u.fact_refs for u in self.r.source_ledgers[factor.source_ledger_ref].units))


if __name__=='__main__': unittest.main()
