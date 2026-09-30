"""Inventory the complete GUC V2 evidence chain with file identity.

The bundle is an inventory, not a runtime claim.  It records which static,
preflight, and runtime artifacts exist and binds each present file to its
SHA-256 and size.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import List, Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, model_validator


class StrictGucEvidenceBundleModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucEvidenceArtifactDef(StrictGucEvidenceBundleModel):
    name: str
    path: str
    exists: bool
    sha256: Optional[str] = None
    size_bytes: Optional[int] = None

    @model_validator(mode="after")
    def ensure_identity_shape(self) -> "GucEvidenceArtifactDef":
        if self.exists and (self.sha256 is None or self.size_bytes is None):
            raise ValueError("present evidence artifact must have SHA-256 and size")
        if not self.exists and (self.sha256 is not None or self.size_bytes is not None):
            raise ValueError("missing evidence artifact cannot have SHA-256 or size")
        return self


class GucEvidenceLayerDef(StrictGucEvidenceBundleModel):
    name: Literal["static", "preflight", "runtime"]
    artifacts: List[str]
    present_count: int
    missing_count: int
    complete: bool

    @model_validator(mode="after")
    def ensure_layer_shape(self) -> "GucEvidenceLayerDef":
        if not self.artifacts or len(set(self.artifacts)) != len(self.artifacts):
            raise ValueError("evidence layer artifacts must be non-empty and unique")
        if self.present_count + self.missing_count != len(self.artifacts):
            raise ValueError("evidence layer counts do not match artifact list")
        if self.complete != (self.missing_count == 0):
            raise ValueError("evidence layer completion is inconsistent")
        return self


class GucEvidenceBundleSummaryDef(StrictGucEvidenceBundleModel):
    artifact_count: int
    present_count: int
    missing_count: int
    static_complete: bool
    preflight_complete: bool
    runtime_complete: bool
    all_complete: bool


class GucV2EvidenceBundleDef(StrictGucEvidenceBundleModel):
    schema_version: Literal[1] = 1
    kind: Literal["guc_v2_evidence_bundle"] = "guc_v2_evidence_bundle"
    id: str = "guc_v2_evidence_bundle_v1"
    name: str = "GaussDB GUC V2 Evidence Bundle"
    description: str = (
        "Inventory of GUC V2 static, preflight, and runtime evidence artifacts; "
        "presence is not runtime verification."
    )
    artifacts: List[GucEvidenceArtifactDef]
    layers: List[GucEvidenceLayerDef]
    summary: GucEvidenceBundleSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "Static evidence does not prove database behavior.",
        "A present preflight result does not authorize GUC changes.",
        "A present runtime receipt still requires independent audit.",
        "Missing runtime evidence means runtime behavior is not verified.",
    ])

    @model_validator(mode="after")
    def ensure_bundle_shape(self) -> "GucV2EvidenceBundleDef":
        names = [artifact.name for artifact in self.artifacts]
        if len(set(names)) != len(names):
            raise ValueError("evidence artifact names cannot repeat")
        layer_names = [name for layer in self.layers for name in layer.artifacts]
        if sorted(layer_names) != sorted(names):
            raise ValueError("evidence layers must cover every artifact exactly once")
        expected_present = sum(artifact.exists for artifact in self.artifacts)
        expected_missing = len(self.artifacts) - expected_present
        if self.summary.artifact_count != len(self.artifacts):
            raise ValueError("evidence artifact_count is inconsistent")
        if self.summary.present_count != expected_present:
            raise ValueError("evidence present_count is inconsistent")
        if self.summary.missing_count != expected_missing:
            raise ValueError("evidence missing_count is inconsistent")
        layer_by_name = {layer.name: layer for layer in self.layers}
        for layer in self.layers:
            expected_present = sum(
                artifact.exists
                for artifact in self.artifacts
                if artifact.name in layer.artifacts
            )
            expected_missing = len(layer.artifacts) - expected_present
            if layer.present_count != expected_present:
                raise ValueError(f"{layer.name} layer present_count is inconsistent")
            if layer.missing_count != expected_missing:
                raise ValueError(f"{layer.name} layer missing_count is inconsistent")
        if self.summary.static_complete != layer_by_name["static"].complete:
            raise ValueError("static_complete is inconsistent")
        if self.summary.preflight_complete != layer_by_name["preflight"].complete:
            raise ValueError("preflight_complete is inconsistent")
        if self.summary.runtime_complete != layer_by_name["runtime"].complete:
            raise ValueError("runtime_complete is inconsistent")
        expected_all = (
            layer_by_name["static"].complete
            and layer_by_name["preflight"].complete
            and layer_by_name["runtime"].complete
        )
        if self.summary.all_complete != expected_all:
            raise ValueError("all_complete is inconsistent")
        return self


ARTIFACT_PATHS = {
    "environment_v2": "environments/guc_parameters_v2.yaml",
    "reference_catalog": "generated/guc_reference_catalog/catalog.json",
    "candidate_matrix": "generated/guc_candidate_matrix/matrix.json",
    "overlay_plans": "generated/guc_environment_v2/overlay_plans.json",
    "overlay_plans_sql": "generated/guc_environment_v2/overlay_plans.sql",
    "capability_matrix": "generated/guc_environment_v2/capability_matrix.json",
    "requirement_adapter": "generated/guc_environment_v2/requirement_adapter.json",
    "preflight_plan": "generated/guc_environment_v2/preflight_plan.json",
    "preflight_result": "generated/guc_environment_v2/preflight_result.json",
    "preflight_audit": "generated/guc_environment_v2/preflight_audit.json",
    "runtime_dry_run": "generated/guc_environment_v2/runtime_dry_run.json",
    "runtime_receipt": "generated/guc_environment_v2/runtime_receipt.json",
    "runtime_receipt_audit": "generated/guc_environment_v2/runtime_receipt_audit.json",
    "readiness": "generated/guc_environment_v2/readiness.json",
    "static_audit": "generated/guc_environment_v2/audit.json",
}

LAYER_ARTIFACTS = {
    "static": [
        "environment_v2",
        "reference_catalog",
        "candidate_matrix",
        "overlay_plans",
        "overlay_plans_sql",
        "capability_matrix",
        "requirement_adapter",
        "preflight_plan",
        "runtime_dry_run",
        "readiness",
        "static_audit",
    ],
    "preflight": [
        "preflight_result",
        "preflight_audit",
    ],
    "runtime": [
        "runtime_receipt",
        "runtime_receipt_audit",
    ],
}


def _artifact(root: Path, name: str, relpath: str) -> GucEvidenceArtifactDef:
    path = root / relpath
    if not path.is_file():
        return GucEvidenceArtifactDef(
            name=name,
            path=relpath,
            exists=False,
        )
    content = path.read_bytes()
    return GucEvidenceArtifactDef(
        name=name,
        path=relpath,
        exists=True,
        sha256=hashlib.sha256(content).hexdigest(),
        size_bytes=len(content),
    )


class GucV2EvidenceBundleVerificationResultDef(StrictGucEvidenceBundleModel):
    kind: Literal["guc_v2_evidence_bundle_verification"] = "guc_v2_evidence_bundle_verification"
    schema_version: Literal[1] = 1
    valid: bool
    errors: List[str] = Field(default_factory=list)
    recorded_summary: GucEvidenceBundleSummaryDef
    current_summary: GucEvidenceBundleSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "Verification checks file identity and inventory consistency only.",
        "It does not prove database behavior or runtime execution.",
        "A valid bundle still requires independent preflight and runtime audits.",
    ])


def verify_guc_v2_evidence_bundle(root: Path) -> GucV2EvidenceBundleVerificationResultDef:
    root = Path(root)
    bundle_path = root / "generated/guc_environment_v2/evidence_bundle.json"
    try:
        raw = json.loads(bundle_path.read_text(encoding="utf-8"))
        recorded = GucV2EvidenceBundleDef(**raw)
    except FileNotFoundError:
        return GucV2EvidenceBundleVerificationResultDef(
            valid=False,
            errors=[f"evidence bundle not found: {bundle_path}"],
            recorded_summary=GucEvidenceBundleSummaryDef(
                artifact_count=0,
                present_count=0,
                missing_count=0,
                static_complete=False,
                preflight_complete=False,
                runtime_complete=False,
                all_complete=False,
            ),
            current_summary=GucEvidenceBundleSummaryDef(
                artifact_count=0,
                present_count=0,
                missing_count=0,
                static_complete=False,
                preflight_complete=False,
                runtime_complete=False,
                all_complete=False,
            ),
        )
    except Exception as exc:
        return GucV2EvidenceBundleVerificationResultDef(
            valid=False,
            errors=[f"evidence bundle is invalid: {exc}"],
            recorded_summary=GucEvidenceBundleSummaryDef(
                artifact_count=0,
                present_count=0,
                missing_count=0,
                static_complete=False,
                preflight_complete=False,
                runtime_complete=False,
                all_complete=False,
            ),
            current_summary=GucEvidenceBundleSummaryDef(
                artifact_count=0,
                present_count=0,
                missing_count=0,
                static_complete=False,
                preflight_complete=False,
                runtime_complete=False,
                all_complete=False,
            ),
        )

    current = build_guc_v2_evidence_bundle(root)
    errors: List[str] = []
    recorded_by_name = {artifact.name: artifact for artifact in recorded.artifacts}
    current_by_name = {artifact.name: artifact for artifact in current.artifacts}

    if set(recorded_by_name) != set(current_by_name):
        errors.append("evidence artifact name set drift")

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

    return GucV2EvidenceBundleVerificationResultDef(
        valid=not errors,
        errors=errors,
        recorded_summary=recorded.summary,
        current_summary=current.summary,
    )


def build_guc_v2_evidence_bundle(root: Path) -> GucV2EvidenceBundleDef:
    root = Path(root)
    artifacts = [
        _artifact(root, name, relpath)
        for name, relpath in ARTIFACT_PATHS.items()
    ]
    artifact_by_name = {artifact.name: artifact for artifact in artifacts}
    layers: List[GucEvidenceLayerDef] = []
    for layer_name, names in LAYER_ARTIFACTS.items():
        present = sum(artifact_by_name[name].exists for name in names)
        missing = len(names) - present
        layers.append(GucEvidenceLayerDef(
            name=layer_name,
            artifacts=names,
            present_count=present,
            missing_count=missing,
            complete=missing == 0,
        ))
    layer_by_name = {layer.name: layer for layer in layers}
    present_count = sum(artifact.exists for artifact in artifacts)
    missing_count = len(artifacts) - present_count
    return GucV2EvidenceBundleDef(
        artifacts=artifacts,
        layers=layers,
        summary=GucEvidenceBundleSummaryDef(
            artifact_count=len(artifacts),
            present_count=present_count,
            missing_count=missing_count,
            static_complete=layer_by_name["static"].complete,
            preflight_complete=layer_by_name["preflight"].complete,
            runtime_complete=layer_by_name["runtime"].complete,
            all_complete=all(layer.complete for layer in layers),
        ),
    )
