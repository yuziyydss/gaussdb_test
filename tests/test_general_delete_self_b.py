"""General B self-USING consumes a mode gate and fresh three-row fixture."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.spec_generator import GenerationValidationError
from core.finite_delete_contract import inspect_delete

MID='manifest_delete_self_using_b_fresh'

class DeleteSelfUsingBTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def manifest(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.r.manifests[MID]

    def test_two_spellings_have_real_fresh_self_target(self):
        cases,report=self.g.generate_with_report(self.manifest())
        self.assertEqual(len(cases),2);self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{'DELETE FROM t_delete_self_b USING t_delete_self_b AS src;',
                                              'DELETE t_delete_self_b USING t_delete_self_b AS src;'})
        for c in cases:
            self.assertEqual(c.setup_sqls,['CREATE TABLE t_delete_self_b (id INTEGER, note VARCHAR(64));',
                "INSERT INTO t_delete_self_b VALUES (1,'one'),(2,'two'),(3,'three');"])
            self.assertEqual(c.teardown_sqls,['DROP TABLE t_delete_self_b;'])
            self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))

    def test_selected_facet_rejects_missing_wrong_or_broadened_mode(self):
        for allowed in (None,['A'],['M'],['B','A']):
            m=self.manifest().model_copy(deep=True)
            if allowed is None:m.environment_requirements=[g for g in m.environment_requirements if g.key!='compatibility_mode']
            else:next(g for g in m.environment_requirements if g.key=='compatibility_mode').allowed_values=allowed
            with self.assertRaisesRegex(GenerationValidationError,'compatibility_mode'):
                self.g.generate_with_report(m)

    def test_retains_general_conditional_and_cursor_gaps(self):
        self.manifest();audit=FactorCoverageAuditor(self.r).audit('delete')
        self.assertIn('single_using_clause.delete_using_target_b',audit['values']['conditional_unselected'])
        self.assertIn('single_predicate.delete_predicate_current_of',audit['values']['conditional_unselected'])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])

    def test_two_scenarios_each_rebuild_seed_and_remain_planned(self):
        self.manifest()
        for suffix in ('with_from','without_from'):
            s=self.r.scenarios['scenario_delete_self_using_b_'+suffix]
            self.assertEqual(s.status,'planned')
            self.assertEqual(s.fixture_refs,['fixture_delete_self_b_fresh'])
            self.assertEqual(s.steps[-1]['sql'],'SELECT id,note FROM t_delete_self_b ORDER BY id;')
            self.assertTrue(any(o.get('step_id')=='remaining' and o.get('expected')==[] for o in s.oracles))
            self.assertIn('independent_case_lifecycle',s.execution_requirements)

    def test_generic_delete_inspector_does_not_infer_environment_from_sql(self):
        # The new generation facet has a consumed B gate; the standalone shape
        # inspector has no environment input and must still require review.
        cases,_=self.g.generate_with_report(self.manifest())
        for c in cases:
            self.assertEqual(inspect_delete(c.sql,c.setup_sqls)['status'],'needs_review')
