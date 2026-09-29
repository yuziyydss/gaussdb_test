"""Convert safe GUC V2 capabilities into Factor Package requirement payloads.

The adapter is deliberately conservative.  It only emits capabilities that
already have runtime fact bindings and whose allowed values are accepted by
Factor Package V1's EnvironmentRequirementDef schema.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Dict, List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

from core.factor_package_model import EnvironmentRequirementDef
from core.guc_capability import GucCapabilityMatrixDef, GucCapabilityRegistry


SHA256_RE = re.compile(r"[0-9a-f]{64}")


class GucRequirementAdapterError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__(
            "GUC requirement adapter 加载失败:\n" + "\n".join(f"- {item}" for item in errors)
        )


class StrictGucRequirementAdapterModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucRequirementAdapterSourceDef(StrictGucRequirementAdapterModel):
    capability_matrix_relpath: str
    capability_matrix_sha256: str

    @field_validator("capability_matrix_relpath")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("GUC requirement adapter source path must be safe")
        return value

    @field_validator("capability_matrix_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if SHA256_RE.fullmatch(value) is None:
            raise ValueError("GUC requirement adapter source SHA-256 must be 64 hex characters")
        return value

    @model_validator(mode="after")
    def ensure_source_shape(self) -> "GucRequirementAdapterSourceDef":
        if self.capability_matrix_relpath != "generated/guc_environment_v2/capability_matrix.json":
            raise ValueError("GUC requirement adapter must bind to the capability matrix")
        return self


class GucRequirementAdapterItemDef(StrictGucRequirementAdapterModel):
    parameter_name: str
    requirement: EnvironmentRequirementDef

    @field_validator("parameter_name")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC requirement adapter parameter name cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_item_shape(self) -> "GucRequirementAdapterItemDef":
        if self.requirement.key != f"guc_{self.parameter_name}":
            raise ValueError("GUC requirement key must derive from parameter name")
        return self


class GucRequirementBlockedDef(StrictGucRequirementAdapterModel):
    parameter_name: str
    reason: Literal["missing_runtime_fact", "empty_value_not_supported"]

    @field_validator("parameter_name")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC blocked parameter name cannot be blank")
        return normalized


class GucRequirementAdapterSummaryDef(StrictGucRequirementAdapterModel):
    capability_count: int
    requirement_count: int
    blocked_count: int
    missing_fact_blocked_count: int
    empty_value_blocked_count: int


class GucRequirementAdapterDef(StrictGucRequirementAdapterModel):
    schema_version: Literal[1]
    kind: Literal["guc_requirement_adapter"]
    id: str = "guc_requirement_adapter_v1"
    name: str = "GaussDB GUC V2 Requirement Adapter"
    description: str = (
        "将已有runtime fact且值域兼容Factor Package V1的GUC能力转换为EnvironmentRequirementDef；不直接写入specs。"
    )
    source: GucRequirementAdapterSourceDef
    requirements: List[GucRequirementAdapterItemDef]
    blocked: List[GucRequirementBlockedDef]
    summary: GucRequirementAdapterSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "This adapter does not modify Factor Package specs.",
        "Schema compatibility does not prove that fact refs resolve in a FactorPackageRegistry.",
        "Empty option-set values are blocked until EnvironmentRequirementDef supports them explicitly.",
        "A converted requirement does not authorize database execution.",
    ])

    @model_validator(mode="after")
    def ensure_adapter_shape(self) -> "GucRequirementAdapterDef":
        parameter_names = [item.parameter_name for item in self.requirements]
        blocked_names = [item.parameter_name for item in self.blocked]
        if len(set(parameter_names)) != len(parameter_names):
            raise ValueError("GUC requirement parameter names cannot repeat")
        if len(set(blocked_names)) != len(blocked_names):
            raise ValueError("GUC blocked parameter names cannot repeat")
        if set(parameter_names) & set(blocked_names):
            raise ValueError("A GUC parameter cannot be both converted and blocked")
        expected_summary = GucRequirementAdapterSummaryDef(
            capability_count=len(parameter_names) + len(blocked_names),
            requirement_count=len(self.requirements),
            blocked_count=len(self.blocked),
            missing_fact_blocked_count=sum(
                item.reason == "missing_runtime_fact" for item in self.blocked
            ),
            empty_value_blocked_count=sum(
                item.reason == "empty_value_not_supported" for item in self.blocked
            ),
        )
        if self.summary != expected_summary:
            raise ValueError("GUC requirement adapter summary is inconsistent")
        return self


def build_guc_requirement_adapter(root: Path) -> GucRequirementAdapterDef:
    root = Path(root)
    capability_path = root / "generated/guc_environment_v2/capability_matrix.json"
    capability_matrix = GucCapabilityRegistry(root).load(capability_path)

    requirements: List[GucRequirementAdapterItemDef] = []
    blocked: List[GucRequirementBlockedDef] = []
    for capability in capability_matrix.capabilities:
        if capability.integration_status != "runtime_fact_bound":
            blocked.append(GucRequirementBlockedDef(
                parameter_name=capability.parameter_name,
                reason="missing_runtime_fact",
            ))
            continue
        if any(value == "" for value in capability.allowed_values):
            blocked.append(GucRequirementBlockedDef(
                parameter_name=capability.parameter_name,
                reason="empty_value_not_supported",
            ))
            continue
        requirements.append(GucRequirementAdapterItemDef(
            parameter_name=capability.parameter_name,
            requirement=EnvironmentRequirementDef(
                key=capability.requirement_key,
                allowed_values=capability.allowed_values,
                fact_refs=capability.fact_refs,
            ),
        ))

    return GucRequirementAdapterDef(
        schema_version=1,
        kind="guc_requirement_adapter",
        source=GucRequirementAdapterSourceDef(
            capability_matrix_relpath=str(capability_path.relative_to(root)),
            capability_matrix_sha256=hashlib.sha256(
                capability_path.read_bytes()
            ).hexdigest(),
        ),
        requirements=requirements,
        blocked=blocked,
        summary=GucRequirementAdapterSummaryDef(
            capability_count=len(requirements) + len(blocked),
            requirement_count=len(requirements),
            blocked_count=len(blocked),
            missing_fact_blocked_count=sum(
                item.reason == "missing_runtime_fact" for item in blocked
            ),
            empty_value_blocked_count=sum(
                item.reason == "empty_value_not_supported" for item in blocked
            ),
        ),
    )


class GucRequirementAdapterRegistry:
    """Build, persist, and reload the GUC requirement adapter."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.adapter_path = self.root / "generated/guc_environment_v2/requirement_adapter.json"

    def build(self) -> GucRequirementAdapterDef:
        return build_guc_requirement_adapter(self.root)

    def write(self, output: Optional[Path] = None) -> Path:
        output = Path(output or self.adapter_path)
        adapter = self.build()
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(
            json.dumps(adapter.model_dump(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return output

    def load(self, path: Optional[Path] = None) -> GucRequirementAdapterDef:
        path = Path(path or self.adapter_path)
        try:
            payload = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise GucRequirementAdapterError([f"{path}: {exc}"]) from exc
        adapter = self.load_payload(payload)
        self._verify_source(adapter)
        return adapter

    def load_payload(self, payload: Dict) -> GucRequirementAdapterDef:
        try:
            return GucRequirementAdapterDef(**payload)
        except ValidationError as exc:
            errors = [f"payload: {item}" for item in exc.errors()]
        except (TypeError, ValueError) as exc:
            errors = [f"payload: {exc}"]
        raise GucRequirementAdapterError(errors)

    def _verify_source(self, adapter: GucRequirementAdapterDef) -> None:
        source = adapter.source
        path = self.root / source.capability_matrix_relpath
        try:
            actual_hash = hashlib.sha256(path.read_bytes()).hexdigest()
        except OSError as exc:
            raise GucRequirementAdapterError([f"cannot read capability matrix: {exc}"]) from exc
        if actual_hash != source.capability_matrix_sha256:
            raise GucRequirementAdapterError([
                "GUC capability matrix hash drift: "
                f"expected {source.capability_matrix_sha256}, got {actual_hash}"
            ])
