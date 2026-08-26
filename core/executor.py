"""SQL 执行引擎：连接 GaussDB，执行 SQL，检测 core/异常，比对预期结果。

支持两种模式:
  enabled=False (默认): 桩模式，返回 skipped，不连数据库
  enabled=True: 真实执行，捕获 SQLSTATE，检测 core dump，与 expected 集合比对
  use_sandbox=True (默认): Schema 级沙箱隔离，执行完毕后自动 CASCADE 清理，杜绝 DDL 污染
"""
import os
import time
import uuid
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
    expected: str = ""             # 来自 GeneratedCase 的预期 (success | error)
    expected_sqlstate: str = ""   # 主预期 SQLSTATE (向后兼容)
    expected_sqlstates: List[str] = field(default_factory=list) # 预期合法 SQLSTATE 候选集合
    actual_sqlstate: str = ""      # 实际捕获的 SQLSTATE
    verdict: str = ""             # pass | fail | crash | skip | pending

    def compute_verdict(self):
        """根据 status 和 expected 集合推导判定结果 (支持多 SQLSTATE 候选容错)。"""
        if self.status == "skipped":
            self.verdict = "skip"
            return
        if self.status == "core":
            self.verdict = "crash"
            return

        # 整理所有合法的预期 SQLSTATE 候选集
        candidates = set(self.expected_sqlstates)
        if self.expected_sqlstate:
            candidates.add(self.expected_sqlstate)

        if self.status == "error" and self.expected == "error":
            # 预期报错且确实报错 — 若指定了预期错误码集合，校验是否命中
            if candidates:
                if self.actual_sqlstate and self.actual_sqlstate in candidates:
                    self.verdict = "pass"
                else:
                    self.verdict = "fail"
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
    """GaussDB 连接与执行配置 (支持从环境变量自动加载)。"""
    host: str = field(default_factory=lambda: os.getenv("GAUSSDB_HOST", "localhost"))
    port: int = field(default_factory=lambda: int(os.getenv("GAUSSDB_PORT", "5432")))
    database: str = field(default_factory=lambda: os.getenv("GAUSSDB_DATABASE", "postgres"))
    user: str = field(default_factory=lambda: os.getenv("GAUSSDB_USER", "gaussdb"))
    password: str = field(default_factory=lambda: os.getenv("GAUSSDB_PASSWORD", ""))
    enabled: bool = field(default_factory=lambda: os.getenv("GAUSSDB_ENABLED", "false").lower() in ("true", "1", "yes"))
    use_sandbox: bool = field(default_factory=lambda: os.getenv("GAUSSDB_USE_SANDBOX", "true").lower() in ("true", "1", "yes"))
    sandbox_prefix: str = "factortest_sandbox"


