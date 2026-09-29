#!/usr/bin/env python3
"""Rebuild the complete static GUC V2 evidence chain in one command."""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_audit import build_guc_v2_audit
from core.guc_candidate import GucCandidateRegistry
from core.guc_capability import GucCapabilityRegistry
from core.guc_requirement_adapter import GucRequirementAdapterRegistry
from core.guc_evidence_bundle import build_guc_v2_evidence_bundle
from core.guc_plan_export import GucOverlayPlanExportRegistry
from core.guc_preflight import GucV2PreflightRegistry
from core.guc_readiness import GucV2ReadinessRegistry
from core.guc_reference import GucReferenceRegistry
from core.guc_runtime_pilot import GucV2RuntimePilotRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--check",
        action="store_true",
        help="rebuild the static chain and fail if any artifact hash changes",
    )
    return parser.parse_args(argv)


STATIC_CHAIN_ARTIFACTS = {
    "reference_catalog": "generated/guc_reference_catalog/catalog.json",
    "candidate_matrix": "generated/guc_candidate_matrix/matrix.json",
    "overlay_plans": "generated/guc_environment_v2/overlay_plans.json",
    "overlay_plans_sql": "generated/guc_environment_v2/overlay_plans.sql",
    "capability_matrix": "generated/guc_environment_v2/capability_matrix.json",
    "requirement_adapter": "generated/guc_environment_v2/requirement_adapter.json",
    "preflight_plan": "generated/guc_environment_v2/preflight_plan.json",
    "runtime_dry_run": "generated/guc_environment_v2/runtime_dry_run.json",
    "static_audit": "generated/guc_environment_v2/audit.json",
    "readiness": "generated/guc_environment_v2/readiness.json",
    "evidence_bundle": "generated/guc_environment_v2/evidence_bundle.json",
}


def _static_chain_hashes(root: Path):
    hashes = {}
    for name, relpath in STATIC_CHAIN_ARTIFACTS.items():
        path = root / relpath
        if not path.is_file():
            hashes[name] = None
        else:
            hashes[name] = hashlib.sha256(path.read_bytes()).hexdigest()
    return hashes


def _write_json(path: Path, payload) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def main(argv=None) -> int:
    args = parse_args(argv)
    root = args.root

    steps = [
        ("reference_catalog", lambda: GucReferenceRegistry(root).write()),
        ("candidate_matrix", lambda: GucCandidateRegistry(root).write()),
        ("overlay_plans", lambda: GucOverlayPlanExportRegistry(root).write()),
        ("capability_matrix", lambda: GucCapabilityRegistry(root).write()),
        ("requirement_adapter", lambda: GucRequirementAdapterRegistry(root).write()),
        ("preflight_plan", lambda: GucV2PreflightRegistry(root).write()),
        (
            "runtime_dry_run",
            lambda: GucV2RuntimePilotRegistry(root).write(
                root / "generated/guc_environment_v2/runtime_dry_run.json"
            ),
        ),
        (
            "static_audit",
            lambda: _write_json(
                root / "generated/guc_environment_v2/audit.json",
                build_guc_v2_audit(root).model_dump(),
            ),
        ),
        ("readiness", lambda: GucV2ReadinessRegistry(root).write()),
        (
            "evidence_bundle",
            lambda: _write_json(
                root / "generated/guc_environment_v2/evidence_bundle.json",
                build_guc_v2_evidence_bundle(root).model_dump(),
            ),
        ),
    ]

    before = _static_chain_hashes(root) if args.check else None

    for name, build_step in steps:
        print(f"building {name}...")
        build_step()

    bundle = build_guc_v2_evidence_bundle(root)
    summary = bundle.summary
    print(
        "GUC V2 static chain rebuilt: "
        f"artifacts={summary.artifact_count} present={summary.present_count} "
        f"missing={summary.missing_count} static={summary.static_complete} "
        f"preflight={summary.preflight_complete} runtime={summary.runtime_complete}"
    )
    if args.check:
        after = _static_chain_hashes(root)
        drift = {
            name: (before[name], after[name])
            for name in STATIC_CHAIN_ARTIFACTS
            if before[name] != after[name]
        }
        if drift:
            print("GUC V2 static chain check failed: artifact hash drift detected")
            for name, (old_hash, new_hash) in drift.items():
                print(f"  {name}: {old_hash} -> {new_hash}")
            return 1
        print("GUC V2 static chain check passed: all artifact hashes are stable")

    return 0 if summary.static_complete else 1


if __name__ == "__main__":
    raise SystemExit(main())
