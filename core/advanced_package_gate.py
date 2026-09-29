"""Fail-closed execution gate for the Advanced Package runtime pilot.

The gate separates static evidence, runtime-plan readiness, authorization, and
database availability.  A static bundle never authorizes database execution.
"""
from __future__ import annotations

from pathlib import Path
from typing import List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, model_validator

from core.advanced_package_evidence import (
    AdvancedEvidenceBundleRegistry,
    verify_advanced_package_evidence_bundle,
)
from core.runtime_validation_pilot import RuntimePilotPlanDef


class StrictAdvancedGateModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class AdvancedPackageGateResultDef(StrictAdvancedGateModel):
    kind: Literal["advanced_package_gate"] = "advanced_package_gate"
    schema_version: Literal[1] = 1
    static_evidence_valid: bool
    runtime_plan_valid: bool
    preflight_plan_valid: bool
    preflight_result_present: bool
    preflight_result_valid: bool
    preflight_audit_present: bool
    preflight_audit_valid: bool
    preflight_connected: bool
    preflight_metadata_read: bool
    preflight_finding_count: int
    preflight_ready: bool
    runtime_receipt_present: bool
    runtime_receipt_audit_present: bool
    static_ready: bool
    runtime_plan_ready: bool
    technical_ready: bool
    authorization_requested: bool
    authorization_environment_set: bool
    authorization_ready: bool
    database_enabled: bool
    database_ready: bool
    ready_for_authorized_execution: bool
    allowed: bool
    blockers: List[str]
    next_actions: List[str]
    limits: List[str] = Field(default_factory=lambda: [
        "A valid static bundle does not authorize execution.",
        "A valid runtime dry-run is not an execution receipt.",
        "Execution requires explicit CLI and environment authorization.",
        "Execution requires a successful, audited, zero-finding preflight.",
        "Runtime evidence still requires receipt and independent audit.",
    ])

    @model_validator(mode="after")
    def ensure_gate_consistency(self) -> "AdvancedPackageGateResultDef":
        expected_technical = self.static_ready and self.runtime_plan_ready and self.preflight_ready
        expected_authorization = (
            self.authorization_requested and self.authorization_environment_set
        )
        expected_allowed = (
            expected_technical
            and expected_authorization
            and self.database_ready
            and not self.runtime_receipt_present
            and not self.runtime_receipt_audit_present
        )
        if self.technical_ready != expected_technical:
            raise ValueError("Advanced package technical readiness is inconsistent")
        if self.authorization_ready != expected_authorization:
            raise ValueError("Advanced package authorization readiness is inconsistent")
        if self.ready_for_authorized_execution != (
            expected_technical and not self.runtime_receipt_present
        ):
            raise ValueError("Advanced package ready_for_authorized_execution is inconsistent")
        if self.allowed != expected_allowed:
            raise ValueError("Advanced package gate decision is inconsistent")
        return self