class Executor:
    """SQL 执行器。

    enabled=False: 桩模式，所有用例返回 skipped。
    enabled=True: 连接真实 GaussDB 执行。
    use_sandbox=True: 每个批次在独立动态 Schema 中运行，防止 DDL 隐式提交污染测试库。
    """

    def __init__(self, config: ExecConfig = None):
        self.config = config or ExecConfig()
        self._conn = None
        self._current_sandbox: Optional[str] = None

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
            try:
                self._conn.close()
            except Exception:
                pass
            self._conn = None

    def _check_alive(self) -> bool:
        """检测数据库连接是否存活 (检测 Core Dump / 服务 Crash)。"""
        if not self._conn:
            return False
        try:
            cur = self._conn.cursor()
            cur.execute("SELECT 1")
            cur.close()
            return True
        except Exception:
            return False

    def create_sandbox(self) -> str:
        """创建独立的临时 Schema 沙箱。"""
        if not self.config.enabled or not self.config.use_sandbox or not self._conn:
            return "public"
        
        sandbox_name = f"{self.config.sandbox_prefix}_{int(time.time())}_{uuid.uuid4().hex[:6]}"
        try:
            cur = self._conn.cursor()
            cur.execute(f'CREATE SCHEMA "{sandbox_name}";')
            cur.execute(f'SET search_path TO "{sandbox_name}", public;')
            cur.close()
            self._current_sandbox = sandbox_name
            return sandbox_name
        except Exception as e:
            print(f"[Executor] 创建沙箱失败，回退到 public: {e}")
            return "public"

    def drop_sandbox(self, sandbox_name: str):
        """清理临时 Schema 沙箱及其所有对象。"""
        if not self.config.enabled or not self.config.use_sandbox or not self._conn:
            return
        if not sandbox_name or sandbox_name == "public":
            return
        try:
            cur = self._conn.cursor()
            cur.execute("SET search_path TO public;")
            cur.execute(f'DROP SCHEMA IF EXISTS "{sandbox_name}" CASCADE;')
            cur.close()
        except Exception as e:
            print(f"[Executor] 清理沙箱 {sandbox_name} 失败: {e}")
        finally:
            if self._current_sandbox == sandbox_name:
                self._current_sandbox = None

    def execute_one(self, case: GeneratedCase) -> ExecResult:
        """执行单条 SQL，返回结果。"""
        expected_sqlstates = getattr(case, "expected_sqlstates", [])
        if not self.config.enabled:
            r = ExecResult(
                case_id=case.case_id,
                sql=case.sql,
                status="skipped",
                expected=case.expected,
                expected_sqlstate=case.expected_sqlstate,
                expected_sqlstates=expected_sqlstates,
            )
            r.compute_verdict()
            return r

        start = time.time()
        try:
            cur = self._conn.cursor()

            # 自动表状态重置：若即将执行建表或 setup 中包含建表，先清理同名旧表，防止批次执行时 "table already exists" 串扰
            all_sqls_to_run = list(case.setup_sqls) + [case.sql]
            for s in all_sqls_to_run:
                match = re.search(r"CREATE\s+(?:(?:GLOBAL\s+)?TEMPORARY\s+|UNLOGGED\s+)?TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?([a-zA-Z0-9_\.\"]+)", s, re.IGNORECASE)
                if match:
                    tbl_name = match.group(1)
                    try:
                        cur.execute(f"DROP TABLE IF EXISTS {tbl_name} CASCADE;")
                    except Exception:
                        pass

            # 执行 setup SQL (fixture 链)
            for setup_sql in case.setup_sqls:
                try:
                    cur.execute(setup_sql)
                except Exception:
                    pass  # setup 失败不阻断, 继续跑 test SQL

            # 执行 test SQL
            cur.execute(case.sql)
            cur.close()
            duration = (time.time() - start) * 1000
            r = ExecResult(
                case_id=case.case_id,
                sql=case.sql,
                status="success",
                duration_ms=round(duration, 1),
                expected=case.expected,
                expected_sqlstate=case.expected_sqlstate,
                expected_sqlstates=expected_sqlstates,
            )
        except Exception as e:
            duration = (time.time() - start) * 1000
            err_msg = str(e)

            # 提取 SQLSTATE (支持 pgcode 与 diag.sqlstate)
            actual_sqlstate = ""
            if hasattr(e, "pgcode") and e.pgcode:
                actual_sqlstate = str(e.pgcode)
            elif hasattr(e, "diag") and hasattr(e.diag, "sqlstate"):
                actual_sqlstate = str(e.diag.sqlstate or "")

            # 检测 core dump: 执行后连接是否断开
            if not self._check_alive():
                r = ExecResult(
                    case_id=case.case_id,
                    sql=case.sql,
                    status="core",
                    error_msg=err_msg,
                    duration_ms=round(duration, 1),
                    expected=case.expected,
                    expected_sqlstate=case.expected_sqlstate,
                    expected_sqlstates=expected_sqlstates,
                )
            else:
                r = ExecResult(
                    case_id=case.case_id,
                    sql=case.sql,
                    status="error",
                    error_msg=err_msg,
                    duration_ms=round(duration, 1),
                    expected=case.expected,
                    expected_sqlstate=case.expected_sqlstate,
                    expected_sqlstates=expected_sqlstates,
                    actual_sqlstate=actual_sqlstate,
                )
        r.compute_verdict()
        return r

    def execute_batch(self, cases: List[GeneratedCase]) -> List[ExecResult]:
        """批量执行用例，在独立的 Schema 沙箱环境中运行并在结束时自动级联清理。"""
        if not cases:
            return []

        # 确保已建立连接
        if self.config.enabled and not self._conn:
            self.connect()

        sandbox = self.create_sandbox()
        results = []
        try:
            for c in cases:
                results.append(self.execute_one(c))
        finally:
            if sandbox and sandbox != "public":
                self.drop_sandbox(sandbox)

        return results

