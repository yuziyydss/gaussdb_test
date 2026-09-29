#!/usr/bin/env python3
"""Audit an Advanced Package runtime preflight result against its plan."""
from __future__ import annotations
import argparse, json, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.advanced_package_runtime_preflight import (
    AdvancedRuntimePreflightPlanDef,
    audit_advanced_package_runtime_preflight_result,
)


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--result", type=Path, required=True)
    parser.add_argument("--plan", type=Path, default=ROOT / "generated/advanced_package_pilot/runtime_preflight_plan.json")
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args(argv)


def load_json(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise SystemExit(f"cannot load {path}: {exc}")


def main(argv=None) -> int:
    args = parse_args(argv)
    result = load_json(args.result)
    try:
        plan = AdvancedRuntimePreflightPlanDef(**load_json(args.plan))
    except Exception as exc:
        raise SystemExit(f"invalid Advanced Package preflight plan {args.plan}: {exc}")
    audit = audit_advanced_package_runtime_preflight_result(result, plan=plan)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.output.exists():
        raise SystemExit(f"output already exists: {args.output}")
    args.output.write_text(json.dumps(audit.model_dump(), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return 0 if audit.valid and audit.plan_verified else 1


if __name__ == "__main__":
    raise SystemExit(main())
