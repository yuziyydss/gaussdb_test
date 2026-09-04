from __future__ import annotations

import hashlib
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from scripts.audit_pdf_catalog_coverage import build_coverage_report
from scripts.manage_extraction_queue import (
    factor_package_sha256,
    inventory_state,
    verification_toolchain_sha256,
)


class PdfCatalogCoverageTests(unittest.TestCase):
    def test_cli_can_be_executed_as_a_script(self):
        script = Path(__file__).resolve().parents[1] / "scripts/audit_pdf_catalog_coverage.py"
        completed = subprocess.run(
            [sys.executable, "-B", str(script), "--help"],
            capture_output=True,
            text=True,
            check=False,
        )

        self.assertEqual(completed.returncode, 0, completed.stderr)
        self.assertIn("--source-catalog", completed.stdout)

    def test_reports_pdf_denominator_and_each_closure_stage(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            pdf = root / "source.pdf"
            pdf.write_bytes(b"pdf")
            corpus = root / "corpus"
            source = corpus / "general/ddl/create_view.txt"
            source.parent.mkdir(parents=True)
            source.write_text("CREATE VIEW\n", encoding="utf-8")
            chapter_hash = hashlib.sha256(source.read_bytes()).hexdigest()
            view_path = ["1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.60 CREATE VIEW"]
            index_path = ["1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.27 CREATE INDEX"]
            catalog = {
                "schema_version": 1,
                "document_id": "doc",
                "parent_pdf_path": str(pdf),
                "parent_pdf_sha256": hashlib.sha256(pdf.read_bytes()).hexdigest(),
                "product_version": "V1",
                "document_version": "01",
                "extraction_rule_version": "v1",
                "outline": [
                    {"content_route": "general_sql_statement", "variant": "general", "section_number": "1.13.9.60", "title": "CREATE VIEW", "outline_path": view_path},
                    {"content_route": "general_sql_statement", "variant": "general", "section_number": "1.13.9.27", "title": "CREATE INDEX", "outline_path": index_path},
                ],
                "chapters": [{
                    "source_relpath": "general/ddl/create_view.txt",
                    "variant": "general",
                    "category": "ddl",
                    "section_number": "1.13.9.60",
                    "title": "CREATE VIEW",
                    "outline_path": view_path,
                    "start_destination": {"physical_page": 10, "printed_page": "1", "pdf_top": 700.0, "y_from_top": 100.0, "coordinate_unit": "pt"},
                    "end_destination": {"physical_page": 11, "printed_page": "2", "pdf_top": 600.0, "y_from_top": 200.0, "coordinate_unit": "pt", "exclusive": True},
                    "physical_page_start": 10,
                    "physical_page_end": 10,
                    "printed_page_start": "1",
                    "printed_page_end": "1",
                    "chapter_sha256": chapter_hash,
                }],
            }
            catalog_path = corpus / "catalog.json"
            catalog_path.write_text(json.dumps(catalog), encoding="utf-8")
            specs = root / "specs/ddl/create_view"
            specs.mkdir(parents=True)
            (specs / "create_view.factor.yaml").write_text(
                "id: create_view\nsource:\n"
                f"  parent_pdf_sha256: {catalog['parent_pdf_sha256']}\n"
                "  extraction_rule_version: v1\n"
                "  catalog_chapter_ref:\n"
                "    document_id: doc\n"
                "    source_relpath: general/ddl/create_view.txt\n"
                f"    chapter_sha256: {chapter_hash}\n",
                encoding="utf-8",
            )
            queue_state = inventory_state(
                corpus,
                root / "specs",
                source_catalog_path=catalog_path,
            )
            task = queue_state["tasks"][0]
            task["status"] = "static_complete"
            task["verification_snapshot"] = {
                "factor_package_sha256": factor_package_sha256(specs),
                "toolchain_sha256": verification_toolchain_sha256(),
                "source_sha256": task["source_sha256"],
                "catalog_sha256": task["source_catalog_sha256"],
                "parent_pdf_sha256": task["parent_pdf_sha256"],
                "verified_at": "2026-09-04T00:00:00+00:00",
            }
            queue = root / "queue.json"
            queue.write_text(json.dumps(queue_state), encoding="utf-8")

            report = build_coverage_report(
                catalog_path,
                root / "specs",
                queue_path=queue,
            )

            self.assertEqual(report["summary"]["total"], 2)
            self.assertEqual(report["summary"]["extracted"], 1)
            self.assertEqual(report["summary"]["package_bound"], 1)
            self.assertEqual(report["summary"]["static_complete"], 1)
            self.assertEqual(report["errors"], [])

            original_source = source.read_bytes()
            source.write_text("CREATE VIEW changed\n", encoding="utf-8")
            stale_source = build_coverage_report(
                catalog_path,
                root / "specs",
                queue_path=queue,
            )
            self.assertEqual(stale_source["summary"]["extracted"], 0)
            self.assertEqual(stale_source["summary"]["static_complete"], 0)
            self.assertIn(
                "source_changed_after_verify",
                stale_source["statements"][0]["static_complete_stale_reasons"],
            )
            source.write_bytes(original_source)

            original_catalog = catalog_path.read_bytes()
            catalog_path.write_bytes(original_catalog + b"\n")
            stale_catalog = build_coverage_report(
                catalog_path,
                root / "specs",
                queue_path=queue,
            )
            self.assertEqual(stale_catalog["summary"]["static_complete"], 0)
            self.assertIn(
                "catalog_changed_after_verify",
                stale_catalog["statements"][0]["static_complete_stale_reasons"],
            )
            catalog_path.write_bytes(original_catalog)

            original_pdf = pdf.read_bytes()
            pdf.write_bytes(b"changed pdf")
            stale_pdf = build_coverage_report(
                catalog_path,
                root / "specs",
                queue_path=queue,
            )
            self.assertEqual(stale_pdf["summary"]["static_complete"], 0)
            self.assertIn(
                "parent_pdf_changed_after_verify",
                stale_pdf["statements"][0]["static_complete_stale_reasons"],
            )
            pdf.write_bytes(original_pdf)

            factor_file = specs / "create_view.factor.yaml"
            factor_file.write_text(
                factor_file.read_text(encoding="utf-8") + "description: changed\n",
                encoding="utf-8",
            )
            stale = build_coverage_report(
                catalog_path,
                root / "specs",
                queue_path=queue,
            )
            self.assertEqual(stale["summary"]["static_complete"], 0)
            self.assertEqual(stale["stale_static_complete"], 1)
            self.assertIn(
                "factor_package_changed_after_verify",
                stale["statements"][0]["static_complete_stale_reasons"],
            )


if __name__ == "__main__":
    unittest.main()
