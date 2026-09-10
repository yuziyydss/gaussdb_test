"""A finite COMMENT function target owns a real, explicitly typed PG routine."""
import hashlib
import copy
from pathlib import Path
import unittest
import yaml
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_package_model import FactorPackageRegistry
from core.factor_coverage_auditor import FactorCoverageAuditor

ROOT=Path(__file__).resolve().parents[1]
NS='g_comment_function_ns'
FN=NS+'.identity_value'
MID='manifest_comment_function'


class CommentFunctionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self):
        self.assertTrue(MID in self.r.manifests,MID)
        return self.g.generate_with_report(self.r.manifests[MID])

    def test_function_signature_crosses_original_four_text_values(self):
        cases,report=self.cases()
        self.assertEqual(len(cases),4);self.assertTrue(report.pairwise_complete)
        self.assertEqual({c.sql for c in cases},{f'COMMENT ON FUNCTION {FN}(INTEGER) IS {t};'
            for t in ("'factor note'","'测试注释'","'owner''s note'",'NULL')})
        self.assertTrue(all(c.expected=='success' and c.expected_scope=='syntax_only' for c in cases))
        for mid,n in [('manifest_comment_table_and_columns',12),('manifest_comment_owned_relations',12),
                      ('manifest_comment_namespace_constraint',8)]:
            self.assertEqual(len(self.g.generate_cases_for_manifest(self.r.manifests[mid])),n)

    def test_real_ddl_not_fake_table_and_only_owned_signature_cleanup(self):
        cases,_=self.cases()
        for c in cases:
            self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA {NS};',
                f"CREATE FUNCTION {FN}(input_value INTEGER) RETURNS INTEGER LANGUAGE SQL AS 'SELECT $1;';"])
            self.assertEqual(c.teardown_sqls,[f'DROP FUNCTION {FN}(INTEGER) RESTRICT;',f'DROP SCHEMA {NS} RESTRICT;'])
            self.assertFalse(any('CASCADE' in s or 'DROP OWNED' in s for s in c.setup_sqls+c.teardown_sqls))
        fx=self.r.fixtures['fixture_comment_function']
        self.assertEqual(fx.provides.tables,[])
        for text in ('PUBLIC','非当前模式','setup失败','本case'):
            self.assertIn(text,fx.execution.note)

    def test_mode_authority_and_visibility_are_actual_dependencies(self):
        cases,_=self.cases()
        gates={g['key']:g for g in cases[0].environment_requirements}
        self.assertEqual(gates['compatibility_mode']['allowed_values'],['PG'])
        self.assertIn('create_function::create_function_fact_styles',gates['compatibility_mode']['fact_refs'])
        self.assertIn('create_function::create_function_fact_create_any',gates['function_create_authority']['fact_refs'])
        self.assertIn('create_function::create_function_fact_public_execute',gates['execution_isolation']['fact_refs'])
        self.assertIn('drop_function::drop_function_fact_authority',gates['cleanup_function']['fact_refs'])
        graph=self.r.factor_dependency_graph();order=self.r.factor_topological_order()
        self.assertTrue({'create_function','drop_function','create_schema','drop_schema'}<=graph['comment'])
        self.assertTrue(all(order.index(k)<order.index('comment') for k in graph['comment']))

    def test_planned_oracles_distinguish_identity_metadata_from_result(self):
        self.cases()
        s=self.r.scenarios['scenario_comment_function'];self.assertEqual(s.status,'planned')
        for gate in ('database_authorization','target_oracle_calibration','ownership_scoped_cleanup','per_step_oracle'):
            self.assertIn(gate,s.execution_requirements)
        reads=[o for o in s.oracles if o['kind']=='result_set']
        metadata=[o for o in s.oracles if o['kind']=='manual_assertion']
        self.assertEqual(len(reads),3);self.assertTrue(all(o['expected']==[[7]] for o in reads))
        self.assertEqual({o['step_id'] for o in metadata},{'set','replace','clear'})
        self.assertTrue(all('INTEGER' in o['expected'] for o in metadata))
        self.assertFalse(any(o['kind']=='target_error' for o in s.oracles))
        self.assertEqual([step['sql'] for step in s.steps if step['id'].endswith('_read')],
                         [f'SELECT {FN}(CAST(7 AS INTEGER));']*3)

    def test_representative_and_atomic_sources_do_not_claim_full_domain(self):
        self.cases()
        features={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        f=features['comment_feature_object_function']
        self.assertEqual((f.status,f.coverage_mode),('covered','representative'))
        self.assertEqual(f.value_refs,['comment_target_function_fresh'])
        aggregate=features['comment_feature_object_aggregate']
        self.assertEqual((aggregate.status,aggregate.coverage_mode),('covered','representative'))
        self.assertEqual(aggregate.value_refs,['comment_target_aggregate_fresh'])
        self.assertEqual(features['comment_feature_object_operator'].status,'needs_profile')
        ledger=yaml.safe_load((ROOT/'specs/ddl/comment/comment.source.yaml').read_text())
        unit=next(u for u in ledger['units'] if u['id']=='comment_su_object_function_38')
        self.assertEqual((unit['atomicity'],unit['independent_claim_count']),('atomic',1))
        refs={s['id']:s for s in ledger['supplemental_sources']}
        for key in ('comment_source_create_function_owned','comment_source_drop_function_owned'):
            self.assertIn(key,unit['supplemental_source_refs'])
            ref=refs[key]['catalog_chapter_ref']
            body=ROOT/'work/doc2spec/full_general_corpus'/ref['source_relpath']
            self.assertEqual(hashlib.sha256(body.read_bytes()).hexdigest(),ref['chapter_sha256'])

    def test_seven_object_lines_have_distinct_source_facts_and_feature_consumers(self):
        ledger=self.r.source_ledgers['source_ledger_comment']
        units=[u for u in ledger.units if 33<=u.line_start<=39]
        self.assertEqual(len(units),7)
        features={f.id:f for f in self.r.matrices['matrix_comment_coverage'].documented_features}
        facts={f.id:f for f in self.r.factors['comment'].facts}
        kinds=('database','domain','extension','foreign_data_wrapper','foreign_table','function','index')
        for line,kind in enumerate(kinds,33):
            unit=next(u for u in units if u.line_start==line)
            fid='comment_fact_object_'+kind+'_syntax'
            self.assertEqual((unit.line_end,unit.atomicity,unit.independent_claim_count),(line,'atomic',1))
            self.assertIn(fid,unit.fact_refs)
            self.assertEqual((facts[fid].type,facts[fid].source_anchor),('syntax',f'L{line}-L{line}'))
            self.assertIn(fid,features['comment_feature_object_'+kind].fact_refs)
        gaps=FactorCoverageAuditor(self.r).audit('comment')['source_units']['atomicity']['gaps']
        self.assertEqual({g['id'] for g in gaps},
                         {'comment_su_syntax_a_25','comment_su_syntax_c_40','comment_su_syntax_d_47'})
        self.assertTrue(all(features['comment_feature_object_'+k].status=='needs_profile' for k in kinds[:5]))

    def test_recombining_seven_lines_under_one_fact_reproduces_atomicity_failure(self):
        r=copy.deepcopy(self.r);ledger=r.source_ledgers['source_ledger_comment']
        units=[u for u in ledger.units if 33<=u.line_start<=39]
        self.assertEqual(len(units),7)
        combined=units[0].model_copy(update=dict(line_start=33,line_end=39,source_anchor='L33-L39',
            atomicity='grouped',independent_claim_count=7,fact_refs=['comment_fact_syntax_b']))
        ledger.units=[u for u in ledger.units if not 33<=u.line_start<=39]+[combined]
        audit=FactorCoverageAuditor(r).audit('comment')
        self.assertFalse(audit['conclusions']['source_extraction_complete'])
        self.assertTrue(any(g['id']==combined.id and 'independent_claims_exceed_fact_mappings' in g['reasons']
                            for g in audit['source_units']['atomicity']['gaps']))


if __name__=='__main__':unittest.main()
