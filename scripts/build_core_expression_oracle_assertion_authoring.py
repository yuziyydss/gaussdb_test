#!/usr/bin/env python3
"""Build or verify the executable-oracle assertion authoring artifact."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_oracle_assertion_authoring import build_core_expression_oracle_assertion_authoring_payloads

JSON_OUTPUT = ROOT / 'generated/core_expression_oracle_assertion_authoring_v1/assertion_authoring.json'
MD_OUTPUT = ROOT / 'generated/core_expression_oracle_assertion_authoring_v1/assertion_authoring.md'


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--json-output', type=Path, default=JSON_OUTPUT)
    parser.add_argument('--markdown-output', type=Path, default=MD_OUTPUT)
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    payload, markdown = build_core_expression_oracle_assertion_authoring_payloads(args.root)
    json_rendered = json.dumps(payload, ensure_ascii=False, indent=2) + '\n'
    if args.check:
        drift = (
            not args.json_output.exists()
            or args.json_output.read_text(encoding='utf-8') != json_rendered
            or not args.markdown_output.exists()
            or args.markdown_output.read_text(encoding='utf-8') != markdown
        )
        if drift:
            print('Core expression assertion authoring check failed: artifact drift')
            return 1
    if not args.check or not args.json_output.exists():
        args.json_output.parent.mkdir(parents=True, exist_ok=True)
        args.json_output.write_text(json_rendered, encoding='utf-8')
    if not args.check or not args.markdown_output.exists():
        args.markdown_output.parent.mkdir(parents=True, exist_ok=True)
        args.markdown_output.write_text(markdown, encoding='utf-8')
    summary = payload['summary']
    print(
        f"Core expression assertion authoring written: {args.json_output} "
        f"promoted={summary['promotion_item_count']} authoring={summary['authoring_item_count']} "
        f"assertions={summary['assertion_draft_count']} "
        f"authoring_sha256={payload['authoring_sha256']}"
    )
    print(f"Core expression assertion authoring markdown written: {args.markdown_output}")
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
