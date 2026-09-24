"""Strict environment model for GaussDB GUC parameters.

GUC parameters are environment capabilities, not SQL syntax slots. This module
keeps parameter identity, value domains, source provenance and execution safety
separate from SQL factor packages.
"""
from __future__ import annotations

import hashlib
import re
from pathlib import Path
from typing import Dict, Iterable, List, Literal, Optional

import yaml
from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator


GUC_NAME_RE = re.compile(r"[a-z][a-z0-9_]*(?:\.[a-z][a-z0-9_]*)*")
SQL_LITERAL_RE = re.compile(r"'(?:''|[^'])*'")
IDENTIFIER_SQL_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")


class GucEnvironmentLoadError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__("GUC environment 加载失败:\n" + "\n".join(f"- {item}" for item in errors))


class StrictGucModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucSourceDef(StrictGucModel):
    document: str
    version: str
    source_relpath: str
    source_sha256: str
    anchor: str

    @field_validator("source_relpath")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("source_relpath 必须是安全相对路径")
        return value

    @field_validator("source_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        digest = value.lower()
        if re.fullmatch(r"[0-9a-f]{64}", digest) is None:
            raise ValueError("source_sha256 必须是64位十六进制 SHA-256")
        return digest


class GucValueDef(StrictGucModel):
    value: str
    sql_literal: str
    description: str

    @field_validator("value")
    @classmethod
    def ensure_value(cls, value: str) -> str:
        return value

    @field_validator("sql_literal")
    @classmethod
    def ensure_sql_literal(cls, value: str) -> str:
        if SQL_LITERAL_RE.fullmatch(value) is None:
            raise ValueError("sql_literal 必须是单引号 SQL 字面量")
        return value


class GucValueDomainDef(StrictGucModel):
    type: Literal["fixed", "option_set", "integer_range", "free_string"]
    values: List[GucValueDef] = Field(default_factory=list)
    options: List[str] = Field(default_factory=list)
    minimum: Optional[int] = None
    maximum: Optional[int] = None
    unit: Optional[str] = None
    allow_empty: bool = False

    @model_validator(mode="after")
    def ensure_domain_shape(self) -> "GucValueDomainDef":
        if self.type == "fixed" and not self.values:
            raise ValueError("fixed 值域必须声明 values")
        if self.type == "option_set" and not self.options:
            raise ValueError("option_set 值域必须声明 options")
        if self.type == "integer_range" and (self.minimum is None or self.maximum is None):
            raise ValueError("integer_range 必须声明 minimum 和 maximum")
        if self.type in {"fixed", "option_set"} and (self.minimum is not None or self.maximum is not None):
            raise ValueError("只有 integer_range 可以声明 minimum/maximum")
        if len({item.value for item in self.values}) != len(self.values):
            raise ValueError("fixed values 不能重复")
        if len(set(self.options)) != len(self.options):
            raise ValueError("options 不能重复")
        return self

    def literal_is_allowed(self, sql_literal: str) -> bool:
        value = _unquote_sql_literal(sql_literal)
        if self.type == "fixed":
            return any(item.value == value for item in self.values)
        if self.type == "option_set":
            if value == "":
                return self.allow_empty
            tokens = [token.strip() for token in value.split(",")]
            return bool(tokens) and all(token in set(self.options) for token in tokens)
        if self.type == "integer_range":
            try:
                number = int(value)
            except ValueError:
                return False
            return self.minimum <= number <= self.maximum
        return True


class GucParameterDef(StrictGucModel):
    schema_version: Literal[1]
    kind: Literal["guc_parameter"]
    id: str
    name: str
    category: Literal[
        "compatibility", "query_planning", "transaction", "wal", "lock", "plancache"
    ]
    description: str
    value_type: Literal["boolean", "enum", "string", "integer"]
    value_domain: GucValueDomainDef
    default_value: str
    context_type: Literal["INTERNAL", "USERSET", "SUSET", "SIGHUP", "POSTMASTER"]
    set_scopes: List[Literal["session", "database", "pdb", "user"]] = Field(default_factory=list)
    dynamic: bool
    restart_required: bool
    execution_policy: Literal["session_overlay", "read_only", "manual_review", "blocked"]
    safe_probe_values: List[str] = Field(default_factory=list)
    restore_policy: Literal["set_original", "not_applicable"]
    source: GucSourceDef
    fact_refs: List[str] = Field(default_factory=list)

    @field_validator("id")
    @classmethod
    def ensure_id(cls, value: str) -> str:
        if not re.fullmatch(r"guc_[a-z0-9_]+", value):
            raise ValueError("id 必须是 guc_ 前缀的 snake_case")
        return value

    @field_validator("name")
    @classmethod
    def ensure_name(cls, value: str) -> str:
        if GUC_NAME_RE.fullmatch(value) is None:
            raise ValueError("name 必须是安全 GUC 参数名")
        return value

    @field_validator("default_value", "safe_probe_values")
    @classmethod
    def ensure_sql_literals(cls, value):
        if isinstance(value, str):
            values = [value]
        else:
            values = value
        for literal in values:
            if SQL_LITERAL_RE.fullmatch(literal) is None:
                raise ValueError("GUC 值必须是单引号 SQL 字面量")
        return value

    @model_validator(mode="after")
    def ensure_policy_and_domain(self) -> "GucParameterDef":
        if not self.value_domain.literal_is_allowed(self.default_value):
            raise ValueError("default_value 不在声明值域内")
        for literal in self.safe_probe_values:
            if not self.value_domain.literal_is_allowed(literal):
                raise ValueError(f"safe_probe_value {literal} 不在声明值域内")
        if len(set(self.safe_probe_values)) != len(self.safe_probe_values):
            raise ValueError("safe_probe_values 不能重复")
        if self.context_type == "INTERNAL":
            if self.set_scopes or self.dynamic or self.restart_required:
                raise ValueError("INTERNAL 参数只能读取，不能声明可设置/动态/重启")
            if self.execution_policy != "read_only":
                raise ValueError("INTERNAL 参数必须 read_only")
        elif self.context_type == "POSTMASTER":
            if not self.restart_required:
                raise ValueError("POSTMASTER 参数必须 restart_required")
            if self.execution_policy != "blocked":
                raise ValueError("POSTMASTER 参数必须 blocked")
        if self.execution_policy == "session_overlay":
            if self.context_type != "USERSET" or "session" not in self.set_scopes or not self.dynamic:
                raise ValueError("session_overlay 只允许动态 USERSET 参数")
            if self.restart_required or not self.safe_probe_values:
                raise ValueError("session_overlay 必须无重启且声明 safe_probe_values")
            if self.restore_policy != "set_original":
                raise ValueError("session_overlay 必须恢复原值")
        elif self.safe_probe_values:
            raise ValueError("只有 session_overlay 可以声明 safe_probe_values")
        return self

    @property
    def metadata_sql(self) -> str:
        return f"SELECT current_setting('{self.name}', true) AS value;"


class GucEnvironmentDef(StrictGucModel):
    schema_version: Literal[1]
    kind: Literal["guc_environment"]
    id: str
    name: str
    description: str
    parameters: List[GucParameterDef]

    @model_validator(mode="after")
    def ensure_unique_parameters(self) -> "GucEnvironmentDef":
        ids = [item.id for item in self.parameters]
        names = [item.name for item in self.parameters]
        if len(set(ids)) != len(ids):
            raise ValueError("GUC parameter id 重复")
        if len(set(names)) != len(names):
            raise ValueError("GUC parameter name 重复")
        return self


class GucOverlayStepDef(StrictGucModel):
    action: Literal["capture_original", "apply", "verify_target", "restore", "verify_restore"]
    sql: str
    must_succeed: bool = True


class GucOverlayPlanDef(StrictGucModel):
    parameter_id: str
    parameter_name: str
    target_value: str
    original_value: str
    steps: List[GucOverlayStepDef]


def _unquote_sql_literal(literal: str) -> str:
    if not SQL_LITERAL_RE.fullmatch(literal):
        raise ValueError(f"无效 SQL 字面量: {literal}")
    return literal[1:-1].replace("''", "'")


class GucEnvironmentPlanner:
    """Build session-local plans; global and restart-required changes fail closed."""

    def __init__(self, registry: "GucEnvironmentRegistry"):
        self.registry = registry

    def plan(self, parameter_id: str, target_value: str, original_value: str) -> GucOverlayPlanDef:
        parameter = self.registry.parameters[parameter_id]
        if parameter.execution_policy != "session_overlay":
            raise ValueError(f"GUC {parameter.name} 不允许 session overlay: {parameter.execution_policy}")
        if not parameter.value_domain.literal_is_allowed(target_value):
            raise ValueError(f"GUC {parameter.name} target_value 不在声明值域内")
        if target_value not in parameter.safe_probe_values:
            raise ValueError(f"GUC {parameter.name} target_value 不在 safe_probe_values 内")
        if not parameter.value_domain.literal_is_allowed(original_value):
            raise ValueError(f"GUC {parameter.name} original_value 不在声明值域内")

        # Use the captured original literal, never RESET to an inherited/default value.
        return GucOverlayPlanDef(
            parameter_id=parameter.id,
            parameter_name=parameter.name,
            target_value=target_value,
            original_value=original_value,
            steps=[
                GucOverlayStepDef(action="capture_original", sql=parameter.metadata_sql),
                GucOverlayStepDef(
                    action="apply",
                    sql=f"SET {parameter.name} = {target_value};",
                ),
                GucOverlayStepDef(
                    action="verify_target",
                    sql=f"SELECT current_setting('{parameter.name}', true) AS value;",
                ),
                GucOverlayStepDef(
                    action="restore",
                    sql=f"SET {parameter.name} = {original_value};",
                ),
                GucOverlayStepDef(
                    action="verify_restore",
                    sql=f"SELECT current_setting('{parameter.name}', true) AS value;",
                ),
            ],
        )


class GucEnvironmentRegistry:
    """Strict loader for the pilot GUC environment inventory."""

    def __init__(self, root: Path, inventory_path: Optional[Path] = None):
        self.root = Path(root)
        self.inventory_path = Path(inventory_path or self.root / "environments/guc_parameters_v1.yaml")
        self.environment: Optional[GucEnvironmentDef] = None
        self.parameters: Dict[str, GucParameterDef] = {}
        self.parameters_by_name: Dict[str, GucParameterDef] = {}
        self.fact_ids: set[str] = set()
        self.fact_statuses: Dict[str, str] = {}
        self.source_paths: Dict[str, Path] = {}

    def load_all(self) -> None:
        self.parameters.clear()
        self.parameters_by_name.clear()
        self.fact_ids.clear()
        self.fact_statuses.clear()
        self.source_paths.clear()
        errors: List[str] = []
        try:
            raw = yaml.safe_load(self.inventory_path.read_text(encoding="utf-8"))
            if not isinstance(raw, dict):
                raise ValueError("YAML 顶层必须是对象")
            environment = GucEnvironmentDef(**raw)
        except (OSError, yaml.YAMLError, ValidationError, ValueError) as exc:
            raise GucEnvironmentLoadError([f"{self.inventory_path}: {exc}"]) from exc

        for path in sorted((self.root / "docs/compat_facts").glob("runtime_params*.yaml")):
            try:
                raw = yaml.safe_load(path.read_text(encoding="utf-8"))
                for item in raw.get("facts", []):
                    self.fact_ids.add(item["id"])
                    self.fact_statuses[item["id"]] = item.get("status", "")
            except (OSError, yaml.YAMLError, TypeError, KeyError) as exc:
                errors.append(f"{path}: {exc}")

        for parameter in environment.parameters:
            source_path = self.root / parameter.source.source_relpath
            self.source_paths[parameter.id] = source_path
            try:
                actual_hash = hashlib.sha256(source_path.read_bytes()).hexdigest()
            except OSError as exc:
                errors.append(f"{parameter.id}: source file {source_path}: {exc}")
                continue
            if actual_hash != parameter.source.source_sha256:
                errors.append(
                    f"{parameter.id}: source hash drift: expected {parameter.source.source_sha256}, got {actual_hash}"
                )
            missing_facts = set(parameter.fact_refs) - self.fact_ids
            if missing_facts:
                errors.append(f"{parameter.id}: unknown runtime param facts: {sorted(missing_facts)}")
            unconfirmed_facts = {
                fact_id for fact_id in parameter.fact_refs
                if fact_id in self.fact_statuses
                and self.fact_statuses[fact_id] != "confirmed"
            }
            if unconfirmed_facts:
                errors.append(
                    f"{parameter.id}: runtime param facts are not confirmed: {sorted(unconfirmed_facts)}"
                )
            self.parameters[parameter.id] = parameter
            self.parameters_by_name[parameter.name] = parameter

        if errors:
            raise GucEnvironmentLoadError(errors)
        self.environment = environment

    def session_overlay_parameters(self) -> List[GucParameterDef]:
        return [
            item for item in self.parameters.values()
            if item.execution_policy == "session_overlay"
        ]
