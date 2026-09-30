"""Aggregate GUC V2 static readiness, preflight state, and authorization gates.

This module deliberately separates three claims:

1. Static artifacts are structurally valid.
2. A read-only database preflight has succeeded.
3. Runtime execution is authorized and verified.

Only the third claim can be made by a separate execution receipt.
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, model_validator

from core.guc_audit import build_guc_v2_audit
from core.guc_environment import GucEnvironmentRegistry
from core.guc_plan_export import GucOverlayPlanExportRegistry
from core.guc_preflight import GucV2PreflightRegistry, GucV2PreflightResultDef
from core.guc_preflight_audit import GucV2PreflightAuditResultDef
from core.guc_runtime_pilot import GucV2RuntimePilotRegistry


class StrictGucReadinessModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucV2ReadinessResultDef(StrictGucReadinessModel):
    kind: Literal["guc_v2_readiness"] = "guc_v2_readiness"
    schema_version: Literal[1] = 1
    static_audit_valid: bool
    environment_v2_valid: bool
    overlay_plans_valid: bool
    runtime_plan_valid: bool
    preflight_plan_valid: bool
    preflight_result_present: bool
    preflight_result_valid: bool
    preflight_audit_valid: bool
    preflight_connected: bool
    preflight_metadata_read: bool
    ready_for_authorized_execution: bool
    execution_authorized: bool = False
    runtime_verified: bool = False
    blockers: List[str]
    next_actions: List[str]
    summary: Dict[str, Any]
    limits: List[str] = Field(default_factory=lambda: [
        "Static readiness does not prove database behavior.",
        "A valid preflight result does not authorize GUC changes.",
        "Runtime execution requires explicit authorization and a separate receipt.",
        "A missing execution receipt means runtime behavior is not verified.",
    ])

    @model_validator(mode="after")
    def ensure_honest_claims(self) -> "GucV2ReadinessResultDef":
        if self.execution_authorized or self.runtime_verified:
            raise ValueError("GUC V2 readiness cannot claim authorization or runtime verification")
        if self.ready_for_authorized_execution and not (
            self.static_audit_valid
            and self.environment_v2_valid
            and self.overlay_plans_valid
            and self.runtime_plan_valid
            and self.preflight_plan_valid
            and self.preflight_result_present
            and self.preflight_result_valid
            and self.preflight_audit_valid
            and self.preflight_connected
            and self.preflight_metadata_read
        ):
            raise ValueError("GUC V2 ready_for_authorized_execution is inconsistent")
        if self.ready_for_authorized_execution and (
            self.summary.get("preflight_domain_mismatch_count") not in (None, 0)
            or self.summary.get("preflight_error_count") not in (None, 0)
        ):
            raise ValueError("GUC V2 ready_for_authorized_execution cannot have preflight findings")
        return self


class GucV2ReadinessRegistry:
    """Build and persist the GUC V2 readiness report."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.output_path = self.root / "generated/guc_environment_v2/readiness.json"

    def build(self) -> GucV2ReadinessResultDef:
        return build_guc_v2_readiness(self.root)

    def write(self) -> Path:
        readiness = self.build()
        self.output_path.parent.mkdir(parents=True, exist_ok=True)
        self.output_path.write_text(
            json.dumps(readiness.model_dump(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return self.output_path


def _load_json(path: Path) -> Optional[dict]:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return None


def build_guc_v2_readiness(root: Path) -> GucV2ReadinessResultDef:
    root = Path(root)

    static_audit_valid = False
    static_audit_check_count = 0
    try:
        audit = build_guc_v2_audit(root)
        static_audit_valid = audit.valid
        static_audit_check_count = len(audit.checks)
    except Exception:
        static_audit_valid = False

    environment_v2_valid = False
    environment_parameter_count = 0
    try:
        registry = GucEnvironmentRegistry(
            root,
            inventory_path=root / "environments/guc_parameters_v2.yaml",
        )
        registry.load_all()
        environment_v2_valid = True
        environment_parameter_count = len(registry.parameters)
    except Exception:
        environment_v2_valid = False

    overlay_plans_valid = False
    overlay_plan_count = 0
    overlay_step_count = 0
    try:
        plans = GucOverlayPlanExportRegistry(root).load()
        overlay_plans_valid = True
        overlay_plan_count = plans.summary.exported_plan_count
        overlay_step_count = plans.summary.step_count
    except Exception:
        overlay_plans_valid = False

    runtime_plan_valid = False
    runtime_unit_count = 0
    runtime_step_count = 0
    try:
        runtime_plan = GucV2RuntimePilotRegistry(root).load(
            root / "generated/guc_environment_v2/runtime_dry_run.json"
        )
        runtime_plan_valid = True
        runtime_unit_count = len(runtime_plan.units)
        runtime_step_count = sum(len(unit.execution_plan) for unit in runtime_plan.units)
    except Exception:
        runtime_plan_valid = False

    preflight_plan_valid = False
    preflight_query_count = 0
    try:
        preflight_plan = GucV2PreflightRegistry(root).load()
        preflight_plan_valid = True
        preflight_query_count = preflight_plan.summary.query_count
    except Exception:
        preflight_plan_valid = False

    preflight_result_path = root / "generated/guc_environment_v2/preflight_result.json"
    preflight_audit_path = root / "generated/guc_environment_v2/preflight_audit.json"
    preflight_result_present = preflight_result_path.is_file()
    preflight_audit_valid = False
    preflight_result_valid = False
    preflight_connected = False
    preflight_metadata_read = False
    preflight_domain_mismatch_count: Optional[int] = None
    preflight_error_count: Optional[int] = None
    if preflight_result_present:
        raw = _load_json(preflight_result_path)
        if raw is not None:
            try:
                result = GucV2PreflightResultDef(**raw)
                preflight_result_valid = True
                preflight_connected = result.connected
                preflight_metadata_read = result.metadata_read
                preflight_domain_mismatch_count = result.summary.domain_mismatch_count
                preflight_error_count = result.summary.error_count
            except Exception:
                preflight_result_valid = False

    if preflight_result_present and preflight_audit_path.is_file():
        raw_audit = _load_json(preflight_audit_path)
        if raw_audit is not None:
            try:
                preflight_audit = GucV2PreflightAuditResultDef(**raw_audit)
                preflight_audit_valid = (
                    preflight_audit.valid and preflight_audit.plan_verified
                )
            except Exception:
                preflight_audit_valid = False

    ready_for_authorized_execution = all([
        static_audit_valid,
        environment_v2_valid,
        overlay_plans_valid,
        runtime_plan_valid,
        preflight_plan_valid,
        preflight_result_present,
        preflight_result_valid,
        preflight_audit_valid,
        preflight_connected,
        preflight_metadata_read,
        preflight_domain_mismatch_count == 0,
        preflight_error_count == 0,
    ])

    blockers: List[str] = []
    if not static_audit_valid:
        blockers.append("GUC V2 static audit is missing or invalid.")
    if not environment_v2_valid:
        blockers.append("GUC Environment V2 is missing or invalid.")
    if not overlay_plans_valid:
        blockers.append("GUC V2 overlay plans are missing or invalid.")
    if not runtime_plan_valid:
        blockers.append("GUC V2 runtime pilot plan is missing or invalid.")
    if not preflight_plan_valid:
        blockers.append("GUC V2 preflight plan is missing or invalid.")
    if not preflight_result_present:
        blockers.append("GUC V2 preflight result is missing.")
    elif not preflight_result_valid:
        blockers.append("GUC V2 preflight result is invalid.")
    elif not preflight_audit_valid:
        blockers.append("GUC V2 preflight result audit is missing or invalid.")
    elif not preflight_connected:
        blockers.append("GUC V2 preflight did not connect to the database.")
    elif not preflight_metadata_read:
        blockers.append("GUC V2 preflight did not read all metadata.")
    elif preflight_domain_mismatch_count not in (None, 0):
        blockers.append("GUC V2 preflight found declared-domain mismatches.")
    elif preflight_error_count not in (None, 0):
        blockers.append("GUC V2 preflight reported query errors.")
    blockers.append("Runtime execution is not authorized.")

    next_actions: List[str] = []
    if not static_audit_valid:
        next_actions.append("Regenerate and audit the GUC V2 static artifacts.")
    if not environment_v2_valid:
        next_actions.append("Repair or regenerate GUC Environment V2.")
    if not overlay_plans_valid:
        next_actions.append("Regenerate the GUC V2 overlay plan export.")
    if not runtime_plan_valid:
        next_actions.append("Regenerate the GUC V2 runtime pilot dry-run plan.")
    if not preflight_plan_valid:
        next_actions.append("Regenerate the GUC V2 read-only preflight plan.")
    if not preflight_result_present:
        next_actions.append("Run the GUC V2 read-only preflight against the target database.")
    elif not preflight_result_valid:
        next_actions.append("Regenerate the GUC V2 preflight result.")
    elif not preflight_audit_valid:
        next_actions.append("Audit the GUC V2 preflight result against its plan.")
    elif not preflight_connected or not preflight_metadata_read:
        next_actions.append("Resolve GUC V2 preflight connection or metadata-read failures.")
    elif preflight_domain_mismatch_count not in (None, 0):
        next_actions.append("Review GUC V2 preflight domain mismatches before execution.")
    if ready_for_authorized_execution:
        next_actions.append("Authorize GUC V2 execution only after reviewing all blockers and limits.")
    else:
        next_actions.append("Do not authorize GUC V2 execution until static and preflight blockers are cleared.")

    summary: Dict[str, Any] = {
        "environment_parameter_count": environment_parameter_count,
        "overlay_plan_count": overlay_plan_count,
        "overlay_step_count": overlay_step_count,
        "runtime_unit_count": runtime_unit_count,
        "runtime_step_count": runtime_step_count,
        "preflight_query_count": preflight_query_count,
        "static_audit_check_count": static_audit_check_count,
        "preflight_domain_mismatch_count": preflight_domain_mismatch_count,
        "preflight_error_count": preflight_error_count,
        "preflight_audit_valid": preflight_audit_valid,
    }

    return GucV2ReadinessResultDef(
        static_audit_valid=static_audit_valid,
        environment_v2_valid=environment_v2_valid,
        overlay_plans_valid=overlay_plans_valid,
        runtime_plan_valid=runtime_plan_valid,
        preflight_plan_valid=preflight_plan_valid,
        preflight_result_present=preflight_result_present,
        preflight_result_valid=preflight_result_valid,
        preflight_audit_valid=preflight_audit_valid,
        preflight_connected=preflight_connected,
        preflight_metadata_read=preflight_metadata_read,
        ready_for_authorized_execution=ready_for_authorized_execution,
        execution_authorized=False,
        runtime_verified=False,
        blockers=blockers,
        next_actions=next_actions,
        summary=summary,
    )
