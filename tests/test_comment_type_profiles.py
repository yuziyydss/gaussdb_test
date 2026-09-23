"""Owned enum/composite COMMENT targets, not arbitrary type or metadata proof."""
import copy
import hashlib
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
NS='g_comment_type_ns'
MID='manifest_comment_types'


class CommentTypeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_two_real_type_identities_cross_four_existing_text_values(self):
        cases,r=self.cases()
        self.assertEqual(len(cases),8);self.assertTrue(r.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{f'COMMENT ON TYPE {NS}.{typ} IS {text};'
             for typ in ('status_enum','point_pair')
             for text in ("'factor note'","'测试注释'","'owner''s note'",'NULL')})
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only' for c in cases))

    def test_actual_type_ddl_and_reverse_owned_cleanup_never_fake_tables(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA {NS};',
                f"CREATE TYPE {NS}.status_enum AS ENUM ('open','closed');",
                f'CREATE TYPE {NS}.point_pair AS (x INTEGER, y INTEGER);'])
            self.assertEqual(c.teardown_sqls,[f'DROP TYPE {NS}.point_pair RESTRICT;',
                f'DROP TYPE {NS}.status_enum RESTRICT;',f'DROP SCHEMA {NS} RESTRICT;'])
            self.assertFalse(any('CASCADE' in s or 'DROP OWNED' in s for s in c.setup_sqls+c.teardown_sqls))
        fx=self.r.fixtures['fixture_comment_types']
        self.assertFalse(fx.provides.tables)
        for text in ('非当前模式','本case','setup失败','不依赖DDL回滚'):
            self.assertIn(text,fx.execution.note)

    def test_permissions_are_actual_typed_provider_consumers(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertIn('create_type::create_type_fact_any_type',gates['type_create_authority']['fact_refs'])
        self.assertIn('create_type::create_type_fact_composite_usage',gates['attribute_type_usage']['fact_refs'])
        self.assertIn('drop_type::drop_type_fact_privilege',gates['cleanup_types']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertTrue({'create_type','drop_type','create_schema','drop_schema'}<=graph['comment'])
        self.assertTrue(all(order.index(d)<order.index('comment') for d in graph['comment']))

    def test_metadata_steps_preserve_enum_and_composite_identity_but_stay_planned(self):
        self.cases();s=self.r.scenarios['scenario_comment_types']
        self.assertEqual(s.status,'planned');self.assertEqual(len(s.steps),6);self.assertEqual(len(s.oracles),6)
        self.assertTrue(all(o['kind']=='manual_assertion' for o in s.oracles))
        self.assertEqual([o['step_id'] for o in s.oracles],
                         [f'{kind}_{action}' for kind in ('enum','composite') for action in ('set','replace','clear')])
        self.assertIn('target_oracle_calibration',s.execution_requirements)
        self.assertIn('ownership_scoped_cleanup',s.execution_requirements)
        self.assertIn('per_step_oracle',s.execution_requirements)
        self.assertIn('create_type::create_type_fact_owner',s.fact_refs)
        self.assertIn('drop_type::drop_type_fact_restrict',s.fact_refs)

    def test_type_feature_is_only_two_representatives_and_source_rows_are_atomic(self):
        self.cases()
        fs={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        self.assertEqual((fs['comment_feature_object_type'].status,fs['comment_feature_object_type'].coverage_mode),
                         ('covered','any'))
        self.assertEqual(fs['comment_feature_object_type'].value_refs,
                         ['comment_target_enum_fresh','comment_target_composite_fresh'])
        self.assertEqual(fs['comment_feature_object_trigger'].status,'covered')
        facts={f.id:f for f in self.r.factors['comment'].facts}
        ledger=self.r.source_ledgers['source_ledger_comment']
        for line,kind in ((54,'type'),(55,'view'),(56,'trigger'),(58,'is')):
            unit=next(u for u in ledger.units if u.line_start==line)
            fid='comment_fact_object_'+kind+'_syntax'
            self.assertEqual((unit.line_end,unit.atomicity,unit.independent_claim_count),(line,'atomic',1))
            self.assertIn(fid,unit.fact_refs)
            self.assertEqual((facts[fid].type,facts[fid].source_anchor),('syntax',f'L{line}-L{line}'))
        self.assertFalse(any(u.line_start<=57<=u.line_end for u in ledger.units))
        gaps=FactorCoverageAuditor(self.r).audit('comment')['source_units']['atomicity']['gaps']
        self.assertEqual(gaps, [])

    def test_actual_create_and_drop_bodies_supply_supplemental_identity(self):
        self.cases();ledger=self.r.source_ledgers['source_ledger_comment']
        unit=next(u for u in ledger.units if u.line_start==54)
        sources={s.id:s for s in ledger.supplemental_sources}
        for key in ('comment_source_create_type_owned','comment_source_drop_type_owned'):
            self.assertIn(key,unit.supplemental_source_refs)
            ref=sources[key].catalog_chapter_ref
            body=ROOT/'work/doc2spec/full_general_corpus'/ref.source_relpath
            self.assertEqual(hashlib.sha256(body.read_bytes()).hexdigest(),ref.chapter_sha256)

    def test_four_claims_under_one_fact_do_not_become_complete(self):
        self.cases();r=copy.deepcopy(self.r);ledger=r.source_ledgers['source_ledger_comment']
        units=[u for u in ledger.units if u.line_start in (54,55,56,58)]
        self.assertEqual(len(units),4)
        combined=units[0].model_copy(update=dict(line_start=54,line_end=58,atomicity='grouped',
            independent_claim_count=4,fact_refs=['comment_fact_syntax_e']))
        ledger.units=[u for u in ledger.units if u not in units]+[combined]
        a=FactorCoverageAuditor(r).audit('comment')
        self.assertFalse(a['conclusions']['source_extraction_complete'])
        self.assertTrue(any(g['id']==combined.id and 'independent_claims_exceed_fact_mappings' in g['reasons']
                            for g in a['source_units']['atomicity']['gaps']))


if __name__=='__main__':unittest.main()
