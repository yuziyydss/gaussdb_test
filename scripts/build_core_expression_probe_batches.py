#!/usr/bin/env python3
"""Build or verify the Core Expression probe batch dry-run plans."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_probe_batches import build_core_expression_probe_batches_payload


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--output', type=Path, default=ROOT / 'generated/core_expression_probe_batches_v1/batches.json')
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    payload = build_core_expression_probe_batches_payload(args.root)
    rendered = json.dumps(payload, ensure_ascii=False, indent=2) + '\n'
    if args.check and args.output.exists():
        if args.output.read_text(encoding='utf-8') != rendered:
            print('Core expression probe batch check failed: artifact drift')
            return 1
    if not args.check or not args.output.exists():
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding='utf-8')
    summary = payload['summary']
    print(
        f"Core expression probe batches written: {args.output} "
        f"batches={summary['batch_count']} steps={summary['batched_step_count']} "
        f"counts={summary['batch_step_counts']} plan_sha256={payload['plan_sha256']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
