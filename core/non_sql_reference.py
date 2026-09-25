"""Strict schema for the existing non-SQL compatibility reference facts.

This is a registry schema, not a claim that every fact has a downstream
generator consumer or runtime oracle.  It makes the current 67 YAML files
typed, categorized, hash-bound, and auditable.
"""
from __future__ import annotations

import hashlib
import re
from collections import Counter
from pathlib import Path
from typing import Any, Dict, List, Literal, Optional

import yaml
from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator


class NonSqlReferenceLoadError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__("Non-SQL reference 加载失败:\n" + "\n".join(f"- {item}" for item in errors))


class StrictNonSqlReferenceModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class NonSqlFactDef(StrictNonSqlReferenceModel):
    id: str
    type: str
    statement: str
    status: Literal["confirmed", "needs_verification"]
    source_anchor: str
    verification_method: Optional[str] = None
    properties: Dict[str, Any] = Field(default_factory=dict)

    @field_validator("id", "type", "statement", "source_anchor")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("non-SQL fact field cannot be blank")
        return normalized


class NonSqlSourceDef(StrictNonSqlReferenceModel):
    path: str
    document: str
    version: str
    parent_pdf_sha256: str
    extraction_date: str
    extraction_method: str
    verification_status: str
    sha256: str
    category: Literal[
        "stored_procedure",
        "compatibility",
        "runtime_parameters",
        "tool_reference",
        "log_reference",
        "system_catalog",
        "schema",
        "report",
    ]
    facts: List[NonSqlFactDef]
    fact_count: int

    @field_validator("parent_pdf_sha256", "sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if not re.fullmatch(r"[0-9a-f]{64}", value):
            raise ValueError("SHA-256 must be 64 hexadecimal characters")
        return value

    @model_validator(mode="after")
    def ensure_count(self) -> "NonSqlSourceDef":
        if self.fact_count != len(self.facts):
            raise ValueError("fact_count does not match facts")
        return self


class NonSqlReferenceSummaryDef(StrictNonSqlReferenceModel):
    source_file_count: int
    fact_count: int
    fact_status_counts: Dict[str, int]
    fact_type_counts: Dict[str, int]
    category_counts: Dict[str, int]
    category_fact_counts: Dict[str, int]
    duplicate_bare_fact_id_count: int
    unresolved_fact_ids: List[str]


class NonSqlReferenceInventoryDef(StrictNonSqlReferenceModel):
    schema_version: Literal[1]
    kind: Literal["non_sql_reference_inventory"]
    id: str = "non_sql_reference_inventory_v1"
    name: str = "GaussDB Non-SQL Reference Facts V1"
    description: str = "67个非SQL参考事实文件的类型化清单；不推断生成器消费或数据库行为。"
    parent_pdf_sha256: str
    sources: List[NonSqlSourceDef]
    summary: NonSqlReferenceSummaryDef
    limits: List[str] = Field(default_factory=lambda: [
        "A confirmed fact is a source-review result, not runtime evidence.",
        "This inventory does not imply generator consumption or schema completeness.",
        "Bare fact IDs may repeat across files; use file::fact_id for global identity.",
    ])


def _sha256_bytes(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()


def _category(document: str) -> str:
    normalized = document.replace("集中式版参考 /", "").strip()
    if normalized.startswith("3 "):
        return "stored_procedure"
    if normalized.startswith("4 "):
        return "compatibility"
    if normalized.startswith("5 "):
        return "tool_reference"
    if normalized.startswith("6 "):
        return "log_reference"
    if normalized.startswith("7 "):
        return "runtime_parameters"
    if normalized.startswith("8 ") or normalized.startswith("9 "):
        return "system_catalog"
    if normalized.startswith("10 ") or normalized.startswith("11 "):
        return "schema"
    if normalized.startswith("12 ") or normalized.startswith("13 "):
        return "report"
    return "compatibility"


class NonSqlReferenceRegistry:
    """Strict loader and auditor for docs/compat_facts/*.yaml."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.inventory: Optional[NonSqlReferenceInventoryDef] = None

    def load_all(self) -> NonSqlReferenceInventoryDef:
        errors: List[str] = []
        sources: List[NonSqlSourceDef] = []
        paths = sorted((self.root / "docs/compat_facts").glob("*.yaml"))
        if not paths:
            raise NonSqlReferenceLoadError(["no non-SQL reference YAML files found"])

        for path in paths:
            try:
                raw = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
                raw_facts = raw.get("facts", [])
                if not isinstance(raw_facts, list):
                    raise ValueError("facts must be a list")
                fact_fields = {
                    "id", "type", "statement", "status", "source_anchor", "verification_method"
                }
                normalized_facts = []
                for raw_fact in raw_facts:
                    if not isinstance(raw_fact, dict):
                        raise ValueError("each fact must be an object")
                    normalized_fact = {
                        key: value for key, value in raw_fact.items() if key in fact_fields
                    }
                    normalized_fact["properties"] = {
                        key: value for key, value in raw_fact.items() if key not in fact_fields
                    }
                    normalized_facts.append(normalized_fact)
                raw_facts = normalized_facts
                payload = {
                    "path": path.relative_to(self.root).as_posix(),
                    "document": str(raw.get("document", "")),
                    "version": str(raw.get("version", "")),
                    "parent_pdf_sha256": str(raw.get("parent_pdf_sha256", "")),
                    "extraction_date": str(raw.get("extraction_date", "")),
                    "extraction_method": str(raw.get("extraction_method", "")),
                    "verification_status": str(raw.get("verification_status", "")),
                    "sha256": _sha256_bytes(path.read_bytes()),
                    "category": _category(str(raw.get("document", ""))),
                    "facts": raw_facts,
                    "fact_count": len(raw_facts),
                }
                sources.append(NonSqlSourceDef(**payload))
            except (OSError, yaml.YAMLError, ValidationError, ValueError, TypeError) as exc:
                errors.append(f"{path}: {exc}")

        if errors:
            raise NonSqlReferenceLoadError(errors)

        fact_status_counts = Counter(fact.status for source in sources for fact in source.facts)
        fact_type_counts = Counter(fact.type for source in sources for fact in source.facts)
        category_counts = Counter(source.category for source in sources)
        category_fact_counts = Counter()
        for source in sources:
            category_fact_counts[source.category] += len(source.facts)
        bare_ids = [fact.id for source in sources for fact in source.facts]
        unresolved = [
            f"{source.path}::{fact.id}"
            for source in sources for fact in source.facts
            if fact.status != "confirmed"
        ]
        parent_hashes = {source.parent_pdf_sha256 for source in sources}
        if len(parent_hashes) != 1:
            raise NonSqlReferenceLoadError([
                f"parent_pdf_sha256 mismatch: {sorted(parent_hashes)}"
            ])

        summary = NonSqlReferenceSummaryDef(
            source_file_count=len(sources),
            fact_count=sum(len(source.facts) for source in sources),
            fact_status_counts=dict(sorted(fact_status_counts.items())),
            fact_type_counts=dict(sorted(fact_type_counts.items())),
            category_counts=dict(sorted(category_counts.items())),
            category_fact_counts=dict(sorted(category_fact_counts.items())),
            duplicate_bare_fact_id_count=len(bare_ids) - len(set(bare_ids)),
            unresolved_fact_ids=sorted(unresolved),
        )
        self.inventory = NonSqlReferenceInventoryDef(
            schema_version=1,
            kind="non_sql_reference_inventory",
            parent_pdf_sha256=parent_hashes.pop(),
            sources=sources,
            summary=summary,
        )
        return self.inventory
