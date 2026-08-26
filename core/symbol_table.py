"""数据库符号表 (Symbol Table) 与 SchemaContext：

维护测试执行过程中的数据库物理与逻辑对象状态（表、列、类型、索引、引擎等），
解决“前置因子与被测因子脱节、单表单列、下游因子无法动态消费符号”的问题。
"""
import copy
import re
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Any, Set, Tuple


# ==============================================================================
# 数据类型与语义分类系统 (Semantic Typing)
# ==============================================================================

TYPE_CATEGORY_MAP = {
    # 数值型
    "INT": "numeric", "INTEGER": "numeric", "BIGINT": "numeric", "SMALLINT": "numeric",
    "TINYINT": "numeric", "NUMERIC": "numeric", "DECIMAL": "numeric", "REAL": "numeric",
    "DOUBLE PRECISION": "numeric", "FLOAT": "numeric", "SERIAL": "numeric", "BIGSERIAL": "numeric",
    # 字符型
    "VARCHAR": "string", "CHAR": "string", "TEXT": "string", "NVARCHAR2": "string",
    "VARCHAR2": "string", "CLOB": "string", "CHARACTER VARYING": "string",
    # 日期时间型
    "DATE": "datetime", "TIME": "datetime", "TIMESTAMP": "datetime",
    "TIMESTAMPTZ": "datetime", "INTERVAL": "datetime", "SMALLDATETIME": "datetime",
    # 布尔型
    "BOOLEAN": "boolean", "BOOL": "boolean",
    # 二进制型
    "BYTEA": "binary", "BLOB": "binary", "RAW": "binary",
    # JSON 型
    "JSON": "json", "JSONB": "json",
    # 网络/其他
    "UUID": "uuid", "INET": "network", "CIDR": "network",
}


def infer_type_category(datatype: str) -> str:
    """根据 SQL 数据类型推断其语义大类。"""
    raw = datatype.strip().upper()
    base_type = re.sub(r"\(.*?\)", "", raw).strip()
    if base_type in TYPE_CATEGORY_MAP:
        return TYPE_CATEGORY_MAP[base_type]
    for k, cat in TYPE_CATEGORY_MAP.items():
        if base_type.startswith(k):
            return cat
    return "custom"


def generate_sample_literal(datatype: str, category: str = None) -> str:
    """根据数据类型生成合法的字面量样本值 (用于 DML 填充)。"""
    cat = category or infer_type_category(datatype)
    if cat == "numeric":
        return "100"
    elif cat == "string":
        return "'test_val'"
    elif cat == "datetime":
        return "'2026-08-26 12:00:00'"
    elif cat == "boolean":
        return "TRUE"
    elif cat == "binary":
        return "E'\\\\xDEADBEEF'"
    elif cat == "json":
        return '\'{"k": "v", "num": 1}\''
    elif cat == "uuid":
        return "'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'"
    return "'sample'"


# ==============================================================================
# 符号定义 (Column, Index, Table, Sequence)
# ==============================================================================

@dataclass
class ColumnSymbol:
    """列符号：描述一张表的单个字段元数据。"""
    name: str
    datatype: str
    category: str = ""
    is_nullable: bool = True
    is_primary_key: bool = False
    is_unique: bool = False
    default_value: Optional[str] = None
    constraint: Optional[str] = None

    def __post_init__(self):
        if not self.category:
            self.category = infer_type_category(self.datatype)

    def to_dict(self) -> dict:
        return {
            "name": self.name,
            "datatype": self.datatype,
            "category": self.category,
            "is_nullable": self.is_nullable,
            "is_primary_key": self.is_primary_key,
            "is_unique": self.is_unique,
            "default_value": self.default_value,
            "constraint": self.constraint,
        }

    @classmethod
    def from_dict(cls, data: dict) -> "ColumnSymbol":
        return cls(**data)


@dataclass
class IndexSymbol:
    """索引符号：描述表上的索引。"""
    name: str
    table_name: str
    columns: List[str] = field(default_factory=list)
    index_type: str = "btree"  # btree, ubtree, gin, gist, hash
    is_unique: bool = False

    def to_dict(self) -> dict:
        return {
            "name": self.name,
            "table_name": self.table_name,
            "columns": list(self.columns),
            "index_type": self.index_type,
            "is_unique": self.is_unique,
        }

    @classmethod
    def from_dict(cls, data: dict) -> "IndexSymbol":
        return cls(**data)


