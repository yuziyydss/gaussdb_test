#!/usr/bin/env python3
"""Build or execute the GUC + advanced-package runtime validation pilot."""
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.executor import ExecConfig
from core.runtime_validation_pilot import (
    DatabaseRuntimeTransport,
    build_dry_run,
    execute_plan,
    plan_sha256,
)


def parse_args(argv=None) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--execute", action="store_true", help="execute against GaussDB (requires authorization)")
    parser.add_argument("--authorized", action="store_true", help="explicit runtime authorization flag")
    return parser.parse_args(argv)


def write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        raise SystemExit(f"output already exists: {path}")
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def main(argv=None) -> int:
    args = parse_args() if argv is None else parse_args(argv)
    plan = build_dry_run(ROOT)
    fingerprint = plan_sha256(plan)

    if not args.execute:
        payload = plan.model_dump(mode="json")
        payload["plan_sha256"] = fingerprint
        write_json(args.output, payload)
        return 0

    if not args.authoritized:
        raise SystemExit("runtime execution requires --authorized")
    if os.getenv("GAUSSDB_RUNTIME_PILOT_AUTHORIZED", "").lower() not in {"true", "1", "yes"}:
        raise SystemExit("GAUSSDB_RUNTIME_PILOT_AUTHORIZED must be true for runtime execution")

    config = ExecConfig(enabled=True)
    if not config.enabled:
        raise SystemExit("GAUSSDB_ENABLED must be true for runtime execution")

    transport = DatabaseRuntimeTransport(
        host=config.host,
        port=config.port,
        database=config.database,
        user=config.user,
        password=config.password,
    )
    try:
        receipt = execute_plan(plan, transport, authorized=True)
    finally:
        transport.close()
    receipt["plan_sha256"] = fingerprint
    write_json(args.output, receipt)
    return 0 if receipt["status"] == "runtime_verified" else 1


if __name__ == "__main__":
    raise SystemExit(main())
