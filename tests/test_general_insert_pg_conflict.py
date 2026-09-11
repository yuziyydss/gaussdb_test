"""Four scoped PG upsert candidates; generic conditional values remain open."""
import unittest
from pathlib import Path
from unittest.mock import Mock, patch

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.executor import Executor, ExecConfig
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_insert_pg_conflict_fresh'
SOURCES=["VALUES (101, 'alpha')", "VALUES (102, 'beta'), (103, 'gamma')"]
CLAUSES=['ON CONFLICT DO NOTHING','ON CONFLICT (id) DO UPDATE SET note = EXCLUDED.note']


class GeneralInsertPGConflictTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def generated(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_four_exact_sql_with_conflicting_and_nonconflicting_sources(self):
        cases,report=self.generated()
        self.assertEqual(len(cases),4)
        self.assertEqual({c.sql for c in cases},{
            'INSERT INTO g_insert_pg_conflict (id, note) '+source+' '+clause+';'
            for source in SOURCES for clause in CLAUSES})
        self.assertTrue(report.pairwise_complete)
        for case in cases:
            self.assertEqual((case.expected,case.expected_scope),('success','syntax_only'))
            gates={g['key']:g for g in case.environment_requirements}
            self.assertEqual(gates['compatibility_mode']['allowed_values'],['PG'])
            self.assertEqual(gates['actor_authority']['allowed_values'],['fixture_creator_insert_select_update'])
            self.assertEqual(gates['case_namespace']['allowed_values'],['isolated_user_schema'])

    def test_real_fresh_primary_key_and_seed_without_destructive_precleanup(self):
        cases,_=self.generated()
        for case in cases:
            self.assertEqual(case.setup_sqls,[
                'CREATE TABLE g_insert_pg_conflict (id INTEGER PRIMARY KEY, note VARCHAR(64));',
                "INSERT INTO g_insert_pg_conflict (id, note) VALUES (101, 'existing');"])
            self.assertEqual(case.teardown_sqls,['DROP TABLE g_insert_pg_conflict;'])
        fixture=self.r.fixtures['fixture_insert_pg_conflict_fresh']
        cols=fixture.provides.tables[0].columns
        self.assertEqual([(c.name,c.type,c.nullable) for c in cols],
                         [('id','INTEGER',False),('note','VARCHAR(64)',True)])

    def test_scope_mutations_and_unmet_environment_are_rejected(self):
        cases,_=self.generated()
        m=self.r.manifests[MID]
        solver=self.g._build_solver(self.r.factors['insert'],m,self.r.resolve_dimension_values('insert'))
        params=cases[0].params
        self.assertTrue(solver.is_valid(params)[0])
        self.assertFalse(solver.is_valid(dict(params,target_profile='insert_target_table_two_columns'))[0])
        self.assertFalse(solver.is_valid(dict(params,source_profile='insert_source_query'))[0])
        executor=Executor(ExecConfig(enabled=True,environment_capabilities={'compatibility_mode':'M'}))
        executor._conn=Mock()
        executor.connect=Mock(side_effect=AssertionError('database forbidden'))
        result=executor.execute_one(cases[0])
        self.assertEqual(result.verdict,'skip')
        executor._conn.cursor.assert_not_called()
        executor.connect.assert_not_called()

    def test_generic_gaps_and_unexecuted_oracles_are_honest(self):
        self.generated()
        audit=FactorCoverageAuditor(self.r).audit('insert')
        # 三个泛化conditional值由已选中的PG有限facet代表；tuple_update
        # 因更新冲突键语义不同仍保留缺口。
        for suffix in ('nothing_no_target','update','expression_predicate'):
            self.assertIn('conflict_clause.insert_on_conflict_'+suffix,audit['values']['represented_by_finite_facet'])
            self.assertNotIn('conflict_clause.insert_on_conflict_'+suffix,audit['values']['coverage_gaps'])
        self.assertIn('conflict_clause.insert_on_conflict_tuple_update',audit['values']['conditional_unselected'])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        for suffix,note in [('nothing','existing'),('update','alpha')]:
            scenario=self.r.scenarios['scenario_insert_pg_conflict_'+suffix]
            self.assertEqual(scenario.status,'planned')
            self.assertEqual([o['expected'] for o in scenario.oracles],
                             [[[101,note]],[[101,note],[102,'beta'],[103,'gamma']]])
            self.assertTrue(all(o['kind']=='result_set' for o in scenario.oracles))

    def test_actual_fixture_primary_key_cannot_be_replaced_by_profile_claim(self):
        self.generated()
        fid='fixture_insert_pg_conflict_fresh'
        bad=self.r.fixtures[fid].model_copy(deep=True)
        bad.execution.setup_sqls[0]=bad.execution.setup_sqls[0].replace(' PRIMARY KEY',' NOT NULL')
        with patch.dict(self.r.fixtures,{fid:bad}):
            with self.assertRaisesRegex(GenerationValidationError,'primary_key'):
                self.g.generate_with_report(self.r.manifests[MID])

    def test_selected_pg_key_contract_requires_explicit_pg_environment(self):
        self.generated()
        bad=self.r.manifests[MID].model_copy(deep=True)
        bad.environment_requirements=[g for g in bad.environment_requirements if g.key!='compatibility_mode']
        with self.assertRaisesRegex(GenerationValidationError,'compatibility_mode=PG'):
            self.g.generate_with_report(bad)


if __name__=='__main__':unittest.main()
