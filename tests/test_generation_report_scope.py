"""Scoped generation must not overwrite the canonical global report."""
from pathlib import Path
from types import SimpleNamespace
import unittest

from scripts.generate_factor_package_sql import ROOT_DIR, should_write_global_report

CANONICAL = ROOT_DIR / "generated" / "factor_packages"
CUSTOM = ROOT_DIR / "tmp" / "scoped-report"


class GenerationReportScopeTests(unittest.TestCase):
    def registry(self):
        return SimpleNamespace(manifests={"a", "b"})

    def test_partial_run_preserves_canonical_global_report(self):
        self.assertFalse(should_write_global_report(CANONICAL, ["a"], self.registry()))

    def test_full_run_updates_canonical_global_report(self):
        self.assertTrue(should_write_global_report(CANONICAL, ["a", "b"], self.registry()))

    def test_custom_output_dir_may_receive_scoped_report(self):
        self.assertTrue(should_write_global_report(CUSTOM, ["a"], self.registry()))


if __name__ == "__main__":
    unittest.main()
