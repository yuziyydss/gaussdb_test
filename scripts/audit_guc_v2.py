#!/usr/bin/env python3
"""Write the cross-layer GUC V2 static audit artifact."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_audit import build_guc_v2_audit


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "generated/guc_environment_v2/audit.json",
    )
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    audit = build_guc_v2_audit(args.root)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(audit.model_dump(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(
        f"GUC V2 audit written: {args.output} "
        f"valid={audit.valid} checks={len(audit.checks)} "
        f"plans={audit.summary['exported_plan_count']}"
    )
    return 0 if audit.valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
