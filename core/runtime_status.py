"""Aggregate runtime validation artifacts into one honest readiness report."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, ConfigDict, Field

from .phase1_report_audit import Phase1ReportAuditResult, Phase1ReportDef
from .runtime_preflight import RuntimePreflightResult
from .runtime_receipt_audit import RuntimeReceiptAuditResult, RuntimeReceiptDef
from .runtime_validation_pilot import RuntimePilotPlanDef
from .guc_readiness import GucV2ReadinessResultDef
from .guc_evidence_bundle import GucV2EvidenceBundleDef
from .guc_runtime_pilot import GucV2RuntimePilotRegistry
from .advanced_package_evidence import AdvancedEvidenceBundleDef


class StrictRuntimeStatusModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class RuntimeArtifactStatus(StrictRuntimeStatusModel):
    path: str
    exists: bool
    valid: bool = False
    kind: Optional[str] = None
    error: str = ""
    summary: Dict[str, Any] = Field(default_factory=dict)
    sha256: Optional[str] = None
    size_bytes: Optional[int] = None


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


def _artifact_identity(path: Path):
    try:
        content = path.read_bytes()
    except OSError:
        return None, None
    return hashlib.sha256(content).hexdigest(), len(content)


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


def _guc_v2_runtime_plan_summary(value):
    return {
        "profile": value.profile,
        "unit_count": len(value.units),
        "step_count": sum(len(unit.execution_plan) for unit in value.units),
        "database_executed": value.database_executed,
        "execution_authorized": value.execution_authorized,
        "runtime_verified": value.runtime_verified,
    }


def _guc_v2_readiness_summary(value: GucV2ReadinessResultDef):
    return {
        "static_audit_valid": value.static_audit_valid,
        "environment_v2_valid": value.environment_v2_valid,
        "overlay_plans_valid": value.overlay_plans_valid,
        "runtime_plan_valid": value.runtime_plan_valid,
        "preflight_plan_valid": value.preflight_plan_valid,
        "preflight_result_present": value.preflight_result_present,
        "preflight_result_valid": value.preflight_result_valid,
        "preflight_connected": value.preflight_connected,
        "preflight_metadata_read": value.preflight_metadata_read,
        "ready_for_authorized_execution": value.ready_for_authorized_execution,
        "execution_authorized": value.execution_authorized,
        "runtime_verified": value.runtime_verified,
        **value.summary,
    }


def _guc_v2_evidence_bundle_summary(value: GucV2EvidenceBundleDef):
    return {
        "artifact_count": value.summary.artifact_count,
        "present_count": value.summary.present_count,
        "missing_count": value.summary.missing_count,
        "static_complete": value.summary.static_complete,
        "preflight_complete": value.summary.preflight_complete,
        "runtime_complete": value.summary.runtime_complete,
        "all_complete": value.summary.all_complete,
    }


def _phase1_audit_summary(value: Phase1ReportAuditResult):
    return {
        "valid": value.valid,
        "runtime_verified": value.runtime_verified,
        **value.summary,
    }


def _advanced_package_evidence_summary(value: AdvancedEvidenceBundleDef):
    return {
        "artifact_count": value.summary.artifact_count,
        "present_count": value.summary.present_count,
        "missing_count": value.summary.missing_count,
        "package_count": value.summary.package_count,
        "supported_package_count": value.summary.supported_package_count,
        "unmodeled_supported_package_count": value.summary.unmodeled_supported_package_count,
        "interface_count": value.summary.interface_count,
        "runtime_candidate_interface_count": value.summary.runtime_candidate_interface_count,
        "manual_review_interface_count": value.summary.manual_review_interface_count,
        "static_probe_interface_count": value.summary.static_probe_interface_count,
        "test_case_count": value.summary.test_case_count,
        "runtime_case_interface_count": value.summary.runtime_case_interface_count,
        "uncovered_runtime_candidate_interface_count": value.summary.uncovered_runtime_candidate_interface_count,
        "runtime_candidate_case_coverage_complete": value.summary.runtime_candidate_case_coverage_complete,
        "preflight_plan_present": value.summary.preflight_plan_present,
        "preflight_result_present": value.summary.preflight_result_present,
        "preflight_audit_present": value.summary.preflight_audit_present,
        "preflight_plan_valid": value.summary.preflight_plan_valid,
        "preflight_result_valid": value.summary.preflight_result_valid,
        "preflight_audit_valid": value.summary.preflight_audit_valid,
        "preflight_connected": value.summary.preflight_connected,
        "preflight_metadata_read": value.summary.preflight_metadata_read,
        "preflight_finding_count": value.summary.preflight_finding_count,
        "preflight_ready": value.summary.preflight_ready,
        "static_complete": value.summary.static_complete,
        "runtime_complete": value.summary.runtime_complete,
        "all_complete": value.summary.all_complete,
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
        "guc_v2_runtime_plan": root / "generated/guc_environment_v2/runtime_dry_run.json",
        "guc_v2_readiness": root / "generated/guc_environment_v2/readiness.json",
        "guc_v2_runtime_receipt": root / "generated/guc_environment_v2/runtime_receipt.json",
        "guc_v2_runtime_receipt_audit": root / "generated/guc_environment_v2/runtime_receipt_audit.json",
        "guc_v2_evidence_bundle": root / "generated/guc_environment_v2/evidence_bundle.json",
        "advanced_package_evidence_bundle": root / "generated/advanced_package_pilot/evidence_bundle.json",
    }

    artifacts: Dict[str, RuntimeArtifactStatus] = {}
    parsed: Dict[str, Any] = {}

    for name, path in paths.items():
        raw, error = _load(path)
        exists = path.is_file()
        sha256, size_bytes = _artifact_identity(path) if exists else (None, None)
        if raw is None:
            artifacts[name] = RuntimeArtifactStatus(
                path=str(path.relative_to(root)), exists=exists, valid=False, error=error,
                sha256=sha256, size_bytes=size_bytes,
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
            elif name == "guc_v2_runtime_plan":
                value = GucV2RuntimePilotRegistry(root).load(path)
                summary = _guc_v2_runtime_plan_summary(value)
            elif name == "guc_v2_readiness":
                value = GucV2ReadinessResultDef(**raw)
                summary = _guc_v2_readiness_summary(value)
            elif name == "guc_v2_runtime_receipt":
                value = RuntimeReceiptDef(**raw)
                summary = _runtime_receipt_summary(value)
            elif name == "guc_v2_runtime_receipt_audit":
                value = RuntimeReceiptAuditResult(**raw)
                summary = _runtime_audit_summary(value)
            elif name == "guc_v2_evidence_bundle":
                value = GucV2EvidenceBundleDef(**raw)
                summary = _guc_v2_evidence_bundle_summary(value)
            elif name == "advanced_package_evidence_bundle":
                value = AdvancedEvidenceBundleDef(**raw)
                summary = _advanced_package_evidence_summary(value)
            else:  # pragma: no cover - guarded by paths keys
                raise ValueError(f"unknown artifact: {name}")
        except Exception as exc:
            artifacts[name] = RuntimeArtifactStatus(
                path=str(path.relative_to(root)), exists=True, valid=False, error=str(exc),
                sha256=sha256, size_bytes=size_bytes,
            )
            continue

        parsed[name] = value
        artifacts[name] = RuntimeArtifactStatus(
            path=str(path.relative_to(root)),
            exists=True,
            valid=True,
            kind=raw.get("kind"),
            summary=summary,
            sha256=sha256,
            size_bytes=size_bytes,
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
    guc_v2_static_ready = artifacts["guc_v2_readiness"].valid and all(
        bool(artifacts["guc_v2_readiness"].summary.get(key))
        for key in (
            "static_audit_valid",
            "environment_v2_valid",
            "overlay_plans_valid",
            "runtime_plan_valid",
            "preflight_plan_valid",
        )
    )
    guc_v2_preflight_ready = (
        artifacts["guc_v2_readiness"].valid
        and bool(artifacts["guc_v2_readiness"].summary.get("preflight_plan_valid"))
        and bool(artifacts["guc_v2_readiness"].summary.get("preflight_result_present"))
        and bool(artifacts["guc_v2_readiness"].summary.get("preflight_result_valid"))
        and bool(artifacts["guc_v2_readiness"].summary.get("preflight_audit_valid"))
        and bool(artifacts["guc_v2_readiness"].summary.get("preflight_connected"))
        and bool(artifacts["guc_v2_readiness"].summary.get("preflight_metadata_read"))
        and artifacts["guc_v2_readiness"].summary.get("preflight_domain_mismatch_count") == 0
        and artifacts["guc_v2_readiness"].summary.get("preflight_error_count") == 0
    )
    guc_v2_ready_for_authorized_execution = artifacts["guc_v2_readiness"].valid and bool(
        artifacts["guc_v2_readiness"].summary.get("ready_for_authorized_execution")
    )
    guc_v2_runtime_executed = artifacts["guc_v2_runtime_receipt"].valid and bool(
        artifacts["guc_v2_runtime_receipt"].summary.get("database_executed")
    )
    guc_v2_runtime_audit_valid = artifacts["guc_v2_runtime_receipt_audit"].valid and bool(
        artifacts["guc_v2_runtime_receipt_audit"].summary.get("valid")
    ) and bool(artifacts["guc_v2_runtime_receipt_audit"].summary.get("plan_verified"))
    guc_v2_evidence_bundle_complete = artifacts["guc_v2_evidence_bundle"].valid and bool(
        artifacts["guc_v2_evidence_bundle"].summary.get("static_complete")
    )
    advanced_package_static_ready = artifacts["advanced_package_evidence_bundle"].valid and bool(
        artifacts["advanced_package_evidence_bundle"].summary.get("static_complete")
    )
    advanced_package_preflight_ready = artifacts["advanced_package_evidence_bundle"].valid and bool(
        artifacts["advanced_package_evidence_bundle"].summary.get("preflight_ready")
    )
    advanced_package_runtime_executed = artifacts["advanced_package_evidence_bundle"].valid and bool(
        artifacts["advanced_package_evidence_bundle"].summary.get("runtime_complete")
    )
    advanced_package_runtime_candidate_coverage_complete = artifacts["advanced_package_evidence_bundle"].valid and bool(
        artifacts["advanced_package_evidence_bundle"].summary.get("runtime_candidate_case_coverage_complete")
    )
    advanced_package_all_complete = artifacts["advanced_package_evidence_bundle"].valid and bool(
        artifacts["advanced_package_evidence_bundle"].summary.get("all_complete")
    )
    guc_v2_all_modeled_runtime_evidence_complete = all([
        guc_v2_static_ready,
        guc_v2_evidence_bundle_complete,
        guc_v2_preflight_ready,
        guc_v2_ready_for_authorized_execution,
        guc_v2_runtime_executed,
        guc_v2_runtime_audit_valid,
    ])
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
    if not guc_v2_preflight_ready:
        next_actions.append("Run the GUC V2 read-only preflight against the target database.")
    if not guc_v2_ready_for_authorized_execution:
        next_actions.append("Clear GUC V2 readiness blockers before runtime authorization.")
    if not guc_v2_runtime_executed:
        next_actions.append("Execute the GUC V2 runtime pilot after explicit authorization.")
    if not guc_v2_runtime_audit_valid:
        next_actions.append("Audit the GUC V2 runtime receipt.")
    if not guc_v2_evidence_bundle_complete:
        next_actions.append("Rebuild the GUC V2 static evidence bundle.")
    if not advanced_package_static_ready:
        next_actions.append("Build the Advanced Package evidence bundle.")
    if not advanced_package_preflight_ready:
        next_actions.append("Run the Advanced Package read-only preflight and resolve audit findings.")
    if not advanced_package_runtime_executed:
        next_actions.append("Run Advanced Package runtime pilot and audit its receipt.")
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
            "guc_v2_static_ready": guc_v2_static_ready,
            "guc_v2_preflight_ready": guc_v2_preflight_ready,
            "guc_v2_ready_for_authorized_execution": guc_v2_ready_for_authorized_execution,
            "guc_v2_runtime_executed": guc_v2_runtime_executed,
            "guc_v2_runtime_audit_valid": guc_v2_runtime_audit_valid,
            "guc_v2_evidence_bundle_complete": guc_v2_evidence_bundle_complete,
            "guc_v2_all_modeled_runtime_evidence_complete": guc_v2_all_modeled_runtime_evidence_complete,
            "advanced_package_static_ready": advanced_package_static_ready,
            "advanced_package_preflight_ready": advanced_package_preflight_ready,
            "advanced_package_runtime_executed": advanced_package_runtime_executed,
            "advanced_package_runtime_candidate_coverage_complete": advanced_package_runtime_candidate_coverage_complete,
            "advanced_package_all_complete": advanced_package_all_complete,
            "all_modeled_runtime_evidence_complete": all([
                offline_ready, preflight_ready, runtime_executed,
                runtime_audit_valid, phase1_executed, phase1_audit_valid,
                guc_v2_all_modeled_runtime_evidence_complete,
                advanced_package_all_complete,
            ]),
        },
        next_actions=next_actions,
    )
