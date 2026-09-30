#!/usr/bin/env python3
"""Build the GUC candidate review matrix from GUC Reference Schema V2."""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_candidate import GucCandidateLoadError, GucCandidateRegistry


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=ROOT / "generated/guc_candidate_matrix/matrix.json")
    parser.add_argument("--root", type=Path, default=ROOT)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    registry = GucCandidateRegistry(args.root)
    try:
        output = registry.write(args.output)
        matrix = registry.load()
    except (OSError, GucCandidateLoadError) as exc:
        raise SystemExit(str(exc)) from exc
    summary = matrix.summary
    print(
        f"GUC candidate matrix written: {output} "
        f"parameters={summary.parameter_count} boolean_candidates={summary.boolean_session_candidate_count} "
        f"next_batch={summary.next_batch_count}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
