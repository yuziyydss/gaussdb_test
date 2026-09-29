#!/usr/bin/env python3
"""Build the read-only GUC V2 preflight plan."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_preflight import GucV2PreflightError, GucV2PreflightRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = GucV2PreflightRegistry(args.root)
    try:
        output = registry.write()
        plan = registry.load()
    except (OSError, GucV2PreflightError) as exc:
        raise SystemExit(str(exc)) from exc
    print(
        f"GUC V2 preflight plan written: {output} "
        f"queries={plan.summary.query_count} read_only={plan.summary.read_only}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
