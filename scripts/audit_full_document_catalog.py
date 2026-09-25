#!/usr/bin/env python3
"""Audit authoritative full-document catalog coverage."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.full_document_catalog import FullDocumentCatalogError, audit_full_document_catalog


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--catalog", type=Path, default=ROOT / "generated/full_document_catalog/catalog.json")
    parser.add_argument("--output", type=Path, default=ROOT / "generated/full_document_catalog/coverage.json")
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--verify-sources", action="store_true")
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    try:
        report = audit_full_document_catalog(args.catalog, verify_sources=args.verify_sources, root=args.root)
    except (OSError, FullDocumentCatalogError) as exc:
        raise SystemExit(str(exc)) from exc
    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.output.exists():
        raise SystemExit(f"output already exists: {args.output}")
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    summary = report["summary"]
    print(
        f"full document coverage written: {args.output} "
        f"valid={report['valid']} covered={summary['covered_content_pages']}/{summary['total_pages'] - summary['front_matter_pages']}"
    )
    return 0 if report["valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
