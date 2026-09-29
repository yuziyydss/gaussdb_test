#!/usr/bin/env python3
"""Audit a core-expression batch runtime receipt against its execution plan."""
from __future__ import annotations
import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.core_expression_batch_execution import (
    CoreExpressionBatchExecutionPlanDef,
    SUPPORTED_BATCH_IDS,
    audit_core_expression_batch_receipt,
    plan_output_path,
)


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--batch-id', choices=sorted(SUPPORTED_BATCH_IDS), required=True)
    parser.add_argument('--receipt', type=Path, required=True)
    parser.add_argument('--plan', type=Path, default=None)
    parser.add_argument('--output', type=Path, required=True)
    return parser.parse_args(argv)


def load_json(path: Path):
    try:
        return json.loads(path.read_text(encoding='utf-8'))
    except (OSError, json.JSONDecodeError) as exc:
        raise SystemExit(f'cannot load {path}: {exc}')


def main(argv=None) -> int:
    args = parse_args(argv)
    plan_path = args.plan or plan_output_path(ROOT, args.batch_id)
    plan_payload = load_json(plan_path)
    try:
        plan = CoreExpressionBatchExecutionPlanDef(**{
            key: value for key, value in plan_payload.items() if key != 'plan_sha256'
        })
    except Exception as exc:
        raise SystemExit(f'invalid core expression execution plan {plan_path}: {exc}')
    audit = audit_core_expression_batch_receipt(
        load_json(args.receipt),
        plan=plan,
        expected_plan_sha256=plan_payload.get('plan_sha256'),
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.output.exists():
        raise SystemExit(f'output already exists: {args.output}')
    args.output.write_text(json.dumps(audit.model_dump(), ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(
        f'{args.batch_id} receipt audit written: {args.output} valid={audit.valid} '
        f'plan_verified={audit.plan_verified} summary={audit.summary}'
    )
    return 0 if audit.valid and audit.plan_verified else 1


if __name__ == '__main__':
    raise SystemExit(main())
