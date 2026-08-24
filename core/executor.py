"""SQL 执行引擎：连接 GaussDB，执行 SQL，检测 core/异常，比对预期结果。

支持两种模式:
  enabled=False (默认): 桩模式，返回 skipped，不连数据库
  enabled=True: 真实执行，捕获 SQLSTATE，检测 core dump，与 expected 比对
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
    expected: str = ""             # 来自 GeneratedCase 的预期
    expected_sqlstate: str = ""
    actual_sqlstate: str = ""      # 实际捕获的 SQLSTATE
    verdict: str = ""             # pass | fail | crash | skip | pending

    def compute_verdict(self):
        """根据 status 和 expected 推导判定结果。"""
        if self.status == "skipped":
            self.verdict = "skip"
            return
        if self.status == "core":
            self.verdict = "crash"
            return
        if self.status == "error" and self.expected == "error":
            # 预期报错且确实报错 — 还需检查 SQLSTATE 是否匹配
            if self.expected_sqlstate and self.actual_sqlstate:
                self.verdict = "pass" if self.actual_sqlstate == self.expected_sqlstate else "fail"
            else:
                self.verdict = "pass"
            return
        if self.status == "success" and self.expected == "success":
            self.verdict = "pass"
            return
        if self.status == "success" and self.expected == "error":
            self.verdict = "fail"  # 预期报错但成功了
            return
        if self.status == "error" and self.expected == "success":
            self.verdict = "fail"  # 预期成功但报错了
            return
        self.verdict = "pending"


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

    enabled=False: 桩模式，所有用例返回 skipped。
    enabled=True: 连接真实 GaussDB 执行。
    """

    def __init__(self, config: ExecConfig = None):
        self.config = config or ExecConfig()
        self._conn = None

    def connect(self):
        """连接 GaussDB。"""
        if not self.config.enabled:
            return
        try:
            import psycopg2
            self._conn = psycopg2.connect(
                host=self.config.host,
                port=self.config.port,
                dbname=self.config.database,
                user=self.config.user,
                password=self.config.password,
            )
            self._conn.autocommit = True
        except ImportError:
            raise RuntimeError(
                "需要安装 psycopg2: pip install psycopg2-binary"
            )
        except Exception as e:
            raise RuntimeError(f"GaussDB 连接失败: {e}")

    def disconnect(self):
        if self._conn:
            self._conn.close()
            self._conn = None

    def _check_alive(self) -> bool:
        """检测数据库连接是否还活着 (core dump 检测)。"""
        if not self._conn:
            return False
        try:
            import psycopg2
            cur = self._conn.cursor()
            cur.execute("SELECT 1")
            cur.close()
            return True
        except Exception:
            return False

    def execute_one(self, case: GeneratedCase) -> ExecResult:
        """执行单条 SQL，返回结果。"""
        if not self.config.enabled:
            r = ExecResult(
                case_id=case.case_id, sql=case.sql, status="skipped",
                expected=case.expected, expected_sqlstate=case.expected_sqlstate,
            )
            r.compute_verdict()
            return r

        import time
        start = time.time()

        # 事务包裹: 执行后回滚, 不污染数据库
        try:
            cur = self._conn.cursor()
            cur.execute("BEGIN")
            # 执行 setup SQL (fixture 链)
            for setup_sql in case.setup_sqls:
                try:
                    cur.execute(setup_sql)
                except Exception:
                    pass  # setup 失败不阻断, 继续跑 test SQL
            # 执行 test SQL
            cur.execute(case.sql)
            cur.execute("ROLLBACK")
            cur.close()
            duration = (time.time() - start) * 1000
            r = ExecResult(
                case_id=case.case_id, sql=case.sql, status="success",
                duration_ms=round(duration, 1),
                expected=case.expected, expected_sqlstate=case.expected_sqlstate,
            )
        except Exception as e:
            duration = (time.time() - start) * 1000
            err_msg = str(e)
            # 尝试回滚, 避免事务残留
            try:
                cur = self._conn.cursor()
                cur.execute("ROLLBACK")
                cur.close()
            except Exception:
                pass
            # 尝试提取 SQLSTATE
            actual_sqlstate = ""
            if hasattr(e, "diag") and hasattr(e.diag, "sqlstate"):
                actual_sqlstate = e.diag.sqlstate or ""
            # 检测 core dump: 执行后连接是否断开
            if not self._check_alive():
                r = ExecResult(
                    case_id=case.case_id, sql=case.sql, status="core",
                    error_msg=err_msg, duration_ms=round(duration, 1),
                    expected=case.expected, expected_sqlstate=case.expected_sqlstate,
                )
            else:
                r = ExecResult(
                    case_id=case.case_id, sql=case.sql, status="error",
                    error_msg=err_msg, duration_ms=round(duration, 1),
                    expected=case.expected, expected_sqlstate=case.expected_sqlstate,
                    actual_sqlstate=actual_sqlstate,
                )
        r.compute_verdict()
        return r

    def execute_batch(self, cases: List[GeneratedCase]) -> List[ExecResult]:
        """批量执行。"""
        return [self.execute_one(c) for c in cases]
