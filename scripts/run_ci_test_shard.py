#!/usr/bin/env python3
"""Run one deterministic pytest shard in CI.

Sharding is based on the complete collected test ID, not the module path, so a
single heavy module is distributed instead of landing entirely in one shard.
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def collect_test_ids() -> list[str]:
    result = subprocess.run(
        [sys.executable, "-m", "pytest", "--collect-only", "-q", "tests"],
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(result.stdout, end="")
        print(result.stderr, end="", file=sys.stderr)
        raise RuntimeError(f"pytest collection failed with exit code {result.returncode}")
    return sorted(
        line.strip()
        for line in result.stdout.splitlines()
        if line.strip().startswith("tests/")
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--shard", type=int, required=True)
    parser.add_argument("--shards", type=int, required=True)
    parser.add_argument("--workers", type=int, default=4)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    if not 0 <= args.shard < args.shards:
        parser.error("--shard must be in [0, --shards)")
    if args.workers < 1:
        parser.error("--workers must be positive")
    return args


def main() -> int:
    args = parse_args()
    test_ids = collect_test_ids()
    selected = [
        test_id for index, test_id in enumerate(test_ids)
        if index % args.shards == args.shard
    ]
    if args.dry_run:
        print(f"total={len(test_ids)} selected={len(selected)}")
        for test_id in selected:
            print(test_id)
        return 0
    if not selected:
        raise RuntimeError(f"CI shard {args.shard} selected no tests")
    result = subprocess.run(
        [
            sys.executable, "-m", "pytest", "-q", "--tb=short",
            f"-n={args.workers}", *selected
        ],
        cwd=ROOT,
        check=False,
    )
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
