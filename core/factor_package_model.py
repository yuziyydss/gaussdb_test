"""Factor Package Schema V1 models and strict registry."""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, Iterable, List, Literal, Optional, Set, Tuple, Union

import yaml
from pydantic import BaseModel, ConfigDict, Field, ValidationError, field_validator, model_validator

from .constraint_solver import ConstraintError, ConstraintSolver


Status = Literal["draft", "needs_review", "ready", "planned", "deprecated"]
Validity = Literal["valid", "invalid", "conditional", "unknown"]


class FactorPackageLoadError(ValueError):
    """All V1 package loading errors from one pass."""

    def __init__(self, errors: List[str]):
        self.errors = errors
        super().__init__("Factor Package V1 加载失败:\n" + "\n".join(f"- {item}" for item in errors))


class StrictV1Model(BaseModel):
    model_config = ConfigDict(extra="forbid")


class CatalogChapterRefDef(StrictV1Model):
    document_id: str = Field(min_length=1)
    source_relpath: str = Field(min_length=1)
    chapter_sha256: str

    @field_validator("document_id", "source_relpath")
    @classmethod
    def ensure_non_blank_text(cls, value: str, info: Any) -> str:
        normalized = value.strip()
        if not normalized:
            raise ValueError(f"{info.field_name} 必须是非空字符串")
        return normalized

    @field_validator("source_relpath")
    @classmethod
    def ensure_safe_relative_path(cls, value: str) -> str:
        parts = value.split("/")
        if (
            value.startswith("/")
            or "\\" in value
            or any(part in {"", ".", ".."} for part in parts)
        ):
            raise ValueError("source_relpath 必须是安全相对路径")
        return value

    @field_validator("chapter_sha256")
    @classmethod
    def ensure_sha256(cls, value: str) -> str:
        digest = value.strip().lower()
        if re.fullmatch(r"[0-9a-f]{64}", digest) is None:
            raise ValueError("chapter_sha256 必须是64位十六进制 SHA-256")
        return digest


class SourceDef(StrictV1Model):
    product: str
    document: str
    version: str
    artifact_sha256: str
    parent_pdf_sha256: Optional[str] = None
    extraction_rule_version: Optional[str] = None
    extraction_date: str
    catalog_chapter_ref: Optional[CatalogChapterRefDef] = None

    @field_validator("artifact_sha256", "parent_pdf_sha256")
    @classmethod
    def ensure_source_sha256(cls, value: Optional[str]) -> Optional[str]:
        if value is None:
            return None
        digest = value.strip().lower()
        if re.fullmatch(r"[0-9a-f]{64}", digest) is None:
            raise ValueError("来源 SHA-256 必须是64位十六进制摘要")
        return digest

    @field_validator("extraction_rule_version")
    @classmethod
    def ensure_extraction_rule_version(cls, value: Optional[str]) -> Optional[str]:
        if value is None:
            return None
        normalized = value.strip()
        if not normalized:
            raise ValueError("extraction_rule_version 不能为空")
        return normalized

    @model_validator(mode="after")
    def ensure_catalog_hash_matches_artifact(self) -> "SourceDef":
        if (
            self.catalog_chapter_ref is not None
            and self.catalog_chapter_ref.chapter_sha256 != self.artifact_sha256
        ):
            raise ValueError(
                "catalog_chapter_ref.chapter_sha256 与 artifact_sha256 必须相同"
            )
        if self.catalog_chapter_ref is not None and (
            self.parent_pdf_sha256 is None or self.extraction_rule_version is None
        ):
            raise ValueError(
                "catalog 来源必须同时声明 parent_pdf_sha256 和 extraction_rule_version"
            )
        return self


class DimensionValueDef(StrictV1Model):
    id: str
    render: str
    representative: bool
    validity: Validity
    fixture_refs: List[str] = Field(default_factory=list)
    properties: Dict[str, Any] = Field(default_factory=dict)
    output_column_count: Optional[Union[int, Literal["inherited"]]] = None
    fact_refs: List[str] = Field(default_factory=list)


class EquivalenceClassDef(StrictV1Model):
    id: str
    meaning: str
    values: List[DimensionValueDef]


class ProfileSourceDef(StrictV1Model):
    matrix_ref: str
    profile_id_path: Literal["profiles.id"] = "profiles.id"


class DimensionDef(StrictV1Model):
    description: str
    classes: List[EquivalenceClassDef] = Field(default_factory=list)
    profile_source: Optional[ProfileSourceDef] = None
    default_value_id: Optional[str] = None

    @model_validator(mode="after")
    def ensure_one_value_source(self) -> "DimensionDef":
        if bool(self.classes) == bool(self.profile_source):
            raise ValueError("dimension 必须且只能使用 classes 或 profile_source")
        return self


class FactorRuleDef(StrictV1Model):
    id: str
    kind: Literal["requires"]
    expression: str
    severity: Literal["error"] = "error"
    fact_refs: List[str]


class StructuralCheckDef(StrictV1Model):
    id: str
    kind: Literal[
        "column_count_matches_query",
        "select_expression_contract",
        "insert_input_contract",
        "index_column_count_contract",
        "index_fillfactor_contract",
        "index_key_source_contract",
        "fixture_write_contract",
    ]
    fact_refs: List[str]


class FactDef(StrictV1Model):
    id: str
    type: Literal[
        "syntax", "constraint", "environment", "lifecycle", "behavior_oracle",
        "metadata_oracle", "example", "open_question",
    ]
    statement: str
    status: Literal["confirmed", "inferred", "needs_verification", "rejected"]
    source_anchor: str


class SourceUnitDef(StrictV1Model):
    id: str
    section: str
    source_anchor: str
    line_start: int = Field(ge=1)
    line_end: int = Field(ge=1)
    statement: str
    status: Literal["mapped", "open_question", "out_of_scope", "unmapped"]
    fact_refs: List[str] = Field(default_factory=list)
    supplemental_source_refs: List[str] = Field(default_factory=list)
    rationale: Optional[str] = None
    atomicity: Literal["atomic", "grouped", "unreviewed"] = "unreviewed"
    independent_claim_count: int = Field(default=1, ge=1)
    atomicity_rationale: Optional[str] = Field(default=None, min_length=1)
    overlap_group: Optional[str] = Field(default=None, min_length=1)
    overlap_rationale: Optional[str] = Field(default=None, min_length=1)

    @model_validator(mode="after")
    def ensure_disposition_is_explicit(self) -> "SourceUnitDef":
        if self.line_end < self.line_start:
            raise ValueError("line_end 不能小于 line_start")
        if self.status in {"mapped", "open_question"} and not self.fact_refs:
            raise ValueError(f"status={self.status} 的 source unit 必须引用 fact")
        if self.status in {"out_of_scope", "unmapped"}:
            if self.fact_refs:
                raise ValueError(f"status={self.status} 的 source unit 不能引用 fact")
            if not self.rationale:
                raise ValueError(f"status={self.status} 的 source unit 必须说明 rationale")
        if self.atomicity == "grouped" and self.independent_claim_count < 2:
            raise ValueError("atomicity=grouped 时 independent_claim_count 必须至少为 2")
        if self.atomicity == "atomic" and self.independent_claim_count != 1:
            raise ValueError("atomicity=atomic 时 independent_claim_count 必须为 1")
        if bool(self.overlap_group) != bool(self.overlap_rationale):
            raise ValueError("overlap_group 与 overlap_rationale 必须同时声明")
        return self


class IgnoredSourceLineDef(StrictV1Model):
    line: int = Field(ge=1)
    rationale: str = Field(min_length=1)


class SupplementalSourceDef(StrictV1Model):
    id: str
    document: str
    version: str
    url: Optional[str] = Field(default=None, min_length=1)
    catalog_chapter_ref: Optional[CatalogChapterRefDef] = None
    retrieval_date: str
    source_anchor: str

    @field_validator("url")
    @classmethod
    def ensure_non_blank_url(cls, value: Optional[str]) -> Optional[str]:
        if value is None:
            return None
        normalized = value.strip()
        if not normalized:
            raise ValueError("url 必须是非空字符串")
        return normalized

    @model_validator(mode="after")
    def ensure_exactly_one_locator(self) -> "SupplementalSourceDef":
        if (self.url is None) == (self.catalog_chapter_ref is None):
            raise ValueError("supplemental source 必须且只能提供 url 或 catalog_chapter_ref")
        return self


