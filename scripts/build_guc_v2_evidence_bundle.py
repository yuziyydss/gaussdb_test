#!/usr/bin/env python3
"""Write the GUC V2 evidence bundle inventory."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_evidence_bundle import build_guc_v2_evidence_bundle


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "generated/guc_environment_v2/evidence_bundle.json",
    )
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    bundle = build_guc_v2_evidence_bundle(args.root)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(bundle.model_dump(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    summary = bundle.summary
    print(
        f"GUC V2 evidence bundle written: {args.output} "
        f"artifacts={summary.artifact_count} present={summary.present_count} "
        f"missing={summary.missing_count} static={summary.static_complete} "
        f"preflight={summary.preflight_complete} runtime={summary.runtime_complete}"
    )
    return 0 if summary.static_complete else 1


if __name__ == "__main__":
    raise SystemExit(main())
