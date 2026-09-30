"""Read-only, domain-aware preflight for GUC Environment V2.

The plan covers all modeled parameters, but it never changes a GUC and never
executes target SQL.  A real database run must use a separate authorized
transport and produce its own receipt.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Dict, List, Literal, Optional, Protocol

from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

from core.guc_environment import GucEnvironmentRegistry, GucValueDomainDef


SHA256_RE = re.compile(r"[0-9a-f]{64}")


class GucV2PreflightError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__(
            "GUC V2 preflight 加载失败:\n" + "\n".join(f"- {item}" for item in errors)
        )


class StrictGucPreflightModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucPreflightSourceDef(StrictGucPreflightModel):
    relpath: str
    sha256: str

    @field_validator("relpath")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("GUC environment path must be a safe relative path")
        return value

    @field_validator("sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if SHA256_RE.fullmatch(value) is None:
            raise ValueError("GUC environment SHA-256 must be 64 hexadecimal characters")
        return value


class GucPreflightPlanSummaryDef(StrictGucPreflightModel):
    query_count: int
    read_only: bool


class GucPreflightQueryDef(StrictGucPreflightModel):
    parameter_id: str
    parameter_name: str
    sql: str
    description: str
    value_domain: GucValueDomainDef

    @field_validator("parameter_id", "parameter_name", "sql", "description")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC preflight query field cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_read_only_sql(self) -> "GucPreflightQueryDef":
        if not self.sql.startswith("SELECT current_setting("):
            raise ValueError("GUC preflight query must read current_setting")
        for forbidden in ("SET ", "INSERT ", "UPDATE ", "DELETE ", "CREATE ", "DROP ", "ALTER "):
            if forbidden in self.sql:
                raise ValueError(f"GUC preflight query cannot contain {forbidden.strip()}")
        return self


class GucV2PreflightPlanDef(StrictGucPreflightModel):
    schema_version: Literal[1]
    kind: Literal["guc_v2_preflight_plan"]
    environment_id: str
    environment_schema_version: int
    source: GucPreflightSourceDef
    queries: List[GucPreflightQueryDef]
    summary: GucPreflightPlanSummaryDef

    @field_validator("environment_id")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC environment id cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_plan_shape(self) -> "GucV2PreflightPlanDef":
        if self.environment_id != "guc_environment_v2" or self.environment_schema_version != 2:
            raise ValueError("GUC preflight plan must bind to GUC Environment V2")
        if self.source.relpath != "environments/guc_parameters_v2.yaml":
            raise ValueError("GUC preflight plan source path is unexpected")
        if not self.queries:
            raise ValueError("GUC preflight plan must contain queries")
        ids = [item.parameter_id for item in self.queries]
        names = [item.parameter_name for item in self.queries]
        if len(set(ids)) != len(ids):
            raise ValueError("GUC preflight parameter ids cannot repeat")
        if len(set(names)) != len(names):
            raise ValueError("GUC preflight parameter names cannot repeat")
        expected_summary = GucPreflightPlanSummaryDef(
            query_count=len(self.queries),
            read_only=True,
        )
        if self.summary != expected_summary:
            raise ValueError("GUC preflight plan summary does not match queries")
        return self


class GucPreflightQueryResultDef(StrictGucPreflightModel):
    parameter_id: str
    parameter_name: str
    sql: str
    status: Literal["success", "error"]
    value: Optional[str] = None
    in_declared_domain: bool = False
    error: str = ""


class GucPreflightResultSummaryDef(StrictGucPreflightModel):
    query_count: int
    success_count: int
    error_count: int
    domain_mismatch_count: int


class GucV2PreflightResultDef(StrictGucPreflightModel):
    schema_version: Literal[1]
    kind: Literal["guc_v2_preflight_result"]
    environment_id: str
    connected: bool
    metadata_read: bool
    target_sql_executed: bool = False
    guc_changed: bool = False
    object_created: bool = False
    queries: List[GucPreflightQueryResultDef]
    errors: List[str]
    summary: GucPreflightResultSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "This preflight only reads current GUC values.",
        "It does not execute target SQL or change any GUC.",
        "A domain mismatch is a finding, not a database execution failure.",
        "Runtime behavior still requires a separate authorized execution receipt.",
    ])

    @model_validator(mode="after")
    def ensure_result_shape(self) -> "GucV2PreflightResultDef":
        if self.target_sql_executed or self.guc_changed or self.object_created:
            raise ValueError("GUC preflight cannot execute target SQL or change state")
        success_count = sum(item.status == "success" for item in self.queries)
        error_count = sum(item.status == "error" for item in self.queries)
        mismatch_count = sum(
            item.status == "success" and not item.in_declared_domain
            for item in self.queries
        )
        expected_summary = GucPreflightResultSummaryDef(
            query_count=len(self.queries),
            success_count=success_count,
            error_count=error_count,
            domain_mismatch_count=mismatch_count,
        )
        if self.summary != expected_summary:
            raise ValueError("GUC preflight result summary does not match queries")
        if self.metadata_read != ((success_count == len(self.queries)) and bool(self.queries)):
            raise ValueError("GUC preflight metadata_read is inconsistent")
        return self


class GucPreflightTransport(Protocol):
    def run(self, sql: str):
        ...


class ScriptedGucPreflightTransport:
    def __init__(self, responses):
        self.responses = list(responses)
        self.calls: List[str] = []

    def run(self, sql: str):
        self.calls.append(sql)
        if not self.responses:
            raise AssertionError(f"unexpected SQL call: {sql}")
        return self.responses.pop(0)


def _plain_value(sql_literal: str) -> str:
    if len(sql_literal) >= 2 and sql_literal[0] == sql_literal[-1] == "'":
        return sql_literal[1:-1].replace("''", "'")
    return sql_literal


def _quote_sql_literal(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def build_guc_v2_preflight_plan(root: Path) -> GucV2PreflightPlanDef:
    root = Path(root)
    environment_path = root / "environments/guc_parameters_v2.yaml"
    registry = GucEnvironmentRegistry(root, inventory_path=environment_path)
    registry.load_all()
    queries = [
        GucPreflightQueryDef(
            parameter_id=parameter.id,
            parameter_name=parameter.name,
            sql=f"SELECT current_setting('{parameter.name}', true) AS value;",
            description=parameter.description,
            value_domain=parameter.value_domain,
        )
        for parameter in sorted(
            registry.parameters.values(),
            key=lambda item: (item.category, item.name),
        )
    ]
    return GucV2PreflightPlanDef(
        schema_version=1,
        kind="guc_v2_preflight_plan",
        environment_id=registry.environment.id,
        environment_schema_version=registry.environment.schema_version,
        source=GucPreflightSourceDef(
            relpath=str(environment_path.relative_to(root)),
            sha256=hashlib.sha256(environment_path.read_bytes()).hexdigest(),
        ),
        queries=queries,
        summary=GucPreflightPlanSummaryDef(
            query_count=len(queries),
            read_only=True,
        ),
    )


def run_guc_v2_preflight(
    plan: GucV2PreflightPlanDef,
    transport: GucPreflightTransport,
) -> GucV2PreflightResultDef:
    results: List[GucPreflightQueryResultDef] = []
    errors: List[str] = []

    for query in plan.queries:
        try:
            response = transport.run(query.sql)
        except Exception as exc:
            results.append(GucPreflightQueryResultDef(
                parameter_id=query.parameter_id,
                parameter_name=query.parameter_name,
                sql=query.sql,
                status="error",
                error=str(exc),
            ))
            errors.append(f"{query.parameter_name}: {exc}")
            continue

        if not getattr(response, "success", False):
            error = str(getattr(response, "error", ""))
            results.append(GucPreflightQueryResultDef(
                parameter_id=query.parameter_id,
                parameter_name=query.parameter_name,
                sql=query.sql,
                status="error",
                error=error,
            ))
            errors.append(f"{query.parameter_name}: {error}")
            continue

        rows = getattr(response, "rows", []) or []
        if not rows or not rows[0]:
            error = "no row returned"
            results.append(GucPreflightQueryResultDef(
                parameter_id=query.parameter_id,
                parameter_name=query.parameter_name,
                sql=query.sql,
                status="error",
                error=error,
            ))
            errors.append(f"{query.parameter_name}: {error}")
            continue

        value = rows[0][0]
        value_text = None if value is None else str(value)
        in_domain = (
            value_text is not None
            and query.value_domain.literal_is_allowed(_quote_sql_literal(value_text))
        )
        results.append(GucPreflightQueryResultDef(
            parameter_id=query.parameter_id,
            parameter_name=query.parameter_name,
            sql=query.sql,
            status="success",
            value=value_text,
            in_declared_domain=in_domain,
        ))

    success_count = sum(item.status == "success" for item in results)
    error_count = sum(item.status == "error" for item in results)
    mismatch_count = sum(
        item.status == "success" and not item.in_declared_domain
        for item in results
    )
    return GucV2PreflightResultDef(
        schema_version=1,
        kind="guc_v2_preflight_result",
        environment_id=plan.environment_id,
        connected=success_count > 0,
        metadata_read=success_count == len(plan.queries) and bool(plan.queries),
        queries=results,
        errors=errors,
        summary=GucPreflightResultSummaryDef(
            query_count=len(results),
            success_count=success_count,
            error_count=error_count,
            domain_mismatch_count=mismatch_count,
        ),
    )


class GucV2PreflightRegistry:
    """Build or load the static GUC V2 read-only preflight plan."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.environment_path = self.root / "environments/guc_parameters_v2.yaml"
        self.plan_path = self.root / "generated/guc_environment_v2/preflight_plan.json"

    def build(self) -> GucV2PreflightPlanDef:
        return build_guc_v2_preflight_plan(self.root)

    def write(self) -> Path:
        plan = self.build()
        self.plan_path.parent.mkdir(parents=True, exist_ok=True)
        self.plan_path.write_text(
            json.dumps(plan.model_dump(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return self.plan_path

    def load(self) -> GucV2PreflightPlanDef:
        try:
            payload = json.loads(self.plan_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise GucV2PreflightError([f"{self.plan_path}: {exc}"]) from exc
        plan = self.load_payload(payload)
        self._verify_source(plan)
        return plan

    def load_payload(self, payload: Dict) -> GucV2PreflightPlanDef:
        try:
            return GucV2PreflightPlanDef(**payload)
        except ValidationError as exc:
            errors = [f"payload: {item}" for item in exc.errors()]
        except (TypeError, ValueError) as exc:
            errors = [f"payload: {exc}"]
        raise GucV2PreflightError(errors)

    def current_values(self) -> List[str]:
        registry = GucEnvironmentRegistry(
            self.root,
            inventory_path=self.environment_path,
        )
        registry.load_all()
        return [
            _plain_value(parameter.default_value)
            for parameter in sorted(
                registry.parameters.values(),
                key=lambda item: (item.category, item.name),
            )
        ]

    def _verify_source(self, plan: GucV2PreflightPlanDef) -> None:
        try:
            content = self.environment_path.read_bytes()
        except OSError as exc:
            raise GucV2PreflightError([f"environment source unavailable: {exc}"]) from exc
        actual_hash = hashlib.sha256(content).hexdigest()
        if actual_hash != plan.source.sha256:
            raise GucV2PreflightError([
                "GUC environment hash drift: "
                f"expected {plan.source.sha256}, got {actual_hash}"
            ])
