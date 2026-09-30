"""Strict audit for GUC V2 read-only preflight results.

A preflight result is not trusted merely because it reports ``metadata_read``.
This audit checks schema, plan identity, query identity, SQL identity, counts,
state-change boundaries, and summary consistency.
"""
from __future__ import annotations

from typing import Any, Dict, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field

from core.guc_preflight import GucV2PreflightPlanDef, GucV2PreflightResultDef


class StrictGucPreflightAuditModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucV2PreflightAuditSummaryDef(StrictGucPreflightAuditModel):
    query_count: int
    success_count: int
    error_count: int
    domain_mismatch_count: int
    metadata_read: bool
    connected: bool


class GucV2PreflightAuditResultDef(StrictGucPreflightAuditModel):
    kind: Literal["guc_v2_preflight_audit"] = "guc_v2_preflight_audit"
    schema_version: Literal[1] = 1
    valid: bool
    errors: List[str] = Field(default_factory=list)
    summary: GucV2PreflightAuditSummaryDef
    plan_verified: bool = False
    limits: List[str] = Field(default_factory=lambda: [
        "A valid preflight proves only that the recorded read-only queries succeeded.",
        "A valid preflight does not authorize GUC changes or target SQL execution.",
        "A domain mismatch is a finding, not a database execution failure.",
        "Runtime behavior still requires a separate authorized execution receipt.",
    ])


def _raw_boundary_errors(raw: Any) -> List[str]:
    errors: List[str] = []
    if not isinstance(raw, dict):
        return errors
    if raw.get("target_sql_executed"):
        errors.append("preflight cannot execute target SQL")
    if raw.get("guc_changed"):
        errors.append("preflight cannot change GUC state")
    if raw.get("object_created"):
        errors.append("preflight cannot create objects")
    return errors


def _raw_summary_errors(raw: Any) -> List[str]:
    if not isinstance(raw, dict):
        return []
    queries = raw.get("queries", [])
    if not isinstance(queries, list):
        return []
    success_count = sum(
        isinstance(item, dict) and item.get("status") == "success"
        for item in queries
    )
    error_count = sum(
        isinstance(item, dict) and item.get("status") == "error"
        for item in queries
    )
    mismatch_count = sum(
        isinstance(item, dict)
        and item.get("status") == "success"
        and not item.get("in_declared_domain", False)
        for item in queries
    )
    summary = raw.get("summary", {})
    if not isinstance(summary, dict):
        return ["summary is not an object"]
    errors: List[str] = []
    if summary.get("query_count") != len(queries):
        errors.append("summary query_count mismatch")
    if summary.get("success_count") != success_count:
        errors.append("summary success_count mismatch")
    if summary.get("error_count") != error_count:
        errors.append("summary error_count mismatch")
    if summary.get("domain_mismatch_count") != mismatch_count:
        errors.append("summary domain_mismatch_count mismatch")
    return errors


def audit_guc_v2_preflight_result(
    result: Any,
    *,
    plan: Optional[GucV2PreflightPlanDef] = None,
) -> GucV2PreflightAuditResultDef:
    errors: List[str] = []
    plan_verified = False

    if isinstance(result, GucV2PreflightResultDef):
        parsed = result
    else:
        try:
            parsed = GucV2PreflightResultDef(**result)
        except Exception as exc:
            boundary_errors = _raw_boundary_errors(result)
            summary_errors = _raw_summary_errors(result)
            errors = boundary_errors + summary_errors
            if not errors:
                errors = [f"preflight result schema validation failed: {exc}"]
            return GucV2PreflightAuditResultDef(
                valid=False,
                errors=errors,
                summary=GucV2PreflightAuditSummaryDef(
                    query_count=0,
                    success_count=0,
                    error_count=0,
                    domain_mismatch_count=0,
                    metadata_read=False,
                    connected=False,
                ),
            )

    if parsed.target_sql_executed:
        errors.append("preflight cannot execute target SQL")
    if parsed.guc_changed:
        errors.append("preflight cannot change GUC state")
    if parsed.object_created:
        errors.append("preflight cannot create objects")

    success_count = sum(item.status == "success" for item in parsed.queries)
    error_count = sum(item.status == "error" for item in parsed.queries)
    mismatch_count = sum(
        item.status == "success" and not item.in_declared_domain
        for item in parsed.queries
    )
    expected_summary = GucV2PreflightAuditSummaryDef(
        query_count=len(parsed.queries),
        success_count=success_count,
        error_count=error_count,
        domain_mismatch_count=mismatch_count,
        metadata_read=parsed.metadata_read,
        connected=parsed.connected,
    )
    if parsed.summary.query_count != expected_summary.query_count:
        errors.append("summary query_count mismatch")
    if parsed.summary.success_count != expected_summary.success_count:
        errors.append("summary success_count mismatch")
    if parsed.summary.error_count != expected_summary.error_count:
        errors.append("summary error_count mismatch")
    if parsed.summary.domain_mismatch_count != expected_summary.domain_mismatch_count:
        errors.append("summary domain_mismatch_count mismatch")
    if parsed.metadata_read != (success_count == len(parsed.queries) and bool(parsed.queries)):
        errors.append("metadata_read is inconsistent with query results")
    if parsed.connected != (success_count > 0):
        errors.append("connected is inconsistent with query results")
    if len(parsed.errors) != error_count:
        errors.append("errors list does not match error_count")

    if plan is None:
        errors.append("plan not supplied; plan identity could not be verified")
    else:
        if parsed.environment_id != plan.environment_id:
            errors.append("environment id mismatch")
        if len(parsed.queries) != len(plan.queries):
            errors.append("query count does not match plan")
        else:
            for index, (result_query, plan_query) in enumerate(
                zip(parsed.queries, plan.queries)
            ):
                if (
                    result_query.parameter_id != plan_query.parameter_id
                    or result_query.parameter_name != plan_query.parameter_name
                ):
                    errors.append(f"query identity mismatch at index {index}")
                    break
                if result_query.sql != plan_query.sql:
                    errors.append(f"query SQL mismatch at index {index}")
                    break
        if not errors:
            plan_verified = True

    return GucV2PreflightAuditResultDef(
        valid=not errors,
        errors=errors,
        summary=expected_summary,
        plan_verified=plan_verified,
    )
