#!/usr/bin/env python3
"""Build a deterministic PDF outline catalog and extract bookmark sections.

The default selection is the five general-variant SQL chapters already modeled
by this repository.  M-Compatibility bookmarks remain separately addressable
through their ``m_compat`` variant and are never matched by title alone.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import re
import shutil
import subprocess
import sys
import tempfile
from collections import Counter
from dataclasses import dataclass, replace
from pathlib import Path
from typing import Any, Callable, Dict, Iterable, List, Optional, Sequence, Tuple


ROOT_DIR = Path(__file__).resolve().parents[1]
DEFAULT_PDF_PATH = ROOT_DIR / "gaussdb-rf-cent.pdf"
DEFAULT_OUTPUT_ROOT = ROOT_DIR / "intranet_corpus"
DEFAULT_CATALOG_NAME = "catalog.json"

SCHEMA_VERSION = 1
EXTRACTION_RULE_VERSION = "gaussdb-pdf-outline-v1"
CONTENT_TOP_PT = 72.0
CONTENT_BOTTOM_PT = 765.0
PAGE_MARKER_TEMPLATE = "[[PDF_PAGE physical={physical_page} printed={printed_page}]]"
PAGE_MARKER_RE = re.compile(
    r"^\[\[PDF_PAGE physical=(\d+) printed=([^\]]+)\]\]$",
    re.MULTILINE,
)

DEFAULT_GENERAL_SECTIONS: Tuple[Tuple[str, str], ...] = (
    ("1.13.7.36", "ddl"),   # ALTER TABLE
    ("1.13.9.27", "ddl"),   # CREATE INDEX
    ("1.13.9.60", "ddl"),   # CREATE VIEW
    ("1.13.14.7", "dml"),   # INSERT
    ("1.13.19.3", "dml"),   # SELECT
)

STATEMENT_ROUTE_BY_VARIANT = {
    "general": "general_sql_statement",
    "m_compat": "m_compat_sql_statement",
}
DDL_COMMANDS = ("ALTER", "COMMENT", "CREATE", "DROP", "REINDEX", "TRUNCATE")
DML_COMMANDS = ("CALL", "COPY", "DELETE", "FETCH", "INSERT", "MERGE", "MOVE", "SELECT", "UPDATE", "VALUES")
DCL_COMMANDS = ("GRANT", "REVOKE")
TCL_COMMANDS = (
    "ABORT",
    "BEGIN",
    "COMMIT",
    "END",
    "PREPARE TRANSACTION",
    "RELEASE SAVEPOINT",
    "ROLLBACK",
    "SAVEPOINT",
    "START TRANSACTION",
)


class PdfExtractionError(ValueError):
    """Raised when a PDF cannot produce an unambiguous source catalog."""


def parse_cover_identity(text: str) -> Dict[str, str]:
    """Read the version identity printed on the cover; never infer it from a filename."""
    product = re.search(r"GaussDB\s+(V\d+(?:\.\d+)+(?:-[\d.]+)?)", text, re.DOTALL)
    document = re.search(r"文档版本\s+([^\s]+)", text)
    release = re.search(r"发布日期\s+(\d{4}-\d{2}-\d{2})", text)
    missing = [
        name
        for name, match in (
            ("product_version", product),
            ("document_version", document),
            ("release_date", release),
        )
        if match is None
    ]
    if missing:
        raise PdfExtractionError(f"PDF 封面缺少可验证的版本字段: {missing}")
    return {
        "product_version": product.group(1),
        "document_version": document.group(1),
        "release_date": release.group(1),
    }


@dataclass(frozen=True)
class Destination:
    physical_page: int
    printed_page: str
    pdf_top: Optional[float]
    y_from_top: float
    page_height: float

    def as_dict(self, *, exclusive: bool = False) -> Dict[str, Any]:
        result: Dict[str, Any] = {
            "physical_page": self.physical_page,
            "printed_page": self.printed_page,
            "pdf_top": stable_float(self.pdf_top),
            "y_from_top": stable_float(self.y_from_top),
            "coordinate_unit": "pt",
        }
        if exclusive:
            result["exclusive"] = True
        return result


@dataclass(frozen=True)
class Bookmark:
    index: int
    depth: int
    outline_path: Tuple[str, ...]
    section_number: Optional[str]
    title: str
    variant: str
    start_destination: Destination
    end_destination: Optional[Destination] = None


PageExtractor = Callable[[int, float, float], str]


def stable_float(value: Optional[float]) -> Optional[float]:
    if value is None:
        return None
    return round(float(value), 6)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def canonical_json_bytes(payload: Dict[str, Any]) -> bytes:
    return (
        json.dumps(payload, ensure_ascii=False, sort_keys=True, indent=2) + "\n"
    ).encode("utf-8")


def parse_outline_title(value: str) -> Tuple[Optional[str], str]:
    value = value.strip()
    match = re.match(r"^(\d+(?:\.\d+)*)\s+(.+)$", value)
    if not match:
        return None, value
    return match.group(1), match.group(2).strip()


def infer_variant(outline_path: Sequence[str]) -> str:
    joined = " ".join(outline_path).casefold()
    return "m_compat" if "m-compatibility" in joined else "general"


def classify_outline(bookmark: Bookmark) -> str:
    """Classify every bookmark so the whole PDF has an explicit denominator."""
    top = bookmark.outline_path[0] if bookmark.outline_path else ""
    number_parts = (bookmark.section_number or "").split(".")
    if top == "1 SQL参考":
        if bookmark.section_number and bookmark.section_number.startswith("1.13."):
            if bookmark.depth == 3 and len(number_parts) == 4:
                return "general_sql_statement"
            if any(re.match(r"^1\.13\.\d+\.\d+\s", item) for item in bookmark.outline_path[:-1]):
                return "general_sql_statement_subsection"
            return "general_sql_navigation"
        return "general_sql_reference"
    if top == "2 SQL参考-M-Compatibility兼容模式":
        if bookmark.section_number and bookmark.section_number.startswith("2.4.2."):
            if bookmark.depth == 4 and len(number_parts) == 5:
                return "m_compat_sql_statement"
            if any(re.match(r"^2\.4\.2\.\d+\.\d+\s", item) for item in bookmark.outline_path[:-1]):
                return "m_compat_sql_statement_subsection"
            return "m_compat_sql_navigation"
        return "m_compat_sql_reference"
    top_routes = {
        "3 存储过程": "stored_procedure_reference",
        "4 兼容性说明": "compatibility_reference",
        "5 工具参考": "tool_reference",
        "6 日志参考": "log_reference",
        "7 数据库运行参数说明": "configuration_reference",
        "8 系统表和系统视图": "metadata_catalog_reference",
        "9 系统表和系统视图-M-Compatibility兼容模式": "m_compat_metadata_catalog_reference",
        "10 Schema": "schema_reference",
        "11 Schema-M-Compatibility兼容模式": "m_compat_schema_reference",
        "12 WDR报告": "report_reference",
        "13 ASP报告": "report_reference",
    }
    return top_routes.get(top, "document_navigation")


def assign_end_destinations(
    bookmarks: Sequence[Bookmark],
    *,
    page_count: int,
    page_labels: Sequence[str],
    page_heights: Sequence[float],
) -> List[Bookmark]:
    """Assign each bookmark the next same-or-higher-level destination.

    End destinations are exclusive.  Skipping descendants makes a parent
    bookmark span its complete subtree, while leaf bookmarks end at the next
    sibling even when both destinations share a physical page.
    """
    if page_count <= 0:
        raise PdfExtractionError("PDF page_count must be positive")
    if len(page_labels) != page_count or len(page_heights) != page_count:
        raise PdfExtractionError("page labels/heights must cover every physical page")

    last_height = float(page_heights[-1])
    terminal = Destination(
        physical_page=page_count,
        printed_page=str(page_labels[-1]),
        pdf_top=last_height - min(CONTENT_BOTTOM_PT, last_height),
        y_from_top=min(CONTENT_BOTTOM_PT, last_height),
        page_height=last_height,
    )
    bounded: List[Bookmark] = []
    for index, bookmark in enumerate(bookmarks):
        end = terminal
        for candidate in bookmarks[index + 1 :]:
            if candidate.depth <= bookmark.depth:
                end = candidate.start_destination
                break
        if destination_key(end) < destination_key(bookmark.start_destination):
            raise PdfExtractionError(
                f"outline destination moved backwards: {bookmark.outline_path!r}"
            )
        bounded.append(replace(bookmark, end_destination=end))
    return bounded


def destination_key(destination: Destination) -> Tuple[int, float]:
    return destination.physical_page, destination.y_from_top


def select_bookmarks(
    bookmarks: Sequence[Bookmark],
    *,
    variant: str,
    section_numbers: Sequence[str],
) -> List[Bookmark]:
    selected: List[Bookmark] = []
    for section_number in section_numbers:
        matches = [
            bookmark
            for bookmark in bookmarks
            if bookmark.variant == variant
            and bookmark.section_number == section_number
        ]
        if not matches:
            raise PdfExtractionError(
                f"bookmark not found for variant={variant!r}, section={section_number!r}"
            )
        if len(matches) > 1:
            paths = [" > ".join(item.outline_path) for item in matches]
            raise PdfExtractionError(
                f"ambiguous bookmark for variant={variant!r}, "
                f"section={section_number!r}: {paths}"
            )
        selected.append(matches[0])
    return selected


def select_statement_bookmarks(
    bookmarks: Sequence[Bookmark], *, variants: Sequence[str]
) -> List[Bookmark]:
    """Select every top-level SQL statement for the requested document variants."""
    requested = tuple(dict.fromkeys(variants))
    unknown = sorted(set(requested) - set(STATEMENT_ROUTE_BY_VARIANT))
    if unknown:
        raise PdfExtractionError(f"unknown statement variants: {unknown}")
    routes = {STATEMENT_ROUTE_BY_VARIANT[variant] for variant in requested}
    selected = [bookmark for bookmark in bookmarks if classify_outline(bookmark) in routes]
    if not selected:
        raise PdfExtractionError(f"no SQL statement bookmarks found for variants={requested!r}")
    return selected


def source_relpath_for(bookmark: Bookmark, category: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "_", bookmark.title.casefold()).strip("_")
    if not slug:
        raise PdfExtractionError(
            f"bookmark title cannot form a stable source filename: {bookmark.title!r}"
        )
    return f"{bookmark.variant}/{category}/{slug}.txt"


def normalize_page_text(text: str) -> str:
    text = text.replace("\r\n", "\n").replace("\r", "\n").replace("\f", "")
    lines = [line.rstrip() for line in text.split("\n")]
    while lines and not lines[0]:
        lines.pop(0)
    while lines and not lines[-1]:
        lines.pop()
    return "\n".join(lines)


def extract_chapter_text(
    bookmark: Bookmark,
    extract_page: PageExtractor,
    *,
    page_labels: Optional[Sequence[str]] = None,
) -> str:
    """Extract one bookmark range with deterministic page markers and margins."""
    end = bookmark.end_destination
    if end is None:
        raise PdfExtractionError("bookmark end destination has not been assigned")

    page_chunks: List[str] = []
    for physical_page in range(
        bookmark.start_destination.physical_page,
        end.physical_page + 1,
    ):
        top = CONTENT_TOP_PT
        bottom = CONTENT_BOTTOM_PT
        if physical_page == bookmark.start_destination.physical_page:
            top = max(top, bookmark.start_destination.y_from_top)
        if physical_page == end.physical_page:
            bottom = min(bottom, end.y_from_top)
        if bottom <= top:
            continue

        page_text = normalize_page_text(extract_page(physical_page, top, bottom))
        if not page_text:
            continue
        printed_page = printed_label_for_page(
            physical_page,
            bookmark,
            page_labels,
        )
        marker = PAGE_MARKER_TEMPLATE.format(
            physical_page=physical_page,
            printed_page=printed_page,
        )
        page_chunks.append(f"{marker}\n{page_text}")

    if not page_chunks:
        raise PdfExtractionError(
            f"bookmark produced no text: {' > '.join(bookmark.outline_path)}"
        )
    return "\n".join(page_chunks) + "\n"


def printed_label_for_page(
    physical_page: int,
    bookmark: Bookmark,
    page_labels: Optional[Sequence[str]],
) -> str:
    if page_labels is not None:
        return str(page_labels[physical_page - 1])
    if physical_page == bookmark.start_destination.physical_page:
        return bookmark.start_destination.printed_page
    if (
        bookmark.end_destination is not None
        and physical_page == bookmark.end_destination.physical_page
    ):
        return bookmark.end_destination.printed_page
    return str(physical_page)


class PopplerPageExtractor:
    """Extract cropped page text through pdftotext at a fixed 72 DPI."""

    def __init__(
        self,
        pdf_path: Path,
        page_widths: Sequence[float],
        page_heights: Sequence[float],
        binary: Optional[str] = None,
    ) -> None:
        self.pdf_path = pdf_path
        self.page_widths = page_widths
        self.page_heights = page_heights
        self.binary = binary or shutil.which("pdftotext") or ""
        if not self.binary:
            raise PdfExtractionError("pdftotext is required but was not found")

    def __call__(self, physical_page: int, top: float, bottom: float) -> str:
        width = float(self.page_widths[physical_page - 1])
        height = float(self.page_heights[physical_page - 1])
        crop_top = max(0, int(math.floor(top)))
        crop_bottom = min(int(math.ceil(height)), int(math.ceil(bottom)))
        crop_height = crop_bottom - crop_top
        if crop_height <= 0:
            return ""
        command = [
            self.binary,
            "-f",
            str(physical_page),
            "-l",
            str(physical_page),
            "-r",
            "72",
            "-layout",
            "-enc",
            "UTF-8",
            "-eol",
            "unix",
            "-nopgbrk",
            "-x",
            "0",
            "-y",
            str(crop_top),
            "-W",
            str(int(math.ceil(width))),
            "-H",
            str(crop_height),
            str(self.pdf_path),
            "-",
        ]
        result = subprocess.run(command, capture_output=True, check=False)
        if result.returncode != 0:
            stderr = result.stderr.decode("utf-8", errors="replace").strip()
            raise PdfExtractionError(
                f"pdftotext failed for physical page {physical_page}: {stderr}"
            )
        return result.stdout.decode("utf-8")


def load_pypdf_reader(pdf_path: Path) -> Any:
    try:
        from pypdf import PdfReader
    except ModuleNotFoundError as exc:
        raise PdfExtractionError(
            "pypdf is required for bookmark coordinates; run with the bundled "
            "workspace Python or install pypdf"
        ) from exc
    try:
        reader = PdfReader(pdf_path, strict=True)
    except Exception as exc:
        raise PdfExtractionError(f"cannot read PDF {pdf_path}: {exc}") from exc
    if reader.is_encrypted:
        raise PdfExtractionError(f"encrypted PDF is not supported: {pdf_path}")
    return reader


def flatten_outline(
    reader: Any,
    page_labels: Sequence[str],
    page_heights: Sequence[float],
) -> List[Bookmark]:
    entries: List[Bookmark] = []

    def visit(items: Iterable[Any], parents: Tuple[str, ...]) -> None:
        last_title: Optional[str] = None
        for item in items:
            if isinstance(item, list):
                if last_title is None:
                    raise PdfExtractionError("outline child list has no parent bookmark")
                visit(item, parents + (last_title,))
                continue

            title = str(getattr(item, "title", item)).strip()
            physical_index = reader.get_destination_page_number(item)
            if physical_index is None or physical_index < 0:
                raise PdfExtractionError(f"unresolved outline destination: {title!r}")
            physical_page = physical_index + 1
            page_height = float(page_heights[physical_index])
            raw_top = getattr(item, "top", None)
            try:
                pdf_top = float(raw_top)
            except (TypeError, ValueError):
                pdf_top = None
            y_from_top = (
                page_height - pdf_top if pdf_top is not None else CONTENT_TOP_PT
            )
            outline_path = parents + (title,)
            section_number, short_title = parse_outline_title(title)
            entries.append(
                Bookmark(
                    index=len(entries),
                    depth=len(parents),
                    outline_path=outline_path,
                    section_number=section_number,
                    title=short_title,
                    variant=infer_variant(outline_path),
                    start_destination=Destination(
                        physical_page=physical_page,
                        printed_page=str(page_labels[physical_index]),
                        pdf_top=pdf_top,
                        y_from_top=y_from_top,
                        page_height=page_height,
                    ),
                )
            )
            last_title = title

    visit(reader.outline, ())
    return entries


def bookmark_record(bookmark: Bookmark) -> Dict[str, Any]:
    if bookmark.end_destination is None:
        raise PdfExtractionError("bookmark end destination has not been assigned")
    return {
        "index": bookmark.index,
        "depth": bookmark.depth,
        "variant": bookmark.variant,
        "content_route": classify_outline(bookmark),
        "section_number": bookmark.section_number,
        "title": bookmark.title,
        "outline_path": list(bookmark.outline_path),
        "start_destination": bookmark.start_destination.as_dict(),
        "end_destination": bookmark.end_destination.as_dict(exclusive=True),
    }


def chapter_record(
    bookmark: Bookmark,
    *,
    category: str,
    source_relpath: str,
    chapter_text: str,
) -> Dict[str, Any]:
    if bookmark.end_destination is None:
        raise PdfExtractionError("bookmark end destination has not been assigned")
    page_markers = PAGE_MARKER_RE.findall(chapter_text)
    if not page_markers:
        raise PdfExtractionError("chapter text contains no PDF page markers")
    first_physical_page, first_printed_page = page_markers[0]
    last_physical_page, last_printed_page = page_markers[-1]
    return {
        "source_relpath": source_relpath,
        "variant": bookmark.variant,
        "content_route": classify_outline(bookmark),
        "category": category,
        "section_number": bookmark.section_number,
        "title": bookmark.title,
        "outline_path": list(bookmark.outline_path),
        "start_destination": bookmark.start_destination.as_dict(),
        "end_destination": bookmark.end_destination.as_dict(exclusive=True),
        "physical_page_start": int(first_physical_page),
        "physical_page_end": int(last_physical_page),
        "printed_page_start": first_printed_page,
        "printed_page_end": last_printed_page,
        "chapter_sha256": sha256_text(chapter_text),
    }


def metadata_value(metadata: Any, key: str) -> Optional[str]:
    value = metadata.get(key) if metadata else None
    return None if value is None else str(value)


def document_metadata(reader: Any, page_widths: Sequence[float], page_heights: Sequence[float]) -> Dict[str, Any]:
    metadata = reader.metadata
    root = reader.trailer["/Root"]
    return {
        "title": metadata_value(metadata, "/Title"),
        "subject": metadata_value(metadata, "/Subject"),
        "author": metadata_value(metadata, "/Author"),
        "creator": metadata_value(metadata, "/Creator"),
        "producer": metadata_value(metadata, "/Producer"),
        "creation_date": metadata_value(metadata, "/CreationDate"),
        "modification_date": metadata_value(metadata, "/ModDate"),
        "pdf_header": str(reader.pdf_header),
        "page_count": len(reader.pages),
        "first_page_size_pt": {
            "width": stable_float(page_widths[0]),
            "height": stable_float(page_heights[0]),
        },
        "encrypted": bool(reader.is_encrypted),
        "tagged": "/StructTreeRoot" in root,
    }


def infer_category(bookmark: Bookmark) -> str:
    title = " ".join(bookmark.title.upper().split())

    def matches(commands: Sequence[str]) -> bool:
        return any(
            title == command
            or title.startswith(f"{command} ")
            or title.startswith(f"{command} |")
            for command in commands
        )

    if matches(DDL_COMMANDS):
        return "ddl"
    if matches(DML_COMMANDS):
        return "dml"
    if matches(DCL_COMMANDS):
        return "dcl"
    if matches(TCL_COMMANDS):
        return "tcl"
    return "utility"


def write_atomic(path: Path, data: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        "wb", dir=path.parent, prefix=f".{path.name}.", delete=False
    ) as target:
        target.write(data)
        temporary_path = Path(target.name)
    os.replace(temporary_path, path)


def protect_existing_catalog(
    catalog_path: Path, new_catalog: Dict[str, Any], *, replace: bool
) -> None:
    """Prevent a later partial extraction from silently shrinking the source catalog."""
    if replace or not catalog_path.is_file():
        return
    try:
        existing = json.loads(catalog_path.read_text(encoding="utf-8"))
    except (OSError, UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise PdfExtractionError(
            f"existing catalog cannot be validated; use --replace-catalog only after review: {exc}"
        ) from exc
    identity_fields = (
        "document_id",
        "parent_pdf_sha256",
        "extraction_rule_version",
    )
    same_identity = all(existing.get(field) == new_catalog.get(field) for field in identity_fields)
    old_paths = {
        chapter.get("source_relpath")
        for chapter in existing.get("chapters", [])
        if isinstance(chapter, dict)
    }
    new_paths = {
        chapter.get("source_relpath")
        for chapter in new_catalog.get("chapters", [])
        if isinstance(chapter, dict)
    }
    if same_identity and old_paths == new_paths:
        return
    raise PdfExtractionError(
        "existing catalog identity or extraction scope would change; "
        "review the change and rerun with --replace-catalog"
    )


def build_catalog(
    *,
    pdf_path: Path,
    output_root: Path,
    catalog_name: str,
    document_id: str,
    product_version: str,
    document_version: str,
    extraction_rule_version: str,
    variant: str,
    section_numbers: Sequence[str],
    all_statement_variants: Sequence[str] = (),
    category_by_section: Optional[Dict[str, str]] = None,
    pdftotext_binary: Optional[str] = None,
    replace_catalog: bool = False,
) -> Tuple[Path, Dict[str, Any]]:
    pdf_path = pdf_path.resolve()
    output_root = output_root.resolve()
    if not pdf_path.is_file():
        raise PdfExtractionError(f"PDF does not exist: {pdf_path}")

    reader = load_pypdf_reader(pdf_path)
    cover_identity = parse_cover_identity(reader.pages[0].extract_text() or "")
    if product_version != cover_identity["product_version"]:
        raise PdfExtractionError(
            f"--product-version={product_version!r} 与PDF封面"
            f"{cover_identity['product_version']!r} 不一致"
        )
    if document_version != cover_identity["document_version"]:
        raise PdfExtractionError(
            f"--document-version={document_version!r} 与PDF封面"
            f"{cover_identity['document_version']!r} 不一致"
        )
    page_count = len(reader.pages)
    page_labels = [str(label) for label in reader.page_labels]
    if len(page_labels) != page_count:
        page_labels = [str(number) for number in range(1, page_count + 1)]
    page_widths = [float(page.mediabox.width) for page in reader.pages]
    page_heights = [float(page.mediabox.height) for page in reader.pages]

    outline = flatten_outline(reader, page_labels, page_heights)
    outline = assign_end_destinations(
        outline,
        page_count=page_count,
        page_labels=page_labels,
        page_heights=page_heights,
    )
    if all_statement_variants:
        if section_numbers:
            raise PdfExtractionError(
                "all_statement_variants and explicit section_numbers are mutually exclusive"
            )
        selected = select_statement_bookmarks(
            outline,
            variants=all_statement_variants,
        )
    else:
        selected = select_bookmarks(
            outline,
            variant=variant,
            section_numbers=section_numbers,
        )
    extractor = PopplerPageExtractor(
        pdf_path,
        page_widths,
        page_heights,
        binary=pdftotext_binary,
    )

    chapter_records: List[Dict[str, Any]] = []
    seen_relpaths = set()
    for bookmark in selected:
        category = (category_by_section or {}).get(
            bookmark.section_number or "",
            infer_category(bookmark),
        )
        source_relpath = source_relpath_for(bookmark, category)
        if source_relpath in seen_relpaths:
            raise PdfExtractionError(f"duplicate source_relpath: {source_relpath}")
        seen_relpaths.add(source_relpath)
        chapter_text = extract_chapter_text(
            bookmark,
            extractor,
            page_labels=page_labels,
        )
        write_atomic(output_root / source_relpath, chapter_text.encode("utf-8"))
        chapter_records.append(
            chapter_record(
                bookmark,
                category=category,
                source_relpath=source_relpath,
                chapter_text=chapter_text,
            )
        )

    route_counts = Counter(classify_outline(bookmark) for bookmark in outline)
    catalog = {
        "schema_version": SCHEMA_VERSION,
        "document_id": document_id,
        "parent_pdf_path": Path(os.path.relpath(pdf_path, output_root)).as_posix(),
        "parent_pdf_sha256": sha256_file(pdf_path),
        "product_version": product_version,
        "document_version": document_version,
        "release_date": cover_identity["release_date"],
        "extraction_rule_version": extraction_rule_version,
        "parent_pdf_metadata": document_metadata(reader, page_widths, page_heights),
        "extraction_rules": {
            "coordinate_system": "PDF points measured from page top",
            "bookmark_boundary": "start inclusive, end exclusive",
            "content_top_pt": CONTENT_TOP_PT,
            "content_bottom_pt": CONTENT_BOTTOM_PT,
            "page_marker_template": PAGE_MARKER_TEMPLATE,
            "text_extractor": "pdftotext -r 72 -layout -enc UTF-8 -eol unix",
        },
        "scope_summary": {
            "outline_entry_count": len(outline),
            "general_sql_statement_count": route_counts["general_sql_statement"],
            "m_compat_sql_statement_count": route_counts["m_compat_sql_statement"],
            "content_route_counts": dict(sorted(route_counts.items())),
        },
        "outline": [bookmark_record(bookmark) for bookmark in outline],
        "chapters": chapter_records,
    }
    catalog_path = output_root / catalog_name
    protect_existing_catalog(catalog_path, catalog, replace=replace_catalog)
    write_atomic(catalog_path, canonical_json_bytes(catalog))
    return catalog_path, catalog


def parse_args(argv: Optional[Sequence[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Deterministically inventory and slice GaussDB PDF bookmarks."
    )
    parser.add_argument("--pdf", type=Path, default=DEFAULT_PDF_PATH)
    parser.add_argument("--output-root", type=Path, default=DEFAULT_OUTPUT_ROOT)
    parser.add_argument("--catalog-name", default=DEFAULT_CATALOG_NAME)
    parser.add_argument("--document-id", default="gaussdb_v2_0_10_0_0_centralized_reference_01")
    parser.add_argument("--product-version", default="V2.0-10.0.0")
    parser.add_argument("--document-version", default="01")
    parser.add_argument("--extraction-rule-version", default=EXTRACTION_RULE_VERSION)
    parser.add_argument("--variant", choices=("general", "m_compat"), default="general")
    parser.add_argument(
        "--section",
        action="append",
        dest="sections",
        help="Exact outline section number; repeat to extract multiple sections.",
    )
    parser.add_argument(
        "--all-general-statements",
        action="store_true",
        help="Extract all top-level general SQL statement bookmarks.",
    )
    parser.add_argument(
        "--all-sql-statements",
        action="store_true",
        help="Extract all top-level general and M-Compatibility SQL statements.",
    )
    parser.add_argument("--pdftotext", dest="pdftotext_binary")
    parser.add_argument(
        "--replace-catalog",
        action="store_true",
        help="Explicitly replace an existing catalog when identity or extraction scope changes.",
    )
    return parser.parse_args(argv)


def main(argv: Optional[Sequence[str]] = None) -> int:
    args = parse_args(argv)
    bulk_flags = int(args.all_general_statements) + int(args.all_sql_statements)
    if bulk_flags and args.sections:
        raise PdfExtractionError(
            "--section cannot be combined with --all-general-statements or --all-sql-statements"
        )
    if bulk_flags > 1:
        raise PdfExtractionError(
            "--all-general-statements and --all-sql-statements are mutually exclusive"
        )
    all_statement_variants: Sequence[str] = ()
    if args.all_sql_statements:
        section_numbers = []
        category_by_section = {}
        all_statement_variants = ("general", "m_compat")
    elif args.all_general_statements:
        section_numbers = []
        category_by_section = {}
        all_statement_variants = ("general",)
    elif args.sections:
        section_numbers = args.sections
        category_by_section: Dict[str, str] = {}
    elif args.variant == "general":
        section_numbers = [number for number, _ in DEFAULT_GENERAL_SECTIONS]
        category_by_section = dict(DEFAULT_GENERAL_SECTIONS)
    else:
        raise PdfExtractionError(
            "--variant m_compat requires one or more explicit --section values"
        )

    catalog_path, catalog = build_catalog(
        pdf_path=args.pdf,
        output_root=args.output_root,
        catalog_name=args.catalog_name,
        document_id=args.document_id,
        product_version=args.product_version,
        document_version=args.document_version,
        extraction_rule_version=args.extraction_rule_version,
        variant=args.variant,
        section_numbers=section_numbers,
        all_statement_variants=all_statement_variants,
        category_by_section=category_by_section,
        pdftotext_binary=args.pdftotext_binary,
        replace_catalog=args.replace_catalog,
    )
    print(
        json.dumps(
            {
                "catalog_path": str(catalog_path),
                "parent_pdf_sha256": catalog["parent_pdf_sha256"],
                "outline_count": len(catalog["outline"]),
                "chapter_count": len(catalog["chapters"]),
            },
            ensure_ascii=False,
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except PdfExtractionError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
