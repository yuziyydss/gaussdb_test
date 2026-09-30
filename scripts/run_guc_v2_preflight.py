#!/usr/bin/env python3
"""Run the read-only GUC V2 preflight against a configured GaussDB."""
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.guc_preflight import GucV2PreflightRegistry, run_guc_v2_preflight
from core.guc_preflight_audit import audit_guc_v2_preflight_result
from core.runtime_validation_pilot import DatabaseRuntimeTransport


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument(
        "--audit-output",
        type=Path,
        default=None,
        help="audit output path; defaults to preflight_audit.json beside --output",
    )
    parser.add_argument("--host", default=None)
    parser.add_argument("--port", type=int, default=None)
    parser.add_argument("--database", default=None)
    parser.add_argument("--user", default=None)
    parser.add_argument("--password-env", default="GAUSSDB_PASSWORD")
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    audit_output = args.audit_output or args.output.with_name("preflight_audit.json")
    if args.output.exists():
        raise SystemExit(f"output already exists: {args.output}")
    if audit_output.exists():
        raise SystemExit(f"audit output already exists: {audit_output}")

    host = args.host or os.getenv("GAUSSDB_HOST", "localhost")
    port = args.port or int(os.getenv("GAUSSDB_PORT", "5432"))
    database = args.database or os.getenv("GAUSSDB_DATABASE", "postgres")
    user = args.user or os.getenv("GAUSSDB_USER", "gaussdb")
    password = os.getenv(args.password_env, "")

    registry = GucV2PreflightRegistry(ROOT)
    plan = registry.load()
    transport = DatabaseRuntimeTransport(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password,
    )
    try:
        result = run_guc_v2_preflight(plan, transport)
    finally:
        transport.close()

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(result.model_dump(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    audit = audit_guc_v2_preflight_result(result, plan=plan)
    audit_output.parent.mkdir(parents=True, exist_ok=True)
    audit_output.write_text(
        json.dumps(audit.model_dump(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(
        f"GUC V2 preflight written: {args.output} "
        f"queries={result.summary.query_count} "
        f"success={result.summary.success_count} "
        f"domain_mismatches={result.summary.domain_mismatch_count}"
    )
    print(
        f"GUC V2 preflight audit written: {audit_output} "
        f"valid={audit.valid} plan_verified={audit.plan_verified}"
    )
    return 0 if (
        result.connected
        and result.metadata_read
        and audit.valid
        and audit.plan_verified
    ) else 1


if __name__ == "__main__":
    raise SystemExit(main())
