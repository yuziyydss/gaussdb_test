"""Bounded inline INDEX/SEQUENCE candidates; no database or rollback assumption."""
from pathlib import Path
import unittest
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator


class SchemaInlineAssetTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root=Path(__file__).resolve().parents[1]
        cls.r=FactorPackageRegistry(cls.root/'specs');cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def case(self, suffix):
        mid='manifest_create_schema_inline_'+suffix
        self.assertTrue(mid in self.r.manifests,mid)
        cases,report=self.g.generate_with_report(self.r.manifests[mid])
        self.assertEqual(len(cases),1)
        self.assertTrue(report.pairwise_complete)
        self.assertEqual(cases[0].expected_scope,'syntax_only')
        return cases[0]

    def test_inline_index_follows_its_actual_table_in_one_statement(self):
        c=self.case('index')
        self.assertEqual(c.sql,'CREATE SCHEMA fp_cs_new CREATE TABLE fp_cs_new.t_cs_index (id INTEGER) WITH (storage_type=astore) CREATE INDEX fp_cs_new.i_cs_index ON fp_cs_new.t_cs_index USING btree (id);')
        self.assertEqual(c.setup_sqls,['SHOW search_path;'])
        self.assertEqual(c.teardown_sqls,['DROP TABLE fp_cs_new.t_cs_index PURGE;','DROP SCHEMA fp_cs_new RESTRICT;'])

    def test_sequence_is_qualified_and_not_mistaken_for_owned_by_default(self):
        c=self.case('sequence')
        self.assertEqual(c.sql,'CREATE SCHEMA fp_cs_new CREATE SEQUENCE fp_cs_new.s_cs_inline START WITH 101 INCREMENT BY 10;')
        self.assertEqual(c.setup_sqls,['SHOW search_path;'])
        self.assertEqual(c.teardown_sqls,['DROP SEQUENCE fp_cs_new.s_cs_inline RESTRICT;','DROP SCHEMA fp_cs_new RESTRICT;'])
        self.assertNotIn('OWNED BY',c.sql)

    def test_selected_value_alone_supplies_cleanup_and_no_preexisting_fake_table(self):
        for suffix in ('index','sequence'):
            c=self.case(suffix)
            m=self.r.manifests['manifest_create_schema_inline_'+suffix].model_copy(deep=True)
            m.fixture_refs=[]
            other=self.g.generate_cases_for_manifest(m)[0]
            self.assertEqual(other.teardown_sqls,c.teardown_sqls)
            f=self.r.fixtures['fixture_create_schema_inline_'+suffix]
            self.assertEqual(f.provides.tables,[])
            self.assertNotIn('CASCADE',' '.join(c.teardown_sqls))
            self.assertIn('current_schema',f.execution.note)
            self.assertIn('ownership',f.execution.note)

    def test_creation_dependencies_are_real_and_cleanup_cycle_is_not_hidden(self):
        self.case('index');self.case('sequence')
        g=self.r.factor_dependency_graph()
        self.assertTrue({'create_index','create_sequence','create_table'}<=g['create_schema'])
        self.assertIn('create_schema',g['drop_schema'])
        self.assertNotIn('drop_schema',g['create_schema'])
        ledger=self.r.source_ledgers['source_ledger_create_schema']
        paths={s.catalog_chapter_ref.source_relpath for s in ledger.supplemental_sources if s.catalog_chapter_ref}
        self.assertTrue({'general/ddl/drop_schema.txt','general/ddl/drop_table.txt','general/ddl/drop_sequence.txt'}<=paths)
        for suffix in ('index','sequence'):
            s=self.r.scenarios['scenario_create_schema_inline_'+suffix]
            self.assertIn('phase_dependency_review',s.execution_requirements)
            self.assertEqual(s.status,'planned')

    def test_sequence_result_oracle_is_bound_to_two_separate_calls_and_still_planned(self):
        self.case('sequence')
        s=self.r.scenarios['scenario_create_schema_inline_sequence']
        checks=[o for o in s.oracles if o['kind']=='result_set']
        self.assertEqual([(o['after_step'],o['expected']) for o in checks],[('first_value',[[101]]),('second_value',[[111]])])
        self.assertIn('create_sequence::cs_fact_example_increment',s.fact_refs)
        self.assertIn('target_oracle_calibration',s.execution_requirements)


if __name__=='__main__':unittest.main()
