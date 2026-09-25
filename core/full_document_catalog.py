"""Build and audit the authoritative full-document catalog.

The source catalogs are extraction batches, not competing authorities.  This
module merges their chapter payloads while preserving per-catalog provenance.
The resulting catalog records the full PDF outline, all unique extracted
chapters, and the front-matter boundary that is outside the content denominator.
"""
from __future__ import annotations

import hashlib
import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Sequence, Tuple


ROOT_IDENTITY_FIELDS = (
    "schema_version",
    "document_id",
    "document_version",
    "parent_pdf_sha256",
    "product_version",
    "release_date",
)
CHAPTER_IDENTITY_FIELDS = (
    "variant",
    "category",
    "section_number",
    "title",
    "outline_path",
    "start_destination",
    "end_destination",
    "physical_page_start",
    "physical_page_end",
    "printed_page_start",
    "printed_page_end",
    "source_relpath",
    "content_route",
    "chapter_sha256",
)
SHA256_RE = re.compile(r"[0-9a-f]{64}")


class FullDocumentCatalogError(ValueError):
    """Deterministic merge/audit failure with all collected errors."""


def _sha256_bytes(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()


def _sha256_value(value: Any) -> str:
    canonical = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return _sha256_bytes(canonical)


def _relative(path: Path, root: Path) -> str:
    return path.resolve().relative_to(root.resolve()).as_posix()


def _load_json(path: Path) -> Dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise FullDocumentCatalogError(f"cannot read catalog {path}: {exc}") from exc
    if not isinstance(value, dict):
        raise FullDocumentCatalogError(f"catalog must be an object: {path}")
    return value


def discover_source_catalogs(root: Path, output: Optional[Path] = None) -> List[Path]:
    root = root.resolve()
    output = output.resolve() if output is not None else None
    paths = []
    for path in root.rglob("catalog.json"):
        if ".git" in path.parts or (output is not None and path.resolve() == output):
            continue
        paths.append(path)
    return sorted(paths, key=lambda item: _relative(item, root))


def _validate_source_catalogs(
    catalogs: Sequence[Tuple[Path, Dict[str, Any]]],
    root: Path,
) -> Tuple[Dict[str, Any], str, str]:
    errors: List[str] = []
    if not catalogs:
        raise FullDocumentCatalogError("no source catalogs found")

    first_path, first = catalogs[0]
    identity: Dict[str, Any] = {key: first.get(key) for key in ROOT_IDENTITY_FIELDS}
    outline_hash = _sha256_value(first.get("outline", []))
    extraction_rules_hash = _sha256_value(first.get("extraction_rules", []))
    parent_metadata_hash = _sha256_value(first.get("parent_pdf_metadata", {}))

    for path, catalog in catalogs:
        rel = _relative(path, root)
        for key, expected in identity.items():
            if catalog.get(key) != expected:
                errors.append(f"{rel}: {key} mismatch: {catalog.get(key)!r} != {expected!r}")
        if _sha256_value(catalog.get("outline", [])) != outline_hash:
            errors.append(f"{rel}: outline differs from the canonical full outline")
        if _sha256_value(catalog.get("extraction_rules", [])) != extraction_rules_hash:
            errors.append(f"{rel}: extraction_rules differ")
        if _sha256_value(catalog.get("parent_pdf_metadata", {})) != parent_metadata_hash:
            errors.append(f"{rel}: parent_pdf_metadata differs")
        if not isinstance(catalog.get("chapters"), list):
            errors.append(f"{rel}: chapters must be a list")
        if not isinstance(catalog.get("outline"), list):
            errors.append(f"{rel}: outline must be a list")
    if errors:
        raise FullDocumentCatalogError("\n".join(errors))
    return first, outline_hash, extraction_rules_hash


def _chapter_key(chapter: Dict[str, Any]) -> Tuple[str, Tuple[str, ...]]:
    variant = chapter.get("variant")
    outline_path = chapter.get("outline_path")
    if not isinstance(variant, str) or not isinstance(outline_path, list) or not all(isinstance(item, str) for item in outline_path):
        raise FullDocumentCatalogError(f"invalid chapter identity: {chapter!r}")
    return variant, tuple(outline_path)


def _merge_chapters(
    catalogs: Sequence[Tuple[Path, Dict[str, Any]]],
    root: Path,
) -> List[Dict[str, Any]]:
    merged: Dict[Tuple[str, Tuple[str, ...]], Dict[str, Any]] = {}
    references: Dict[Tuple[str, Tuple[str, ...]], List[str]] = defaultdict(list)
    errors: List[str] = []

    for path, catalog in catalogs:
        catalog_ref = _relative(path, root)
        for index, raw in enumerate(catalog.get("chapters", [])):
            if not isinstance(raw, dict):
                errors.append(f"{catalog_ref}: chapter {index} is not an object")
                continue
            missing = [field for field in CHAPTER_IDENTITY_FIELDS if field not in raw]
            if missing:
                errors.append(f"{catalog_ref}: chapter {index} missing fields: {missing}")
                continue
            key = _chapter_key(raw)
            if key in merged:
                for field in CHAPTER_IDENTITY_FIELDS:
                    if merged[key].get(field) != raw.get(field):
                        errors.append(
                            f"{catalog_ref}: chapter conflict for {key}: {field} "
                            f"{raw.get(field)!r} != {merged[key].get(field)!r}"
                        )
            else:
                chapter = {field: raw[field] for field in CHAPTER_IDENTITY_FIELDS}
                merged[key] = chapter
            references[key].append(catalog_ref)

    if errors:
        raise FullDocumentCatalogError("\n".join(errors))

    chapters: List[Dict[str, Any]] = []
    for key, chapter in merged.items():
        chapter["source_catalog_refs"] = sorted(set(references[key]))
        chapters.append(chapter)

    chapters.sort(key=lambda item: (
        int(item["physical_page_start"]),
        int(item["physical_page_end"]),
        item["variant"],
        item["source_relpath"],
        tuple(item["outline_path"]),
    ))
    return chapters


def _front_matter(chapters: Sequence[Dict[str, Any]], page_count: int) -> Dict[str, Any]:
    if not chapters:
        raise FullDocumentCatalogError("cannot infer front matter without chapters")
    first_page = int(chapters[0]["physical_page_start"])
    if first_page < 1:
        raise FullDocumentCatalogError("first content chapter must start at page 1 or later")
    return {
        "physical_page_start": 1,
        "physical_page_end": first_page - 1,
        "page_count": first_page - 1,
        "content_route": "front_matter",
        "status": "explicitly_ignored",
        "reason": "封面、版权、目录与前言不进入正文抽取分母。",
    }


def _scope_summary(
    outline: Sequence[Dict[str, Any]],
    chapters: Sequence[Dict[str, Any]],
    front_matter: Dict[str, Any],
) -> Dict[str, Any]:
    route_counts = Counter(str(item.get("content_route", "unknown")) for item in chapters)
    variant_counts = Counter(str(item.get("variant", "unknown")) for item in chapters)
    return {
        "outline_entry_count": len(outline),
        "chapter_count": len(chapters),
        "front_matter_page_count": front_matter["page_count"],
        "content_page_start": int(chapters[0]["physical_page_start"]),
        "content_page_end": int(chapters[-1]["physical_page_end"]),
        "chapter_content_route_counts": dict(sorted(route_counts.items())),
        "chapter_variant_counts": dict(sorted(variant_counts.items())),
    }


def build_full_document_catalog(
    root: Path,
    output: Path,
    *,
    source_catalogs: Optional[Iterable[Path]] = None,
) -> Dict[str, Any]:
    root = root.resolve()
    output = output.resolve()
    if output.exists():
        raise FullDocumentCatalogError(f"output already exists: {output}")

    paths = (
        [path.resolve() for path in source_catalogs]
        if source_catalogs is not None
        else discover_source_catalogs(root, output)
    )
    catalogs = [(path, _load_json(path)) for path in paths]
    canonical, outline_hash, extraction_rules_hash = _validate_source_catalogs(catalogs, root)
    chapters = _merge_chapters(catalogs, root)
    page_count = int((canonical.get("parent_pdf_metadata") or {}).get("page_count", 0))
    if page_count < 1:
        raise FullDocumentCatalogError("parent_pdf_metadata.page_count must be positive")
    front_matter = _front_matter(chapters, page_count)

    source_hashes: Dict[str, str] = {}
    extraction_rule_versions: set[str] = set()
    for path, catalog in catalogs:
        source_hashes[_relative(path, root)] = _sha256_bytes(path.read_bytes())
        extraction_rule_versions.add(str(catalog.get("extraction_rule_version", "")))

    document_id = str(canonical["document_id"])
    result: Dict[str, Any] = {
        "schema_version": 1,
        "kind": "full_document_catalog",
        "id": f"full_document_catalog_{document_id}",
        "document_id": document_id,
        "document_version": canonical["document_version"],
        "product_version": canonical["product_version"],
        "release_date": canonical["release_date"],
        "parent_pdf_path": "gaussdb-rf-cent.pdf",
        "parent_pdf_sha256": canonical["parent_pdf_sha256"],
        "parent_pdf_metadata": canonical.get("parent_pdf_metadata", {}),
        "outline": canonical.get("outline", []),
        "outline_sha256": outline_hash,
        "extraction_rules": canonical.get("extraction_rules", []),
        "extraction_rules_sha256": extraction_rules_hash,
        "extraction_rule_versions": sorted(extraction_rule_versions),
        "front_matter": front_matter,
        "chapters": chapters,
        "source_catalog_count": len(catalogs),
        "source_catalog_sha256": dict(sorted(source_hashes.items())),
        "scope_summary": _scope_summary(canonical.get("outline", []), chapters, front_matter),
    }

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return result


def _merge_page_intervals(chapters: Sequence[Dict[str, Any]]) -> List[List[int]]:
    intervals: List[Tuple[int, int]] = []
    for chapter in chapters:
        try:
            start, end = int(chapter["physical_page_start"]), int(chapter["physical_page_end"])
        except (KeyError, TypeError, ValueError) as exc:
            raise FullDocumentCatalogError(f"invalid page interval: {chapter!r}") from exc
        if start < 1 or end < start:
            raise FullDocumentCatalogError(f"invalid page interval: {chapter!r}")
        intervals.append((start, end))
    intervals.sort()
    merged: List[List[int]] = []
    for start, end in intervals:
        if not merged or start > merged[-1][1] + 1:
            merged.append([start, end])
        else:
            merged[-1][1] = max(merged[-1][1], end)
    return merged


def _top_level_page_summary(chapters: Sequence[Dict[str, Any]]) -> List[Dict[str, Any]]:
    groups: Dict[str, List[Dict[str, Any]]] = defaultdict(list)
    for chapter in chapters:
        outline_path = chapter.get("outline_path")
        top_level = outline_path[0] if isinstance(outline_path, list) and outline_path else "unknown"
        groups[top_level].append(chapter)
    rows = []
    for top_level, items in sorted(groups.items()):
        intervals = _merge_page_intervals(items)
        pages = sum(end - start + 1 for start, end in intervals)
        rows.append({
            "title": top_level,
            "chapter_count": len(items),
            "covered_pages": pages,
            "intervals": [{"start": start, "end": end} for start, end in intervals],
        })
    return rows


def audit_full_document_catalog(
    catalog_path: Path,
    *,
    verify_sources: bool = False,
    root: Optional[Path] = None,
) -> Dict[str, Any]:
    catalog_path = catalog_path.resolve()
    root = root.resolve() if root is not None else catalog_path.parents[1]
    catalog = _load_json(catalog_path)
    errors: List[str] = []
    warnings: List[str] = []

    if catalog.get("kind") != "full_document_catalog":
        errors.append("kind must be full_document_catalog")
    if catalog.get("schema_version") != 1:
        errors.append("schema_version must be 1")
    if not SHA256_RE.fullmatch(str(catalog.get("parent_pdf_sha256", ""))):
        errors.append("parent_pdf_sha256 must be a 64-character hexadecimal digest")

    pdf_path = root / str(catalog.get("parent_pdf_path", "gaussdb-rf-cent.pdf"))
    if pdf_path.is_file():
        actual_pdf_hash = _sha256_bytes(pdf_path.read_bytes())
        if actual_pdf_hash != catalog.get("parent_pdf_sha256"):
            errors.append("parent PDF hash drift")
    else:
        warnings.append("parent PDF not found; structural audit only")

    page_count = int((catalog.get("parent_pdf_metadata") or {}).get("page_count", 0))
    if page_count < 1:
        errors.append("parent_pdf_metadata.page_count must be positive")

    outline = catalog.get("outline", [])
    chapters = catalog.get("chapters", [])
    if not isinstance(outline, list) or not isinstance(chapters, list):
        errors.append("outline and chapters must be lists")
        outline, chapters = [], []

    outline_keys = [_chapter_key(item) for item in outline if isinstance(item, dict)]
    if len(outline_keys) != len(set(outline_keys)):
        errors.append("outline variant/path identities must be unique")
    chapter_keys = [_chapter_key(chapter) for chapter in chapters if isinstance(chapter, dict)]
    if len(chapter_keys) != len(set(chapter_keys)):
        errors.append("merged chapter outline identities must be unique")
    outline_key_set = set(outline_keys)
    for chapter, key in zip(chapters, chapter_keys):
        if key not in outline_key_set:
            errors.append(f"chapter outline identity is absent from outline: {key}")
        if not SHA256_RE.fullmatch(str(chapter.get("chapter_sha256", ""))):
            errors.append(f"chapter hash invalid: {key}")

    front = catalog.get("front_matter", {})
    if not isinstance(front, dict):
        errors.append("front_matter must be an object")
        front = {}
    if chapters:
        first_page = int(chapters[0]["physical_page_start"])
        if front.get("physical_page_start") != 1 or front.get("physical_page_end") != first_page - 1:
            errors.append("front_matter must cover pages 1 through the page before the first chapter")

    intervals = _merge_page_intervals(chapters) if chapters else []
    covered = sum(end - start + 1 for start, end in intervals)
    front_pages = int(front.get("page_count", 0))
    missing_ranges: List[Dict[str, int]] = []
    if page_count and chapters:
        expected_start = int(chapters[0]["physical_page_start"])
        expected_end = page_count
        current = expected_start
        for start, end in intervals:
            if start > current:
                missing_ranges.append({"start": current, "end": start - 1})
            current = max(current, end + 1)
        if current <= expected_end:
            missing_ranges.append({"start": current, "end": expected_end})
        if front_pages + covered != page_count:
            errors.append(
                f"page accounting mismatch: front={front_pages}, covered={covered}, total={page_count}"
            )

    source_catalog_count = int(catalog.get("source_catalog_count", 0))
    source_hashes = catalog.get("source_catalog_sha256", {})
    if not isinstance(source_hashes, dict) or len(source_hashes) != source_catalog_count:
        errors.append("source_catalog_sha256 count mismatch")
    for chapter in chapters:
        refs = chapter.get("source_catalog_refs", [])
        if not isinstance(refs, list) or not refs:
            errors.append(f"chapter has no source_catalog_refs: {_chapter_key(chapter)}")

    if verify_sources:
        verified_sources = 0
        for chapter in chapters:
            source_found = False
            for ref in chapter.get("source_catalog_refs", []):
                source_catalog = root / str(ref)
                if not source_catalog.is_file():
                    continue
                source_path = source_catalog.parent / str(chapter.get("source_relpath", ""))
                if not source_path.is_file():
                    continue
                if _sha256_bytes(source_path.read_bytes()) != chapter.get("chapter_sha256"):
                    errors.append(f"source hash drift: {_chapter_key(chapter)} at {source_path}")
                    source_found = True
                    break
                source_found = True
                verified_sources += 1
                break
            if not source_found:
                errors.append(f"no verifiable source file: {_chapter_key(chapter)}")
        if verified_sources != len(chapters):
            errors.append(f"source verification count mismatch: {verified_sources} != {len(chapters)}")

    summary = {
        "total_pages": page_count,
        "front_matter_pages": front_pages,
        "covered_content_pages": covered,
        "missing_content_pages": sum(end - start + 1 for start, end in (item.values() for item in missing_ranges)),
        "coverage_ratio": (front_pages + covered) / page_count if page_count else 0,
        "chapter_count": len(chapters),
        "outline_entry_count": len(outline),
        "source_catalog_count": source_catalog_count,
    }
    return {
        "schema_version": 1,
        "kind": "full_document_catalog_coverage",
        "catalog_path": _relative(catalog_path, root),
        "catalog_sha256": _sha256_bytes(catalog_path.read_bytes()),
        "parent_pdf_sha256": catalog.get("parent_pdf_sha256"),
        "valid": not errors,
        "source_verified": verify_sources,
        "errors": errors,
        "warnings": warnings,
        "summary": summary,
        "covered_intervals": [{"start": start, "end": end} for start, end in intervals],
        "missing_ranges": missing_ranges,
        "by_top_level": _top_level_page_summary(chapters),
    }
