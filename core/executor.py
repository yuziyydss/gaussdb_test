"""SQL 执行引擎：连接 GaussDB，执行 SQL，检测 core/异常。

当前为桩实现——预留接口，后续接 GaussDB 真实连接。
"""
from dataclasses import dataclass, field
from typing import List, Optional

from .generator import GeneratedCase


@dataclass
class ExecResult:
    """单条 SQL 的执行结果。"""
    case_id: str
    sql: str
    status: str = "skipped"        # success | error | core | skipped
    error_msg: str = ""
    duration_ms: float = 0.0


@dataclass
class ExecConfig:
    """GaussDB 连接配置。"""
    host: str = "localhost"
    port: int = 5432
    database: str = "postgres"
    user: str = "gaussdb"
    password: str = ""
    enabled: bool = False           # 桩模式开关


class Executor:
    """SQL 执行器。

    enabled=False 时为桩模式，所有用例返回 status=skipped。
    enabled=True 时连接真实 GaussDB 执行。
    """

    def __init__(self, config: ExecConfig = None):
        self.config = config or ExecConfig()
        self._conn = None

    def connect(self):
        """连接 GaussDB。后续用 psycopg2 或 GaussDB 官方驱动。"""
        if not self.config.enabled:
            return
        # TODO: psycopg2.connect(host=..., port=..., dbname=..., user=..., password=...)
        raise NotImplementedError("GaussDB 连接尚未实现")

    def disconnect(self):
        if self._conn:
            self._conn.close()
            self._conn = None

    def execute_one(self, case: GeneratedCase) -> ExecResult:
        """执行单条 SQL，返回结果。"""
        if not self.config.enabled:
            return ExecResult(case_id=case.case_id, sql=case.sql, status="skipped")
        # TODO: 真实执行逻辑
        # 1. 执行 SQL
        # 2. 捕获 SQLSTATE / error message
        # 3. 检测连接是否断开（core dump 信号）
        # 4. 返回 ExecResult
        raise NotImplementedError("执行逻辑尚未实现")

    def execute_batch(self, cases: List[GeneratedCase]) -> List[ExecResult]:
        """批量执行。"""
        return [self.execute_one(c) for c in cases]
