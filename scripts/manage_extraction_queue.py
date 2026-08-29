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
from typing import Any, Dict, Iterable, Iterator, List, Optional

import yaml


ROOT_DIR = Path(__file__).resolve().parents[1]
DEFAULT_STATE_PATH = ROOT_DIR / "work" / "doc2spec" / "queue.json"
DEFAULT_TEMPLATE_PATH = ROOT_DIR / "prompts" / "factor_package_v1_extraction.md"
DEFAULT_TASK_DIR = ROOT_DIR / "work" / "doc2spec" / "tasks"
DEFAULT_VERIFY_OUTPUT_DIR = ROOT_DIR / "work" / "doc2spec" / "generated"

QUEUE_SCHEMA_VERSION = 1
SOURCE_SUFFIXES = {".txt", ".md", ".html", ".htm"}
GENERAL_VARIANTS = {"general", "common", "default"}
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
    "static_complete": set(),
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


def count_utf8_lines(path: Path) -> int:
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError as exc:
        raise QueueError(f"语料必须是 UTF-8: {path}: {exc}") from exc
    count = len(text.splitlines())
    if count == 0:
        raise QueueError(f"语料文件为空: {path}")
    return count


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
) -> Dict[str, Any]:
    corpus_root = corpus_root.resolve()
    specs_root = specs_root.resolve()
    discovered = [task_from_source(corpus_root, specs_root, path) for path in discover_sources(corpus_root)]

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
    }
    merged: List[Dict[str, Any]] = []
    current_paths = set()
    for new_task in discovered:
        relpath = new_task["source_relpath"]
        current_paths.add(relpath)
        old_task = old_by_path.get(relpath)
        if old_task and old_task.get("source_sha256") == new_task["source_sha256"]:
            for field in (
                "status", "attempt", "claimed_by", "claimed_at", "updated_at",
                "message", "checks",
            ):
                new_task[field] = old_task.get(field, new_task[field])
        elif old_task:
            new_task["message"] = "源文件 SHA-256 已变化，任务已重置为 pending。"
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
    return {
        "schema_version": QUEUE_SCHEMA_VERSION,
        "corpus_root": str(corpus_root),
        "specs_root": str(specs_root),
        "created_at": created_at,
        "updated_at": utc_now(),
        "tasks": sorted(merged, key=lambda item: item["task_id"]),
    }


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
    duplicates = sorted(
        task_id for task_id, count in Counter(task_ids).items() if count > 1
    )
    if duplicates:
        raise QueueError(f"queue 中 task_id 重复: {duplicates}")


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


def select_pending_task(
    state: Dict[str, Any],
    *,
    variant: Optional[str] = None,
    category: Optional[str] = None,
) -> Dict[str, Any]:
    for task in state["tasks"]:
        if task["status"] != "pending" or not task.get("source_present", True):
            continue
        if variant and task["source_variant"] != normalize_id(variant, field="variant"):
            continue
        if category and task["category"] != normalize_id(category, field="category"):
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


def validate_task_artifact(task: Dict[str, Any]) -> Dict[str, Any]:
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

    if factor_data:
        if factor_data.get("id") != task["factor_id"]:
            errors.append(
                f"factor.id={factor_data.get('id')!r} 与任务 factor_id={task['factor_id']!r} 不一致"
            )
        factor_sha = (factor_data.get("source") or {}).get("artifact_sha256")
        if factor_sha != task["source_sha256"]:
            errors.append("factor.source.artifact_sha256 与任务原文 SHA-256 不一致")
    if ledger_data:
        if ledger_data.get("factor_ref") != task["factor_id"]:
            errors.append("source ledger factor_ref 与任务 factor_id 不一致")
        if ledger_data.get("artifact_sha256") != task["source_sha256"]:
            errors.append("source ledger artifact_sha256 与任务原文 SHA-256 不一致")
        if ledger_data.get("source_line_count") != task["source_line_count"]:
            errors.append("source ledger source_line_count 与任务原文行数不一致")

    return {
        "command": ["validate_task_artifact", task["task_id"]],
        "returncode": 1 if errors else 0,
        "output": "\n".join(errors) if errors else "OK task envelope matches generated package",
    }


def verify_task(state: Dict[str, Any], task: Dict[str, Any], output_dir: Path) -> bool:
    factor_id = task["factor_id"]
    checks = {
        "task_envelope": validate_task_artifact(task),
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
        task["status"] = "static_complete"
        task["message"] = (
            "Factor Package V1 严格加载、SQL 生成和静态覆盖审计均通过；"
            "该状态不代表数据库行为场景已执行。"
        )
    else:
        task["status"] = "needs_review"
        failed = [
            name for name in ("task_envelope", "lint", "generate", "audit")
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
    complete = counts["static_complete"]
    print(f"tasks={total} static_complete={complete} remaining={total - complete}")
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
                state = inventory_state(args.corpus_dir, args.specs_dir, existing)
                write_state(args.state, state)
            print(f"queue={args.state.resolve()}")
            print_summary(state)
            return 0

        if args.command == "claim":
            with locked_state(args.state):
                state = read_state(args.state)
                task = select_pending_task(
                    state, variant=args.variant, category=args.category
                )
                task["status"] = "in_progress"
                task["attempt"] += 1
                task["claimed_by"] = args.worker
                task["claimed_at"] = utc_now()
                task["updated_at"] = utc_now()
                task["message"] = ""
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
            task_snapshot = dict(find_task(state, args.task_id))
            if task_snapshot["status"] not in {"generated", "needs_review"}:
                raise QueueError(
                    "verify 只接受 generated 或 needs_review 任务；"
                    f"当前状态是 {task_snapshot['status']}"
                )
            source_sha256 = task_snapshot["source_sha256"]
            succeeded = verify_task(state, task_snapshot, args.output_dir)
            with locked_state(args.state):
                state = read_state(args.state)
                task = find_task(state, args.task_id)
                if task["source_sha256"] != source_sha256:
                    raise QueueError(
                        "verify 期间原文已变化；检查结果未写入，请重新 inventory 后再验证。"
                    )
                for field in ("checks", "status", "message", "updated_at"):
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
