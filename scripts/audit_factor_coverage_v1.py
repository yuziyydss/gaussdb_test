#!/usr/bin/env python3
"""Audit source-to-spec-to-generation coverage for Factor Package V1."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_model import FactorPackageLoadError, FactorPackageRegistry


def display_path(path: Path) -> str:
    """Use a compact repo-relative path, while allowing external output dirs."""
    try:
        return str(path.resolve().relative_to(ROOT_DIR.resolve()))
    except ValueError:
        return str(path.resolve())


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="审计原文单元、因子值域、规则、Manifest、特性和 Scenario 覆盖；不执行 SQL。"
    )
    parser.add_argument("--factor", action="append", dest="factor_ids", help="指定 factor，可重复")
    parser.add_argument("--json", action="store_true", help="同时向标准输出打印完整 JSON")
    parser.add_argument("--fail-on-gaps", action="store_true", help="存在静态覆盖缺口时返回非零")
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=ROOT_DIR / "generated" / "factor_packages",
        help="覆盖审计 JSON 输出目录",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    registry = FactorPackageRegistry(ROOT_DIR / "specs")
    try:
        registry.load_all()
    except FactorPackageLoadError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    requested = args.factor_ids or sorted(registry.factors)
    missing = sorted(set(requested) - set(registry.factors))
    if missing:
        print(f"未知 V1 factor: {', '.join(missing)}", file=sys.stderr)
        return 2

    auditor = FactorCoverageAuditor(registry)
    reports = {}
    has_gaps = False
    for factor_id in requested:
        report = auditor.audit(factor_id)
        reports[factor_id] = report
        output_path = args.output_dir / factor_id / "coverage_audit.json"
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(
            json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8"
        )
        source = report["source_units"]
        values = report["values"]
        rules = report["rules"]
        features = report["documented_features"]
        scenarios = report["scenarios"]
        conclusions = report["conclusions"]
        line_coverage = source["line_coverage"]
        print(
            f"{factor_id}: source={source['accounted']}/{source['total']} "
            f"lines={line_coverage['covered_by_units'] + line_coverage['ignored']}/{line_coverage['total']} "
            f"unmapped={len(source['unmapped'])} "
            f"atomicity_gaps={len(source['atomicity']['gaps'])} "
            f"valid_values={values['valid_selected']}/{values['valid_total']} "
            f"value_gaps={len(values['coverage_gaps'])} "
            f"rule_gaps={len(rules['gaps'])} "
            f"pairs_complete={not report['manifests']['pairwise_incomplete']} "
            f"unresolved_error_oracles={len(report['manifests']['unresolved_error_oracles'])} "
            f"features_domain_complete={features['covered']}/{features['total']} "
            f"features_represented={features['represented']}/{features['total']} "
            f"feature_gaps={len(features['coverage_gaps'])} "
            f"unresolved_facts={len(report['facts']['unresolved'])} "
            f"wrong_fact_consumers={len(report['facts']['wrong_consumer_type'])} "
            f"planned_scenarios={len(scenarios['planned'])}"
        )
        print(
            "  conclusions: "
            f"source={conclusions['source_extraction_complete']} "
            f"generation={conclusions['generation_model_complete']} "
            f"static={conclusions['static_coverage_complete']} "
            f"behavior={conclusions['behavior_coverage_complete']} "
            f"report={display_path(output_path)}"
        )
        if source["unmapped"]:
            print("  unmapped_source_units: " + ", ".join(
                item["id"] for item in source["unmapped"]
            ))
        has_gaps = has_gaps or not conclusions["static_coverage_complete"]

    if args.json:
        print(json.dumps(reports, ensure_ascii=False, indent=2))
    return 1 if args.fail_on_gaps and has_gaps else 0


if __name__ == "__main__":
    raise SystemExit(main())
