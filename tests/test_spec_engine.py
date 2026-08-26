"""单元测试：验证文法解耦规格引擎 (Spec Engine, Linter, Generator, Seeder)。"""
import os
import unittest

from core.spec_model import SpecRegistry, SyntaxDef, MatrixDef, ManifestDef
from core.spec_linter import SpecLinter
from core.spec_generator import SpecSQLGenerator
from core.data_seeder import DataSeeder
from core.symbol_table import TableSymbol, ColumnSymbol, SchemaContext


class TestSpecEngine(unittest.TestCase):

    def setUp(self):
        self.base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.registry = SpecRegistry(self.base_dir)
        self.registry.load_all()

    def test_spec_registry_loading(self):
        self.assertIn("syntax_create_table", self.registry.syntaxes)
        self.assertIn("syntax_select", self.registry.syntaxes)
        self.assertIn("matrix_gaussdb_core", self.registry.matrices)
        self.assertIn("manifest_create_table_matrix", self.registry.manifests)
        self.assertIn("manifest_select_tlp", self.registry.manifests)

    def test_spec_linter_validation(self):
        linter = SpecLinter(self.registry)
        issues = linter.lint_all()
        # 确保没有阻断性 ERROR
        errors = [i for i in issues if i.level == "ERROR"]
        self.assertEqual(len(errors), 0, f"Linter 报错: {errors}")

    def test_data_seeder_generation(self):
        table = TableSymbol(
            name="t_seed_demo",
            columns=[
                ColumnSymbol(name="id", datatype="INTEGER", is_primary_key=True),
                ColumnSymbol(name="name", datatype="VARCHAR(100)"),
                ColumnSymbol(name="created_at", datatype="DATE"),
            ]
        )

        rows = DataSeeder.generate_seed_rows(table, row_count=4)
        self.assertEqual(len(rows), 4)
        # 第一行正常值
        self.assertEqual(rows[0]["id"], "1")
        self.assertEqual(rows[0]["name"], "'Alice'")
        # 第三行带特殊字符
        self.assertIn("O''Reilly", rows[2]["name"])

        # 生成 SQL
        sqls = DataSeeder.generate_insert_sqls(table, row_count=3)
        self.assertEqual(len(sqls), 3)
        self.assertTrue(all(s.startswith("INSERT INTO t_seed_demo") for s in sqls))

    def test_spec_generator_sql_and_oracle_derivation(self):
        generator = SpecSQLGenerator(self.registry)
        manifest = self.registry.get_manifest("manifest_create_table_matrix")
        self.assertIsNotNone(manifest)

        cases = generator.generate_cases_for_manifest(manifest)
        self.assertGreater(len(cases), 0)

        # 检查 CSP 约束剪枝：临时表 + 列存 必须被剔除
        for c in cases:
            self.assertFalse(
                c.params.get("table_modifier") == "TEMPORARY" and
                c.params.get("storage_options") == "WITH (ORIENTATION = COLUMN)"
            )

        # 检查非法类型 FAKETYPE 自动推导预期为 error 且带有 expected_sqlstates
        faketype_cases = [c for c in cases if c.params.get("column_datatype") == "FAKETYPE"]
        self.assertGreater(len(faketype_cases), 0)
        for fc in faketype_cases:
            self.assertEqual(fc.expected, "error")
            self.assertIn("42704", fc.expected_sqlstates)


if __name__ == "__main__":
    unittest.main()
