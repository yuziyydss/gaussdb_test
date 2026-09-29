#!/usr/bin/env python3
"""Verify the GUC V2 evidence bundle against current artifact files."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_evidence_bundle import verify_guc_v2_evidence_bundle


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
    result = verify_guc_v2_evidence_bundle(args.root)
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(
            json.dumps(result.model_dump(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
    if result.valid:
        print(
            "GUC V2 evidence bundle verification passed: "
            f"artifacts={result.current_summary.artifact_count} "
            f"present={result.current_summary.present_count} "
            f"missing={result.current_summary.missing_count}"
        )
    else:
        print("GUC V2 evidence bundle verification failed:")
        for error in result.errors:
            print(f"- {error}")
    return 0 if result.valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
