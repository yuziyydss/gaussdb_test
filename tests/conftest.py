"""Shared pytest fixtures and collection hooks for the gaussdb_test project."""
from __future__ import annotations

from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
WORK_DIR = ROOT / "work"


def pytest_collection_modifyitems(config, items):
    """Skip tests that require work/ source files when work/ is not available.

    The work/ directory contains extracted text from a proprietary PDF and is
    intentionally gitignored.  In CI, these files are absent, so tests that
    call build scripts resolving source files by SHA256 or depend on the GUC
    V2 chain (which itself requires work/) will fail.  We skip them to allow
    the remaining work-independent tests to pass.
    """
    if WORK_DIR.is_dir():
        return  # work/ available, no need to skip
    skip_marker = pytest.mark.skip(
        reason="work/ directory not available (proprietary source content not committed)"
    )
    for item in items:
        fspath = str(item.fspath)
        basename = Path(fspath).name
        # Build script --check tests: all wave test files have one
        if "test_written_manifest_is_current" in item.name:
            item.add_marker(skip_marker)
            continue
        # All GUC V2 chain tests depend on work/ files through the GUC reference catalog
        if "test_guc" in basename:
            item.add_marker(skip_marker)
            continue
        # Runtime status depends on GUC V2 readiness
        if basename == "test_runtime_status.py":
            item.add_marker(skip_marker)
            continue
        # GUC V2 audit test
        if basename == "test_guc_v2_audit.py":
            item.add_marker(skip_marker)
            continue
