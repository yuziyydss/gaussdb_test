"""Static runtime preflight plan for the authorized Advanced Package pilot.

The plan maps every advanced-package runtime unit to read-only preflight
checks, permissions, fixture expectations, execution boundaries and cleanup.
It never opens a connection, executes SQL, or creates runtime evidence.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Dict, List, Literal, Optional

import yaml
from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.advanced_package_policy_audit import build_advanced_package_policy_audit
from core.runtime_validation_pilot import build_dry_run, plan_sha256


class StrictAdvancedPreflightModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class AdvancedPreflightSourceDef(StrictAdvancedPreflightModel):
    interface_inventory_relpath: str
    interface_inventory_sha256: str
    policy_audit_relpath: str
    policy_audit_sha256: str
    runtime_plan_sha256: str
    runtime_plan_unit_count: int
    advanced_unit_count: int

    @field_validator("interface_inventory_relpath", "policy_audit_relpath")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("advanced preflight source path must be safe")
        return value

    @field_validator("interface_inventory_sha256", "policy_audit_sha256", "runtime_plan_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r"[0-9a-f]{64}", value) is None:
            raise ValueError("advanced preflight source SHA-256 must be 64 hex characters")
        return value


class AdvancedPreflightQueryDef(StrictAdvancedPreflightModel):
    key: str
    sql: str
    purpose: str
    validation_rule: str

    @field_validator("key")
    @classmethod
    def ensure_key(cls, value: str) -> str:
        if not re.fullmatch(r"[a-z][a-z0-9_]*", value):
            raise ValueError("advanced preflight query key must be snake_case")
        return value

    @model_validator(mode="after")
    def ensure_read_only_query(self) -> "AdvancedPreflightQueryDef":
        normalized = " ".join(self.sql.strip().split()).upper()
        if not normalized.startswith("SELECT ") or normalized not in ("SELECT",) and not normalized.endswith(";"):
            raise ValueError(f"advanced preflight query {self.key} must be a SELECT statement ending with ;")
        forbidden = ("INSERT ", "UPDATE ", "DELETE ", "CREATE ", "ALTER ", "DROP ", "TRUNCATE ", "SET ", "RESET ", "CALL ", "GRANT ", "REVOKE ")
        if any(word in f" {normalized} " for word in forbidden):
            raise ValueError(f"advanced preflight query {self.key} must be read-only")
        if not self.purpose or not self.validation_rule:
            raise ValueError(f"advanced preflight query {self.key} needs purpose and validation rule")
        return self


class AdvancedPackageCasePreflightDef(StrictAdvancedPreflightModel):
    unit_id: str
    package_ref: str
    execution_class: Literal[
        "session_buffer_lifecycle",
        "pure_function_value",
        "dynamic_sql_context",
        "xml_document_lifecycle",
        "xml_parser_lifecycle",
        "statistics_history_read",
    ]
    risk_tier: Literal["low", "medium"]
    global_query_keys: List[str]
    interface_count: int
    permissions: List[str]
    fixture_requirements: List[str]
    execution_boundaries: List[str]
    cleanup_requirements: List[str]
    notes: str

    @model_validator(mode="after")
    def ensure_case_shape(self) -> "AdvancedPackageCasePreflightDef":
        if not self.unit_id or not self.unit_id.replace("_", "").isalnum():
            raise ValueError("advanced preflight unit_id must be a safe identifier")
        if not self.global_query_keys:
            raise ValueError(f"advanced preflight case {self.unit_id} needs global queries")
        if self.interface_count < 1:
            raise ValueError(f"advanced preflight case {self.unit_id} must reference interfaces")
        required_lists = {
            "permissions": self.permissions,
            "fixture_requirements": self.fixture_requirements,
            "execution_boundaries": self.execution_boundaries,
            "cleanup_requirements": self.cleanup_requirements,
        }
        if any(not value for value in required_lists.values()):
            raise ValueError(f"advanced preflight case {self.unit_id} needs complete preflight contract")
        return self


class AdvancedPreflightSummaryDef(StrictAdvancedPreflightModel):
    runtime_plan_unit_count: int
    guc_overlay_unit_count: int
    advanced_case_count: int
    advanced_interface_reference_count: int
    global_query_count: int
    preflight_case_count: int
    low_risk_case_count: int
    medium_risk_case_count: int
    expansion_runtime_candidate_count: int
    covered_expansion_runtime_candidate_count: int
    coverage_complete: bool

    @model_validator(mode="after")
    def ensure_summary_shape(self) -> "AdvancedPreflightSummaryDef":
        if self.guc_overlay_unit_count + self.advanced_case_count != self.runtime_plan_unit_count:
            raise ValueError("advanced preflight runtime unit counts are inconsistent")
        if self.preflight_case_count != self.advanced_case_count:
            raise ValueError("advanced preflight case coverage is inconsistent")
        if self.low_risk_case_count + self.medium_risk_case_count != self.advanced_case_count:
            raise ValueError("advanced preflight risk counts are inconsistent")
        if self.coverage_complete != (
            self.preflight_case_count == self.advanced_case_count
            and self.covered_expansion_runtime_candidate_count == self.expansion_runtime_candidate_count
        ):
            raise ValueError("advanced preflight coverage_complete is inconsistent")
        return self


class AdvancedRuntimePreflightPlanDef(StrictAdvancedPreflightModel):
    schema_version: int = 1
    kind: str = "advanced_package_runtime_preflight_plan"
    id: str = "advanced_package_runtime_preflight_plan_v1"
    name: str = "Advanced Package Runtime Preflight Plan"
    description: str = (
        "27个高级包runtime case的只读前置检查、权限、fixture、边界与清理计划；不执行SQL，不生成receipt。"
    )
    source: AdvancedPreflightSourceDef
    global_queries: List[AdvancedPreflightQueryDef]
    case_plans: List[AdvancedPackageCasePreflightDef]
    summary: AdvancedPreflightSummaryDef
    next_actions: List[str] = Field(default_factory=lambda: [
        "Run the read-only preflight queries against the authorized target database.",
        "Confirm A-compatibility, encoding, ownership and package permissions before execution.",
        "Capture one success/failure receipt per step, including XML cleanup evidence.",
        "Keep ILM and file-writing interfaces out of the first authorized runtime batch.",
    ])
    limits: List[str] = Field(default_factory=lambda: [
        "This plan is static and does not connect to GaussDB.",
        "A planned preflight query is not a preflight result.",
        "A preflight result does not prove advanced package behavior.",
        "Runtime evidence still requires receipts and independent audit.",
    ])

    @model_validator(mode="after")
    def ensure_plan_shape(self) -> "AdvancedRuntimePreflightPlanDef":
        unit_ids = [item.unit_id for item in self.case_plans]
        if len(unit_ids) != len(set(unit_ids)):
            raise ValueError("advanced preflight unit ids cannot repeat")
        if len(unit_ids) != self.summary.advanced_case_count:
            raise ValueError("advanced preflight case count is inconsistent")
        query_keys = [item.key for item in self.global_queries]
        if len(query_keys) != len(set(query_keys)):
            raise ValueError("advanced preflight global query keys cannot repeat")
        for item in self.case_plans:
            missing = sorted(set(item.global_query_keys) - set(query_keys))
            if missing:
                raise ValueError(f"advanced preflight case {item.unit_id} references unknown queries: {missing}")
        if self.summary.global_query_count != len(self.global_queries):
            raise ValueError("advanced preflight global query count is inconsistent")
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _load_yaml(path: Path) -> dict:
    value = yaml.safe_load(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"{path}: top-level YAML must be an object")
    return value


def _package_contract(package_ref: str) -> dict:
    contracts: Dict[str, dict] = {
        "dbe_output": {
            "execution_class": "session_buffer_lifecycle",
            "risk_tier": "low",
            "permissions": ["EXECUTE privilege on DBE_OUTPUT package functions/procedures."],
            "fixture_requirements": ["No persistent object fixture is required."],
            "execution_boundaries": [
                "Output is session-local and depends on database notice capture.",
                "Do not change global GUC values or server configuration.",
            ],
            "cleanup_requirements": ["Restore or close buffer state as expressed by the case SQL."],
        },
        "dbe_raw": {
            "execution_class": "pure_function_value",
            "risk_tier": "low",
            "permissions": ["EXECUTE privilege on DBE_RAW package functions."],
            "fixture_requirements": ["No persistent object fixture is required."],
            "execution_boundaries": ["Use explicit endianness and compare only the documented conversion domain."],
            "cleanup_requirements": ["No persistent object cleanup is required."],
        },
        "dbe_sql": {
            "execution_class": "dynamic_sql_context",
            "risk_tier": "medium",
            "permissions": ["EXECUTE privilege on DBE_SQL package functions."],
            "fixture_requirements": ["The dynamic SQL must reference only objects visible to the authorized runtime user."],
            "execution_boundaries": [
                "Dynamic SQL must remain a small read-only SELECT owned by the runtime plan.",
                "Normal and exception paths must close the registered context.",
            ],
            "cleanup_requirements": ["Call DBE_SQL.SQL_UNREGISTER_CONTEXT on normal and exception paths."],
        },
        "dbe_xmldom": {
            "execution_class": "xml_document_lifecycle",
            "risk_tier": "medium",
            "permissions": ["EXECUTE privilege on DBE_XMLDOM package functions/procedures."],
            "fixture_requirements": [
                "No persistent database object is required.",
                "Use ASCII-safe XML in an SQL_ASCII database; otherwise UTF-8-safe samples are acceptable.",
            ],
            "execution_boundaries": [
                "Confirm sql_compatibility=A and supported encoding before execution.",
                "Do not invoke file-writing overloads in this batch.",
            ],
            "cleanup_requirements": [
                "Free every DOMDOCUMENT, element, node, list and text resource on normal and exception paths.",
                "Capture cleanup evidence with the runtime receipt.",
            ],
        },
        "dbe_xmlparser": {
            "execution_class": "xml_parser_lifecycle",
            "risk_tier": "medium",
            "permissions": ["EXECUTE privilege on DBE_XMLPARSER and DBE_XMLDOM resources."],
            "fixture_requirements": ["Use a small UTF-8-safe XML buffer and avoid external DTD fetches."],
            "execution_boundaries": [
                "Confirm sql_compatibility=A before execution.",
                "Parser validation behavior must not be inferred without a captured notice or receipt.",
            ],
            "cleanup_requirements": ["FREEPARSER and FREEDOCUMENT must execute on normal and exception paths."],
        },
        "dbe_stats": {
            "execution_class": "statistics_history_read",
            "risk_tier": "low",
            "permissions": [
                "EXECUTE privilege on DBE_STATS history functions.",
                "MONADMIN or equivalent permission required by the documented statistics-history functions.",
            ],
            "fixture_requirements": [
                "Statistics history may be empty; empty/null output does not imply runtime verification.",
                "Do not run ANALYZE, purge, restore or import/export as part of this preflight.",
            ],
            "execution_boundaries": ["Use only the two read-only history functions in the authorized batch."],
            "cleanup_requirements": ["No persistent object cleanup is required."],
        },
    }
    if package_ref not in contracts:
        raise ValueError(f"advanced preflight has no contract for package {package_ref}")
    return contracts[package_ref]


def build_advanced_package_runtime_preflight(root: Path) -> AdvancedRuntimePreflightPlanDef:
    root = Path(root)
    inventory_path = root / "environments/advanced_packages_v1.yaml"
    policy_manifest_path = root / "environments/advanced_package_policy_audit_v1.yaml"

    policy_audit = build_advanced_package_policy_audit(root)
    plan = build_dry_run(root)
    runtime_units = [unit for unit in plan.units if unit.kind == "advanced_package"]
    guc_units = [unit for unit in plan.units if unit.kind == "guc_overlay"]
    policy_decisions = {item.interface_id: item for item in policy_audit.decisions}
    expansion_runtime_ids = {
        interface_id for interface_id, decision in policy_decisions.items()
        if decision.recommended_policy == "runtime_candidate"
    }

    global_queries = [
        AdvancedPreflightQueryDef(
            key="server_version",
            sql="SELECT version() AS value;",
            purpose="Confirm database identity and version.",
            validation_rule="value must be non-empty and recorded in the receipt.",
        ),
        AdvancedPreflightQueryDef(
            key="current_database",
            sql="SELECT current_database() AS value;",
            purpose="Identify the target database.",
            validation_rule="value must match the authorized runtime target.",
        ),
        AdvancedPreflightQueryDef(
            key="current_user",
            sql="SELECT current_user AS value;",
            purpose="Identify the executing role.",
            validation_rule="value must match the authorized runtime role.",
        ),
        AdvancedPreflightQueryDef(
            key="sql_compatibility",
            sql="SELECT current_setting('sql_compatibility', true) AS value;",
            purpose="Confirm XML package compatibility mode.",
            validation_rule="value must be A for XML document and parser cases.",
        ),
        AdvancedPreflightQueryDef(
            key="server_encoding",
            sql="SELECT current_setting('server_encoding', true) AS value;",
            purpose="Confirm XML input encoding boundary.",
            validation_rule="If SQL_ASCII, XML samples must remain ASCII-safe.",
        ),
        AdvancedPreflightQueryDef(
            key="client_encoding",
            sql="SELECT current_setting('client_encoding', true) AS value;",
            purpose="Confirm client/server XML encoding consistency.",
            validation_rule="value must be recorded and compatible with server_encoding.",
        ),
        AdvancedPreflightQueryDef(
            key="behavior_compat_options",
            sql="SELECT current_setting('behavior_compat_options', true) AS value;",
            purpose="Record compatibility options relevant to procedure search behavior.",
            validation_rule="value must be recorded; required options may be added only after documented review.",
        ),
        AdvancedPreflightQueryDef(
            key="enable_ilm",
            sql="SELECT current_setting('enable_ilm', true) AS value;",
            purpose="Record whether ILM is enabled for compression-related context.",
            validation_rule="value must be recorded; ILM execution remains excluded from this batch.",
        ),
    ]

    case_plans: List[AdvancedPackageCasePreflightDef] = []
    referenced_interface_ids: set[str] = set()
    for unit in runtime_units:
        contract = _package_contract(unit.package_ref or "")
        case_plans.append(AdvancedPackageCasePreflightDef(
            unit_id=unit.id,
            package_ref=unit.package_ref or "",
            execution_class=contract["execution_class"],
            risk_tier=contract["risk_tier"],
            global_query_keys=[item.key for item in global_queries],
            interface_count=len(unit.interface_refs),
            permissions=contract["permissions"],
            fixture_requirements=contract["fixture_requirements"],
            execution_boundaries=contract["execution_boundaries"],
            cleanup_requirements=contract["cleanup_requirements"],
            notes=f"Static preflight for {len(unit.interface_refs)} runtime-candidate interface references.",
        ))
        referenced_interface_ids.update(unit.interface_refs)

        for interface_id in unit.interface_refs:
            decision = policy_decisions.get(interface_id)
            if decision is not None and decision.recommended_policy != "runtime_candidate":
                raise ValueError(
                    f"runtime unit {unit.id} contains expansion interface {interface_id} "
                    f"recommended as {decision.recommended_policy}"
                )

    missing_expansion = sorted(expansion_runtime_ids - referenced_interface_ids)
    if missing_expansion:
        raise ValueError(f"runtime plan misses expansion runtime candidates: {missing_expansion}")

    low_risk = sum(item.risk_tier == "low" for item in case_plans)
    return AdvancedRuntimePreflightPlanDef(
        source=AdvancedPreflightSourceDef(
            interface_inventory_relpath="environments/advanced_packages_v1.yaml",
            interface_inventory_sha256=_sha256(inventory_path),
            policy_audit_relpath="environments/advanced_package_policy_audit_v1.yaml",
            policy_audit_sha256=_sha256(policy_manifest_path),
            runtime_plan_sha256=plan_sha256(plan),
            runtime_plan_unit_count=len(plan.units),
            advanced_unit_count=len(runtime_units),
        ),
        global_queries=global_queries,
        case_plans=case_plans,
        summary=AdvancedPreflightSummaryDef(
            runtime_plan_unit_count=len(plan.units),
            guc_overlay_unit_count=len(guc_units),
            advanced_case_count=len(runtime_units),
            advanced_interface_reference_count=len(referenced_interface_ids),
            global_query_count=len(global_queries),
            preflight_case_count=len(case_plans),
            low_risk_case_count=low_risk,
            medium_risk_case_count=len(case_plans) - low_risk,
            expansion_runtime_candidate_count=len(expansion_runtime_ids),
            covered_expansion_runtime_candidate_count=len(expansion_runtime_ids & referenced_interface_ids),
            coverage_complete=len(case_plans) == len(runtime_units) and not missing_expansion,
        ),
    )


class AdvancedRuntimePreflightRegistry:
    def __init__(self, root: Path):
        self.root = Path(root)

    def build(self) -> AdvancedRuntimePreflightPlanDef:
        return build_advanced_package_runtime_preflight(self.root)

    def verify(self) -> AdvancedRuntimePreflightPlanDef:
        path = self.root / "generated/advanced_package_pilot/runtime_preflight_plan.json"
        if not path.is_file():
            raise ValueError("advanced package runtime preflight plan artifact is missing")
        try:
            recorded = AdvancedRuntimePreflightPlanDef(**json.loads(path.read_text(encoding="utf-8")))
        except Exception as exc:
            raise ValueError(f"advanced package runtime preflight plan artifact is invalid: {exc}") from exc
        current = self.build()
        if recorded.model_dump(mode="json") != current.model_dump(mode="json"):
            raise ValueError("advanced package runtime preflight plan artifact is stale")
        return recorded


def verify_advanced_package_runtime_preflight(root: Path) -> AdvancedRuntimePreflightPlanDef:
    return AdvancedRuntimePreflightRegistry(Path(root)).verify()


class AdvancedPreflightQueryResultDef(StrictAdvancedPreflightModel):
    key: str
    sql: str
    status: Literal["success", "error"]
    value: Optional[str] = None
    validation_status: Literal["passed", "finding", "not_evaluated"] = "not_evaluated"
    error: str = ""

    @model_validator(mode="after")
    def ensure_query_result_shape(self) -> "AdvancedPreflightQueryResultDef":
        if self.status == "error":
            if self.validation_status != "not_evaluated":
                raise ValueError(f"failed preflight query {self.key} cannot declare a validation status")
            if self.value is not None:
                raise ValueError(f"failed preflight query {self.key} cannot declare a value")
            if not self.error:
                raise ValueError(f"failed preflight query {self.key} needs an error")
        else:
            if self.error:
                raise ValueError(f"successful preflight query {self.key} cannot declare an error")
        return self


class AdvancedPreflightResultSummaryDef(StrictAdvancedPreflightModel):
    query_count: int
    success_count: int
    error_count: int
    finding_count: int

    @model_validator(mode="after")
    def ensure_counts(self) -> "AdvancedPreflightResultSummaryDef":
        if self.query_count != self.success_count + self.error_count:
            raise ValueError("advanced preflight result query counts are inconsistent")
        if self.finding_count > self.success_count:
            raise ValueError("advanced preflight result finding count is inconsistent")
        return self


class AdvancedPackageRuntimePreflightResultDef(StrictAdvancedPreflightModel):
    schema_version: int = 1
    kind: str = "advanced_package_runtime_preflight_result"
    plan_id: str
    runtime_plan_sha256: str
    case_plan_count: int
    connected: bool
    metadata_read: bool = False
    target_sql_executed: bool = False
    guc_changed: bool = False
    object_created: bool = False
    runtime_sql_executed: bool = False
    queries: List[AdvancedPreflightQueryResultDef]
    errors: List[str]
    summary: AdvancedPreflightResultSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "This result contains only read-only preflight query evidence.",
        "It does not execute target SQL or prove advanced package behavior.",
        "A validation finding must be reviewed, but does not by itself mean the query failed.",
        "Runtime evidence still requires receipts and independent audit.",
    ])

    @model_validator(mode="after")
    def ensure_result_shape(self) -> "AdvancedPackageRuntimePreflightResultDef":
        if self.target_sql_executed or self.guc_changed or self.object_created or self.runtime_sql_executed:
            raise ValueError("advanced package preflight cannot execute runtime SQL or change state")
        success_count = sum(item.status == "success" for item in self.queries)
        error_count = sum(item.status == "error" for item in self.queries)
        finding_count = sum(
            item.status == "success" and item.validation_status == "finding"
            for item in self.queries
        )
        expected = AdvancedPreflightResultSummaryDef(
            query_count=len(self.queries),
            success_count=success_count,
            error_count=error_count,
            finding_count=finding_count,
        )
        if self.summary != expected:
            raise ValueError("advanced package preflight result summary does not match queries")
        if self.metadata_read != (bool(self.queries) and success_count == len(self.queries)):
            raise ValueError("advanced package preflight metadata_read is inconsistent")
        if self.connected != (success_count > 0):
            raise ValueError("advanced package preflight connected is inconsistent")
        if len(self.errors) != error_count:
            raise ValueError("advanced package preflight errors list does not match error_count")
        return self


class AdvancedPreflightAuditSummaryDef(StrictAdvancedPreflightModel):
    query_count: int
    success_count: int
    error_count: int
    finding_count: int
    metadata_read: bool
    connected: bool


class AdvancedPreflightAuditResultDef(StrictAdvancedPreflightModel):
    kind: str = "advanced_package_runtime_preflight_audit"
    schema_version: int = 1
    valid: bool
    plan_verified: bool
    errors: List[str]
    summary: AdvancedPreflightAuditSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "Audit verifies plan identity, query identity and result consistency only.",
        "It does not execute SQL or prove advanced package behavior.",
        "Validation findings require review before authorized execution.",
    ])


def _validate_advanced_preflight_value(key: str, value: Optional[str]) -> Literal["passed", "finding"]:
    text = None if value is None else str(value)
    if key in {"server_version", "current_database", "current_user"}:
        return "passed" if text else "finding"
    if key == "sql_compatibility":
        return "passed" if text == "A" else "finding"
    if key in {"server_encoding", "client_encoding"}:
        return "finding" if text and text.upper() == "SQL_ASCII" else "passed"
    return "passed" if value is not None else "finding"


def run_advanced_package_runtime_preflight(
    plan: AdvancedRuntimePreflightPlanDef,
    transport,
) -> AdvancedPackageRuntimePreflightResultDef:
    """Run only the planned read-only SELECT queries through a database transport."""
    results: List[AdvancedPreflightQueryResultDef] = []
    errors: List[str] = []
    for query in plan.global_queries:
        try:
            response = transport.run(query.sql)
        except Exception as exc:
            message = str(exc)
            results.append(AdvancedPreflightQueryResultDef(
                key=query.key, sql=query.sql, status="error", error=message,
            ))
            errors.append(f"{query.key}: {message}")
            continue

        if not getattr(response, "success", False):
            message = str(getattr(response, "error", ""))
            results.append(AdvancedPreflightQueryResultDef(
                key=query.key, sql=query.sql, status="error", error=message,
            ))
            errors.append(f"{query.key}: {message}")
            continue

        rows = getattr(response, "rows", []) or []
        value = rows[0][0] if rows and rows[0] is not None else None
        value_text = None if value is None else str(value)
        validation_status = _validate_advanced_preflight_value(query.key, value_text)
        results.append(AdvancedPreflightQueryResultDef(
            key=query.key,
            sql=query.sql,
            status="success",
            value=value_text,
            validation_status=validation_status,
        ))

    success_count = sum(item.status == "success" for item in results)
    error_count = len(errors)
    finding_count = sum(item.validation_status == "finding" for item in results if item.status == "success")
    return AdvancedPackageRuntimePreflightResultDef(
        plan_id=plan.id,
        runtime_plan_sha256=plan.source.runtime_plan_sha256,
        case_plan_count=len(plan.case_plans),
        connected=success_count > 0,
        metadata_read=bool(results) and success_count == len(results),
        queries=results,
        errors=errors,
        summary=AdvancedPreflightResultSummaryDef(
            query_count=len(results),
            success_count=success_count,
            error_count=error_count,
            finding_count=finding_count,
        ),
    )


def audit_advanced_package_runtime_preflight_result(
    result,
    *,
    plan: Optional[AdvancedRuntimePreflightPlanDef] = None,
) -> AdvancedPreflightAuditResultDef:
    errors: List[str] = []
    plan_verified = False
    try:
        parsed = result if isinstance(result, AdvancedPackageRuntimePreflightResultDef) else AdvancedPackageRuntimePreflightResultDef(**result)
    except Exception as exc:
        return AdvancedPreflightAuditResultDef(
            valid=False,
            plan_verified=False,
            errors=[f"preflight result schema validation failed: {exc}"],
            summary=AdvancedPreflightAuditSummaryDef(
                query_count=0, success_count=0, error_count=0,
                finding_count=0, metadata_read=False, connected=False,
            ),
        )

    if parsed.target_sql_executed:
        errors.append("preflight cannot execute target SQL")
    if parsed.guc_changed:
        errors.append("preflight cannot change GUC state")
    if parsed.object_created:
        errors.append("preflight cannot create objects")
    if parsed.runtime_sql_executed:
        errors.append("preflight cannot execute runtime SQL")

    success_count = sum(item.status == "success" for item in parsed.queries)
    error_count = sum(item.status == "error" for item in parsed.queries)
    finding_count = sum(item.status == "success" and item.validation_status == "finding" for item in parsed.queries)
    expected_summary = AdvancedPreflightAuditSummaryDef(
        query_count=len(parsed.queries),
        success_count=success_count,
        error_count=error_count,
        finding_count=finding_count,
        metadata_read=parsed.metadata_read,
        connected=parsed.connected,
    )
    if parsed.summary.query_count != len(parsed.queries):
        errors.append("summary query_count mismatch")
    if parsed.summary.success_count != success_count:
        errors.append("summary success_count mismatch")
    if parsed.summary.error_count != error_count:
        errors.append("summary error_count mismatch")
    if parsed.summary.finding_count != finding_count:
        errors.append("summary finding_count mismatch")
    if parsed.metadata_read != (bool(parsed.queries) and success_count == len(parsed.queries)):
        errors.append("metadata_read is inconsistent with query results")
    if parsed.connected != (success_count > 0):
        errors.append("connected is inconsistent with query results")
    if len(parsed.errors) != error_count:
        errors.append("errors list does not match error_count")

    if plan is None:
        errors.append("plan not supplied; plan identity could not be verified")
    else:
        if parsed.plan_id != plan.id:
            errors.append("plan id mismatch")
        if parsed.runtime_plan_sha256 != plan.source.runtime_plan_sha256:
            errors.append("runtime plan fingerprint mismatch")
        if parsed.case_plan_count != len(plan.case_plans):
            errors.append("case plan count mismatch")
        if len(parsed.queries) != len(plan.global_queries):
            errors.append("query count does not match plan")
        else:
            for index, (result_query, plan_query) in enumerate(zip(parsed.queries, plan.global_queries)):
                if result_query.key != plan_query.key:
                    errors.append(f"query identity mismatch at index {index}")
                    break
                if result_query.sql != plan_query.sql:
                    errors.append(f"query SQL mismatch at index {index}")
                    break
                expected_validation = (
                    "not_evaluated" if result_query.status == "error"
                    else _validate_advanced_preflight_value(plan_query.key, result_query.value)
                )
                if result_query.validation_status != expected_validation:
                    errors.append(f"query validation status mismatch at index {index}: {plan_query.key}")
                    break
        if not errors:
            plan_verified = True

    return AdvancedPreflightAuditResultDef(
        valid=not errors,
        plan_verified=plan_verified,
        errors=errors,
        summary=expected_summary,
    )
