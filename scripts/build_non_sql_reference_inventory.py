#!/usr/bin/env python3
"""Write a typed inventory of all non-SQL compatibility reference facts."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.non_sql_reference import NonSqlReferenceLoadError, NonSqlReferenceRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=ROOT / "generated/non_sql_reference_inventory/inventory.json")
    parser.add_argument("--root", type=Path, default=ROOT)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = NonSqlReferenceRegistry(args.root)
    try:
        inventory = registry.load_all()
    except (OSError, NonSqlReferenceLoadError) as exc:
        raise SystemExit(str(exc)) from exc
    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.output.exists():
        raise SystemExit(f"output already exists: {args.output}")
    args.output.write_text(
        json.dumps(inventory.model_dump(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    summary = inventory.summary
    print(
        f"non-SQL reference inventory written: {args.output} "
        f"files={summary.source_file_count} facts={summary.fact_count} "
        f"unresolved={len(summary.unresolved_fact_ids)}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
