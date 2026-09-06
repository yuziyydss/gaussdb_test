#!/usr/bin/env python3
"""Manage an offline, provider-neutral Doc2Spec extraction queue.

The queue contains metadata and local file paths only.  It never calls an AI
service and never sends source text over the network.  A human or any AI agent
running inside the intranet can claim one task, read the rendered task file,
write one Factor Package V1, and then use this script to run the deterministic
static quality gates.
"""
from __future__ import annotations

import argparse
import fcntl
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
from collections import Counter
from contextlib import contextmanager
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterable, Iterator, List, Optional, Set

import yaml
ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from core.factor_package_model import FactorPackageLoadError, FactorPackageRegistry


DEFAULT_STATE_PATH = ROOT_DIR / "work" / "doc2spec" / "queue.json"
DEFAULT_TEMPLATE_PATH = ROOT_DIR / "prompts" / "factor_package_v1_extraction.md"
DEFAULT_TASK_DIR = ROOT_DIR / "work" / "doc2spec" / "tasks"
DEFAULT_VERIFY_OUTPUT_DIR = ROOT_DIR / "work" / "doc2spec" / "generated"

QUEUE_SCHEMA_VERSION = 1
SOURCE_SUFFIXES = {".txt", ".md", ".html", ".htm"}
GENERAL_VARIANTS = {"general", "common", "default"}
SHA256_PATTERN = re.compile(r"[0-9a-f]{64}")
CATALOG_ROOT_FIELDS = (
    "document_id",
    "parent_pdf_path",
    "parent_pdf_sha256",
    "product_version",
    "document_version",
    "extraction_rule_version",
)
CATALOG_CHAPTER_FIELDS = (
    "variant",
    "category",
    "section_number",
    "title",
    "outline_path",
    "start_destination",
    "end_destination",
    "physical_page_start",
    "physical_page_end",
    "printed_page_start",
    "printed_page_end",
    "chapter_sha256",
)
TASK_PROVENANCE_FIELDS = (*CATALOG_ROOT_FIELDS, *CATALOG_CHAPTER_FIELDS)
VERIFY_GUARD_FIELDS = (
    "source_sha256",
    "source_line_count",
    "source_present",
    "source_catalog_path",
    "source_catalog_sha256",
    "depends_on_factor_refs",
    *TASK_PROVENANCE_FIELDS,
)
STATUSES = {
    "pending",
    "in_progress",
    "generated",
    "needs_review",
    "blocked",
    "failed",
    "static_complete",
}
EDITABLE_STATUSES = STATUSES - {"static_complete"}
TRANSITIONS = {
    "pending": {"in_progress", "blocked"},
    "in_progress": {"generated", "needs_review", "blocked", "failed"},
    "generated": {"needs_review", "blocked", "failed"},
    "needs_review": {"in_progress", "blocked", "failed"},
    "blocked": {"pending", "in_progress"},
    "failed": {"pending", "in_progress", "blocked"},
    "static_complete": {"in_progress"},
}


class QueueError(ValueError):
    """A deterministic queue or workflow validation error."""


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_files(paths: Iterable[Path], *, relative_to: Path) -> str:
    """Hash file names and bytes so a prior verification cannot outlive its inputs."""
    root = relative_to.resolve()
    digest = hashlib.sha256()
    resolved_paths = sorted({path.resolve() for path in paths})
    for path in resolved_paths:
        try:
            relative = path.relative_to(root).as_posix()
        except ValueError as exc:
            raise QueueError(f"快照文件越出根目录 {root}: {path}") from exc
        if not path.is_file():
            raise QueueError(f"快照文件不存在: {path}")
        payload = path.read_bytes()
        digest.update(relative.encode("utf-8"))
        digest.update(b"\0")
        digest.update(str(len(payload)).encode("ascii"))
        digest.update(b"\0")
        digest.update(payload)
        digest.update(b"\0")
    return digest.hexdigest()


def factor_package_sha256(package_dir: Path) -> str:
    """Hash every YAML input that defines one Factor Package."""
    root = package_dir.resolve()
    if not root.is_dir():
        raise QueueError(f"Factor Package 目录不存在: {root}")
    paths = sorted(root.rglob("*.yaml"))
    if not paths:
        raise QueueError(f"Factor Package 没有 YAML 文件: {root}")
    return sha256_files(paths, relative_to=root)


def _factor_source_sha256(package_dir: Path, factor_id: str) -> str:
    candidates = sorted(package_dir.glob("*.factor.yaml"))
    for path in candidates:
        try:
            raw = yaml.safe_load(path.read_text(encoding="utf-8"))
        except (OSError, yaml.YAMLError):
            continue
        if not isinstance(raw, dict) or raw.get("id") != factor_id:
            continue
        source = raw.get("source")
        digest = source.get("artifact_sha256") if isinstance(source, dict) else None
        if isinstance(digest, str) and SHA256_PATTERN.fullmatch(digest):
            return digest
    raise QueueError(
        f"依赖 factor '{factor_id}' 缺少 source.artifact_sha256"
    )


def supplemental_verification_snapshot(
    package_dir: Path,
    catalog_path: Optional[Path],
    corpus_root: Optional[Path] = None,
) -> Dict[str, Any]:
    """Bind declared body-only inputs to disk, not merely ledger/catalog hashes.

    This is internal queue evidence, not a new Factor Package schema. URL-only
    sources cannot receive a local freshness proof. No network access is made.
    """
    try:
        sources = []
        for path in sorted(package_dir.glob('*.source.yaml')):
            ledger = yaml.safe_load(path.read_text(encoding='utf-8'))
            if not isinstance(ledger, dict):
                raise ValueError(f'invalid ledger: {path.name}')
            sources.extend(ledger.get('supplemental_sources', []))
        if not sources:
            return {}
        if catalog_path is None:
            raise ValueError('catalog unavailable')
        catalog_path = Path(catalog_path).resolve()
        catalog = json.loads(catalog_path.read_text(encoding='utf-8'))
        chapters = {c['source_relpath']: c for c in catalog['chapters']}
        root = (corpus_root or catalog_path.parent).resolve()
        result = {}
        for source in sources:
            ref = source.get('catalog_chapter_ref')
            if not isinstance(ref, dict):
                raise ValueError('local catalog reference required, URL freshness unverified')
            relpath = ref['source_relpath']
            path = (root / relpath).resolve()
            if Path(relpath).is_absolute() or not path.is_relative_to(root):
                raise ValueError(f'body outside corpus: {relpath}')
            chapter = chapters.get(relpath)
            if (not chapter or ref['document_id'] != catalog['document_id']
                    or source['version'] != catalog['product_version']
                    or ref['chapter_sha256'] != chapter['chapter_sha256']):
                raise ValueError(f'catalog/ledger mismatch: {relpath}')
            digest = sha256_file(path)
            if digest != ref['chapter_sha256']:
                raise ValueError(f'body changed: {relpath}')
            result[relpath] = {'source_path': str(path), 'source_sha256': digest}
        return {'catalog_path': str(catalog_path), 'corpus_root': str(root), 'bodies': result}
    except (OSError, ValueError, KeyError, TypeError, AttributeError, yaml.YAMLError) as exc:
        raise QueueError(f'supplemental_source_unverified:{package_dir.name}:{exc}') from exc


def dependency_verification_snapshot(
    state: Dict[str, Any],
    task: Dict[str, Any],
) -> Dict[str, Dict[str, Any]]:
    """Snapshot the transitive package and chapter inputs of a task."""
    tasks_by_factor = {item["factor_id"]: item for item in state["tasks"]}
    graph: Dict[str, Set[str]] = {
        factor_id: set(item.get("depends_on_factor_refs", []))
        for factor_id, item in tasks_by_factor.items()
    }
    try:
        registry = FactorPackageRegistry(Path(state["specs_root"]))
        registry.load_all()
        for factor_id, dependencies in registry.factor_dependency_graph().items():
            graph[factor_id] = set(dependencies)
    except (FactorPackageLoadError, OSError, ValueError):
        pass

    closure: Set[str] = set()
    pending = list(graph.get(task["factor_id"], task.get("depends_on_factor_refs", [])))
    while pending:
        dependency_id = pending.pop()
        if dependency_id in closure:
            continue
        closure.add(dependency_id)
        pending.extend(graph.get(dependency_id, set()))

    package_dirs = _factor_package_dirs(Path(state["specs_root"]))
    result: Dict[str, Dict[str, Any]] = {}
    for dependency_id in sorted(closure):
        dependency_task = tasks_by_factor.get(dependency_id)
        package_dir = (
            Path(dependency_task["output_dir"])
            if dependency_task is not None
            else package_dirs.get(dependency_id)
        )
        if package_dir is None or not package_dir.is_dir():
            raise QueueError(f"依赖 factor package 不存在: '{dependency_id}'")
        source_sha256 = (
            dependency_task["source_sha256"]
            if dependency_task is not None
            else _factor_source_sha256(package_dir, dependency_id)
        )
        source_path = None
        if dependency_task is not None:
            catalog_path = dependency_task.get("source_catalog_path")
            source_root = (
                Path(catalog_path).parent if catalog_path
                else Path(state["corpus_root"])
            ).resolve()
            source_path = (source_root / dependency_task["source_relpath"]).resolve()
            if not source_path.is_relative_to(source_root):
                raise QueueError(f"dependency_source_outside_corpus:{dependency_id}")
            if not source_path.is_file():
                raise QueueError(f"dependency_source_unavailable:{dependency_id}")
            actual_source_sha256 = sha256_file(source_path)
            if actual_source_sha256 != source_sha256:
                raise QueueError(f"dependency_source_changed:{dependency_id}")
            source_sha256 = actual_source_sha256
        result[dependency_id] = {
            "package_dir": str(package_dir.resolve()),
            "factor_package_sha256": factor_package_sha256(package_dir),
            "source_sha256": source_sha256,
        }
        if source_path is not None:
            result[dependency_id]["source_path"] = str(source_path)
        catalog_value = (dependency_task or {}).get('source_catalog_path') or state.get('source_catalog_path')
        result[dependency_id]['supplemental_sources'] = supplemental_verification_snapshot(
            package_dir, Path(catalog_value) if catalog_value else None,
            Path(state['corpus_root']) if not (dependency_task or {}).get('source_catalog_path') else None)
    return result


