"""Strict static model for GaussDB advanced package interface pilots.

Advanced packages are PL/SQL interface contracts, not SQL statement factors.
This module keeps package/interface identity, signatures, source provenance and
runtime pilot plans separate from the SQL Factor Package V1 registry.
"""
from __future__ import annotations

import hashlib
import re
from pathlib import Path
from typing import Dict, List, Literal, Optional

import yaml
from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator


SAFE_SQL_FRAGMENT_RE = re.compile(r"[A-Za-z0-9_.'\":\-\[\](), %*+/$]*")
QUALIFIED_CALL_RE = re.compile(r"[A-Z][A-Z0-9_]*\.[A-Z][A-Z0-9_]*")


class AdvancedPackageLoadError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__("Advanced package 加载失败:\n" + "\n".join(f"- {item}" for item in errors))


class StrictAdvancedPackageModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class AdvancedPackageSourceDef(StrictAdvancedPackageModel):
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


class AdvancedParameterDef(StrictAdvancedPackageModel):
    name: str
    mode: Literal["IN", "OUT", "INOUT"]
    type: str
    default_sql: Optional[str] = None
    description: str

    @field_validator("name")
    @classmethod
    def ensure_name(cls, value: str) -> str:
        if not re.fullmatch(r"[a-z][a-z0-9_]*", value):
            raise ValueError("advanced package 参数名必须是 snake_case")
        return value

    @field_validator("type")
    @classmethod
    def ensure_type(cls, value: str) -> str:
        if not re.fullmatch(r"[A-Za-z0-9_()%.,\[\] ]+", value):
            raise ValueError(f"无效参数类型: {value}")
        return value.strip()

    @field_validator("default_sql")
    @classmethod
    def ensure_default_sql(cls, value: Optional[str]) -> Optional[str]:
        if value is None:
            return None
        normalized = value.strip()
        if not normalized or not SAFE_SQL_FRAGMENT_RE.fullmatch(normalized):
            raise ValueError(f"无效 default SQL 片段: {value}")
        return normalized


class AdvancedInterfaceDef(StrictAdvancedPackageModel):
    schema_version: Literal[1]
    kind: Literal["advanced_interface"]
    id: str
    package_ref: str
    call_name: str
    callable_kind: Literal["procedure", "function", "collection_type"]
    parameters: List[AdvancedParameterDef] = Field(default_factory=list)
    return_type: Optional[str] = None
    fact_refs: List[str]
    execution_policy: Literal["static_probe", "runtime_candidate", "manual_review", "blocked"]
    state_effect: Literal["none", "buffer", "context"] = "none"
    cleanup_requirement: Literal["none", "close_context"] = "none"
    notes: str = ""

    @field_validator("id")
    @classmethod
    def ensure_id(cls, value: str) -> str:
        if not re.fullmatch(r"adv_[a-z0-9_]+", value):
            raise ValueError("interface id 必须是 adv_ 前缀 snake_case")
        return value

    @field_validator("call_name")
    @classmethod
    def ensure_call_name(cls, value: str) -> str:
        if QUALIFIED_CALL_RE.fullmatch(value) is None:
            raise ValueError("call_name 必须是 PACKAGE.INTERFACE 形式")
        return value

    @model_validator(mode="after")
    def ensure_signature_consistency(self) -> "AdvancedInterfaceDef":
        if self.callable_kind == "function" and not self.return_type:
            raise ValueError("function 接口必须声明 return_type")
        if self.callable_kind != "function" and self.return_type:
            raise ValueError("只有 function 接口可以声明 return_type")
        if self.callable_kind == "collection_type" and self.parameters:
            raise ValueError("collection_type 不能声明调用参数")
        if self.cleanup_requirement == "close_context" and self.state_effect != "context":
            raise ValueError("close_context 清理要求只能用于 context 状态接口")
        if self.execution_policy == "blocked" and self.cleanup_requirement != "none":
            raise ValueError("blocked 接口不能生成清理调用")
        return self

    def signature(self) -> str:
        parameters = ", ".join(
            f"{item.name} {item.mode} {item.type}"
            + (f" DEFAULT {item.default_sql}" if item.default_sql else "")
            for item in self.parameters
        )
        suffix = f" RETURN {self.return_type}" if self.return_type else ""
        return f"{self.call_name}({parameters}){suffix}"


