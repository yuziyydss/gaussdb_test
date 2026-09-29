#!/usr/bin/env python3
"""Build or verify the Core Expression static SQL probe dry-run plan."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_probe_plan import build_core_expression_probe_plan_payload


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--output', type=Path, default=ROOT / 'generated/core_expression_probe_plan_v1/dry_run.json')
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    payload = build_core_expression_probe_plan_payload(args.root)
    rendered = json.dumps(payload, ensure_ascii=False, indent=2) + '\n'
    if args.check and args.output.exists():
        if args.output.read_text(encoding='utf-8') != rendered:
            print('Core expression probe plan check failed: artifact drift')
            return 1
    if not args.check or not args.output.exists():
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding='utf-8')
    summary = payload['summary']
    print(
        f"Core expression probe plan written: {args.output} "
        f"candidates={summary['candidate_count']} selected={summary['selected_count']} "
        f"excluded={summary['excluded_count']} steps={summary['step_count']} "
        f"read_only={summary['read_only_step_count']} "
        f"plan_sha256={payload['plan_sha256']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