def verification_toolchain_sha256() -> str:
    """Hash the static loader/generator/auditor implementation used by verify."""
    paths = [*sorted((ROOT_DIR / "core").glob("*.py"))]
    paths.extend(
        ROOT_DIR / "scripts" / name
        for name in (
            "lint_factor_packages_v1.py",
            "generate_factor_package_sql.py",
            "audit_factor_coverage_v1.py",
            "manage_extraction_queue.py",
        )
    )
    paths.append(ROOT_DIR / "requirements.txt")
    return sha256_files(paths, relative_to=ROOT_DIR)


def _valid_supplemental_snapshot(evidence: Any) -> bool:
    """Check persisted JSON before using it to construct filesystem paths."""
    if not isinstance(evidence, dict):
        return False
    if not evidence:
        return True  # Older snapshots without supplemental inputs.
    if not all(isinstance(evidence.get(key), str) and evidence[key].strip()
               for key in ('catalog_path', 'corpus_root')):
        return False
    bodies = evidence.get('bodies')
    return isinstance(bodies, dict) and all(
        isinstance(relpath, str) and isinstance(body, dict)
        and isinstance(body.get('source_path'), str) and bool(body['source_path'].strip())
        and isinstance(body.get('source_sha256'), str)
        and bool(SHA256_PATTERN.fullmatch(body['source_sha256']))
        for relpath, body in bodies.items())


def static_completion_freshness(
    task: Dict[str, Any],
    *,
    state: Optional[Dict[str, Any]] = None,
    package_dir: Optional[Path] = None,
    toolchain_sha256: Optional[str] = None,
    corpus_root: Optional[Path] = None,
    source_catalog_path: Optional[Path] = None,
    parent_pdf_path: Optional[Path] = None,
) -> tuple[bool, List[str]]:
    """Recheck every source and implementation snapshot behind static completion."""
    if task.get("status") != "static_complete":
        return False, ["queue_status_not_static_complete"]
    snapshot = task.get("verification_snapshot")
    if not isinstance(snapshot, dict):
        return False, ["verification_snapshot_missing"]
    reasons: List[str] = []
    target_dir = package_dir or Path(str(task.get("output_dir", "")))
    try:
        current_package_sha256 = factor_package_sha256(target_dir)
    except QueueError as exc:
        reasons.append(str(exc))
    else:
        if snapshot.get("factor_package_sha256") != current_package_sha256:
            reasons.append("factor_package_changed_after_verify")
    current_toolchain = toolchain_sha256 or verification_toolchain_sha256()
    if snapshot.get("toolchain_sha256") != current_toolchain:
        reasons.append("verification_toolchain_changed_after_verify")

    snapshot_source_sha256 = snapshot.get("source_sha256")
    if snapshot_source_sha256 is None:
        reasons.append("source_snapshot_missing")
    elif snapshot_source_sha256 != task.get("source_sha256"):
        reasons.append("source_snapshot_task_mismatch")
    source_root = corpus_root.resolve() if corpus_root is not None else None
    if source_root is None and (source_catalog_path or task.get("source_catalog_path")):
        source_root = Path(
            source_catalog_path or str(task["source_catalog_path"])
        ).resolve().parent
    if source_root is None:
        reasons.append("source_path_unavailable_for_freshness")
    else:
        source_path = (source_root / str(task.get("source_relpath", ""))).resolve()
        try:
            source_path.relative_to(source_root)
        except ValueError:
            reasons.append("source_path_outside_corpus")
        else:
            if not source_path.is_file():
                reasons.append("source_unavailable_after_verify")
            elif snapshot_source_sha256 != sha256_file(source_path):
                reasons.append("source_changed_after_verify")

    catalog_value = source_catalog_path or task.get("source_catalog_path")
    catalog_backed = catalog_value is not None or task.get("source_catalog_sha256") is not None
    if catalog_backed:
        snapshot_catalog_sha256 = snapshot.get("catalog_sha256")
        if snapshot_catalog_sha256 is None:
            reasons.append("catalog_snapshot_missing")
        elif snapshot_catalog_sha256 != task.get("source_catalog_sha256"):
            reasons.append("catalog_snapshot_task_mismatch")
        catalog_path = Path(str(catalog_value)).resolve() if catalog_value else None
        if catalog_path is None or not catalog_path.is_file():
            reasons.append("catalog_unavailable_after_verify")
        elif snapshot_catalog_sha256 != sha256_file(catalog_path):
            reasons.append("catalog_changed_after_verify")

        snapshot_parent_pdf_sha256 = snapshot.get("parent_pdf_sha256")
        if snapshot_parent_pdf_sha256 is None:
            reasons.append("parent_pdf_snapshot_missing")
        elif snapshot_parent_pdf_sha256 != task.get("parent_pdf_sha256"):
            reasons.append("parent_pdf_snapshot_task_mismatch")
        pdf_value = parent_pdf_path or task.get("parent_pdf_path")
        pdf_path = Path(str(pdf_value)).resolve() if pdf_value else None
        if pdf_path is None or not pdf_path.is_file():
            reasons.append("parent_pdf_unavailable_after_verify")
        elif snapshot_parent_pdf_sha256 != sha256_file(pdf_path):
            reasons.append("parent_pdf_changed_after_verify")

    expected_supplements = snapshot.get('supplemental_sources', {})
    try:
        if not _valid_supplemental_snapshot(expected_supplements):
            raise QueueError('supplemental_snapshot_invalid')
        evidence = expected_supplements
        supplemental_catalog = (catalog_value or (state or {}).get('source_catalog_path')
                                or evidence.get('catalog_path'))
        current_supplements = supplemental_verification_snapshot(
            target_dir, Path(supplemental_catalog) if supplemental_catalog else None,
            source_root or (Path(evidence['corpus_root']) if evidence.get('corpus_root') else None))
        if current_supplements != expected_supplements:
            reasons.append('supplemental_sources_changed_or_snapshot_missing')
    except QueueError as exc:
        reasons.append(str(exc))

    expected_dependencies = snapshot.get("dependencies", {})
    declared_dependencies = set(task.get("depends_on_factor_refs", []))
    if not isinstance(expected_dependencies, dict):
        reasons.append("dependency_snapshot_invalid")
    elif declared_dependencies and not expected_dependencies:
        reasons.append("dependency_snapshot_missing")
    else:
        if state is not None:
            try:
                current_dependencies = dependency_verification_snapshot(state, task)
            except QueueError as exc:
                reasons.append(str(exc))
                current_dependencies = {}
        else:
            current_dependencies = {}
            for dependency_id, expected in expected_dependencies.items():
                if (not isinstance(expected, dict)
                        or not isinstance(expected.get('package_dir'), str)
                        or not expected['package_dir'].strip()):
                    reasons.append(f"dependency_snapshot_invalid:{dependency_id}")
                    continue
                dependency_dir = Path(expected["package_dir"])
                try:
                    source_path = expected.get("source_path")
                    if source_path is not None and (not isinstance(source_path, str) or not source_path.strip()):
                        raise QueueError(f'dependency_snapshot_invalid:{dependency_id}')
                    if source_path and not Path(source_path).is_file():
                        raise QueueError(f"dependency_source_unavailable:{dependency_id}")
                    current_dependencies[dependency_id] = {
                        "package_dir": str(dependency_dir.resolve()),
                        "factor_package_sha256": factor_package_sha256(dependency_dir),
                        "source_sha256": (
                            sha256_file(Path(source_path)) if source_path
                            else _factor_source_sha256(dependency_dir, dependency_id)
                        ),
                    }
                    evidence = expected.get('supplemental_sources', {})
                    if not _valid_supplemental_snapshot(evidence):
                        raise QueueError(f'dependency_supplemental_snapshot_invalid:{dependency_id}')
                    current_dependencies[dependency_id]['supplemental_sources'] = supplemental_verification_snapshot(
                        dependency_dir,
                        Path(evidence['catalog_path']) if evidence.get('catalog_path') else None,
                        Path(evidence['corpus_root']) if evidence.get('corpus_root') else None)
                except QueueError as exc:
                    reasons.append(str(exc))
        if set(current_dependencies) != set(expected_dependencies):
            reasons.append("dependency_set_changed_after_verify")
        for dependency_id in sorted(
            set(current_dependencies) & set(expected_dependencies)
        ):
            current = current_dependencies[dependency_id]
            expected = expected_dependencies[dependency_id]
            if not isinstance(expected, dict):
                reasons.append(f'dependency_snapshot_invalid:{dependency_id}')
                continue
            if (
                current.get("factor_package_sha256")
                != expected.get("factor_package_sha256")
            ):
                reasons.append(
                    f"dependency_factor_package_changed:{dependency_id}"
                )
            if current.get("source_sha256") != expected.get("source_sha256"):
                reasons.append(f"dependency_source_changed:{dependency_id}")
            if current.get('supplemental_sources', {}) != expected.get('supplemental_sources', {}):
                reasons.append(f'dependency_supplemental_sources_changed:{dependency_id}')
    return not reasons, list(dict.fromkeys(reasons))


