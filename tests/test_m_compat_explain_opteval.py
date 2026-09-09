"""OPTEVAL has a presence whitelist, not merely ANALYZE/Buffers booleans off."""
import itertools
from pathlib import Path
import unittest

from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from core.factor_coverage_auditor import FactorCoverageAuditor
from scripts.build_m_compat_batch_03 import explain


class ExplainOptevalDefinitionTests(unittest.TestCase):
    def test_independent_branch_omits_forbidden_options_even_when_false(self):
        p=explain()
        self.assertTrue('m_explain_form_opteval' in p.ast['branches'])
        branch=repr(p.ast['branches']['m_explain_form_opteval'])
        self.assertIn('OPTEVAL TRUE',branch)
        self.assertNotIn('analyze',branch.lower())
        self.assertNotIn('buffers',branch.lower())
        self.assertEqual(set(p.dims),{'form','analyze','verbose','costs','buffers','format','ordered','body'})


class ExplainOptevalIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,suffix):
        mid='manifest_m_explain_'+suffix
        self.assertTrue(mid in self.r.manifests,mid)
        return self.g.generate_with_report(self.r.manifests[mid])

    def test_positive_covers_twenty_active_pairs_without_analyze_or_buffers(self):
        cases,report=self.cases('opteval_query')
        self.assertTrue(report.pairwise_complete)
        names=('verbose','costs','format')
        domains=[['m_explain_verbose_off','m_explain_verbose_on'],
                 ['m_explain_costs_off','m_explain_costs_on'],
                 ['m_explain_format_'+v for v in ('text','xml','json','yaml')]]
        expected={(names[i],a,names[j],b) for i,j in itertools.combinations(range(3),2)
                  for a,b in itertools.product(domains[i],domains[j])}
        observed={(names[i],c.params[names[i]],names[j],c.params[names[j]])
                  for c in cases for i,j in itertools.combinations(range(3),2)}
        self.assertEqual(len(expected),20);self.assertEqual(observed,expected)
        self.assertGreaterEqual(len(cases),8);self.assertLessEqual(len(cases),16)
        self.assertEqual(len({c.sql for c in cases}),len(cases))
        for c in cases:
            self.assertTrue(c.sql.startswith('EXPLAIN (OPTEVAL TRUE,'),c.sql)
            self.assertTrue(c.sql.endswith('SELECT id,qty FROM m_b01_source WHERE id=1;'))
            self.assertNotIn('ANALYZE',c.sql);self.assertNotIn('BUFFERS',c.sql)
            self.assertEqual(c.expected_scope,'syntax_only')
            self.assertEqual(c.setup_sqls,['CREATE TABLE m_b01_source (id INT DEFAULT 7, qty INT DEFAULT 9);',
                                         'INSERT INTO m_b01_source (id,qty) VALUES (1,10),(2,20),(3,30);'])

    def test_forbidden_analyze_false_is_a_target_error_not_a_positive_shortcut(self):
        cases,_=self.cases('opteval_option_negative')
        self.assertEqual(len(cases),1)
        case=cases[0]
        self.assertEqual(case.sql,'EXPLAIN (OPTEVAL TRUE, ANALYZE FALSE) SELECT id,qty FROM m_b01_source WHERE id=1;')
        self.assertEqual(case.expected,'error')
        self.assertEqual(case.expected_oracle_status,'needs_verification')
        self.assertEqual(case.expected_sqlstates,[])
        self.assertEqual(case.expected_error_category,'opteval_option_not_allowed')
        m=self.r.manifests['manifest_m_explain_opteval_option_negative']
        self.assertEqual(m.violates_rule_refs,['m_explain_rule_opteval_options'])
        values=self.r.resolve_dimension_values('m_explain')['form']
        self.assertEqual(values[case.params['form']].validity,'invalid')

    def test_plan_and_performance_remain_unverified_and_old_four_manifests_stay(self):
        self.cases('opteval_query')
        old=('query_options','query_ordered','dml_plan_only','buffers_without_analyze_negative')
        self.assertEqual(sum(len(self.cases(v)[0]) for v in old),22)
        scenario=self.r.scenarios['scenario_m_explain_plan_and_opteval']
        self.assertEqual(scenario.status,'planned')
        question=next(f for f in self.r.factors['m_explain'].facts if f.id=='m_explain_fact_performance_gap')
        self.assertEqual(question.status,'needs_verification')
        audit=FactorCoverageAuditor(self.r).audit('m_explain')
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])


if __name__=='__main__':unittest.main()
