#!/usr/bin/env python3
"""Generate deterministic SQL snapshots and coverage reports from V1 manifests."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Dict, List


ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from core.factor_package_generator import FactorPackageSQLGenerator
from core.factor_coverage_auditor import FactorCoverageAuditor
from core.factor_package_model import FactorPackageLoadError, FactorPackageRegistry
from core.generator import validate_sql_syntax
from core.spec_generator import GenerationValidationError


def display_path(path: Path) -> str:
    """Use a compact repo-relative path, while allowing external output dirs."""
    try:
        return str(path.resolve().relative_to(ROOT_DIR.resolve()))
    except ValueError:
        return str(path.resolve())


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="生成 Factor Package V1 SQL；不连接数据库。")
    parser.add_argument("--factor", help="只生成指定 factor 的全部 manifest")
    parser.add_argument("--manifest", action="append", dest="manifest_ids", help="只生成指定 manifest，可重复")
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=ROOT_DIR / "generated" / "factor_packages",
        help="确定性 SQL 与 JSON 报告输出目录",
    )
    return parser.parse_args()


def render_sql_snapshot(manifest_id: str, cases: List[Any]) -> str:
    lines = [
        f"-- generated_from: {manifest_id}",
        "-- static_only: true",
        f"-- case_count: {len(cases)}",
        "",
    ]
    for case in cases:
        params = json.dumps(case.params, ensure_ascii=False, sort_keys=True)
        lines.extend([
            f"-- case_id: {case.case_id}",
            f"-- expected: {case.expected}",
            f"-- expected_error_category: {case.expected_error_category or '-'}",
            f"-- expected_sqlstates: {','.join(case.expected_sqlstates) or '-'}",
            f"-- expected_error_regex: {case.expected_error_regex or '-'}",
            f"-- expected_oracle_status: {case.expected_oracle_status}",
            f"-- expected_scope: {case.expected_scope}",
            f"-- params: {params}",
        ])
        if case.environment_requirements:
            lines.append(
                "-- environment_requirements: "
                + json.dumps(case.environment_requirements, ensure_ascii=False, sort_keys=True)
            )
        if case.setup_sqls:
            lines.append("-- fixture_setup:")
            lines.extend(case.setup_sqls)
        lines.extend(["-- test_sql:", case.sql])
        if case.teardown_sqls:
            lines.append("-- fixture_teardown:")
            lines.extend(case.teardown_sqls)
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def record_sql_provenance(
    origins: Dict[str, List[Dict[str, str]]],
    factor_id: str,
    manifest_id: str,
    cases: List[Any],
) -> None:
    """Retain cross-chapter overlaps; reject duplicate generation within a factor.

    START TRANSACTION and BEGIN both document BEGIN. Identical text across
    chapters is evidence to report, not grounds to discard a source branch.
    This does not assert equivalent fixtures, expectations, or behavior.
    """
    for case in cases:
        previous = origins.setdefault(case.sql, [])
        if any(item["factor_id"] == factor_id for item in previous):
            raise GenerationValidationError(
                f"同一 factor 跨 manifest SQL 重复: {factor_id}: {case.sql}"
            )
        previous.append({
            "factor_id": factor_id,
            "manifest_id": manifest_id,
            "case_id": case.case_id,
        })


def main() -> int:
    args = parse_args()
    registry = FactorPackageRegistry(ROOT_DIR / "specs")
    try:
        registry.load_all()
    except FactorPackageLoadError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    requested = args.manifest_ids or sorted(registry.manifests)
    if args.factor:
        requested = [
            manifest_id for manifest_id in requested
            if registry.manifests.get(manifest_id)
            and registry.manifests[manifest_id].factor_ref == args.factor
        ]
    missing = sorted(set(requested) - set(registry.manifests))
    if missing:
        print(f"未知 V1 manifest: {', '.join(missing)}", file=sys.stderr)
        return 2
    if not requested:
        print("没有匹配的 V1 manifest", file=sys.stderr)
        return 2

    generator = FactorPackageSQLGenerator(registry)
    reports: Dict[str, Any] = {}
    pending_snapshots: Dict[Path, str] = {}
    global_case_ids = set()
    sql_origins: Dict[str, List[Dict[str, str]]] = {}
    for manifest_id in requested:
        manifest = registry.manifests[manifest_id]
        try:
            cases, report = generator.generate_with_report(manifest)
        except GenerationValidationError as exc:
            print(str(exc), file=sys.stderr)
            return 1
        duplicates = sorted(case.case_id for case in cases if case.case_id in global_case_ids)
        if duplicates:
            print(f"跨 manifest case_id 重复: {duplicates}", file=sys.stderr)
            return 1
        global_case_ids.update(case.case_id for case in cases)
        try:
            record_sql_provenance(sql_origins, manifest.factor_ref, manifest_id, cases)
        except GenerationValidationError as exc:
            print(str(exc), file=sys.stderr)
            return 1
        for case in cases:
            valid_sql, issues = validate_sql_syntax(case.sql)
            if not valid_sql:
                print(f"{case.case_id}: SQL 基础校验失败: {issues}", file=sys.stderr)
                return 1
            for stage, statements in (
                ("fixture_setup", case.setup_sqls),
                ("fixture_teardown", case.teardown_sqls),
            ):
                for statement in statements:
                    valid_fixture_sql, fixture_issues = validate_sql_syntax(statement)
                    if not valid_fixture_sql:
                        print(
                            f"{case.case_id}: {stage} SQL 基础校验失败: "
                            f"{fixture_issues}: {statement}",
                            file=sys.stderr,
                        )
                        return 1
        factor_dir = args.output_dir / manifest.factor_ref
        sql_path = factor_dir / f"{manifest.id}.sql"
        pending_snapshots[sql_path] = render_sql_snapshot(manifest.id, cases)
        reports[manifest.id] = {
            "suite_type": manifest.suite_type,
            "expected": manifest.expected.model_dump(),
            "violates_rule_refs": list(manifest.violates_rule_refs),
            "report": report.to_dict(),
            "cases": [case.to_dict() for case in cases],
            "sql_snapshot": display_path(sql_path),
        }
        interaction_dimension_count = sum(
            len(values) > 1 for values in manifest.bindings.values()
        )
        pair_summary = (
            f"{report.covered_pair_count}/{report.feasible_pair_count}"
            if interaction_dimension_count >= 2
            else f"n/a(interaction_dimensions={interaction_dimension_count})"
        )
        print(
            f"{manifest.id}: cases={len(cases)} pairs={pair_summary} "
            f"sql={display_path(sql_path)}"
        )

    requested_by_factor: Dict[str, set[str]] = {}
    for manifest_id in requested:
        factor_id = registry.manifests[manifest_id].factor_ref
        requested_by_factor.setdefault(factor_id, set()).add(manifest_id)
    for factor_id, selected_ids in requested_by_factor.items():
        factor_dir = args.output_dir / factor_id
        factor_dir.mkdir(parents=True, exist_ok=True)
        all_factor_ids = set(registry.factors[factor_id].manifest_refs)
        if selected_ids == all_factor_ids:
            expected_names = {f"{manifest_id}.sql" for manifest_id in selected_ids}
            for existing in factor_dir.glob("*.sql"):
                if existing.name not in expected_names:
                    existing.unlink()
        for path, content in pending_snapshots.items():
            if path.parent == factor_dir:
                path.write_text(content, encoding="utf-8")

    report_path = args.output_dir / "generation_report.json"
    report_path.parent.mkdir(parents=True, exist_ok=True)
    factor_summaries: Dict[str, Any] = {}
    auditor = FactorCoverageAuditor(registry)
    for factor_id in sorted({registry.manifests[item].factor_ref for item in requested}):
        audit = auditor.audit(factor_id)
        factor_summaries[factor_id] = audit
        if requested_by_factor[factor_id] == set(registry.factors[factor_id].manifest_refs):
            audit_path = args.output_dir / factor_id / "coverage_audit.json"
            audit_path.write_text(
                json.dumps(audit, ensure_ascii=False, indent=2),
                encoding="utf-8",
            )
    report_path.write_text(
        json.dumps({
            "manifest_count": len(reports),
            "global_case_id_count": len(global_case_ids),
            "distinct_sql_count": len(sql_origins),
            "cross_factor_sql_overlaps": [
                {"sql": sql, "origins": origins}
                for sql, origins in sorted(sql_origins.items())
                if len(origins) > 1
            ],
            "factor_dependencies": {
                factor_id: sorted(dependencies)
                for factor_id, dependencies in sorted(
                    registry.factor_dependency_graph().items()
                )
            },
            "factor_topological_order": registry.factor_topological_order(),
            "factor_coverage": factor_summaries,
            "manifests": reports,
        }, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    print(f"report={display_path(report_path)} global_case_ids={len(global_case_ids)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
