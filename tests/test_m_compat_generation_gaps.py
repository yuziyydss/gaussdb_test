"""Former M generation gaps now close statically; behavior remains unexecuted."""
import unittest
from pathlib import Path

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry

ROOT=Path(__file__).resolve().parents[1]
TARGETS=('m_create_table','m_create_table_partition','m_create_table_subpartition',
         'm_drop_function','m_explain','m_insert')


class MGenerationGapTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,mid):
        self.assertIn(mid,self.r.manifests,'missing manifest: '+mid)
        return self.g.generate_cases_for_manifest(self.r.manifests[mid])

    def test_former_generation_gaps_are_static_only(self):
        for fid in TARGETS:
            with self.subTest(factor=fid):
                audit=FactorCoverageAuditor(self.r).audit(fid)
                self.assertTrue(audit['conclusions']['generation_model_complete'])
                self.assertTrue(audit['conclusions']['static_coverage_complete'])
                self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
                self.assertEqual(audit['manifests']['unresolved_error_oracles'],[])
                self.assertEqual(audit['values']['coverage_gaps'],[])

    def test_uncalibrated_invalid_values_are_not_positive_candidates(self):
        for fid,dim,value in [('m_create_table','orientation','column'),
                              ('m_insert','source_profile','generated_literal')]:
            resolved=self.r.resolve_dimension_values(fid)
            value_id=fid+'_'+dim+'_'+value
            self.assertEqual(resolved[dim][value_id].validity,'unknown')
        self.assertEqual(self.r.resolve_dimension_values('m_insert')['duplicate']['m_insert_duplicate_yes'].validity,'valid')

    def test_upsert_has_real_conflict_and_owned_cleanup(self):
        for case in self.cases('manifest_m_insert_upsert_conflict'):
            self.assertEqual(case.expected,'success')
            self.assertIn('ON DUPLICATE KEY UPDATE qty = VALUES(qty)',case.sql)
            self.assertIn('PRIMARY KEY',case.setup_sqls[0])
            self.assertIn('INSERT INTO m_b01_upsert VALUES (7,3);',case.setup_sqls)
            self.assertIn('(7,9)',case.sql)
            self.assertEqual(case.teardown_sqls,['DROP TABLE m_b01_upsert;'])

    def test_implicit_hash_is_positive_not_fabricated_error(self):
        for case in self.cases('manifest_m_create_table_partition_hash_implicit'):
            self.assertEqual(case.expected,'success')
            self.assertNotIn('PARTITIONS ',case.sql)
            self.assertNotIn('PARTITION p',case.sql)
        factor=self.r.factors['m_create_table_partition']
        self.assertNotIn('m_create_table_partition_rule_auto_count',[rule.id for rule in factor.rules])
        self.assertTrue(self.r.manifests['manifest_m_create_table_partition_hash_auto'].local_rules)

    def test_subpartition_labels_are_manifest_selection_policy(self):
        factor=self.r.factors['m_create_table_subpartition']
        self.assertEqual(factor.rules,[])
        for label in ('automatic','implicit'):
            manifest=self.r.manifests['manifest_m_create_table_subpartition_'+label]
            self.assertTrue(manifest.local_rules)
            self.assertTrue(manifest.local_rules[0].rationale)
            self.assertTrue(manifest.local_rules[0].fact_refs)


if __name__=='__main__':
    unittest.main()
