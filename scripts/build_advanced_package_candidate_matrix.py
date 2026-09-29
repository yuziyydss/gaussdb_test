#!/usr/bin/env python3
"""Build the Advanced Package candidate matrix."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.advanced_package_candidate import build_advanced_package_candidate_matrix


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "generated/advanced_package_pilot/candidate_matrix.json",
    )
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    matrix = build_advanced_package_candidate_matrix(args.root)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(matrix.model_dump(mode="json"), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    summary = matrix.summary
    print(
        f"Advanced Package candidate matrix written: {args.output} "
        f"packages={summary.supported_package_count} "
        f"modeled={summary.modeled_package_count} "
        f"near_term={summary.near_term_candidate_count} "
        f"facts={summary.fact_count}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
