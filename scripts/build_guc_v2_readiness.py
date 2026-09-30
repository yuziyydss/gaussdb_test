#!/usr/bin/env python3
"""Write the GUC V2 readiness report."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_readiness import GucV2ReadinessRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = GucV2ReadinessRegistry(args.root)
    output = registry.write()
    readiness = registry.build()
    print(
        f"GUC V2 readiness written: {output} "
        f"static={readiness.static_audit_valid} "
        f"preflight_result={readiness.preflight_result_present} "
        f"ready_for_authorized_execution={readiness.ready_for_authorized_execution}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
