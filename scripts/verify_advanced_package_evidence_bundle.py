#!/usr/bin/env python3
"""Verify the Advanced Package Pilot evidence bundle against current files."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.advanced_package_evidence import verify_advanced_package_evidence_bundle


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="optional JSON verification report",
    )
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    result = verify_advanced_package_evidence_bundle(args.root)
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(
            json.dumps(result.model_dump(mode="json"), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
    if result.valid:
        print(
            "Advanced Package evidence bundle verification passed: "
            f"packages={result.current_summary.package_count} "
            f"interfaces={result.current_summary.interface_count} "
            f"runtime_candidates={result.current_summary.test_case_count}"
        )
    else:
        print("Advanced Package evidence bundle verification failed:")
        for error in result.errors:
            print(f"- {error}")
    return 0 if result.valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
