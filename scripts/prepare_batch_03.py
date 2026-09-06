#!/usr/bin/env python3
"""Prepare local batch 03 task envelopes; never extract facts or execute SQL.

The plan DAG is a reviewed scheduling input, not evidence of consumed Fact refs.
Actual package dependency validation remains in FactorPackageRegistry.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from core.factor_package_model import FactorPackageRegistry
from scripts.manage_extraction_queue import (
    inventory_state, read_state, render_task, task_topological_order, write_state,
)


def validate_plan(plan: dict) -> None:
    new = plan["new_chapters"]
    providers = plan["existing_providers"]
    if not 20 <= len(new) <= 30 or len(set(new)) != len(new):
        raise ValueError("Expected 20–30 distinct new chapters")
    if len(set(providers)) != len(providers) or set(new) & set(providers):
        raise ValueError("New chapters and existing providers must be disjoint")
    known = set(new + providers)
    graph = plan["extraction_dependencies"]
    if set(graph) != set(new):
        raise ValueError("Every new chapter must declare its scheduling dependencies")
    visiting, visited = set(), set()

    def visit(title):
        if title not in known:
            raise ValueError(f"Unknown dependency: {title}")
        if title in visiting:
            raise ValueError(f"Scheduling dependency cycle: {title}")
        if title in visited:
            return
        visiting.add(title)
        for dependency in graph.get(title, []):
            visit(dependency)
        visiting.remove(title)
        visited.add(title)

    for title in new:
        visit(title)
    sections = plan["supplemental_sections"]
    if len({x["section"] for x in sections}) != len(sections):
        raise ValueError("Duplicate supplemental section")
    for item in sections:
        if not item["reason"] or not item["consumers"] or not set(item["consumers"]) <= set(new):
            raise ValueError("Supplemental source requires known consumers and a reason")
    if plan.get("database_execution") is not False:
        raise ValueError("Batch preparation must not enable database execution")


def source_records(catalog_path: Path) -> tuple[dict, dict]:
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    records = {}
    for chapter in catalog["chapters"]:
        path = (catalog_path.parent / chapter["source_relpath"]).resolve()
        if not path.is_relative_to(catalog_path.parent.resolve()):
            raise ValueError("Source escapes corpus directory")
        content = path.read_bytes()
        digest = hashlib.sha256(content).hexdigest()
        if digest != chapter["chapter_sha256"]:
            raise ValueError(f"Source hash mismatch: {path}")
        if chapter["title"] in records:
            raise ValueError(f"Ambiguous chapter title: {chapter['title']}")
        records[chapter["title"]] = {
            "title": chapter["title"], "section_number": chapter["section_number"],
            "source_path": str(path), "source_relpath": chapter["source_relpath"],
            "sha256": digest, "line_count": len(content.decode("utf-8").splitlines()),
            "physical_pages": [chapter["physical_page_start"], chapter["physical_page_end"]],
        }
    return catalog, records


def prepare(batch_root: Path, plan_path: Path, specs_root: Path) -> dict:
    plan = json.loads(plan_path.read_text(encoding="utf-8"))
    validate_plan(plan)
    catalog_path = batch_root / "corpus/catalog.json"
    catalog, all_sources = source_records(catalog_path)
    task_titles = set(plan["new_chapters"] + plan["existing_providers"])
    supplemental_titles = {x["title"] for x in plan["supplemental_sections"]}
    if set(all_sources) != task_titles | supplemental_titles:
        raise ValueError("Corpus does not match the closed task and supplemental source selection")
    chapters = {title: all_sources[title] for title in task_titles}
    supplements = {title: all_sources[title] for title in supplemental_titles}
    for item in plan["supplemental_sections"]:
        if supplements[item["title"]]["section_number"] != item["section"]:
            raise ValueError(f"Supplemental section mismatch: {item['title']}")

    registry = FactorPackageRegistry(specs_root)
    registry.load_all()
    queue_path = batch_root / "queue.json"
    state = inventory_state(
        batch_root / "corpus", specs_root,
        existing=read_state(queue_path) if queue_path.exists() else None,
        source_catalog_path=catalog_path,
    )
    # Keep supplemental text in the SAME catalog so ledger chapter refs can be
    # validated, but do not create extraction tasks for source-only chapters.
    task_paths = {record["source_relpath"] for record in chapters.values()}
    state["tasks"] = [task for task in state["tasks"] if task["source_relpath"] in task_paths]
    by_path = {task["source_relpath"]: task for task in state["tasks"]}
    by_title = {title: by_path[record["source_relpath"]] for title, record in chapters.items()}
    for title in plan["existing_providers"]:
        task = by_title[title]
        factor = registry.factors.get(task["factor_id"])
        if factor is None or factor.source.artifact_sha256 != chapters[title]["sha256"]:
            raise ValueError(f"Existing provider is missing or source has drifted: {title}")
        if task["status"] == "pending":
            task["status"] = "needs_review"
            task["message"] = "Existing provider, source hash matched; no new completeness claim."
    for title, dependencies in plan["extraction_dependencies"].items():
        task = by_title[title]
        # Preserve registry-resolved dependencies once a package exists. The plan
        # remains a separate input and is never presented as actual Fact edges.
        if task["factor_id"] not in registry.factors:
            task["depends_on_factor_refs"] = sorted(by_title[d]["factor_id"] for d in dependencies)
    ordered = task_topological_order(state)
    write_state(queue_path, state)

    index = {
        "batch_id": plan["id"], "parent_pdf_sha256": catalog["parent_pdf_sha256"],
        "plan_sha256": hashlib.sha256(plan_path.read_bytes()).hexdigest(),
        "catalog_sha256": hashlib.sha256(catalog_path.read_bytes()).hexdigest(),
        "new_chapter_count": len(plan["new_chapters"]),
        "existing_provider_count": len(plan["existing_providers"]),
        "supplemental_source_count": len(supplements),
        "new_packages_present": sum(by_title[t]["factor_id"] in registry.factors for t in plan["new_chapters"]),
        "sources": [chapters[t] for t in sorted(chapters)],
        "supplemental_sources": [supplements[t] for t in sorted(supplements)],
        "new_task_order": [task["factor_id"] for task in ordered if task["factor_id"] in {by_title[t]["factor_id"] for t in plan["new_chapters"]}],
        "open_source_questions": plan["open_source_questions"],
        "database_executed": False,
    }
    (batch_root / "source_index.json").write_text(json.dumps(index, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    for title in plan["new_chapters"]:
        task = by_title[title]
        output = batch_root / "tasks" / (task["factor_id"] + ".md")
        render_task(state, task, ROOT / "prompts/factor_package_v1_extraction.md", output, embed_source=True)
        context = [chapters[d] for d in plan["extraction_dependencies"][title]]
        context += [supplements[x["title"]] for x in plan["supplemental_sections"] if title in x["consumers"]]
        appendix = "\n\n## 本批跨章输入（源正文已落盘，必须按使用范围读取）\n\n"
        appendix += "调度依赖不等于 Fact 已被引用；相关链接不自动成为依赖边。引用前核对导出事实和类型。\n"
        for entry in context:
            appendix += f"\n- {entry['section_number']} {entry['title']}: `{entry['source_path']}`，SHA-256 `{entry['sha256']}`，{entry['line_count']} 行。\n"
        appendix += "\n完整本批正文索引：`" + str((batch_root / "source_index.json").resolve()) + "`。相关链接所指本批其他章节也可按此索引读取。\n"
        for question in plan["open_source_questions"]:
            if question["consumer"] == title:
                appendix += f"\n- 未闭合来源：{question['reference']}。{question['reason']}。\n"
        appendix += "\n只新增本因子包；缺少依赖导出时记录请求，不复制上游规则、不修改核心模型、不执行 SQL。\n"
        output.write_text(output.read_text(encoding="utf-8") + appendix, encoding="utf-8")
    return {key: value for key, value in index.items() if key not in {"sources", "supplemental_sources"}}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--batch-root", type=Path, default=ROOT / "work/doc2spec/batches/batch_03")
    parser.add_argument("--plan", type=Path, default=ROOT / "tests/data/batch_03.json")
    parser.add_argument("--specs-root", type=Path, default=ROOT / "specs")
    args = parser.parse_args()
    result = prepare(args.batch_root.resolve(), args.plan.resolve(), args.specs_root.resolve())
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
