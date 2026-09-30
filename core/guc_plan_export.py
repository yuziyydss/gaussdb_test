"""Deterministic export of GUC V2 session-overlay plans.

The export is still a plan, not an execution receipt.  It preserves the
capture/apply/verify/restore ordering and keeps global configuration changes
outside the generated SQL boundary.
"""
from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path
from typing import Dict, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

from core.guc_environment import (
    GucEnvironmentPlanner,
    GucEnvironmentRegistry,
    GucOverlayPlanDef,
)


SHA256_RE = re.compile(r"[0-9a-f]{64}")
PLAN_ACTIONS = (
    "capture_original", "apply", "verify_target", "restore", "verify_restore",
)


class GucOverlayPlanExportError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__(
            "GUC overlay plan export 加载失败:\n" + "\n".join(f"- {item}" for item in errors)
        )


class StrictGucPlanExportModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucPlanExportSourceDef(StrictGucPlanExportModel):
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


class GucOverlayPlanExportSummaryDef(StrictGucPlanExportModel):
    environment_parameter_count: int
    exported_plan_count: int
    excluded_parameter_count: int
    step_count: int
    execution_policy_counts: Dict[str, int]
    category_counts: Dict[str, int]


class GucOverlayPlanExportDef(StrictGucPlanExportModel):
    schema_version: Literal[1] = 1
    kind: Literal["guc_overlay_plan_export"] = "guc_overlay_plan_export"
    environment_id: str
    environment_schema_version: int
    source: GucPlanExportSourceDef
    plans: List[GucOverlayPlanDef]
    summary: GucOverlayPlanExportSummaryDef

    @field_validator("environment_id")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC environment id cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_export_shape(self) -> "GucOverlayPlanExportDef":
        if self.environment_schema_version != 2 or self.environment_id != "guc_environment_v2":
            raise ValueError("GUC overlay plan export must bind to GUC Environment V2")
        if self.source.relpath != "environments/guc_parameters_v2.yaml":
            raise ValueError("GUC overlay plan export source path is unexpected")
        parameter_ids = [plan.parameter_id for plan in self.plans]
        parameter_names = [plan.parameter_name for plan in self.plans]
        if len(set(parameter_ids)) != len(parameter_ids):
            raise ValueError("GUC overlay plan parameter ids cannot repeat")
        if len(set(parameter_names)) != len(parameter_names):
            raise ValueError("GUC overlay plan parameter names cannot repeat")
        if any([step.action for step in plan.steps] != list(PLAN_ACTIONS) for plan in self.plans):
            raise ValueError("GUC overlay plan step order is invalid")
        if any(not step.must_succeed for plan in self.plans for step in plan.steps):
            raise ValueError("GUC overlay plan steps must all be mandatory")

        environment_count = sum(self.summary.execution_policy_counts.values())
        category_count = sum(self.summary.category_counts.values())
        if environment_count != category_count:
            raise ValueError("GUC overlay policy and category totals disagree")
        expected_summary = GucOverlayPlanExportSummaryDef(
            environment_parameter_count=environment_count,
            exported_plan_count=len(self.plans),
            excluded_parameter_count=environment_count - len(self.plans),
            step_count=sum(len(plan.steps) for plan in self.plans),
            execution_policy_counts=self.summary.execution_policy_counts,
            category_counts=self.summary.category_counts,
        )
        if self.summary != expected_summary:
            raise ValueError("GUC overlay plan summary does not match the payload")
        return self


class GucOverlayPlanExportRegistry:
    """Load or rebuild the deterministic GUC V2 overlay plan export."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.environment_path = self.root / "environments/guc_parameters_v2.yaml"
        self.json_path = self.root / "generated/guc_environment_v2/overlay_plans.json"
        self.sql_path = self.root / "generated/guc_environment_v2/overlay_plans.sql"

    def load(self) -> GucOverlayPlanExportDef:
        try:
            payload = json.loads(self.json_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise GucOverlayPlanExportError([f"{self.json_path}: {exc}"]) from exc
        export = self.load_payload(payload)
        self._verify_source(export)
        return export

    def load_payload(self, payload: Dict) -> GucOverlayPlanExportDef:
        try:
            return GucOverlayPlanExportDef(**payload)
        except ValidationError as exc:
            errors = [f"payload: {item}" for item in exc.errors()]
        except (TypeError, ValueError) as exc:
            errors = [f"payload: {exc}"]
        raise GucOverlayPlanExportError(errors)

    def build(self) -> GucOverlayPlanExportDef:
        registry = GucEnvironmentRegistry(self.root, inventory_path=self.environment_path)
        registry.load_all()
        planner = GucEnvironmentPlanner(registry)
        plans: List[GucOverlayPlanDef] = []
        for parameter in sorted(registry.session_overlay_parameters(), key=lambda item: item.name):
            original = parameter.default_value
            target = next(
                value for value in parameter.safe_probe_values if value != original
            )
            plans.append(planner.plan(parameter.id, target, original))

        execution_policy_counts = dict(sorted(
            Counter(
                parameter.execution_policy
                for parameter in registry.parameters.values()
            ).items()
        ))
        category_counts = dict(sorted(
            Counter(
                parameter.category
                for parameter in registry.parameters.values()
            ).items()
        ))
        return GucOverlayPlanExportDef(
            environment_id=registry.environment.id,
            environment_schema_version=registry.environment.schema_version,
            source=GucPlanExportSourceDef(
                relpath=str(self.environment_path.relative_to(self.root)),
                sha256=hashlib.sha256(self.environment_path.read_bytes()).hexdigest(),
            ),
            plans=plans,
            summary=GucOverlayPlanExportSummaryDef(
                environment_parameter_count=len(registry.parameters),
                exported_plan_count=len(plans),
                excluded_parameter_count=len(registry.parameters) - len(plans),
                step_count=sum(len(plan.steps) for plan in plans),
                execution_policy_counts=execution_policy_counts,
                category_counts=category_counts,
            ),
        )

    def write(self) -> Path:
        export = self.build()
        self.json_path.parent.mkdir(parents=True, exist_ok=True)
        self.json_path.write_text(
            json.dumps(export.model_dump(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        self.sql_path.write_text(
            render_guc_overlay_plan_sql(export),
            encoding="utf-8",
        )
        return self.json_path

    def _verify_source(self, export: GucOverlayPlanExportDef) -> None:
        try:
            environment_bytes = self.environment_path.read_bytes()
        except OSError as exc:
            raise GucOverlayPlanExportError([f"environment source unavailable: {exc}"]) from exc
        actual_hash = hashlib.sha256(environment_bytes).hexdigest()
        if actual_hash != export.source.sha256:
            raise GucOverlayPlanExportError([
                "GUC environment hash drift: "
                f"expected {export.source.sha256}, got {actual_hash}"
            ])


def render_guc_overlay_plan_sql(export: GucOverlayPlanExportDef) -> str:
    lines = [
        "-- GaussDB GUC Environment V2 session overlay plans",
        "-- Static plan export; this file is not an execution receipt.",
        "",
    ]
    for plan in export.plans:
        lines.extend([
            f"-- parameter: {plan.parameter_name}",
            f"-- original: {plan.original_value}",
            f"-- target: {plan.target_value}",
        ])
        for step in plan.steps:
            lines.append(f"-- {step.action}")
            lines.append(step.sql)
            lines.append("")
    return "\n".join(lines).rstrip() + "\n"
