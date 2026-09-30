#!/usr/bin/env python3
"""Build the Advanced Package runtime preflight plan artifact."""
from __future__ import annotations
import argparse, json, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.advanced_package_runtime_preflight import build_advanced_package_runtime_preflight


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--output", type=Path, default=ROOT / "generated/advanced_package_pilot/runtime_preflight_plan.json")
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    plan = build_advanced_package_runtime_preflight(args.root)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(plan.model_dump(mode="json"), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    summary = plan.summary
    print(
        f"Advanced Package runtime preflight plan written: {args.output} "
        f"cases={summary.advanced_case_count} interfaces={summary.advanced_interface_reference_count} "
        f"queries={summary.global_query_count} coverage={summary.coverage_complete}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
