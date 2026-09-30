#!/usr/bin/env python3
"""Rebuild and verify the Advanced Package static evidence chain."""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.advanced_package_evidence import (
    AdvancedEvidenceBundleRegistry,
    build_advanced_package_evidence_bundle,
)
from core.advanced_package_candidate import build_advanced_package_candidate_matrix
from core.advanced_package_policy_audit import AdvancedPolicyAuditRegistry
from core.advanced_package_runtime_preflight import AdvancedRuntimePreflightRegistry
from core.runtime_validation_pilot import build_dry_run, plan_sha256


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--check",
        action="store_true",
        help="rebuild the static chain and fail if any artifact hash changes",
    )
    return parser.parse_args(argv)


ADVANCED_PACKAGE_CHAIN_ARTIFACTS = {
    "candidate_matrix": "generated/advanced_package_pilot/candidate_matrix.json",
    "policy_audit": "generated/advanced_package_pilot/policy_audit.json",
    "runtime_dry_run": "generated/runtime_validation_pilot/dry_run.json",
    "runtime_preflight_plan": "generated/advanced_package_pilot/runtime_preflight_plan.json",
    "evidence_bundle": "generated/advanced_package_pilot/evidence_bundle.json",
}


def _chain_hashes(root: Path):
    return {
        name: (
            hashlib.sha256((root / relpath).read_bytes()).hexdigest()
            if (root / relpath).is_file()
            else None
        )
        for name, relpath in ADVANCED_PACKAGE_CHAIN_ARTIFACTS.items()
    }


def _write_json(path: Path, payload) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def main(argv=None) -> int:
    args = parse_args(argv)
    root = args.root

    before = _chain_hashes(root) if args.check else None

    print("building candidate_matrix...")
    candidate_matrix = build_advanced_package_candidate_matrix(root)
    _write_json(
        root / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["candidate_matrix"],
        candidate_matrix.model_dump(mode="json"),
    )

    print("building policy_audit...")
    policy_audit = AdvancedPolicyAuditRegistry(root).build()
    _write_json(
        root / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["policy_audit"],
        policy_audit.model_dump(mode="json"),
    )

    print("building runtime_dry_run...")
    runtime = build_dry_run(root)
    runtime_payload = runtime.model_dump(mode="json")
    runtime_payload["plan_sha256"] = plan_sha256(runtime)
    runtime_path = root / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["runtime_dry_run"]
    _write_json(runtime_path, runtime_payload)

    print("building runtime_preflight_plan...")
    runtime_preflight = AdvancedRuntimePreflightRegistry(root).build()
    _write_json(
        root / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["runtime_preflight_plan"],
        runtime_preflight.model_dump(mode="json"),
    )

    print("building evidence_bundle...")
    bundle = AdvancedEvidenceBundleRegistry(root).build()
    bundle_payload = bundle.model_dump(mode="json")
    summary = bundle.summary
    bundle_path = root / ADVANCED_PACKAGE_CHAIN_ARTIFACTS["evidence_bundle"]
    _write_json(bundle_path, bundle_payload)

    print(
        "Advanced Package static chain rebuilt: "
        f"packages={summary.package_count}/{summary.supported_package_count} "
        f"interfaces={summary.interface_count} "
        f"runtime_candidates={summary.test_case_count} "
        f"static={summary.static_complete} "
        f"runtime={summary.runtime_complete}"
    )

    if args.check:
        after = _chain_hashes(root)
        drift = {
            name: (before[name], after[name])
            for name in ADVANCED_PACKAGE_CHAIN_ARTIFACTS
            if before[name] != after[name]
        }
        if drift:
            print("Advanced Package static chain check failed: artifact hash drift detected")
            for name, (old_hash, new_hash) in drift.items():
                print(f"  {name}: {old_hash} -> {new_hash}")
            return 1
        print("Advanced Package static chain check passed: all artifact hashes are stable")

    return 0 if summary.static_complete else 1


if __name__ == "__main__":
    raise SystemExit(main())
