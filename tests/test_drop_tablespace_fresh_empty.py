"""DROP TABLESPACE uses one dedicated empty RELATIVE tablespace."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_drop_tablespace_fresh_empty'
NAME='g_drop_tbspc'


class DropTablespaceFreshEmptyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_if_exists_modifier_crosses_two_candidates(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),2)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{
            f'DROP TABLESPACE {NAME};',
            f'DROP TABLESPACE IF EXISTS {NAME};',
        })
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only'
                            for c in cases))

    def test_lifecycle_creates_and_cleans_dedicated_tablespace(self):
        cases,_=self.cases()
        for case in cases:
            self.assertEqual(case.setup_sqls,
                             [f"CREATE TABLESPACE {NAME} RELATIVE LOCATION '{NAME}';"])
            self.assertEqual(case.teardown_sqls,
                             [f'DROP TABLESPACE IF EXISTS {NAME};'])
            self.assertFalse(any('CASCADE' in x or 'DROP OWNED' in x
                                  for x in case.setup_sqls+case.teardown_sqls))
        fixture=self.r.fixtures['fixture_drop_tablespace_fresh_empty']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('非事务块','专用目录','setup失败','不验证磁盘容量','禁止CASCADE'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_and_audit_do_not_claim_runtime(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['tablespace_drop_privilege']['allowed_values'],['true'])
        self.assertIn('drop_tablespace_fact_body_8',
                      gates['tablespace_drop_privilege']['fact_refs'])
        features={f.id:f for f in self.r.matrices['matrix_drop_tablespace_coverage'].documented_features}
        feature=features['drop_tablespace_feature_runtime']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','all'))
        self.assertEqual(feature.value_refs,[
            'drop_tablespace_if_exists_none',
            'drop_tablespace_if_exists_yes',
            'drop_tablespace_tablespace_name_fresh',
        ])
        audit=FactorCoverageAuditor(self.r).audit('drop_tablespace')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])


if __name__=='__main__':unittest.main()
