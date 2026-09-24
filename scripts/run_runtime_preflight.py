#!/usr/bin/env python3
"""Run a read-only GaussDB connection and GUC preflight."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.runtime_preflight import run_preflight
from core.runtime_validation_pilot import DatabaseRuntimeTransport


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--host", default=None)
    parser.add_argument("--port", type=int, default=None)
    parser.add_argument("--database", default=None)
    parser.add_argument("--user", default=None)
    parser.add_argument("--password-env", default="GAUSSDB_PASSWORD")
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    import os

    host = args.host or os.getenv("GAUSSDB_HOST", "localhost")
    port = args.port or int(os.getenv("GAUSSDB_PORT", "5432"))
    database = args.database or os.getenv("GAUSSDB_DATABASE", "postgres")
    user = args.user or os.getenv("GAUSSDB_USER", "gaussdb")
    password = os.getenv(args.password_env, "")

    transport = DatabaseRuntimeTransport(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password,
    )
    try:
        result = run_preflight(transport)
    finally:
        transport.close()

    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.output.exists():
        raise SystemExit(f"output already exists: {args.output}")
    args.output.write_text(
        json.dumps(result.model_dump(), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return 0 if result.connected and result.metadata_read else 1


if __name__ == "__main__":
    raise SystemExit(main())
