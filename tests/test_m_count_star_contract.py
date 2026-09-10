"""COUNT(*) counts rows; it is not COUNT of a nullable field or DISTINCT *."""
import copy
from pathlib import Path
import unittest
import yaml
from core.query_output_contract import check_documented_aggregate_types,check_rendered_aggregate_source
from core.finite_sql_contract import ReviewNeeded,Contradiction
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError
from scripts.build_m_compat_pilot import select
ROOT=Path(__file__).resolve().parents[1];TABLE='m_select_count_ns.source_table'


class CountStarTypeTests(unittest.TestCase):
    def check(self,item='COUNT(*)',output='BIGINT',mode='M',identity='m_builtin_count'):
        return check_documented_aggregate_types([item],[output],['qty'],['INTEGER'],mode=mode,identity=identity)
    def test_star_has_its_own_bigint_type_branch(self):
        for item in ('COUNT(*)','count( * ) AS result'):
            self.assertEqual(self.check(item),[0])
        for output in ('INTEGER','DECIMAL','DOUBLE'):
            with self.subTest(output=output),self.assertRaisesRegex(Contradiction,'function_output_type_mismatch'):
                self.check(output=output)
    def test_star_does_not_enable_other_expressions_functions_or_modes(self):
        for item in ('COUNT(ALL *)','COUNT(DISTINCT *)','COUNT(t.*)','COUNT(*,qty)',
                     'COUNT(*) OVER ()','COUNT(*) AS reſult','app.COUNT(*)'):
            with self.subTest(item=item),self.assertRaises(ReviewNeeded):self.check(item=item)
        for kwargs in ({'mode':'general'},{'identity':'m_builtin_sum'},{'output':'BıGINT'}):
            with self.subTest(kwargs=kwargs),self.assertRaises(ReviewNeeded):self.check(**kwargs)


class CountStarConsumerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
    def manifest(self):
        mid='manifest_m_select_count_star';self.assertTrue(mid in self.r.manifests,mid)
        return self.r.manifests[mid]
    def test_star_reuses_exact_nullable_fixture_and_keeps_oracles_planned(self):
        g=FactorPackageSQLGenerator(self.r);cs,_=g.generate_with_report(self.manifest());c,=cs
        fields,_=g.generate_with_report(self.r.manifests['manifest_m_select_count_nullable'])
        self.assertEqual(c.sql,f'SELECT COUNT(*) AS result FROM {TABLE};')
        self.assertEqual(c.setup_sqls,fields[0].setup_sqls);self.assertEqual(c.teardown_sqls,fields[0].teardown_sqls)
        self.assertEqual((c.expected,c.expected_scope),('success','syntax_only'))
        s=self.r.scenarios['scenario_m_select_count_star'];self.assertEqual(s.status,'planned')
        self.assertEqual([o['expected'] for o in s.oracles if o['kind']=='result_set'],[[[6]]])
        self.assertTrue(any(o['kind']=='manual_assertion' and 'BIGINT' in o['expected'] for o in s.oracles))
        self.assertIn('per_step_oracle',s.execution_requirements)
        self.assertIn('target_oracle_calibration',s.execution_requirements)
    def test_actual_source_projection_identity_and_builder_are_required(self):
        m=self.manifest();wrong=copy.deepcopy(m)
        next(g for g in wrong.environment_requirements if g.key=='function_resolution').allowed_values=['m_builtin_sum']
        with self.assertRaisesRegex(GenerationValidationError,'function_resolution'):
            FactorPackageSQLGenerator(self.r).generate_with_report(wrong)
        kwargs=dict(items=['COUNT(*) AS result'],output_types=['BIGINT'],available_columns=['id','qty'],
                    available_types=['INTEGER','INTEGER'],source_tables=[TABLE],mode='M',identity='m_builtin_count')
        ddl=f'CREATE TABLE {TABLE}(id INTEGER, qty INTEGER);'
        sql=f'SELECT COUNT(*) AS result FROM {TABLE};'
        e=check_rendered_aggregate_source(sql,[ddl],**kwargs);self.assertEqual(e['source_table'],TABLE)
        with self.assertRaisesRegex(Contradiction,'query_projection_mismatch'):
            check_rendered_aggregate_source(sql.replace('COUNT(*)','COUNT(qty)'),[ddl],**kwargs)
        with self.assertRaisesRegex(ReviewNeeded,'query_source_unknown'):
            check_rendered_aggregate_source(sql,[],**kwargs)
        for name,value in select().finish().items():
            self.assertEqual(yaml.safe_load((ROOT/'specs/dml/m_select'/name).read_text()),value,name)


if __name__=='__main__':unittest.main()