def count_utf8_lines(path: Path) -> int:
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError as exc:
        raise QueueError(f"语料必须是 UTF-8: {path}: {exc}") from exc
    count = len(text.splitlines())
    if count == 0:
        raise QueueError(f"语料文件为空: {path}")
    return count


def _require_text(value: Any, field: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise QueueError(f"source catalog 的 {field} 必须是非空字符串")
    return value.strip()


def _require_sha256(value: Any, field: str) -> str:
    digest = _require_text(value, field).lower()
    if not SHA256_PATTERN.fullmatch(digest):
        raise QueueError(f"source catalog 的 {field} 必须是64位十六进制 SHA-256")
    return digest


def _normalise_printed_page(value: Any, field: str) -> str:
    if isinstance(value, bool) or not isinstance(value, (str, int)):
        raise QueueError(f"source catalog 的 {field} 必须是非空页码")
    page = str(value).strip()
    if not page:
        raise QueueError(f"source catalog 的 {field} 必须是非空页码")
    return page


def _normalise_destination(
    value: Any, field: str, *, require_exclusive: bool = False
) -> Dict[str, Any]:
    if not isinstance(value, dict):
        raise QueueError(f"source catalog 的 {field} 必须是对象")
    physical_page = value.get("physical_page")
    if isinstance(physical_page, bool) or not isinstance(physical_page, int) or physical_page < 1:
        raise QueueError(f"source catalog 的 {field}.physical_page 必须是正整数")
    pdf_top = value.get("pdf_top")
    if (
        pdf_top is not None
        and (
            isinstance(pdf_top, bool)
            or not isinstance(pdf_top, (int, float))
            or pdf_top < 0
        )
    ):
        raise QueueError(f"source catalog 的 {field}.pdf_top 必须是 null 或非负数")
    y_from_top = value.get("y_from_top")
    if (
        isinstance(y_from_top, bool)
        or not isinstance(y_from_top, (int, float))
        or y_from_top < 0
    ):
        raise QueueError(f"source catalog 的 {field}.y_from_top 必须是非负数")
    if value.get("coordinate_unit") != "pt":
        raise QueueError(f"source catalog 的 {field}.coordinate_unit 必须是 'pt'")
    if require_exclusive and value.get("exclusive") is not True:
        raise QueueError(f"source catalog 的 {field}.exclusive 必须为 true")
    if not require_exclusive and value.get("exclusive") not in (None, False):
        raise QueueError(f"source catalog 的 {field} 起点不能声明 exclusive=true")
    destination = {
        "physical_page": physical_page,
        "printed_page": _normalise_printed_page(
            value.get("printed_page"), f"{field}.printed_page"
        ),
        "pdf_top": None if pdf_top is None else float(pdf_top),
        "y_from_top": float(y_from_top),
        "coordinate_unit": "pt",
    }
    if require_exclusive:
        destination["exclusive"] = True
    return destination


def _normalise_catalog_chapter(raw: Any, index: int) -> Dict[str, Any]:
    prefix = f"chapters[{index}]"
    if not isinstance(raw, dict):
        raise QueueError(f"source catalog 的 {prefix} 必须是对象")
    source_relpath = _require_text(raw.get("source_relpath"), f"{prefix}.source_relpath")
    relative_path = Path(source_relpath)
    if (
        relative_path.is_absolute()
        or "\\" in source_relpath
        or ".." in relative_path.parts
        or relative_path.as_posix() != source_relpath
    ):
        raise QueueError(f"source catalog 的 {prefix}.source_relpath 必须是安全相对路径")
    source_relpath = relative_path.as_posix()
    variant = normalize_id(_require_text(raw.get("variant"), f"{prefix}.variant"), field="variant")
    category = normalize_id(_require_text(raw.get("category"), f"{prefix}.category"), field="category")
    outline_path = raw.get("outline_path")
    if (
        not isinstance(outline_path, list)
        or not outline_path
        or any(not isinstance(item, str) or not item.strip() for item in outline_path)
    ):
        raise QueueError(f"source catalog 的 {prefix}.outline_path 必须是非空字符串列表")
    start_destination = _normalise_destination(
        raw.get("start_destination"), f"{prefix}.start_destination"
    )
    end_destination = _normalise_destination(
        raw.get("end_destination"),
        f"{prefix}.end_destination",
        require_exclusive=True,
    )
    physical_page_start = raw.get("physical_page_start")
    physical_page_end = raw.get("physical_page_end")
    for field_name, page in (
        ("physical_page_start", physical_page_start),
        ("physical_page_end", physical_page_end),
    ):
        if isinstance(page, bool) or not isinstance(page, int) or page < 1:
            raise QueueError(f"source catalog 的 {prefix}.{field_name} 必须是正整数")
    if physical_page_end < physical_page_start:
        raise QueueError(f"source catalog 的 {prefix}.physical_page_end 不能小于起始页")
    printed_page_start = _normalise_printed_page(
        raw.get("printed_page_start"), f"{prefix}.printed_page_start"
    )
    printed_page_end = _normalise_printed_page(
        raw.get("printed_page_end"), f"{prefix}.printed_page_end"
    )
    if physical_page_start < start_destination["physical_page"]:
        raise QueueError(
            f"source catalog 的 {prefix}.physical_page_start 不能早于 start_destination"
        )
    if physical_page_end > end_destination["physical_page"]:
        raise QueueError(
            f"source catalog 的 {prefix}.physical_page_end 不能晚于 end_destination"
        )
    if (
        physical_page_start == start_destination["physical_page"]
        and start_destination["printed_page"] != printed_page_start
    ):
        raise QueueError(
            f"source catalog 的 {prefix}.printed_page_start 与 start_destination 不一致"
        )
    if (
        physical_page_end == end_destination["physical_page"]
        and end_destination["printed_page"] != printed_page_end
    ):
        raise QueueError(
            f"source catalog 的 {prefix}.printed_page_end 与 end_destination 不一致"
        )
    start_key = (start_destination["physical_page"], start_destination["y_from_top"])
    end_key = (end_destination["physical_page"], end_destination["y_from_top"])
    if end_key <= start_key:
        raise QueueError(
            f"source catalog 的 {prefix}.end_destination 必须晚于起点（end为exclusive）"
        )
    return {
        "source_relpath": source_relpath,
        "variant": variant,
        "category": category,
        "section_number": _require_text(
            raw.get("section_number"), f"{prefix}.section_number"
        ),
        "title": _require_text(raw.get("title"), f"{prefix}.title"),
        "outline_path": [item.strip() for item in outline_path],
        "start_destination": start_destination,
        "end_destination": end_destination,
        "physical_page_start": physical_page_start,
        "physical_page_end": physical_page_end,
        "printed_page_start": printed_page_start,
        "printed_page_end": printed_page_end,
        "chapter_sha256": _require_sha256(
            raw.get("chapter_sha256"), f"{prefix}.chapter_sha256"
        ),
    }


def load_source_catalog(
    path: Path, *, verify_parent_pdf: bool = True
) -> Dict[str, Any]:
    """Load and verify a PDF-to-chapter sidecar without changing V1 schemas."""
    catalog_path = path.resolve()
    if not catalog_path.is_file():
        raise QueueError(f"source catalog 不存在: {catalog_path}")
    try:
        catalog_bytes = catalog_path.read_bytes()
        raw = json.loads(catalog_bytes.decode("utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise QueueError(f"无法读取 source catalog {catalog_path}: {exc}") from exc
    if not isinstance(raw, dict):
        raise QueueError("source catalog 顶层必须是对象")
    if raw.get("schema_version") != 1:
        raise QueueError(f"不支持的 source catalog schema_version: {raw.get('schema_version')!r}")

    parent_pdf_value = _require_text(raw.get("parent_pdf_path"), "parent_pdf_path")
    parent_pdf_path = Path(parent_pdf_value)
    if not parent_pdf_path.is_absolute():
        parent_pdf_path = catalog_path.parent / parent_pdf_path
    parent_pdf_path = parent_pdf_path.resolve()
    if not parent_pdf_path.is_file():
        raise QueueError(f"source catalog 的 parent_pdf_path 不存在: {parent_pdf_path}")
    parent_pdf_sha256 = _require_sha256(
        raw.get("parent_pdf_sha256"), "parent_pdf_sha256"
    )
    actual_parent_sha256 = sha256_file(parent_pdf_path)
    if verify_parent_pdf and actual_parent_sha256 != parent_pdf_sha256:
        raise QueueError(
            "source catalog 的 parent_pdf_sha256 与当前父 PDF SHA-256 不一致: "
            f"expected={parent_pdf_sha256} actual={actual_parent_sha256}"
        )

    raw_chapters = raw.get("chapters")
    if not isinstance(raw_chapters, list) or not raw_chapters:
        raise QueueError("source catalog 的 chapters 必须是非空列表")
    chapters: Dict[str, Dict[str, Any]] = {}
    for index, raw_chapter in enumerate(raw_chapters):
        chapter = _normalise_catalog_chapter(raw_chapter, index)
        relpath = chapter["source_relpath"]
        if relpath in chapters:
            raise QueueError(f"source catalog 的 source_relpath 重复: {relpath}")
        chapters[relpath] = chapter

    return {
        "path": str(catalog_path),
        "sha256": hashlib.sha256(catalog_bytes).hexdigest(),
        "document_id": _require_text(raw.get("document_id"), "document_id"),
        "parent_pdf_path": str(parent_pdf_path),
        "parent_pdf_sha256": parent_pdf_sha256,
        "product_version": _require_text(raw.get("product_version"), "product_version"),
        "document_version": _require_text(raw.get("document_version"), "document_version"),
        "extraction_rule_version": _require_text(
            raw.get("extraction_rule_version"), "extraction_rule_version"
        ),
        "chapters": chapters,
    }


def _catalog_task_provenance(
    catalog: Dict[str, Any], chapter: Dict[str, Any]
) -> Dict[str, Any]:
    provenance = {field: catalog[field] for field in CATALOG_ROOT_FIELDS}
    provenance.update({field: chapter[field] for field in CATALOG_CHAPTER_FIELDS})
    provenance.update({
        "source_catalog_path": catalog["path"],
        "source_catalog_sha256": catalog["sha256"],
    })
    return provenance


def _attach_catalog_provenance(
    task: Dict[str, Any], catalog: Dict[str, Any]
) -> bool:
    chapter = catalog["chapters"].get(task["source_relpath"])
    if chapter is None:
        return False
    if chapter["variant"] != task["source_variant"]:
        raise QueueError(
            f"{task['source_relpath']}: catalog variant={chapter['variant']!r} "
            f"与路径 variant={task['source_variant']!r} 不一致"
        )
    if chapter["category"] != task["category"]:
        raise QueueError(
            f"{task['source_relpath']}: catalog category={chapter['category']!r} "
            f"与路径 category={task['category']!r} 不一致"
        )
    if chapter["chapter_sha256"] != task["source_sha256"]:
        raise QueueError(
            f"{task['source_relpath']}: catalog chapter_sha256 与章节文本不一致: "
            f"expected={chapter['chapter_sha256']} actual={task['source_sha256']}"
        )
    task.update(_catalog_task_provenance(catalog, chapter))
    return True


def normalize_id(value: str, *, field: str) -> str:
    normalized = re.sub(r"[^a-z0-9]+", "_", value.strip().lower()).strip("_")
    if not normalized:
        raise QueueError(f"{field} 无法转换为稳定英文 ID: {value!r}")
    return normalized


def task_from_source(corpus_root: Path, specs_root: Path, source_path: Path) -> Dict[str, Any]:
    relative = source_path.relative_to(corpus_root)
    parts = relative.parts
    if len(parts) < 3:
        raise QueueError(
            f"语料路径至少需要三层 <variant>/<category>/<section>.<ext>: {relative}"
        )
    variant = normalize_id(parts[0], field="variant")
    category = normalize_id(parts[1], field="category")
    section_parts = list(parts[2:-1]) + [source_path.stem]
    section_id = normalize_id("_".join(section_parts), field="section")
    factor_id = section_id if variant in GENERAL_VARIANTS else f"{variant}_{section_id}"
    task_id = f"doc2spec_{variant}_{category}_{section_id}"
    output_dir = specs_root / category / factor_id
    return {
        "task_id": task_id,
        "source_relpath": relative.as_posix(),
        "source_sha256": sha256_file(source_path),
        "source_line_count": count_utf8_lines(source_path),
        "source_variant": variant,
        "category": category,
        "section_id": section_id,
        "factor_id": factor_id,
        "output_dir": str(output_dir.resolve()),
        "source_present": True,
        "status": "pending",
        "attempt": 0,
        "claimed_by": None,
        "claimed_at": None,
        "updated_at": utc_now(),
        "message": "",
        "checks": {},
        "depends_on_factor_refs": [],
    }


def discover_sources(corpus_root: Path) -> List[Path]:
    if not corpus_root.is_dir():
        raise QueueError(f"语料目录不存在: {corpus_root}")
    return sorted(
        path for path in corpus_root.rglob("*")
        if path.is_file()
        and path.suffix.lower() in SOURCE_SUFFIXES
        and path.name.lower() != "readme.md"
        and not any(part.startswith(".") for part in path.relative_to(corpus_root).parts)
    )


def inventory_state(
    corpus_root: Path,
    specs_root: Path,
    existing: Optional[Dict[str, Any]] = None,
    source_catalog_path: Optional[Path] = None,
) -> Dict[str, Any]:
    corpus_root = corpus_root.resolve()
    specs_root = specs_root.resolve()
    discovered = [task_from_source(corpus_root, specs_root, path) for path in discover_sources(corpus_root)]

    if source_catalog_path is None and (existing or {}).get("source_catalog_path"):
        source_catalog_path = Path(existing["source_catalog_path"])
    catalog = load_source_catalog(source_catalog_path) if source_catalog_path else None
    catalog_paths = set(catalog["chapters"]) if catalog else set()
    discovered_paths = {task["source_relpath"] for task in discovered}
    missing_catalog_sources = sorted(catalog_paths - discovered_paths)
    if missing_catalog_sources:
        raise QueueError(
            "source catalog 引用的章节文本不存在于 corpus: "
            f"{missing_catalog_sources}"
        )
    if catalog:
        uncataloged_sources = sorted(discovered_paths - catalog_paths)
        if uncataloged_sources:
            raise QueueError(
                "catalog 外的章节文本不能进入 PDF 队列；请先加入 catalog 或移出本批语料: "
                f"{uncataloged_sources}"
            )
        for task in discovered:
            if not _attach_catalog_provenance(task, catalog):
                raise QueueError(
                    f"catalog 未枚举章节文本: {task['source_relpath']}"
                )

    duplicate_task_ids = sorted(
        task_id for task_id, count in Counter(item["task_id"] for item in discovered).items()
        if count > 1
    )
    duplicate_factor_ids = sorted(
        factor_id for factor_id, count in Counter(item["factor_id"] for item in discovered).items()
        if count > 1
    )
    if duplicate_task_ids:
        raise QueueError(f"语料产生重复 task_id: {duplicate_task_ids}")
    if duplicate_factor_ids:
        raise QueueError(
            "语料产生重复 factor_id；不同模式必须使用独立 variant 目录: "
            f"{duplicate_factor_ids}"
        )

    old_by_path = {
        item["source_relpath"]: item
        for item in (existing or {}).get("tasks", [])
        if not catalog or item.get("source_relpath") in catalog_paths
    }
    merged: List[Dict[str, Any]] = []
    current_paths = set()
    for new_task in discovered:
        relpath = new_task["source_relpath"]
        current_paths.add(relpath)
        old_task = old_by_path.get(relpath)
        same_source = (
            old_task
            and old_task.get("source_sha256") == new_task["source_sha256"]
        )
        same_provenance = same_source and all(
            old_task.get(field) == new_task.get(field)
            for field in (
                *TASK_PROVENANCE_FIELDS,
                "source_catalog_path",
                "source_catalog_sha256",
            )
        )
        if same_provenance:
            for field in (
                "status", "attempt", "claimed_by", "claimed_at", "updated_at",
                "message", "checks", "verification_snapshot",
                "depends_on_factor_refs",
            ):
                if field in old_task:
                    new_task[field] = old_task[field]
        elif old_task:
            if not same_source:
                new_task["message"] = "源文件 SHA-256 已变化，任务已重置为 pending。"
            else:
                new_task["message"] = "来源 sidecar 证据已变化，任务已重置为 pending。"
        merged.append(new_task)

    for relpath, old_task in sorted(old_by_path.items()):
        if relpath in current_paths:
            continue
        missing = dict(old_task)
        missing.update({
            "source_present": False,
            "status": "blocked",
            "updated_at": utc_now(),
            "message": "源文件已从语料目录移除。",
        })
        merged.append(missing)

    created_at = (existing or {}).get("created_at", utc_now())
    state = {
        "schema_version": QUEUE_SCHEMA_VERSION,
        "corpus_root": str(corpus_root),
        "specs_root": str(specs_root),
        "created_at": created_at,
        "updated_at": utc_now(),
        "tasks": sorted(merged, key=lambda item: item["task_id"]),
    }
    if catalog:
        state.update({
            "source_catalog_path": catalog["path"],
            "source_catalog_sha256": catalog["sha256"],
        })
    refresh_task_dependencies(state)
    return state


def validate_state(state: Dict[str, Any]) -> None:
    if state.get("schema_version") != QUEUE_SCHEMA_VERSION:
        raise QueueError(
            f"不支持的 queue schema_version: {state.get('schema_version')!r}"
        )
    if not isinstance(state.get("tasks"), list):
        raise QueueError("queue.tasks 必须是列表")
    task_ids = []
    for task in state["tasks"]:
        task_id = task.get("task_id")
        task_ids.append(task_id)
        if task.get("status") not in STATUSES:
            raise QueueError(f"{task_id}: 未知状态 {task.get('status')!r}")
        if not task.get("source_relpath") or not task.get("factor_id"):
            raise QueueError(f"{task_id}: 缺少 source_relpath 或 factor_id")
        dependencies = task.get("depends_on_factor_refs", [])
        if (
            not isinstance(dependencies, list)
            or any(not isinstance(item, str) or not item for item in dependencies)
        ):
            raise QueueError(f"{task_id}: depends_on_factor_refs 必须是非空字符串列表")
        if len(dependencies) != len(set(dependencies)):
            raise QueueError(f"{task_id}: depends_on_factor_refs 不能重复")
        if task.get("factor_id") in dependencies:
            raise QueueError(f"{task_id}: 不能依赖自身 factor")
        catalog_only_fields = set(TASK_PROVENANCE_FIELDS) - {"category"}
        present_catalog_fields = catalog_only_fields & set(task)
        if present_catalog_fields and not set(TASK_PROVENANCE_FIELDS) <= set(task):
            missing = sorted(set(TASK_PROVENANCE_FIELDS) - set(task))
            raise QueueError(f"{task_id}: PDF 来源证据不完整，缺少 {missing}")
        if present_catalog_fields and not task.get("source_catalog_path"):
            raise QueueError(f"{task_id}: PDF 来源证据缺少 source_catalog_path")
        if present_catalog_fields and not task.get("source_catalog_sha256"):
            raise QueueError(f"{task_id}: PDF 来源证据缺少 source_catalog_sha256")
        if present_catalog_fields:
            for field in ("source_catalog_path", "source_catalog_sha256"):
                if task.get(field) != state.get(field):
                    raise QueueError(f"{task_id}: task.{field} 与 queue.{field} 不一致")
    duplicates = sorted(
        task_id for task_id, count in Counter(task_ids).items() if count > 1
    )
    if duplicates:
        raise QueueError(f"queue 中 task_id 重复: {duplicates}")
    task_topological_order(state)


def read_state(path: Path) -> Dict[str, Any]:
    if not path.is_file():
        raise QueueError(f"队列文件不存在，请先运行 inventory: {path}")
    try:
        state = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise QueueError(f"无法读取队列文件 {path}: {exc}") from exc
    validate_state(state)
    return state


def write_state(path: Path, state: Dict[str, Any]) -> None:
    validate_state(state)
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(state, ensure_ascii=False, indent=2) + "\n"
    with tempfile.NamedTemporaryFile(
        "w", encoding="utf-8", dir=path.parent, prefix=f".{path.name}.", delete=False
    ) as target:
        target.write(payload)
        temporary_path = Path(target.name)
    os.replace(temporary_path, path)


@contextmanager
def locked_state(path: Path) -> Iterator[None]:
    lock_path = path.with_suffix(path.suffix + ".lock")
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    with lock_path.open("a+", encoding="utf-8") as lock_file:
        fcntl.flock(lock_file.fileno(), fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(lock_file.fileno(), fcntl.LOCK_UN)


def find_task(state: Dict[str, Any], task_id: str) -> Dict[str, Any]:
    for task in state["tasks"]:
        if task["task_id"] == task_id:
            return task
    raise QueueError(f"未知 task_id: {task_id}")


def apply_factor_dependency_graph(
    state: Dict[str, Any],
    graph: Dict[str, Iterable[str]],
    *,
    replace_missing: bool = True,
) -> None:
    """Persist direct factor dependencies on their queue tasks."""
    for task in state["tasks"]:
        factor_id = task["factor_id"]
        if factor_id in graph:
            task["depends_on_factor_refs"] = sorted(set(graph[factor_id]))
        elif replace_missing:
            task["depends_on_factor_refs"] = []


def refresh_task_dependencies(
    state: Dict[str, Any],
    *,
    strict: bool = False,
) -> bool:
    """Load available packages and synchronize the queue dependency DAG."""
    try:
        registry = FactorPackageRegistry(Path(state["specs_root"]))
        registry.load_all()
        graph = registry.factor_dependency_graph()
        registry.factor_topological_order()
    except (FactorPackageLoadError, OSError, ValueError) as exc:
        if strict:
            raise QueueError(f"无法同步 Factor Package 依赖图: {exc}") from exc
        return False
    apply_factor_dependency_graph(state, graph, replace_missing=False)
    return True


def task_topological_order(state: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Return queue tasks with dependencies before consumers."""
    tasks_by_factor = {task["factor_id"]: task for task in state["tasks"]}
    graph = {
        factor_id: {
            dependency_id
            for dependency_id in task.get("depends_on_factor_refs", [])
            if dependency_id in tasks_by_factor
        }
        for factor_id, task in tasks_by_factor.items()
    }
    ordered: List[str] = []
    state_by_factor: Dict[str, int] = {}
    stack: List[str] = []

    def visit(factor_id: str) -> None:
        marker = state_by_factor.get(factor_id, 0)
        if marker == 2:
            return
        if marker == 1:
            start = stack.index(factor_id)
            cycle = [*stack[start:], factor_id]
            raise QueueError("任务依赖存在环: " + " -> ".join(cycle))
        state_by_factor[factor_id] = 1
        stack.append(factor_id)
        for dependency_id in sorted(graph[factor_id]):
            visit(dependency_id)
        stack.pop()
        state_by_factor[factor_id] = 2
        ordered.append(factor_id)

    for factor_id in sorted(graph):
        visit(factor_id)
    return [tasks_by_factor[factor_id] for factor_id in ordered]


def _factor_package_dirs(specs_root: Path) -> Dict[str, Path]:
    result: Dict[str, Path] = {}
    if not specs_root.is_dir():
        return result
    for path in sorted(specs_root.rglob("*.factor.yaml")):
        try:
            raw = yaml.safe_load(path.read_text(encoding="utf-8"))
        except (OSError, yaml.YAMLError):
            continue
        if isinstance(raw, dict) and raw.get("kind") == "factor" and raw.get("id"):
            result[str(raw["id"])] = path.parent
    return result


def _dependencies_available(state: Dict[str, Any], task: Dict[str, Any]) -> bool:
    tasks_by_factor = {item["factor_id"]: item for item in state["tasks"]}
    package_dirs = _factor_package_dirs(Path(state["specs_root"]))
    produced_statuses = {"generated", "needs_review", "static_complete"}
    for dependency_id in task.get("depends_on_factor_refs", []):
        dependency_task = tasks_by_factor.get(dependency_id)
        if dependency_task is not None:
            if dependency_task["status"] not in produced_statuses:
                return False
            if dependency_task["status"] == "static_complete":
                fresh, _ = static_completion_freshness(
                    dependency_task,
                    corpus_root=Path(state["corpus_root"]),
                    state=state,
                )
                if not fresh:
                    return False
        elif dependency_id not in package_dirs:
            return False
    return True


def select_pending_task(
    state: Dict[str, Any],
    *,
    variant: Optional[str] = None,
    category: Optional[str] = None,
) -> Dict[str, Any]:
    normalized_variant = normalize_id(variant, field="variant") if variant else None
    normalized_category = normalize_id(category, field="category") if category else None
    corpus_root = Path(state["corpus_root"])
    for accepted_status in ("pending", "static_complete"):
        for task in task_topological_order(state):
            if task["status"] != accepted_status or not task.get("source_present", True):
                continue
            if normalized_variant and task["source_variant"] != normalized_variant:
                continue
            if normalized_category and task["category"] != normalized_category:
                continue
            if not _dependencies_available(state, task):
                continue
            if accepted_status == "static_complete":
                fresh, _ = static_completion_freshness(
                    task, corpus_root=corpus_root, state=state
                )
                if fresh:
                    continue
            return task
    raise QueueError("没有符合过滤条件的 pending 任务")


def render_task(
    state: Dict[str, Any],
    task: Dict[str, Any],
    template_path: Path,
    output_path: Path,
    *,
    embed_source: bool = False,
) -> Path:
    if not template_path.is_file():
        raise QueueError(f"任务模板不存在: {template_path}")
    corpus_root = Path(state["corpus_root"])
    source_path = corpus_root / task["source_relpath"]
    if not source_path.is_file():
        raise QueueError(f"任务源文件不存在: {source_path}")
    source_content = (
        source_path.read_text(encoding="utf-8")
        if embed_source
        else "（原文未内嵌。AI 必须从上面的 SOURCE_PATH 读取完整文件。）"
    )
    replacements = {
        "{{TASK_ID}}": task["task_id"],
        "{{SOURCE_PATH}}": str(source_path.resolve()),
        "{{SOURCE_RELPATH}}": task["source_relpath"],
        "{{SOURCE_SHA256}}": task["source_sha256"],
        "{{SOURCE_LINE_COUNT}}": str(task["source_line_count"]),
        "{{SOURCE_VARIANT}}": task["source_variant"],
        "{{CATEGORY}}": task["category"],
        "{{FACTOR_ID}}": task["factor_id"],
        "{{OUTPUT_DIR}}": task["output_dir"],
        "{{SOURCE_CONTENT}}": source_content,
        "{{SOURCE_CATALOG_PATH}}": str(task.get("source_catalog_path", "not_catalog_backed")),
        "{{DOCUMENT_ID}}": str(task.get("document_id", "not_catalog_backed")),
        "{{PARENT_PDF_PATH}}": str(task.get("parent_pdf_path", "not_catalog_backed")),
        "{{PARENT_PDF_SHA256}}": str(task.get("parent_pdf_sha256", "not_catalog_backed")),
        "{{PRODUCT_VERSION}}": str(task.get("product_version", "unknown")),
        "{{DOCUMENT_VERSION}}": str(task.get("document_version", "unknown")),
        "{{EXTRACTION_RULE_VERSION}}": str(task.get("extraction_rule_version", "not_catalog_backed")),
        "{{SECTION_NUMBER}}": str(task.get("section_number", "unknown")),
        "{{OUTLINE_PATH}}": " > ".join(task.get("outline_path", [])) or "not_catalog_backed",
        "{{START_DESTINATION}}": json.dumps(
            task.get("start_destination", {}), ensure_ascii=False, sort_keys=True
        ),
        "{{END_DESTINATION}}": json.dumps(
            task.get("end_destination", {}), ensure_ascii=False, sort_keys=True
        ),
        "{{PHYSICAL_PAGE_RANGE}}": (
            f"{task.get('physical_page_start', 'unknown')}-"
            f"{task.get('physical_page_end', 'unknown')}"
        ),
        "{{PRINTED_PAGE_RANGE}}": (
            f"{task.get('printed_page_start', 'unknown')}-"
            f"{task.get('printed_page_end', 'unknown')}"
        ),
    }
    rendered = template_path.read_text(encoding="utf-8")
    for marker, value in replacements.items():
        rendered = rendered.replace(marker, value)
    unresolved = sorted(set(re.findall(r"\{\{[A-Z0-9_]+\}\}", rendered)))
    if unresolved:
        raise QueueError(f"任务模板存在未解析变量: {unresolved}")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(rendered, encoding="utf-8")
    return output_path


def set_task_status(
    task: Dict[str, Any],
    new_status: str,
    *,
    message: str = "",
    force: bool = False,
) -> None:
    if new_status not in EDITABLE_STATUSES:
        raise QueueError(
            "update 不能直接设置 static_complete；必须由 verify 三道门禁成功后写入。"
        )
    old_status = task["status"]
    if not force and new_status not in TRANSITIONS[old_status]:
        raise QueueError(f"非法状态迁移: {old_status} -> {new_status}")
    task["status"] = new_status
    task.pop("verification_snapshot", None)
    task["updated_at"] = utc_now()
    task["message"] = message
    if new_status == "pending":
        task["claimed_by"] = None
        task["claimed_at"] = None


def run_check(command: List[str], cwd: Path) -> Dict[str, Any]:
    result = subprocess.run(
        command,
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    return {
        "command": command,
        "returncode": result.returncode,
        "output": result.stdout,
    }


def _validate_current_source(
    state: Dict[str, Any], task: Dict[str, Any], errors: List[str]
) -> None:
    corpus_root = Path(state["corpus_root"]).resolve()
    source_path = (corpus_root / task["source_relpath"]).resolve()
    try:
        source_path.relative_to(corpus_root)
    except ValueError:
        errors.append("任务 source_relpath 越出 corpus_root")
        return
    if not source_path.is_file():
        errors.append(f"任务章节文本不存在: {source_path}")
        return
    try:
        current_sha256 = sha256_file(source_path)
        current_line_count = count_utf8_lines(source_path)
    except (OSError, QueueError) as exc:
        errors.append(f"无法复核任务章节文本: {exc}")
        return
    if current_sha256 != task.get("source_sha256"):
        errors.append("当前章节文本 SHA-256 与任务快照不一致")
    if current_line_count != task.get("source_line_count"):
        errors.append("当前章节文本行数与任务快照不一致")


def _validate_catalog_envelope(
    state: Optional[Dict[str, Any]],
    task: Dict[str, Any],
    errors: List[str],
) -> Optional[Dict[str, Any]]:
    catalog_backed = any(
        field in task
        for field in ("source_catalog_path", "chapter_sha256", "parent_pdf_sha256")
    )
    if not catalog_backed:
        return None
    if state is None:
        errors.append("PDF catalog 任务必须提供 queue state 才能重算来源证据")
        return None

    catalog_path_value = task.get("source_catalog_path") or state.get("source_catalog_path")
    if not catalog_path_value:
        errors.append("PDF catalog 任务缺少 source_catalog_path")
        return None
    try:
        catalog = load_source_catalog(Path(catalog_path_value))
    except QueueError as exc:
        errors.append(str(exc))
        return None

    if state.get("source_catalog_path") != catalog["path"]:
        errors.append("queue.source_catalog_path 与任务 catalog 不一致")
    if state.get("source_catalog_sha256") != catalog["sha256"]:
        errors.append("queue.source_catalog_sha256 与当前 catalog SHA-256 不一致")
    if task.get("source_catalog_path") != catalog["path"]:
        errors.append("task.source_catalog_path 与当前 catalog 不一致")
    queued_catalog_sha = task.get("source_catalog_sha256")
    if queued_catalog_sha != catalog["sha256"]:
        errors.append(
            "source catalog SHA-256 与任务快照不一致: "
            f"expected={queued_catalog_sha} actual={catalog['sha256']}"
        )

    chapter = catalog["chapters"].get(task["source_relpath"])
    if chapter is None:
        errors.append(
            f"source catalog 不包含任务章节: {task['source_relpath']}"
        )
        return catalog
    current_provenance = _catalog_task_provenance(catalog, chapter)
    for field in TASK_PROVENANCE_FIELDS:
        if task.get(field) != current_provenance[field]:
            errors.append(
                f"任务来源字段 {field} 与当前 source catalog 不一致: "
                f"expected={task.get(field)!r} actual={current_provenance[field]!r}"
            )
    if chapter["variant"] != task.get("source_variant"):
        errors.append("source catalog variant 与任务 source_variant 不一致")
    if chapter["category"] != task.get("category"):
        errors.append("source catalog category 与任务 category 不一致")
    return catalog


def ensure_verify_writeback_safe(
    state: Dict[str, Any],
    task_snapshot: Dict[str, Any],
    current_task: Dict[str, Any],
) -> None:
    changed_fields = [
        field
        for field in VERIFY_GUARD_FIELDS
        if task_snapshot.get(field) != current_task.get(field)
    ]
    if changed_fields:
        raise QueueError(
            "verify 期间 queue 来源证据已变化；检查结果未写入: "
            f"{changed_fields}"
        )

    evidence_errors: List[str] = []
    _validate_current_source(state, task_snapshot, evidence_errors)
    _validate_catalog_envelope(state, task_snapshot, evidence_errors)
    if evidence_errors:
        unique_errors = list(dict.fromkeys(evidence_errors))
        raise QueueError(
            "verify 期间来源证据已变化；检查结果未写入: "
            + "; ".join(unique_errors)
        )


def _validate_supplemental_catalog_refs(
    ledger_data: Dict[str, Any],
    catalog: Optional[Dict[str, Any]],
    errors: List[str],
) -> None:
    supplemental_sources = ledger_data.get("supplemental_sources", [])
    if not isinstance(supplemental_sources, list):
        return
    for index, source in enumerate(supplemental_sources):
        if not isinstance(source, dict):
            continue
        url = source.get("url")
        chapter_ref = source.get("catalog_chapter_ref")
        has_url = isinstance(url, str) and bool(url.strip())
        has_chapter_ref = chapter_ref is not None
        if has_url == has_chapter_ref:
            errors.append(
                f"supplemental_sources[{index}] 必须且只能提供 url 或 catalog_chapter_ref"
            )
            continue
        if not has_chapter_ref:
            continue
        if catalog is None:
            errors.append(
                f"supplemental_sources[{index}].catalog_chapter_ref "
                "需要同一任务的 source catalog"
            )
            continue
        if not isinstance(chapter_ref, dict):
            errors.append(
                f"supplemental_sources[{index}].catalog_chapter_ref 必须是对象"
            )
            continue
        if chapter_ref.get("document_id") != catalog["document_id"]:
            errors.append(
                f"supplemental_sources[{index}].catalog_chapter_ref.document_id "
                "与 source catalog 不一致"
            )
        relpath = chapter_ref.get("source_relpath")
        chapter = catalog["chapters"].get(relpath)
        if chapter is None:
            errors.append(
                f"supplemental_sources[{index}].catalog_chapter_ref.source_relpath "
                f"不存在: {relpath!r}"
            )
            continue
        if chapter_ref.get("chapter_sha256") != chapter["chapter_sha256"]:
            errors.append(
                f"supplemental_sources[{index}].catalog_chapter_ref.chapter_sha256 "
                "与 source catalog 不一致"
            )
        if source.get("version") != catalog["product_version"]:
            errors.append(
                f"supplemental_sources[{index}].version 与 source catalog "
                "product_version 不一致"
            )


def validate_task_artifact(
    task: Dict[str, Any], state: Optional[Dict[str, Any]] = None
) -> Dict[str, Any]:
    """Bind a generated package to the exact queued source, not an old package."""
    output_dir = Path(task["output_dir"])
    factor_paths = sorted(output_dir.glob("*.factor.yaml"))
    ledger_paths = sorted(output_dir.glob("*.source.yaml"))
    errors: List[str] = []
    if len(factor_paths) != 1:
        errors.append(f"OUTPUT_DIR 必须且只能有一个 *.factor.yaml，实际 {len(factor_paths)}")
    if len(ledger_paths) != 1:
        errors.append(f"OUTPUT_DIR 必须且只能有一个 *.source.yaml，实际 {len(ledger_paths)}")

    factor_data: Dict[str, Any] = {}
    ledger_data: Dict[str, Any] = {}
    try:
        if factor_paths:
            factor_data = yaml.safe_load(factor_paths[0].read_text(encoding="utf-8")) or {}
        if ledger_paths:
            ledger_data = yaml.safe_load(ledger_paths[0].read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError) as exc:
        errors.append(f"无法读取任务产物 YAML: {exc}")

    if state is not None:
        _validate_current_source(state, task, errors)
    catalog = _validate_catalog_envelope(state, task, errors)

    expected_artifact_sha256 = task.get("chapter_sha256", task["source_sha256"])
    if factor_data:
        if factor_data.get("id") != task["factor_id"]:
            errors.append(
                f"factor.id={factor_data.get('id')!r} 与任务 factor_id={task['factor_id']!r} 不一致"
            )
        factor_source = factor_data.get("source")
        if not isinstance(factor_source, dict):
            errors.append("factor.source 必须是对象")
            factor_source = {}
        factor_sha = factor_source.get("artifact_sha256")
        if factor_sha != expected_artifact_sha256:
            errors.append("factor.source.artifact_sha256 与任务原文 SHA-256 不一致")
        if task.get("product_version") is not None:
            factor_version = factor_source.get("version")
            if factor_version != task["product_version"]:
                errors.append(
                    "factor.source.version 与 source catalog product_version 不一致"
                )
        factor_catalog_ref = factor_source.get("catalog_chapter_ref")
        if task.get("chapter_sha256") is not None:
            if factor_source.get("parent_pdf_sha256") != task.get("parent_pdf_sha256"):
                errors.append(
                    "factor.source.parent_pdf_sha256 缺失或与当前任务 catalog 不一致"
                )
            if (
                factor_source.get("extraction_rule_version")
                != task.get("extraction_rule_version")
            ):
                errors.append(
                    "factor.source.extraction_rule_version 缺失或与当前任务 catalog 不一致"
                )
            expected_catalog_ref = {
                "document_id": task["document_id"],
                "source_relpath": task["source_relpath"],
                "chapter_sha256": task["chapter_sha256"],
            }
            if factor_catalog_ref != expected_catalog_ref:
                errors.append(
                    "factor.source.catalog_chapter_ref 缺失或与当前任务 catalog 不一致"
                )
        elif factor_catalog_ref is not None:
            errors.append(
                "非 catalog 任务无法验证 factor.source.catalog_chapter_ref"
            )
    if ledger_data:
        if ledger_data.get("factor_ref") != task["factor_id"]:
            errors.append("source ledger factor_ref 与任务 factor_id 不一致")
        if ledger_data.get("artifact_sha256") != expected_artifact_sha256:
            errors.append("source ledger artifact_sha256 与任务原文 SHA-256 不一致")
        if ledger_data.get("source_line_count") != task["source_line_count"]:
            errors.append("source ledger source_line_count 与任务原文行数不一致")
        _validate_supplemental_catalog_refs(ledger_data, catalog, errors)
        if ledger_data.get('supplemental_sources'):
            try:
                supplemental_verification_snapshot(
                    output_dir, Path(catalog['path']) if catalog else None,
                    Path(state['corpus_root']) if state and state.get('corpus_root') else None)
            except QueueError as exc:
                errors.append(str(exc))

    return {
        "command": ["validate_task_artifact", task["task_id"]],
        "returncode": 1 if errors else 0,
        "output": "\n".join(errors) if errors else "OK task envelope matches generated package",
    }


def verify_task(state: Dict[str, Any], task: Dict[str, Any], output_dir: Path) -> bool:
    factor_id = task["factor_id"]
    checks = {
        "task_envelope": validate_task_artifact(task, state=state),
    }
    if checks["task_envelope"]["returncode"] == 0:
        checks["lint"] = run_check(
            [sys.executable, "scripts/lint_factor_packages_v1.py", "specs"], ROOT_DIR
        )
    if checks.get("lint", {}).get("returncode") == 0:
        checks["generate"] = run_check(
            [
                sys.executable,
                "scripts/generate_factor_package_sql.py",
                "--factor",
                factor_id,
                "--output-dir",
                str(output_dir),
            ],
            ROOT_DIR,
        )
    if checks.get("generate", {}).get("returncode") == 0:
        checks["audit"] = run_check(
            [
                sys.executable,
                "scripts/audit_factor_coverage_v1.py",
                "--factor",
                factor_id,
                "--fail-on-gaps",
                "--output-dir",
                str(output_dir),
            ],
            ROOT_DIR,
        )
    task["checks"] = {"checked_at": utc_now(), **checks}
    task["updated_at"] = utc_now()
    succeeded = all(
        checks.get(name, {}).get("returncode") == 0
        for name in ("task_envelope", "lint", "generate", "audit")
    )
    if succeeded:
        try:
            dependencies = dependency_verification_snapshot(state, task)
            supplements = supplemental_verification_snapshot(
                Path(task['output_dir']),
                Path(task.get('source_catalog_path') or state['source_catalog_path'])
                if task.get('source_catalog_path') or state.get('source_catalog_path') else None,
                Path(state['corpus_root']))
        except QueueError as exc:
            succeeded = False
            checks['input_snapshot'] = {'returncode': 1, 'output': str(exc)}
            task['checks']['input_snapshot'] = checks['input_snapshot']
    if succeeded:
        task["verification_snapshot"] = {
            "factor_package_sha256": factor_package_sha256(Path(task["output_dir"])),
            "toolchain_sha256": verification_toolchain_sha256(),
            "source_sha256": task["source_sha256"],
            "catalog_sha256": task.get("source_catalog_sha256"),
            "parent_pdf_sha256": task.get("parent_pdf_sha256"),
            "dependencies": dependencies,
            "supplemental_sources": supplements,
            "verified_at": utc_now(),
        }
        task["status"] = "static_complete"
        task["message"] = (
            "Factor Package V1 严格加载、SQL 生成和静态覆盖审计均通过；"
            "该状态不代表数据库行为场景已执行。"
        )
    else:
        task.pop("verification_snapshot", None)
        task["status"] = "needs_review"
        failed = [
            name for name in ("task_envelope", "lint", "generate", "audit", "input_snapshot")
            if name in checks and checks[name]["returncode"] != 0
        ]
        task["message"] = f"静态门禁未通过: {', '.join(failed)}"
    return succeeded


def task_view(state: Dict[str, Any], task: Dict[str, Any]) -> Dict[str, Any]:
    result = dict(task)
    result["source_path"] = str(
        (Path(state["corpus_root"]) / task["source_relpath"]).resolve()
    )
    return result


def print_summary(state: Dict[str, Any]) -> None:
    counts = Counter(task["status"] for task in state["tasks"])
    total = len(state["tasks"])
    current_toolchain = verification_toolchain_sha256()
    freshness = [
        static_completion_freshness(
            task,
            toolchain_sha256=current_toolchain,
            corpus_root=Path(state["corpus_root"]),
            state=state,
        )[0]
        for task in state["tasks"]
        if task["status"] == "static_complete"
    ]
    complete = sum(freshness)
    stale = len(freshness) - complete
    print(
        f"tasks={total} static_complete={complete} "
        f"static_complete_stale={stale} remaining={total - complete}"
    )
    print(" ".join(f"{status}={counts[status]}" for status in sorted(STATUSES)))
    by_variant = Counter(task["source_variant"] for task in state["tasks"])
    by_category = Counter(task["category"] for task in state["tasks"])
    print("variants: " + " ".join(f"{key}={value}" for key, value in sorted(by_variant.items())))
    print("categories: " + " ".join(f"{key}={value}" for key, value in sorted(by_category.items())))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="内网离线 Doc2Spec 任务队列；不调用 AI、不联网、不执行数据库 SQL。"
    )
    parser.add_argument("--state", type=Path, default=DEFAULT_STATE_PATH)
    subparsers = parser.add_subparsers(dest="command", required=True)

    inventory = subparsers.add_parser("inventory", help="扫描章节语料并创建或合并队列")
    inventory.add_argument("--corpus-dir", type=Path, required=True)
    inventory.add_argument("--specs-dir", type=Path, default=ROOT_DIR / "specs")
    inventory.add_argument(
        "--source-catalog",
        type=Path,
        help="可选 PDF 章节 sidecar；省略时沿用现有队列中的路径",
    )

    claim = subparsers.add_parser("claim", help="原子认领下一个 pending 任务")
    claim.add_argument("--worker", required=True)
    claim.add_argument("--variant")
    claim.add_argument("--category")
    claim.add_argument("--render", action="store_true", help="同时渲染 AI 任务文件")
    claim.add_argument("--embed-source", action="store_true", help="在任务文件内嵌原文")
    claim.add_argument("--template", type=Path, default=DEFAULT_TEMPLATE_PATH)
    claim.add_argument("--task-dir", type=Path, default=DEFAULT_TASK_DIR)

    render = subparsers.add_parser("render", help="为指定任务渲染 AI 任务文件")
    render.add_argument("--task-id", required=True)
    render.add_argument("--template", type=Path, default=DEFAULT_TEMPLATE_PATH)
    render.add_argument("--output", type=Path)
    render.add_argument("--embed-source", action="store_true")

    update = subparsers.add_parser("update", help="记录 AI 的任务结果或人工处理结果")
    update.add_argument("--task-id", required=True)
    update.add_argument("--status", choices=sorted(EDITABLE_STATUSES), required=True)
    update.add_argument("--message", default="")
    update.add_argument("--force", action="store_true", help="仅供人工修复队列状态")

    verify = subparsers.add_parser("verify", help="运行 V1 严格加载、生成和静态覆盖审计")
    verify.add_argument("--task-id", required=True)
    verify.add_argument("--output-dir", type=Path, default=DEFAULT_VERIFY_OUTPUT_DIR)

    list_parser = subparsers.add_parser("list", help="列出任务")
    list_parser.add_argument("--status", choices=sorted(STATUSES))
    list_parser.add_argument("--variant")
    list_parser.add_argument("--category")

    subparsers.add_parser("summary", help="输出队列进度汇总")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        if args.command == "inventory":
            with locked_state(args.state):
                existing = read_state(args.state) if args.state.exists() else None
                state = inventory_state(
                    args.corpus_dir,
                    args.specs_dir,
                    existing,
                    source_catalog_path=args.source_catalog,
                )
                write_state(args.state, state)
            print(f"queue={args.state.resolve()}")
            print_summary(state)
            return 0

        if args.command == "claim":
            with locked_state(args.state):
                state = read_state(args.state)
                refresh_task_dependencies(state)
                task = select_pending_task(
                    state, variant=args.variant, category=args.category
                )
                previous_status = task["status"]
                stale_reasons: List[str] = []
                if previous_status == "static_complete":
                    _, stale_reasons = static_completion_freshness(
                        task, corpus_root=Path(state["corpus_root"])
                    )
                task["status"] = "in_progress"
                task.pop("verification_snapshot", None)
                task["attempt"] += 1
                task["claimed_by"] = args.worker
                task["claimed_at"] = utc_now()
                task["updated_at"] = utc_now()
                task["message"] = (
                    "旧 static_complete 已陈旧，重新认领: "
                    + ", ".join(stale_reasons)
                    if previous_status == "static_complete"
                    else ""
                )
                rendered_path = None
                if args.render:
                    rendered_path = render_task(
                        state,
                        task,
                        args.template,
                        args.task_dir / f"{task['task_id']}.md",
                        embed_source=args.embed_source,
                    )
                write_state(args.state, state)
            result = task_view(state, task)
            if rendered_path:
                result["rendered_task_path"] = str(rendered_path.resolve())
            print(json.dumps(result, ensure_ascii=False, indent=2))
            return 0

        if args.command == "render":
            state = read_state(args.state)
            task = find_task(state, args.task_id)
            output = args.output or DEFAULT_TASK_DIR / f"{task['task_id']}.md"
            rendered = render_task(
                state, task, args.template, output, embed_source=args.embed_source
            )
            print(rendered.resolve())
            return 0

        if args.command == "update":
            with locked_state(args.state):
                state = read_state(args.state)
                refresh_task_dependencies(state, strict=True)
                task = find_task(state, args.task_id)
                set_task_status(
                    task, args.status, message=args.message, force=args.force
                )
                state["updated_at"] = utc_now()
                write_state(args.state, state)
            print(json.dumps(task_view(state, task), ensure_ascii=False, indent=2))
            return 0

        if args.command == "verify":
            # Static checks can take minutes.  Do not hold the queue lock while
            # they run, otherwise unrelated workers cannot claim new tasks.
            state = read_state(args.state)
            refresh_task_dependencies(state, strict=True)
            task_snapshot = dict(find_task(state, args.task_id))
            if task_snapshot["status"] not in {
                "generated", "needs_review", "static_complete"
            }:
                raise QueueError(
                    "verify 只接受 generated、needs_review 或 static_complete 任务；"
                    f"当前状态是 {task_snapshot['status']}"
                )
            source_snapshot = dict(task_snapshot)
            succeeded = verify_task(state, task_snapshot, args.output_dir)
            with locked_state(args.state):
                state = read_state(args.state)
                task = find_task(state, args.task_id)
                ensure_verify_writeback_safe(state, source_snapshot, task)
                for field in (
                    "checks", "status", "message", "updated_at",
                    "verification_snapshot", "depends_on_factor_refs",
                ):
                    if field not in task_snapshot:
                        task.pop(field, None)
                        continue
                    task[field] = task_snapshot[field]
                state["updated_at"] = utc_now()
                write_state(args.state, state)
            for name in ("task_envelope", "lint", "generate", "audit"):
                check = task["checks"].get(name)
                if check:
                    print(f"[{name}] returncode={check['returncode']}")
                    print(check["output"].rstrip())
            print(f"status={task['status']}")
            return 0 if succeeded else 1

        state = read_state(args.state)
        if args.command == "summary":
            print_summary(state)
            return 0
        if args.command == "list":
            tasks: Iterable[Dict[str, Any]] = state["tasks"]
            if args.status:
                tasks = (item for item in tasks if item["status"] == args.status)
            if args.variant:
                variant = normalize_id(args.variant, field="variant")
                tasks = (item for item in tasks if item["source_variant"] == variant)
            if args.category:
                category = normalize_id(args.category, field="category")
                tasks = (item for item in tasks if item["category"] == category)
            print(json.dumps([task_view(state, item) for item in tasks], ensure_ascii=False, indent=2))
            return 0
    except QueueError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
