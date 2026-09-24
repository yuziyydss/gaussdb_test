"""Strict audit model for runtime validation receipts.

A receipt is not trusted merely because it says ``runtime_verified``.  This
module checks internal consistency, safety boundaries, and optional plan
identity before accepting a runtime claim.
"""
from __future__ import annotations

import re
from typing import Any, Dict, List, Literal, Optional, Sequence

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from .runtime_validation_pilot import RuntimePilotPlanDef, plan_sha256


class StrictRuntimeReceiptAuditModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class RuntimeReceiptStepDef(StrictRuntimeReceiptAuditModel):
    phase: str
    sql: str
    status: Literal["success", "failed"]
    rows: List[List[Any]] = Field(default_factory=list)
    notices: List[str] = Field(default_factory=list)
    error: str = ""
    expected_rows: List[List[Any]] = Field(default_factory=list)
    expected_notice: Optional[str] = None

    @field_validator("phase", "sql")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("runtime receipt step 字段不能为空")
        return value


class RuntimeReceiptUnitDef(StrictRuntimeReceiptAuditModel):
    id: str
    kind: Literal["guc_overlay", "advanced_package"]
    package_ref: Optional[str] = None
    interface_refs: List[str]
    status: Literal["runtime_verified", "execution_failed"]
    database_executed: bool
    runtime_verified: bool
    oracle: Dict[str, str]
    steps: List[RuntimeReceiptStepDef]
    cleanup: Dict[str, bool]

    @model_validator(mode="after")
    def ensure_status_consistency(self) -> "RuntimeReceiptUnitDef":
        if self.runtime_verified and self.status != "runtime_verified":
            raise ValueError("runtime_verified 单元状态必须一致")
        if not self.runtime_verified and self.status != "execution_failed":
            raise ValueError("未验证单元必须标记 execution_failed")
        if self.runtime_verified and not self.database_executed:
            raise ValueError("runtime_verified 单元必须 database_executed=true")
        return self


