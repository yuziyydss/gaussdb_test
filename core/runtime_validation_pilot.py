"""Runtime validation pilot for GUC overlays and advanced package calls.

The default artifact is a dry-run plan.  Real execution requires explicit
authorization and a database transport; it never fabricates runtime evidence.
"""
from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any, Dict, List, Literal, Optional, Protocol

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from .advanced_package import AdvancedPackagePlanner, AdvancedPackageRegistry
from .guc_environment import GucEnvironmentPlanner, GucEnvironmentRegistry


class StrictRuntimePilotModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class RuntimeOracleDef(StrictRuntimePilotModel):
    kind: Literal["metadata", "output", "value", "lifecycle"]
    expected: str
    status: Literal["needs_verification"]


class RuntimeStepDef(StrictRuntimePilotModel):
    phase: Literal[
        "capture_original", "apply", "verify_target", "restore",
        "verify_restore", "target",
    ]
    sql: str
    expected_rows: List[List[Any]] = Field(default_factory=list)
    expected_notice: Optional[str] = None
    must_succeed: bool = True

    @field_validator("sql")
    @classmethod
    def ensure_sql(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("runtime step SQL 不能为空")
        return value

    @model_validator(mode="after")
    def ensure_one_oracle(self) -> "RuntimeStepDef":
        if self.expected_rows and self.expected_notice:
            raise ValueError("runtime step 不能同时声明 rows 和 notice Oracle")
        return self


class RuntimeCleanupDef(StrictRuntimePilotModel):
    restore_original_guc: bool = False
    close_advanced_context: bool = False
    runtime_ownership_proven: bool = False


class RuntimeUnitDef(StrictRuntimePilotModel):
    id: str
    kind: Literal["guc_overlay", "advanced_package"]
    package_ref: Optional[str] = None
    interface_refs: List[str]
    status: Literal["ready_for_authorized_execution"]
    database_executed: bool = False
    runtime_verified: bool = False
    oracle: RuntimeOracleDef
    execution_plan: List[RuntimeStepDef]
    cleanup: RuntimeCleanupDef

    @field_validator("id")
    @classmethod
    def ensure_id(cls, value: str) -> str:
        if not value or not value.replace("_", "").isalnum():
            raise ValueError("runtime unit id 必须是非空安全标识")
        return value

    @model_validator(mode="after")
    def ensure_cleanup_boundary(self) -> "RuntimeUnitDef":
        if self.kind == "guc_overlay" and not self.cleanup.restore_original_guc:
            raise ValueError("GUC overlay 必须恢复原值")
        if self.kind == "advanced_package" and "dbe_sql" in self.id and not self.cleanup.close_advanced_context:
            raise ValueError("DBE_SQL 单元必须关闭上下文")
        if self.runtime_verified and not self.database_executed:
            raise ValueError("未执行数据库不能声明 runtime_verified")
        return self


class RuntimePilotPlanDef(StrictRuntimePilotModel):
    schema_version: Literal[1]
    kind: Literal["runtime_validation_pilot"]
    profile: Literal["runtime_validation_pilot_v1"]
    status: Literal["ready_for_authorized_execution"]
    database_executed: bool = False
    execution_authorized: bool = False
    runtime_verified: int = 0
    units: List[RuntimeUnitDef]
    execution_requirements: List[str]
    limits: List[str]

    @model_validator(mode="after")
    def ensure_honest_counts(self) -> "RuntimePilotPlanDef":
        if self.database_executed or self.execution_authorized or self.runtime_verified:
            raise ValueError("dry-run plan 不能声明执行、授权或验证结果")
        if not self.units:
            raise ValueError("runtime pilot 至少需要一个单元")
        return self


def _sql_literal_value(literal: str) -> str:
    if len(literal) >= 2 and literal[0] == literal[-1] == "'":
        return literal[1:-1].replace("''", "'")
    return literal


class RuntimeStepResult:
    def __init__(
        self,
        *,
        success: bool,
        rows: Optional[List[List[Any]]] = None,
        notices: Optional[List[str]] = None,
        error: str = "",
    ):
        self.success = success
        self.rows = rows or []
        self.notices = notices or []
        self.error = error


class RuntimeTransport(Protocol):
    def run(self, sql: str) -> RuntimeStepResult:
        ...


class DatabaseRuntimeTransport:
    """Minimal psycopg2 transport; no sandbox or implicit object cleanup."""

    def __init__(self, *, host: str, port: int, database: str, user: str, password: str):
        import psycopg2

        self._conn = psycopg2.connect(
            host=host,
            port=port,
            dbname=database,
            user=user,
            password=password,
        )
        self._conn.autocommit = True

    def close(self) -> None:
        if getattr(self, "_conn", None):
            self._conn.close()
            self._conn = None

    def run(self, sql: str) -> RuntimeStepResult:
        cursor = None
        notices_before = list(getattr(self._conn, "notices", []))
        try:
            if hasattr(self._conn, "notices"):
                self._conn.notices.clear()
            cursor = self._conn.cursor()
            cursor.execute(sql)
            rows = []
            if cursor.description:
                rows = [list(row) for row in cursor.fetchall()]
            notices = list(getattr(self._conn, "notices", []))
            return RuntimeStepResult(success=True, rows=rows, notices=notices)
        except Exception as exc:
            notices = list(getattr(self._conn, "notices", []))
            return RuntimeStepResult(success=False, notices=notices, error=str(exc))
        finally:
            if cursor is not None:
                try:
                    cursor.close()
                except Exception:
                    pass
            if hasattr(self._conn, "notices"):
                self._conn.notices.extend(notices_before)


class ScriptedRuntimeTransport:
    def __init__(self, responses: List[RuntimeStepResult]):
        self.responses = list(responses)
        self.calls: List[str] = []

    def run(self, sql: str) -> RuntimeStepResult:
        self.calls.append(sql)
        if not self.responses:
            raise AssertionError(f"unexpected SQL call: {sql}")
        return self.responses.pop(0)


def _guc_unit(
    unit_id: str,
    parameter_id: str,
    target_value: str,
    original_value: str,
    planner: GucEnvironmentPlanner,
) -> RuntimeUnitDef:
    plan = planner.plan(parameter_id, target_value, original_value)
    steps = [
        RuntimeStepDef(
            phase="capture_original",
            sql=plan.steps[0].sql,
            expected_rows=[[_sql_literal_value(original_value)]],
        ),
        RuntimeStepDef(phase="apply", sql=plan.steps[1].sql),
        RuntimeStepDef(
            phase="verify_target",
            sql=plan.steps[2].sql,
            expected_rows=[[_sql_literal_value(target_value)]],
        ),
        RuntimeStepDef(phase="restore", sql=plan.steps[3].sql),
        RuntimeStepDef(
            phase="verify_restore",
            sql=plan.steps[4].sql,
            expected_rows=[[_sql_literal_value(original_value)]],
        ),
    ]
    return RuntimeUnitDef(
        id=unit_id,
        kind="guc_overlay",
        interface_refs=[parameter_id],
        status="ready_for_authorized_execution",
        oracle=RuntimeOracleDef(
            kind="metadata",
            expected=f"{planner.registry.parameters[parameter_id].name}={target_value}; restore={original_value}",
            status="needs_verification",
        ),
        execution_plan=steps,
        cleanup=RuntimeCleanupDef(restore_original_guc=True),
    )


def _advanced_unit(case, package_ref: str) -> RuntimeUnitDef:
    expected_rows = []
    expected_notice = None
    if case.oracle.kind == "value":
        expected_value = "ABC" if case.id.endswith("varchar_roundtrip") else 742
        expected_rows = [[expected_value]]
    else:
        expected_notice = {
            "adv_case_dbe_output_direct_print": "hello, database!",
            "adv_case_dbe_output_buffer_lifecycle": "buffered",
            "adv_case_dbe_sql_select_lifecycle": "value=1",
        }[case.id]
    return RuntimeUnitDef(
        id=case.id,
        kind="advanced_package",
        package_ref=package_ref,
        interface_refs=case.interface_refs,
        status="ready_for_authorized_execution",
        oracle=RuntimeOracleDef(
            kind=case.oracle.kind,
            expected=case.oracle.expected,
            status="needs_verification",
        ),
        execution_plan=[
            RuntimeStepDef(
                phase="target",
                sql=case.sql,
                expected_rows=expected_rows,
                expected_notice=expected_notice,
            )
        ],
        cleanup=RuntimeCleanupDef(
            close_advanced_context=case.cleanup_required,
        ),
    )


def build_dry_run(root: Path) -> RuntimePilotPlanDef:
    guc_registry = GucEnvironmentRegistry(root)
    guc_registry.load_all()
    guc_planner = GucEnvironmentPlanner(guc_registry)

    advanced_registry = AdvancedPackageRegistry(root)
    advanced_registry.load_all()
    advanced_planner = AdvancedPackagePlanner(advanced_registry)

    units: List[RuntimeUnitDef] = [
        _guc_unit(
            "runtime_guc_enable_seqscan_off",
            "guc_enable_seqscan",
            "'off'",
            "'on'",
            guc_planner,
        ),
        _guc_unit(
            "runtime_guc_default_transaction_read_only_on",
            "guc_default_transaction_read_only",
            "'on'",
            "'off'",
            guc_planner,
        ),
    ]
    for package_id in ("dbe_output", "dbe_raw", "dbe_sql"):
        for case in advanced_planner.plan_package(package_id):
            units.append(_advanced_unit(case, package_id))

    return RuntimePilotPlanDef(
        schema_version=1,
        kind="runtime_validation_pilot",
        profile="runtime_validation_pilot_v1",
        status="ready_for_authorized_execution",
        units=units,
        execution_requirements=[
            "explicit_runtime_authorization",
            "single_connection",
            "no_global_guc_changes",
            "restore_original_guc_values",
            "per_step_success_receipt",
            "row_or_notice_oracle",
            "advanced_context_cleanup",
        ],
        limits=[
            "This dry run does not open a database connection or execute SQL.",
            "A planned step is not runtime evidence.",
            "GUC overlays are session-local only and must restore the captured original value.",
            "DBE_SQL context cleanup must succeed on normal and exception paths.",
            "Output oracles depend on database notices and are not claimed without captured evidence.",
        ],
    )


def _step_pass(step: RuntimeStepDef, result: RuntimeStepResult) -> bool:
    if not result.success:
        return False
    if step.expected_rows and result.rows != step.expected_rows:
        return False
    if step.expected_notice and not any(
        step.expected_notice in notice for notice in result.notices
    ):
        return False
    return True


def execute_plan(
    plan: RuntimePilotPlanDef,
    transport: RuntimeTransport,
    *,
    authorized: bool,
) -> Dict[str, Any]:
    if not authorized:
        raise ValueError("runtime execution requires explicit authorization")
    if plan.database_executed or plan.execution_authorized or plan.runtime_verified:
        raise ValueError("execution input already contains runtime claims")

    units: List[Dict[str, Any]] = []
    runtime_verified = 0
    failed_units = 0
    executed_steps = 0

    for unit in plan.units:
        step_results = []
        unit_failed = False
        for step in unit.execution_plan:
            result = transport.run(step.sql)
            executed_steps += 1
            passed = _step_pass(step, result)
            step_results.append({
                "phase": step.phase,
                "sql": step.sql,
                "status": "success" if passed else "failed",
                "rows": result.rows,
                "notices": result.notices,
                "error": result.error,
                "expected_rows": step.expected_rows,
                "expected_notice": step.expected_notice,
            })
            if not passed:
                unit_failed = True
                break
        verified = not unit_failed and bool(step_results)
        if verified:
            runtime_verified += 1
        else:
            failed_units += 1
        units.append({
            "id": unit.id,
            "kind": unit.kind,
            "package_ref": unit.package_ref,
            "interface_refs": unit.interface_refs,
            "status": "runtime_verified" if verified else "execution_failed",
            "database_executed": True,
            "runtime_verified": verified,
            "oracle": unit.oracle.model_dump(),
            "steps": step_results,
            "cleanup": unit.cleanup.model_dump(),
        })

    return {
        "kind": "runtime_validation_receipt",
        "schema_version": 1,
        "profile": plan.profile,
        "status": "runtime_verified" if runtime_verified == len(plan.units) else "failed",
        "database_executed": True,
        "execution_authorized": True,
        "runtime_verified": runtime_verified,
        "failed_units": failed_units,
        "executed_steps": executed_steps,
        "units": units,
        "limits": plan.limits,
    }


def plan_sha256(plan: RuntimePilotPlanDef) -> str:
    import hashlib

    canonical = json.dumps(
        plan.model_dump(mode="json"),
        ensure_ascii=False,
        sort_keys=True,
        separators=(",", ":"),
    ).encode("utf-8")
    return hashlib.sha256(canonical).hexdigest()
