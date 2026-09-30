#!/usr/bin/env python3
"""Build and verify the Core Expression fact -> fixture -> SQL candidate chain."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_candidate_chain import build_core_expression_candidate_chain


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', type=Path, default=ROOT)
    parser.add_argument('--output', type=Path, default=ROOT / 'generated/core_expression_candidate_chain_v1/candidates.json')
    parser.add_argument('--check', action='store_true')
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    current = build_core_expression_candidate_chain(args.root)
    rendered = json.dumps(current.model_dump(mode='json'), ensure_ascii=False, indent=2) + '\n'
    if args.check and args.output.exists():
        if args.output.read_text(encoding='utf-8') != rendered:
            print('Core expression candidate chain check failed: artifact drift')
            return 1
    if not args.check or not args.output.exists():
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding='utf-8')
    summary = current.summary
    print(
        f'Core expression candidate chain written: {args.output} '
        f'facts={summary.source_fact_count} candidates={summary.candidate_count} '
        f'fixtures={summary.fixture_count} fact_refs={summary.candidate_fact_reference_count} '
        f'uncovered={summary.uncovered_fact_count} static={summary.static_chain_complete}'
    )
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
