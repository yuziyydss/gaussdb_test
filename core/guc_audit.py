"""Cross-layer static audit for the GUC V2 evidence chain.

The audit checks the local reference catalog, candidate matrix, environment
inventory, and overlay plan export.  It never connects to a database and never
claims runtime behavior verification.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any, Dict, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field

from core.guc_candidate import GucCandidateRegistry
from core.guc_capability import GucCapabilityRegistry
from core.guc_requirement_adapter import GucRequirementAdapterRegistry
from core.guc_environment import GucEnvironmentRegistry
from core.guc_plan_export import GucOverlayPlanExportRegistry, render_guc_overlay_plan_sql
from core.guc_preflight import GucV2PreflightRegistry
from core.guc_runtime_pilot import GucV2RuntimePilotRegistry
from core.guc_reference import GucReferenceRegistry


class StrictGucAuditModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucAuditLayerStatus(StrictGucAuditModel):
    path: str
    exists: bool
    valid: bool
    kind: Optional[str] = None
    sha256: Optional[str] = None
    size_bytes: Optional[int] = None
    summary: Dict[str, Any] = Field(default_factory=dict)


class GucAuditCheck(StrictGucAuditModel):
    name: str
    passed: bool
    detail: str


class GucV2AuditResult(StrictGucAuditModel):
    kind: Literal["guc_v2_audit"] = "guc_v2_audit"
    schema_version: Literal[1] = 1
    valid: bool
    layers: Dict[str, GucAuditLayerStatus]
    checks: List[GucAuditCheck]
    summary: Dict[str, Any]
    limits: List[str] = Field(default_factory=lambda: [
        "Static audit does not prove database behavior.",
        "A valid plan is not an execution receipt.",
        "Confirmed facts remain source-review evidence, not runtime evidence.",
        "GUC changes still require explicit database authorization.",
    ])


def _file_identity(path: Path) -> tuple[Optional[str], Optional[int]]:
    try:
        content = path.read_bytes()
    except OSError:
        return None, None
    return hashlib.sha256(content).hexdigest(), len(content)


def _layer(
    path: Path,
    *,
    valid: bool,
    kind: Optional[str],
    summary: Dict[str, Any],
) -> GucAuditLayerStatus:
    sha256, size_bytes = _file_identity(path)
    return GucAuditLayerStatus(
        path=str(path),
        exists=path.is_file(),
        valid=valid and path.is_file() and sha256 is not None,
        kind=kind,
        sha256=sha256,
        size_bytes=size_bytes,
        summary=summary,
    )


def _check(name: str, passed: bool, detail: str) -> GucAuditCheck:
    return GucAuditCheck(name=name, passed=passed, detail=detail)


def build_guc_v2_audit(root: Path) -> GucV2AuditResult:
    root = Path(root)

    reference_path = root / "generated/guc_reference_catalog/catalog.json"
    candidate_path = root / "generated/guc_candidate_matrix/matrix.json"
    environment_path = root / "environments/guc_parameters_v2.yaml"
    plans_path = root / "generated/guc_environment_v2/overlay_plans.json"
    plans_sql_path = root / "generated/guc_environment_v2/overlay_plans.sql"
    capability_path = root / "generated/guc_environment_v2/capability_matrix.json"
    requirement_adapter_path = root / "generated/guc_environment_v2/requirement_adapter.json"
    preflight_path = root / "generated/guc_environment_v2/preflight_plan.json"
    runtime_path = root / "generated/guc_environment_v2/runtime_dry_run.json"

    reference = GucReferenceRegistry(root).load()
    candidate = GucCandidateRegistry(root).load()
    environment_registry = GucEnvironmentRegistry(
        root,
        inventory_path=environment_path,
    )
    environment_registry.load_all()
    environment = environment_registry.environment
    plans = GucOverlayPlanExportRegistry(root).load()
    capabilities = GucCapabilityRegistry(root).load(capability_path)
    requirement_adapter = GucRequirementAdapterRegistry(root).load(requirement_adapter_path)
    preflight = GucV2PreflightRegistry(root).load()
    runtime = GucV2RuntimePilotRegistry(root).load(runtime_path)
    plan_sql = plans_sql_path.read_text(encoding="utf-8") if plans_sql_path.is_file() else ""

    reference_names = {item.name for item in reference.parameters}
    candidate_names = {item.name for item in candidate.parameters}
    environment_session_names = {
        item.name
        for item in environment.parameters
        if item.execution_policy == "session_overlay"
    }
    environment_manual_names = {
        item.name
        for item in environment.parameters
        if item.execution_policy == "manual_review"
    }
    environment_read_only_names = {
        item.name
        for item in environment.parameters
        if item.execution_policy == "read_only"
    }
    environment_blocked_names = {
        item.name
        for item in environment.parameters
        if item.execution_policy == "blocked"
    }
    plan_names = {item.parameter_name for item in plans.plans}
    next_batch_names = {item.name for item in candidate.next_batch}
    new_environment_names = {
        item.name
        for item in environment.parameters
        if item.category in {"data_import_export", "runtime_statistics"}
    }
    next_batch_session_names = next_batch_names & environment_session_names
    next_batch_manual_names = next_batch_names & environment_manual_names
    deferred_names = {item.name for item in candidate.deferred_unverified_facts}
    runtime_interface_ids = {
        interface_id
        for unit in runtime.units
        for interface_id in unit.interface_refs
    }
    capability_parameter_ids = {item.parameter_id for item in capabilities.capabilities}
    capability_requirement_keys = {
        item.requirement_key for item in capabilities.capabilities
    }
    adapter_requirement_keys = {
        item.requirement.key for item in requirement_adapter.requirements
    }
    adapter_blocked_names = {
        item.parameter_name for item in requirement_adapter.blocked
    }
    runtime_step_count = sum(len(unit.execution_plan) for unit in runtime.units)
    forbidden_operations = ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET ")

    checks = [
        _check(
            "reference_catalog_shape",
            reference.kind == "guc_reference_catalog"
            and reference.schema_version == 2
            and reference.summary.parameter_count == 1175
            and reference.summary.definition_count == 1177,
            "reference catalog must be V2 with 1,175 parameters and 1,177 occurrences",
        ),
        _check(
            "candidate_matrix_shape",
            candidate.kind == "guc_candidate_matrix"
            and candidate.schema_version == 1
            and candidate.summary.parameter_count == 1175
            and candidate.summary.occurrence_count == 1177,
            "candidate matrix must classify 1,175 parameters and 1,177 occurrences",
        ),
        _check(
            "environment_v2_shape",
            environment.kind == "guc_environment"
            and environment.schema_version == 2
            and len(environment.parameters) == 27,
            "environment V2 must contain 27 parameters",
        ),
        _check(
            "overlay_plan_export_shape",
            plans.kind == "guc_overlay_plan_export"
            and plans.schema_version == 1
            and plans.summary.exported_plan_count == 19
            and plans.summary.step_count == 95,
            "overlay plan export must contain 19 plans and 95 steps",
        ),
        _check(
            "reference_candidate_parameter_identity",
            reference_names == candidate_names
            and reference.summary.parameter_count == candidate.summary.parameter_count
            and reference.summary.definition_count == candidate.summary.occurrence_count,
            "reference and candidate matrix must use the same parameter identity set",
        ),
        _check(
            "candidate_source_binding",
            candidate.source.reference_catalog_relpath
            == "generated/guc_reference_catalog/catalog.json",
            "candidate matrix must bind to the GUC reference catalog",
        ),
        _check(
            "environment_source_binding",
            plans.source.relpath == "environments/guc_parameters_v2.yaml"
            and plans.environment_id == environment.id
            and plans.environment_schema_version == environment.schema_version,
            "overlay plans must bind to GUC Environment V2",
        ),
        _check(
            "next_batch_environment_alignment",
            next_batch_names == new_environment_names
            and len(next_batch_session_names) == 5
            and len(next_batch_manual_names) == 2,
            "all 7 next-batch candidates must appear in Environment V2 with 5 overlays and 2 manual reviews",
        ),
        _check(
            "session_overlay_plan_coverage",
            plan_names == environment_session_names
            and len(plan_names) == 19,
            "all 19 session-overlay parameters must have exactly one plan",
        ),
        _check(
            "excluded_policy_plan_isolation",
            not (plan_names & (environment_manual_names | environment_read_only_names | environment_blocked_names)),
            "manual_review, read_only, and blocked parameters must not appear in plans",
        ),
        _check(
            "plan_step_order",
            all(
                [step.action for step in plan.steps] == [
                    "capture_original", "apply", "verify_target", "restore", "verify_restore",
                ]
                for plan in plans.plans
            ),
            "every plan must use capture/apply/verify/restore/verify_restore order",
        ),
        _check(
            "plan_sql_forbidden_operations",
            all(operation not in plan_sql for operation in forbidden_operations),
            "plan SQL must not contain ALTER SYSTEM, ALTER DATABASE, ALTER ROLE, or RESET",
        ),
        _check(
            "plan_sql_render_identity",
            plan_sql == render_guc_overlay_plan_sql(plans),
            "generated SQL must match the deterministic renderer",
        ),
        _check(
            "capability_matrix_shape",
            capabilities.kind == "guc_capability_matrix"
            and capabilities.summary.capability_count == 19
            and capabilities.summary.runtime_fact_bound_count == 11
            and capabilities.summary.needs_runtime_fact_count == 8
            and capabilities.summary.plan_step_count == 95,
            "capability matrix must contain 19 capabilities, 11 fact-bound entries, 8 unbound entries, and 95 steps",
        ),
        _check(
            "capability_overlay_binding",
            capability_parameter_ids == {item.parameter_id for item in plans.plans},
            "capability matrix must bind one-to-one to overlay plan parameters",
        ),
        _check(
            "capability_requirement_keys",
            len(capability_requirement_keys) == len(capabilities.capabilities)
            and all(key.startswith("guc_") for key in capability_requirement_keys),
            "capability requirement keys must be unique and prefixed with guc_",
        ),
        _check(
            "requirement_adapter_shape",
            requirement_adapter.kind == "guc_requirement_adapter"
            and requirement_adapter.summary.capability_count == 19
            and requirement_adapter.summary.requirement_count == 9
            and requirement_adapter.summary.blocked_count == 10
            and requirement_adapter.summary.missing_fact_blocked_count == 8
            and requirement_adapter.summary.empty_value_blocked_count == 2,
            "requirement adapter must convert 9 capabilities and block 10 capabilities explicitly",
        ),
        _check(
            "requirement_adapter_capability_binding",
            adapter_requirement_keys <= capability_requirement_keys
            and not (adapter_requirement_keys & adapter_blocked_names),
            "requirement adapter must bind to capability keys without converting blocked capabilities",
        ),
        _check(
            "runtime_pilot_shape",
            runtime.profile == "runtime_guc_v2_pilot_v1"
            and len(runtime.units) == 19
            and runtime_step_count == 95
            and all(unit.kind == "guc_overlay" for unit in runtime.units),
            "runtime pilot must contain 19 GUC overlay units and 95 steps",
        ),
        _check(
            "runtime_pilot_overlay_binding",
            runtime_interface_ids == {item.parameter_id for item in plans.plans},
            "runtime pilot units must bind one-to-one to overlay plan parameters",
        ),
        _check(
            "runtime_pilot_step_order",
            all(
                [step.phase for step in unit.execution_plan] == [
                    "capture_original", "apply", "verify_target", "restore", "verify_restore",
                ]
                for unit in runtime.units
            ),
            "runtime pilot must preserve capture/apply/verify/restore/verify_restore order",
        ),
        _check(
            "preflight_plan_shape",
            preflight.kind == "guc_v2_preflight_plan"
            and preflight.environment_id == environment.id
            and preflight.summary.query_count == len(environment.parameters)
            and preflight.summary.read_only,
            "preflight plan must cover every Environment V2 parameter with read-only SQL",
        ),
        _check(
            "preflight_environment_binding",
            preflight.source.relpath == "environments/guc_parameters_v2.yaml"
            and preflight.environment_schema_version == environment.schema_version,
            "preflight plan must bind to GUC Environment V2",
        ),
        _check(
            "preflight_read_only_sql",
            all(
                query.sql.startswith("SELECT current_setting(")
                and not any(
                    operation in query.sql
                    for operation in ("SET ", "INSERT ", "UPDATE ", "DELETE ", "CREATE ", "DROP ", "ALTER ")
                )
                for query in preflight.queries
            ),
            "every preflight query must be a read-only current_setting SELECT",
        ),
        _check(
            "deferred_unverified_fact_isolation",
            deferred_names == {"td_compatible_truncation"}
            and not (deferred_names & next_batch_names),
            "needs_verification candidates must remain outside the next batch",
        ),
    ]

    summary: Dict[str, Any] = {
        "reference_parameter_count": reference.summary.parameter_count,
        "reference_occurrence_count": reference.summary.definition_count,
        "candidate_parameter_count": candidate.summary.parameter_count,
        "candidate_occurrence_count": candidate.summary.occurrence_count,
        "environment_parameter_count": len(environment.parameters),
        "session_overlay_count": len(environment_session_names),
        "manual_review_count": len(environment_manual_names),
        "read_only_count": len(environment_read_only_names),
        "blocked_count": len(environment_blocked_names),
        "next_batch_candidate_count": len(next_batch_names),
        "next_batch_session_overlay_count": len(next_batch_session_names),
        "next_batch_manual_review_count": len(next_batch_manual_names),
        "deferred_unverified_candidate_count": len(deferred_names),
        "exported_plan_count": len(plans.plans),
        "exported_step_count": plans.summary.step_count,
        "preflight_query_count": preflight.summary.query_count,
        "runtime_unit_count": len(runtime.units),
        "runtime_step_count": runtime_step_count,
        "capability_count": capabilities.summary.capability_count,
        "capability_runtime_fact_bound_count": capabilities.summary.runtime_fact_bound_count,
        "capability_needs_runtime_fact_count": capabilities.summary.needs_runtime_fact_count,
        "capability_plan_step_count": capabilities.summary.plan_step_count,
        "requirement_adapter_count": requirement_adapter.summary.requirement_count,
        "requirement_adapter_blocked_count": requirement_adapter.summary.blocked_count,
        "requirement_adapter_missing_fact_count": requirement_adapter.summary.missing_fact_blocked_count,
        "requirement_adapter_empty_value_count": requirement_adapter.summary.empty_value_blocked_count,
        "next_batch_environment_names": sorted(next_batch_names),
        "next_batch_session_overlay_names": sorted(next_batch_session_names),
        "next_batch_manual_review_names": sorted(next_batch_manual_names),
        "deferred_unverified_names": sorted(deferred_names),
    }

    layers = {
        "reference_catalog": _layer(
            reference_path,
            valid=reference.kind == "guc_reference_catalog",
            kind=reference.kind,
            summary={
                "parameter_count": reference.summary.parameter_count,
                "occurrence_count": reference.summary.definition_count,
                "pilot_parameter_count": reference.summary.pilot_parameter_count,
            },
        ),
        "candidate_matrix": _layer(
            candidate_path,
            valid=candidate.kind == "guc_candidate_matrix",
            kind=candidate.kind,
            summary={
                "parameter_count": candidate.summary.parameter_count,
                "occurrence_count": candidate.summary.occurrence_count,
                "next_batch_count": candidate.summary.next_batch_count,
                "boolean_session_candidate_count": candidate.summary.boolean_session_candidate_count,
            },
        ),
        "environment_v2": _layer(
            environment_path,
            valid=environment.kind == "guc_environment",
            kind=environment.kind,
            summary={
                "parameter_count": len(environment.parameters),
                "session_overlay_count": len(environment_session_names),
                "manual_review_count": len(environment_manual_names),
                "read_only_count": len(environment_read_only_names),
                "blocked_count": len(environment_blocked_names),
            },
        ),
        "overlay_plans": _layer(
            plans_path,
            valid=plans.kind == "guc_overlay_plan_export",
            kind=plans.kind,
            summary={
                "plan_count": plans.summary.exported_plan_count,
                "step_count": plans.summary.step_count,
                "excluded_parameter_count": plans.summary.excluded_parameter_count,
            },
        ),
        "capability_matrix": _layer(
            capability_path,
            valid=capabilities.kind == "guc_capability_matrix",
            kind=capabilities.kind,
            summary={
                "capability_count": capabilities.summary.capability_count,
                "runtime_fact_bound_count": capabilities.summary.runtime_fact_bound_count,
                "needs_runtime_fact_count": capabilities.summary.needs_runtime_fact_count,
                "plan_step_count": capabilities.summary.plan_step_count,
            },
        ),
        "requirement_adapter": _layer(
            requirement_adapter_path,
            valid=requirement_adapter.kind == "guc_requirement_adapter",
            kind=requirement_adapter.kind,
            summary={
                "requirement_count": requirement_adapter.summary.requirement_count,
                "blocked_count": requirement_adapter.summary.blocked_count,
                "missing_fact_blocked_count": requirement_adapter.summary.missing_fact_blocked_count,
                "empty_value_blocked_count": requirement_adapter.summary.empty_value_blocked_count,
            },
        ),
        "runtime_pilot": _layer(
            runtime_path,
            valid=runtime.profile == "runtime_guc_v2_pilot_v1",
            kind=runtime.kind,
            summary={
                "profile": runtime.profile,
                "unit_count": len(runtime.units),
                "step_count": runtime_step_count,
            },
        ),
        "preflight_plan": _layer(
            preflight_path,
            valid=preflight.kind == "guc_v2_preflight_plan",
            kind=preflight.kind,
            summary={
                "query_count": preflight.summary.query_count,
                "read_only": preflight.summary.read_only,
            },
        ),
        "overlay_plans_sql": _layer(
            plans_sql_path,
            valid=bool(plan_sql) and plan_sql == render_guc_overlay_plan_sql(plans),
            kind="guc_overlay_plan_sql",
            summary={
                "line_count": len(plan_sql.splitlines()),
                "set_count": plan_sql.count("SET "),
                "forbidden_operation_count": sum(
                    plan_sql.count(operation) for operation in forbidden_operations
                ),
            },
        ),
    }

    return GucV2AuditResult(
        valid=all(check.passed for check in checks) and all(layer.valid for layer in layers.values()),
        layers=layers,
        checks=checks,
        summary=summary,
    )
