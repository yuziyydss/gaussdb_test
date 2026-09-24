"""COMMENT ON EXTENSION uses a transaction-scoped dedicated test extension."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_comment_extension'
EXTENSION='ext_b7'
NS='g_comment_extension_ns'


class CommentExtensionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_extension_target_crosses_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        expected={f'COMMENT ON EXTENSION {EXTENSION} IS {text};'
                  for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')}
        self.assertEqual({c.sql for c in cases},expected)
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only'
                            for c in cases))

    def test_extension_lifecycle_is_transaction_scoped_and_owned(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[
                'BEGIN;',
                f'CREATE SCHEMA {NS};',
                f'CREATE EXTENSION {EXTENSION} SCHEMA {NS};',
            ])
            self.assertEqual(c.teardown_sqls,['ROLLBACK;'])
            self.assertFalse(any('DROP EXTENSION' in x or 'CASCADE' in x or 'DROP OWNED' in x
                                  for x in c.setup_sqls+c.teardown_sqls))
        fixture=self.r.fixtures['fixture_comment_extension']
        self.assertFalse(fixture.provides.tables)
        for phrase in ('事务内','enable_extension','专用测试扩展','本case','ROLLBACK'):
            self.assertIn(phrase,fixture.execution.note)

    def test_gate_feature_scenario_and_cross_contract(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['isolated_internal_test']['allowed_values'],['true'])
        self.assertIn('create_extension::create_extension_fact_internal',
                      gates['isolated_internal_test']['fact_refs'])
        self.assertEqual(gates['enable_extension']['allowed_values'],['true'])
        self.assertIn('create_extension::create_extension_fact_enabled',
                      gates['enable_extension']['fact_refs'])
        self.assertEqual(gates['extension_support_contract']['allowed_values'],
                         ['ext_b7:default,1.0,b7_version'])
        self.assertIn('create_extension::create_extension_fact_support_files',
                      gates['extension_support_contract']['fact_refs'])
        self.assertEqual(gates['comment_authority']['allowed_values'],['fixture_object_owner'])
        self.assertIn('comment_fact_authority',gates['comment_authority']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertIn('create_extension',graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment')
                            for d in ('create_extension',)))
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        feature=fs['comment_feature_object_extension']
        self.assertEqual((feature.status,feature.coverage_mode),('covered','any'))
        self.assertEqual(feature.value_refs,['comment_target_extension_fresh'])
        audit=FactorCoverageAuditor(self.r).audit('comment')
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        scenario=self.r.scenarios['scenario_comment_extension']
        self.assertEqual(scenario.status,'planned')
        self.assertEqual(len(scenario.steps),1)
        self.assertEqual(len(scenario.oracles),1)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in scenario.oracles))
        self.assertIn('target_oracle_calibration',scenario.execution_requirements)


if __name__=='__main__':unittest.main()
