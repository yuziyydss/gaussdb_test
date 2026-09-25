#!/usr/bin/env python3
"""Build the authoritative full-document catalog from all local catalogs."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from core.full_document_catalog import FullDocumentCatalogError, build_full_document_catalog


def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=ROOT / "generated/full_document_catalog/catalog.json")
    parser.add_argument("--root", type=Path, default=ROOT)
    return parser.parse_args(argv)


def main(argv=None) -> int:
    args = parse_args(argv)
    try:
        catalog = build_full_document_catalog(args.root, args.output)
    except (OSError, FullDocumentCatalogError) as exc:
        raise SystemExit(str(exc)) from exc
    summary = catalog["scope_summary"]
    print(
        f"full document catalog written: {args.output} "
        f"chapters={summary['chapter_count']} outline={summary['outline_entry_count']} "
        f"front_matter_pages={summary['front_matter_page_count']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