@dataclass
class TableSymbol:
    """表符号：描述一个完整数据表的元数据与物理属性。"""
    name: str
    columns: List[ColumnSymbol] = field(default_factory=list)
    storage_engine: str = "ASTORE"  # ASTORE | USTORE | CSTORE | MOT
    partition_type: Optional[str] = None  # RANGE | LIST | HASH | None
    partition_keys: List[str] = field(default_factory=list)
    indices: List[IndexSymbol] = field(default_factory=list)
    is_temporary: bool = False
    is_unlogged: bool = False
    row_count_estimate: int = 0

    def add_column(self, col: ColumnSymbol):
        # 如果存在同名列则替换，否则追加
        self.columns = [c for c in self.columns if c.name != col.name]
        self.columns.append(col)

    def drop_column(self, col_name: str) -> bool:
        init_len = len(self.columns)
        self.columns = [c for c in self.columns if c.name != col_name]
        return len(self.columns) < init_len

    def get_column(self, col_name: str) -> Optional[ColumnSymbol]:
        for c in self.columns:
            if c.name == col_name:
                return c
        return None

    def get_columns_by_category(self, category: str) -> List[ColumnSymbol]:
        return [c for c in self.columns if c.category == category]

    def column_names(self) -> List[str]:
        return [c.name for c in self.columns]

    def primary_key_columns(self) -> List[ColumnSymbol]:
        return [c for c in self.columns if c.is_primary_key]

    def add_index(self, index: IndexSymbol):
        self.indices = [idx for idx in self.indices if idx.name != index.name]
        self.indices.append(index)

    def drop_index(self, index_name: str) -> bool:
        init_len = len(self.indices)
        self.indices = [idx for idx in self.indices if idx.name != index_name]
        return len(self.indices) < init_len

    def to_dict(self) -> dict:
        return {
            "name": self.name,
            "columns": [c.to_dict() for c in self.columns],
            "storage_engine": self.storage_engine,
            "partition_type": self.partition_type,
            "partition_keys": list(self.partition_keys),
            "indices": [idx.to_dict() for idx in self.indices],
            "is_temporary": self.is_temporary,
            "is_unlogged": self.is_unlogged,
            "row_count_estimate": self.row_count_estimate,
        }

    @classmethod
    def from_dict(cls, data: dict) -> "TableSymbol":
        columns = [ColumnSymbol.from_dict(c) for c in data.get("columns", [])]
        indices = [IndexSymbol.from_dict(idx) for idx in data.get("indices", [])]
        return cls(
            name=data["name"],
            columns=columns,
            storage_engine=data.get("storage_engine", "ASTORE"),
            partition_type=data.get("partition_type"),
            partition_keys=data.get("partition_keys", []),
            indices=indices,
            is_temporary=data.get("is_temporary", False),
            is_unlogged=data.get("is_unlogged", False),
            row_count_estimate=data.get("row_count_estimate", 0),
        )


# ==============================================================================
# SchemaContext：符号表核心容器与状态机管理
# ==============================================================================

