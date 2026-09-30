#!/usr/bin/env python3
"""Build or verify the core-expression oracle capture registry."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_oracle_capture import build_core_expression_oracle_capture

OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_capture_v1/captures.json'


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--output', type=Path, default=OUTPUT_PATH)
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    payload = build_core_expression_oracle_capture(args.root).model_dump(mode='json')
    rendered = json.dumps(payload, ensure_ascii=False, indent=2) + '\n'
    if args.check and args.output.exists():
        if args.output.read_text(encoding='utf-8') != rendered:
            print('Core expression oracle capture check failed: artifact drift')
            return 1
    if not args.check or not args.output.exists():
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding='utf-8')
    summary = payload['summary']
    print(
        f"Core expression oracle captures written: {args.output} "
        f"slots={summary['capture_slot_count']} pending={summary['pending_capture_count']} "
        f"captured={summary['captured_count']} failed={summary['capture_failed_count']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
