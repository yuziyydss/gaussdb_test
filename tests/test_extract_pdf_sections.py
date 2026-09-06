from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from scripts.extract_pdf_sections import (
    Bookmark,
    Destination,
    assign_end_destinations,
    canonical_json_bytes,
    chapter_record,
    classify_outline,
    extract_chapter_text,
    infer_category,
    parse_cover_identity,
    PdfExtractionError,
    protect_existing_catalog,
    select_bookmarks,
    select_statement_bookmarks,
    sha256_text,
    source_relpath_for,
)


def destination(page: int, y_from_top: float, printed: str) -> Destination:
    return Destination(
        physical_page=page,
        printed_page=printed,
        pdf_top=841.89 - y_from_top,
        y_from_top=y_from_top,
        page_height=841.89,
    )


def bookmark(
    *,
    index: int,
    depth: int,
    path: tuple[str, ...],
    section_number: str,
    title: str,
    variant: str,
    page: int,
    y_from_top: float,
    printed: str,
) -> Bookmark:
    return Bookmark(
        index=index,
        depth=depth,
        outline_path=path,
        section_number=section_number,
        title=title,
        variant=variant,
        start_destination=destination(page, y_from_top, printed),
    )


class PdfSectionExtractionTests(unittest.TestCase):
    def test_chinese_supplemental_titles_use_section_identity(self):
        paths = []
        for section in ("1.9.2", "2.3.2"):
            item = bookmark(
                index=0, depth=2, path=("SQL参考", "类型转换", "操作符"),
                section_number=section, title="操作符", variant="general",
                page=10, y_from_top=90.0, printed="1",
            )
            paths.append(source_relpath_for(item, "utility"))
        self.assertEqual(paths, ["general/utility/section_1_9_2.txt", "general/utility/section_2_3_2.txt"])

    def test_existing_catalog_requires_explicit_replacement_when_scope_changes(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "catalog.json"
            existing = {
                "document_id": "doc",
                "parent_pdf_sha256": "a" * 64,
                "extraction_rule_version": "v1",
                "chapters": [{"source_relpath": "general/ddl/create_view.txt"}],
            }
            path.write_text(json.dumps(existing), encoding="utf-8")
            same_scope = dict(existing)
            changed_scope = {
                **existing,
                "chapters": [{"source_relpath": "general/dml/select.txt"}],
            }

            protect_existing_catalog(path, same_scope, replace=False)
            with self.assertRaises(PdfExtractionError):
                protect_existing_catalog(path, changed_scope, replace=False)
            protect_existing_catalog(path, changed_scope, replace=True)

    def test_all_statement_selection_keeps_variants_distinct(self):
        general = bookmark(
            index=0,
            depth=3,
            path=("1 SQL参考", "1.13 SQL语法", "1.13.19 S", "1.13.19.3 SELECT"),
            section_number="1.13.19.3",
            title="SELECT",
            variant="general",
            page=20,
            y_from_top=100.0,
            printed="11",
        )
        m_compat = bookmark(
            index=1,
            depth=4,
            path=(
                "2 SQL参考-M-Compatibility兼容模式",
                "2.4 SQL语法",
                "2.4.2 SQL语句",
                "2.4.2.14 S",
                "2.4.2.14.3 SELECT",
            ),
            section_number="2.4.2.14.3",
            title="SELECT",
            variant="m_compat",
            page=200,
            y_from_top=100.0,
            printed="191",
        )
        navigation = bookmark(
            index=2,
            depth=2,
            path=("1 SQL参考", "1.13 SQL语法", "1.13.19 S"),
            section_number="1.13.19",
            title="S",
            variant="general",
            page=19,
            y_from_top=100.0,
            printed="10",
        )

        self.assertEqual(
            select_statement_bookmarks(
                [general, m_compat, navigation], variants=["general"]
            ),
            [general],
        )
        self.assertEqual(
            select_statement_bookmarks(
                [general, m_compat, navigation], variants=["general", "m_compat"]
            ),
            [general, m_compat],
        )

    def test_semantic_category_routing_is_explicit(self):
        examples = {
            "CREATE TABLE": "ddl",
            "SELECT": "dml",
            "CALL": "dml",
            "GRANT": "dcl",
            "COMMIT": "tcl",
            "EXPLAIN": "utility",
        }
        for title, expected in examples.items():
            with self.subTest(title=title):
                item = bookmark(
                    index=0,
                    depth=3,
                    path=("1 SQL参考", "1.13 SQL语法", "group", title),
                    section_number="1.13.1.1",
                    title=title,
                    variant="general",
                    page=1,
                    y_from_top=100.0,
                    printed="1",
                )
                self.assertEqual(infer_category(item), expected)

    def test_cover_identity_is_read_from_document_text(self):
        identity = parse_cover_identity(
            "GaussDB\nV2.0-10.0.0\n集中式版参考\n"
            "文档版本          01\n发布日期          2026-04-30\n"
        )
        self.assertEqual(identity["product_version"], "V2.0-10.0.0")
        self.assertEqual(identity["document_version"], "01")
        self.assertEqual(identity["release_date"], "2026-04-30")

    def test_shared_page_bookmarks_use_end_exclusive_coordinate(self):
        first = bookmark(
            index=0,
            depth=3,
            path=("1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.1 CREATE A"),
            section_number="1.13.9.1",
            title="CREATE A",
            variant="general",
            page=10,
            y_from_top=100.0,
            printed="1",
        )
        second = bookmark(
            index=1,
            depth=3,
            path=("1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.2 CREATE B"),
            section_number="1.13.9.2",
            title="CREATE B",
            variant="general",
            page=10,
            y_from_top=300.0,
            printed="1",
        )
        bounded = assign_end_destinations(
            [first, second],
            page_count=10,
            page_labels=[str(number) for number in range(1, 11)],
            page_heights=[841.89] * 10,
        )

        calls: list[tuple[int, float, float]] = []

        def extract_page(page: int, top: float, bottom: float) -> str:
            calls.append((page, top, bottom))
            return "1.13.9.1 CREATE A\r\nSELECT 1;   \r\n"

        text = extract_chapter_text(bounded[0], extract_page)

        self.assertEqual(calls, [(10, 100.0, 300.0)])
        self.assertEqual(
            text,
            "[[PDF_PAGE physical=10 printed=1]]\n"
            "1.13.9.1 CREATE A\n"
            "SELECT 1;\n",
        )
        self.assertNotIn("CREATE B", text)

    def test_same_title_is_isolated_by_variant_and_section_number(self):
        general = bookmark(
            index=0,
            depth=3,
            path=("1 SQL参考", "1.13 SQL语法", "1.13.9 C", "1.13.9.48 CREATE TABLE"),
            section_number="1.13.9.48",
            title="CREATE TABLE",
            variant="general",
            page=1532,
            y_from_top=352.0,
            printed="1483",
        )
        m_compat = bookmark(
            index=1,
            depth=4,
            path=(
                "2 SQL参考-M-Compatibility兼容模式",
                "2.4 SQL语法",
                "2.4.2 SQL语句",
                "2.4.2.8 C",
                "2.4.2.8.16 CREATE TABLE",
            ),
            section_number="2.4.2.8.16",
            title="CREATE TABLE",
            variant="m_compat",
            page=2117,
            y_from_top=677.0,
            printed="2068",
        )

        selected = select_bookmarks(
            [general, m_compat],
            variant="general",
            section_numbers=["1.13.9.48"],
        )

        self.assertEqual(selected, [general])
        self.assertNotEqual(
            source_relpath_for(general, "ddl"),
            source_relpath_for(m_compat, "ddl"),
        )
        self.assertEqual(source_relpath_for(general, "ddl"), "general/ddl/create_table.txt")
        self.assertEqual(source_relpath_for(m_compat, "ddl"), "m_compat/ddl/create_table.txt")
        self.assertEqual(classify_outline(general), "general_sql_statement")
        self.assertEqual(classify_outline(m_compat), "m_compat_sql_statement")

    def test_normalized_chapter_and_catalog_hashes_are_stable(self):
        item = bookmark(
            index=0,
            depth=3,
            path=("1 SQL参考", "1.13 SQL语法", "1.13.19 S", "1.13.19.3 SELECT"),
            section_number="1.13.19.3",
            title="SELECT",
            variant="general",
            page=20,
            y_from_top=100.0,
            printed="11",
        )
        item = assign_end_destinations(
            [item],
            page_count=20,
            page_labels=[str(number) for number in range(1, 21)],
            page_heights=[841.89] * 20,
        )[0]

        first = extract_chapter_text(item, lambda *_: "SELECT 1;\r\n\r\n")
        second = extract_chapter_text(item, lambda *_: "SELECT 1;   \n\n\n")

        self.assertEqual(first, second)
        self.assertEqual(sha256_text(first), sha256_text(second))
        self.assertEqual(
            canonical_json_bytes({"b": 2, "a": 1}),
            canonical_json_bytes({"a": 1, "b": 2}),
        )

    def test_chapter_page_range_comes_from_written_page_markers(self):
        first = bookmark(
            index=0,
            depth=3,
            path=("1 SQL参考", "1.13 SQL语法", "1.13.19 S", "1.13.19.3 SELECT"),
            section_number="1.13.19.3",
            title="SELECT",
            variant="general",
            page=10,
            y_from_top=100.0,
            printed="10",
        )
        following = bookmark(
            index=1,
            depth=3,
            path=("1 SQL参考", "1.13 SQL语法", "1.13.19 S", "1.13.19.4 SELECT INTO"),
            section_number="1.13.19.4",
            title="SELECT INTO",
            variant="general",
            page=12,
            y_from_top=80.0,
            printed="12",
        )
        bounded = assign_end_destinations(
            [first, following],
            page_count=12,
            page_labels=[str(number) for number in range(1, 13)],
            page_heights=[841.89] * 12,
        )[0]
        chapter_text = extract_chapter_text(
            bounded,
            lambda page, *_: "body" if page in {10, 11} else "",
            page_labels=[str(number) for number in range(1, 13)],
        )

        record = chapter_record(
            bounded,
            category="dml",
            source_relpath="general/dml/select.txt",
            chapter_text=chapter_text,
        )

        self.assertEqual(record["physical_page_start"], 10)
        self.assertEqual(record["physical_page_end"], 11)
        self.assertEqual(record["printed_page_start"], "10")
        self.assertEqual(record["printed_page_end"], "11")
        self.assertEqual(record["outline_path"], list(bounded.outline_path))


if __name__ == "__main__":
    unittest.main()
