#!/usr/bin/env python3
"""Build or verify the core-expression expected-oracle draft artifact."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_oracle_draft import build_core_expression_oracle_draft_payload

OUTPUT_PATH = ROOT / 'generated/core_expression_oracle_draft_v1/oracle_draft.json'


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--output', type=Path, default=OUTPUT_PATH)
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    payload = build_core_expression_oracle_draft_payload(args.root)
    rendered = json.dumps(payload, ensure_ascii=False, indent=2) + '\n'
    if args.check and args.output.exists():
        if args.output.read_text(encoding='utf-8') != rendered:
            print('Core expression oracle draft check failed: artifact drift')
            return 1
    if not args.check or not args.output.exists():
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding='utf-8')
    summary = payload['summary']
    print(
        f"Core expression oracle draft written: {args.output} "
        f"steps={summary['oracle_draft_count']} batches={summary['batch_count']} "
        f"facts={summary['unique_fact_count']} exact_values={summary['exact_value_assertion_count']} "
        f"draft_sha256={payload['draft_sha256']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