class FactorSourceLedgerDef(StrictV1Model):
    schema_version: Literal[1]
    kind: Literal["source_ledger"]
    id: str
    name: str
    status: Status
    description: str
    factor_ref: str
    artifact_sha256: str
    source_line_count: int = Field(ge=1)
    ignored_lines: List[IgnoredSourceLineDef] = Field(default_factory=list)
    supplemental_sources: List[SupplementalSourceDef] = Field(default_factory=list)
    units: List[SourceUnitDef]

    @field_validator("artifact_sha256")
    @classmethod
    def ensure_artifact_sha256(cls, value: str) -> str:
        digest = value.strip().lower()
        if re.fullmatch(r"[0-9a-f]{64}", digest) is None:
            raise ValueError("artifact_sha256 必须是64位十六进制 SHA-256")
        return digest

    @model_validator(mode="after")
    def ensure_every_source_line_is_accounted_for(self) -> "FactorSourceLedgerDef":
        unit_lines: Set[int] = set()
        line_units: Dict[int, List[SourceUnitDef]] = {}
        for unit in self.units:
            if unit.line_end > self.source_line_count:
                raise ValueError(
                    f"source unit '{unit.id}' 超出原文总行数 {self.source_line_count}"
                )
            for line in range(unit.line_start, unit.line_end + 1):
                unit_lines.add(line)
                line_units.setdefault(line, []).append(unit)
        undeclared_overlaps: Dict[int, List[str]] = {}
        for line, overlapping_units in line_units.items():
            if len(overlapping_units) < 2:
                continue
            groups = {unit.overlap_group for unit in overlapping_units}
            if None in groups or len(groups) != 1:
                undeclared_overlaps[line] = [unit.id for unit in overlapping_units]
        if undeclared_overlaps:
            preview = dict(list(sorted(undeclared_overlaps.items()))[:20])
            raise ValueError(
                "source unit 行区间重叠必须由相同 overlap_group 与 rationale 显式解释: "
                f"{preview}"
            )
        ignored = [item.line for item in self.ignored_lines]
        if len(ignored) != len(set(ignored)):
            raise ValueError("ignored_lines 不能包含重复行号")
        if any(line > self.source_line_count for line in ignored):
            raise ValueError("ignored_lines 不能超出 source_line_count")
        overlap = sorted(unit_lines & set(ignored))
        if overlap:
            raise ValueError(f"原文行不能同时被 unit 覆盖并忽略: {overlap}")
        missing = sorted(
            set(range(1, self.source_line_count + 1)) - unit_lines - set(ignored)
        )
        if missing:
            raise ValueError(f"原文存在未登记行: {missing}")
        source_ids = [source.id for source in self.supplemental_sources]
        if len(source_ids) != len(set(source_ids)):
            raise ValueError("supplemental_sources 不能包含重复 ID")
        known_sources = set(source_ids)
        unknown_refs = sorted({
            source_ref
            for unit in self.units
            for source_ref in unit.supplemental_source_refs
            if source_ref not in known_sources
        })
        if unknown_refs:
            raise ValueError(f"source unit 引用未知 supplemental source: {unknown_refs}")
        return self


class FactorPackageDef(StrictV1Model):
    schema_version: Literal[1]
    kind: Literal["factor"]
    id: str
    name: str
    category: str
    status: Status
    description: str
    source: SourceDef
    source_ledger_ref: str
    syntax_ref: str
    dimension_refs: List[str] = Field(default_factory=list)
    dimensions: Dict[str, DimensionDef]
    rules: List[FactorRuleDef] = Field(default_factory=list)
    structural_checks: List[StructuralCheckDef] = Field(default_factory=list)
    facts: List[FactDef] = Field(default_factory=list)
    exported_fact_refs: List[str] = Field(default_factory=list)
    manifest_refs: List[str] = Field(default_factory=list)
    matrix_refs: List[str] = Field(default_factory=list)
    fixture_refs: List[str] = Field(default_factory=list)
    scenario_refs: List[str] = Field(default_factory=list)


class RenderingDef(StrictV1Model):
    whitespace: Literal["collapse"] = "collapse"
    statement_terminator: str = ";"


class V1SlotDef(StrictV1Model):
    type: str
    optional: bool
    dimension_ref: Optional[str] = None
    symbol_action: Optional[str] = None
    identifier_role: Optional[str] = None


class SyntaxASTNodeDef(StrictV1Model):
    kind: Literal["literal", "slot", "sequence", "choice", "optional", "repeat", "ref"]
    text: Optional[str] = None
    slot: Optional[str] = None
    items: List["SyntaxASTNodeDef"] = Field(default_factory=list)
    selector: Optional[str] = None
    branches: Dict[str, "SyntaxASTNodeDef"] = Field(default_factory=dict)
    enabled_values: List[str] = Field(default_factory=list)
    item: Optional["SyntaxASTNodeDef"] = None
    separator: str = ", "
    items_property: str = "items"
    ref: Optional[str] = None

    @model_validator(mode="after")
    def ensure_shape_matches_kind(self) -> "SyntaxASTNodeDef":
        required = {
            "literal": ("text",),
            "slot": ("slot",),
            "sequence": ("items",),
            "choice": ("selector", "branches"),
            "optional": ("selector", "enabled_values", "item"),
            "repeat": ("slot",),
            "ref": ("ref",),
        }[self.kind]
        for field_name in required:
            value = getattr(self, field_name)
            if value is None or value == [] or value == {}:
                raise ValueError(f"AST kind={self.kind!r} 必须提供 {field_name}")
        return self

    def referenced_slots(self) -> Set[str]:
        refs: Set[str] = set()
        if self.kind in {"slot", "repeat"} and self.slot:
            refs.add(self.slot)
        if self.kind in {"choice", "optional"} and self.selector:
            refs.add(self.selector)
        for child in self.items:
            refs.update(child.referenced_slots())
        for child in self.branches.values():
            refs.update(child.referenced_slots())
        if self.item is not None:
            refs.update(self.item.referenced_slots())
        return refs

    def walk(self) -> Iterable["SyntaxASTNodeDef"]:
        yield self
        for child in self.items:
            yield from child.walk()
        for child in self.branches.values():
            yield from child.walk()
        if self.item is not None:
            yield from self.item.walk()

    def referenced_subgrammars(self) -> Set[str]:
        refs = {self.ref} if self.kind == "ref" and self.ref else set()
        for child in self.items:
            refs.update(child.referenced_subgrammars())
        for child in self.branches.values():
            refs.update(child.referenced_subgrammars())
        if self.item is not None:
            refs.update(self.item.referenced_subgrammars())
        return refs


class FactorSyntaxDef(StrictV1Model):
    schema_version: Literal[1]
    kind: Literal["syntax"]
    id: str
    name: str
    category: str
    status: Status
    factor_ref: str
    description: str
    production: Optional[str] = None
    ast: Optional[SyntaxASTNodeDef] = None
    subgrammars: Dict[str, SyntaxASTNodeDef] = Field(default_factory=dict)
    rendering: RenderingDef
    slots: Dict[str, V1SlotDef]
    source_fact_refs: List[str] = Field(default_factory=list)

    @model_validator(mode="after")
    def ensure_one_rendering_model(self) -> "FactorSyntaxDef":
        if bool(self.production) == bool(self.ast):
            raise ValueError("syntax 必须且只能提供 production 或 ast")
        if self.production and self.subgrammars:
            raise ValueError("线性 production 不能声明 AST subgrammars")
        return self

    def production_placeholders(self) -> Set[str]:
        if not self.production:
            return set()
        return set(re.findall(r"\{([A-Za-z_][A-Za-z0-9_]*)\}", self.production))

    def ast_slots(self) -> Set[str]:
        if self.ast is None:
            return set()
        refs = self.ast.referenced_slots()
        for node in self.subgrammars.values():
            refs.update(node.referenced_slots())
        return refs

    def ast_subgrammar_refs(self) -> Set[str]:
        if self.ast is None:
            return set()
        refs = self.ast.referenced_subgrammars()
        for node in self.subgrammars.values():
            refs.update(node.referenced_subgrammars())
        return refs


