#!/usr/bin/env python3
"""Build the GUC V2 capability adapter matrix."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_capability import GucCapabilityLoadError, GucCapabilityRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "generated/guc_environment_v2/capability_matrix.json",
    )
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = GucCapabilityRegistry(args.root)
    try:
        output = registry.write(args.output)
        matrix = registry.load(output)
    except (OSError, GucCapabilityLoadError) as exc:
        raise SystemExit(str(exc)) from exc
    summary = matrix.summary
    print(
        f"GUC capability matrix written: {output} "
        f"capabilities={summary.capability_count} "
        f"fact_bound={summary.runtime_fact_bound_count} "
        f"needs_fact={summary.needs_runtime_fact_count} "
        f"steps={summary.plan_step_count}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
