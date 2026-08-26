"""单元测试：验证符号表 (Symbol Table) 与 SchemaContext 状态机功能。"""
import unittest

from core.symbol_table import (
    ColumnSymbol,
    TableSymbol,
    IndexSymbol,
    SchemaContext,
    infer_type_category,
    generate_sample_literal,
    apply_sql_effect_to_context,
)


class TestSymbolTable(unittest.TestCase):

    def test_semantic_typing_inference(self):
        self.assertEqual(infer_type_category("INTEGER"), "numeric")
        self.assertEqual(infer_type_category("NUMERIC(10,2)"), "numeric")
        self.assertEqual(infer_type_category("VARCHAR(100)"), "string")
        self.assertEqual(infer_type_category("TIMESTAMP WITH TIME ZONE"), "datetime")
        self.assertEqual(infer_type_category("BYTEA"), "binary")
        self.assertEqual(infer_type_category("JSONB"), "json")
        self.assertEqual(infer_type_category("BOOLEAN"), "boolean")

        # 生成字面量
        self.assertEqual(generate_sample_literal("INTEGER"), "100")
        self.assertEqual(generate_sample_literal("VARCHAR(50)"), "'test_val'")

    def test_table_symbol_operations(self):
        col1 = ColumnSymbol(name="id", datatype="INTEGER", is_primary_key=True)
        col2 = ColumnSymbol(name="name", datatype="VARCHAR(100)")
        tbl = TableSymbol(name="t_user", columns=[col1, col2], storage_engine="USTORE")

        self.assertEqual(tbl.column_names(), ["id", "name"])
        self.assertEqual(len(tbl.primary_key_columns()), 1)
        self.assertEqual(tbl.primary_key_columns()[0].name, "id")

        # 添加新列
        tbl.add_column(ColumnSymbol(name="age", datatype="INT"))
        self.assertEqual(tbl.column_names(), ["id", "name", "age"])

        # 删除列
        tbl.drop_column("name")
        self.assertEqual(tbl.column_names(), ["id", "age"])

        # 索引操作
        idx = IndexSymbol(name="idx_user_age", table_name="t_user", columns=["age"], index_type="ubtree")
        tbl.add_index(idx)
        self.assertEqual(len(tbl.indices), 1)
        self.assertEqual(tbl.indices[0].name, "idx_user_age")

        tbl.drop_index("idx_user_age")
        self.assertEqual(len(tbl.indices), 0)

    def test_schema_context_lifecycle_and_pickers(self):
        ctx = SchemaContext(schema_name="test_schema")

        t1 = TableSymbol(
            name="t_orders",
            columns=[
                ColumnSymbol(name="order_id", datatype="BIGINT", is_primary_key=True),
                ColumnSymbol(name="amount", datatype="NUMERIC(10,2)"),
                ColumnSymbol(name="created_at", datatype="TIMESTAMP"),
            ],
            storage_engine="ASTORE"
        )
        t2 = TableSymbol(
            name="t_logs",
            columns=[
                ColumnSymbol(name="log_id", datatype="INT"),
                ColumnSymbol(name="msg", datatype="TEXT"),
            ],
            storage_engine="USTORE"
        )

        ctx.register_table(t1)
        ctx.register_table(t2)

        self.assertTrue(ctx.has_table("t_orders"))
        self.assertTrue(ctx.has_table("t_logs"))
        self.assertEqual(set(ctx.table_names()), {"t_orders", "t_logs"})

        # pick_table 按偏好引擎挑选
        picked_ustore = ctx.pick_table(preferred_engine="USTORE")
        self.assertIsNotNone(picked_ustore)
        self.assertEqual(picked_ustore.name, "t_logs")

        # pick_column 按类型类别挑选
        picked_dt = ctx.pick_column(category="datetime")
        self.assertIsNotNone(picked_dt)
        self.assertEqual(picked_dt.name, "created_at")

        # pick_compatible_columns
        num_cols = ctx.pick_compatible_columns("t_orders", target_category="numeric")
        self.assertEqual(len(num_cols), 2)  # order_id and amount

        # 重命名表
        ctx.rename_table("t_logs", "t_logs_archived")
        self.assertFalse(ctx.has_table("t_logs"))
        self.assertTrue(ctx.has_table("t_logs_archived"))

        # Snapshot & Restore
        snap = ctx.snapshot()
        ctx.drop_table("t_orders")
        self.assertFalse(ctx.has_table("t_orders"))

        ctx.restore(snap)
        self.assertTrue(ctx.has_table("t_orders"))

    def test_apply_sql_effect_to_context(self):
        ctx = SchemaContext(schema_name="sandbox")

        # 1. CREATE TABLE
        sql1 = "CREATE TABLE t_prod ( col_1 INTEGER NOT NULL ) WITH (ORIENTATION = USTORE)"
        apply_sql_effect_to_context(ctx, "create_table", {"table_name": "t_prod", "column_datatype": "INTEGER", "column_constraint": "NOT NULL"}, sql1)

        self.assertTrue(ctx.has_table("t_prod"))
        t_prod = ctx.get_table("t_prod")
        self.assertEqual(t_prod.storage_engine, "USTORE")
        self.assertEqual(t_prod.column_names(), ["col_1"])

        # 2. ALTER TABLE ADD COLUMN
        sql2 = "ALTER TABLE t_prod ADD COLUMN price NUMERIC(10,2)"
        apply_sql_effect_to_context(ctx, "alter_table", {"table_name": "t_prod", "action": "ADD COLUMN price NUMERIC(10,2)"}, sql2)
        self.assertEqual(t_prod.column_names(), ["col_1", "price"])

        # 3. CREATE INDEX
        sql3 = "CREATE INDEX idx_prod_price ON t_prod (price)"
        apply_sql_effect_to_context(ctx, "create_index", {}, sql3)
        self.assertEqual(len(t_prod.indices), 1)
        self.assertEqual(t_prod.indices[0].name, "idx_prod_price")

        # 4. INSERT INTO
        sql4 = "INSERT INTO t_prod (col_1, price) VALUES (1, 99.5)"
        apply_sql_effect_to_context(ctx, "insert_values", {"table_name": "t_prod"}, sql4)
        self.assertEqual(t_prod.row_count_estimate, 1)

        # 5. ALTER TABLE DROP COLUMN
        sql5 = "ALTER TABLE t_prod DROP COLUMN col_1"
        apply_sql_effect_to_context(ctx, "alter_table", {"table_name": "t_prod", "action": "DROP COLUMN col_1"}, sql5)
        self.assertEqual(t_prod.column_names(), ["price"])


if __name__ == "__main__":
    unittest.main()
