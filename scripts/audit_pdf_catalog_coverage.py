#!/usr/bin/env python3
"""Audit the whole-PDF statement denominator against extracted Factor Packages."""
from __future__ import annotations

import argparse
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any, Dict, Iterable, Optional, Sequence

import yaml

ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from scripts.manage_extraction_queue import (
    QueueError,
    load_source_catalog,
    sha256_file,
    static_completion_freshness,
    verification_toolchain_sha256,
)


ROUTE_BY_VARIANT = {
    "general": "general_sql_statement",
    "m_compat": "m_compat_sql_statement",
}
STAGES = ("cataloged", "extracted", "package_bound", "static_complete")


class CatalogCoverageError(ValueError):
    """Raised when the catalog cannot support an unambiguous coverage report."""


def _load_factor_bindings(spec_root: Path) -> Dict[str, list[Dict[str, str]]]:
    bindings: Dict[str, list[Dict[str, str]]] = defaultdict(list)
    for path in sorted(spec_root.rglob("*.factor.yaml")):
        try:
            data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
        except (OSError, yaml.YAMLError) as exc:
            raise CatalogCoverageError(f"无法读取 factor {path}: {exc}") from exc
        source = data.get("source") or {}
        chapter_ref = source.get("catalog_chapter_ref")
        if not chapter_ref:
            continue
        relpath = chapter_ref.get("source_relpath")
        if not isinstance(relpath, str) or not relpath:
            raise CatalogCoverageError(f"{path}: catalog_chapter_ref.source_relpath 无效")
        bindings[relpath].append({
            "factor_id": str(data.get("id", "")),
            "path": str(path.resolve()),
            "document_id": str(chapter_ref.get("document_id", "")),
            "chapter_sha256": str(chapter_ref.get("chapter_sha256", "")),
            "parent_pdf_sha256": str(source.get("parent_pdf_sha256", "")),
            "extraction_rule_version": str(source.get("extraction_rule_version", "")),
        })
    return bindings


