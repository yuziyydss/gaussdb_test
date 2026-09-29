#!/usr/bin/env python3
"""Run the read-only Advanced Package preflight against a configured GaussDB."""
from __future__ import annotations
import argparse, json, os, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.executor import ExecConfig
from core.advanced_package_runtime_preflight import (
    build_advanced_package_runtime_preflight,
    run_advanced_package_runtime_preflight,
    audit_advanced_package_runtime_preflight_result,
)
from core.runtime_validation_pilot import DatabaseRuntimeTransport


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--audit-output", type=Path, default=None)
    parser.add_argument("--host", default=None)
    parser.add_argument("--port", type=int, default=None)
    parser.add_argument("--database", default=None)
    parser.add_argument("--user", default=None)
    parser.add_argument("--password-env", default="GAUSSDB_PASSWORD")
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    audit_output = args.audit_output or args.output.with_name("runtime_preflight_audit.json")
    if args.output.exists():
        raise SystemExit(f"output already exists: {args.output}")
    if audit_output.exists():
        raise SystemExit(f"audit output already exists: {audit_output}")

    config = ExecConfig(enabled=True)
    if not config.enabled:
        raise SystemExit("GAUSSDB_ENABLED must be true for read-only preflight execution")

    plan = build_advanced_package_runtime_preflight(ROOT)
    transport = DatabaseRuntimeTransport(
        host=args.host or os.getenv("GAUSSDB_HOST", "localhost"),
        port=args.port or int(os.getenv("GAUSSDB_PORT", "5432")),
        database=args.database or os.getenv("GAUSSDB_DATABASE", "postgres"),
        user=args.user or os.getenv("GAUSSDB_USER", "gaussdb"),
        password=os.getenv(args.password_env, ""),
    )
    try:
        result = run_advanced_package_runtime_preflight(plan, transport)
    finally:
        transport.close()

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result.model_dump(), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    audit = audit_advanced_package_runtime_preflight_result(result, plan=plan)
    audit_output.parent.mkdir(parents=True, exist_ok=True)
    audit_output.write_text(json.dumps(audit.model_dump(), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(
        f"Advanced Package runtime preflight written: {args.output} "
        f"queries={result.summary.query_count} success={result.summary.success_count} "
        f"errors={result.summary.error_count} findings={result.summary.finding_count}"
    )
    print(
        f"Advanced Package runtime preflight audit written: {audit_output} "
        f"valid={audit.valid} plan_verified={audit.plan_verified}"
    )
    return 0 if result.connected and result.metadata_read and audit.valid and audit.plan_verified else 1


if __name__ == "__main__":
    raise SystemExit(main())
