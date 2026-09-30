#!/usr/bin/env python3
"""Build or verify a core-expression batch authorized-execution plan."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_batch_execution import (
    SUPPORTED_BATCH_IDS,
    build_core_expression_batch_execution_plan_payload,
    plan_output_path,
)


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--batch-id', choices=sorted(SUPPORTED_BATCH_IDS), required=True)
    parser.add_argument('--output', type=Path, default=None)
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    output = args.output or plan_output_path(args.root, args.batch_id)
    payload = build_core_expression_batch_execution_plan_payload(args.root, args.batch_id)
    rendered = json.dumps(payload, ensure_ascii=False, indent=2) + '\n'
    if args.check and output.exists():
        if output.read_text(encoding='utf-8') != rendered:
            print(f'{args.batch_id} execution plan check failed: artifact drift')
            return 1
    if not args.check or not output.exists():
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(rendered, encoding='utf-8')
    print(
        f'{args.batch_id} execution plan written: {output} '
        f"steps={len(payload['steps'])} plan_sha256={payload['plan_sha256']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