def evaluate_advanced_package_gate(
    root: Path,
    *,
    authorized_flag: bool,
    authorization_environment_set: bool,
    database_enabled: bool,
) -> AdvancedPackageGateResultDef:
    root = Path(root)
    evidence_bundle_path = root / "generated/advanced_package_pilot/evidence_bundle.json"
    runtime_plan_path = root / "generated/runtime_validation_pilot/dry_run.json"
    runtime_receipt_path = root / "generated/runtime_validation_pilot/receipt.json"
    runtime_receipt_audit_path = root / "generated/runtime_validation_pilot/receipt_audit.json"

    static_evidence_valid = False
    static_ready = False
    errors: List[str] = []
    try:
        verify_advanced_package_evidence_bundle(root)
        static_evidence_valid = True
        static_ready = True
    except Exception as exc:
        errors.append(f"advanced package static evidence is invalid: {exc}")

    runtime_plan_valid = False
    try:
        payload = json_load(runtime_plan_path)
        payload.pop("plan_sha256", None)
        runtime_plan = RuntimePilotPlanDef(**payload)
        runtime_plan_valid = (
            runtime_plan.profile == "runtime_validation_pilot_v1"
            and len(runtime_plan.units) == 29
            and sum(len(unit.execution_plan) for unit in runtime_plan.units) == 37
        )
    except Exception:
        runtime_plan_valid = False

    preflight_state = {
        "plan_valid": False, "result_present": False, "result_valid": False,
        "audit_present": False, "audit_valid": False, "connected": False,
        "metadata_read": False, "finding_count": 0,
    }
    if static_evidence_valid:
        try:
            evidence_payload = json_load(evidence_bundle_path)
            evidence_summary = evidence_payload["summary"]
            preflight_state.update({
                "plan_valid": bool(evidence_summary["preflight_plan_valid"]),
                "result_present": bool(evidence_summary["preflight_result_present"]),
                "result_valid": bool(evidence_summary["preflight_result_valid"]),
                "audit_present": bool(evidence_summary["preflight_audit_present"]),
                "audit_valid": bool(evidence_summary["preflight_audit_valid"]),
                "connected": bool(evidence_summary["preflight_connected"]),
                "metadata_read": bool(evidence_summary["preflight_metadata_read"]),
                "finding_count": int(evidence_summary["preflight_finding_count"]),
            })
        except Exception:
            pass
    preflight_ready = all([
        preflight_state["plan_valid"],
        preflight_state["result_present"] and preflight_state["result_valid"],
        preflight_state["audit_present"] and preflight_state["audit_valid"],
        preflight_state["connected"],
        preflight_state["metadata_read"],
        preflight_state["finding_count"] == 0,
    ])
    runtime_receipt_present = runtime_receipt_path.is_file()
    runtime_receipt_audit_present = runtime_receipt_audit_path.is_file()

    static_ready = static_evidence_valid and static_ready
    runtime_plan_ready = runtime_plan_valid
    technical_ready = static_ready and runtime_plan_ready and preflight_ready
    authorization_ready = authorized_flag and authorization_environment_set
    database_ready = database_enabled
    allowed = (
        technical_ready
        and authorization_ready
        and database_ready
        and not runtime_receipt_present
        and not runtime_receipt_audit_present
    )

    blockers: List[str] = []
    if not static_ready:
        blockers.append("Advanced package static evidence is missing or drifted.")
    if not runtime_plan_ready:
        blockers.append("Advanced package runtime plan is missing or invalid.")
    if not preflight_state["plan_valid"]:
        blockers.append("Advanced package preflight plan is missing or invalid.")
    if not preflight_state["result_present"]:
        blockers.append("Advanced package preflight result is missing.")
    elif not preflight_state["result_valid"]:
        blockers.append("Advanced package preflight result is invalid.")
    if not preflight_state["audit_present"]:
        blockers.append("Advanced package preflight audit is missing.")
    elif not preflight_state["audit_valid"]:
        blockers.append("Advanced package preflight audit is missing, invalid, or stale.")
    if preflight_state["result_valid"] and not preflight_state["connected"]:
        blockers.append("Advanced package preflight did not connect to the target database.")
    if preflight_state["result_valid"] and not preflight_state["metadata_read"]:
        blockers.append("Advanced package preflight could not read all required metadata.")
    if preflight_state["result_valid"] and preflight_state["finding_count"] > 0:
        blockers.append("Advanced package preflight has findings that require review.")
    if runtime_receipt_present:
        blockers.append("Advanced package runtime receipt already exists.")
    if runtime_receipt_audit_present:
        blockers.append("Advanced package runtime receipt audit already exists.")
    if not authorized_flag:
        blockers.append("Runtime execution authorization flag is missing.")
    if not authorization_environment_set:
        blockers.append("GAUSSDB_RUNTIME_PILOT_AUTHORIZED is not set to true.")
    if not database_enabled:
        blockers.append("GAUSSDB_ENABLED is not true.")

    next_actions: List[str] = []
    if not static_ready:
        next_actions.append("Rebuild and verify the Advanced Package evidence bundle.")
    if not runtime_plan_ready:
        next_actions.append("Regenerate the Advanced Package runtime dry-run plan.")
    if not preflight_ready:
        next_actions.append("Run the Advanced Package read-only preflight and resolve its audit findings.")
    if not authorization_ready:
        next_actions.append("Provide both --authorized and GAUSSDB_RUNTIME_PILOT_AUTHORIZED=true.")
    if not database_ready:
        next_actions.append("Set GAUSSDB_ENABLED=true and provide a valid database connection.")
    if allowed:
        next_actions.append("Proceed only with the authorized Advanced Package runtime pilot execution.")
    else:
        next_actions.append("Do not execute Advanced Package runtime pilot until all blockers are cleared.")

    return AdvancedPackageGateResultDef(
        static_evidence_valid=static_evidence_valid,
        runtime_plan_valid=runtime_plan_valid,
        preflight_plan_valid=preflight_state["plan_valid"],
        preflight_result_present=preflight_state["result_present"],
        preflight_result_valid=preflight_state["result_valid"],
        preflight_audit_present=preflight_state["audit_present"],
        preflight_audit_valid=preflight_state["audit_valid"],
        preflight_connected=preflight_state["connected"],
        preflight_metadata_read=preflight_state["metadata_read"],
        preflight_finding_count=preflight_state["finding_count"],
        preflight_ready=preflight_ready,
        runtime_receipt_present=runtime_receipt_present,
        runtime_receipt_audit_present=runtime_receipt_audit_present,
        static_ready=static_ready,
        runtime_plan_ready=runtime_plan_ready,
        technical_ready=technical_ready,
        authorization_requested=authorized_flag,
        authorization_environment_set=authorization_environment_set,
        authorization_ready=authorization_ready,
        database_enabled=database_enabled,
        database_ready=database_ready,
        ready_for_authorized_execution=(
            technical_ready and not runtime_receipt_present
        ),
        allowed=allowed,
        blockers=blockers,
        next_actions=next_actions,
    )


def json_load(path: Path):
    import json
    return json.loads(path.read_text(encoding="utf-8"))
