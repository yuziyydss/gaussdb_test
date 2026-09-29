#!/usr/bin/env python3
"""Build the GUC V2 to Factor Package requirement adapter."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_requirement_adapter import (
    GucRequirementAdapterError,
    GucRequirementAdapterRegistry,
)


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "generated/guc_environment_v2/requirement_adapter.json",
    )
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = GucRequirementAdapterRegistry(args.root)
    try:
        output = registry.write(args.output)
        adapter = registry.load(output)
    except (OSError, GucRequirementAdapterError) as exc:
        raise SystemExit(str(exc)) from exc
    summary = adapter.summary
    print(
        f"GUC requirement adapter written: {output} "
        f"requirements={summary.requirement_count} "
        f"blocked={summary.blocked_count} "
        f"missing_fact={summary.missing_fact_blocked_count} "
        f"empty_value={summary.empty_value_blocked_count}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
