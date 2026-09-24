#!/usr/bin/env python3
"""Audit a Phase 1 auto-validation report."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.phase1_report_audit import audit_phase1_report


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    try:
        report = json.loads(args.report.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise SystemExit(f"cannot load Phase 1 report {args.report}: {exc}")

    audit = audit_phase1_report(report)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.output.exists():
        raise SystemExit(f"output already exists: {args.output}")
    args.output.write_text(
        json.dumps(audit.model_dump(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return 0 if audit.valid else 1


if __name__ == "__main__":
    raise SystemExit(main())
