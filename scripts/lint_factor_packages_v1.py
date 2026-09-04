#!/usr/bin/env python3
"""Strictly load Factor Package V1 YAML without executing SQL."""
from __future__ import annotations

import argparse
import sys
from collections import Counter
from pathlib import Path


ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from core.factor_package_model import FactorPackageLoadError, FactorPackageRegistry


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="静态校验 Factor Package Schema V1；不执行 SQL。")
    parser.add_argument("specs_dir", nargs="?", type=Path, default=ROOT_DIR / "specs")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    requested_root = args.specs_dir.resolve()
    canonical_root = (ROOT_DIR / "specs").resolve()
    try:
        requested_root.relative_to(canonical_root)
        registry_root = canonical_root
    except ValueError:
        registry_root = requested_root
    registry = FactorPackageRegistry(registry_root)
    try:
        registry.load_all()
    except FactorPackageLoadError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    def selected(entity_id: str) -> bool:
        try:
            registry.source_paths[entity_id].resolve().relative_to(requested_root)
            return True
        except ValueError:
            return False

    selected_factors = {
        factor_id: factor
        for factor_id, factor in registry.factors.items()
        if selected(factor_id)
    }
    counts = Counter({
        "factor": len(selected_factors),
        "source_ledger": sum(selected(item) for item in registry.source_ledgers),
        "fixture": sum(selected(item) for item in registry.fixtures),
        "manifest": sum(selected(item) for item in registry.manifests),
        "matrix": sum(selected(item) for item in registry.matrices),
        "scenario": sum(selected(item) for item in registry.scenarios),
        "syntax": sum(selected(item) for item in registry.syntaxes),
    })
    total = sum(counts.values())
    summary = " ".join(f"{kind}={counts[kind]}" for kind in sorted(counts))
    print(f"OK files={total} factors={len(selected_factors)} {summary}")
    for factor in selected_factors.values():
        ledger = registry.source_ledgers[factor.source_ledger_ref]
        source_accounted = sum(unit.status != "unmapped" for unit in ledger.units)
        covered_lines = {
            line
            for unit in ledger.units
            for line in range(unit.line_start, unit.line_end + 1)
        }
        documented_features = [
            feature
            for matrix_id in factor.matrix_refs
            for feature in registry.matrices[matrix_id].all_documented_features
        ]
        print(
            f"  {factor.id}: confirmed_facts="
            f"{sum(fact.status == 'confirmed' for fact in factor.facts)} "
            f"open_questions={sum(fact.type == 'open_question' for fact in factor.facts)} "
            f"source_units={source_accounted}/{len(ledger.units)} "
            f"source_lines={len(covered_lines) + len(ledger.ignored_lines)}/{ledger.source_line_count} "
            f"feature_specs_with_refs="
            f"{sum(item.status == 'covered' for item in documented_features)}"
            f"/{len(documented_features)} "
            f"feature_specs_needing_profile="
            f"{sum(item.status == 'needs_profile' for item in documented_features)}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
