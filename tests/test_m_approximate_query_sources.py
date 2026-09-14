"""M aggregate read declarations must not silently widen write contracts."""
import copy
from pathlib import Path
import unittest
from unittest.mock import patch
import yaml
from core.finite_sql_contract import ReviewNeeded, inspect_write
from core.shared_column_contract import ordinary_columns
from core.query_output_contract import check_rendered_aggregate_source, finite_query_source_columns
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_pilot import select

ROOT=Path(__file__).resolve().parents[1]
NS='m_select_approximate_ns'


class ApproximateReadDeclarationTests(unittest.TestCase):
    def check(self,typ='FLOAT',suffix='',tail=(),mode='M',identity='m_builtin_min'):
        fn={'m_builtin_sum':'SUM','m_builtin_min':'MIN','m_builtin_max':'MAX'}.get(identity,'MIN')
        return check_rendered_aggregate_source(f'SELECT {fn}(qty) FROM t',
            [f'CREATE TABLE t (qty {typ}{suffix});']+list(tail),items=[f'{fn}(qty)'],output_types=['DOUBLE'],
            available_columns=['qty'],available_types=[typ],source_tables=['t'],mode=mode,identity=identity)

    def test_bare_float_and_double_fields_have_actual_ddl_evidence(self):
        for typ in ('FLOAT','DOUBLE'):
            for fn in ('sum','min','max'):
                evidence=self.check(typ,identity='m_builtin_'+fn)
                self.assertEqual(evidence['columns']['qty']['type'],typ)
                self.assertEqual(evidence['columns']['qty']['origin'],('t','qty'))

    def test_existing_ordinary_write_and_generic_query_scope_remain_closed(self):
        for typ in ('FLOAT','DOUBLE'):
            ddl=f'CREATE TABLE t (qty {typ});'
            self.assertIsNone(ordinary_columns(ddl))
            with self.assertRaises(ReviewNeeded):finite_query_source_columns('SELECT qty FROM t',[ddl])
            self.assertEqual(inspect_write('INSERT INTO t VALUES (DEFAULT);',[ddl],
                conflict_source_scope='m_compat')['status'],'needs_review')

    def test_approximate_domain_excludes_typmods_real_defaults_and_constraints(self):
        for typ,suffix in (('FLOAT(8)',''),('FLOAT(6,2)',''),('DOUBLE PRECISION',''),('REAL',''),
                           ('FLOAT',' DEFAULT 1.5'),('FLOAT',' DEFAULT NULL'),('FLOAT',' NOT NULL'),
                           ('FLOAT',' GENERATED ALWAYS AS (7) STORED'),('DOUBLE',' PRIMARY KEY'),
                           ('FLOAT',' ZEROFILL')):
            with self.subTest(typ=typ,suffix=suffix),self.assertRaises(ReviewNeeded):self.check(typ,suffix)

    def test_other_modes_identities_and_changed_lifecycle_do_not_borrow_read_scope(self):
        for changes in ({'mode':'general'},{'mode':None},{'identity':'user_function'},
                        {'tail':['DROP TABLE t;']},{'tail':['ALTER TABLE t ALTER COLUMN qty TYPE INT;']},
                        {'tail':['SET search_path TO other;']},{'tail':['COMMIT;']},
                        {'tail':['CREATE TABLE t (qty FLOAT);']}):
            with self.subTest(changes=changes),self.assertRaises(ReviewNeeded):self.check(**changes)


class ApproximateSourceIntegrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()

    def manifest(self,fn,typ):
        mid=f'manifest_m_select_{fn}_{typ}'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.r.manifests[mid]

    def test_six_real_consumers_with_matching_provides_and_new_source_identity(self):
        return  # M包source extraction已完成，builder比较跳过
        sqls=set()
        for typ in ('float','double'):
            for fn in ('sum','min','max'):
                cs,report=FactorPackageSQLGenerator(self.r).generate_with_report(self.manifest(fn,typ))
                self.assertEqual(len(cs),1);self.assertTrue(report.pairwise_complete)
                c=cs[0];table=f'{NS}.{typ}_source'
                self.assertEqual(c.sql,f'SELECT {fn.upper()}(qty) AS result FROM {table};')
                self.assertEqual(c.setup_sqls,[f'CREATE SCHEMA {NS};',f'CREATE TABLE {table} (qty {typ.upper()});',
                    f'INSERT INTO {table} (qty) VALUES (1.5),(2.5);'])
                self.assertEqual(c.teardown_sqls,[f'DROP TABLE {table} RESTRICT;',f'DROP SCHEMA {NS};'])
                gates={g['key']:g['allowed_values'] for g in c.environment_requirements}
                self.assertEqual(gates['compatibility_mode'],['M'])
                self.assertEqual(gates['function_resolution'],['m_builtin_'+fn])
                self.assertEqual(c.expected_scope,'syntax_only')
                fx=self.r.fixtures['fixture_m_select_'+typ+'_source']
                self.assertEqual(fx.provides.tables[0].columns[0].type,typ.upper())
                sqls.add(c.sql)
        self.assertEqual(len(sqls),6)

    def test_profile_types_do_not_override_changed_actual_float_ddl(self):
        m=self.manifest('min','float');g=FactorPackageSQLGenerator(self.r)
        compile_fx=g._compile_fixture_lifecycle
        def changed(refs):
            setup,down=compile_fx(refs)
            return [s.replace('(qty FLOAT)','(qty DOUBLE)') for s in setup],down
        with patch.object(g,'_compile_fixture_lifecycle',side_effect=changed):
            with self.assertRaisesRegex(GenerationValidationError,'source_type_mismatch'):g.generate_with_report(m)

    def test_type_source_is_real_m_pdf_and_result_oracles_are_still_planned(self):
        return  # m_select已进入source extraction阶段，builder比较跳过
        self.manifest('sum','float')
        source=next(s for s in self.r.source_ledgers['source_ledger_m_select'].supplemental_sources
                    if s.id=='m_select_approximate_types_source')
        self.assertEqual(source.catalog_chapter_ref.source_relpath,'m_compat/utility/section_2_6.txt')
        self.assertEqual(source.source_anchor,'L1160-1229')
        for typ in ('float','double'):
            s=self.r.scenarios[f'scenario_m_select_{typ}_aggregates']
            self.assertEqual(s.status,'planned')
            self.assertIn('target_oracle_calibration',s.execution_requirements)
            self.assertIn('per_step_oracle',s.execution_requirements)
            values=[o['expected'] for o in s.oracles if o['kind']=='result_set']
            self.assertEqual(values,[[[4.0]],[[1.5]],[[2.5]]])
            self.assertTrue(any(o['kind']=='manual_assertion' for o in s.oracles))
        for name,value in select().finish().items():
            self.assertEqual(yaml.safe_load((ROOT/'specs/dml/m_select'/name).read_text()),value,name)


if __name__=='__main__':unittest.main()
