"""The full-document catalog merge is deterministic and fail-closed."""
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from core.full_document_catalog import (
    FullDocumentCatalogError,
    audit_full_document_catalog,
    build_full_document_catalog,
)


PAGE_COUNT = 60
OUTLINE = [
    {"variant": "general", "outline_path": ["Book", "Chapter 1"], "content_route": "reference"},
    {"variant": "general", "outline_path": ["Book", "Chapter 2"], "content_route": "reference"},
]


def digest(text: str) -> str:
    return hashlib.sha256(text.encode()).hexdigest()


def catalog(root: Path, name: str, chapters):
    directory = root / name
    directory.mkdir()
    for chapter in chapters:
        source = directory / chapter["source_relpath"]
        source.parent.mkdir(parents=True, exist_ok=True)
        source.write_text(chapter.pop("source_text"), encoding="utf-8")
        chapter["chapter_sha256"] = digest(source.read_text())
    payload = {
        "schema_version": 1,
        "document_id": "test_document",
        "document_version": "01",
        "parent_pdf_sha256": "a" * 64,
        "product_version": "V1",
        "release_date": "2026-01-01",
        "extraction_rule_version": "test-rule",
        "parent_pdf_metadata": {"page_count": PAGE_COUNT},
        "extraction_rules": {"rule": "same"},
        "outline": OUTLINE,
        "chapters": chapters,
    }
    path = directory / "catalog.json"
    path.write_text(json.dumps(payload, ensure_ascii=False), encoding="utf-8")
    return path


def chapter(section, source_relpath, start, end, source_text, variant="general"):
    return {
        "variant": variant,
        "category": "utility",
        "section_number": section,
        "title": f"Section {section}",
        "outline_path": ["Book", f"Chapter {section}"],
        "start_destination": {"physical_page": start},
        "end_destination": {"physical_page": end},
        "physical_page_start": start,
        "physical_page_end": end,
        "printed_page_start": str(start),
        "printed_page_end": str(end),
        "source_relpath": source_relpath,
        "content_route": "reference",
        "source_text": source_text,
    }


class FullDocumentCatalogTests(unittest.TestCase):
    def test_merges_unique_chapters_and_audits_complete_coverage(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            first = catalog(root, "batch_1", [chapter(1, "a.txt", 1, 30, "alpha\n")])
            second = catalog(root, "batch_2", [
                chapter(1, "a.txt", 1, 30, "alpha\n"),
                chapter(2, "b.txt", 31, 60, "beta\n"),
            ])
            output = root / "merged/catalog.json"
            built = build_full_document_catalog(root, output)
            self.assertEqual(built["source_catalog_count"], 2)
            self.assertEqual(len(built["chapters"]), 2)
            self.assertEqual(built["front_matter"]["page_count"], 0)
            self.assertEqual(
                built["chapters"][0]["source_catalog_refs"],
                sorted({str(first.relative_to(root)), str(second.relative_to(root))}),
            )
            report = audit_full_document_catalog(output, verify_sources=True, root=root)
            self.assertTrue(report["valid"], report["errors"])
            self.assertEqual(report["summary"]["coverage_ratio"], 1.0)
            self.assertEqual(report["summary"]["missing_content_pages"], 0)

    def test_front_matter_is_explicit_and_not_counted_as_content(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            catalog(root, "batch", [
                chapter(1, "a.txt", 10, 30, "alpha\n"),
                chapter(2, "b.txt", 31, 60, "beta\n"),
            ])
            output = root / "merged/catalog.json"
            built = build_full_document_catalog(root, output)
            self.assertEqual(built["front_matter"], {
                "physical_page_start": 1,
                "physical_page_end": 9,
                "page_count": 9,
                "content_route": "front_matter",
                "status": "explicitly_ignored",
                "reason": "封面、版权、目录与前言不进入正文抽取分母。",
            })
            report = audit_full_document_catalog(output, root=root)
            self.assertTrue(report["valid"], report["errors"])
            self.assertEqual(report["summary"]["front_matter_pages"], 9)

    def test_page_gap_fails_audit(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            catalog(root, "batch", [chapter(1, "a.txt", 1, 30, "alpha\n")])
            output = root / "merged/catalog.json"
            build_full_document_catalog(root, output)
            payload = json.loads(output.read_text())
            payload["chapters"].append(dict(payload["chapters"][0], outline_path=["Book", "Chapter 2"], source_relpath="missing.txt", chapter_sha256="b" * 64, physical_page_start=40, physical_page_end=60))
            output.write_text(json.dumps(payload), encoding="utf-8")
            report = audit_full_document_catalog(output, root=root)
            self.assertFalse(report["valid"])
            self.assertEqual(report["summary"]["missing_content_pages"], 9)
            self.assertEqual(report["missing_ranges"], [{"start": 31, "end": 39}])

    def test_conflicting_chapter_identity_fails_merge(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            catalog(root, "batch_1", [chapter(1, "a.txt", 1, 30, "alpha\n")])
            catalog(root, "batch_2", [chapter(1, "a.txt", 1, 31, "different\n")])
            output = root / "merged/catalog.json"
            with self.assertRaises(FullDocumentCatalogError) as caught:
                build_full_document_catalog(root, output)
            self.assertIn("chapter conflict", str(caught.exception))

    def test_source_hash_drift_fails_optional_verification(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = catalog(root, "batch", [chapter(1, "a.txt", 1, 60, "alpha\n")])
            source = path.parent / "a.txt"
            source.write_text("changed\n", encoding="utf-8")
            output = root / "merged/catalog.json"
            build_full_document_catalog(root, output)
            report = audit_full_document_catalog(output, verify_sources=True, root=root)
            self.assertFalse(report["valid"])
            self.assertTrue(any("source hash drift" in error for error in report["errors"]))


    def test_repository_authoritative_catalog_covers_all_content_pages(self):
        root = Path(__file__).resolve().parents[1]
        catalog_path = root / "generated/full_document_catalog/catalog.json"
        report = audit_full_document_catalog(catalog_path, root=root)
        self.assertTrue(report["valid"], report["errors"])
        self.assertEqual(report["summary"], {
            "total_pages": 5686,
            "front_matter_pages": 49,
            "covered_content_pages": 5637,
            "missing_content_pages": 0,
            "coverage_ratio": 1.0,
            "chapter_count": 515,
            "outline_entry_count": 1964,
            "source_catalog_count": 83,
        })
        self.assertEqual(report["missing_ranges"], [])


if __name__ == "__main__":
    unittest.main()
