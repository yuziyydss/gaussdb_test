"""Strict GUC V2 capability adapter for future environment gates.

The matrix is not a Factor Package environment requirement yet.  It exposes
the safe requirement key, allowed values, runtime fact bindings, and overlay
plan for each GUC Environment V2 session-overlay parameter.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Dict, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

from core.guc_environment import GucEnvironmentRegistry
from core.guc_plan_export import GucOverlayPlanExportRegistry


SHA256_RE = re.compile(r"[0-9a-f]{64}")
SQL_LITERAL_RE = re.compile(r"'(?:''|[^'])*'")
PLAN_ACTIONS = (
    "capture_original", "apply", "verify_target", "restore", "verify_restore",
)


class GucCapabilityLoadError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__(
            "GUC capability matrix 加载失败:\n" + "\n".join(f"- {item}" for item in errors)
        )


class StrictGucCapabilityModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucCapabilitySourceDef(StrictGucCapabilityModel):
    environment_relpath: str
    environment_sha256: str
    overlay_plans_relpath: str
    overlay_plans_sha256: str

    @field_validator("environment_relpath", "overlay_plans_relpath")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("GUC capability source path must be a safe relative path")
        return value

    @field_validator("environment_sha256", "overlay_plans_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if SHA256_RE.fullmatch(value) is None:
            raise ValueError("GUC capability source SHA-256 must be 64 hexadecimal characters")
        return value

    @model_validator(mode="after")
    def ensure_source_shape(self) -> "GucCapabilitySourceDef":
        if self.environment_relpath != "environments/guc_parameters_v2.yaml":
            raise ValueError("GUC capability matrix must bind to GUC Environment V2")
        if self.overlay_plans_relpath != "generated/guc_environment_v2/overlay_plans.json":
            raise ValueError("GUC capability matrix must bind to the overlay plan export")
        return self


class GucCapabilityPlanStepDef(StrictGucCapabilityModel):
    action: Literal[
        "capture_original", "apply", "verify_target", "restore", "verify_restore"
    ]
    sql: str

    @field_validator("sql")
    @classmethod
    def ensure_nonblank_sql(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC capability SQL cannot be blank")
        return normalized


class GucCapabilityPlanDef(StrictGucCapabilityModel):
    target_value: str
    original_value: str
    steps: List[GucCapabilityPlanStepDef]

    @field_validator("target_value", "original_value")
    @classmethod
    def ensure_sql_literal(cls, value: str) -> str:
        if SQL_LITERAL_RE.fullmatch(value) is None:
            raise ValueError("GUC capability plan values must be SQL literals")
        return value

    @model_validator(mode="after")
    def ensure_plan_shape(self) -> "GucCapabilityPlanDef":
        if [step.action for step in self.steps] != list(PLAN_ACTIONS):
            raise ValueError("GUC capability plan step order is invalid")
        joined_sql = "\n".join(step.sql for step in self.steps)
        for forbidden in ("ALTER SYSTEM", "ALTER DATABASE", "ALTER ROLE", "RESET "):
            if forbidden in joined_sql:
                raise ValueError(f"GUC capability plan cannot contain {forbidden.strip()}")
        return self


class GucCapabilityDef(StrictGucCapabilityModel):
    requirement_key: str
    parameter_id: str
    parameter_name: str
    category: str
    integration_status: Literal["runtime_fact_bound", "needs_runtime_fact"]
    allowed_values: List[str]
    fact_refs: List[str]
    source_anchor: str
    plan: GucCapabilityPlanDef

    @field_validator(
        "requirement_key", "parameter_id", "parameter_name", "category",
        "source_anchor",
    )
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC capability field cannot be blank")
        return normalized

    @field_validator("requirement_key")
    @classmethod
    def ensure_requirement_key(cls, value: str) -> str:
        if not re.fullmatch(r"guc_[a-z][a-z0-9_]*", value):
            raise ValueError("GUC capability requirement key must be safe snake_case")
        return value

    @field_validator("allowed_values")
    @classmethod
    def ensure_allowed_values(cls, values: List[str]) -> List[str]:
        if not values:
            raise ValueError("GUC capability allowed_values cannot be empty")
        if len(values) != len(set(values)):
            raise ValueError("GUC capability allowed_values cannot repeat")
        return values

    @model_validator(mode="after")
    def ensure_capability_shape(self) -> "GucCapabilityDef":
        if self.requirement_key != f"guc_{self.parameter_name}":
            raise ValueError("GUC capability requirement key must derive from parameter name")
        expected_status = (
            "runtime_fact_bound" if self.fact_refs else "needs_runtime_fact"
        )
        if self.integration_status != expected_status:
            raise ValueError("GUC capability integration status is inconsistent")
        return self


class GucCapabilitySummaryDef(StrictGucCapabilityModel):
    capability_count: int
    runtime_fact_bound_count: int
    needs_runtime_fact_count: int
    allowed_value_count: int
    plan_step_count: int


class GucCapabilityMatrixDef(StrictGucCapabilityModel):
    schema_version: Literal[1]
    kind: Literal["guc_capability_matrix"]
    id: str = "guc_capability_matrix_v1"
    name: str = "GaussDB GUC V2 Capability Matrix"
    description: str = (
        "GUC Environment V2 session overlay参数的环境能力适配层；尚未直接写入Factor Package。"
    )
    source: GucCapabilitySourceDef
    capabilities: List[GucCapabilityDef]
    summary: GucCapabilitySummaryDef

    @model_validator(mode="after")
    def ensure_matrix_shape(self) -> "GucCapabilityMatrixDef":
        requirement_keys = [item.requirement_key for item in self.capabilities]
        parameter_ids = [item.parameter_id for item in self.capabilities]
        parameter_names = [item.parameter_name for item in self.capabilities]
        if len(set(requirement_keys)) != len(requirement_keys):
            raise ValueError("GUC capability requirement keys cannot repeat")
        if len(set(parameter_ids)) != len(parameter_ids):
            raise ValueError("GUC capability parameter ids cannot repeat")
        if len(set(parameter_names)) != len(parameter_names):
            raise ValueError("GUC capability parameter names cannot repeat")
        if any(not item.parameter_name.islower() for item in self.capabilities):
            raise ValueError("GUC capability parameter names must be lowercase")

        expected_summary = GucCapabilitySummaryDef(
            capability_count=len(self.capabilities),
            runtime_fact_bound_count=sum(
                item.integration_status == "runtime_fact_bound"
                for item in self.capabilities
            ),
            needs_runtime_fact_count=sum(
                item.integration_status == "needs_runtime_fact"
                for item in self.capabilities
            ),
            allowed_value_count=sum(len(item.allowed_values) for item in self.capabilities),
            plan_step_count=sum(len(item.plan.steps) for item in self.capabilities),
        )
        if self.summary != expected_summary:
            raise ValueError("GUC capability summary does not match capabilities")
        return self


def _plain_value(sql_literal: str) -> str:
    if len(sql_literal) >= 2 and sql_literal[0] == sql_literal[-1] == "'":
        return sql_literal[1:-1].replace("''", "'")
    return sql_literal


def build_guc_capability_matrix(root: Path) -> GucCapabilityMatrixDef:
    root = Path(root)
    environment_path = root / "environments/guc_parameters_v2.yaml"
    overlay_path = root / "generated/guc_environment_v2/overlay_plans.json"

    registry = GucEnvironmentRegistry(root, inventory_path=environment_path)
    registry.load_all()
    export = GucOverlayPlanExportRegistry(root).load()
    plans_by_parameter = {item.parameter_id: item for item in export.plans}

    capabilities: List[GucCapabilityDef] = []
    for parameter in sorted(registry.session_overlay_parameters(), key=lambda item: item.name):
        plan = plans_by_parameter.get(parameter.id)
        if plan is None:
            raise GucCapabilityLoadError([
                f"GUC capability overlay plan missing: {parameter.name}"
            ])
        capabilities.append(GucCapabilityDef(
            requirement_key=f"guc_{parameter.name}",
            parameter_id=parameter.id,
            parameter_name=parameter.name,
            category=parameter.category,
            integration_status=(
                "runtime_fact_bound" if parameter.fact_refs else "needs_runtime_fact"
            ),
            allowed_values=[
                _plain_value(value) for value in parameter.safe_probe_values
            ],
            fact_refs=list(parameter.fact_refs),
            source_anchor=parameter.source.anchor,
            plan=GucCapabilityPlanDef(
                target_value=plan.target_value,
                original_value=plan.original_value,
                steps=[
                    GucCapabilityPlanStepDef(action=step.action, sql=step.sql)
                    for step in plan.steps
                ],
            ),
        ))

    return GucCapabilityMatrixDef(
        schema_version=1,
        kind="guc_capability_matrix",
        source=GucCapabilitySourceDef(
            environment_relpath=str(environment_path.relative_to(root)),
            environment_sha256=hashlib.sha256(environment_path.read_bytes()).hexdigest(),
            overlay_plans_relpath=str(overlay_path.relative_to(root)),
            overlay_plans_sha256=hashlib.sha256(overlay_path.read_bytes()).hexdigest(),
        ),
        capabilities=capabilities,
        summary=GucCapabilitySummaryDef(
            capability_count=len(capabilities),
            runtime_fact_bound_count=sum(
                item.integration_status == "runtime_fact_bound"
                for item in capabilities
            ),
            needs_runtime_fact_count=sum(
                item.integration_status == "needs_runtime_fact"
                for item in capabilities
            ),
            allowed_value_count=sum(len(item.allowed_values) for item in capabilities),
            plan_step_count=sum(len(item.plan.steps) for item in capabilities),
        ),
    )


class GucCapabilityRegistry:
    """Build, persist, and reload the GUC V2 capability matrix."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.matrix_path = self.root / "generated/guc_environment_v2/capability_matrix.json"

    def build(self) -> GucCapabilityMatrixDef:
        return build_guc_capability_matrix(self.root)

    def write(self, output: Optional[Path] = None) -> Path:
        output = Path(output or self.matrix_path)
        matrix = self.build()
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(
            json.dumps(matrix.model_dump(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return output

    def load(self, path: Optional[Path] = None) -> GucCapabilityMatrixDef:
        path = Path(path or self.matrix_path)
        try:
            payload = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise GucCapabilityLoadError([f"{path}: {exc}"]) from exc
        matrix = self.load_payload(payload)
        self._verify_source(matrix)
        return matrix

    def load_payload(self, payload: Dict) -> GucCapabilityMatrixDef:
        try:
            return GucCapabilityMatrixDef(**payload)
        except ValidationError as exc:
            errors = [f"payload: {item}" for item in exc.errors()]
        except (TypeError, ValueError) as exc:
            errors = [f"payload: {exc}"]
        raise GucCapabilityLoadError(errors)

    def _verify_source(self, matrix: GucCapabilityMatrixDef) -> None:
        errors: List[str] = []
        source = matrix.source
        for relpath, expected_hash in (
            (source.environment_relpath, source.environment_sha256),
            (source.overlay_plans_relpath, source.overlay_plans_sha256),
        ):
            path = self.root / relpath
            try:
                actual_hash = hashlib.sha256(path.read_bytes()).hexdigest()
            except OSError as exc:
                errors.append(f"cannot read GUC capability source {relpath}: {exc}")
                continue
            if actual_hash != expected_hash:
                errors.append(
                    f"GUC capability source hash drift for {relpath}: "
                    f"expected {expected_hash}, got {actual_hash}"
                )
        if errors:
            raise GucCapabilityLoadError(errors)