class RuntimeReceiptDef(StrictRuntimeReceiptAuditModel):
    kind: Literal["runtime_validation_receipt"]
    schema_version: Literal[1]
    profile: Literal["runtime_validation_pilot_v1"]
    status: Literal["runtime_verified", "failed"]
    database_executed: bool
    execution_authorized: bool
    runtime_verified: int
    failed_units: int
    executed_steps: int
    plan_sha256: str
    plan_unit_ids: List[str]
    plan_step_count: int
    units: List[RuntimeReceiptUnitDef]
    limits: List[str]

    @field_validator("plan_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if not re.fullmatch(r"[0-9a-f]{64}", value):
            raise ValueError("plan_sha256 必须是64位十六进制 SHA-256")
        return value

    @model_validator(mode="after")
    def ensure_top_level_consistency(self) -> "RuntimeReceiptDef":
        if not self.database_executed or not self.execution_authorized:
            raise ValueError("runtime receipt 必须声明已授权执行")
        if self.runtime_verified < 0 or self.failed_units < 0 or self.executed_steps < 0:
            raise ValueError("runtime receipt 计数不能为负")
        return self


class RuntimeReceiptAuditResult(StrictRuntimeReceiptAuditModel):
    kind: Literal["runtime_receipt_audit"]
    schema_version: Literal[1]
    valid: bool
    errors: List[str] = Field(default_factory=list)
    summary: Dict[str, int]
    plan_verified: bool = False
    limits: List[str] = Field(default_factory=lambda: [
        "A valid receipt proves only the recorded runtime execution, not general package behavior.",
        "A valid receipt does not prove untested GUC values, interfaces, or advanced packages.",
        "Receipt audit does not replace database-side authorization or connection security review.",
    ])


def _contains_forbidden_sql(sql: str) -> bool:
    forbidden = (
        "ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET ",
        "DROP ", "TRUNCATE ", "DBMS_",
    )
    return any(token in sql.upper() for token in forbidden)


def _audit_unit(unit: RuntimeReceiptUnitDef, errors: List[str]) -> None:
    if not unit.steps:
        errors.append(f"{unit.id}: unit has no execution steps")
        return

    expected_phases = (
        ["capture_original", "apply", "verify_target", "restore", "verify_restore"]
        if unit.kind == "guc_overlay"
        else ["target"]
    )
    actual_phases = [step.phase for step in unit.steps]
    if actual_phases != expected_phases:
        errors.append(f"{unit.id}: step phases do not match {expected_phases}")

    if unit.kind == "guc_overlay":
        if not unit.cleanup.get("restore_original_guc", False):
            errors.append(f"{unit.id}: GUC overlay must restore original value")
        if not unit.database_executed:
            errors.append(f"{unit.id}: GUC overlay must record database execution")

    if unit.id.startswith("adv_case_dbe_sql_"):
        if not unit.cleanup.get("close_advanced_context", False):
            errors.append(f"{unit.id}: DBE_SQL unit must close context")
        sql = "\n".join(step.sql for step in unit.steps)
        if sql.count("DBE_SQL.SQL_UNREGISTER_CONTEXT") < 2:
            errors.append(f"{unit.id}: DBE_SQL unit must close context on normal and exception paths")

    for step in unit.steps:
        if _contains_forbidden_sql(step.sql):
            errors.append(f"{unit.id}/{step.phase}: forbidden SQL detected")
        if step.status == "success" and step.error:
            errors.append(f"{unit.id}/{step.phase}: success step cannot contain error")
        if step.status == "failed" and not step.error:
            errors.append(f"{unit.id}/{step.phase}: failed step must contain error")

    all_success = all(step.status == "success" for step in unit.steps)
    if unit.runtime_verified and not all_success:
        errors.append(f"{unit.id}: runtime_verified unit has failed/pending steps")
    if not unit.runtime_verified and all_success:
        errors.append(f"{unit.id}: all steps succeeded but unit is not runtime_verified")


def audit_runtime_receipt(
    receipt: Dict[str, Any],
    *,
    plan: Optional[RuntimePilotPlanDef] = None,
) -> RuntimeReceiptAuditResult:
    errors: List[str] = []
    plan_verified = False

    try:
        parsed = RuntimeReceiptDef(**receipt)
    except Exception as exc:
        return RuntimeReceiptAuditResult(
            kind="runtime_receipt_audit",
            schema_version=1,
            valid=False,
            errors=[f"receipt schema validation failed: {exc}"],
            summary={"units": 0, "runtime_verified": 0, "failed_units": 0, "executed_steps": 0},
        )

    if plan is not None:
        expected_hash = plan_sha256(plan)
        if parsed.plan_sha256 != expected_hash:
            errors.append(
                f"plan hash mismatch: receipt={parsed.plan_sha256}, plan={expected_hash}"
            )
        expected_unit_ids = [unit.id for unit in plan.units]
        if parsed.plan_unit_ids != expected_unit_ids:
            errors.append("plan unit IDs do not match supplied plan")
        expected_step_count = sum(len(unit.execution_plan) for unit in plan.units)
        if parsed.plan_step_count != expected_step_count:
            errors.append("plan step count does not match supplied plan")
        if not errors:
            plan_verified = True
    else:
        errors.append("plan not supplied; plan identity could not be verified")

    actual_step_count = sum(len(unit.steps) for unit in parsed.units)
    if actual_step_count != parsed.executed_steps:
        errors.append(
            f"executed_steps mismatch: top-level={parsed.executed_steps}, actual={actual_step_count}"
        )

    verified_count = sum(unit.runtime_verified for unit in parsed.units)
    if verified_count != parsed.runtime_verified:
        errors.append(
            f"runtime_verified mismatch: top-level={parsed.runtime_verified}, actual={verified_count}"
        )

    failed_count = sum(not unit.runtime_verified for unit in parsed.units)
    if failed_count != parsed.failed_units:
        errors.append(
            f"failed_units mismatch: top-level={parsed.failed_units}, actual={failed_count}"
        )

    for unit in parsed.units:
        _audit_unit(unit, errors)

    return RuntimeReceiptAuditResult(
        kind="runtime_receipt_audit",
        schema_version=1,
        valid=not errors,
        errors=errors,
        summary={
            "units": len(parsed.units),
            "runtime_verified": verified_count,
            "failed_units": failed_count,
            "executed_steps": actual_step_count,
        },
        plan_verified=plan_verified,
    )