class MatrixProfileDef(StrictV1Model):
    id: str
    render: str
    validity: Validity
    fixture_refs: List[str] = Field(default_factory=list)
    properties: Dict[str, Any] = Field(default_factory=dict)
    fact_refs: List[str] = Field(default_factory=list)


class DocumentedFeatureCoverageDef(StrictV1Model):
    id: str
    profile_refs: List[str] = Field(default_factory=list)
    value_refs: List[str] = Field(default_factory=list)
    status: Literal["covered", "needs_profile"]
    coverage_mode: Literal["all", "any", "representative"] = "all"
    fact_refs: List[str] = Field(default_factory=list)

    @property
    def coverage_refs(self) -> List[str]:
        return [*self.profile_refs, *self.value_refs]

    @model_validator(mode="after")
    def ensure_status_matches_profiles(self) -> "DocumentedFeatureCoverageDef":
        if not self.fact_refs:
            raise ValueError("documented feature 必须引用 PDF 溯源 fact_refs")
        if self.status == "covered" and not self.coverage_refs:
            raise ValueError("covered feature 必须至少引用一个 profile 或 dimension value")
        if self.status == "needs_profile" and self.coverage_refs:
            raise ValueError("needs_profile feature 不能引用尚未确认的覆盖值")
        if self.status == "needs_profile" and self.coverage_mode != "all":
            raise ValueError("needs_profile feature 不应声明 coverage_mode")
        return self


class FactorMatrixDef(StrictV1Model):
    schema_version: Literal[1]
    kind: Literal["matrix"]
    id: str
    name: str
    status: Status
    description: str
    factor_ref: str
    profile_property_defaults: Dict[str, Any] = Field(default_factory=dict)
    profiles: List[MatrixProfileDef]
    documented_features: List[DocumentedFeatureCoverageDef] = Field(default_factory=list)
    documented_non_updatable_features: List[DocumentedFeatureCoverageDef] = Field(default_factory=list)
    fact_refs: List[str] = Field(default_factory=list)

    @property
    def all_documented_features(self) -> List[DocumentedFeatureCoverageDef]:
        """Return generic V1 feature coverage plus the CREATE VIEW compatibility field."""
        return [*self.documented_features, *self.documented_non_updatable_features]


class FixtureColumnV1Def(StrictV1Model):
    name: str
    type: str
    nullable: bool


class FixtureTableV1Def(StrictV1Model):
    name: str
    persistence: Literal["permanent", "temporary"]
    table_kind: str
    columns: List[FixtureColumnV1Def]


class FixtureInputFileDef(StrictV1Model):
    """Small source-controlled INTEGER TSV input, not a deployed server file."""
    id: str = Field(pattern=r"^[a-z][a-z0-9_]*$")
    source_path: str
    sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    target_path: str
    format: Literal["integer_tsv"]
    column_count: int = Field(ge=1, le=32)
    row_count: int = Field(ge=1)
    deployment: Literal["manual_copy_and_verify"]
    cleanup: Literal["remove_only_owned_deployed_file_after_hash_check"]
    fact_refs: List[str] = Field(default_factory=list)

    @model_validator(mode="after")
    def bounded_paths(self) -> "FixtureInputFileDef":
        if (not re.fullmatch(r"assets/[A-Za-z0-9_./-]+", self.source_path)
                or any(p in ("", ".", "..") for p in self.source_path.split("/"))):
            raise ValueError("file asset source_path must stay in fixture/assets")
        if (not re.fullmatch(r"/tmp/(?:m_factor_assets|factor_assets)/[A-Za-z0-9_./-]+", self.target_path)
                or any(p in ("", ".", "..") for p in self.target_path.split("/")[1:])):
            raise ValueError("file asset target_path must be a scoped /tmp/factor_assets or /tmp/m_factor_assets file")
        return self


class FixtureProvidesDef(StrictV1Model):
    tables: List[FixtureTableV1Def] = Field(default_factory=list)
    files: List[FixtureInputFileDef] = Field(default_factory=list)


class FixtureSeedDef(StrictV1Model):
    required: bool
    rows: List[Dict[str, Any]] = Field(default_factory=list)


class FixtureExecutionDef(StrictV1Model):
    status: Literal["ready", "not_implemented"]
    mode: Literal["auto", "explicit"] = "auto"
    setup_sqls: List[str] = Field(default_factory=list)
    teardown_sqls: List[str] = Field(default_factory=list)
    note: str

    @model_validator(mode="after")
    def ensure_explicit_lifecycle_is_complete(self) -> "FixtureExecutionDef":
        if self.mode == "explicit" and (
            not self.setup_sqls or not self.teardown_sqls
        ):
            raise ValueError("explicit fixture 必须同时提供 setup_sqls 和 teardown_sqls")
        return self


class FactorFixtureDef(StrictV1Model):
    schema_version: Literal[1]
    kind: Literal["fixture"]
    id: str
    name: str
    status: Status
    description: str
    factor_ref: Optional[str] = None
    requires_fixture_refs: List[str] = Field(default_factory=list)
    provides: FixtureProvidesDef
    seed: FixtureSeedDef
    execution: FixtureExecutionDef


class IdentifierPolicyDef(StrictV1Model):
    generator: Literal["deterministic"]
    prefix: str
    schema_prefix: Optional[str] = None
    unique_per_case: Literal[True] = True

    @field_validator("prefix", "schema_prefix")
    @classmethod
    def ensure_safe_unquoted_identifier_component(cls, value: Optional[str]) -> Optional[str]:
        if value is not None and not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", value):
            raise ValueError("必须是安全的未引用 SQL 标识符片段")
        return value


class LocalRuleDef(StrictV1Model):
    expression: str
    rationale: str
    fact_refs: List[str] = Field(default_factory=list)


class ExpectedDef(StrictV1Model):
    default: Literal["success", "error"]
    scope: Literal["syntax_only", "syntax_and_semantics", "behavior", "metadata"]
    oracle_status: Literal["confirmed", "needs_verification"] = "confirmed"
    sqlstates: List[str] = Field(default_factory=list)
    error_category: Optional[str] = None
    error_message_regex: Optional[str] = None
    fact_refs: List[str] = Field(default_factory=list)

    @model_validator(mode="after")
    def ensure_target_error_oracle(self) -> "ExpectedDef":
        if self.default == "success":
            if self.sqlstates or self.error_category or self.error_message_regex:
                raise ValueError("success expected 不能声明错误 Oracle")
            if self.oracle_status != "confirmed":
                raise ValueError("success expected 的 oracle_status 必须为 confirmed")
            return self
        if not self.error_category:
            raise ValueError("error expected 必须声明 error_category")
        if self.oracle_status == "needs_verification":
            if self.sqlstates or self.error_message_regex:
                raise ValueError(
                    "needs_verification 错误 Oracle 不能携带未确认的 sqlstates 或正则"
                )
            return self
        if not self.fact_refs:
            raise ValueError("confirmed error Oracle 必须引用 fact_refs")
        if not self.sqlstates and not self.error_message_regex:
            raise ValueError("error expected 必须声明 sqlstates 或 error_message_regex")
        if self.error_message_regex:
            try:
                compiled = re.compile(self.error_message_regex)
            except re.error as exc:
                raise ValueError(f"error_message_regex 无效: {exc}") from exc
            unrelated_messages = (
                "unrelated_alpha",
                "completely different failure 123",
                "权限错误样例",
            )
            if all(compiled.search(message) for message in unrelated_messages):
                raise ValueError("error_message_regex 不能匹配任意错误")
        return self


class CoverageRequirementDef(StrictV1Model):
    strength: Literal[2]
    require_all_feasible_pairs: Literal[True]


class EnvironmentRequirementDef(StrictV1Model):
    key: str = Field(min_length=1)
    allowed_values: List[str] = Field(min_length=1)
    fact_refs: List[str] = Field(min_length=1)

    @field_validator("key")
    @classmethod
    def ensure_key_is_safe(cls, value: str) -> str:
        if not re.fullmatch(r"[a-z][a-z0-9_]*", value):
            raise ValueError("environment requirement key 必须是小写 snake_case")
        return value

    @field_validator("allowed_values")
    @classmethod
    def ensure_allowed_values_are_explicit(cls, values: List[str]) -> List[str]:
        normalized = [value.strip() for value in values]
        if any(not value for value in normalized):
            raise ValueError("environment requirement 不允许空值")
        if len(normalized) != len(set(normalized)):
            raise ValueError("environment requirement allowed_values 不能重复")
        return normalized


