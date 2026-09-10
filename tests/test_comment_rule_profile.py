"""A rewrite rule is identified together with its owning table, not as a trigger."""
import hashlib
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
NS='g_comment_rule_ns';TABLE=NS+'.base_table';RULE='ignore_insert'
MID='manifest_comment_rule'


class CommentRuleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return FactorPackageSQLGenerator(self.r).generate_with_report(self.r.manifests[MID])

    def test_rule_and_table_identity_cross_four_text_values(self):
        cs,report=self.cases()
        self.assertEqual(len(cs),4);self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cs},{f'COMMENT ON RULE {RULE} ON {TABLE} IS {t};'
            for t in ("'factor note'","'测试注释'","'owner''s note'",'NULL')})
        self.assertTrue(all((c.expected,c.expected_scope)==('success','syntax_only') for c in cs))

    def test_plain_table_and_actual_rule_have_no_insert_or_select_rule_side_effects(self):
        cs,_=self.cases()
        for c in cs:
            self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA {NS};',
                f'CREATE TABLE {TABLE} (id INTEGER, qty INTEGER);',
                f'CREATE RULE {RULE} AS ON INSERT TO {TABLE} DO INSTEAD NOTHING;'])
            self.assertEqual(c.teardown_sqls,[f'DROP RULE {RULE} ON {TABLE} RESTRICT;',
                f'DROP TABLE {TABLE} PURGE;',f'DROP SCHEMA {NS} RESTRICT;'])
            self.assertFalse(any(word in s for s in c.setup_sqls+c.teardown_sqls
                                 for word in ('CASCADE','DROP OWNED','OR REPLACE','ON SELECT','IF EXISTS')))
        fx=self.r.fixtures['fixture_comment_rule']
        self.assertEqual([(t.name,[c.name for c in t.columns]) for t in fx.provides.tables],[(TABLE,['id','qty'])])
        for marker in ('setup失败','本case','非当前模式','删除权限'):
            self.assertIn(marker,fx.execution.note)

    def test_create_owner_and_drop_syntax_are_distinct_dependencies(self):
        cs,_=self.cases()
        gates={g['key']:g for g in cs[0].environment_requirements}
        self.assertEqual(gates['rule_create_authority']['allowed_values'],['actual_case_table_owner'])
        self.assertIn('create_rule::create_rule_fact_owner',gates['rule_create_authority']['fact_refs'])
        self.assertNotIn('rule_drop_authority',gates)
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertTrue({'create_rule','drop_rule','create_table','drop_table','create_schema','drop_schema'}<=graph['comment'])
        self.assertTrue(all(order.index(p)<order.index('comment') for p in graph['comment']))

    def test_planned_metadata_is_scoped_to_rule_and_table_not_trigger_or_behavior(self):
        self.cases();s=self.r.scenarios['scenario_comment_rule']
        self.assertEqual(s.status,'planned')
        self.assertEqual([step['id'] for step in s.steps],['set','replace','clear'])
        self.assertEqual({o['step_id'] for o in s.oracles},{'set','replace','clear'})
        self.assertTrue(all(o['kind']=='manual_assertion' and TABLE in o['expected'] and RULE in o['expected'] for o in s.oracles))
        for gate in ('target_oracle_calibration','ownership_scoped_cleanup','rule_drop_authorization','per_step_oracle'):
            self.assertIn(gate,s.execution_requirements)

    def test_source_hashes_and_unclosed_original_groups_are_honest(self):
        self.cases();ledger=self.r.source_ledgers['source_ledger_comment']
        unit=next(u for u in ledger.units if u.id=='comment_su_syntax_c_40')
        for name in ('create_rule','drop_rule'):
            sid='comment_source_'+name+'_owned';self.assertIn(sid,unit.supplemental_source_refs)
            s=next(s for s in ledger.supplemental_sources if s.id==sid)
            p=ROOT/'work/doc2spec/full_general_corpus'/s.catalog_chapter_ref.source_relpath
            self.assertEqual(hashlib.sha256(p.read_bytes()).hexdigest(),s.catalog_chapter_ref.chapter_sha256)
        features={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        f=features['comment_feature_object_rule']
        self.assertEqual((f.status,f.coverage_mode),('covered','representative'))
        self.assertEqual(f.value_refs,['comment_target_rule_fresh'])
        self.assertEqual(features['comment_feature_object_operator'].status,'needs_profile')
        a=FactorCoverageAuditor(self.r).audit('comment')
        self.assertEqual({g['id'] for g in a['source_units']['atomicity']['gaps']},
                         {'comment_su_syntax_a_25','comment_su_syntax_c_40','comment_su_syntax_d_47'})
        self.assertFalse(a['conclusions']['source_extraction_complete'])


if __name__=='__main__':unittest.main()
