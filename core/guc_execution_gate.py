"""Fail-closed execution gate for GUC V2 runtime pilot.

The gate separates technical readiness, explicit authorization, and database
availability.  A valid static plan never authorizes execution by itself.
"""
from __future__ import annotations

from typing import List, Literal

from pydantic import BaseModel, ConfigDict, Field, model_validator

from core.guc_readiness import GucV2ReadinessResultDef


class StrictGucExecutionGateModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucV2ExecutionGateResultDef(StrictGucExecutionGateModel):
    kind: Literal["guc_v2_execution_gate"] = "guc_v2_execution_gate"
    schema_version: Literal[1] = 1
    static_ready: bool
    preflight_ready: bool
    runtime_plan_ready: bool
    technical_ready: bool
    authorization_requested: bool
    authorization_environment_set: bool
    authorization_ready: bool
    database_enabled: bool
    database_ready: bool
    allowed: bool
    blockers: List[str]
    next_actions: List[str]
    limits: List[str] = Field(default_factory=lambda: [
        "A valid dry-run plan does not authorize execution.",
        "A valid preflight does not authorize GUC changes.",
        "Runtime execution still requires explicit authorization and a database connection.",
        "Execution results require a separate receipt and independent audit.",
    ])

    @model_validator(mode="after")
    def ensure_gate_consistency(self) -> "GucV2ExecutionGateResultDef":
        expected_technical = (
            self.static_ready and self.preflight_ready and self.runtime_plan_ready
        )
        expected_authorization = (
            self.authorization_requested and self.authorization_environment_set
        )
        expected_database = self.database_enabled
        expected_allowed = (
            expected_technical and expected_authorization and expected_database
        )
        if self.technical_ready != expected_technical:
            raise ValueError("GUC V2 technical readiness is inconsistent")
        if self.authorization_ready != expected_authorization:
            raise ValueError("GUC V2 authorization readiness is inconsistent")
        if self.database_ready != expected_database:
            raise ValueError("GUC V2 database readiness is inconsistent")
        if self.allowed != expected_allowed:
            raise ValueError("GUC V2 execution gate decision is inconsistent")
        return self


def evaluate_guc_v2_execution_gate(
    readiness: GucV2ReadinessResultDef,
    *,
    authorized_flag: bool,
    authorization_environment_set: bool,
    database_enabled: bool,
) -> GucV2ExecutionGateResultDef:
    static_ready = (
        readiness.static_audit_valid
        and readiness.environment_v2_valid
        and readiness.overlay_plans_valid
        and readiness.preflight_plan_valid
    )
    preflight_ready = (
        readiness.preflight_result_present
        and readiness.preflight_result_valid
        and readiness.preflight_audit_valid
        and readiness.preflight_connected
        and readiness.preflight_metadata_read
        and readiness.summary.get("preflight_domain_mismatch_count") == 0
        and readiness.summary.get("preflight_error_count") == 0
    )
    runtime_plan_ready = readiness.runtime_plan_valid
    technical_ready = static_ready and preflight_ready and runtime_plan_ready
    authorization_ready = authorized_flag and authorization_environment_set
    database_ready = database_enabled
    allowed = technical_ready and authorization_ready and database_ready

    blockers: List[str] = []
    if not static_ready:
        blockers.append("GUC V2 static artifacts are not ready.")
    if not preflight_ready:
        blockers.append("GUC V2 preflight is not ready.")
    if not runtime_plan_ready:
        blockers.append("GUC V2 runtime pilot plan is not ready.")
    if not authorized_flag:
        blockers.append("Runtime execution authorization flag is missing.")
    if not authorization_environment_set:
        blockers.append("GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED is not set to true.")
    if not database_enabled:
        blockers.append("GAUSSDB_ENABLED is not true.")

    next_actions: List[str] = []
    if not static_ready:
        next_actions.append("Regenerate and audit GUC V2 static artifacts.")
    if not preflight_ready:
        next_actions.append("Run and validate the GUC V2 read-only preflight.")
    if not runtime_plan_ready:
        next_actions.append("Regenerate the GUC V2 runtime pilot dry-run plan.")
    if not authorization_ready:
        next_actions.append("Provide both --authorized and GAUSSDB_GUC_V2_RUNTIME_AUTHORIZED=true.")
    if not database_ready:
        next_actions.append("Set GAUSSDB_ENABLED=true and provide a valid database connection.")
    if allowed:
        next_actions.append("Proceed only with the authorized GUC V2 runtime pilot execution.")
    else:
        next_actions.append("Do not execute GUC V2 runtime pilot until all blockers are cleared.")

    return GucV2ExecutionGateResultDef(
        static_ready=static_ready,
        preflight_ready=preflight_ready,
        runtime_plan_ready=runtime_plan_ready,
        technical_ready=technical_ready,
        authorization_requested=authorized_flag,
        authorization_environment_set=authorization_environment_set,
        authorization_ready=authorization_ready,
        database_enabled=database_enabled,
        database_ready=database_ready,
        allowed=allowed,
        blockers=blockers,
        next_actions=next_actions,
    )
