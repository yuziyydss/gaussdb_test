"""Owned log_fdw server and foreign table COMMENT targets, not FDW data proof."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_fdw_objects'
SERVER='g_comment_fdw_server'
NS='g_comment_fdw_ns'


class CommentFDWObjectTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_real_server_schema_foreign_table_and_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),8);self.assertTrue(report.pairwise_complete)
        expected={f'COMMENT ON {target} IS {text};'
                  for target in (f'FOREIGN TABLE {NS}.foreign_table',f'SERVER {SERVER}')
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only' for c in cases))

    def test_actual_fdw_lifecycle_and_reverse_owned_cleanup(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                f'CREATE SERVER {SERVER} FOREIGN DATA WRAPPER log_fdw;',
                f'CREATE SCHEMA {NS};',
                f'CREATE FOREIGN TABLE {NS}.foreign_table (col1 TEXT) SERVER {SERVER} OPTIONS (logtype \'gs_log\');',
            ])
            self.assertEqual(c.teardown_sqls,[
                f'DROP FOREIGN TABLE {NS}.foreign_table RESTRICT;',
                f'DROP SCHEMA {NS} RESTRICT;',
                f'DROP SERVER {SERVER} RESTRICT;',
            ])
            self.assertFalse(any('CASCADE' in s or 'DROP OWNED' in s for s in c.setup_sqls+c.teardown_sqls))
        fixture=self.r.fixtures['fixture_comment_fdw_objects']
        self.assertEqual(fixture.provides.tables[0].table_kind,'foreign')
        for phrase in ('非当前模式','本case','setup失败','不读取日志数据'):
            self.assertIn(phrase,fixture.execution.note)

    def test_environment_and_cleanup_gates_use_actual_providers(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['documented_fdw_available']['allowed_values'],['log_fdw_catalog'])
        self.assertIn('create_server::create_server_fact_fdw_environment',
                      gates['documented_fdw_available']['fact_refs'])
        self.assertEqual(gates['database_scope']['allowed_values'],['non_pdb'])
        self.assertIn('create_foreign_table::create_foreign_table_fact_pdb_admin',
                      gates['database_scope']['fact_refs'])
        self.assertEqual(gates['comment_authority']['allowed_values'],['fixture_object_owner'])
        self.assertIn('comment_fact_authority',gates['comment_authority']['fact_refs'])
        self.assertEqual(gates['cleanup_namespace']['allowed_values'],['owned_fresh_non_current_schema'])
        self.assertIn('drop_schema::drop_schema_fact_permission',gates['cleanup_namespace']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertTrue({'create_server','create_foreign_table','drop_schema'}<=graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_server','create_foreign_table','drop_schema')))

    def test_features_are_two_owned_representatives_without_runtime_claim(self):
        self.cases()
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        for fid,target in (('comment_feature_object_foreign_table','comment_target_foreign_table_fresh'),
                           ('comment_feature_object_server','comment_target_server_fresh')):
            self.assertEqual((fs[fid].status,fs[fid].coverage_mode),('covered','representative'))
            self.assertEqual(fs[fid].value_refs,[target])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_fdw_objects']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual([s['id'] for s in scenario.steps],['comment_foreign_table','comment_server'])
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)


if __name__=='__main__':unittest.main()
