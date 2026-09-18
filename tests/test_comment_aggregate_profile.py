"""COMMENT AGGREGATE identifies an owned signature, not a fake table/function."""
import hashlib
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
NS='g_comment_aggregate_ns'
AGG=NS+'.sum_value'
FN=NS+'.transition_value'
MID='manifest_comment_aggregate'


class CommentAggregateTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return FactorPackageSQLGenerator(self.r).generate_with_report(self.r.manifests[MID])

    def test_signature_crosses_four_original_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{f'COMMENT ON AGGREGATE {AGG}(INTEGER) IS {text};'
            for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')})
        self.assertTrue(all((c.expected,c.expected_scope)==('success','syntax_only') for c in cases))

    def test_real_typed_transition_and_aggregate_have_exact_reverse_cleanup(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA {NS};',
                f"CREATE FUNCTION {FN}(INTEGER, INTEGER) RETURNS INTEGER LANGUAGE SQL AS 'SELECT $1 + $2;';",
                f"CREATE AGGREGATE {AGG}(INTEGER) (SFUNC={FN}, STYPE=INTEGER, INITCOND='0');"])
            self.assertEqual(c.teardown_sqls,[f'DROP AGGREGATE {AGG}(INTEGER) RESTRICT;',
                f'DROP FUNCTION {FN}(INTEGER, INTEGER) RESTRICT;',f'DROP SCHEMA {NS} RESTRICT;'])
            self.assertFalse(any(s in sql for sql in c.setup_sqls+c.teardown_sqls
                                 for s in ('CASCADE','DROP OWNED','OR REPLACE','IF EXISTS')))
        fx=self.r.fixtures['fixture_comment_aggregate']
        self.assertEqual(fx.provides.tables,[])
        self.assertEqual(fx.requires_fixture_refs,[])
        for marker in ('PUBLIC','setup失败','本case','非当前模式','聚集'):
            self.assertIn(marker,fx.execution.note)

    def test_real_provider_dependencies_and_owner_gate_are_required(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['PG'])
        self.assertIn('drop_aggregate::drop_aggregate_fact_owner',gates['cleanup_aggregate']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertTrue({'create_aggregate','drop_aggregate','create_function','drop_function',
                         'create_schema','drop_schema'}<=graph['comment'])
        self.assertTrue(all(order.index(p)<order.index('comment') for p in graph['comment']))

    def test_metadata_oracles_are_planned_and_signature_specific(self):
        self.cases();s=self.r.scenarios['scenario_comment_aggregate']
        self.assertEqual(s.status,'planned')
        self.assertEqual([step['id'] for step in s.steps],['set','replace','clear'])
        self.assertEqual({o['step_id'] for o in s.oracles},{'set','replace','clear'})
        self.assertTrue(all(o['kind']=='manual_assertion' and 'INTEGER' in o['expected'] and
                            '聚集' in o['expected'] for o in s.oracles))
        self.assertIn('ownership_scoped_cleanup',s.execution_requirements)
        self.assertIn('target_oracle_calibration',s.execution_requirements)
        self.assertIn('per_step_oracle',s.execution_requirements)

    def test_sources_are_hashed_and_remaining_groups_are_not_declared_complete(self):
        self.cases();ledger=self.r.source_ledgers['source_ledger_comment']
        unit=next(u for u in ledger.units if u.id=='comment_su_aggregate_62')
        for name in ('create_aggregate','drop_aggregate'):
            sid='comment_source_'+name+'_owned'
            self.assertIn(sid,unit.supplemental_source_refs)
            s=next(s for s in ledger.supplemental_sources if s.id==sid)
            body=ROOT/'work/doc2spec/full_general_corpus'/s.catalog_chapter_ref.source_relpath
            self.assertEqual(hashlib.sha256(body.read_bytes()).hexdigest(),s.catalog_chapter_ref.chapter_sha256)
        features={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        f=features['comment_feature_object_aggregate']
        self.assertEqual((f.status,f.coverage_mode),('covered','representative'))
        self.assertEqual(f.value_refs,['comment_target_aggregate_fresh'])
        self.assertEqual(features['comment_feature_object_operator'].status,'covered')
        a=FactorCoverageAuditor(self.r).audit('comment')
        self.assertEqual(a['source_units']['atomicity']['gaps'], [])
        self.assertTrue(a['conclusions']['source_extraction_complete'])
        self.assertFalse(a['conclusions']['behavior_coverage_complete'])


if __name__=='__main__':unittest.main()
