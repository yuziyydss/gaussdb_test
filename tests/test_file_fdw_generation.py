"""End-to-end format consumption and actual file identity, no database."""
from pathlib import Path
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.spec_generator import GenerationValidationError

ROOT = Path(__file__).resolve().parents[1]


class FileFDWGenerationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r = FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g = FactorPackageSQLGenerator(cls.r)

    def cases(self, fmt):
        return self.g.generate_with_report(self.r.manifests['manifest_create_foreign_table_file_'+fmt])[0]

    def test_format_is_rendered_and_real_local_bytes_are_bound(self):
        for fmt in ('text','csv'):
            cases = self.cases(fmt); self.assertEqual(len(cases),1)
            c = cases[0]
            self.assertIn('format',c.consumed_dimension_ids)
            self.assertIn("OPTIONS (format '"+fmt+"', filename '",c.sql)
            self.assertEqual(len(c.file_assets),1)
            self.assertFalse(c.file_assets[0]['deployed'])
            self.assertEqual(c.file_assets[0]['row_count'],3)
            self.assertIn('file_fdw',c.setup_sqls[0])
            self.assertEqual(c.expected_scope,'syntax_only')
            s=self.r.scenarios['scenario_create_foreign_table_file_'+fmt]
            self.assertEqual(s.status,'planned')
            self.assertEqual(s.oracles[0]['expected'],[[1,10],[2,20],[3,30]])

    def test_wrong_wrapper_gates_paths_layout_and_cleanup_are_rejected(self):
        original = self.g._compile_fixture_lifecycle
        with patch.object(self.g,'_compile_fixture_lifecycle',side_effect=lambda refs:
                          ([x.replace('file_fdw','log_fdw') for x in original(refs)[0]],original(refs)[1])):
            with self.assertRaisesRegex(GenerationValidationError,'file_fdw'): self.cases('csv')
        m=self.r.manifests['manifest_create_foreign_table_file_csv'].model_copy(deep=True)
        m.environment_requirements=[]
        with self.assertRaisesRegex(GenerationValidationError,'file_fdw'):self.g.generate_with_report(m)
        render=self.g._render_sql_with_consumption
        for old,new in [("format 'csv'","format 'text'"),("header 'false'","header 'true'"),
                        ('rows.csv','missing.csv'),("encoding 'UTF8'","encoding 'UTF8', format 'csv'")]:
            def changed(*args):
                sql,consumed=render(*args);return sql.replace(old,new),consumed
            with self.subTest(new=new),patch.object(self.g,'_render_sql_with_consumption',side_effect=changed):
                with self.assertRaises((ValueError,GenerationValidationError)):self.cases('csv')
        with patch.object(self.g,'_compile_fixture_lifecycle',side_effect=lambda refs:
                          (original(refs)[0],[x.replace('RESTRICT','CASCADE') for x in original(refs)[1]])):
            with self.assertRaisesRegex(GenerationValidationError,'file_fdw'):self.cases('text')

    def test_format_cannot_be_marked_consumed_without_matching_sql(self):
        render = self.g._render_sql_with_consumption
        def unconsumed(*args):
            sql, consumed = render(*args)
            return sql, [item for item in consumed if item != 'format']
        with patch.object(self.g, '_render_sql_with_consumption', side_effect=unconsumed):
            with self.assertRaisesRegex(GenerationValidationError, 'consumed format'):
                self.cases('csv')
        for old, new in [('qty INTEGER', 'qty TEXT'), ("format 'csv', ", '')]:
            def changed(*args):
                sql, consumed = render(*args)
                return sql.replace(old, new), consumed
            with self.subTest(new=new), patch.object(self.g, '_render_sql_with_consumption', side_effect=changed):
                with self.assertRaises((ValueError, GenerationValidationError)):
                    self.cases('csv')

    def test_local_csv_shape_hash_and_target_must_agree(self):
        from core.fixture_file_contract import inspect_fixture_files
        key='fixture_create_foreign_table_file_csv'
        for field,value in [('sha256','0'*64),('format','integer_tsv'),('column_count',1),('row_count',99)]:
            fixture=self.r.fixtures[key].model_copy(deep=True)
            setattr(fixture.provides.files[0],field,value)
            with self.subTest(field=field),self.assertRaises(ValueError):
                inspect_fixture_files(fixture,self.r.source_paths[key],self.r.specs_dir)

    def test_csv_assets_do_not_widen_load_data_file_contract(self):
        key = 'fixture_create_foreign_table_file_csv'
        path = self.r.fixtures[key].provides.files[0].target_path
        with self.assertRaisesRegex(ValueError, 'CSV file asset requires reviewed'):
            self.g._compile_fixture_files([key], f"LOAD DATA INFILE '{path}' INTO TABLE t;", [])

    def test_remaining_binary_fixed_are_visible_not_waived(self):
        audit=FactorCoverageAuditor(self.r).audit('create_foreign_table')
        self.assertEqual(audit['values']['coverage_gaps'],[
            'format.create_foreign_table_format_binary','format.create_foreign_table_format_fixed'])
        self.assertFalse(audit['conclusions']['generation_model_complete'])
        self.assertFalse(audit['conclusions']['behavior_coverage_complete'])
        self.assertIn('copy',self.r.factor_dependency_graph()['create_foreign_table'])
        self.r.factor_topological_order()


if __name__=='__main__':unittest.main()
