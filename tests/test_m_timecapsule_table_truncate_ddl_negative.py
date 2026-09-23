"""M TIMECAPSULE TABLE DDL negative uses a source-confirmed error."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_m_timecapsule_table_truncate_ddl_negative'


class MTimecapsuleTableTruncateDdlNegativeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def test_one_truncate_ddl_negative_candidate_is_generated(self):
        self.assertIn(MID,self.r.manifests)
        cases,report=self.g.generate_with_report(self.r.manifests[MID])
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        case=cases[0]
        self.assertEqual(case.sql,
                         'TIMECAPSULE TABLE m_timecapsule_namespace.source '
                         'TO BEFORE TRUNCATE;')
        self.assertEqual(case.expected,'error')
        self.assertEqual(case.expected_scope,'syntax_and_semantics')
        self.assertEqual(case.expected_oracle_status,'confirmed')
        self.assertEqual(case.expected_error_category,'intervening_ddl_modified_table')
        self.assertEqual(case.expected_error_regex,
                         'The table definition of .* has been modified')

    def test_fixture_performs_truncate_then_ddl_and_rule_is_targeted(self):
        cases,_=self.g.generate_with_report(self.r.manifests[MID])
        case=cases[0]
        setup='\n'.join(case.setup_sqls)
        self.assertEqual(setup.count('CREATE SCHEMA m_timecapsule_namespace;'),1)
        self.assertEqual(setup.count('CREATE TABLE m_timecapsule_namespace.source'),1)
        self.assertEqual(setup.count('TRUNCATE TABLE m_timecapsule_namespace.source'),1)
        self.assertIn('ALTER TABLE m_timecapsule_namespace.source ADD COLUMN ddl_marker INTEGER',setup)
        self.assertIn('DROP TABLE IF EXISTS m_timecapsule_namespace.source PURGE',case.teardown_sqls[0])
        rule=next(r for r in self.r.get_factor('m_timecapsule_table').rules
                  if r.id=='m_timecapsule_table_rule_no_intervening_ddl')
        self.assertEqual(rule.expression,
                         "intervening_ddl != 'm_timecapsule_table_intervening_ddl_alter'")

    def test_existing_rename_negative_and_runtime_gaps_remain(self):
        self.g.generate_with_report(self.r.manifests[MID])
        rename_mid='manifest_m_timecapsule_table_truncate_rename_negative'
        self.g.generate_with_report(self.r.manifests[rename_mid])
        audit=FactorCoverageAuditor(self.r).audit('m_timecapsule_table')
        self.assertTrue(audit['conclusions']['generation_model_complete'])
        self.assertTrue(audit['conclusions']['static_coverage_complete'])
        self.assertNotIn(rename_mid,audit['manifests']['unresolved_error_oracles'])
        self.assertTrue(audit['scenarios']['non_ready'])


if __name__=='__main__':unittest.main()