class AdvancedPackageDef(StrictAdvancedPackageModel):
    schema_version: Literal[1]
    kind: Literal["advanced_package"]
    id: str
    name: str
    description: str
    source: AdvancedPackageSourceDef
    interfaces: List[AdvancedInterfaceDef]

    @field_validator("id", "name")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("advanced package id/name 不能为空")
        return normalized

    @model_validator(mode="after")
    def ensure_unique_interfaces(self) -> "AdvancedPackageDef":
        ids = [item.id for item in self.interfaces]
        names = [item.call_name for item in self.interfaces]
        if len(set(ids)) != len(ids):
            raise ValueError("interface id 重复")
        if len(set(names)) != len(names):
            raise ValueError("interface call_name 重复")
        if any(item.package_ref != self.id for item in self.interfaces):
            raise ValueError("interface package_ref 与所属 package 不一致")
        return self


class AdvancedOracleDef(StrictAdvancedPackageModel):
    kind: Literal["output", "value", "lifecycle"]
    expected: str
    status: Literal["needs_verification"]


class AdvancedPackageTestCaseDef(StrictAdvancedPackageModel):
    schema_version: Literal[1]
    kind: Literal["advanced_package_test_case"]
    id: str
    package_ref: str
    interface_refs: List[str]
    status: Literal["runtime_candidate"]
    sql: str
    oracle: AdvancedOracleDef
    cleanup_required: bool

    @field_validator("id")
    @classmethod
    def ensure_id(cls, value: str) -> str:
        if not re.fullmatch(r"adv_case_[a-z0-9_]+", value):
            raise ValueError("test case id 必须是 adv_case_ 前缀 snake_case")
        return value

    @model_validator(mode="after")
    def ensure_runtime_boundary(self) -> "AdvancedPackageTestCaseDef":
        if self.oracle.status != "needs_verification":
            raise ValueError("advanced package 试点不能声明已确认运行 Oracle")
        if self.cleanup_required and "SQL_UNREGISTER_CONTEXT" not in self.sql:
            raise ValueError("cleanup_required 用例必须包含 SQL_UNREGISTER_CONTEXT")
        return self


class AdvancedPackageEnvironmentDef(StrictAdvancedPackageModel):
    schema_version: Literal[1]
    kind: Literal["advanced_package_environment"]
    id: str
    name: str
    description: str
    packages: List[AdvancedPackageDef]
    test_cases: List[AdvancedPackageTestCaseDef]

    @model_validator(mode="after")
    def ensure_unique_top_level_ids(self) -> "AdvancedPackageEnvironmentDef":
        package_ids = [item.id for item in self.packages]
        case_ids = [item.id for item in self.test_cases]
        if len(set(package_ids)) != len(package_ids):
            raise ValueError("advanced package id 重复")
        if len(set(case_ids)) != len(case_ids):
            raise ValueError("advanced package test case id 重复")
        return self


