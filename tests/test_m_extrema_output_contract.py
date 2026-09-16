"""M MIN/MAX direct field typing, not arbitrary MySQL expression evaluation."""
from tests.evolved_asset_assertions import assert_evolved_asset
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
import yaml
from core import query_output_contract as contract
from core.finite_sql_contract import Contradiction, ReviewNeeded
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_pilot import select

ROOT=Path(__file__).resolve().parents[1]


class MExtremaTypeTests(unittest.TestCase):
    def check(self, fn='MIN', typ='INTEGER', output='INTEGER', expression=None, mode='M', identity=None):
        self.assertTrue(hasattr(contract,'check_documented_aggregate_types'))
        return contract.check_documented_aggregate_types([expression or f'{fn}(qty) AS result'],[output],
            ['qty'],[typ],mode=mode,identity=identity or 'm_builtin_'+fn.lower())

    def test_fields_preserve_integer_type_but_float_widens(self):
        for fn in ('MIN','MAX'):
            for typ in ('INT','INTEGER','INT4'):
                self.assertEqual(self.check(fn,typ),[0])
            self.assertEqual(self.check(fn,'FLOAT','DOUBLE'),[0])
            with self.assertRaisesRegex(Contradiction,'function_output_type_mismatch'):
                self.check(fn,output='DECIMAL')
            with self.assertRaisesRegex(Contradiction,'function_output_type_mismatch'):
                self.check(fn,'FLOAT','FLOAT')

    def test_mode_identity_and_non_field_expressions_do_not_inherit_contract(self):
        for fn in ('MIN','MAX'):
            for kw in ({'mode':'general'},{'mode':None},{'identity':'user_function'},
                       {'expression':f'{fn}(7)'},{'expression':f'{fn}(qty+1)'},
                       {'expression':f'{fn}(CAST(qty AS INT))'}, {'expression':f'{fn}(qty) OVER ()'},
                       {'expression':f'app.{fn}(qty)'},{'expression':f'{fn}("qty")'},
                       {'expression':'MİN(qty)'},{'expression':f'{fn}(NULL)'}):
                with self.subTest(fn=fn,kw=kw),self.assertRaises(ReviewNeeded):self.check(fn,**kw)
            for typ in ('TEXT','BIGINT','DECIMAL(10,2)','SET','BOOLEAN'):
                with self.subTest(typ=typ),self.assertRaisesRegex(ReviewNeeded,'function_argument_type_unknown'):
                    self.check(fn,typ,typ)

    def test_all_distinct_and_missing_column_still_have_exact_identity(self):
        for fn in ('MIN','MAX'):
            for modifier in ('','ALL ','DISTINCT '):
                self.assertEqual(self.check(fn,expression=f'{fn}({modifier}qty)'),[0])
            with self.assertRaisesRegex(Contradiction,'function_missing_column'):
                self.check(fn,expression=f'{fn}(absent)')
            with self.assertRaisesRegex(ReviewNeeded,'function_expression_unknown'):
                self.check(fn,expression='MAX(qty)' if fn=='MIN' else 'MIN(qty)')

    def test_arity_and_legacy_sum_contract_are_not_relaxed(self):
        self.check()
        for outputs,columns,types in (([],['qty'],['INT']),(['INT'],['qty'],[])):
            with self.assertRaisesRegex(Contradiction,'function_.*arity'):
                contract.check_documented_aggregate_types(['MIN(qty)'],outputs,columns,types,
                    mode='M',identity='m_builtin_min')
        with self.assertRaisesRegex(ReviewNeeded,'function_identity_unknown'):
            contract.check_documented_sum_types(['MIN(qty)'],['INT'],['qty'],['INT'],mode='M',identity='m_builtin_min')
        self.assertEqual(contract.check_documented_aggregate_types(['SUM(qty)'],['DECIMAL'],['qty'],['INT'],
            mode='M',identity='m_builtin_sum'),[0])