class SchemaContext:
    """动态维护当前测试环境中的数据库对象状态（表、列、索引、数据量等）。"""

    def __init__(self, schema_name: str = "public"):
        self.schema_name = schema_name
        self.tables: Dict[str, TableSymbol] = {}
        self.variables: Dict[str, Any] = {}

    def register_table(self, table: TableSymbol):
        """注册或更新表符号。"""
        self.tables[table.name] = table

    def get_table(self, table_name: str) -> Optional[TableSymbol]:
        """获取指定表符号。"""
        return self.tables.get(table_name)

    def has_table(self, table_name: str) -> bool:
        """检查表是否存在。"""
        return table_name in self.tables

    def drop_table(self, table_name: str) -> bool:
        """删除指定表符号。"""
        if table_name in self.tables:
            del self.tables[table_name]
            return True
        return False

    def rename_table(self, old_name: str, new_name: str) -> bool:
        """重命名表符号。"""
        if old_name in self.tables:
            tbl = self.tables.pop(old_name)
            tbl.name = new_name
            # 同步更新表下属索引中的 table_name
            for idx in tbl.indices:
                idx.table_name = new_name
            self.tables[new_name] = tbl
            return True
        return False

    def all_tables(self) -> List[TableSymbol]:
        """获取当前所有的表列表。"""
        return list(self.tables.values())

    def table_names(self) -> List[str]:
        """获取当前所有的表名列表。"""
        return list(self.tables.keys())

    def clear(self):
        """清空当前符号表上下文。"""
        self.tables.clear()
        self.variables.clear()

    # --------------------------------------------------------------------------
    # 智能符号拾取器 (Intelligent Symbol Pickers for Factors)
    # --------------------------------------------------------------------------

    def pick_table(self, preferred_engine: str = None,
                   min_columns: int = 1) -> Optional[TableSymbol]:
        """按偏好条件挑选可用表（供 DML/DQL 因子动态绑定）。"""
        if not self.tables:
            return None
        candidates = [
            t for t in self.tables.values()
            if len(t.columns) >= min_columns
        ]
        if not candidates:
            candidates = list(self.tables.values())

        if preferred_engine:
            matching_engine = [t for t in candidates if t.storage_engine.upper() == preferred_engine.upper()]
            if matching_engine:
                return matching_engine[0]

        return candidates[0] if candidates else None

    def pick_column(self, table_name: str = None,
                    category: str = None,
                    required_type: str = None) -> Optional[ColumnSymbol]:
        """在指定表或所有表中挑选符合类型条件的列。"""
        target_tables = []
        if table_name and table_name in self.tables:
            target_tables = [self.tables[table_name]]
        else:
            target_tables = list(self.tables.values())

        for tbl in target_tables:
            for col in tbl.columns:
                if required_type and col.datatype.upper() == required_type.upper():
                    return col
                if category and col.category == category:
                    return col
                if not required_type and not category:
                    return col
        return None

    def pick_compatible_columns(self, table_name: str, target_category: str) -> List[ColumnSymbol]:
        """获取指定表中所有类型兼容的列列表。"""
        tbl = self.get_table(table_name)
        if not tbl:
            return []
        return tbl.get_columns_by_category(target_category)

    # --------------------------------------------------------------------------
    # 快照与回滚 (Snapshot & Rollback for Branching/Scenarios)
    # --------------------------------------------------------------------------

    def snapshot(self) -> "SchemaContext":
        """创建当前符号表上下文的深拷贝快照。"""
        snap = SchemaContext(schema_name=self.schema_name)
        snap.tables = {k: copy.deepcopy(v) for k, v in self.tables.items()}
        snap.variables = copy.deepcopy(self.variables)
        return snap

    def restore(self, snap: "SchemaContext"):
        """从快照恢复状态。"""
        self.schema_name = snap.schema_name
        self.tables = {k: copy.deepcopy(v) for k, v in snap.tables.items()}
        self.variables = copy.deepcopy(snap.variables)

    def to_dict(self) -> dict:
        return {
            "schema_name": self.schema_name,
            "tables": {k: v.to_dict() for k, v in self.tables.items()},
            "variables": copy.deepcopy(self.variables),
        }

    @classmethod
    def from_dict(cls, data: dict) -> "SchemaContext":
        ctx = cls(schema_name=data.get("schema_name", "public"))
        tables_data = data.get("tables", {})
        for name, t_dict in tables_data.items():
            ctx.tables[name] = TableSymbol.from_dict(t_dict)
        ctx.variables = data.get("variables", {})
        return ctx


# ==============================================================================
# DDL 符号解析器：从因子与 SQL 自动提炼并注册符号到 SchemaContext
# ==============================================================================

