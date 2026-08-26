"""蜕变测试 (Metamorphic Testing) Oracle 体系：

实现无需预设真值基准的自动查询正确性验证：
1. TLP (Ternary Logic Partitioning, 三值逻辑分区)：
   针对任意谓词 P，验证: count(Q_where_P) == count(Q_where_P_is_true)
   且: count(Q_all) == count(P_is_true) + count(P_is_false) + count(P_is_null)
2. NoREC (Non-optimizing Reference Engine Construction)：
   验证优化器开关与常量折叠前后的结果集等价性。
"""
import re
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple, Any


@dataclass
class TLPQueryGroup:
    """一组派生的 TLP 蜕变查询语句。"""
    base_sql: str
    q_all: str          # 原始全表基数查询: SELECT count(*) FROM t
    q_orig: str         # 原始过滤查询: SELECT count(*) FROM t WHERE P
    q_true: str         # 三值分区 True: SELECT count(*) FROM t WHERE (P) IS TRUE
    q_false: str        # 三值分区 False: SELECT count(*) FROM t WHERE (P) IS FALSE
    q_null: str         # 三值分区 Null/Unknown: SELECT count(*) FROM t WHERE (P) IS NULL
    table_name: str
    predicate: str


@dataclass
class MetamorphicResult:
    """蜕变测试执行与判定结果。"""
    case_id: str
    oracle_type: str            # TLP | NoREC
    verdict: str                # pass | fail | error | skipped
    base_sql: str
    count_all: int = 0
    count_orig: int = 0
    count_true: int = 0
    count_false: int = 0
    count_null: int = 0
    error_msg: str = ""
    details: str = ""


class TLPOracle:
    """三值逻辑分区 (TLP) 测试 Oracle。"""

    @staticmethod
    def extract_table_and_predicate(sql: str) -> Tuple[Optional[str], Optional[str]]:
        """从带有 WHERE 的 SELECT 查询中提取表名和谓词表达式。"""
        clean_sql = sql.strip().rstrip(";")
        # 匹配: SELECT ... FROM schema.table WHERE predicate (兼容 ORDER/LIMIT/GROUP BY/HAVING 等尾随子句)
        pattern = re.compile(
            r"SELECT\s+.*?\s+FROM\s+([a-zA-Z0-9_\.\"]+)\s+WHERE\s+(.*?)(?:\s+(?:ORDER\s+BY|LIMIT|GROUP\s+BY|HAVING|OFFSET|FOR\s+UPDATE)\b.*|$)",
            re.IGNORECASE | re.DOTALL
        )
        match = pattern.search(clean_sql)
        if match:
            table_name = match.group(1).strip()
            predicate = match.group(2).strip()
            return table_name, predicate
        return None, None

    @classmethod
    def generate_tlp_group(cls, sql: str) -> Optional[TLPQueryGroup]:
        """将任意带有 WHERE 谓词的查询转化为 TLP 蜕变查询组。"""
        table_name, predicate = cls.extract_table_and_predicate(sql)
        if not table_name or not predicate:
            return None

        q_all = f"SELECT count(*) FROM {table_name}"
        q_orig = f"SELECT count(*) FROM {table_name} WHERE {predicate}"
        q_true = f"SELECT count(*) FROM {table_name} WHERE ({predicate}) IS TRUE"
        q_false = f"SELECT count(*) FROM {table_name} WHERE ({predicate}) IS FALSE"
        q_null = f"SELECT count(*) FROM {table_name} WHERE ({predicate}) IS NULL"

        return TLPQueryGroup(
            base_sql=sql,
            q_all=q_all,
            q_orig=q_orig,
            q_true=q_true,
            q_false=q_false,
            q_null=q_null,
            table_name=table_name,
            predicate=predicate,
        )

    @staticmethod
    def verify_tlp_counts(count_all: int, count_orig: int,
                           count_true: int, count_false: int, count_null: int) -> Tuple[bool, str]:
        """校验三值逻辑分区的数学等式不变性。"""
        partition_sum = count_true + count_false + count_null

        # 断言 1: 分区总和必须恒等于全表总行数 (Partition Completeness)
        if partition_sum != count_all:
            return False, (
                f"TLP 完备性违背: count(true)={count_true} + count(false)={count_false} + "
                f"count(null)={count_null} = {partition_sum} != 全表行数 count_all={count_all}"
            )

        # 断言 2: 原查询行数必须恒等于 count(true) (SQL WHERE 谓词定义)
        if count_orig != count_true:
            return False, (
                f"TLP 谓词真值违背: 原查询 count(orig)={count_orig} != count(is_true)={count_true}"
            )

        return True, "TLP 三值逻辑分区等式严格成立 (count_orig == count_true 且 sum == count_all)"


class MetamorphicExecutor:
    """蜕变测试执行调度器。"""

    def __init__(self, db_conn=None):
        self._conn = db_conn

    def execute_tlp_group(self, case_id: str, group: TLPQueryGroup) -> MetamorphicResult:
        """在数据库连接中执行 TLP 四条派生 SQL 并验证结果一致性。"""
        if not self._conn:
            # 桩模式 / Mock 回退
            return MetamorphicResult(
                case_id=case_id,
                oracle_type="TLP",
                verdict="skipped",
                base_sql=group.base_sql,
                details="Mock 模式下跳过真实数据库查询"
            )

        try:
            cur = self._conn.cursor()

            # 执行四条派生聚合查询
            cur.execute(group.q_all)
            c_all = cur.fetchone()[0]

            cur.execute(group.q_orig)
            c_orig = cur.fetchone()[0]

            cur.execute(group.q_true)
            c_true = cur.fetchone()[0]

            cur.execute(group.q_false)
            c_false = cur.fetchone()[0]

            cur.execute(group.q_null)
            c_null = cur.fetchone()[0]

            cur.close()

            is_valid, reason = TLPOracle.verify_tlp_counts(
                count_all=c_all,
                count_orig=c_orig,
                count_true=c_true,
                count_false=c_false,
                count_null=c_null,
            )

            return MetamorphicResult(
                case_id=case_id,
                oracle_type="TLP",
                verdict="pass" if is_valid else "fail",
                base_sql=group.base_sql,
                count_all=c_all,
                count_orig=c_orig,
                count_true=c_true,
                count_false=c_false,
                count_null=c_null,
                details=reason,
            )

        except Exception as e:
            return MetamorphicResult(
                case_id=case_id,
                oracle_type="TLP",
                verdict="error",
                base_sql=group.base_sql,
                error_msg=str(e),
                details=f"执行 TLP 查询组发生异常: {e}",
            )
