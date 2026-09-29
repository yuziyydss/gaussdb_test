#!/usr/bin/env python3
"""Build deterministic JSON and SQL exports for GUC V2 session overlays."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_plan_export import GucOverlayPlanExportError, GucOverlayPlanExportRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = GucOverlayPlanExportRegistry(args.root)
    try:
        output = registry.write()
        export = registry.load()
    except (OSError, GucOverlayPlanExportError) as exc:
        raise SystemExit(str(exc)) from exc
    summary = export.summary
    print(
        f"GUC overlay plans written: {output} "
        f"plans={summary.exported_plan_count} steps={summary.step_count} "
        f"excluded={summary.excluded_parameter_count}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