class AdvancedPackageRegistry:
    """Strict loader for the DBE_OUTPUT / DBE_RAW / DBE_SQL pilot inventory."""

    def __init__(self, root: Path, inventory_path: Optional[Path] = None):
        self.root = Path(root)
        self.inventory_path = Path(inventory_path or self.root / "environments/advanced_packages_v1.yaml")
        self.environment: Optional[AdvancedPackageEnvironmentDef] = None
        self.packages: Dict[str, AdvancedPackageDef] = {}
        self.interfaces: Dict[str, AdvancedInterfaceDef] = {}
        self.test_cases: Dict[str, AdvancedPackageTestCaseDef] = {}
        self.fact_statuses: Dict[str, str] = {}

    def load_all(self) -> None:
        self.packages.clear()
        self.interfaces.clear()
        self.test_cases.clear()
        self.fact_statuses.clear()
        errors: List[str] = []
        try:
            raw = yaml.safe_load(self.inventory_path.read_text(encoding="utf-8"))
            if not isinstance(raw, dict):
                raise ValueError("YAML 顶层必须是对象")
            environment = AdvancedPackageEnvironmentDef(**raw)
        except (OSError, yaml.YAMLError, ValidationError, ValueError) as exc:
            raise AdvancedPackageLoadError([f"{self.inventory_path}: {exc}"]) from exc

        for path in sorted((self.root / "docs/compat_facts").glob("stored_proc_dbe*.yaml")):
            try:
                raw = yaml.safe_load(path.read_text(encoding="utf-8"))
                for item in raw.get("facts", []):
                    self.fact_statuses[item["id"]] = item.get("status", "")
            except (OSError, yaml.YAMLError, TypeError, KeyError) as exc:
                errors.append(f"{path}: {exc}")

        for package in environment.packages:
            source_path = self.root / package.source.source_relpath
            try:
                actual_hash = hashlib.sha256(source_path.read_bytes()).hexdigest()
            except OSError as exc:
                errors.append(f"{package.id}: source file {source_path}: {exc}")
                continue
            if actual_hash != package.source.source_sha256:
                errors.append(
                    f"{package.id}: source hash drift: expected {package.source.source_sha256}, got {actual_hash}"
                )
            self.packages[package.id] = package
            for interface in package.interfaces:
                missing = set(interface.fact_refs) - set(self.fact_statuses)
                unconfirmed = {
                    fact_id for fact_id in interface.fact_refs
                    if fact_id in self.fact_statuses and self.fact_statuses[fact_id] != "confirmed"
                }
                if missing:
                    errors.append(f"{interface.id}: unknown fact refs: {sorted(missing)}")
                if unconfirmed:
                    errors.append(f"{interface.id}: fact refs are not confirmed: {sorted(unconfirmed)}")
                self.interfaces[interface.id] = interface

        for test_case in environment.test_cases:
            if test_case.package_ref not in self.packages:
                errors.append(f"{test_case.id}: unknown package {test_case.package_ref}")
            missing_interfaces = set(test_case.interface_refs) - set(self.interfaces)
            if missing_interfaces:
                errors.append(f"{test_case.id}: unknown interfaces: {sorted(missing_interfaces)}")
            wrong_package = {
                interface_id for interface_id in test_case.interface_refs
                if interface_id in self.interfaces
                and self.interfaces[interface_id].package_ref != test_case.package_ref
            }
            if wrong_package:
                errors.append(f"{test_case.id}: interfaces belong to another package: {sorted(wrong_package)}")
            if "DBMS_" in test_case.sql:
                errors.append(f"{test_case.id}: unsupported DBMS_ package must not appear in pilot SQL")
            if "adv_dbe_sql_register_context" in test_case.interface_refs:
                if "adv_dbe_sql_unregister_context" not in test_case.interface_refs:
                    errors.append(f"{test_case.id}: DBE_SQL context must be closed")
            self.test_cases[test_case.id] = test_case

        if errors:
            raise AdvancedPackageLoadError(errors)
        self.environment = environment

    def interfaces_for_package(self, package_id: str) -> List[AdvancedInterfaceDef]:
        return [item for item in self.interfaces.values() if item.package_ref == package_id]


class AdvancedPackagePlanner:
    """Return static runtime-candidate plans; execution evidence remains absent."""

    def __init__(self, registry: AdvancedPackageRegistry):
        self.registry = registry

    def plan_package(self, package_id: str) -> List[AdvancedPackageTestCaseDef]:
        if package_id not in self.registry.packages:
            raise ValueError(f"unknown advanced package: {package_id}")
        return [
            item for item in self.registry.test_cases.values()
            if item.package_ref == package_id
        ]

    def plan_interface(self, interface_id: str) -> str:
        interface = self.registry.interfaces[interface_id]
        if interface.execution_policy in {"manual_review", "blocked"}:
            raise ValueError(f"interface {interface.call_name} cannot be planned: {interface.execution_policy}")
        return interface.signature()
