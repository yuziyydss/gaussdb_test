"""A source ledger must not count seven visible syntax items as one fact."""
from pathlib import Path
import unittest
import yaml
from core.factor_package_model import FactorPackageRegistry
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
GROUPS={'comment_su_syntax_a_25':(25,32,2),
        'comment_su_syntax_c_40':(40,46,1),'comment_su_syntax_d_47':(47,53,1)}


class CommentRemainingGroupTests(unittest.TestCase):
    def test_counts_follow_the_original_rows_not_the_number_of_mapped_facts(self):
        raw=yaml.safe_load((ROOT/'specs/ddl/comment/comment.source.yaml').read_text())
        units={u['id']:u for u in raw['units']}
        body=(ROOT/'work/doc2spec/full_general_corpus/general/ddl/comment.txt').read_text().splitlines()
        for name,(start,end,facts) in GROUPS.items():
            u=units[name]
            clauses=[s.strip().rstrip('|').strip() for s in body[start-1:end] if s.strip()!='{']
            self.assertEqual(len(clauses),7)
            self.assertEqual((u['line_start'],u['line_end']),(start,end))
            self.assertEqual((u['atomicity'],u.get('independent_claim_count')),('grouped',7),name)
            self.assertEqual(len(u['fact_refs']),facts)

    def test_auditor_exposes_all_three_unresolved_groups_without_changing_their_profiles(self):
        r=FactorPackageRegistry(ROOT/'specs');r.load_all()
        a=FactorCoverageAuditor(r).audit('comment')
        gaps={g['id']:g for g in a['source_units']['atomicity']['gaps']}
        self.assertEqual(set(gaps),set(GROUPS))
        for name,(_,_,count) in GROUPS.items():
            self.assertEqual((gaps[name]['independent_claim_count'],gaps[name]['fact_ref_count']),(7,count))
            self.assertIn('independent_claims_exceed_fact_mappings',gaps[name]['reasons'])
        self.assertFalse(a['conclusions']['source_extraction_complete'])
        self.assertFalse(a['conclusions']['static_coverage_complete'])
        self.assertFalse(a['conclusions']['behavior_coverage_complete'])
        fs={f.id:f for f in r.matrices['matrix_comment_coverage'].documented_features}
        self.assertEqual(fs['comment_feature_object_type'].coverage_mode,'representative')
        self.assertEqual(fs['comment_feature_object_type'].status,'covered')
        self.assertEqual(fs['comment_feature_object_operator'].status,'needs_profile')


if __name__=='__main__':unittest.main()
