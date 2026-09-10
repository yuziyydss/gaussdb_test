"""M COUNT has a BIGINT contract, not SUM's numeric return mapping."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
import yaml
from core.finite_sql_contract import ReviewNeeded, Contradiction
from core.query_output_contract import check_documented_aggregate_types, check_documented_sum_types
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_pilot import select

ROOT=Path(__file__).resolve().parents[1]
MID='manifest_m_select_count_nullable';TABLE='m_select_count_ns.source_table'


class CountTypeTests(unittest.TestCase):
    def check(self,item='COUNT(qty)',output='BIGINT',typ='INTEGER',mode='M',identity='m_builtin_count'):
        return check_documented_aggregate_types([item],[output],['qty'],[typ],mode=mode,identity=identity)

    def test_bigint_return_is_independent_of_all_or_distinct(self):
        for typ in ('INT','INTEGER','INT4'):
            for modifier in ('','ALL ','DISTINCT '):
                self.assertEqual(self.check(item=f'count({modifier}qty) AS result',typ=typ),[0])
        for output in ('INTEGER','DECIMAL','DOUBLE'):
            with self.subTest(output=output),self.assertRaisesRegex(Contradiction,'function_output_type_mismatch'):
                self.check(output=output)

    def test_noncolumn_window_and_unknown_identity_remain_review(self):
        for item in ('COUNT(NULL)','COUNT(current_date)','COUNT(qty+1)',
                     'COUNT(DISTINCT qty, qty)','COUNT(qty) OVER ()','app.COUNT(qty)',
                     'COUNT(qty) AS reſult','COUNT(ALLqty)'):
            with self.subTest(item=item),self.assertRaises((ReviewNeeded,Contradiction)):self.check(item=item)
        for kwargs in ({'mode':'general'},{'identity':'user_function'},{'typ':'ınt'},
                       {'output':'BıGINT'},{'typ':'DECIMAL(8,2)'},{'typ':'TEXT'}):
            with self.subTest(kwargs=kwargs),self.assertRaises(ReviewNeeded):self.check(**kwargs)
        with self.assertRaisesRegex(Contradiction,'function_missing_column'):self.check(item='COUNT(missing)')
        with self.assertRaisesRegex(ReviewNeeded,'function_identity_unknown'):
            check_documented_sum_types(['COUNT(qty)'],['BIGINT'],['qty'],['INT'],mode='M',identity='m_builtin_count')


class CountConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()

    def manifest(self):
        self.assertTrue(MID in self.r.manifests,MID);return self.r.manifests[MID]

    def test_six_projections_have_actual_nullable_seed_and_mode_gates(self):
        cs,r=FactorPackageSQLGenerator(self.r).generate_with_report(self.manifest())
        self.assertTrue(r.pairwise_complete)
        self.assertEqual({c.sql for c in cs},{f'SELECT COUNT({mod}{col}) AS result FROM {TABLE};'
            for col in ('id','qty') for mod in ('','ALL ','DISTINCT ')})
        for c in cs:
            self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA m_select_count_ns;',
                f'CREATE TABLE {TABLE} (id INTEGER, qty INTEGER);',
                f'INSERT INTO {TABLE} (id,qty) VALUES (1,NULL),(1,1),(1,2),(1,2),(2,NULL),(2,NULL);'])
            self.assertEqual(c.teardown_sqls,[f'DROP TABLE {TABLE} RESTRICT;','DROP SCHEMA m_select_count_ns;'])
            gates={g['key']:g['allowed_values'] for g in c.environment_requirements}
            self.assertEqual(gates['compatibility_mode'],['M'])
            self.assertEqual(gates['function_resolution'],['m_builtin_count'])
            self.assertEqual(c.expected_scope,'syntax_only')
        fx=self.r.fixtures['fixture_m_select_count_source']
        self.assertTrue(fx.seed.required)
        self.assertEqual(fx.seed.rows,[dict(id=i,qty=q) for i,q in ((1,None),(1,1),(1,2),(1,2),(2,None),(2,None))])

    def test_wrong_mode_identity_and_mismatched_actual_ddl_fail(self):
        for key,values in (('compatibility_mode',['general']),('function_resolution',['m_builtin_sum']),
                           ('function_resolution',['m_builtin_count','unknown'])):
            m=copy.deepcopy(self.manifest());next(g for g in m.environment_requirements if g.key==key).allowed_values=values
            with self.subTest(key=key),self.assertRaisesRegex(GenerationValidationError,'function_resolution'):
                FactorPackageSQLGenerator(self.r).generate_with_report(m)
        g=FactorPackageSQLGenerator(self.r);original=g._compile_fixture_lifecycle
        def changed(refs):
            setup,down=original(refs)
            return [s.replace('qty INTEGER','qty TEXT') for s in setup],down
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=changed):
            with self.assertRaises(GenerationValidationError):g.generate_with_report(self.manifest())

    def test_null_and_duplicate_results_are_planned_not_database_proof(self):
        self.manifest();s=self.r.scenarios['scenario_m_select_count_nullable']
        self.assertEqual(s.status,'planned');self.assertEqual(len(s.steps),6)
        self.assertEqual([o['expected'] for o in s.oracles if o['kind']=='result_set'],
                         [[[6]],[[6]],[[2]],[[3]],[[3]],[[2]]])
        metadata=[o for o in s.oracles if o['kind']=='manual_assertion']
        self.assertEqual(len(metadata),6);self.assertTrue(all('BIGINT' in o['expected'] for o in metadata))
        self.assertEqual({o['step_id'] for o in metadata},{s['id'] for s in s.steps})
        self.assertIn('per_step_oracle',s.execution_requirements)
        self.assertIn('target_oracle_calibration',s.execution_requirements)

    def test_builder_and_actual_source_interval_match(self):
        self.manifest();ledger=self.r.source_ledgers['source_ledger_m_select']
        s=next(s for s in ledger.supplemental_sources if s.id=='m_select_count_signature_source')
        self.assertEqual(s.source_anchor,'L338-388')
        self.assertEqual(s.catalog_chapter_ref.chapter_sha256,'ca0c02156ff890f3b89fb2e200133acde2be0b10f7d5bb06af2c67d8c9900db9')
        for name,value in select().finish().items():
            self.assertEqual(yaml.safe_load((ROOT/'specs/dml/m_select'/name).read_text()),value,name)


if __name__=='__main__':unittest.main()
