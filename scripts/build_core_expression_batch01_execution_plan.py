#!/usr/bin/env python3
"""Build or verify the Batch 01 authorized-execution plan."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_batch01_execution import build_core_expression_batch01_execution_plan_payload

OUTPUT_PATH = ROOT / 'generated/core_expression_probe_batches_v1/batch_01_execution_plan.json'


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--output', type=Path, default=OUTPUT_PATH)
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    payload = build_core_expression_batch01_execution_plan_payload(args.root)
    rendered = json.dumps(payload, ensure_ascii=False, indent=2) + '\n'
    if args.check and args.output.exists():
        if args.output.read_text(encoding='utf-8') != rendered:
            print('Batch 01 execution plan check failed: artifact drift')
            return 1
    if not args.check or not args.output.exists():
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding='utf-8')
    print(
        f"Batch 01 execution plan written: {args.output} "
        f"steps={len(payload['steps'])} plan_sha256={payload['plan_sha256']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
