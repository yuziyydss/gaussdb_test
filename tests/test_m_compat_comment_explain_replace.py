from tests.evolved_asset_assertions import assert_evolved_asset
import copy
import unittest
from pathlib import Path
import yaml

from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.shared_column_contract import ordinary_columns
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]


class MCommentExplainReplaceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def cases(self,name):
        return self.g.generate_cases_for_manifest(self.r.manifests['manifest_m_'+name])

    def test_comment_null_and_real_object_dependencies(self):
        for name,ddl in [('table','CREATE TABLE m_b01_source '),('view','CREATE VIEW m_b01_view '),
            ('index','CREATE INDEX m_b03_existing_index '),('sequence','CREATE SEQUENCE m_b03_existing_seq ')]:
            cases=self.cases('comment_'+name)
            self.assertTrue(any(c.sql.endswith(' IS NULL;') for c in cases))
            for c in cases:
                self.assertTrue(any(s.startswith(ddl) for s in c.setup_sqls),(name,c.setup_sqls))
                self.assertTrue(any(e['key']=='object_authority' for e in c.environment_requirements))
                self.assertFalse(any('DROP OWNED' in s or 'DROP ROLE' in s for s in c.teardown_sqls))

    def test_explain_dml_does_not_silently_analyze(self):
        for c in self.cases('explain_dml_plan_only'):
            self.assertIn('ANALYZE FALSE',c.sql)
            self.assertIn('BUFFERS FALSE',c.sql)
            self.assertRegex(c.sql,r'\) (INSERT|UPDATE|DELETE) ')
        for c in self.cases('explain_query_options'):
            self.assertNotRegex(c.sql,r'\b(DETAIL|NODES|NUM_NODES|PLAN|OPTEVAL|PERFORMANCE)\b')
        for c in self.cases('explain_query_ordered'):
            self.assertNotIn('VERBOSE ANALYZE',c.sql)

    def test_buffers_without_analyze_fails_solver(self):
        f=self.r.factors['m_explain'];m=self.r.manifests['manifest_m_explain_query_options']
        combo={k:v.default_value_id for k,v in f.dimensions.items()}
        combo['buffers']='m_explain_buffers_on';combo['analyze']='m_explain_analyze_off'
        solver=self.g._build_solver(f,m,self.r.resolve_dimension_values(f.id))
        self.assertTrue(solver.is_valid(combo)[0])

    def test_replace_real_primary_key_default_and_query_source(self):
        for name in ('values','query','set'):
            for c in self.cases('replace_'+name):
                ddl=c.setup_sqls[0];cols=ordinary_columns(ddl)
                self.assertIn('PRIMARY KEY',ddl)
                self.assertFalse(cols['id']['nullable'])
                self.assertEqual(cols['id']['default_sql'],'2')
                self.assertEqual(cols['qty']['default_sql'],'9')
                self.assertIn('INSERT INTO m_replace_target(id,qty) VALUES (1,10),(2,20);',c.setup_sqls)
                if name=='query':
                    self.assertIn('CREATE TABLE m_replace_source(id INT,qty INT);',c.setup_sqls)
                    self.assertIn('SELECT id,qty FROM m_replace_source',c.sql)
                if name=='set':self.assertNotIn('m_replace_target (id,qty)',c.sql)

    def test_replace_reuses_input_contract_rejects_wrong_arity_and_type(self):
        f=self.r.factors['m_replace'];resolved=self.r.resolve_dimension_values(f.id)
        combo={k:v.default_value_id for k,v in f.dimensions.items()}
        source=combo['source_profile']
        bad=copy.deepcopy(resolved)
        bad['source_profile'][source].attributes['source_profile.properties.output_column_count']=1
        bad['source_profile'][source].attributes['source_profile.properties.output_types']=['INTEGER']
        with self.assertRaisesRegex(GenerationValidationError,'目标列数与输入列数不一致'):
            self.g._validate_structural_contract(f,combo,bad)
        bad=copy.deepcopy(resolved)
        bad['source_profile'][source].attributes['source_profile.properties.output_types']=['INTEGER','TEXT']
        with self.assertRaisesRegex(GenerationValidationError,'类型不兼容'):
            self.g._validate_structural_contract(f,combo,bad)

    def test_real_defaults_not_current_row_in_replace_set(self):
        cases=self.cases('replace_set')
        self.assertTrue(any('SET id=id+1, qty=id' in c.sql for c in cases))
        s=self.r.scenarios['scenario_m_replace_set_default_lineage']
        self.assertEqual(s.status,'planned')
        self.assertTrue(any(o.get('expected')==[[3,3]] for o in s.oracles))

    def test_current_specs_load_and_generate(self):
        for fid in ('m_comment','m_explain','m_replace'):
            for mid in self.r.factors[fid].manifest_refs:
                cases,report=self.g.generate_with_report(self.r.manifests[mid])
                self.assertTrue(cases)
                self.assertTrue(report.pairwise_complete)
        values=self.r.resolve_dimension_values('m_replace')['source_profile']
        self.assertEqual(values['m_replace_source_profile_new'].attributes['source_profile.properties.items'],['(4,40)'])
        self.assertEqual(values['m_replace_source_profile_query'].attributes['source_profile.properties.items'],[])

