"""Aggregate runtime validation artifacts into one honest readiness report."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, ConfigDict, Field

from .phase1_report_audit import Phase1ReportAuditResult, Phase1ReportDef
from .runtime_preflight import RuntimePreflightResult
from .runtime_receipt_audit import RuntimeReceiptAuditResult, RuntimeReceiptDef
from .runtime_validation_pilot import RuntimePilotPlanDef


class StrictRuntimeStatusModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class RuntimeArtifactStatus(StrictRuntimeStatusModel):
    path: str
    exists: bool
    valid: bool = False
    kind: Optional[str] = None
    error: str = ""
    summary: Dict[str, Any] = Field(default_factory=dict)


class RuntimeStatusResult(StrictRuntimeStatusModel):
    kind: str = "runtime_status"
    schema_version: int = 1
    artifacts: Dict[str, RuntimeArtifactStatus]
    readiness: Dict[str, bool]
    next_actions: List[str]
    limits: List[str] = Field(default_factory=lambda: [
        "Artifact presence does not prove database behavior.",
        "A valid receipt or report proves only its recorded units and steps.",
        "Preflight readiness does not authorize target SQL execution.",
        "Runtime execution still requires explicit database authorization.",
    ])


def _load(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8")), ""
    except FileNotFoundError:
        return None, "file not found"
    except (OSError, json.JSONDecodeError) as exc:
        return None, str(exc)


def _preflight_summary(value: RuntimePreflightResult):
    return {
        "connected": value.connected,
        "metadata_read": value.metadata_read,
        "target_sql_executed": value.target_sql_executed,
        "guc_changed": value.guc_changed,
        "object_created": value.object_created,
        "query_count": len(value.queries),
        "error_count": len(value.errors),
    }


def _runtime_plan_summary(value: RuntimePilotPlanDef):
    return {
        "unit_count": len(value.units),
        "step_count": sum(len(unit.execution_plan) for unit in value.units),
        "database_executed": value.database_executed,
        "execution_authorized": value.execution_authorized,
        "runtime_verified": value.runtime_verified,
        "plan_sha256": None,
    }


def _runtime_receipt_summary(value: RuntimeReceiptDef):
    return {
        "unit_count": len(value.units),
        "step_count": value.executed_steps,
        "database_executed": value.database_executed,
        "execution_authorized": value.execution_authorized,
        "runtime_verified": value.runtime_verified,
        "plan_sha256": value.plan_sha256,
    }


def _runtime_audit_summary(value: RuntimeReceiptAuditResult):
    return {
        "valid": value.valid,
        "plan_verified": value.plan_verified,
        **value.summary,
    }


def _phase1_plan_summary(value: dict):
    return {
        "unit_count": len(value.get("units", [])),
        "has_setup": isinstance(value.get("setup"), dict),
        "has_cleanup": isinstance(value.get("cleanup"), dict),
        "database_executed": value.get("database_executed"),
        "execution_authorized": value.get("execution_authorized"),
        "runtime_verified": value.get("runtime_verified"),
    }


def _phase1_report_summary(value: Phase1ReportDef):
    return {
        "total": value.summary.total,
        "passed": value.summary.passed,
        "failed": value.summary.failed,
        "blocked": value.summary.blocked,
        "executed": value.summary.executed,
        "pass_rate": value.summary.pass_rate,
    }


def _phase1_audit_summary(value: Phase1ReportAuditResult):
    return {
        "valid": value.valid,
        "runtime_verified": value.runtime_verified,
        **value.summary,
    }


def build_runtime_status(root: Path) -> RuntimeStatusResult:
    root = Path(root)
    paths = {
        "preflight": root / "generated/runtime_validation_pilot/preflight.json",
        "runtime_plan": root / "generated/runtime_validation_pilot/dry_run.json",
        "runtime_receipt": root / "generated/runtime_validation_pilot/receipt.json",
        "runtime_receipt_audit": root / "generated/runtime_validation_pilot/receipt_audit.json",
        "phase1_plan": root / "generated/runtime_validation_pilot/phase1_dry_run.json",
        "phase1_report": root / "generated/runtime_validation_pilot/phase1_report.json",
        "phase1_report_audit": root / "generated/runtime_validation_pilot/phase1_report_audit.json",
    }

    artifacts: Dict[str, RuntimeArtifactStatus] = {}
    parsed: Dict[str, Any] = {}

    for name, path in paths.items():
        raw, error = _load(path)
        exists = path.is_file()
        if raw is None:
            artifacts[name] = RuntimeArtifactStatus(
                path=str(path.relative_to(root)), exists=exists, valid=False, error=error
            )
            continue

        try:
            if name == "preflight":
                value = RuntimePreflightResult(**raw)
                summary = _preflight_summary(value)
            elif name == "runtime_plan":
                # The persisted artifact carries its fingerprint as metadata;
                # the plan model itself remains hash-free.
                plan_raw = {key: value for key, value in raw.items() if key != "plan_sha256"}
                value = RuntimePilotPlanDef(**plan_raw)
                summary = _runtime_plan_summary(value)
                summary["plan_sha256"] = raw.get("plan_sha256")
            elif name == "runtime_receipt":
                value = RuntimeReceiptDef(**raw)
                summary = _runtime_receipt_summary(value)
            elif name == "runtime_receipt_audit":
                value = RuntimeReceiptAuditResult(**raw)
                summary = _runtime_audit_summary(value)
            elif name == "phase1_plan":
                value = raw
                summary = _phase1_plan_summary(value)
            elif name == "phase1_report":
                value = Phase1ReportDef(**raw)
                summary = _phase1_report_summary(value)
            elif name == "phase1_report_audit":
                value = Phase1ReportAuditResult(**raw)
                summary = _phase1_audit_summary(value)
            else:  # pragma: no cover - guarded by paths keys
                raise ValueError(f"unknown artifact: {name}")
        except Exception as exc:
            artifacts[name] = RuntimeArtifactStatus(
                path=str(path.relative_to(root)), exists=True, valid=False, error=str(exc)
            )
            continue

        parsed[name] = value
        artifacts[name] = RuntimeArtifactStatus(
            path=str(path.relative_to(root)),
            exists=True,
            valid=True,
            kind=raw.get("kind"),
            summary=summary,
        )

    offline_ready = artifacts["runtime_plan"].valid and artifacts["phase1_plan"].valid
    preflight_ready = artifacts["preflight"].valid and bool(
        artifacts["preflight"].summary.get("connected")
    ) and bool(artifacts["preflight"].summary.get("metadata_read"))
    runtime_executed = artifacts["runtime_receipt"].valid and bool(
        artifacts["runtime_receipt"].summary.get("database_executed")
    )
    runtime_audit_valid = artifacts["runtime_receipt_audit"].valid and bool(
        artifacts["runtime_receipt_audit"].summary.get("valid")
    ) and bool(artifacts["runtime_receipt_audit"].summary.get("plan_verified"))
    phase1_executed = artifacts["phase1_report"].valid and bool(
        artifacts["phase1_report"].summary.get("executed")
    )
    phase1_audit_valid = artifacts["phase1_report_audit"].valid and bool(
        artifacts["phase1_report_audit"].summary.get("valid")
    )

    next_actions: List[str] = []
    if not artifacts["runtime_plan"].valid:
        next_actions.append("Generate the runtime pilot dry-run plan.")
    if not artifacts["phase1_plan"].valid:
        next_actions.append("Generate the Phase 1 dry-run plan.")
    if not preflight_ready:
        next_actions.append("Run the read-only runtime preflight after database configuration.")
    if not runtime_executed:
        next_actions.append("Execute the runtime pilot only after explicit authorization.")
    if not runtime_audit_valid:
        next_actions.append("Audit the runtime receipt against its dry-run plan.")
    if not phase1_executed:
        next_actions.append("Execute Phase 1 from its generated plan after authorization.")
    if not phase1_audit_valid:
        next_actions.append("Audit the Phase 1 execution report.")
    if not next_actions:
        next_actions.append("All currently modeled runtime artifacts are present and audited.")

    return RuntimeStatusResult(
        artifacts=artifacts,
        readiness={
            "offline_ready": offline_ready,
            "preflight_ready": preflight_ready,
            "runtime_executed": runtime_executed,
            "runtime_audit_valid": runtime_audit_valid,
            "phase1_executed": phase1_executed,
            "phase1_audit_valid": phase1_audit_valid,
            "all_modeled_runtime_evidence_complete": all([
                offline_ready, preflight_ready, runtime_executed,
                runtime_audit_valid, phase1_executed, phase1_audit_valid,
            ]),
        },
        next_actions=next_actions,
    )
