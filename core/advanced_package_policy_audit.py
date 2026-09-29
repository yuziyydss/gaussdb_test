"""Coverage and policy audit for the eight advanced-package expansion contracts.

The audit is static only.  It compares the modeled inventory with an explicit
documented-interface coverage manifest and produces a fail-closed policy review.
It never changes execution policies and never claims database verification.
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import List, Literal, Optional

import yaml
from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from core.advanced_package import AdvancedPackageRegistry


AUDITED_PACKAGE_IDS = {
    "dbe_compression",
    "dbe_describe",
    "dbe_heat_map",
    "dbe_ilm",
    "dbe_ilm_admin",
    "dbe_stats",
    "dbe_xmldom",
    "dbe_xmlparser",
}


class StrictAdvancedPolicyAuditModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class AdvancedPolicyAuditSourceDef(StrictAdvancedPolicyAuditModel):
    interface_inventory_relpath: str
    interface_inventory_sha256: str
    coverage_inventory_relpath: str
    coverage_inventory_sha256: str
    policy_inventory_relpath: str
    policy_inventory_sha256: str

    @field_validator(
        "interface_inventory_relpath",
        "coverage_inventory_relpath",
        "policy_inventory_relpath",
    )
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("advanced policy audit source path must be safe")
        return value

    @field_validator(
        "interface_inventory_sha256",
        "coverage_inventory_sha256",
        "policy_inventory_sha256",
    )
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if re.fullmatch(r"[0-9a-f]{64}", value) is None:
            raise ValueError("advanced policy audit source SHA-256 must be 64 hex characters")
        return value


class AdvancedExpansionCoverageDef(StrictAdvancedPolicyAuditModel):
    package_id: str
    package_name: str
    coverage_scope: Literal["complete", "partial"]
    source_anchor: str
    documented_callable_count: int
    documented_type_count: int
    documented_signature_count: int
    modeled_signature_count: int
    missing_signature_count: int
    missing_interfaces: List[str]
    missing_overload_count: int
    notes: str

    @field_validator("package_id", "package_name", "source_anchor", "notes")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("advanced expansion coverage fields cannot be blank")
        return value

    @field_validator("missing_interfaces")
    @classmethod
    def ensure_unique_missing(cls, value: List[str]) -> List[str]:
        if len(value) != len(set(value)):
            raise ValueError("advanced expansion coverage missing interfaces cannot repeat")
        return value


class AdvancedPackageCoverageAuditDef(StrictAdvancedPolicyAuditModel):
    package_id: str
    package_name: str
    coverage_scope: Literal["complete", "partial"]
    source_anchor: str
    documented_callable_count: int
    documented_type_count: int
    modeled_callable_count: int
    modeled_type_count: int
    missing_callable_count: int
    documented_signature_count: int
    modeled_signature_count: int
    missing_signature_count: int
    missing_overload_count: int
    missing_interfaces: List[str]
    notes: str


class AdvancedInterfacePolicyDecisionDef(StrictAdvancedPolicyAuditModel):
    interface_id: str
    package_id: str
    call_name: str
    current_policy: Literal["static_probe", "runtime_candidate", "manual_review", "blocked"]
    recommended_policy: Literal["static_probe", "runtime_candidate", "manual_review", "blocked"]
    review_decision: Literal[
        "static_type_only",
        "promote_after_case_design",
        "keep_manual_review",
        "block_for_runtime_pilot",
    ]
    reasons: List[str]
    prerequisites: List[str]

    @model_validator(mode="after")
    def ensure_decision_shape(self) -> "AdvancedInterfacePolicyDecisionDef":
        expected = {
            "static_type_only": "static_probe",
            "promote_after_case_design": "runtime_candidate",
            "keep_manual_review": "manual_review",
            "block_for_runtime_pilot": "blocked",
        }[self.review_decision]
        if self.recommended_policy != expected:
            raise ValueError(f"interface {self.interface_id} review decision is inconsistent")
        if not self.reasons or not self.prerequisites:
            raise ValueError(f"interface {self.interface_id} needs reasons and prerequisites")
        return self


class AdvancedPolicyAuditSummaryDef(StrictAdvancedPolicyAuditModel):
    audited_package_count: int
    documented_callable_count: int
    modeled_callable_count: int
    documented_type_count: int
    modeled_type_count: int
    missing_callable_count: int
    documented_signature_count: int
    modeled_signature_count: int
    missing_signature_count: int
    missing_overload_count: int
    complete_package_count: int
    partial_package_count: int
    interface_decision_count: int
    static_type_count: int
    promote_after_case_design_count: int
    keep_manual_review_count: int
    block_for_runtime_pilot_count: int
    recommended_runtime_candidate_count: int
    recommended_blocked_count: int


class AdvancedPolicyAuditResultDef(StrictAdvancedPolicyAuditModel):
    schema_version: Literal[1] = 1
    kind: Literal["advanced_package_policy_audit"] = "advanced_package_policy_audit"
    id: str = "advanced_package_policy_audit_v1"
    name: str = "Advanced Package Expansion Coverage & Policy Audit"
    description: str = (
        "22包扩展后的8个新增包覆盖缺口与执行策略复审；不改inventory，不生成runtime SQL，不宣称实机验证。"
    )
    source: AdvancedPolicyAuditSourceDef
    packages: List[AdvancedPackageCoverageAuditDef]
    decisions: List[AdvancedInterfacePolicyDecisionDef]
    summary: AdvancedPolicyAuditSummaryDef
    next_actions: List[str] = Field(default_factory=lambda: [
        "Close documented signature gaps for DBE_STATS and DBE_XMLDOM before promotion.",
        "Design lifecycle cases for the 16 recommended runtime-candidate interfaces.",
        "Keep ILM policy and job interfaces out of the first authorized runtime batch.",
        "Add fixture, permission, GUC and cleanup requirements to every promoted case.",
    ])
    limits: List[str] = Field(default_factory=lambda: [
        "Coverage audit is based on explicit manifests and local reference facts.",
        "A recommended policy does not change the current execution policy.",
        "Static signature coverage does not prove database behavior.",
        "No runtime SQL is generated or executed by this audit.",
    ])

    @model_validator(mode="after")
    def ensure_audit_shape(self) -> "AdvancedPolicyAuditResultDef":
        package_ids = [item.package_id for item in self.packages]
        decision_ids = [item.interface_id for item in self.decisions]
        if len(package_ids) != len(set(package_ids)):
            raise ValueError("advanced policy audit package ids cannot repeat")
        if len(decision_ids) != len(set(decision_ids)):
            raise ValueError("advanced policy audit interface decisions cannot repeat")
        if set(package_ids) != AUDITED_PACKAGE_IDS:
            raise ValueError("advanced policy audit must audit exactly eight expansion packages")
        if self.summary.audited_package_count != len(self.packages):
            raise ValueError("advanced policy audit audited package count is inconsistent")
        if self.summary.complete_package_count != sum(item.coverage_scope == "complete" for item in self.packages):
            raise ValueError("advanced policy audit complete package count is inconsistent")
        if self.summary.partial_package_count != sum(item.coverage_scope == "partial" for item in self.packages):
            raise ValueError("advanced policy audit partial package count is inconsistent")
        if self.summary.documented_callable_count != sum(item.documented_callable_count for item in self.packages):
            raise ValueError("advanced policy audit documented callable count is inconsistent")
        if self.summary.modeled_callable_count != sum(item.modeled_callable_count for item in self.packages):
            raise ValueError("advanced policy audit modeled callable count is inconsistent")
        if self.summary.missing_callable_count != sum(item.missing_callable_count for item in self.packages):
            raise ValueError("advanced policy audit missing callable count is inconsistent")
        if self.summary.documented_signature_count != sum(item.documented_signature_count for item in self.packages):
            raise ValueError("advanced policy audit documented signature count is inconsistent")
        if self.summary.modeled_signature_count != sum(item.modeled_signature_count for item in self.packages):
            raise ValueError("advanced policy audit modeled signature count is inconsistent")
        if self.summary.missing_signature_count != sum(item.missing_signature_count for item in self.packages):
            raise ValueError("advanced policy audit missing signature count is inconsistent")
        if self.summary.missing_overload_count != self.summary.missing_signature_count:
            raise ValueError("advanced policy audit missing overload count is inconsistent")
        if self.summary.interface_decision_count != len(self.decisions):
            raise ValueError("advanced policy audit interface decision count is inconsistent")
        expected_decisions = {
            "static_type_count": "static_type_only",
            "promote_after_case_design_count": "promote_after_case_design",
            "keep_manual_review_count": "keep_manual_review",
            "block_for_runtime_pilot_count": "block_for_runtime_pilot",
        }
        for field_name, decision in expected_decisions.items():
            if getattr(self.summary, field_name) != sum(
                item.review_decision == decision for item in self.decisions
            ):
                raise ValueError(f"advanced policy audit {field_name} is inconsistent")
        if self.summary.recommended_runtime_candidate_count != sum(
            item.recommended_policy == "runtime_candidate" for item in self.decisions
        ):
            raise ValueError("advanced policy audit recommended runtime count is inconsistent")
        if self.summary.recommended_blocked_count != sum(
            item.recommended_policy == "blocked" for item in self.decisions
        ):
            raise ValueError("advanced policy audit recommended blocked count is inconsistent")
        return self


def _sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _load_yaml(path: Path) -> dict:
    value = yaml.safe_load(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"{path}: top-level YAML must be an object")
    return value


def build_advanced_package_policy_audit(root: Path) -> AdvancedPolicyAuditResultDef:
    root = Path(root)
    interface_path = root / "environments/advanced_packages_v1.yaml"
    coverage_path = root / "environments/advanced_package_expansion_coverage_v1.yaml"
    policy_path = root / "environments/advanced_package_policy_audit_v1.yaml"

    registry = AdvancedPackageRegistry(root)
    registry.load_all()
    coverage_payload = _load_yaml(coverage_path)
    policy_payload = _load_yaml(policy_path)

    coverage_packages = coverage_payload.get("packages", [])
    if len(coverage_packages) != len(AUDITED_PACKAGE_IDS) or {
        item.get("package_id") for item in coverage_packages
    } != AUDITED_PACKAGE_IDS:
        raise ValueError("coverage manifest must describe exactly eight expansion packages")

    runtime_ids = set(policy_payload.get("runtime_candidate_interfaces", []))
    blocked_ids = set(policy_payload.get("blocked_interfaces", []))
    static_ids = set(policy_payload.get("static_probe_interfaces", []))
    if runtime_ids & blocked_ids or runtime_ids & static_ids or blocked_ids & static_ids:
        raise ValueError("policy manifest categories must not overlap")

    packages: List[AdvancedPackageCoverageAuditDef] = []
    decisions: List[AdvancedInterfacePolicyDecisionDef] = []

    for coverage in coverage_packages:
        package_id = coverage["package_id"]
        interfaces = registry.interfaces_for_package(package_id)
        callable_interfaces = [item for item in interfaces if item.callable_kind != "collection_type"]
        type_interfaces = [item for item in interfaces if item.callable_kind == "collection_type"]
        modeled_callable_names = {item.call_name.split(".", 1)[1] for item in callable_interfaces}
        missing_manifest = list(coverage.get("missing_interfaces", []))
        if set(missing_manifest) & modeled_callable_names:
            raise ValueError(f"{package_id}: missing interfaces cannot also be modeled")
        documented_callable_count = int(coverage["documented_callable_count"])
        if int(coverage["modeled_signature_count"]) != len(callable_interfaces):
            raise ValueError(f"{package_id}: modeled signature count does not match inventory")
        expected_missing = documented_callable_count - len(modeled_callable_names)
        if len(missing_manifest) != expected_missing:
            raise ValueError(
                f"{package_id}: missing interface count is inconsistent: "
                f"manifest={len(missing_manifest)}, derived={expected_missing}"
            )
        if int(coverage["missing_signature_count"]) != int(coverage["documented_signature_count"]) - len(callable_interfaces):
            raise ValueError(f"{package_id}: missing signature count is inconsistent")

        packages.append(AdvancedPackageCoverageAuditDef(
            package_id=package_id,
            package_name=coverage["package_name"],
            coverage_scope=coverage["coverage_scope"],
            source_anchor=coverage["source_anchor"],
            documented_callable_count=coverage["documented_callable_count"],
            documented_type_count=coverage["documented_type_count"],
            modeled_callable_count=len(modeled_callable_names),
            modeled_type_count=len(type_interfaces),
            missing_callable_count=len(missing_manifest),
            documented_signature_count=int(coverage["documented_signature_count"]),
            modeled_signature_count=len(callable_interfaces),
            missing_signature_count=int(coverage["documented_signature_count"]) - len(callable_interfaces),
            missing_overload_count=int(coverage["missing_overload_count", 0] if False else coverage.get("missing_overload_count", 0)),
            missing_interfaces=missing_manifest,
            notes=coverage["notes"],
        ))

        package_reason = policy_payload.get("manual_review_reasons", {}).get(package_id)
        package_prerequisites = policy_payload.get("prerequisites", {}).get(package_id)
        if not package_reason or not package_prerequisites:
            raise ValueError(f"{package_id}: policy manifest needs reasons and prerequisites")
        for interface in interfaces:
            if interface.id in runtime_ids:
                review_decision = "promote_after_case_design"
                recommended_policy = "runtime_candidate"
                reasons = ["Documented effect is document-local or read-only.", "Safe only after a lifecycle case is designed."]
            elif interface.id in blocked_ids:
                review_decision = "block_for_runtime_pilot"
                recommended_policy = "blocked"
                reasons = ["Interface changes global ILM scheduling, policy state or creates jobs."]
            elif interface.id in static_ids:
                review_decision = "static_type_only"
                recommended_policy = "static_probe"
                reasons = ["Collection/type identity can be audited without a database call."]
            else:
                review_decision = "keep_manual_review"
                recommended_policy = "manual_review"
                reasons = [package_reason]
            decisions.append(AdvancedInterfacePolicyDecisionDef(
                interface_id=interface.id,
                package_id=package_id,
                call_name=interface.call_name,
                current_policy=interface.execution_policy,
                recommended_policy=recommended_policy,
                review_decision=review_decision,
                reasons=reasons,
                prerequisites=[package_prerequisites],
            ))

    runtime_interfaces = {item.interface_id for item in decisions if item.recommended_policy == "runtime_candidate"}
    blocked_interfaces = {item.interface_id for item in decisions if item.recommended_policy == "blocked"}
    static_interfaces = {item.interface_id for item in decisions if item.recommended_policy == "static_probe"}
    if runtime_interfaces != runtime_ids:
        raise ValueError("runtime-candidate policy manifest does not match modeled interfaces")
    if blocked_interfaces != blocked_ids:
        raise ValueError("blocked policy manifest does not match modeled interfaces")
    if static_interfaces != static_ids:
        raise ValueError("static-probe policy manifest does not match modeled interfaces")

    complete_count = sum(item.coverage_scope == "complete" for item in packages)
    return AdvancedPolicyAuditResultDef(
        source=AdvancedPolicyAuditSourceDef(
            interface_inventory_relpath="environments/advanced_packages_v1.yaml",
            interface_inventory_sha256=_sha256(interface_path),
            coverage_inventory_relpath="environments/advanced_package_expansion_coverage_v1.yaml",
            coverage_inventory_sha256=_sha256(coverage_path),
            policy_inventory_relpath="environments/advanced_package_policy_audit_v1.yaml",
            policy_inventory_sha256=_sha256(policy_path),
        ),
        packages=packages,
        decisions=decisions,
        summary=AdvancedPolicyAuditSummaryDef(
            audited_package_count=len(packages),
            documented_callable_count=sum(item.documented_callable_count for item in packages),
            modeled_callable_count=sum(item.modeled_callable_count for item in packages),
            documented_type_count=sum(item.documented_type_count for item in packages),
            modeled_type_count=sum(item.modeled_type_count for item in packages),
            missing_callable_count=sum(item.missing_callable_count for item in packages),
            documented_signature_count=sum(item.documented_signature_count for item in packages),
            modeled_signature_count=sum(item.modeled_signature_count for item in packages),
            missing_signature_count=sum(item.missing_signature_count for item in packages),
            missing_overload_count=sum(item.missing_signature_count for item in packages),
            complete_package_count=complete_count,
            partial_package_count=len(packages) - complete_count,
            interface_decision_count=len(decisions),
            static_type_count=sum(item.review_decision == "static_type_only" for item in decisions),
            promote_after_case_design_count=sum(item.review_decision == "promote_after_case_design" for item in decisions),
            keep_manual_review_count=sum(item.review_decision == "keep_manual_review" for item in decisions),
            block_for_runtime_pilot_count=sum(item.review_decision == "block_for_runtime_pilot" for item in decisions),
            recommended_runtime_candidate_count=len(runtime_interfaces),
            recommended_blocked_count=len(blocked_interfaces),
        ),
    )


class AdvancedPolicyAuditRegistry:
    """Build and verify the policy audit artifact against current inputs."""

    def __init__(self, root: Path):
        self.root = Path(root)

    def build(self) -> AdvancedPolicyAuditResultDef:
        return build_advanced_package_policy_audit(self.root)

    def verify(self) -> AdvancedPolicyAuditResultDef:
        path = self.root / "generated/advanced_package_pilot/policy_audit.json"
        if not path.is_file():
            raise ValueError("advanced package policy audit artifact is missing")
        try:
            recorded = AdvancedPolicyAuditResultDef(**json.loads(path.read_text(encoding="utf-8")))
        except Exception as exc:
            raise ValueError(f"advanced package policy audit artifact is invalid: {exc}") from exc
        current = self.build()
        if recorded.model_dump(mode="json") != current.model_dump(mode="json"):
            raise ValueError("advanced package policy audit artifact is stale")
        return recorded


def verify_advanced_package_policy_audit(root: Path) -> AdvancedPolicyAuditResultDef:
    return AdvancedPolicyAuditRegistry(Path(root)).verify()
