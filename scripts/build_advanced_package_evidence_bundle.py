#!/usr/bin/env python3
"""Write the Advanced Package Pilot evidence bundle."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.advanced_package_evidence import AdvancedEvidenceBundleRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "generated/advanced_package_pilot/evidence_bundle.json",
    )
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = AdvancedEvidenceBundleRegistry(args.root)
    output = registry.write(args.output)
    bundle = registry.build()
    summary = bundle.summary
    print(
        f"Advanced Package evidence bundle written: {output} "
        f"packages={summary.package_count}/{summary.supported_package_count} "
        f"interfaces={summary.interface_count} runtime_candidates={summary.test_case_count} "
        f"static={summary.static_complete} runtime={summary.runtime_complete}"
    )
    return 0 if summary.static_complete else 1


if __name__ == "__main__":
    raise SystemExit(main())
