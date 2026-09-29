"""Derive a fail-closed GUC pilot-expansion review matrix from Schema V2.

The matrix is a review queue, not an execution policy.  It never widens the
V1 session-overlay pilot; it only classifies V2 reference entries and promotes
confirmed, fact-backed boolean USERSET parameters to the next review batch.
"""
from __future__ import annotations

import hashlib
import json
import re
from collections import Counter
from pathlib import Path
from typing import Dict, List, Literal, Optional

import yaml
from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

from core.guc_reference import GucReferenceCatalogDef, GucReferenceLoadError, GucReferenceRegistry


SHA256_RE = re.compile(r"[0-9a-f]{64}")
ON_RE = re.compile(r"(?<![A-Za-z])on(?![A-Za-z])")
OFF_RE = re.compile(r"(?<![A-Za-z])off(?![A-Za-z])")
CONTEXT_TYPES = ("INTERNAL", "USERSET", "SUSET", "SIGHUP", "POSTMASTER")


class GucCandidateLoadError(ValueError):
    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__("GUC candidate matrix 加载失败:\n" + "\n".join(f"- {item}" for item in errors))


class StrictGucCandidateModel(BaseModel):
    model_config = ConfigDict(extra="forbid")


class GucRuntimeFactSourceDef(StrictGucCandidateModel):
    path: str
    sha256: str
    fact_count: int

    @field_validator("path")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("runtime fact path must be a safe relative path")
        return value

    @field_validator("sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if SHA256_RE.fullmatch(value) is None:
            raise ValueError("runtime fact SHA-256 must be 64 hexadecimal characters")
        return value

    @model_validator(mode="after")
    def ensure_count(self) -> "GucRuntimeFactSourceDef":
        if self.fact_count < 1:
            raise ValueError("runtime fact count must be positive")
        return self


class GucCandidateSourceDef(StrictGucCandidateModel):
    reference_catalog_relpath: str
    reference_catalog_sha256: str
    runtime_fact_files: List[GucRuntimeFactSourceDef]

    @field_validator("reference_catalog_relpath")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if value.startswith("/") or "\\" in value or any(part in {"", ".", ".."} for part in parts):
            raise ValueError("reference catalog path must be a safe relative path")
        return value

    @field_validator("reference_catalog_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        if SHA256_RE.fullmatch(value) is None:
            raise ValueError("reference catalog SHA-256 must be 64 hexadecimal characters")
        return value

    @model_validator(mode="after")
    def ensure_sources(self) -> "GucCandidateSourceDef":
        if not self.runtime_fact_files:
            raise ValueError("runtime fact sources cannot be empty")
        paths = [item.path for item in self.runtime_fact_files]
        if len(set(paths)) != len(paths):
            raise ValueError("runtime fact source paths cannot repeat")
        return self


class GucCandidateEntryDef(StrictGucCandidateModel):
    id: str
    name: str
    reference_id: str
    occurrence_count: int
    disposition: Literal[
        "pilot_already_modeled",
        "reserved_or_deprecated",
        "duplicate_definition_requires_review",
        "context_not_user_set",
        "boolean_session_candidate",
        "value_domain_model_required",
    ]
    context_types: List[Literal["INTERNAL", "USERSET", "SUSET", "SIGHUP", "POSTMASTER"]]
    parameter_types: List[str]
    confirmed_fact_refs: List[str]
    unverified_fact_refs: List[str]
    primary_source_anchor: str
    default_values: List[str]
    value_domains: List[str]
    next_batch: bool
    review_reason: str

    @field_validator("id", "name", "reference_id", "primary_source_anchor", "review_reason")
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC candidate field cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_entry_shape(self) -> "GucCandidateEntryDef":
        if self.occurrence_count < 1:
            raise ValueError("GUC candidate occurrence_count must be positive")
        for values, label in (
            (self.context_types, "context_types"),
            (self.parameter_types, "parameter_types"),
            (self.confirmed_fact_refs, "confirmed_fact_refs"),
            (self.unverified_fact_refs, "unverified_fact_refs"),
            (self.default_values, "default_values"),
            (self.value_domains, "value_domains"),
        ):
            if len(set(values)) != len(values):
                raise ValueError(f"GUC candidate {label} cannot repeat")
        if len(self.default_values) != self.occurrence_count or len(self.value_domains) != self.occurrence_count:
            raise ValueError("GUC candidate raw value arrays must match occurrence_count")
        expected_next_batch = (
            self.disposition == "boolean_session_candidate"
            and bool(self.confirmed_fact_refs)
            and not self.unverified_fact_refs
        )
        if self.next_batch != expected_next_batch:
            raise ValueError("GUC candidate next_batch flag is inconsistent")
        return self


class GucCandidateReviewItemDef(StrictGucCandidateModel):
    id: str
    name: str
    reference_id: str
    default_value: str
    value_domain: str
    source_anchor: str
    confirmed_fact_refs: List[str]
    unverified_fact_refs: List[str]
    review_reason: str

    @field_validator(
        "id", "name", "reference_id", "default_value", "value_domain",
        "source_anchor", "review_reason",
    )
    @classmethod
    def ensure_nonblank(cls, value: str) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError("GUC review item field cannot be blank")
        return normalized

    @model_validator(mode="after")
    def ensure_review_item_shape(self) -> "GucCandidateReviewItemDef":
        if len(set(self.confirmed_fact_refs)) != len(self.confirmed_fact_refs):
            raise ValueError("GUC review confirmed facts cannot repeat")
        if len(set(self.unverified_fact_refs)) != len(self.unverified_fact_refs):
            raise ValueError("GUC review unverified facts cannot repeat")
        if set(self.confirmed_fact_refs) & set(self.unverified_fact_refs):
            raise ValueError("GUC review fact cannot be both confirmed and unverified")
        return self


class GucCandidateSummaryDef(StrictGucCandidateModel):
    parameter_count: int
    occurrence_count: int
    disposition_counts: Dict[str, int]
    context_type_counts: Dict[str, int]
    parameter_type_counts: Dict[str, int]
    boolean_session_candidate_count: int
    fact_backed_candidate_count: int
    unverified_fact_candidate_count: int
    next_batch_count: int


class GucCandidateMatrixDef(StrictGucCandidateModel):
    schema_version: Literal[1]
    kind: Literal["guc_candidate_matrix"]
    id: str = "guc_candidate_matrix_v1"
    name: str = "GaussDB GUC Candidate Matrix V1"
    description: str = (
        "从GUC Reference V2派生的候选准入矩阵；只生成评审队列，不扩大执行策略。"
    )
    source: GucCandidateSourceDef
    parameters: List[GucCandidateEntryDef]
    next_batch: List[GucCandidateReviewItemDef]
    deferred_unverified_facts: List[GucCandidateReviewItemDef]
    summary: GucCandidateSummaryDef

    @model_validator(mode="after")
    def ensure_matrix_shape(self) -> "GucCandidateMatrixDef":
        ids = [item.id for item in self.parameters]
        names = [item.name for item in self.parameters]
        reference_ids = [item.reference_id for item in self.parameters]
        if len(set(ids)) != len(ids):
            raise ValueError("GUC candidate ids cannot repeat")
        if len(set(names)) != len(names):
            raise ValueError("GUC candidate names cannot repeat")
        if len(set(reference_ids)) != len(reference_ids):
            raise ValueError("GUC candidate reference ids cannot repeat")
        if any(not item.id.startswith(f"guc_{item.name}@") for item in self.parameters):
            raise ValueError("GUC candidate ids must retain parameter identity")

        next_by_name = {item.name: item for item in self.next_batch}
        deferred_by_name = {item.name: item for item in self.deferred_unverified_facts}
        if len(next_by_name) != len(self.next_batch):
            raise ValueError("GUC next batch names cannot repeat")
        if len(deferred_by_name) != len(self.deferred_unverified_facts):
            raise ValueError("GUC deferred names cannot repeat")
        if set(next_by_name) & set(deferred_by_name):
            raise ValueError("GUC next batch and deferred names cannot overlap")
        for item in self.parameters:
            if item.next_batch and item.name not in next_by_name:
                raise ValueError(f"GUC next_batch flag has no review item: {item.name}")
            if not item.next_batch and item.name in next_by_name:
                raise ValueError(f"GUC next_batch review item is not flagged: {item.name}")

        occurrences = sum(item.occurrence_count for item in self.parameters)
        disposition_counts = dict(sorted(Counter(item.disposition for item in self.parameters).items()))
        context_counter = Counter(
            context for item in self.parameters for context in item.context_types
        )
        parameter_counter = Counter(
            parameter_type for item in self.parameters for parameter_type in item.parameter_types
        )
        boolean_candidates = [
            item for item in self.parameters if item.disposition == "boolean_session_candidate"
        ]
        expected_summary = GucCandidateSummaryDef(
            parameter_count=len(self.parameters),
            occurrence_count=occurrences,
            disposition_counts=disposition_counts,
            context_type_counts=dict(sorted(context_counter.items())),
            parameter_type_counts=dict(sorted(parameter_counter.items())),
            boolean_session_candidate_count=len(boolean_candidates),
            fact_backed_candidate_count=sum(bool(item.confirmed_fact_refs) for item in boolean_candidates),
            unverified_fact_candidate_count=sum(bool(item.unverified_fact_refs) for item in boolean_candidates),
            next_batch_count=len(self.next_batch),
        )
        if self.summary != expected_summary:
            raise ValueError("GUC candidate summary does not match the matrix payload")
        return self


class GucCandidateRegistry:
    """Load or rebuild the generated GUC candidate matrix."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self.matrix_path = self.root / "generated/guc_candidate_matrix/matrix.json"
        self.reference_catalog_path = self.root / "generated/guc_reference_catalog/catalog.json"

    def load(self) -> GucCandidateMatrixDef:
        try:
            payload = json.loads(self.matrix_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise GucCandidateLoadError([f"{self.matrix_path}: {exc}"]) from exc
        matrix = self.load_payload(payload)
        self._verify_sources(matrix)
        return matrix

    def load_payload(self, payload: Dict) -> GucCandidateMatrixDef:
        try:
            return GucCandidateMatrixDef(**payload)
        except ValidationError as exc:
            errors = [f"payload: {item}" for item in exc.errors()]
        except (TypeError, ValueError) as exc:
            errors = [f"payload: {exc}"]
        raise GucCandidateLoadError(errors)

    def build(self) -> GucCandidateMatrixDef:
        reference = GucReferenceRegistry(self.root).load()
        reference_bytes = self.reference_catalog_path.read_bytes()
        reference_sha256 = hashlib.sha256(reference_bytes).hexdigest()
        runtime_sources, direct_facts = self._load_runtime_facts()

        pilot_names = {item.name for item in reference.pilot_links}
        reserved_or_deprecated = set(reference.reserved_parameters) | set(reference.deprecated_parameters)
        entries: List[GucCandidateEntryDef] = []
        for parameter in reference.parameters:
            contexts = sorted({
                context
                for occurrence in parameter.occurrences
                for context in occurrence.context_types
            })
            parameter_types = sorted({occurrence.parameter_type for occurrence in parameter.occurrences})
            confirmed, unverified = direct_facts.get(parameter.name, ([], []))
            simple_boolean = all(
                occurrence.parameter_type == "布尔型"
                and ON_RE.search(occurrence.value_domain)
                and OFF_RE.search(occurrence.value_domain)
                for occurrence in parameter.occurrences
            )

            if parameter.name in pilot_names:
                disposition = "pilot_already_modeled"
                reason = "已在GUC Environment V1中建模。"
            elif parameter.name in reserved_or_deprecated:
                disposition = "reserved_or_deprecated"
                reason = "7.3.59显式登记为预留或废弃参数，先保留处置而非准入。"
            elif parameter.occurrence_count > 1:
                disposition = "duplicate_definition_requires_review"
                reason = "同一参数名在7.3中多次定义，必须先人工裁决语义差异。"
            elif contexts != ["USERSET"]:
                disposition = "context_not_user_set"
                reason = f"原文context不是唯一USERSET：{contexts or 'unspecified'}。"
            elif simple_boolean:
                disposition = "boolean_session_candidate"
                reason = "唯一USERSET且原文布尔值域包含on/off；仍需人工评审默认值、联动和恢复风险。"
            else:
                disposition = "value_domain_model_required"
                reason = "唯一USERSET，但值域尚未建立可安全执行的结构化模型。"

            next_batch = (
                disposition == "boolean_session_candidate"
                and bool(confirmed)
                and not unverified
            )
            entries.append(GucCandidateEntryDef(
                id=f"guc_{parameter.name}@candidate",
                name=parameter.name,
                reference_id=parameter.id,
                occurrence_count=parameter.occurrence_count,
                disposition=disposition,
                context_types=contexts,
                parameter_types=parameter_types,
                confirmed_fact_refs=confirmed,
                unverified_fact_refs=unverified,
                primary_source_anchor=parameter.occurrences[0].source_anchor,
                default_values=[item.default_value for item in parameter.occurrences],
                value_domains=[item.value_domain for item in parameter.occurrences],
                next_batch=next_batch,
                review_reason=reason,
            ))

        by_name = {item.name: item for item in entries}
        next_batch_items = [
            _review_item(by_name[item.name], reference)
            for item in entries if item.next_batch
        ]
        deferred_items = [
            _review_item(by_name[item.name], reference)
            for item in entries
            if item.disposition == "boolean_session_candidate"
            and item.unverified_fact_refs
            and not item.confirmed_fact_refs
        ]
        occurrences = sum(item.occurrence_count for item in entries)
        disposition_counts = dict(sorted(Counter(item.disposition for item in entries).items()))
        context_counter = Counter(context for item in entries for context in item.context_types)
        parameter_counter = Counter(
            parameter_type for item in entries for parameter_type in item.parameter_types
        )
        boolean_candidates = [item for item in entries if item.disposition == "boolean_session_candidate"]
        summary = GucCandidateSummaryDef(
            parameter_count=len(entries),
            occurrence_count=occurrences,
            disposition_counts=disposition_counts,
            context_type_counts=dict(sorted(context_counter.items())),
            parameter_type_counts=dict(sorted(parameter_counter.items())),
            boolean_session_candidate_count=len(boolean_candidates),
            fact_backed_candidate_count=sum(bool(item.confirmed_fact_refs) for item in boolean_candidates),
            unverified_fact_candidate_count=sum(bool(item.unverified_fact_refs) for item in boolean_candidates),
            next_batch_count=len(next_batch_items),
        )
        return GucCandidateMatrixDef(
            schema_version=1,
            kind="guc_candidate_matrix",
            source=GucCandidateSourceDef(
                reference_catalog_relpath=str(self.reference_catalog_path.relative_to(self.root)),
                reference_catalog_sha256=reference_sha256,
                runtime_fact_files=runtime_sources,
            ),
            parameters=entries,
            next_batch=next_batch_items,
            deferred_unverified_facts=deferred_items,
            summary=summary,
        )

    def write(self, output: Optional[Path] = None) -> Path:
        output = Path(output or self.matrix_path)
        matrix = self.build()
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(
            json.dumps(matrix.model_dump(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return output

    def _load_runtime_facts(self):
        sources: List[GucRuntimeFactSourceDef] = []
        direct: Dict[str, tuple] = {}
        pattern = "guc_{name}"
        for path in sorted((self.root / "docs/compat_facts").glob("runtime_params*.yaml")):
            try:
                payload = yaml.safe_load(path.read_text(encoding="utf-8"))
                facts = payload.get("facts", [])
                if not isinstance(facts, list):
                    raise ValueError("facts must be a list")
                source = GucRuntimeFactSourceDef(
                    path=str(path.relative_to(self.root)),
                    sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                    fact_count=len(facts),
                )
                sources.append(source)
                for fact in facts:
                    fact_id = str(fact.get("id", ""))
                    status = str(fact.get("status", ""))
                    if not fact_id.startswith("guc_"):
                        continue
                    name = fact_id[4:]
                    key = pattern.format(name=name)
                    if name not in direct:
                        direct[name] = ([], [])
                    global_ref = f"{source.path}::{fact_id}"
                    if status == "confirmed":
                        direct[name][0].append(global_ref)
                    elif status == "needs_verification":
                        direct[name][1].append(global_ref)
                    else:
                        raise ValueError(f"unsupported runtime fact status: {fact_id}: {status}")
            except (OSError, yaml.YAMLError, TypeError, KeyError, ValueError, ValidationError) as exc:
                raise GucCandidateLoadError([f"{path}: {exc}"]) from exc
        confirmed = {
            name: (sorted(values[0]), sorted(values[1]))
            for name, values in direct.items()
        }
        return sources, confirmed

    def _verify_sources(self, matrix: GucCandidateMatrixDef) -> None:
        errors: List[str] = []
        try:
            actual_reference_hash = hashlib.sha256(self.reference_catalog_path.read_bytes()).hexdigest()
        except OSError as exc:
            raise GucCandidateLoadError([f"reference catalog unavailable: {exc}"]) from exc
        if actual_reference_hash != matrix.source.reference_catalog_sha256:
            errors.append(
                "GUC reference catalog hash drift: "
                f"expected {matrix.source.reference_catalog_sha256}, got {actual_reference_hash}"
            )
        try:
            reference = GucReferenceRegistry(self.root).load()
        except GucReferenceLoadError as exc:
            errors.append(f"cannot reload GUC reference catalog: {exc}")
            reference = None
        if reference is None:
            raise GucCandidateLoadError(errors)
        if (
            reference.summary.parameter_count != matrix.summary.parameter_count
            or reference.summary.definition_count != matrix.summary.occurrence_count
        ):
            errors.append("GUC reference catalog counts drifted from candidate matrix")

        try:
            _, direct_facts = self._load_runtime_facts()
        except GucCandidateLoadError as exc:
            errors.extend(exc.errors)
            raise GucCandidateLoadError(errors) from exc
        reference_by_id = {item.id: item for item in reference.parameters}
        for entry in matrix.parameters:
            parameter = reference_by_id.get(entry.reference_id)
            if parameter is None:
                errors.append(f"GUC candidate reference is dangling: {entry.name}")
                continue
            expected_contexts = sorted({
                context
                for occurrence in parameter.occurrences
                for context in occurrence.context_types
            })
            expected_types = sorted({
                occurrence.parameter_type for occurrence in parameter.occurrences
            })
            expected_confirmed, expected_unverified = direct_facts.get(entry.name, ([], []))
            checks = {
                "occurrence_count": (entry.occurrence_count, parameter.occurrence_count),
                "context_types": (entry.context_types, expected_contexts),
                "parameter_types": (entry.parameter_types, expected_types),
                "confirmed_fact_refs": (entry.confirmed_fact_refs, expected_confirmed),
                "unverified_fact_refs": (entry.unverified_fact_refs, expected_unverified),
                "primary_source_anchor": (
                    entry.primary_source_anchor,
                    parameter.occurrences[0].source_anchor,
                ),
            }
            for field, (actual, expected) in checks.items():
                if actual != expected:
                    errors.append(
                        f"GUC candidate {entry.name} {field} drift: "
                        f"matrix={actual!r}, source={expected!r}"
                    )
        for item in matrix.next_batch + matrix.deferred_unverified_facts:
            parameter = reference_by_id.get(item.reference_id)
            if parameter is None:
                errors.append(f"GUC review reference is dangling: {item.name}")
                continue
            occurrence = parameter.occurrences[0]
            for field, actual, expected in (
                ("default_value", item.default_value, occurrence.default_value),
                ("value_domain", item.value_domain, occurrence.value_domain),
                ("source_anchor", item.source_anchor, occurrence.source_anchor),
            ):
                if actual != expected:
                    errors.append(
                        f"GUC review {item.name} {field} drift: "
                        f"matrix={actual!r}, source={expected!r}"
                    )

        recorded = {item.path: item for item in matrix.source.runtime_fact_files}
        actual_paths = sorted((self.root / "docs/compat_facts").glob("runtime_params*.yaml"))
        actual_relpaths = [str(path.relative_to(self.root)) for path in actual_paths]
        if set(recorded) != set(actual_relpaths):
            errors.append(
                "runtime fact source set drift: "
                f"expected={sorted(recorded)}, actual={actual_relpaths}"
            )
        for path in actual_paths:
            relpath = str(path.relative_to(self.root))
            recorded_source = recorded.get(relpath)
            if recorded_source is None:
                continue
            try:
                actual_hash = hashlib.sha256(path.read_bytes()).hexdigest()
                fact_count = len(yaml.safe_load(path.read_text(encoding="utf-8")).get("facts", []))
            except (OSError, yaml.YAMLError, AttributeError) as exc:
                errors.append(f"{relpath}: {exc}")
                continue
            if actual_hash != recorded_source.sha256:
                errors.append(
                    f"{relpath} hash drift: expected {recorded_source.sha256}, got {actual_hash}"
                )
            if fact_count != recorded_source.fact_count:
                errors.append(
                    f"{relpath} fact count drift: expected {recorded_source.fact_count}, got {fact_count}"
                )
        if errors:
            raise GucCandidateLoadError(errors)


def _review_item(
    entry: GucCandidateEntryDef,
    reference: GucReferenceCatalogDef,
) -> GucCandidateReviewItemDef:
    parameter = next(item for item in reference.parameters if item.id == entry.reference_id)
    occurrence = parameter.occurrences[0]
    return GucCandidateReviewItemDef(
        id=entry.id,
        name=entry.name,
        reference_id=entry.reference_id,
        default_value=occurrence.default_value,
        value_domain=occurrence.value_domain,
        source_anchor=occurrence.source_anchor,
        confirmed_fact_refs=entry.confirmed_fact_refs,
        unverified_fact_refs=entry.unverified_fact_refs,
        review_reason=entry.review_reason,
    )
