"""Six finite-model gaps: real SQL evidence, not relaxed coverage criteria."""
import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
TARGETS=('m_create_table','m_create_table_partition','m_create_table_subpartition',
         'm_drop_function','m_explain','m_insert')


class MGenerationGapTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,mid):
        self.assertTrue(mid in self.r.manifests,'missing manifest: '+mid)
        return self.g.generate_cases_for_manifest(self.r.manifests[mid])

    def test_six_models_close_without_claiming_source_or_behavior_completion(self):
        for fid in TARGETS:
            with self.subTest(factor=fid):
                a=FactorCoverageAuditor(self.r).audit(fid)
                self.assertTrue(a['conclusions']['generation_model_complete'],
                    (a['values']['coverage_gaps'],a['rules']['gaps'],a['manifests']['errors']))
                self.assertFalse(a['conclusions']['static_coverage_complete'])
                self.assertFalse(a['conclusions']['behavior_coverage_complete'])

    def test_invalid_values_are_not_disguised_as_positive_coverage(self):
        for fid,dim,value in [('m_create_table','orientation','column'),('m_insert','source_profile','generated_literal')]:
            v=self.r.resolve_dimension_values(fid)[dim][fid+'_'+dim+'_'+value]
            self.assertEqual(v.validity,'invalid')
        # The duplicate clause is legal on tables: it must not be made invalid
        # merely because a view-negative manifest was its only consumer.
        self.assertEqual(self.r.resolve_dimension_values('m_insert')['duplicate']['m_insert_duplicate_yes'].validity,'valid')

    def test_upsert_has_real_conflict_and_preserves_existing_view_negative(self):
        cases=self.cases('manifest_m_insert_upsert_conflict')
        self.assertTrue(cases)
        for c in cases:
            self.assertEqual(c.expected,'success')
            self.assertIn('ON DUPLICATE KEY UPDATE qty = VALUES(qty)',c.sql)
            self.assertIn('PRIMARY KEY',c.setup_sqls[0])
            self.assertIn('INSERT INTO m_b01_upsert VALUES (7,3);',c.setup_sqls)
            self.assertIn('(7,9)',c.sql)
            self.assertEqual(c.teardown_sqls,['DROP TABLE m_b01_upsert;'])
        self.assertTrue(all(c.expected=='error' for c in self.cases('manifest_m_insert_view_duplicate_negative')))

    def test_true_product_rules_have_targeted_negative_cases(self):
        for fid,suffix,rule in [('m_explain','buffers_without_analyze_negative','buffers'),
                                ('m_drop_function','missing_signature_negative','behavior_requires_signature')]:
            mid='manifest_'+fid+'_'+suffix
            for c in self.cases(mid):
                self.assertEqual(c.expected,'error');self.assertEqual(c.expected_error_category,rule)
                self.assertEqual(c.expected_oracle_status,'needs_verification');self.assertFalse(c.expected_sqlstates)
                self.assertTrue(c.setup_sqls and c.teardown_sqls)
                if fid=='m_explain':
                    self.assertIn('BUFFERS TRUE',c.sql);self.assertIn('ANALYZE FALSE',c.sql)
                    self.assertIn(') SELECT ',c.sql)
                else:
                    self.assertNotIn('(',c.sql);self.assertTrue(c.sql.endswith('RESTRICT;'))
                    self.assertTrue(any(x['key']=='command_applicability' for x in c.environment_requirements))

    def test_implicit_hash_is_positive_not_fabricated_error(self):
        for c in self.cases('manifest_m_create_table_partition_hash_implicit'):
            self.assertEqual(c.expected,'success');self.assertNotIn('PARTITIONS ',c.sql)
            self.assertNotIn('PARTITION p',c.sql)
        f=self.r.factors['m_create_table_partition']
        self.assertNotIn('m_create_table_partition_rule_auto_count',[r.id for r in f.rules])
        self.assertTrue(self.r.manifests['manifest_m_create_table_partition_hash_auto'].local_rules)

    def test_subpartition_label_constraints_are_selection_policy_only(self):
        f=self.r.factors['m_create_table_subpartition']
        self.assertEqual([r.id for r in f.rules],['m_create_table_subpartition_rule_sub_count_matches'])
        for label in ('automatic','implicit'):
            m=self.r.manifests['manifest_m_create_table_subpartition_'+label]
            self.assertTrue(m.local_rules);self.assertTrue(m.local_rules[0].rationale)
            self.assertTrue(m.local_rules[0].fact_refs)
        negatives=self.cases('manifest_m_create_table_subpartition_wrong_count_negative')
        self.assertEqual(len(negatives),1)
        self.assertIn('SUBPARTITIONS 3',negatives[0].sql)
        self.assertEqual(negatives[0].sql.count('SUBPARTITION p'),4)


if __name__=='__main__':unittest.main()