class FactorManifestDef(StrictV1Model):
    schema_version: Literal[1]
    kind: Literal["manifest"]
    id: str
    name: str
    status: Status
    description: str
    factor_ref: str
    syntax_ref: str
    suite_type: Literal["positive", "negative"]
    strategy: Literal["pairwise", "equivalence", "full_cartesian"]
    fixture_refs: List[str] = Field(default_factory=list)
    environment_requirements: List[EnvironmentRequirementDef] = Field(
        default_factory=list
    )
    identifier_policy: Dict[str, IdentifierPolicyDef]
    bindings: Dict[str, List[str]]
    local_rules: List[LocalRuleDef] = Field(default_factory=list)
    violates_rule_refs: List[str] = Field(default_factory=list)
    expected: ExpectedDef
    coverage_requirements: CoverageRequirementDef

    @model_validator(mode="after")
    def ensure_suite_intent_is_explicit(self) -> "FactorManifestDef":
        empty_bindings = [name for name, values in self.bindings.items() if not values]
        if empty_bindings:
            raise ValueError(f"bindings 中存在空值域: {', '.join(empty_bindings)}")
        if self.suite_type == "positive":
            if self.expected.default != "success" or self.violates_rule_refs:
                raise ValueError("positive manifest 必须 expected=success 且不能声明 violates_rule_refs")
        elif self.expected.default != "error" or not self.violates_rule_refs:
            raise ValueError("negative manifest 必须 expected=error 且声明 violates_rule_refs")
        if self.expected.oracle_status == "needs_verification" and self.status == "ready":
            raise ValueError("未校准错误 Oracle 的 manifest 不能标记为 ready")
        return self


class FactorScenarioDef(StrictV1Model):
    schema_version: Literal[1]
    kind: Literal["scenario"]
    id: str
    name: str
    status: Status
    description: str
    factor_ref: str
    fixture_refs: List[str] = Field(default_factory=list)
    fact_refs: List[str] = Field(default_factory=list)
    preconditions: List[Any] = Field(default_factory=list)
    steps: List[Any] = Field(default_factory=list)
    variants: List[Any] = Field(default_factory=list)
    oracles: List[Any] = Field(default_factory=list)
    execution_requirements: List[str] = Field(default_factory=list)

    @model_validator(mode="after")
    def ensure_ready_scenario_has_executable_shape(self) -> "FactorScenarioDef":
        if self.status != "ready":
            return self
        if not self.steps and not self.variants:
            raise ValueError("ready scenario 必须声明 steps 或 variants")
        if not self.oracles:
            raise ValueError("ready scenario 必须声明 oracles")
        if any(not isinstance(item, dict) for item in [*self.steps, *self.variants]):
            raise ValueError("ready scenario 的 steps/variants 必须是结构化对象")
        if any(
            not isinstance(item, dict) or not item.get("kind") or "expected" not in item
            for item in self.oracles
        ):
            raise ValueError("ready scenario 的每个 oracle 必须包含 kind 和 expected")
        return self


V1_MODEL_BY_KIND = {
    "factor": FactorPackageDef,
    "source_ledger": FactorSourceLedgerDef,
    "syntax": FactorSyntaxDef,
    "manifest": FactorManifestDef,
    "matrix": FactorMatrixDef,
    "fixture": FactorFixtureDef,
    "scenario": FactorScenarioDef,
}


@dataclass(frozen=True)
class ResolvedDimensionValue:
    id: str
    render: str
    validity: Validity
    attributes: Dict[str, Any] = field(default_factory=dict)
    fixture_refs: List[str] = field(default_factory=list)
    fact_refs: List[str] = field(default_factory=list)


def _iter_key_values(node: Any, key: str) -> Iterable[Any]:
    if isinstance(node, dict):
        for current_key, value in node.items():
            if current_key == key:
                yield value
            yield from _iter_key_values(value, key)
    elif isinstance(node, list):
        for value in node:
            yield from _iter_key_values(value, key)


