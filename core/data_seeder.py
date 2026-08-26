"""测试数据自动发生器 (Data Seeder)：

根据 TableSymbol 中各列的数据类型与约束，
自动生成包含典型代表值、极值与边界值的高语义密度合成数据，
解决“空表导致 DML/查询优化器测试无意义”的痛点。
"""
from typing import List, Dict, Any, Optional
from .symbol_table import TableSymbol, ColumnSymbol, infer_type_category


class DataSeeder:
    """基于类型感知的测试数据合成发生器。"""

    @classmethod
    def generate_seed_rows(cls, table: TableSymbol, row_count: int = 5) -> List[Dict[str, str]]:
        """为指定表生成多行具备边界特征的字段值映射字典。"""
        cols = table.columns
        if not cols:
            return []

        rows: List[Dict[str, str]] = []
        for i in range(1, row_count + 1):
            row_data: Dict[str, str] = {}
            for col in cols:
                row_data[col.name] = cls._generate_value_for_column(col, row_index=i)
            rows.append(row_data)
        return rows

    @classmethod
    def generate_insert_sqls(cls, table: TableSymbol, row_count: int = 5) -> List[str]:
        """生成一组可以直接执行的 INSERT SQL 语句。"""
        rows = cls.generate_seed_rows(table, row_count)
        if not rows:
            return []

        col_names = [c.name for c in table.columns]
        col_list_str = ", ".join(col_names)

        sqls: List[str] = []
        for row in rows:
            val_strs = [row[c] for c in col_names]
            val_list_str = ", ".join(val_strs)
            sql = f"INSERT INTO {table.name} ({col_list_str}) VALUES ({val_list_str})"
            sqls.append(sql)
        return sqls

    @classmethod
    def _generate_value_for_column(cls, col: ColumnSymbol, row_index: int) -> str:
        """根据列类型与行号生成边界值。"""
        cat = col.category or infer_type_category(col.datatype)

        # 第一行测试基本正常值
        if row_index == 1:
            if col.is_primary_key:
                return "1"
            if cat == "numeric":
                return "100"
            elif cat == "string":
                return "'Alice'"
            elif cat == "datetime":
                return "'2026-08-26 09:00:00'"
            elif cat == "boolean":
                return "TRUE"
            elif cat == "json":
                return '\'{"user": "alice", "active": true}\''
            elif cat == "binary":
                return "E'\\\\xAA'"
            return "'val1'"

        # 第二行测试零与空串/边界
        elif row_index == 2:
            if col.is_primary_key:
                return "2"
            if cat == "numeric":
                return "0"
            elif cat == "string":
                return "''"  # 空串
            elif cat == "datetime":
                return "'2000-01-01 00:00:00'"
            elif cat == "boolean":
                return "FALSE"
            elif cat == "json":
                return '\'{"empty": true}\''
            return "'val2'"

        # 第三行测试负数与特殊字符
        elif row_index == 3:
            if col.is_primary_key:
                return "3"
            if cat == "numeric":
                return "-99"
            elif cat == "string":
                return "'O''Reilly'"  # 转义单引号
            elif cat == "datetime":
                return "'2024-02-29 23:59:59'"  # 闰年
            elif cat == "boolean":
                return "TRUE"
            elif cat == "json":
                return '\'{"num": -1}\''
            return "'val3'"

        # 第四行测试 NULL (若允许) 或极大值
        elif row_index == 4:
            if col.is_primary_key:
                return "4"
            if col.is_nullable:
                return "NULL"
            if cat == "numeric":
                return "999999"
            elif cat == "string":
                return "'Bob_Senior'"
            return "'val4'"

        # 其余行
        else:
            if col.is_primary_key:
                return str(row_index)
            if cat == "numeric":
                return str(row_index * 10)
            return f"'sample_{row_index}'"
