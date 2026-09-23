"""ALTER TABLESPACE uses one dedicated RELATIVE rename representative."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_alter_tablespace_fresh_rename'
OLD='g_alter_tbspc'
NEW='g_alter_tbspc_renamed'


class AlterTablespaceFreshRenameTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_one_rename_candidate_is_generated(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].sql,
                         f'ALTER TABLESPACE {OLD} RENAME TO {NEW};')
        self.assertEqual(cases[0].expected,'success')
        self.assertEqual(cases[0].expected_scope,'syntax_only')

    def test_lifecycle_creates_and_cleans_both_names(self):
        cases,_=self.cases()
        case=cases[0]
        self.assertEqual(case.setup_sqls,
                         [f"CREATE TABLESPACE {OLD} RELATIVE LOCATION '{OLD}';"])
        self.assertEqual(case.teardown_sqls,[
            f'DROP TABLESPACE IF EXISTS {OLD};',
            f'DROP TABLESPACE IF EXISTS {NEW};',
        ])
        self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x
                              for x in case.setup_sqls+case.teardown_sqls))
        fixture=self.r.fixtures['fixture_alter_tablespace_fresh_rename']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('非事务块','专用目录','setup失败','不验证磁盘容量','禁止CASCADE'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gates_feature_and_audit_do_not_claim_runtime(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['tablespace_alter_privilege']['allowed_values'],['true'])
        self.assertIn('alter_tablespace_fact_body_8',
                      gates['tablespace_alter_privilege']['fact_refs'])
        self.assertEqual(gates['tablespace_create_privilege']['allowed_values'],['true'])
        self.assertIn('create_tablespace::create_tablespace_fact_body_8',
                      gates['tablespace_create_privilege']['fact_refs'])
        features={f.id:f for f in self.r.matrices['matrix_alter_tablespace_coverage'].documented_features}
        feature=features['alter_tablespace_feature_runtime']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,[
            'alter_tablespace_tablespace_name_fresh',
            'alter_tablespace_action_rename',
        ])
        audit=FactorCoverageAuditor(self.r).audit('alter_tablespace')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])


if __name__=='__main__':unittest.main()
