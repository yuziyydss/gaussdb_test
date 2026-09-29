"""Strict GUC reference schema built from the authoritative book catalog.

Schema V2 is deliberately a reference catalog, not an execution policy.  It
extracts every parameter definition from chapter 7.3, preserves duplicate
occurrences, and links the existing V1 pilot without silently widening that
pilot's safety rules.
"""
from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path
from typing import Dict, Iterable, List, Literal, Optional, Sequence, Tuple

import yaml
from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

from core.guc_environment import GucEnvironmentLoadError, GucEnvironmentRegistry


GUC_PARAMETER_NAME_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_.]*")
GUC_ID_RE = re.compile(r"guc_[A-Za-z0-9_.]+")
SHA256_RE = re.compile(r"[0-9a-f]{64}")
SECTION_HEADING_RE = re.compile(r"^7\.3(?:\.\d+)+\s+(.+)$")
PDF_PAGE_RE = re.compile(r"^\[\[PDF_PAGE physical=(\d+) printed=([^\]]+)\]\]$")
CONTEXT_TYPES = ("INTERNAL", "USERSET", "SUSET", "SIGHUP", "POSTMASTER")
CONTEXT_TYPE_SET = set(CONTEXT_TYPES)
FIELD_LABELS = (
    "参数说明",
    "参数类型",
    "参数单位",
    "取值范围",
    "默认值",
    "设置方式",
    "设置建议",
    "设置不当的风险与影响",
)
FIELD_KEYS = {
    "参数说明": "description",
    "参数类型": "parameter_type",
    "参数单位": "parameter_unit",
    "取值范围": "value_domain",
    "默认值": "default_value",
    "设置方式": "setting_method",
    "设置建议": "recommendation",
    "设置不当的风险与影响": "risk_impact",
}


class GucReferenceError(ValueError):
    """Raised when the authoritative GUC source cannot be parsed safely."""


class GucReferenceLoadError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__("GUC reference 加载失败:\n" + "\n".join(f"- {item}" for item in errors))


class StrictGucReferenceModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucChapterSourceDef(StrictGucReferenceModel):
    catalog_relpath: str
    catalog_sha256: str
    document_id: str
    document_version: str
    product_version: str
    release_date: str
    section_number: str
    title: str
    outline_path: List[str]
    catalog_source_relpath: str
    source_relpath: str
    source_sha256: str
    chapter_sha256: str
    physical_page_start: int
    physical_page_end: int
    source_catalog_refs: List[str]

    @field_validator(
        "catalog_relpath", "catalog_source_relpath", "source_relpath", "document_id", "document_version",
        "product_version", "release_date", "section_number", "title",
    )
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC source field cannot be blank")
        return normalized

    @field_validator("catalog_relpath", "source_relpath")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("GUC source path must be a safe relative path")
        return value

    @field_validator("catalog_sha256", "source_sha256", "chapter_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if SHA256_RE.fullmatch(value) is None:
            raise ValueError("SHA-256 must be 64 hexadecimal characters")
        return value

    @model_validator(mode="after")
    def ensure_page_interval(self) -> "GucChapterSourceDef":
        if self.physical_page_start < 1 or self.physical_page_end < self.physical_page_start:
            raise ValueError("GUC source page interval is invalid")
        if not self.outline_path or not self.source_catalog_refs:
            raise ValueError("GUC source outline and catalog refs cannot be empty")
        return self


class GucParameterOccurrenceDef(StrictGucReferenceModel):
    id: str
    name: str
    section_number: str
    section_title: str
    section_path: List[str]
    source_anchor: str
    physical_pages: List[int]
    description: str
    parameter_type: str
    parameter_unit: str
    value_domain: str
    default_value: str
    setting_method: str
    recommendation: str
    risk_impact: str
    context_types: List[Literal["INTERNAL", "USERSET", "SUSET", "SIGHUP", "POSTMASTER"]]
    context_status: Literal["explicit", "conditional", "unspecified"]

    @field_validator("id", "name", "section_number", "section_title", "source_anchor")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC occurrence field cannot be blank")
        return normalized

    @field_validator("name")
    @classmethod
    def ensure_parameter_name(cls, value: str) -> str:
        if GUC_PARAMETER_NAME_RE.fullmatch(value) is None:
            raise ValueError("GUC parameter name is invalid")
        return value

    @field_validator(
        "description", "parameter_type", "parameter_unit", "value_domain",
        "default_value", "setting_method", "recommendation", "risk_impact",
    )
    @classmethod
    def ensure_extracted_field(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC occurrence extracted field cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_occurrence_shape(self) -> "GucParameterOccurrenceDef":
        if not self.id.startswith(f"guc_{self.name}@"):
            raise ValueError("GUC occurrence id must include its parameter identity")
        if not self.section_path or self.section_path[-1] != f"{self.section_number} {self.section_title}":
            raise ValueError("GUC occurrence section path must end with its section")
        if not self.physical_pages or any(page < 1 for page in self.physical_pages):
            raise ValueError("GUC occurrence physical pages are invalid")
        if len(set(self.physical_pages)) != len(self.physical_pages):
            raise ValueError("GUC occurrence physical pages cannot repeat")
        if len(set(self.context_types)) != len(self.context_types):
            raise ValueError("GUC occurrence context types cannot repeat")
        expected_status = (
            "unspecified" if not self.context_types
            else "explicit" if len(self.context_types) == 1
            else "conditional"
        )
        if self.context_status != expected_status:
            raise ValueError("GUC occurrence context status is inconsistent")
        return self


class GucParameterReferenceDef(StrictGucReferenceModel):
    id: str
    name: str
    occurrence_count: int
    reserved: bool
    deprecated: bool
    occurrences: List[GucParameterOccurrenceDef]

    @field_validator("id", "name")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC parameter field cannot be blank")
        return normalized

    @field_validator("id")
    @classmethod
    def ensure_id(cls, value: str) -> str:
        if GUC_ID_RE.fullmatch(value) is None:
            raise ValueError("GUC reference id must be guc_ plus a parameter name")
        return value

    @field_validator("name")
    @classmethod
    def ensure_name(cls, value: str) -> str:
        if GUC_PARAMETER_NAME_RE.fullmatch(value) is None:
            raise ValueError("GUC parameter name is invalid")
        return value

    @model_validator(mode="after")
    def ensure_parameter_shape(self) -> "GucParameterReferenceDef":
        if self.id != f"guc_{self.name}":
            raise ValueError("GUC reference id must equal guc_ plus its parameter name")
        if self.occurrence_count != len(self.occurrences) or not self.occurrences:
            raise ValueError("GUC occurrence_count does not match occurrences")
        if any(item.name != self.name for item in self.occurrences):
            raise ValueError("GUC occurrences must all use the parameter name")
        if len({item.id for item in self.occurrences}) != len(self.occurrences):
            raise ValueError("GUC occurrence ids cannot repeat")
        return self


class GucPilotLinkDef(StrictGucReferenceModel):
    pilot_id: str
    name: str
    reference_id: str
    pilot_schema_version: int
    execution_policy: str
    pilot_context_type: Literal["INTERNAL", "USERSET", "SUSET", "SIGHUP", "POSTMASTER"]
    reference_context_types: List[Literal["INTERNAL", "USERSET", "SUSET", "SIGHUP", "POSTMASTER"]]
    context_matches: bool

    @field_validator("pilot_id", "name", "reference_id", "execution_policy")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC pilot link field cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_link_shape(self) -> "GucPilotLinkDef":
        if len(set(self.reference_context_types)) != len(self.reference_context_types):
            raise ValueError("GUC pilot reference contexts cannot repeat")
        expected_match = self.pilot_context_type in self.reference_context_types
        if self.context_matches != expected_match:
            raise ValueError("GUC pilot context match flag is inconsistent")
        return self


class GucReferenceSummaryDef(StrictGucReferenceModel):
    definition_count: int
    parameter_count: int
    duplicate_name_count: int
    section_count: int
    parameter_type_counts: Dict[str, int]
    context_type_counts: Dict[str, int]
    context_status_counts: Dict[str, int]
    reserved_name_count: int
    deprecated_name_count: int
    reserved_or_deprecated_name_count: int
    defined_reserved_or_deprecated_count: int
    pilot_parameter_count: int
    pilot_context_match_count: int


class GucReferenceCatalogDef(StrictGucReferenceModel):
    schema_version: Literal[2]
    kind: Literal["guc_reference_catalog"]
    id: str = "guc_reference_catalog_v2"
    name: str = "GaussDB GUC Reference Catalog V2"
    description: str = (
        "从权威全书目录解析7.3 GUC参数说明；保留原始定义、重复出现和V1试点链接，不推断执行安全。"
    )
    parent_pdf_sha256: str
    source: GucChapterSourceDef
    parameters: List[GucParameterReferenceDef]
    reserved_parameters: List[str]
    deprecated_parameters: List[str]
    pilot_links: List[GucPilotLinkDef]
    summary: GucReferenceSummaryDef

    @field_validator("parent_pdf_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if SHA256_RE.fullmatch(value) is None:
            raise ValueError("parent_pdf_sha256 must be 64 hexadecimal characters")
        return value

    @model_validator(mode="after")
    def ensure_catalog_shape(self) -> "GucReferenceCatalogDef":
        parameter_ids = [item.id for item in self.parameters]
        parameter_names = [item.name for item in self.parameters]
        occurrence_ids = [item.id for item in self.parameters for item in item.occurrences]
        pilot_ids = [item.pilot_id for item in self.pilot_links]
        pilot_names = [item.name for item in self.pilot_links]
        if len(set(pilot_ids)) != len(pilot_ids):
            raise ValueError("GUC pilot ids cannot repeat")
        if len(set(pilot_names)) != len(pilot_names):
            raise ValueError("GUC pilot names cannot repeat")
        if len(set(pilot_ids)) != len(pilot_ids):
            raise ValueError("GUC reference parameter ids cannot repeat")
        if len(set(parameter_names)) != len(parameter_names):
            raise ValueError("GUC reference parameter names cannot repeat")
        if len(set(occurrence_ids)) != len(occurrence_ids):
            raise ValueError("GUC reference occurrence ids cannot repeat")
        if len(set(self.reserved_parameters)) != len(self.reserved_parameters):
            raise ValueError("GUC reserved parameters cannot repeat")
        if len(set(self.deprecated_parameters)) != len(self.deprecated_parameters):
            raise ValueError("GUC deprecated parameters cannot repeat")
        if set(self.reserved_parameters) & set(self.deprecated_parameters):
            raise ValueError("A GUC parameter cannot be both reserved and deprecated")
        if any(not GUC_PARAMETER_NAME_RE.fullmatch(item) for item in self.reserved_parameters + self.deprecated_parameters):
            raise ValueError("GUC reserved/deprecated parameter names are invalid")

        by_id = {item.id: item for item in self.parameters}
        for link in self.pilot_links:
            if link.reference_id not in by_id or by_id[link.reference_id].name != link.name:
                raise ValueError(f"GUC pilot link is dangling: {link.name}")
            expected_contexts = sorted({
                context
                for occurrence in by_id[link.reference_id].occurrences
                for context in occurrence.context_types
            })
            if link.reference_context_types != expected_contexts:
                raise ValueError(f"GUC pilot reference contexts drifted: {link.name}")

        occurrences = [item for parameter in self.parameters for item in parameter.occurrences]
        parameter_type_counts = dict(sorted(Counter(item.parameter_type for item in occurrences).items()))
        context_counter = Counter(
            context for item in occurrences for context in item.context_types
        )
        context_type_counts = dict(sorted(context_counter.items()))
        context_status_counts = dict(sorted(Counter(item.context_status for item in occurrences).items()))
        duplicate_count = sum(parameter.occurrence_count - 1 for parameter in self.parameters)
        defined_status_names = {
            parameter.name for parameter in self.parameters
            if parameter.reserved or parameter.deprecated
        }
        expected_summary = GucReferenceSummaryDef(
            definition_count=len(occurrences),
            parameter_count=len(self.parameters),
            duplicate_name_count=duplicate_count,
            section_count=len({item.section_number for item in occurrences}),
            parameter_type_counts=parameter_type_counts,
            context_type_counts=context_type_counts,
            context_status_counts=context_status_counts,
            reserved_name_count=len(self.reserved_parameters),
            deprecated_name_count=len(self.deprecated_parameters),
            reserved_or_deprecated_name_count=len(set(self.reserved_parameters) | set(self.deprecated_parameters)),
            defined_reserved_or_deprecated_count=len(defined_status_names),
            pilot_parameter_count=len(self.pilot_links),
            pilot_context_match_count=sum(item.context_matches for item in self.pilot_links),
        )
        if self.summary != expected_summary:
            raise ValueError("GUC reference summary does not match the catalog payload")
        return self


class GucReferenceRegistry:
    """Load the generated V2 catalog or rebuild it from authoritative inputs."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.catalog_path = self.root / "generated/guc_reference_catalog/catalog.json"
        self.full_catalog_path = self.root / "generated/full_document_catalog/catalog.json"

    def load(self) -> GucReferenceCatalogDef:
        try:
            payload = json.loads(self.catalog_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise GucReferenceLoadError([f"{self.catalog_path}: {exc}"]) from exc
        catalog = self.load_payload(payload)
        self._verify_authoritative_catalog(catalog)
        self._verify_pilot_links(catalog)
        return catalog

    def load_payload(self, payload: Dict) -> GucReferenceCatalogDef:
        try:
            return GucReferenceCatalogDef(**payload)
        except ValidationError as exc:
            errors = [f"payload: {item}" for item in exc.errors()]
        except (TypeError, ValueError) as exc:
            errors = [f"payload: {exc}"]
        raise GucReferenceLoadError(errors)

    def build(self) -> GucReferenceCatalogDef:
        full_catalog = self._load_full_catalog()
        chapter = self._find_guc_chapter(full_catalog)
        catalog_source_relpath = str(chapter["source_relpath"])
        source_catalog_refs = list(chapter.get("source_catalog_refs", []))
        if len(source_catalog_refs) != 1:
            raise GucReferenceError(
                f"authoritative 7.3 chapter must have one source catalog ref, got {len(source_catalog_refs)}"
            )
        source_catalog_path = self.root / source_catalog_refs[0]
        source_path = source_catalog_path.parent / catalog_source_relpath
        try:
            source_relpath = str(source_path.resolve().relative_to(self.root.resolve()))
        except ValueError as exc:
            raise GucReferenceError(f"authoritative 7.3 source escapes root: {source_path}") from exc
        try:
            source_bytes = source_path.read_bytes()
        except OSError as exc:
            raise GucReferenceError(f"cannot read authoritative GUC chapter: {source_path}: {exc}") from exc
        source_sha256 = hashlib.sha256(source_bytes).hexdigest()
        if source_sha256 != chapter.get("chapter_sha256"):
            raise GucReferenceError(
                "authoritative GUC chapter hash drift: "
                f"expected {chapter.get('chapter_sha256')}, got {source_sha256}"
            )

        parsed = self._parse_source(source_bytes.decode("utf-8"), source_relpath)
        pilot_environment = self._load_pilot_environment()
        pilot_links = self._build_pilot_links(parsed["parameters"], pilot_environment)

        catalog_sha256 = hashlib.sha256(self.full_catalog_path.read_bytes()).hexdigest()
        source = GucChapterSourceDef(
            catalog_relpath=str(self.full_catalog_path.relative_to(self.root)),
            catalog_sha256=catalog_sha256,
            document_id=str(full_catalog["document_id"]),
            document_version=str(full_catalog["document_version"]),
            product_version=str(full_catalog.get("product_version", "")),
            release_date=str(full_catalog.get("release_date", "")),
            section_number=str(chapter["section_number"]),
            title=str(chapter["title"]),
            outline_path=list(chapter["outline_path"]),
            catalog_source_relpath=catalog_source_relpath,
            source_relpath=source_relpath,
            source_sha256=source_sha256,
            chapter_sha256=str(chapter["chapter_sha256"]),
            physical_page_start=int(chapter["physical_page_start"]),
            physical_page_end=int(chapter["physical_page_end"]),
            source_catalog_refs=list(chapter.get("source_catalog_refs", [])),
        )
        occurrences = [item for parameter in parsed["parameters"] for item in parameter.occurrences]
        parameter_type_counts = dict(sorted(Counter(item.parameter_type for item in occurrences).items()))
        context_counter = Counter(item for occurrence in occurrences for item in occurrence.context_types)
        context_type_counts = dict(sorted(context_counter.items()))
        context_status_counts = dict(sorted(Counter(item.context_status for item in occurrences).items()))
        duplicate_count = sum(parameter.occurrence_count - 1 for parameter in parsed["parameters"])
        defined_status_count = sum(parameter.reserved or parameter.deprecated for parameter in parsed["parameters"])
        summary = GucReferenceSummaryDef(
            definition_count=len(occurrences),
            parameter_count=len(parsed["parameters"]),
            duplicate_name_count=duplicate_count,
            section_count=len({item.section_number for item in occurrences}),
            parameter_type_counts=parameter_type_counts,
            context_type_counts=context_type_counts,
            context_status_counts=context_status_counts,
            reserved_name_count=len(parsed["reserved"]),
            deprecated_name_count=len(parsed["deprecated"]),
            reserved_or_deprecated_name_count=len(set(parsed["reserved"]) | set(parsed["deprecated"])),
            defined_reserved_or_deprecated_count=defined_status_count,
            pilot_parameter_count=len(pilot_links),
            pilot_context_match_count=sum(item.context_matches for item in pilot_links),
        )
        return GucReferenceCatalogDef(
            schema_version=2,
            kind="guc_reference_catalog",
            parent_pdf_sha256=str(full_catalog["parent_pdf_sha256"]),
            source=source,
            parameters=parsed["parameters"],
            reserved_parameters=parsed["reserved"],
            deprecated_parameters=parsed["deprecated"],
            pilot_links=pilot_links,
            summary=summary,
        )

    def write(self, output: Optional[Path] = None) -> Path:
        output = Path(output or self.catalog_path)
        catalog = self.build()
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(
            json.dumps(catalog.model_dump(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return output

    def _load_full_catalog(self) -> Dict:
        try:
            payload = json.loads(self.full_catalog_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise GucReferenceError(f"cannot read full-document catalog: {self.full_catalog_path}: {exc}") from exc
        if payload.get("kind") != "full_document_catalog" or payload.get("schema_version") != 1:
            raise GucReferenceError("full-document catalog kind/schema is unexpected")
        if not isinstance(payload.get("chapters"), list):
            raise GucReferenceError("full-document catalog has no chapters list")
        return payload

    def _find_guc_chapter(self, full_catalog: Dict) -> Dict:
        matches = [
            chapter for chapter in full_catalog["chapters"]
            if chapter.get("section_number") == "7.3"
            and chapter.get("title") == "GUC参数说明"
        ]
        if len(matches) != 1:
            raise GucReferenceError(f"expected exactly one authoritative 7.3 chapter, got {len(matches)}")
        chapter = matches[0]
        relpath = str(chapter.get("source_relpath", ""))
        parts = relpath.split("/")
        if not relpath or relpath.startswith("/") or "\\" in relpath or any(part in {"", ".", ".."} for part in parts):
            raise GucReferenceError("authoritative 7.3 source_relpath is unsafe")
        if not SHA256_RE.fullmatch(str(chapter.get("chapter_sha256", ""))):
            raise GucReferenceError("authoritative 7.3 chapter hash is invalid")
        return chapter

    def _load_pilot_environment(self):
        registry = GucEnvironmentRegistry(self.root)
        try:
            registry.load_all()
        except GucEnvironmentLoadError as exc:
            raise GucReferenceError("cannot load GUC Environment V1 pilot: " + str(exc)) from exc
        return registry.environment

    def _parse_source(
        self, source_text: str, source_relpath: str
    ) -> Dict[str, List]:
        lines = source_text.splitlines()
        starts: List[Tuple[str, int, str]] = []
        for index, line in enumerate(lines):
            if SECTION_HEADING_RE.match(line):
                starts.append(("heading", index, line.strip()))
                continue
            if GUC_PARAMETER_NAME_RE.fullmatch(line) and any(
                following.strip().startswith("参数说明")
                for following in lines[index + 1:index + 6]
                if following.strip() and not PDF_PAGE_RE.match(following.strip())
            ):
                starts.append(("parameter", index, line.strip()))

        try:
            start = next(index for index, item in enumerate(starts) if item[2].startswith("7.3.2 "))
            end = next(index for index, item in enumerate(starts) if item[2].startswith("7.3.59 "))
        except StopIteration as exc:
            raise GucReferenceError("GUC source lacks the expected 7.3.2–7.3.59 boundaries") from exc
        scoped = starts[start:end]
        headings = [item for item in scoped if item[0] == "heading"]
        if not headings:
            raise GucReferenceError("GUC source has no parameter sections")

        occurrences: List[GucParameterOccurrenceDef] = []
        for position, item in enumerate(scoped):
            if item[0] != "parameter":
                continue
            _, line_index, name = item
            end_index = scoped[position + 1][1] if position + 1 < len(scoped) else len(lines)
            section_stack = _section_stack(headings, line_index)
            if not section_stack:
                raise GucReferenceError(f"parameter {name} has no enclosing section")
            section_number, section_title, section_path = section_stack
            fields = _extract_fields(lines[line_index + 1:end_index])
            if set(fields) != set(FIELD_KEYS.values()):
                raise GucReferenceError(
                    f"parameter {name} missing fields: {sorted(set(FIELD_KEYS.values()) - set(fields))}"
                )
            context_types = _extract_context_types(fields["setting_method"])
            occurrences.append(GucParameterOccurrenceDef(
                id=f"guc_{name}@{section_number}#L{line_index + 1}",
                name=name,
                section_number=section_number,
                section_title=section_title,
                section_path=section_path,
                source_anchor=f"{source_relpath}:L{line_index + 1}-L{end_index}",
                physical_pages=_physical_pages(lines, line_index, end_index),
                context_types=context_types,
                context_status=(
                    "unspecified" if not context_types
                    else "explicit" if len(context_types) == 1
                    else "conditional"
                ),
                **fields,
            ))

        if not occurrences:
            raise GucReferenceError("GUC source yielded no parameter definitions")
        grouped: Dict[str, List[GucParameterOccurrenceDef]] = {}
        for occurrence in occurrences:
            grouped.setdefault(occurrence.name, []).append(occurrence)
        reserved, deprecated = _reserved_and_deprecated(lines)
        parameters: List[GucParameterReferenceDef] = []
        for name in sorted(grouped):
            parameters.append(GucParameterReferenceDef(
                id=f"guc_{name}",
                name=name,
                occurrence_count=len(grouped[name]),
                reserved=name in reserved,
                deprecated=name in deprecated,
                occurrences=grouped[name],
            ))
        return {
            "parameters": parameters,
            "reserved": reserved,
            "deprecated": deprecated,
        }

    def _build_pilot_links(
        self,
        parameters: Sequence[GucParameterReferenceDef],
        pilot_environment,
    ) -> List[GucPilotLinkDef]:
        by_name = {item.name: item for item in parameters}
        links: List[GucPilotLinkDef] = []
        for pilot in pilot_environment.parameters:
            reference = by_name.get(pilot.name)
            if reference is None:
                raise GucReferenceError(f"V1 pilot parameter is absent from V2 source: {pilot.name}")
            reference_contexts = sorted({
                context
                for occurrence in reference.occurrences
                for context in occurrence.context_types
            })
            context_matches = pilot.context_type in reference_contexts
            if not context_matches:
                raise GucReferenceError(
                    f"V1 pilot context drift for {pilot.name}: "
                    f"pilot={pilot.context_type}, source={reference_contexts}"
                )
            links.append(GucPilotLinkDef(
                pilot_id=pilot.id,
                name=pilot.name,
                reference_id=reference.id,
                pilot_schema_version=pilot.schema_version,
                execution_policy=pilot.execution_policy,
                pilot_context_type=pilot.context_type,
                reference_context_types=reference_contexts,
                context_matches=context_matches,
            ))
        return links

    def _verify_authoritative_catalog(self, catalog: GucReferenceCatalogDef) -> None:
        source = catalog.source
        expected_path = self.root / source.catalog_relpath
        try:
            catalog_bytes = expected_path.read_bytes()
        except OSError as exc:
            raise GucReferenceLoadError([f"authoritative catalog unavailable: {expected_path}: {exc}"]) from exc
        actual_hash = hashlib.sha256(catalog_bytes).hexdigest()
        if actual_hash != source.catalog_sha256:
            raise GucReferenceLoadError([
                f"full-document catalog hash drift: expected {source.catalog_sha256}, got {actual_hash}"
            ])
        try:
            payload = json.loads(catalog_bytes)
        except json.JSONDecodeError as exc:
            raise GucReferenceLoadError([f"full-document catalog is invalid JSON: {exc}"]) from exc
        chapter = self._find_guc_chapter(payload)
        comparisons = {
            "section_number": chapter.get("section_number"),
            "title": chapter.get("title"),
            "outline_path": chapter.get("outline_path"),
            "catalog_source_relpath": chapter.get("source_relpath"),
            "chapter_sha256": chapter.get("chapter_sha256"),
            "physical_page_start": chapter.get("physical_page_start"),
            "physical_page_end": chapter.get("physical_page_end"),
        }
        for key, catalog_value in comparisons.items():
            artifact_value = getattr(source, key)
            if catalog_value != artifact_value:
                raise GucReferenceLoadError([
                    f"authoritative GUC chapter drift: {key}: catalog={catalog_value!r}, artifact={artifact_value!r}"
                ])

    def _verify_pilot_links(self, catalog: GucReferenceCatalogDef) -> None:
        pilot_environment = self._load_pilot_environment()
        current = {
            pilot.name: (
                pilot.id, pilot.schema_version, pilot.execution_policy, pilot.context_type
            )
            for pilot in pilot_environment.parameters
        }
        artifact = {
            link.name: (
                link.pilot_id, link.pilot_schema_version, link.execution_policy,
                link.pilot_context_type,
            )
            for link in catalog.pilot_links
        }
        if current != artifact:
            raise GucReferenceLoadError(["GUC V1 pilot link drift"])


def _section_stack(
    headings: Sequence[Tuple[str, int, str]], line_index: int
) -> Tuple[str, str, List[str]]:
    stack: List[Tuple[int, str, str]] = []
    for _, heading_index, heading in headings:
        if heading_index >= line_index:
            break
        match = SECTION_HEADING_RE.match(heading)
        if match is None:
            continue
        number = heading.split(" ", 1)[0]
        title = match.group(1).strip()
        level = number.count(".")
        while stack and stack[-1][0] >= level:
            stack.pop()
        stack.append((level, number, title))
    if not stack:
        return "", "", []
    return stack[-1][1], stack[-1][2], [f"{item[1]} {item[2]}" for item in stack]


def _extract_fields(lines: Sequence[str]) -> Dict[str, str]:
    fields: Dict[str, List[str]] = {}
    current: Optional[str] = None
    index = 0
    while index < len(lines):
        line = lines[index].strip()
        if not line or PDF_PAGE_RE.match(line):
            index += 1
            continue
        wrapped_default = False
        if line == "默认" and index + 1 < len(lines):
            next_line = lines[index + 1].strip()
            if next_line.startswith("值："):
                current = "default_value"
                value = "默认 值：" + next_line.split("：", 1)[1].strip()
                fields.setdefault(current, []).append(value)
                index += 2
                wrapped_default = True
        if wrapped_default:
            continue
        label = next(
            (name for name in FIELD_LABELS if line.startswith(name + "：")),
            None,
        )
        if label is not None:
            current = FIELD_KEYS[label]
            value = line.split("：", 1)[1].strip()
            if value:
                fields.setdefault(current, []).append(value)
        elif current is not None:
            fields.setdefault(current, []).append(line)
        index += 1
    return {key: " ".join(values).strip() for key, values in fields.items()}


def _extract_context_types(setting_method: str) -> List[str]:
    values = {
        value for value in CONTEXT_TYPES
        if value in setting_method
    }
    return sorted(values)


def _physical_pages(lines: Sequence[str], start: int, end: int) -> List[int]:
    pages = [
        int(match.group(1))
        for line in lines[start:end]
        if (match := PDF_PAGE_RE.match(line.strip())) is not None
    ]
    if not pages:
        for index in range(start - 1, -1, -1):
            match = PDF_PAGE_RE.match(lines[index].strip())
            if match is not None:
                pages = [int(match.group(1))]
                break
    if not pages:
        raise GucReferenceError("GUC parameter block has no physical page anchor")
    return pages


def _reserved_and_deprecated(lines: Sequence[str]) -> Tuple[List[str], List[str]]:
    section_index = next(
        (index for index, line in enumerate(lines) if line.strip().startswith("7.3.59 ")),
        None,
    )
    if section_index is None:
        raise GucReferenceError("GUC source lacks the 7.3.59 reserved-parameter section")
    deprecated_index = next(
        (index for index in range(section_index + 1, len(lines)) if lines[index].strip() == "废弃参数"),
        None,
    )
    if deprecated_index is None:
        raise GucReferenceError("GUC source lacks the deprecated-parameter marker")
    reserved = _identifier_lines(lines[section_index + 1:deprecated_index])
    deprecated = _identifier_lines(lines[deprecated_index + 1:])
    return reserved, deprecated


def _identifier_lines(lines: Iterable[str]) -> List[str]:
    return [line.strip() for line in lines if GUC_PARAMETER_NAME_RE.fullmatch(line.strip())]