class FactorPackageRegistry:
    """Strict loader and reference resolver for ``specs/`` V1 packages."""

    def __init__(self, specs_dir: Union[str, Path]):
        self.specs_dir = Path(specs_dir)
        self.factors: Dict[str, FactorPackageDef] = {}
        self.source_ledgers: Dict[str, FactorSourceLedgerDef] = {}
        self.syntaxes: Dict[str, FactorSyntaxDef] = {}
        self.manifests: Dict[str, FactorManifestDef] = {}
        self.matrices: Dict[str, FactorMatrixDef] = {}
        self.fixtures: Dict[str, FactorFixtureDef] = {}
        self.scenarios: Dict[str, FactorScenarioDef] = {}
        self.source_paths: Dict[str, Path] = {}
        self.fact_registry: Dict[str, FactDef] = {}
        self.fact_owners: Dict[str, str] = {}

    def load_all(self) -> None:
        for collection in (
            self.factors, self.source_ledgers, self.syntaxes, self.manifests, self.matrices,
            self.fixtures, self.scenarios, self.source_paths,
        ):
            collection.clear()
        self.fact_registry.clear()
        self.fact_owners.clear()

        errors: List[str] = []
        collections = {
            "factor": self.factors,
            "source_ledger": self.source_ledgers,
            "syntax": self.syntaxes,
            "manifest": self.manifests,
            "matrix": self.matrices,
            "fixture": self.fixtures,
            "scenario": self.scenarios,
        }
        all_ids: Dict[str, Path] = {}

        for path in sorted(self.specs_dir.rglob("*.yaml")):
            try:
                raw = yaml.safe_load(path.read_text(encoding="utf-8"))
                if not isinstance(raw, dict):
                    raise ValueError("YAML 顶层必须是对象")
                kind = raw.get("kind")
                model_type = V1_MODEL_BY_KIND.get(kind)
                if model_type is None:
                    raise ValueError(f"未知 kind: {kind!r}")
                spec = model_type(**raw)
                if spec.id in all_ids:
                    raise ValueError(f"重复顶层 ID '{spec.id}'；已由 {all_ids[spec.id]} 定义")
                all_ids[spec.id] = path
                collections[kind][spec.id] = spec
                self.source_paths[spec.id] = path
            except (OSError, yaml.YAMLError, ValidationError, ValueError) as exc:
                errors.append(f"{path}: {exc}")

        self._validate_references(errors)
        if errors:
            raise FactorPackageLoadError(errors)

    @staticmethod
    def _split_fact_ref(owner_factor_id: Optional[str], fact_ref: str) -> Tuple[Optional[str], Optional[str]]:
        if "::" not in fact_ref:
            return owner_factor_id, fact_ref or None
        if fact_ref.count("::") != 1:
            return None, None
        factor_id, fact_id = fact_ref.split("::", 1)
        if not factor_id or not fact_id:
            return None, None
        return factor_id, fact_id

    def resolve_fact_ref(
        self,
        owner_factor_id: Optional[str],
        fact_ref: str,
    ) -> Optional[FactDef]:
        """Resolve a local or ``factor_id::fact_id`` reference."""
        factor_id, fact_id = self._split_fact_ref(owner_factor_id, fact_ref)
        if factor_id is None or fact_id is None:
            return None
        if factor_id != owner_factor_id:
            target_factor = self.factors.get(factor_id)
            if target_factor is None or fact_id not in target_factor.exported_fact_refs:
                return None
        return self.fact_registry.get(f"{factor_id}::{fact_id}")

    def _local_fact_id(self, owner_factor_id: str, fact_ref: str) -> Optional[str]:
        factor_id, fact_id = self._split_fact_ref(owner_factor_id, fact_ref)
        return fact_id if factor_id == owner_factor_id else None

    def _validate_cross_fact_consumer_types(
        self,
        factor: FactorPackageDef,
        errors: List[str],
    ) -> Set[str]:
        consumed_refs: Set[str] = set()
        allowed_types = {
            "syntax": {"syntax", "example"},
            "rule": {"constraint", "example"},
            "structural_check": {"constraint", "example"},
            "dimension_value": {
                "syntax", "constraint", "environment", "example", "open_question",
            },
            "matrix": {
                "syntax", "constraint", "environment", "example", "open_question",
            },
            "fixture": {"environment", "example"},
            "scenario": {
                "constraint", "environment", "lifecycle", "behavior_oracle",
                "metadata_oracle", "example", "open_question",
            },
            "manifest_rule": {"constraint", "example", "open_question"},
            "environment_gate": {"environment"},
            "error_oracle": {"behavior_oracle"},
        }

        def check(refs: Iterable[str], consumer: str, path: Path) -> None:
            for fact_ref in refs:
                target_factor_id, _ = self._split_fact_ref(factor.id, fact_ref)
                if target_factor_id in (None, factor.id):
                    continue
                fact = self.resolve_fact_ref(factor.id, fact_ref)
                if fact is not None and fact.type not in allowed_types[consumer]:
                    errors.append(
                        f"{path}: 跨包 fact '{fact_ref}' type={fact.type!r} "
                        f"不能由 {consumer} 消费"
                    )
                elif fact is not None:
                    consumed_refs.add(fact_ref)

        factor_path = self.source_paths[factor.id]
        for rule in factor.rules:
            check(rule.fact_refs, "rule", factor_path)
        for structural_check in factor.structural_checks:
            check(structural_check.fact_refs, "structural_check", factor_path)
        for dimension in factor.dimensions.values():
            for equivalence_class in dimension.classes:
                for value in equivalence_class.values:
                    check(value.fact_refs, "dimension_value", factor_path)

        syntax = self.syntaxes.get(factor.syntax_ref)
        if syntax is not None:
            for refs in _iter_key_values(syntax.model_dump(), "source_fact_refs"):
                check(refs, "syntax", self.source_paths[syntax.id])
        for manifest_id in factor.manifest_refs:
            manifest = self.manifests.get(manifest_id)
            if manifest is None:
                continue
            manifest_path = self.source_paths[manifest.id]
            for local_rule in manifest.local_rules:
                check(local_rule.fact_refs, "manifest_rule", manifest_path)
            for requirement in manifest.environment_requirements:
                check(requirement.fact_refs, "environment_gate", manifest_path)
            check(manifest.expected.fact_refs, "error_oracle", manifest_path)
        for matrix_id in factor.matrix_refs:
            matrix = self.matrices.get(matrix_id)
            if matrix is not None:
                for refs in _iter_key_values(matrix.model_dump(), "fact_refs"):
                    check(refs, "matrix", self.source_paths[matrix.id])
        for fixture_id in factor.fixture_refs:
            fixture = self.fixtures.get(fixture_id)
            if fixture is not None:
                for refs in _iter_key_values(fixture.model_dump(), "fact_refs"):
                    check(refs, "fixture", self.source_paths[fixture.id])
        for scenario_id in factor.scenario_refs:
            scenario = self.scenarios.get(scenario_id)
            if scenario is not None:
                check(scenario.fact_refs, "scenario", self.source_paths[scenario.id])
        return consumed_refs

    def fixture_topological_order(self, fixture_refs: Iterable[str]) -> List[str]:
        """Expand fixture prerequisites and return setup order."""
        ordered: List[str] = []
        state: Dict[str, int] = {}
        stack: List[str] = []

        def visit(fixture_id: str) -> None:
            fixture = self.fixtures.get(fixture_id)
            if fixture is None:
                raise ValueError(f"fixture 依赖引用不存在: '{fixture_id}'")
            marker = state.get(fixture_id, 0)
            if marker == 2:
                return
            if marker == 1:
                start = stack.index(fixture_id)
                cycle = [*stack[start:], fixture_id]
                raise ValueError("fixture 依赖存在环: " + " -> ".join(cycle))
            state[fixture_id] = 1
            stack.append(fixture_id)
            for dependency_id in fixture.requires_fixture_refs:
                visit(dependency_id)
            stack.pop()
            state[fixture_id] = 2
            ordered.append(fixture_id)

        for fixture_id in fixture_refs:
            visit(fixture_id)
        return ordered

    def factor_dependency_graph(self) -> Dict[str, Set[str]]:
        """Build direct package dependencies from qualified facts and fixtures."""
        graph: Dict[str, Set[str]] = {factor_id: set() for factor_id in self.factors}

        def add_fact_dependencies(owner_factor_id: str, node: Any) -> None:
            for key in ("fact_refs", "source_fact_refs"):
                for refs in _iter_key_values(node, key):
                    if not isinstance(refs, list):
                        continue
                    for fact_ref in refs:
                        target_factor_id, _ = self._split_fact_ref(owner_factor_id, fact_ref)
                        if target_factor_id and target_factor_id != owner_factor_id:
                            graph[owner_factor_id].add(target_factor_id)

        for factor in self.factors.values():
            add_fact_dependencies(factor.id, factor.model_dump())
            related_entities = [
                entity
                for collection in (
                    self.syntaxes,
                    self.manifests,
                    self.matrices,
                    self.fixtures,
                    self.scenarios,
                )
                for entity in collection.values()
                if getattr(entity, "factor_ref", None) == factor.id
            ]
            root_fixture_ids: Set[str] = set(factor.fixture_refs)
            for entity in related_entities:
                raw = entity.model_dump()
                add_fact_dependencies(factor.id, raw)
                for refs in _iter_key_values(raw, "fixture_refs"):
                    if isinstance(refs, list):
                        root_fixture_ids.update(refs)
            try:
                ordered_fixture_ids = self.fixture_topological_order(root_fixture_ids)
            except ValueError:
                ordered_fixture_ids = sorted(root_fixture_ids)
            for fixture_id in ordered_fixture_ids:
                fixture = self.fixtures.get(fixture_id)
                if fixture is not None and fixture.factor_ref not in (None, factor.id):
                    graph[factor.id].add(fixture.factor_ref)
        return graph

    def factor_topological_order(
        self,
        factor_ids: Optional[Iterable[str]] = None,
    ) -> List[str]:
        """Return dependencies before consumers and reject dependency cycles."""
        graph = self.factor_dependency_graph()
        requested = set(factor_ids) if factor_ids is not None else set(graph)
        unknown = sorted(requested - set(graph))
        if unknown:
            raise ValueError(f"因子依赖引用不存在: {unknown}")
        closure = set(requested)
        pending = list(requested)
        while pending:
            factor_id = pending.pop()
            for dependency_id in graph[factor_id]:
                if dependency_id not in graph:
                    raise ValueError(
                        f"因子 '{factor_id}' 依赖不存在的因子 '{dependency_id}'"
                    )
                if dependency_id not in closure:
                    closure.add(dependency_id)
                    pending.append(dependency_id)

        ordered: List[str] = []
        state: Dict[str, int] = {}
        stack: List[str] = []

        def visit(factor_id: str) -> None:
            marker = state.get(factor_id, 0)
            if marker == 2:
                return
            if marker == 1:
                start = stack.index(factor_id)
                cycle = [*stack[start:], factor_id]
                raise ValueError("因子依赖存在环: " + " -> ".join(cycle))
            state[factor_id] = 1
            stack.append(factor_id)
            for dependency_id in sorted(graph[factor_id]):
                if dependency_id in closure:
                    visit(dependency_id)
            stack.pop()
            state[factor_id] = 2
            ordered.append(factor_id)

        for factor_id in sorted(closure):
            visit(factor_id)
        return ordered

    def _validate_references(self, errors: List[str]) -> None:
        all_entities: Dict[str, Any] = {}
        for collection in (
            self.factors, self.source_ledgers, self.syntaxes, self.manifests, self.matrices,
            self.fixtures, self.scenarios,
        ):
            all_entities.update(collection)

        all_fact_ids: Dict[str, FactDef] = {}
        all_rule_ids: Dict[str, FactorRuleDef] = {}
        for factor in self.factors.values():
            path = self.source_paths[factor.id]
            for label, items, target in (
                ("fact", factor.facts, all_fact_ids),
                ("rule", factor.rules, all_rule_ids),
            ):
                local_ids: Set[str] = set()
                for item in items:
                    if item.id in local_ids or item.id in target:
                        errors.append(f"{path}: 重复 {label} ID '{item.id}'")
                    local_ids.add(item.id)
                    target[item.id] = item
                    if label == "fact":
                        qualified_ref = f"{factor.id}::{item.id}"
                        self.fact_registry[qualified_ref] = item
                        self.fact_owners[qualified_ref] = factor.id

        # Collect actual, exported, correctly typed consumers before checking
        # providers. This must not depend on factor loading order, and exports
        # or source-ledger references alone are not consumption.
        external_used_fact_refs: Set[str] = set()
        for factor in self.factors.values():
            external_used_fact_refs.update(self._validate_cross_fact_consumer_types(factor, errors))
        for factor in self.factors.values():
            self._validate_factor(factor, errors, external_used_fact_refs)

        membership_fields = {
            "source_ledger": "source_ledger_ref",
            "syntax": "syntax_ref",
            "manifest": "manifest_refs",
            "matrix": "matrix_refs",
            "fixture": "fixture_refs",
            "scenario": "scenario_refs",
        }
        for kind, collection in (
            ("source_ledger", self.source_ledgers),
            ("syntax", self.syntaxes),
            ("manifest", self.manifests),
            ("matrix", self.matrices),
            ("fixture", self.fixtures),
            ("scenario", self.scenarios),
        ):
            for entity_id, entity in collection.items():
                factor_ref = getattr(entity, "factor_ref", None)
                if factor_ref is None and kind == "fixture":
                    continue
                factor = self.factors.get(factor_ref)
                if factor is None:
                    errors.append(
                        f"{self.source_paths[entity_id]}: factor_ref '{factor_ref}' 不存在"
                    )
                    continue
                field_name = membership_fields[kind]
                registered = getattr(factor, field_name)
                if kind in {"source_ledger", "syntax"}:
                    registered = [registered]
                if entity_id not in registered:
                    errors.append(
                        f"{self.source_paths[entity_id]}: 未登记到 factor '{factor_ref}' 的 {field_name}"
                    )

        for entity_id, entity in all_entities.items():
            path = self.source_paths[entity_id]
            raw = entity.model_dump()
            owner_factor_id = (
                entity.id
                if getattr(entity, "kind", None) == "factor"
                else getattr(entity, "factor_ref", None)
            )
            for values in _iter_key_values(raw, "fact_refs"):
                if not isinstance(values, list):
                    errors.append(f"{path}: fact_refs 必须是列表")
                    continue
                for fact_ref in values:
                    if self.resolve_fact_ref(owner_factor_id, fact_ref) is None:
                        errors.append(f"{path}: fact_refs 引用了不存在的 fact '{fact_ref}'")
            for values in _iter_key_values(raw, "source_fact_refs"):
                for fact_ref in values:
                    if self.resolve_fact_ref(owner_factor_id, fact_ref) is None:
                        errors.append(
                            f"{path}: source_fact_refs 引用了不存在的 fact '{fact_ref}'"
                        )

        for fixture in self.fixtures.values():
            path = self.source_paths[fixture.id]
            if fixture.provides.files:
                from .fixture_file_contract import inspect_fixture_files
                try:
                    inspect_fixture_files(fixture, path, self.specs_dir)
                except ValueError as exc:
                    errors.append(f"{path}: {exc}")
            if len(fixture.requires_fixture_refs) != len(set(fixture.requires_fixture_refs)):
                errors.append(f"{path}: requires_fixture_refs 不能重复")
            for dependency_id in fixture.requires_fixture_refs:
                if dependency_id not in self.fixtures:
                    errors.append(
                        f"{path}: requires_fixture_refs 引用不存在: '{dependency_id}'"
                    )
        try:
            self.fixture_topological_order(self.fixtures)
        except ValueError as exc:
            errors.append(str(exc))
        try:
            self.factor_topological_order()
        except ValueError as exc:
            errors.append(str(exc))

    def _validate_factor(
        self,
        factor: FactorPackageDef,
        errors: List[str],
        external_used_fact_refs: Set[str],
    ) -> None:
        path = self.source_paths[factor.id]
        factor_facts = {fact.id: fact for fact in factor.facts}
        if len(factor.exported_fact_refs) != len(set(factor.exported_fact_refs)):
            errors.append(f"{path}: exported_fact_refs 不能重复")
        for fact_id in factor.exported_fact_refs:
            fact = factor_facts.get(fact_id)
            if fact is None:
                errors.append(
                    f"{path}: exported_fact_refs 引用不存在的本地 fact '{fact_id}'"
                )
            elif fact.status != "confirmed":
                errors.append(
                    f"{path}: exported_fact_refs 只能导出 confirmed fact '{fact_id}'"
                )
        structural_ids: Set[str] = set()
        for check in factor.structural_checks:
            if check.id in structural_ids:
                errors.append(f"{path}: 重复 structural check ID '{check.id}'")
            structural_ids.add(check.id)
            for fact_ref in check.fact_refs:
                if self.resolve_fact_ref(factor.id, fact_ref) is None:
                    errors.append(
                        f"{path}: structural check '{check.id}' 引用了不存在的 fact '{fact_ref}'"
                    )
        syntax = self.syntaxes.get(factor.syntax_ref)
        if syntax is None:
            errors.append(f"{path}: syntax_ref '{factor.syntax_ref}' 不存在")
        elif syntax.factor_ref != factor.id:
            errors.append(f"{self.source_paths[syntax.id]}: factor_ref 应为 '{factor.id}'")
        else:
            referenced_slots = (
                syntax.production_placeholders()
                if syntax.production is not None
                else syntax.ast_slots()
            )
            if referenced_slots != set(syntax.slots):
                model_name = "production" if syntax.production is not None else "AST"
                errors.append(
                    f"{self.source_paths[syntax.id]}: {model_name} 与 slots 不一致: "
                    f"{sorted(referenced_slots ^ set(syntax.slots))}"
                )
            if syntax.ast is not None:
                unknown_subgrammars = sorted(
                    syntax.ast_subgrammar_refs() - set(syntax.subgrammars)
                )
                if unknown_subgrammars:
                    errors.append(
                        f"{self.source_paths[syntax.id]}: AST 引用未知 subgrammar: "
                        f"{unknown_subgrammars}"
                    )
            for slot_name, slot in syntax.slots.items():
                if slot.dimension_ref is None:
                    continue
                expected_ref = f"{factor.id}.{slot_name}"
                if slot.dimension_ref != expected_ref or slot_name not in factor.dimensions:
                    errors.append(
                        f"{self.source_paths[syntax.id]}: slot '{slot_name}' 应引用 '{expected_ref}'"
                    )

        ref_groups = {
            "source_ledger": [factor.source_ledger_ref],
            "manifest": factor.manifest_refs,
            "matrix": factor.matrix_refs,
            "fixture": factor.fixture_refs,
            "scenario": factor.scenario_refs,
        }
        expected_collections = {
            "source_ledger": self.source_ledgers,
            "manifest": self.manifests,
            "matrix": self.matrices,
            "fixture": self.fixtures,
            "scenario": self.scenarios,
        }
        for kind, refs in ref_groups.items():
            for reference in refs:
                entity = expected_collections[kind].get(reference)
                if entity is None:
                    errors.append(f"{path}: {kind}_refs 引用不存在: '{reference}'")
                elif getattr(entity, "factor_ref", factor.id) not in (None, factor.id):
                    errors.append(f"{self.source_paths[reference]}: factor_ref 与 '{factor.id}' 不一致")

        ledger = self.source_ledgers.get(factor.source_ledger_ref)
        if ledger is not None:
            ledger_path = self.source_paths[ledger.id]
            if ledger.artifact_sha256 != factor.source.artifact_sha256:
                errors.append(
                    f"{ledger_path}: artifact_sha256 与 factor.source.artifact_sha256 不一致"
                )
            unit_ids: Set[str] = set()
            ledgered_fact_ids: Set[str] = set()
            for unit in ledger.units:
                if unit.id in unit_ids:
                    errors.append(f"{ledger_path}: 重复 source unit ID '{unit.id}'")
                unit_ids.add(unit.id)
                ledgered_fact_ids.update(unit.fact_refs)
                for fact_id in unit.fact_refs:
                    fact = factor_facts.get(fact_id)
                    if fact is None:
                        errors.append(
                            f"{ledger_path}: source unit '{unit.id}' 引用其他因子或不存在的 fact '{fact_id}'"
                        )
                if unit.status == "open_question" and not any(
                    fact_id in factor_facts
                    and factor_facts[fact_id].type == "open_question"
                    and factor_facts[fact_id].status == "needs_verification"
                    for fact_id in unit.fact_refs
                ):
                    errors.append(
                        f"{ledger_path}: open_question source unit '{unit.id}' "
                        "必须引用 needs_verification open_question fact"
                    )
            missing_provenance = sorted(
                fact.id for fact in factor.facts
                if fact.status != "inferred" and fact.id not in ledgered_fact_ids
            )
            if missing_provenance:
                errors.append(
                    f"{ledger_path}: 非 inferred facts 没有 source unit 溯源: {missing_provenance}"
                )
            if factor.status == "ready":
                unmapped_units = sorted(
                    unit.id for unit in ledger.units if unit.status == "unmapped"
                )
                if unmapped_units:
                    errors.append(
                        f"{path}: ready factor 不能包含 unmapped source units: {unmapped_units}"
                    )

        resolved = self.resolve_dimension_values(factor.id, errors)
        if syntax is not None and syntax.ast is not None:
            ast_nodes = list(syntax.ast.walk())
            for subgrammar in syntax.subgrammars.values():
                ast_nodes.extend(subgrammar.walk())
            for node in ast_nodes:
                if node.kind == "choice":
                    selector_values = set(resolved.get(node.selector, {}))
                    branch_values = set(node.branches) - {"*"}
                    unknown = sorted(branch_values - selector_values)
                    missing = sorted(selector_values - branch_values)
                    if unknown:
                        errors.append(
                            f"{self.source_paths[syntax.id]}: AST choice '{node.selector}' "
                            f"包含未知 branch values: {unknown}"
                        )
                    if missing and "*" not in node.branches:
                        errors.append(
                            f"{self.source_paths[syntax.id]}: AST choice '{node.selector}' "
                            f"缺少 branch values: {missing}"
                        )
                elif node.kind == "optional":
                    selector_values = set(resolved.get(node.selector, {}))
                    unknown = sorted(set(node.enabled_values) - selector_values)
                    if unknown:
                        errors.append(
                            f"{self.source_paths[syntax.id]}: AST optional '{node.selector}' "
                            f"包含未知 enabled_values: {unknown}"
                        )
                elif node.kind == "repeat":
                    property_key = f"{node.slot}.properties.{node.items_property}"
                    missing_items = sorted(
                        value.id
                        for value in resolved.get(node.slot, {}).values()
                        if not isinstance(value.attributes.get(property_key), list)
                    )
                    if missing_items:
                        errors.append(
                            f"{self.source_paths[syntax.id]}: AST repeat '{node.slot}' "
                            f"的 values 缺少列表属性 {node.items_property}: {missing_items}"
                        )
        for dimension_id, dimension in factor.dimensions.items():
            if (
                dimension.default_value_id is not None
                and dimension.default_value_id not in resolved.get(dimension_id, {})
            ):
                errors.append(
                    f"{path}: dimension '{dimension_id}' 的 default_value_id "
                    f"'{dimension.default_value_id}' 不存在"
                )
        value_ids: List[str] = [item_id for values in resolved.values() for item_id in values]
        duplicates = sorted({item_id for item_id in value_ids if value_ids.count(item_id) > 1})
        if duplicates:
            errors.append(f"{path}: dimension/profile value ID 在因子包内重复: {duplicates}")

        available_names = set(factor.dimensions)
        for dimension_id, values in resolved.items():
            for value in values.values():
                available_names.update(value.attributes)

        for rule in factor.rules:
            confirmed = all(
                (fact := self.resolve_fact_ref(factor.id, fact_ref)) is not None
                and fact.status == "confirmed"
                for fact_ref in rule.fact_refs
            )
            if not rule.fact_refs or not confirmed:
                errors.append(f"{path}: 硬规则 '{rule.id}' 必须只引用 confirmed fact")
            try:
                solver = ConstraintSolver([rule.expression])
                solver.validate_references(available_names)
            except ConstraintError as exc:
                errors.append(f"{path}: 规则 '{rule.id}' 无效: {exc}")

        for manifest_id in factor.manifest_refs:
            manifest = self.manifests.get(manifest_id)
            if manifest is None:
                continue
            manifest_path = self.source_paths[manifest.id]
            if manifest.factor_ref != factor.id or manifest.syntax_ref != factor.syntax_ref:
                errors.append(f"{manifest_path}: factor_ref 或 syntax_ref 与因子包不一致")
            unknown_bindings = sorted(set(manifest.bindings) - set(factor.dimensions))
            if unknown_bindings:
                errors.append(
                    f"{manifest_path}: bindings 包含未知 dimensions: {unknown_bindings}"
                )
            missing_bindings = sorted(
                dimension_id
                for dimension_id, dimension in factor.dimensions.items()
                if dimension_id not in manifest.bindings
                and dimension.default_value_id is None
            )
            if missing_bindings:
                errors.append(
                    f"{manifest_path}: bindings 缺少没有 default_value_id 的 dimensions: "
                    f"{missing_bindings}"
                )
            effective_bindings = dict(manifest.bindings)
            for dimension_id, dimension in factor.dimensions.items():
                if (
                    dimension_id not in effective_bindings
                    and dimension.default_value_id is not None
                ):
                    effective_bindings[dimension_id] = [dimension.default_value_id]
            for dimension_id, selected_ids in effective_bindings.items():
                allowed = resolved.get(dimension_id, {})
                for selected_id in selected_ids:
                    if selected_id not in allowed:
                        errors.append(
                            f"{manifest_path}: binding '{dimension_id}' 引用未知值 '{selected_id}'"
                        )
                    elif (
                        manifest.suite_type == "positive"
                        and allowed[selected_id].validity != "valid"
                    ):
                        errors.append(
                            f"{manifest_path}: positive manifest 不能绑定 "
                            f"validity={allowed[selected_id].validity!r} 的值 "
                            f"'{dimension_id}.{selected_id}'"
                        )
            for fixture_id in manifest.fixture_refs:
                if fixture_id not in self.fixtures:
                    errors.append(f"{manifest_path}: fixture_refs 引用不存在: '{fixture_id}'")
            requirement_keys = [
                requirement.key for requirement in manifest.environment_requirements
            ]
            if len(requirement_keys) != len(set(requirement_keys)):
                errors.append(
                    f"{manifest_path}: environment_requirements 的 key 不能重复"
                )
            for requirement in manifest.environment_requirements:
                for fact_ref in requirement.fact_refs:
                    fact = self.resolve_fact_ref(factor.id, fact_ref)
                    if (
                        fact is None
                        or fact.status != "confirmed"
                        or fact.type != "environment"
                    ):
                        errors.append(
                            f"{manifest_path}: environment requirement 的 fact_refs "
                            "必须引用 confirmed environment fact: "
                            f"'{fact_ref}'"
                        )
            if manifest.suite_type == "negative" and not manifest.violates_rule_refs:
                errors.append(f"{manifest_path}: negative manifest 必须声明 violates_rule_refs")
            for rule_id in manifest.violates_rule_refs:
                if rule_id not in {rule.id for rule in factor.rules}:
                    errors.append(f"{manifest_path}: violates_rule_refs 引用未知规则 '{rule_id}'")
            if (
                manifest.expected.default == "error"
                and manifest.expected.oracle_status == "confirmed"
            ):
                for fact_ref in manifest.expected.fact_refs:
                    fact = self.resolve_fact_ref(factor.id, fact_ref)
                    if (
                        fact is None
                        or fact.status != "confirmed"
                        or fact.type != "behavior_oracle"
                    ):
                        errors.append(
                            f"{manifest_path}: confirmed error Oracle 的 fact_refs "
                            f"必须引用 confirmed behavior_oracle: '{fact_ref}'"
                        )
            for index, local_rule in enumerate(manifest.local_rules):
                for fact_ref in local_rule.fact_refs:
                    if self.resolve_fact_ref(factor.id, fact_ref) is None:
                        errors.append(
                            f"{manifest_path}: local_rules[{index}] 引用了不存在的 fact '{fact_ref}'"
                        )
                try:
                    solver = ConstraintSolver([local_rule.expression])
                    solver.validate_references(available_names)
                except ConstraintError as exc:
                    errors.append(f"{manifest_path}: local_rules[{index}] 无效: {exc}")

        factor_feature_ids: Set[str] = set()
        for matrix_id in factor.matrix_refs:
            matrix = self.matrices.get(matrix_id)
            if matrix is None:
                continue
            profile_ids = {profile.id for profile in matrix.profiles}
            feature_ids: Set[str] = set()
            for feature in matrix.all_documented_features:
                if feature.id in feature_ids or feature.id in factor_feature_ids:
                    errors.append(
                        f"{self.source_paths[matrix.id]}: 因子内重复 documented feature '{feature.id}'"
                    )
                feature_ids.add(feature.id)
                factor_feature_ids.add(feature.id)
                for profile_id in feature.profile_refs:
                    if profile_id not in profile_ids:
                        errors.append(
                            f"{self.source_paths[matrix.id]}: feature '{feature.id}' 引用未知 profile '{profile_id}'"
                        )
                all_dimension_value_ids = {
                    value_id for values in resolved.values() for value_id in values
                }
                for value_id in feature.value_refs:
                    if value_id not in all_dimension_value_ids:
                        errors.append(
                            f"{self.source_paths[matrix.id]}: feature '{feature.id}' "
                            f"引用未知 dimension value '{value_id}'"
                        )
                if feature.status == "needs_profile" and not any(
                    (fact := self.resolve_fact_ref(factor.id, fact_ref)) is not None
                    and fact.type == "open_question"
                    and fact.status == "needs_verification"
                    for fact_ref in feature.fact_refs
                ):
                    errors.append(
                        f"{self.source_paths[matrix.id]}: needs_profile feature '{feature.id}' "
                        "必须引用 needs_verification open_question"
                    )
            for profile in matrix.profiles:
                for fixture_id in profile.fixture_refs:
                    if fixture_id not in self.fixtures:
                        errors.append(
                            f"{self.source_paths[matrix.id]}: profile '{profile.id}' 引用未知 fixture '{fixture_id}'"
                        )

        for dimension_id, dimension in factor.dimensions.items():
            if dimension.profile_source is not None:
                continue
            for equivalence_class in dimension.classes:
                for value in equivalence_class.values:
                    for fixture_id in value.fixture_refs:
                        fixture = self.fixtures.get(fixture_id)
                        if fixture is None:
                            errors.append(
                                f"{path}: dimension '{dimension_id}' value '{value.id}' "
                                f"引用未知 fixture '{fixture_id}'"
                            )
                        elif fixture.factor_ref not in (None, factor.id):
                            errors.append(
                                f"{path}: dimension '{dimension_id}' value '{value.id}' "
                                f"引用了其他因子的 fixture '{fixture_id}'"
                            )

        for scenario_id in factor.scenario_refs:
            scenario = self.scenarios.get(scenario_id)
            if scenario is None:
                continue
            scenario_path = self.source_paths[scenario.id]
            for fixture_id in scenario.fixture_refs:
                fixture = self.fixtures.get(fixture_id)
                if fixture is None:
                    errors.append(
                        f"{scenario_path}: fixture_refs 引用不存在: '{fixture_id}'"
                    )
                elif fixture.factor_ref not in (None, factor.id):
                    errors.append(
                        f"{scenario_path}: fixture_refs 引用了其他因子的 fixture "
                        f"'{fixture_id}'"
                    )

        used_fact_ids = {
            local_fact_id
            for refs in (
                *(rule.fact_refs for rule in factor.rules),
                *(check.fact_refs for check in factor.structural_checks),
            )
            for fact_ref in refs
            for local_fact_id in [self._local_fact_id(factor.id, fact_ref)]
            if local_fact_id is not None
        }
        for dimension in factor.dimensions.values():
            for equivalence_class in dimension.classes:
                for value in equivalence_class.values:
                    used_fact_ids.update(
                        local_fact_id
                        for fact_ref in value.fact_refs
                        for local_fact_id in [self._local_fact_id(factor.id, fact_ref)]
                        if local_fact_id is not None
                    )
        related_entities = [syntax] if syntax is not None else []
        related_entities.extend(
            entity
            for refs, collection in (
                (factor.manifest_refs, self.manifests),
                (factor.matrix_refs, self.matrices),
                (factor.fixture_refs, self.fixtures),
                (factor.scenario_refs, self.scenarios),
            )
            for entity_id in refs
            for entity in [collection.get(entity_id)]
            if entity is not None
        )
        for entity in related_entities:
            raw = entity.model_dump()
            for values in _iter_key_values(raw, "fact_refs"):
                for fact_ref in values:
                    if self.resolve_fact_ref(factor.id, fact_ref) is None:
                        errors.append(
                            f"{self.source_paths[entity.id]}: 引用了不存在的 fact '{fact_ref}'"
                        )
                    local_fact_id = self._local_fact_id(factor.id, fact_ref)
                    if local_fact_id is not None:
                        used_fact_ids.add(local_fact_id)
            for values in _iter_key_values(raw, "source_fact_refs"):
                for fact_ref in values:
                    if self.resolve_fact_ref(factor.id, fact_ref) is None:
                        errors.append(
                            f"{self.source_paths[entity.id]}: 引用了不存在的 fact '{fact_ref}'"
                        )
                    local_fact_id = self._local_fact_id(factor.id, fact_ref)
                    if local_fact_id is not None:
                        used_fact_ids.add(local_fact_id)
        uncovered = sorted(
            fact.id for fact in factor.facts
            if fact.status == "confirmed"
            and fact.type != "example"
            and fact.id not in used_fact_ids
            and f"{factor.id}::{fact.id}" not in external_used_fact_refs
        )
        if uncovered:
            errors.append(f"{path}: confirmed facts 没有规格消费者: {uncovered}")

    def resolve_dimension_values(
        self, factor_id: str, errors: Optional[List[str]] = None
    ) -> Dict[str, Dict[str, ResolvedDimensionValue]]:
        factor = self.factors.get(factor_id)
        if factor is None:
            return {}
        target_errors = errors if errors is not None else []
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]] = {}
        for dimension_id, dimension in factor.dimensions.items():
            values: Dict[str, ResolvedDimensionValue] = {}
            if dimension.profile_source is not None:
                matrix = self.matrices.get(dimension.profile_source.matrix_ref)
                if matrix is None:
                    target_errors.append(
                        f"{self.source_paths[factor.id]}: dimension '{dimension_id}' 引用未知 matrix "
                        f"'{dimension.profile_source.matrix_ref}'"
                    )
                else:
                    for profile in matrix.profiles:
                        properties = {
                            **matrix.profile_property_defaults,
                            **profile.properties,
                        }
                        attributes = self._flatten_attributes(dimension_id, properties)
                        values[profile.id] = ResolvedDimensionValue(
                            id=profile.id,
                            render=profile.render,
                            validity=profile.validity,
                            attributes=attributes,
                            fixture_refs=list(profile.fixture_refs),
                            fact_refs=list(profile.fact_refs),
                        )
            else:
                for equivalence_class in dimension.classes:
                    for value in equivalence_class.values:
                        attributes = self._flatten_attributes(dimension_id, value.properties, "properties")
                        if value.output_column_count is not None:
                            attributes[f"{dimension_id}.output_column_count"] = value.output_column_count
                        if value.id in values:
                            target_errors.append(
                                f"{self.source_paths[factor.id]}: dimension '{dimension_id}' 重复 value ID '{value.id}'"
                            )
                        values[value.id] = ResolvedDimensionValue(
                            id=value.id,
                            render=value.render,
                            validity=value.validity,
                            attributes=attributes,
                            fixture_refs=list(value.fixture_refs),
                            fact_refs=list(value.fact_refs),
                        )
            resolved[dimension_id] = values
        return resolved

    @staticmethod
    def _flatten_attributes(
        dimension_id: str, properties: Dict[str, Any], prefix: str = "properties"
    ) -> Dict[str, Any]:
        flattened: Dict[str, Any] = {}
        for key, value in properties.items():
            flattened[f"{dimension_id}.{prefix}.{key}"] = value
        return flattened

    def get_factor(self, factor_id: str) -> Optional[FactorPackageDef]:
        return self.factors.get(factor_id)

    def get_source_ledger(self, ledger_id: str) -> Optional[FactorSourceLedgerDef]:
        return self.source_ledgers.get(ledger_id)

    def get_syntax(self, syntax_id: str) -> Optional[FactorSyntaxDef]:
        return self.syntaxes.get(syntax_id)

    def get_manifest(self, manifest_id: str) -> Optional[FactorManifestDef]:
        return self.manifests.get(manifest_id)

    def get_fixture(self, fixture_id: str) -> Optional[FactorFixtureDef]:
        return self.fixtures.get(fixture_id)
