"""Factor Package Schema V1 models and strict registry."""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, Iterable, List, Literal, Optional, Set, Union

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


class SourceDef(StrictV1Model):
    product: str
    document: str
    version: str
    artifact_sha256: str
    extraction_date: str


class DimensionValueDef(StrictV1Model):
    id: str
    render: str
    representative: bool
    validity: Validity
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
        return self


class IgnoredSourceLineDef(StrictV1Model):
    line: int = Field(ge=1)
    rationale: str = Field(min_length=1)


class SupplementalSourceDef(StrictV1Model):
    id: str
    document: str
    version: str
    url: str
    retrieval_date: str
    source_anchor: str


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

    @model_validator(mode="after")
    def ensure_every_source_line_is_accounted_for(self) -> "FactorSourceLedgerDef":
        unit_lines: Set[int] = set()
        for unit in self.units:
            if unit.line_end > self.source_line_count:
                raise ValueError(
                    f"source unit '{unit.id}' 超出原文总行数 {self.source_line_count}"
                )
            unit_lines.update(range(unit.line_start, unit.line_end + 1))
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
    fact_refs: List[str] = Field(default_factory=list)

    @property
    def coverage_refs(self) -> List[str]:
        return [*self.profile_refs, *self.value_refs]

    @model_validator(mode="after")
    def ensure_status_matches_profiles(self) -> "DocumentedFeatureCoverageDef":
        if self.status == "covered" and not self.coverage_refs:
            raise ValueError("covered feature 必须至少引用一个 profile 或 dimension value")
        if self.status == "needs_profile" and self.coverage_refs:
            raise ValueError("needs_profile feature 不能引用尚未确认的覆盖值")
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


class FixtureProvidesDef(StrictV1Model):
    tables: List[FixtureTableV1Def] = Field(default_factory=list)


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
    sqlstates: List[str] = Field(default_factory=list)
    error_category: Optional[str] = None
    error_message_regex: Optional[str] = None

    @model_validator(mode="after")
    def ensure_target_error_oracle(self) -> "ExpectedDef":
        if self.default == "success":
            if self.sqlstates or self.error_category or self.error_message_regex:
                raise ValueError("success expected 不能声明错误 Oracle")
            return self
        if not self.error_category:
            raise ValueError("error expected 必须声明 error_category")
        if not self.sqlstates and not self.error_message_regex:
            raise ValueError("error expected 必须声明 sqlstates 或 error_message_regex")
        if self.error_message_regex:
            try:
                re.compile(self.error_message_regex)
            except re.error as exc:
                raise ValueError(f"error_message_regex 无效: {exc}") from exc
        return self


class CoverageRequirementDef(StrictV1Model):
    strength: Literal[2]
    require_all_feasible_pairs: Literal[True]


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

    def load_all(self) -> None:
        for collection in (
            self.factors, self.source_ledgers, self.syntaxes, self.manifests, self.matrices,
            self.fixtures, self.scenarios, self.source_paths,
        ):
            collection.clear()

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

        for factor in self.factors.values():
            self._validate_factor(factor, errors)

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
            for values in _iter_key_values(raw, "fact_refs"):
                if not isinstance(values, list):
                    errors.append(f"{path}: fact_refs 必须是列表")
                    continue
                for fact_id in values:
                    if fact_id not in all_fact_ids:
                        errors.append(f"{path}: fact_refs 引用了不存在的 fact '{fact_id}'")
            for values in _iter_key_values(raw, "source_fact_refs"):
                for fact_id in values:
                    if fact_id not in all_fact_ids:
                        errors.append(f"{path}: source_fact_refs 引用了不存在的 fact '{fact_id}'")

    def _validate_factor(
        self,
        factor: FactorPackageDef,
        errors: List[str],
    ) -> None:
        path = self.source_paths[factor.id]
        factor_facts = {fact.id: fact for fact in factor.facts}
        structural_ids: Set[str] = set()
        for check in factor.structural_checks:
            if check.id in structural_ids:
                errors.append(f"{path}: 重复 structural check ID '{check.id}'")
            structural_ids.add(check.id)
            for fact_id in check.fact_refs:
                if fact_id not in factor_facts:
                    errors.append(
                        f"{path}: structural check '{check.id}' 引用了不存在的 fact '{fact_id}'"
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
                fact_id in factor_facts and factor_facts[fact_id].status == "confirmed"
                for fact_id in rule.fact_refs
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
            if manifest.suite_type == "negative" and not manifest.violates_rule_refs:
                errors.append(f"{manifest_path}: negative manifest 必须声明 violates_rule_refs")
            for rule_id in manifest.violates_rule_refs:
                if rule_id not in {rule.id for rule in factor.rules}:
                    errors.append(f"{manifest_path}: violates_rule_refs 引用未知规则 '{rule_id}'")
            for index, local_rule in enumerate(manifest.local_rules):
                for fact_id in local_rule.fact_refs:
                    if fact_id not in factor_facts:
                        errors.append(
                            f"{manifest_path}: local_rules[{index}] 引用了其他因子或不存在的 fact '{fact_id}'"
                        )
                try:
                    solver = ConstraintSolver([local_rule.expression])
                    solver.validate_references(available_names)
                except ConstraintError as exc:
                    errors.append(f"{manifest_path}: local_rules[{index}] 无效: {exc}")

        for matrix_id in factor.matrix_refs:
            matrix = self.matrices.get(matrix_id)
            if matrix is None:
                continue
            profile_ids = {profile.id for profile in matrix.profiles}
            feature_ids: Set[str] = set()
            for feature in matrix.all_documented_features:
                if feature.id in feature_ids:
                    errors.append(
                        f"{self.source_paths[matrix.id]}: 重复 documented feature '{feature.id}'"
                    )
                feature_ids.add(feature.id)
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
                    fact_id in factor_facts
                    and factor_facts[fact_id].type == "open_question"
                    and factor_facts[fact_id].status == "needs_verification"
                    for fact_id in feature.fact_refs
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

        used_fact_ids = {
            fact_id
            for rule in factor.rules
            for fact_id in rule.fact_refs
        }
        used_fact_ids.update(
            fact_id
            for check in factor.structural_checks
            for fact_id in check.fact_refs
        )
        for dimension in factor.dimensions.values():
            for equivalence_class in dimension.classes:
                for value in equivalence_class.values:
                    used_fact_ids.update(value.fact_refs)
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
                for fact_id in values:
                    if fact_id not in factor_facts:
                        errors.append(
                            f"{self.source_paths[entity.id]}: 引用了其他因子或不存在的 fact '{fact_id}'"
                        )
                used_fact_ids.update(values)
            for values in _iter_key_values(raw, "source_fact_refs"):
                for fact_id in values:
                    if fact_id not in factor_facts:
                        errors.append(
                            f"{self.source_paths[entity.id]}: 引用了其他因子或不存在的 fact '{fact_id}'"
                        )
                used_fact_ids.update(values)
        uncovered = sorted(
            fact.id for fact in factor.facts
            if fact.status == "confirmed"
            and fact.type != "example"
            and fact.id not in used_fact_ids
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
