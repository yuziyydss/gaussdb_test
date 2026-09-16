"""Reviewed source atoms retain separate conditions, not a bulk green waiver."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class SourceAtomReviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()

    def test_three_ledgers_have_no_remaining_atomicity_gaps(self):
        for fid in ('alter_table', 'comment', 'create_table'):
            a = FactorCoverageAuditor(self.r).audit(fid)
            self.assertEqual(a['source_units']['atomicity']['gaps'], [], fid)
            self.assertTrue(a['conclusions']['source_extraction_complete'], fid)
            self.assertFalse(a['conclusions']['behavior_coverage_complete'], fid)

    def test_generated_expression_has_eight_separate_source_conditions(self):
        fid='create_table'; f=self.r.factors[fid]
        ids={'ct_fact_generated_'+s for s in ('no_other_rows','no_generated_refs','no_system_refs',
             'no_set_result','no_subquery','no_aggregate','no_window','immutable_only')}
        facts={x.id:x for x in f.facts}
        self.assertTrue(ids.issubset(facts))
        ledger=self.r.source_ledgers[f.source_ledger_ref]
        for identity in ids:
            units=[u for u in ledger.units if identity in u.fact_refs]
            self.assertEqual(len(units),1,identity)
            self.assertEqual(units[0].atomicity,'atomic')
            self.assertTrue(units[0].overlap_rationale)
        self.assertIn('只能',facts['ct_fact_generated_immutable_only'].statement)
        self.assertIn('IMMUTABLE',facts['ct_fact_generated_immutable_only'].statement)

    def test_change_restrictions_keep_exact_operation_and_environment(self):
        facts={f.id:f for f in self.r.factors['alter_table'].facts}
        for suffix in ('foreign_forbidden','encrypted_condition','partition_type_collation',
                       'rule_type_collation','matview_type_collation'):
            self.assertIn('at_fact_change_'+suffix,facts)
        for suffix in ('partition_type_collation','rule_type_collation','matview_type_collation'):
            statement=facts['at_fact_change_'+suffix].statement
            self.assertIn('数据类型',statement); self.assertIn('排序规则',statement)
        self.assertIn('服务端内存',facts['at_fact_change_encrypted_condition'].statement)