class AggregateRenderedIdentityTests(unittest.TestCase):
    def render_check(self,fn,actual,profile):
        return contract.check_rendered_aggregate_source('SELECT '+actual+' FROM t',
            ['CREATE TABLE t (qty INT, allqty INT, distinctqty INT);'],items=[profile],
            output_types=['DECIMAL' if fn=='SUM' else 'INTEGER'],
            available_columns=['qty','allqty','distinctqty'],available_types=['INT']*3,
            source_tables=['t'],mode='M',identity='m_builtin_'+fn.lower())

    def test_whitespace_does_not_merge_all_or_distinct_into_a_different_column(self):
        for fn in ('SUM','MIN','MAX'):
            for modifier in ('ALL','DISTINCT'):
                with self.subTest(fn=fn,modifier=modifier),self.assertRaisesRegex(
                        Contradiction,'query_projection_mismatch'):
                    self.render_check(fn,f'{fn}({modifier.lower()}qty)',f'{fn}({modifier} qty)')

    def test_spacing_between_same_tokens_remains_equivalent(self):
        for fn in ('SUM','MIN','MAX'):
            self.render_check(fn,f'{fn.lower()} ( ALL  qty ) AS total',f'{fn}(ALL qty) AS total')


class MExtremaIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()

    def manifest(self,fn):
        mid=f'manifest_m_select_{fn}_builtin'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.r.manifests[mid]

    def test_four_actual_queries_with_distinct_exact_identity_gates(self):
        for fn in ('min','max'):
            cs,r=FactorPackageSQLGenerator(self.r).generate_with_report(self.manifest(fn))
            self.assertEqual({c.sql for c in cs},{f'SELECT {fn.upper()}({col}) AS result FROM m_b01_source;'
                             for col in ('id','qty')})
            self.assertEqual(len(cs),2);self.assertTrue(r.pairwise_complete)
            for c in cs:
                gates={g['key']:g['allowed_values'] for g in c.environment_requirements}
                self.assertEqual(gates['function_resolution'],['m_builtin_'+fn])
                self.assertEqual(gates['compatibility_mode'],['M'])
                self.assertEqual(c.expected_scope,'syntax_only')

    def test_removed_widened_or_other_function_gate_is_rejected(self):
        for fn in ('min','max'):
            for value in ([],['m_builtin_'+fn,'unknown'],['m_builtin_sum']):
                m=copy.deepcopy(self.manifest(fn))
                gate=next(g for g in m.environment_requirements if g.key=='function_resolution')
                if value:gate.allowed_values=value
                else:m.environment_requirements.remove(gate)
                with self.subTest(fn=fn,value=value),self.assertRaisesRegex(GenerationValidationError,'function_resolution'):
                    FactorPackageSQLGenerator(self.r).generate_with_report(m)

    def test_real_fixture_and_final_projection_cannot_be_overridden_by_profile(self):
        m=self.manifest('min')
        g=FactorPackageSQLGenerator(self.r)
        compile_fx=g._compile_fixture_lifecycle
        def changed_fixture(refs):
            setup,down=compile_fx(refs)
            return [s.replace('qty INT DEFAULT 9','qty BIGINT DEFAULT 9') for s in setup],down
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=changed_fixture):
            with self.assertRaisesRegex(GenerationValidationError,'source_type_mismatch'):g.generate_with_report(m)
        render=g._render_sql_with_consumption
        def changed_render(*args):
            sql,consumed=render(*args)
            return sql.replace('MIN(qty)','MAX(qty)'),consumed
        with patch.object(g,'_render_sql_with_consumption',side_effect=changed_render):
            with self.assertRaisesRegex(GenerationValidationError,'query_projection_mismatch'):g.generate_with_report(m)

    def test_provider_source_and_scenarios_keep_runtime_identity_uncalibrated(self):
        self.manifest('min')
        ledger=self.r.source_ledgers['source_ledger_m_select']
        for fn,span,result in (('max','L574-591',30),('min','L635-652',10)):
            source=next(s for s in ledger.supplemental_sources if s.id==f'm_select_{fn}_signature_source')
            self.assertEqual(source.source_anchor,span)
            self.assertEqual(source.catalog_chapter_ref.chapter_sha256,
                'ca0c02156ff890f3b89fb2e200133acde2be0b10f7d5bb06af2c67d8c9900db9')
            scenario=self.r.scenarios[f'scenario_m_select_{fn}_result']
            self.assertEqual(scenario.status,'planned')
            self.assertEqual(scenario.oracles[0]['expected'],[[result]])
            self.assertIn('target_oracle_calibration',scenario.execution_requirements)
            self.assertTrue(any('function_resolution=m_builtin_'+fn in p for p in scenario.preconditions))
        for name,obj in select().finish().items():
            assert_evolved_asset(self, yaml.safe_load((ROOT/'specs/dml/m_select'/name).read_text()),obj,name)


if __name__=='__main__':unittest.main()
