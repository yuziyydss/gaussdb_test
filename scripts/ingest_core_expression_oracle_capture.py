#!/usr/bin/env python3
"""Ingest an audited batch runtime receipt into oracle capture slots."""
from __future__ import annotations
import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_batch_execution import SUPPORTED_BATCH_IDS
from core.core_expression_oracle_capture_ingestion import ingest_core_expression_batch_receipt


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--batch-id', choices=sorted(SUPPORTED_BATCH_IDS), required=True)
    parser.add_argument('--receipt', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    try:
        receipt_payload = json.loads(args.receipt.read_text(encoding='utf-8'))
    except (OSError, json.JSONDecodeError) as exc:
        raise SystemExit(f'cannot load receipt {args.receipt}: {exc}')
    ingestion = ingest_core_expression_batch_receipt(args.root, args.batch_id, receipt_payload)
    payload = ingestion.model_dump(mode='json')
    payload['ingestion_sha256'] = hashlib.sha256(
        json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(',', ':')).encode('utf-8')
    ).hexdigest()
    rendered = json.dumps(payload, ensure_ascii=False, indent=2) + '\n'
    if args.check and args.output.exists():
        if args.output.read_text(encoding='utf-8') != rendered:
            print('Core expression capture ingestion check failed: artifact drift')
            return 1
    if not args.check or not args.output.exists():
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding='utf-8')
    summary = payload['summary']
    print(
        f"Core expression capture ingestion written: {args.output} "
        f"steps={summary['receipt_step_count']} captured={summary['captured_count']} "
        f"failed={summary['capture_failed_count']} pending={summary['pending_capture_count']}"
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
