"""SQL 执行引擎：连接 GaussDB，执行 SQL，检测 core/异常，比对预期结果。

支持两种模式:
  enabled=False (默认): 桩模式，返回 skipped，不连数据库
  enabled=True: 真实执行，捕获 SQLSTATE，检测 core dump，与 expected 集合比对
  use_sandbox=True (默认): Schema 级沙箱隔离，执行完毕后自动 CASCADE 清理，杜绝 DDL 污染
"""
import json
import os
import re
import time
import uuid
from dataclasses import dataclass, field
from typing import List, Optional

from .generator import GeneratedCase
from .m_compat_environment import BOOTSTRAP_PATH, requires_m


@dataclass
class ExecResult:
    """单条 SQL 的执行结果。"""
    case_id: str
    sql: str
    status: str = "skipped"        # success | error | fixture_error | cleanup_error | core | skipped
    error_msg: str = ""
    duration_ms: float = 0.0
    expected: str = ""             # 来自 GeneratedCase 的预期 (success | error)
    expected_sqlstate: str = ""   # 主预期 SQLSTATE (向后兼容)
    expected_sqlstates: List[str] = field(default_factory=list) # 预期合法 SQLSTATE 候选集合
    expected_error_category: str = ""
    expected_error_regex: str = ""
    expected_oracle_status: str = "confirmed"
    expected_scope: str = "syntax_and_semantics"
    environment_requirements: List[dict] = field(default_factory=list)
    unmet_environment_requirements: List[str] = field(default_factory=list)
    actual_sqlstate: str = ""      # 实际捕获的 SQLSTATE
    cleanup_error_msg: str = ""
    cleanup_skipped_reason: str = ""
    verdict: str = ""             # pass | fail | crash | skip | pending

    def compute_verdict(self):
        """根据 status 和 expected 集合推导判定结果 (支持多 SQLSTATE 候选容错)。"""
        if self.status == "skipped":
            self.verdict = "skip"
            return
        if self.status == "core":
            self.verdict = "crash"
            return
        if self.status in {"fixture_error", "cleanup_error"}:
            self.verdict = "fail"
            return
        if self.expected_scope != "syntax_and_semantics":
            # Executing the target statement alone cannot close a syntax-only,
            # behavior, or metadata contract.  A dedicated scenario/oracle must
            # promote these results instead of treating mere SQL success as pass.
            self.verdict = "pending"
            return
        if self.expected == "error" and self.expected_oracle_status != "confirmed":
            self.verdict = "pending"
            return

        # 整理所有合法的预期 SQLSTATE 候选集
        candidates = set(self.expected_sqlstates)
        if self.expected_sqlstate:
            candidates.add(self.expected_sqlstate)

        if self.status == "error" and self.expected == "error":
            oracle_results = []
            if candidates:
                oracle_results.append(
                    bool(self.actual_sqlstate and self.actual_sqlstate in candidates)
                )
            if self.expected_error_regex:
                oracle_results.append(bool(re.search(
                    self.expected_error_regex,
                    self.error_msg,
                )))
            # 任意明确目标 Oracle 命中即可；没有 Oracle 的 error 不再允许假通过。
            self.verdict = "pass" if oracle_results and any(oracle_results) else "fail"
            if self.verdict == "pass" and self.cleanup_skipped_reason:
                self.verdict = "pending"  # Target Oracle alone cannot close an unverified lifecycle.
            return

        if self.status == "success" and self.expected == "success":
            self.verdict = "pending" if self.cleanup_skipped_reason else "pass"
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
    environment_capabilities: dict = field(default_factory=lambda: _load_environment_capabilities())


def _load_environment_capabilities() -> dict:
    raw = os.getenv("GAUSSDB_ENVIRONMENT_JSON", "").strip()
    if raw:
        try:
            parsed = json.loads(raw)
        except json.JSONDecodeError as exc:
            raise ValueError(f"GAUSSDB_ENVIRONMENT_JSON 不是合法 JSON: {exc}") from exc
        if not isinstance(parsed, dict):
            raise ValueError("GAUSSDB_ENVIRONMENT_JSON 必须是 JSON object")
        return {str(key): str(value) for key, value in parsed.items()}
    mapping = {
        "compatibility_mode": "GAUSSDB_COMPATIBILITY_MODE",
        "b_format_version": "GAUSSDB_B_FORMAT_VERSION",
        "b_format_dev_version": "GAUSSDB_B_FORMAT_DEV_VERSION",
    }
    return {
        key: os.environ[env_name]
        for key, env_name in mapping.items()
        if os.getenv(env_name)
    }


