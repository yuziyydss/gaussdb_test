"""Evidence bundle for the Advanced Package Pilot V1.

The bundle inventories what already exists and what is still missing.  It does
not turn static interface contracts into runtime verification.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Dict, List, Literal, Optional, Set

import yaml
from pydantic import BaseModel, ConfigDict, Field, model_validator

from core.advanced_package import AdvancedPackageRegistry
from core.advanced_package_runtime_preflight import (
    AdvancedPreflightAuditResultDef,
    AdvancedPackageRuntimePreflightResultDef,
    AdvancedRuntimePreflightPlanDef,
    audit_advanced_package_runtime_preflight_result,
)


class StrictAdvancedEvidenceModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class AdvancedEvidenceArtifactDef(StrictAdvancedEvidenceModel):
    name: str
    path: str
    exists: bool
    sha256: Optional[str] = None
    size_bytes: Optional[int] = None

    @model_validator(mode="after")
    def ensure_identity_shape(self) -> "AdvancedEvidenceArtifactDef":
        if self.exists and (self.sha256 is None or self.size_bytes is None):
            raise ValueError("present advanced evidence artifact must have SHA-256 and size")
        if not self.exists and (self.sha256 is not None or self.size_bytes is not None):
            raise ValueError("missing advanced evidence artifact cannot have SHA-256 or size")
        return self


class AdvancedEvidenceRuntimeUnitDef(StrictAdvancedEvidenceModel):
    id: str
    interface_refs: List[str]
    step_count: int
    oracle_status: str
    database_executed: bool
    runtime_verified: bool


class AdvancedEvidenceRuntimeDryRunDef(StrictAdvancedEvidenceModel):
    units: List[AdvancedEvidenceRuntimeUnitDef]
    unit_count: int
    step_count: int
    unit_ids: List[str]
    case_ids: List[str]
    interface_ids: List[str]

    @model_validator(mode="after")
    def ensure_runtime_shape(self) -> "AdvancedEvidenceRuntimeDryRunDef":
        if self.unit_count != len(self.unit_ids) or len(set(self.unit_ids)) != len(self.unit_ids):
            raise ValueError("advanced runtime unit_count is inconsistent")
        if self.interface_ids != sorted({
            interface_id
            for unit in self.units
            for interface_id in unit.interface_refs
        }):
            raise ValueError("advanced runtime interface_ids are inconsistent")
        return self


class AdvancedEvidenceSummaryDef(StrictAdvancedEvidenceModel):
    artifact_count: int
    present_count: int
    missing_count: int
    package_count: int
    supported_package_count: int
    unmodeled_supported_package_count: int
    interface_count: int
    runtime_candidate_interface_count: int
    manual_review_interface_count: int
    static_probe_interface_count: int
    test_case_count: int
    runtime_case_interface_count: int
    uncovered_runtime_candidate_interface_count: int
    runtime_candidate_case_coverage_complete: bool
    runtime_dry_run_advanced_unit_count: int
    runtime_dry_run_advanced_step_count: int
    preflight_plan_present: bool
    preflight_result_present: bool
    preflight_audit_present: bool
    preflight_plan_valid: bool
    preflight_result_valid: bool
    preflight_audit_valid: bool
    preflight_connected: bool
    preflight_metadata_read: bool
    preflight_finding_count: int
    preflight_ready: bool
    static_complete: bool
    runtime_complete: bool
    all_complete: bool


class AdvancedEvidenceBundleDef(StrictAdvancedEvidenceModel):
    schema_version: Literal[1] = 1
    kind: Literal["advanced_package_evidence_bundle"] = "advanced_package_evidence_bundle"
    id: str = "advanced_package_evidence_bundle_v1"
    name: str = "GaussDB Advanced Package Pilot Evidence Bundle"
    description: str = (
        "22个高级包接口合同、77个runtime candidate、runtime dry run和preflight证据清单；不宣称实机验证。"
    )
    artifacts: List[AdvancedEvidenceArtifactDef]
    unmodeled_supported_package_ids: List[str]
    runtime_dry_run: AdvancedEvidenceRuntimeDryRunDef
    uncovered_runtime_candidate_interface_ids: List[str]
    summary: AdvancedEvidenceSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "Static interface contracts do not prove database behavior.",
        "A present runtime dry-run is not a runtime receipt.",
        "Uncovered runtime-candidate interfaces require separate case design.",
        "Missing runtime receipt/audit means runtime behavior is not verified.",
        "Oracle status remains needs_verification until actual database evidence exists.",
        "Missing or failed preflight blocks authorized runtime execution.",
    ])

    @model_validator(mode="after")
    def ensure_bundle_shape(self) -> "AdvancedEvidenceBundleDef":
        names = [item.name for item in self.artifacts]
        if len(set(names)) != len(names):
            raise ValueError("advanced evidence artifact names cannot repeat")
        expected_present = sum(artifact.exists for artifact in self.artifacts)
        expected_missing = len(self.artifacts) - expected_present
        if self.summary.artifact_count != len(self.artifacts):
            raise ValueError("advanced evidence artifact_count is inconsistent")
        if self.summary.present_count != expected_present:
            raise ValueError("advanced evidence present_count is inconsistent")
        if self.summary.missing_count != len(self.artifacts) - expected_present:
            raise ValueError("advanced evidence missing_count is inconsistent")
        if self.summary.package_count != 22:
            raise ValueError("advanced evidence bundle is bound to the twenty-two-package Pilot V1 scope")
        if self.summary.supported_package_count < self.summary.package_count:
            raise ValueError("supported package count cannot be below modeled pilot package count")
        if self.summary.unmodeled_supported_package_count != (
            self.summary.supported_package_count - self.summary.package_count
        ):
            raise ValueError("unmodeled supported package count is inconsistent")
        if self.summary.static_complete != (expected_missing == 4 and expected_present == 4):
            raise ValueError("advanced static_complete is inconsistent")
        expected_runtime = expected_present == 8 and expected_missing == 0 and self.summary.preflight_ready
        if self.summary.runtime_complete != expected_runtime:
            raise ValueError("advanced runtime_complete is inconsistent")
        if self.summary.runtime_candidate_case_coverage_complete != (
            self.summary.uncovered_runtime_candidate_interface_count == 0
        ):
            raise ValueError("advanced runtime candidate coverage is inconsistent")
        if self.summary.all_complete != (self.summary.static_complete and self.summary.runtime_complete):
            raise ValueError("advanced all_complete is inconsistent")
        return self


class AdvancedEvidenceVerificationResultDef(StrictAdvancedEvidenceModel):
    kind: Literal["advanced_package_evidence_bundle_verification"] = "advanced_package_evidence_bundle_verification"
    schema_version: Literal[1] = 1
    valid: bool
    errors: List[str] = Field(default_factory=list)
    recorded_summary: AdvancedEvidenceSummaryDef
    current_summary: AdvancedEvidenceSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "Verification checks file identity and inventory consistency only.",
        "It does not execute SQL or prove advanced package behavior.",
        "Runtime verification still requires receipt and receipt audit.",
    ])


ARTIFACT_PATHS = {
    "interface_inventory": "environments/advanced_packages_v1.yaml",
    "candidate_matrix": "generated/advanced_package_pilot/candidate_matrix.json",
    "runtime_dry_run": "generated/runtime_validation_pilot/dry_run.json",
    "runtime_preflight_plan": "generated/advanced_package_pilot/runtime_preflight_plan.json",
    "runtime_preflight_result": "generated/advanced_package_pilot/runtime_preflight_result.json",
    "runtime_preflight_audit": "generated/advanced_package_pilot/runtime_preflight_audit.json",
    "runtime_receipt": "generated/runtime_validation_pilot/receipt.json",
    "runtime_receipt_audit": "generated/runtime_validation_pilot/receipt_audit.json",
}


def _artifact(root: Path, name: str, relpath: str) -> AdvancedEvidenceArtifactDef:
    path = root / relpath
    if not path.is_file():
        return AdvancedEvidenceArtifactDef(name=name, path=relpath, exists=False)
    content = path.read_bytes()
    return AdvancedEvidenceArtifactDef(
        name=name,
        path=relpath,
        exists=True,
        sha256=hashlib.sha256(content).hexdigest(),
        size_bytes=len(content),
    )


def _supported_package_ids(root: Path) -> Set[str]:
    path = root / "docs/compat_facts/oracle_advanced_packages.yaml"
    payload = yaml.safe_load(path.read_text(encoding="utf-8"))
    return {
        item["id"].removeprefix("ora_pkg_")
        for item in payload.get("facts", [])
        if item.get("id", "").startswith("ora_pkg_dbe_")
    }


def _runtime_dry_run(root: Path, registry: AdvancedPackageRegistry):
    path = root / "generated/runtime_validation_pilot/dry_run.json"
    payload = json.loads(path.read_text(encoding="utf-8"))
    units = [unit for unit in payload.get("units", []) if unit.get("kind") == "advanced_package"]
    runtime_units = [
        AdvancedEvidenceRuntimeUnitDef(
            id=unit["id"],
            interface_refs=list(unit.get("interface_refs", [])),
            step_count=len(unit.get("execution_plan", [])),
            oracle_status=unit.get("oracle", {}).get("status", ""),
            database_executed=bool(unit.get("database_executed", False)),
            runtime_verified=bool(unit.get("runtime_verified", False)),
        )
        for unit in units
    ]
    return AdvancedEvidenceRuntimeDryRunDef(
        units=runtime_units,
        unit_count=len(runtime_units),
        step_count=sum(unit.step_count for unit in runtime_units),
        unit_ids=sorted(unit.id for unit in runtime_units),
        case_ids=sorted(registry.test_cases),
        interface_ids=sorted({
            interface_id
            for unit in runtime_units
            for interface_id in unit.interface_refs
        }),
    ), runtime_units


def _preflight_state(root: Path) -> Dict[str, object]:
    plan_path = root / ARTIFACT_PATHS["runtime_preflight_plan"]
    result_path = root / ARTIFACT_PATHS["runtime_preflight_result"]
    audit_path = root / ARTIFACT_PATHS["runtime_preflight_audit"]
    state = {
        "preflight_plan_valid": False,
        "preflight_result_valid": False,
        "preflight_audit_valid": False,
        "preflight_connected": False,
        "preflight_metadata_read": False,
        "preflight_finding_count": 0,
    }
    plan = None
    result = None
    try:
        plan = AdvancedRuntimePreflightPlanDef(**json.loads(plan_path.read_text(encoding="utf-8")))
        state["preflight_plan_valid"] = True
    except Exception:
        return state

    if result_path.is_file():
        try:
            result = AdvancedPackageRuntimePreflightResultDef(**json.loads(result_path.read_text(encoding="utf-8")))
            state["preflight_result_valid"] = True
            state["preflight_connected"] = result.connected
            state["preflight_metadata_read"] = result.metadata_read
            state["preflight_finding_count"] = result.summary.finding_count
        except Exception:
            state["preflight_result_valid"] = False

    if result is not None and audit_path.is_file():
        try:
            recorded_audit = AdvancedPreflightAuditResultDef(**json.loads(audit_path.read_text(encoding="utf-8")))
            expected_audit = audit_advanced_package_runtime_preflight_result(result, plan=plan)
            state["preflight_audit_valid"] = bool(
                recorded_audit.valid
                and recorded_audit.plan_verified
                and recorded_audit.model_dump(mode="json") == expected_audit.model_dump(mode="json")
            )
        except Exception:
            state["preflight_audit_valid"] = False
    return state


def build_advanced_package_evidence_bundle(root: Path) -> AdvancedEvidenceBundleDef:
    root = Path(root)
    registry = AdvancedPackageRegistry(root)
    registry.load_all()

    artifacts = [
        _artifact(root, name, relpath)
        for name, relpath in ARTIFACT_PATHS.items()
    ]
    artifact_by_name = {item.name: item for item in artifacts}
    runtime, runtime_units = _runtime_dry_run(root, registry)
    runtime_candidate_interface_ids = sorted(
        interface.id
        for package in registry.environment.packages
        for interface in package.interfaces
        if interface.execution_policy == "runtime_candidate"
    )
    runtime_case_interface_ids = sorted({
        interface_id
        for unit in runtime_units
        for interface_id in unit.interface_refs
    })
    uncovered_runtime_candidate_interface_ids = sorted(
        set(runtime_candidate_interface_ids) - set(runtime_case_interface_ids)
    )

    interface_policies = [
        interface.execution_policy
        for package in registry.environment.packages
        for interface in package.interfaces
    ]
    policy_counts: Dict[str, int] = {}
    for policy in interface_policies:
        policy_counts[policy] = policy_counts.get(policy, 0) + 1

    supported_ids = _supported_package_ids(root)
    modeled_ids = {package.id for package in registry.environment.packages}
    unmodeled_ids = sorted(supported_ids - modeled_ids)

    preflight_state = _preflight_state(root)
    static_complete = (
        artifact_by_name["interface_inventory"].exists
        and artifact_by_name["runtime_dry_run"].exists
        and artifact_by_name["runtime_preflight_plan"].exists
        and runtime.unit_count == len(registry.test_cases)
        and set(runtime.case_ids).issuperset(runtime.unit_ids)
        and all(not unit.database_executed and not unit.runtime_verified for unit in runtime_units)
    )
    runtime_complete = all(
        artifact_by_name[name].exists
        for name in ("interface_inventory", "runtime_dry_run", "runtime_receipt", "runtime_receipt_audit")
    )

    return AdvancedEvidenceBundleDef(
        artifacts=artifacts,
        unmodeled_supported_package_ids=unmodeled_ids,
        runtime_dry_run=runtime,
        uncovered_runtime_candidate_interface_ids=uncovered_runtime_candidate_interface_ids,
        summary=AdvancedEvidenceSummaryDef(
            artifact_count=len(artifacts),
            present_count=sum(artifact.exists for artifact in artifacts),
            missing_count=sum(not artifact.exists for artifact in artifacts),
            package_count=len(registry.environment.packages),
            supported_package_count=len(supported_ids),
            unmodeled_supported_package_count=len(unmodeled_ids),
            interface_count=len(registry.interfaces),
            runtime_candidate_interface_count=policy_counts.get("runtime_candidate", 0),
            manual_review_interface_count=policy_counts.get("manual_review", 0),
            static_probe_interface_count=policy_counts.get("static_probe", 0),
            test_case_count=len(registry.test_cases),
            runtime_case_interface_count=len(runtime_case_interface_ids),
            uncovered_runtime_candidate_interface_count=len(uncovered_runtime_candidate_interface_ids),
            runtime_candidate_case_coverage_complete=not uncovered_runtime_candidate_interface_ids,
            runtime_dry_run_advanced_unit_count=runtime.unit_count,
            runtime_dry_run_advanced_step_count=runtime.step_count,
            preflight_plan_present=artifact_by_name["runtime_preflight_plan"].exists,
            preflight_result_present=artifact_by_name["runtime_preflight_result"].exists,
            preflight_audit_present=artifact_by_name["runtime_preflight_audit"].exists,
            preflight_plan_valid=preflight_state["preflight_plan_valid"],
            preflight_result_valid=preflight_state["preflight_result_valid"],
            preflight_audit_valid=preflight_state["preflight_audit_valid"],
            preflight_connected=preflight_state["preflight_connected"],
            preflight_metadata_read=preflight_state["preflight_metadata_read"],
            preflight_finding_count=preflight_state["preflight_finding_count"],
            preflight_ready=all([
                preflight_state["preflight_plan_valid"],
                preflight_state["preflight_result_valid"],
                preflight_state["preflight_audit_valid"],
                preflight_state["preflight_connected"],
                preflight_state["preflight_metadata_read"],
                preflight_state["preflight_finding_count"] == 0,
            ]),
            static_complete=static_complete,
            runtime_complete=runtime_complete,
            all_complete=static_complete and runtime_complete,
        ),
    )


class AdvancedEvidenceBundleRegistry:
    """Build, persist, and reload the Advanced Package evidence bundle."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.bundle_path = self.root / "generated/advanced_package_pilot/evidence_bundle.json"

    def build(self) -> AdvancedEvidenceBundleDef:
        return build_advanced_package_evidence_bundle(self.root)

    def write(self, output: Optional[Path] = None) -> Path:
        output = Path(output or self.bundle_path)
        bundle = self.build()
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(
            json.dumps(bundle.model_dump(mode="json"), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return output


def verify_advanced_package_evidence_bundle(root: Path) -> AdvancedEvidenceVerificationResultDef:
    root = Path(root)
    bundle_path = root / "generated/advanced_package_pilot/evidence_bundle.json"
    try:
        raw = json.loads(bundle_path.read_text(encoding="utf-8"))
        recorded = AdvancedEvidenceBundleDef(**raw)
    except FileNotFoundError:
        empty_summary = AdvancedEvidenceSummaryDef(
            artifact_count=0,
            present_count=0,
            missing_count=0,
            package_count=0,
            runtime_case_interface_count=0,
            uncovered_runtime_candidate_interface_count=0,
            runtime_candidate_case_coverage_complete=False,
            supported_package_count=0,
            unmodeled_supported_package_count=0,
            interface_count=0,
            runtime_candidate_interface_count=0,
            manual_review_interface_count=0,
            static_probe_interface_count=0,
            test_case_count=0,
            runtime_dry_run_advanced_unit_count=0,
            runtime_dry_run_advanced_step_count=0,
            preflight_plan_present=False,
            preflight_result_present=False,
            preflight_audit_present=False,
            preflight_plan_valid=False,
            preflight_result_valid=False,
            preflight_audit_valid=False,
            preflight_connected=False,
            preflight_metadata_read=False,
            preflight_finding_count=0,
            preflight_ready=False,
            static_complete=False,
            runtime_complete=False,
            all_complete=False,
        )
        return AdvancedEvidenceVerificationResultDef(
            valid=False,
            errors=[f"evidence bundle not found: {bundle_path}"],
            recorded_summary=empty_summary,
            current_summary=empty_summary,
        )
    except Exception as exc:
        empty_summary = AdvancedEvidenceSummaryDef(
            artifact_count=0,
            present_count=0,
            missing_count=0,
            package_count=0,
            runtime_case_interface_count=0,
            uncovered_runtime_candidate_interface_count=0,
            runtime_candidate_case_coverage_complete=False,
            supported_package_count=0,
            unmodeled_supported_package_count=0,
            interface_count=0,
            runtime_candidate_interface_count=0,
            manual_review_interface_count=0,
            static_probe_interface_count=0,
            test_case_count=0,
            runtime_dry_run_advanced_unit_count=0,
            runtime_dry_run_advanced_step_count=0,
            preflight_plan_present=False,
            preflight_result_present=False,
            preflight_audit_present=False,
            preflight_plan_valid=False,
            preflight_result_valid=False,
            preflight_audit_valid=False,
            preflight_connected=False,
            preflight_metadata_read=False,
            preflight_finding_count=0,
            preflight_ready=False,
            static_complete=False,
            runtime_complete=False,
            all_complete=False,
        )
        return AdvancedEvidenceVerificationResultDef(
            valid=False,
            errors=[f"evidence bundle is invalid: {exc}"],
            recorded_summary=empty_summary,
            current_summary=empty_summary,
        )

    current = build_advanced_package_evidence_bundle(root)
    errors: List[str] = []
    recorded_by_name = {item.name: item for item in recorded.artifacts}
    current_by_name = {item.name: item for item in current.artifacts}
    if set(recorded_by_name) != set(current_by_name):
        errors.append("advanced evidence artifact name set drift")
    for name in sorted(set(recorded_by_name) & set(current_by_name)):
        recorded_artifact = recorded_by_name[name]
        current_artifact = current_by_name[name]
        if recorded_artifact.path != current_artifact.path:
            errors.append(f"{name}: path drift")
        if recorded_artifact.exists != current_artifact.exists:
            errors.append(f"{name}: existence drift")
        if recorded_artifact.exists and recorded_artifact.sha256 != current_artifact.sha256:
            errors.append(f"{name}: SHA-256 drift")
        if recorded_artifact.exists and recorded_artifact.size_bytes != current_artifact.size_bytes:
            errors.append(f"{name}: size drift")
    if recorded.summary != current.summary:
        errors.append("summary drift")
    return AdvancedEvidenceVerificationResultDef(
        valid=not errors,
        errors=errors,
        recorded_summary=recorded.summary,
        current_summary=current.summary,
    )