def apply_sql_effect_to_context(ctx: SchemaContext, factor_id: str,
                                params: Dict[str, str], sql: str):
    """根据执行成功的 SQL 或因子参数，自动推进 SchemaContext 状态。"""
    sql_upper = sql.upper().strip()

    # 1. CREATE TABLE
    if factor_id in ("create_table", "create_partitioned_table") or "CREATE TABLE" in sql_upper or "CREATE TEMPORARY TABLE" in sql_upper:
        table_name = params.get("table_name", "t_factor_test")
        col_type = params.get("column_datatype", "INTEGER")
        col_constraint = params.get("column_constraint", "")
        modifier = params.get("table_modifier", "").upper()

        is_pk = "PRIMARY KEY" in col_constraint.upper()
        is_null = "NOT NULL" not in col_constraint.upper() and not is_pk

        col = ColumnSymbol(
            name="col_1",
            datatype=col_type if col_type != "FAKETYPE" else "INTEGER",
            is_nullable=is_null,
            is_primary_key=is_pk,
            constraint=col_constraint,
        )

        # 尝试提取括号内的所有列定义
        columns = []
        body_match = re.search(r"\((.*)\)", sql, re.DOTALL)
        if body_match:
            body_content = body_match.group(1)
            for part in body_content.split(","):
                p_tokens = part.strip().split()
                if len(p_tokens) >= 2:
                    c_name = p_tokens[0]
                    c_type = p_tokens[1]
                    c_constraint = " ".join(p_tokens[2:]) if len(p_tokens) > 2 else ""
                    if not c_name.upper().startswith(("PRIMARY", "UNIQUE", "CHECK", "FOREIGN", "PARTITION", "CONSTRAINT")):
                        columns.append(ColumnSymbol(
                            name=c_name,
                            datatype=c_type,
                            is_primary_key="PRIMARY KEY" in c_constraint.upper(),
                            constraint=c_constraint,
                        ))
        if not columns:
            columns = [col]

        engine = "ASTORE"
        if "USTORE" in sql_upper:
            engine = "USTORE"
        elif "COLUMN" in sql_upper:
            engine = "CSTORE"

        part_type = None
        part_keys = []
        if "PARTITION BY RANGE" in sql_upper:
            part_type = "RANGE"
            part_keys = ["id"] if "id" in sql else ["col_1"]

        table_symbol = TableSymbol(
            name=table_name,
            columns=columns,
            storage_engine=engine,
            partition_type=part_type,
            partition_keys=part_keys,
            is_temporary="TEMPORARY" in modifier or "TEMP" in modifier,
            is_unlogged="UNLOGGED" in modifier,
        )
        ctx.register_table(table_symbol)

    # 2. ALTER TABLE
    elif factor_id == "alter_table" or sql_upper.startswith("ALTER TABLE"):
        table_name = params.get("table_name", "t_factor_test")
        tbl = ctx.get_table(table_name)
        action = params.get("action", "")

        if tbl:
            if "ADD COLUMN" in action.upper():
                # ADD COLUMN col_new VARCHAR(50) NOT NULL
                parts = action.split()
                if len(parts) >= 4:
                    new_col_name = parts[2]
                    new_col_type = parts[3]
                    tbl.add_column(ColumnSymbol(name=new_col_name, datatype=new_col_type))
            elif "DROP COLUMN" in action.upper():
                parts = action.split()
                if len(parts) >= 3:
                    drop_col_name = parts[2]
                    tbl.drop_column(drop_col_name)
            elif "RENAME COLUMN" in action.upper():
                # RENAME COLUMN col_1 TO col_renamed
                match = re.search(r"RENAME\s+COLUMN\s+(\w+)\s+TO\s+(\w+)", action, re.IGNORECASE)
                if match:
                    old_c, new_c = match.group(1), match.group(2)
                    col = tbl.get_column(old_c)
                    if col:
                        col.name = new_c
            elif "RENAME TO" in action.upper():
                match = re.search(r"RENAME\s+TO\s+(\w+)", action, re.IGNORECASE)
                if match:
                    new_tbl_name = match.group(1)
                    ctx.rename_table(table_name, new_tbl_name)

    # 3. CREATE INDEX
    elif "CREATE INDEX" in sql_upper or "CREATE UNIQUE INDEX" in sql_upper:
        # CREATE INDEX idx_t ON t (col_1)
        match = re.search(r"CREATE\s+(UNIQUE\s+)?INDEX\s+(\w+)\s+ON\s+(\w+)\s*\((.*?)\)", sql, re.IGNORECASE)
        if match:
            is_unique = bool(match.group(1))
            idx_name = match.group(2)
            tbl_name = match.group(3)
            cols = [c.strip() for c in match.group(4).split(",")]
            idx_type = "ubtree" if "UBTREE" in sql_upper else "btree"

            tbl = ctx.get_table(tbl_name)
            if tbl:
                tbl.add_index(IndexSymbol(
                    name=idx_name,
                    table_name=tbl_name,
                    columns=cols,
                    index_type=idx_type,
                    is_unique=is_unique
                ))

    # 4. INSERT
    elif sql_upper.startswith("INSERT INTO"):
        table_name = params.get("table_name", "t_factor_test")
        tbl = ctx.get_table(table_name)
        if tbl:
            tbl.row_count_estimate += 1

    # 5. DROP TABLE
    elif sql_upper.startswith("DROP TABLE"):
        match = re.search(r"DROP\s+TABLE\s+(IF\s+EXISTS\s+)?(\w+)", sql, re.IGNORECASE)
        if match:
            tbl_name = match.group(2)
            ctx.drop_table(tbl_name)
