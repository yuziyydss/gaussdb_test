#!/usr/bin/env python3
"""Verify that the Advanced Package policy audit is current and internally valid."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.advanced_package_policy_audit import verify_advanced_package_policy_audit


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--output", type=Path)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    try:
        result = verify_advanced_package_policy_audit(args.root)
        valid, errors = True, []
    except Exception as exc:
        result = None
        valid, errors = False, [str(exc)]

    payload = {
        "kind": "advanced_package_policy_audit_verification",
        "schema_version": 1,
        "valid": valid,
        "errors": errors,
    }
    if result is not None:
        payload["recorded_summary"] = result.summary.model_dump(mode="json")
    text = json.dumps(payload, ensure_ascii=False, indent=2) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    print(text, end="")
    return 0 if valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