def _starts_with_create(sql):
    """Recognize the first keyword through leading comments, not arbitrary SQL bodies.

    This failure guard is not ownership proof for successful/conditional CREATE,
    multiple statements, stored routines or a later replacement of an owned object.
    """
    rest=sql.lstrip('\ufeff \t\r\n')
    while rest.startswith(('--','/*')):
        if rest.startswith('--'):
            rest=rest.partition('\n')[2].lstrip()
            continue
        depth,i=1,2
        while i<len(rest) and depth:
            if rest.startswith('/*',i):depth+=1;i+=2
            elif rest.startswith('*/',i):depth-=1;i+=2
            else:i+=1
        if depth:
            return True  # Incomplete comment: no basis for authorizing teardown.
        rest=rest[i:].lstrip()
    return bool(re.match(r'CREATE\b',rest,re.I))


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
        if getattr(case, 'file_assets', []):
            return self._file_execution_pending(case)
        if requires_m(case):
            return self._m_execution_pending(case)
        expected_sqlstates = getattr(case, "expected_sqlstates", [])
        expected_error_category = getattr(case, "expected_error_category", "")
        expected_error_regex = getattr(case, "expected_error_regex", "")
        expected_oracle_status = getattr(case, "expected_oracle_status", "confirmed")
        expected_scope = getattr(case, "expected_scope", "syntax_and_semantics")
        environment_requirements = getattr(case, "environment_requirements", [])
        unmet_environment_requirements = []
        for requirement in environment_requirements:
            key = str(requirement.get("key", ""))
            allowed_values = {
                str(value) for value in requirement.get("allowed_values", [])
            }
            actual = self.config.environment_capabilities.get(key)
            if actual is None or str(actual) not in allowed_values:
                unmet_environment_requirements.append(
                    f"{key}={actual!r}, required={sorted(allowed_values)}"
                )
        if unmet_environment_requirements:
            r = ExecResult(
                case_id=case.case_id,
                sql=case.sql,
                status="skipped",
                error_msg=(
                    "execution environment does not satisfy manifest gate: "
                    + "; ".join(unmet_environment_requirements)
                ),
                expected=case.expected,
                expected_sqlstate=case.expected_sqlstate,
                expected_sqlstates=expected_sqlstates,
                expected_error_category=expected_error_category,
                expected_error_regex=expected_error_regex,
                expected_oracle_status=expected_oracle_status,
                expected_scope=expected_scope,
                environment_requirements=environment_requirements,
                unmet_environment_requirements=unmet_environment_requirements,
            )
            r.compute_verdict()
            return r
        if not self.config.enabled:
            r = ExecResult(
                case_id=case.case_id,
                sql=case.sql,
                status="skipped",
                expected=case.expected,
                expected_sqlstate=case.expected_sqlstate,
                expected_sqlstates=expected_sqlstates,
                expected_error_category=expected_error_category,
                expected_error_regex=expected_error_regex,
                expected_oracle_status=expected_oracle_status,
                expected_scope=expected_scope,
                environment_requirements=environment_requirements,
            )
            r.compute_verdict()
            return r

        start = time.time()
        stage = "setup"
        cur = None
        r = None
        try:
            cur = self._conn.cursor()
            for setup_sql in case.setup_sqls:
                cur.execute(setup_sql)

            stage = "test"
            cur.execute(case.sql)
            duration = (time.time() - start) * 1000
            r = ExecResult(
                case_id=case.case_id,
                sql=case.sql,
                status="success",
                duration_ms=round(duration, 1),
                expected=case.expected,
                expected_sqlstate=case.expected_sqlstate,
                expected_sqlstates=expected_sqlstates,
                expected_error_category=expected_error_category,
                expected_error_regex=expected_error_regex,
                expected_oracle_status=expected_oracle_status,
                expected_scope=expected_scope,
                environment_requirements=environment_requirements,
            )
        except Exception as e:
            duration = (time.time() - start) * 1000
            err_msg = str(e)

            actual_sqlstate = self._extract_sqlstate(e)

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
                    expected_error_category=expected_error_category,
                    expected_error_regex=expected_error_regex,
                    expected_oracle_status=expected_oracle_status,
                    expected_scope=expected_scope,
                    environment_requirements=environment_requirements,
                )
            else:
                r = ExecResult(
                    case_id=case.case_id,
                    sql=case.sql,
                    status="fixture_error" if stage == "setup" else "error",
                    error_msg=(
                        f"fixture setup failed: {err_msg}"
                        if stage == "setup" else err_msg
                    ),
                    duration_ms=round(duration, 1),
                    expected=case.expected,
                    expected_sqlstate=case.expected_sqlstate,
                    expected_sqlstates=expected_sqlstates,
                    expected_error_category=expected_error_category,
                    expected_error_regex=expected_error_regex,
                    expected_oracle_status=expected_oracle_status,
                    expected_scope=expected_scope,
                    environment_requirements=environment_requirements,
                    actual_sqlstate=actual_sqlstate,
                )
        finally:
            if cur is not None:
                try:
                    cur.close()
                except Exception:
                    pass

            cleanup_errors = []
            if stage == "setup" and getattr(case, "teardown_sqls", []):
                # Failed setup does not establish ownership of teardown targets.
                # In particular, an absence assertion may have found an existing
                # database. Blind cleanup would delete an object we never created.
                if r is not None:
                    r.cleanup_skipped_reason = (
                        "setup did not complete; teardown not authorized; "
                        "inspect possible partial setup residue before manual cleanup"
                    )
            elif (r is not None and r.status in {'error','core'}
                  and getattr(case, 'teardown_sqls', []) and _starts_with_create(case.sql)):
                # A successful absence assertion is not ownership of the target:
                # another actor may create it before our CREATE fails. Without an
                # asset ownership ledger, do not guess which DROP is safe.
                r.cleanup_skipped_reason = (
                    'CREATE target failed; target ownership unproven; teardown not authorized; '
                    'inspect possible setup/target residue before ownership-scoped cleanup'
                )
            elif self._conn and self._check_alive():
                cleanup_cur = None
                try:
                    cleanup_cur = self._conn.cursor()
                    for teardown_sql in getattr(case, "teardown_sqls", []):
                        cleanup_cur.execute(teardown_sql)
                except Exception as cleanup_exc:
                    cleanup_errors.append(str(cleanup_exc))
                finally:
                    if cleanup_cur is not None:
                        try:
                            cleanup_cur.close()
                        except Exception:
                            pass
            if cleanup_errors and r is not None and r.status != "core":
                r.status = "cleanup_error"
                r.cleanup_error_msg = "; ".join(cleanup_errors)
                r.error_msg = (
                    f"{r.error_msg}; cleanup failed: {r.cleanup_error_msg}"
                    if r.error_msg else f"cleanup failed: {r.cleanup_error_msg}"
                )
        r.compute_verdict()
        return r

    @staticmethod
    def _file_execution_pending(case):
        result = ExecResult(case_id=case.case_id, sql=case.sql, expected=case.expected,
            environment_requirements=getattr(case, 'environment_requirements', []),
            error_msg='File asset deployment, ownership and cleanup runner not calibrated; no SQL executed',
            unmet_environment_requirements=['file_asset_execution_not_calibrated'])
        result.compute_verdict()
        return result

    @staticmethod
    def _m_execution_pending(case):
        # A declared M gate is not proof of the connection mode. The legacy
        # sandbox uses general CASCADE cleanup and cannot safely run M schema
        # DDL or partially failed transaction fixtures. Block BEFORE any write.
        result = ExecResult(case_id=case.case_id, sql=case.sql, expected=case.expected,
            environment_requirements=getattr(case, 'environment_requirements', []),
            error_msg=f'M staged executor not calibrated; prepare and verify environment via {BOOTSTRAP_PATH}',
            unmet_environment_requirements=['m_staged_execution_not_calibrated'])
        result.compute_verdict()
        return result

    @staticmethod
    def _extract_sqlstate(error: Exception) -> str:
        if hasattr(error, "pgcode") and error.pgcode:
            return str(error.pgcode)
        if hasattr(error, "diag") and hasattr(error.diag, "sqlstate"):
            return str(error.diag.sqlstate or "")
        return ""

    def execute_batch(self, cases: List[GeneratedCase]) -> List[ExecResult]:
        """批量执行用例，在独立的 Schema 沙箱环境中运行并在结束时自动级联清理。"""
        if not cases:
            return []
        if any(getattr(case, 'file_assets', []) for case in cases):
            return [self._file_execution_pending(case) for case in cases]
        if any(requires_m(case) for case in cases):
            # Reject a mixed batch as well: no general sandbox may be created
            # before M prerequisites have been established.
            return [self._m_execution_pending(case) for case in cases]

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
