"""Separate COMMENT targets are source atoms, not additional SQL coverage."""
import copy
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry, SourceUnitDef
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT = Path(__file__).resolve().parents[1]


class CommentRemainingGroupTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()

    def test_each_clause_and_both_column_branches_have_distinct_facts(self):
        factor = self.r.factors['comment']
        facts = {f.id for f in factor.facts if f.id.startswith('comment_fact_atom_')}
        self.assertEqual(len(facts), 22)
        units = self.r.source_ledgers[factor.source_ledger_ref].units
        for identity in facts:
            matched = [u for u in units if identity in u.fact_refs]
            self.assertEqual(len(matched), 1, identity)
            self.assertEqual(matched[0].atomicity, 'atomic')
        columns = [u for u in units if u.overlap_group == 'comment_column_targets_30']
        self.assertEqual(len(columns), 2)
        self.assertTrue(all(u.overlap_rationale for u in columns))

    def test_source_closure_does_not_upgrade_generation_or_behavior(self):
        a = FactorCoverageAuditor(self.r).audit('comment')
        self.assertEqual(a['source_units']['atomicity']['gaps'], [])
        self.assertTrue(a['conclusions']['source_extraction_complete'])
        self.assertTrue(a['conclusions']['static_coverage_complete'])
        self.assertFalse(a['conclusions']['behavior_coverage_complete'])
        fs = {f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        self.assertEqual(fs['comment_feature_object_type'].coverage_mode, 'any')
        self.assertEqual(fs['comment_feature_object_type'].status, 'covered')
        self.assertEqual(fs['comment_feature_object_operator'].status, 'covered')

    def test_recombining_seven_claims_still_fails_atomicity_audit(self):
        r = copy.copy(self.r); r.source_ledgers = dict(self.r.source_ledgers)
        key = r.factors['comment'].source_ledger_ref
        ledger = self.r.source_ledgers[key].model_copy(deep=True)
        r.source_ledgers[key] = ledger
        first = next(u for u in ledger.units if u.id == 'comment_su_syntax_c_40')
        data = first.model_dump()
        data.update(line_start=40, line_end=46, atomicity='grouped', independent_claim_count=7,
                    fact_refs=[ref for ref in first.fact_refs if not ref.startswith('comment_fact_atom_')])
        ledger.units = [u for u in ledger.units if not (40 <= u.line_start <= 46)]
        ledger.units.append(SourceUnitDef(**data))
        gaps = FactorCoverageAuditor(r).audit('comment')['source_units']['atomicity']['gaps']
        gap = next(g for g in gaps if g['id'] == first.id)
        self.assertIn('independent_claims_exceed_fact_mappings', gap['reasons'])


if __name__ == '__main__':
    unittest.main()
