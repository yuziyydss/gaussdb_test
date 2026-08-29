#!/usr/bin/env python3
"""静态验证所有（或指定）manifest 的生成正确性，不连接数据库。"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Dict, List


ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from core.spec_generator import GenerationValidationError, SpecSQLGenerator
from core.spec_model import SpecLoadError, SpecRegistry


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="验证规格加载、case ID 唯一性与 Pairwise 覆盖；不执行 SQL。"
    )
    parser.add_argument(
        "--manifest", action="append", dest="manifest_ids",
        help="只验证指定 manifest；可重复传入。默认验证全部。",
    )
    parser.add_argument(
        "--json", type=Path, dest="json_path",
        help="可选：把结构化验证报告写到该路径。",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    registry = SpecRegistry(str(ROOT_DIR))
    try:
        registry.load_all()
    except SpecLoadError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    requested = args.manifest_ids or sorted(registry.manifests)
    missing = sorted(set(requested) - set(registry.manifests))
    if missing:
        print(f"未知 manifest: {', '.join(missing)}", file=sys.stderr)
        return 2

    generator = SpecSQLGenerator(registry)
    global_case_ids = set()
    results: List[Dict[str, Any]] = []
    failed = False

    for manifest_id in requested:
        manifest = registry.get_manifest(manifest_id)
        try:
            cases, report = generator.generate_with_report(manifest)
            duplicate_global_ids = sorted(
                case.case_id for case in cases if case.case_id in global_case_ids
            )
            global_case_ids.update(case.case_id for case in cases)
            item = report.to_dict()
            item["global_duplicate_case_ids"] = duplicate_global_ids
            item["ok"] = report.pairwise_complete and not duplicate_global_ids
            results.append(item)
            failed = failed or not item["ok"]
            print(
                f"{manifest_id}: cases={item['generated_case_count']} "
                f"pairs={item['covered_pair_count']}/{item['feasible_pair_count']} "
                f"missing={len(item['missing_pairs'])} "
                f"duplicate_ids={len(duplicate_global_ids)}"
            )
            if item["filtered_pair_reasons"]:
                print(f"  filtered_pairs={item['filtered_pair_reasons']}")
        except GenerationValidationError as exc:
            failed = True
            results.append({"manifest_id": manifest_id, "ok": False, "error": str(exc)})
            print(f"{manifest_id}: ERROR {exc}", file=sys.stderr)

    summary = {
        "manifest_count": len(results),
        "global_case_id_count": len(global_case_ids),
        "ok": not failed,
        "manifests": results,
    }
    if args.json_path:
        args.json_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
