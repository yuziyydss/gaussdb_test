#!/usr/bin/env python3
"""Build the GUC Reference Schema V2 catalog from the authoritative book catalog."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_reference import GucReferenceError, GucReferenceRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=ROOT / "generated/guc_reference_catalog/catalog.json")
    parser.add_argument("--root", type=Path, default=ROOT)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = GucReferenceRegistry(args.root)
    try:
        output = registry.write(args.output)
    except (OSError, GucReferenceError) as exc:
        raise SystemExit(str(exc)) from exc
    catalog = registry.load()
    summary = catalog.summary
    print(
        f"GUC reference catalog written: {output} "
        f"definitions={summary.definition_count} parameters={summary.parameter_count} "
        f"pilot={summary.pilot_context_match_count}/{summary.pilot_parameter_count}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
