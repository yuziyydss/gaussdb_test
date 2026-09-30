#!/usr/bin/env python3
"""Build the Advanced Package expansion coverage & policy audit artifact."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.advanced_package_policy_audit import build_advanced_package_policy_audit


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "generated/advanced_package_pilot/policy_audit.json",
    )
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    audit = build_advanced_package_policy_audit(args.root)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(audit.model_dump(mode="json"), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    summary = audit.summary
    print(
        f"Advanced Package policy audit written: {args.output} "
        f"packages={summary.audited_package_count} "
        f"documented_callables={summary.documented_callable_count} "
        f"modeled_callables={summary.modeled_callable_count} "
        f"missing={summary.missing_callable_count} "
        f"runtime_candidates={summary.recommended_runtime_candidate_count} "
        f"blocked={summary.recommended_blocked_count}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
