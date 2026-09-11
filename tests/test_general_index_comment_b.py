"""Short B-mode COMMENT representative reuses consumed-value mode validation."""
import unittest
from pathlib import Path
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.spec_generator import GenerationValidationError

MID='manifest_create_index_comment_b_fresh'


class IndexCommentBTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(Path(__file__).resolve().parents[1]/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def manifest(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.r.manifests[MID]

    def test_one_short_comment_with_owned_astore_table(self):
        cases,report=self.g.generate_with_report(self.manifest())
        self.assertEqual(len(cases),1);self.assertTrue(report.pairwise_complete)
        c=cases[0]
        self.assertRegex(c.sql,r"^CREATE INDEX idx_ci_comment_[0-9a-f]+ ON g_ci_comment USING btree \(id\) COMMENT 'factor index';$")
        self.assertEqual(c.setup_sqls,['CREATE TABLE g_ci_comment (id INTEGER) WITH (storage_type=astore);'])
        self.assertEqual(c.teardown_sqls,['DROP TABLE g_ci_comment;'])
        self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))

    def test_omitted_wrong_or_broadened_mode_cannot_be_rendered(self):
        for allowed in (None,['A'],['M'],['B','A']):
            m=self.manifest().model_copy(deep=True)
            if allowed is None:m.environment_requirements=[g for g in m.environment_requirements if g.key!='compatibility_mode']
            else:next(g for g in m.environment_requirements if g.key=='compatibility_mode').allowed_values=allowed
            with self.assertRaisesRegex(GenerationValidationError,'compatibility_mode'):
                self.g.generate_with_report(m)

    def test_syntax_mode_and_length_facts_have_separate_existing_atomic_units(self):
        self.manifest()
        f=self.r.factors['create_index'];facts={v.id:v for v in f.facts}
        for fid,kind,anchor in [('ci_fact_comment_syntax','syntax','L659-L660'),
                                ('ci_fact_comment_b_mode','environment','L664'),
                                ('ci_fact_comment_length','constraint','L665')]:
            self.assertEqual((facts[fid].type,facts[fid].source_anchor),(kind,anchor))
        ledger=self.r.source_ledgers[f.source_ledger_ref]
        self.assertEqual(len(ledger.units),213)  # Visibility conditions split into six atomic units.
        self.assertTrue(all(any(fid in u.fact_refs for u in ledger.units)
                            for fid in ['ci_fact_comment_syntax','ci_fact_comment_b_mode','ci_fact_comment_length']))

    def test_short_candidate_does_not_close_length_or_metadata_domain(self):
        self.manifest()
        audit=FactorCoverageAuditor(self.r).audit('create_index')
        self.assertIn('comment_clause.ci_comment_basic',audit['values']['represented_by_finite_facet'])
        self.assertNotIn('comment_clause.ci_comment_basic',audit['values']['coverage_gaps'])
        self.assertFalse(audit['conclusions']['static_coverage_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertEqual(self.r.scenarios['scenario_create_index_comment'].status,'planned')
        s=self.r.scenarios['scenario_create_index_comment_short_b']
        self.assertEqual(s.status,'planned')
        self.assertEqual(s.oracles[0]['kind'],'manual_assertion')


if __name__=='__main__':unittest.main()
