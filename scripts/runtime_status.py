#!/usr/bin/env python3
"""Print or write the aggregated runtime validation status."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.runtime_status import build_runtime_status


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=None)
    parser.add_argument("--root", type=Path, default=ROOT)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    status = build_runtime_status(args.root)
    payload = status.model_dump()
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        if args.output.exists():
            raise SystemExit(f"output already exists: {args.output}")
        args.output.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    else:
        print(json.dumps(payload, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