def _load_tasks(
    queue_path: Optional[Path],
) -> tuple[Dict[str, Dict[str, Any]], Optional[Path], Optional[Dict[str, Any]]]:
    if queue_path is None or not queue_path.is_file():
        return {}, None, None
    try:
        state = json.loads(queue_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise CatalogCoverageError(f"无法读取队列 {queue_path}: {exc}") from exc
    tasks = {
        str(task.get("source_relpath")): task
        for task in state.get("tasks", [])
        if task.get("source_relpath")
    }
    corpus_value = state.get("corpus_root")
    corpus_root = Path(corpus_value).resolve() if isinstance(corpus_value, str) else None
    return tasks, corpus_root, state


def build_coverage_report(
    catalog_path: Path,
    spec_root: Path,
    *,
    variants: Iterable[str] = ("general",),
    queue_path: Optional[Path] = None,
) -> Dict[str, Any]:
    try:
        # The audit must remain able to report an old static_complete as stale
        # when the parent PDF changes. Inventory/verify still use strict parent
        # validation; here freshness reports the drift instead of aborting first.
        validated = load_source_catalog(catalog_path, verify_parent_pdf=False)
        raw = json.loads(catalog_path.read_text(encoding="utf-8"))
    except (QueueError, OSError, json.JSONDecodeError) as exc:
        raise CatalogCoverageError(str(exc)) from exc

    selected_variants = tuple(dict.fromkeys(variants))
    unknown = sorted(set(selected_variants) - set(ROUTE_BY_VARIANT))
    if unknown:
        raise CatalogCoverageError(f"未知 variant: {unknown}")

    chapter_by_path = {
        tuple(chapter.get("outline_path", [])): chapter
        for chapter in raw.get("chapters", [])
    }
    if len(chapter_by_path) != len(raw.get("chapters", [])):
        raise CatalogCoverageError("catalog chapters 存在重复 outline_path")
    factor_bindings = _load_factor_bindings(spec_root)
    tasks, queue_corpus_root, queue_state = _load_tasks(queue_path)
    corpus_root = queue_corpus_root or catalog_path.resolve().parent
    current_toolchain_sha256 = verification_toolchain_sha256()

    statement_entries = [
        entry
        for entry in raw.get("outline", [])
        if entry.get("content_route")
        in {ROUTE_BY_VARIANT[variant] for variant in selected_variants}
    ]
    rows = []
    errors = []
    for entry in statement_entries:
        outline_path = tuple(entry.get("outline_path", []))
        chapter = chapter_by_path.get(outline_path)
        source_relpath = chapter.get("source_relpath") if chapter else None
        extraction_stale_reasons = []
        if source_relpath:
            source_path = (corpus_root / source_relpath).resolve()
            try:
                source_path.relative_to(corpus_root)
            except ValueError:
                extraction_stale_reasons.append("source_path_outside_corpus")
            else:
                if not source_path.is_file():
                    extraction_stale_reasons.append("source_file_missing")
                elif sha256_file(source_path) != chapter.get("chapter_sha256"):
                    extraction_stale_reasons.append("source_chapter_hash_mismatch")
        bound = factor_bindings.get(str(source_relpath), []) if source_relpath else []
        valid_bound = []
        for item in bound:
            if item["document_id"] != validated["document_id"]:
                errors.append(
                    f"{item['path']}: document_id 与 catalog 不一致"
                )
                continue
            if item["chapter_sha256"] != chapter.get("chapter_sha256"):
                errors.append(
                    f"{item['path']}: chapter_sha256 与 catalog 不一致"
                )
                continue
            if item["parent_pdf_sha256"] != raw.get("parent_pdf_sha256"):
                errors.append(
                    f"{item['path']}: parent_pdf_sha256 与 catalog 不一致"
                )
                continue
            if item["extraction_rule_version"] != raw.get("extraction_rule_version"):
                errors.append(
                    f"{item['path']}: extraction_rule_version 与 catalog 不一致"
                )
                continue
            valid_bound.append(item)
        if len(valid_bound) > 1:
            errors.append(f"{source_relpath}: 多个 factor 绑定同一PDF章节")
        task = tasks.get(str(source_relpath)) if source_relpath else None
        task_status = str(task.get("status", "unknown")) if task else None
        static_complete_stale_reasons = []
        if task_status == "static_complete":
            if len(valid_bound) != 1:
                static_complete_stale_reasons.append("factor_binding_not_unique")
            else:
                factor_path = Path(valid_bound[0]["path"])
                _, static_complete_stale_reasons = static_completion_freshness(
                    task,
                    package_dir=factor_path.parent,
                    toolchain_sha256=current_toolchain_sha256,
                    corpus_root=corpus_root,
                    source_catalog_path=catalog_path,
                    parent_pdf_path=Path(validated["parent_pdf_path"]),
                    state=queue_state,
                )
        rows.append({
            "variant": entry.get("variant"),
            "section_number": entry.get("section_number"),
            "title": entry.get("title"),
            "outline_path": list(outline_path),
            "source_relpath": source_relpath,
            "factor_ids": [item["factor_id"] for item in valid_bound],
            "queue_status": task_status,
            "extraction_stale_reasons": extraction_stale_reasons,
            "verification_fresh": task_status == "static_complete" and not static_complete_stale_reasons,
            "static_complete_stale_reasons": static_complete_stale_reasons,
            "stages": {
                "cataloged": True,
                "extracted": chapter is not None and not extraction_stale_reasons,
                "package_bound": len(valid_bound) == 1,
                "static_complete": task_status == "static_complete" and not static_complete_stale_reasons,
            },
        })

    summary = {stage: sum(row["stages"][stage] for row in rows) for stage in STAGES}
    by_variant: Dict[str, Dict[str, int]] = {}
    for variant in selected_variants:
        variant_rows = [row for row in rows if row["variant"] == variant]
        by_variant[variant] = {
            "total": len(variant_rows),
            **{
                stage: sum(row["stages"][stage] for row in variant_rows)
                for stage in STAGES
            },
        }
    queue_counts = Counter(
        row["queue_status"] for row in rows if row["queue_status"] is not None
    )
    stale_static_complete = sum(
        row["queue_status"] == "static_complete" and not row["verification_fresh"]
        for row in rows
    )
    return {
        "schema_version": 1,
        "kind": "pdf_catalog_coverage_audit",
        "document_id": validated["document_id"],
        "parent_pdf_sha256": validated["parent_pdf_sha256"],
        "variants": list(selected_variants),
        "summary": {"total": len(rows), **summary},
        "by_variant": by_variant,
        "queue_status_counts": dict(sorted(queue_counts.items())),
        "stale_static_complete": stale_static_complete,
        "errors": errors,
        "statements": rows,
    }


def parse_args(argv: Optional[Sequence[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="对账PDF中的SQL命令分母、拆章、Factor绑定和静态闭环。"
    )
    parser.add_argument("--source-catalog", type=Path, required=True)
    parser.add_argument("--spec-root", type=Path, default=ROOT_DIR / "specs")
    parser.add_argument("--queue", type=Path, default=ROOT_DIR / "work/doc2spec/queue.json")
    parser.add_argument(
        "--variant",
        action="append",
        choices=sorted(ROUTE_BY_VARIANT),
        help="可重复；默认只审计 general。",
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument("--require-stage", choices=STAGES)
    return parser.parse_args(argv)


def main(argv: Optional[Sequence[str]] = None) -> int:
    args = parse_args(argv)
    try:
        report = build_coverage_report(
            args.source_catalog,
            args.spec_root,
            variants=args.variant or ["general"],
            queue_path=args.queue,
        )
    except CatalogCoverageError as exc:
        print(f"PDF catalog coverage audit failed: {exc}", file=sys.stderr)
        return 2
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(
            json.dumps(report, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
    print(json.dumps(report["summary"], ensure_ascii=False, sort_keys=True))
    if report["errors"]:
        for error in report["errors"]:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1
    required = args.require_stage
    if required and report["summary"][required] != report["summary"]["total"]:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
