"""静态规格的数据契约与严格注册表。

规格由 grammar、matrix、manifest 和最小静态 fixture 四类文件组成。注册表
在加载期完成 YAML、字段、引用和约束校验；出现任一错误即整体失败，避免
“跳过坏文件后继续生成”造成虚假覆盖结论。
"""
from __future__ import annotations

import os
import re
from typing import Any, Dict, Iterable, List, Literal, Optional, Set

import yaml
from pydantic import BaseModel, ConfigDict, Field, ValidationError, model_validator

from .constraint_solver import ConstraintError, ConstraintSolver


class SpecLoadError(ValueError):
    """一次加载中发现的全部规格错误。"""

    def __init__(self, errors: List[str]):
        self.errors = errors
        message = "规格加载失败:\n" + "\n".join(f"- {error}" for error in errors)
        super().__init__(message)


class StrictSpecModel(BaseModel):
    """规格文件不允许未知字段，防止 YAML 拼写错误被静默忽略。"""

    model_config = ConfigDict(extra="forbid")


# ------------------------------------------------------------------------------
# Grammar
# ------------------------------------------------------------------------------

class SlotDef(StrictSpecModel):
    type: str = "token"  # token | identifier | element_list | query | optional_group
    optional: bool = False
    delimiter: str = ", "
    min_elements: int = 1
    max_elements: int = 5
    values: List[str] = Field(default_factory=list)
    allowed_sub_grammars: List[str] = Field(default_factory=list)
    symbol_action: Optional[str] = None
    filter: Dict[str, Any] = Field(default_factory=dict)


class SubGrammarDef(StrictSpecModel):
    production: str
    slots: Dict[str, SlotDef] = Field(default_factory=dict)


class SyntaxDef(StrictSpecModel):
    id: str
    name: str
    category: str = "DDL"
    doc_ref: str = ""
    description: str = ""
    production: str
    slots: Dict[str, SlotDef] = Field(default_factory=dict)
    sub_grammars: Dict[str, SubGrammarDef] = Field(default_factory=dict)

    @model_validator(mode="before")
    @classmethod
    def normalize_slots(cls, data: Any) -> Any:
        """支持 ``slots: {modifier: ['', 'TEMP']}`` 简写。"""
        if isinstance(data, dict) and isinstance(data.get("slots"), dict):
            normalized: Dict[str, Any] = {}
            for name, value in data["slots"].items():
                if isinstance(value, list):
                    normalized[name] = {"values": value, "type": "token"}
                elif isinstance(value, dict):
                    normalized[name] = value
                else:
                    normalized[name] = {"values": [str(value)], "type": "token"}
            data = dict(data)
            data["slots"] = normalized
        return data

    def all_slot_names(self) -> Set[str]:
        names = set(self.slots)
        for sub_grammar in self.sub_grammars.values():
            names.update(sub_grammar.slots)
        return names

    def production_placeholders(self) -> Set[str]:
        return set(re.findall(r"\{([A-Za-z_][A-Za-z0-9_]*)\}", self.production))


# ------------------------------------------------------------------------------
# Matrix
# ------------------------------------------------------------------------------

class DataTypeDef(StrictSpecModel):
    category: str = "numeric"
    representative: str = "100"
    boundary_values: List[str] = Field(default_factory=list)
    invalid_values: List[str] = Field(default_factory=list)
    expected_sqlstates_for_invalid: List[str] = Field(default_factory=list)


class MatrixDef(StrictSpecModel):
    id: str
    name: str
    description: str = ""
    data_types: Dict[str, DataTypeDef] = Field(default_factory=dict)
    storage_engines: Dict[str, Dict[str, Any]] = Field(default_factory=dict)
    compatibility_rules: List[str] = Field(default_factory=list)
    # GUC 矩阵当前仅归档，仍使用严格的顶层字段名，内部结构保持开放。
    guc_parameters: Dict[str, Any] = Field(default_factory=dict)


# ------------------------------------------------------------------------------
# Static fixtures (no SQL execution)
# ------------------------------------------------------------------------------

class FixtureColumnDef(StrictSpecModel):
    name: str
    type: str


class FixtureTableDef(StrictSpecModel):
    name: str
    columns: List[FixtureColumnDef] = Field(default_factory=list)
    storage_engine: str = "ASTORE"
    partition_type: Optional[str] = None
    temporary: bool = False

    @model_validator(mode="after")
    def ensure_unique_columns(self) -> "FixtureTableDef":
        names = [column.name for column in self.columns]
        if len(names) != len(set(names)):
            raise ValueError(f"fixture 表 '{self.name}' 存在重复列名")
        return self


class FixtureDef(StrictSpecModel):
    id: str
    name: str
    description: str = ""
    doc_ref: str = ""
    tables: List[FixtureTableDef] = Field(default_factory=list)

    @model_validator(mode="after")
    def ensure_unique_tables(self) -> "FixtureDef":
        names = [table.name for table in self.tables]
        if len(names) != len(set(names)):
            raise ValueError(f"fixture '{self.id}' 存在重复表名")
        return self


# ------------------------------------------------------------------------------
# Manifest
# ------------------------------------------------------------------------------

class ManifestDef(StrictSpecModel):
    id: str
    name: str
    description: str = ""
    doc_ref: str = ""
    target_syntax: str
    import_matrices: List[str] = Field(default_factory=list)
    fixtures: List[str] = Field(default_factory=list)
    bindings: Dict[str, List[str]] = Field(default_factory=dict)
    strategy: Literal["pairwise", "equivalence", "full_cartesian"] = "pairwise"
    default_expected: Literal["success", "error"] = "success"
    high_priority_dimensions: List[List[str]] = Field(default_factory=list)
    additional_constraints: List[str] = Field(default_factory=list)
    max_search_nodes: int = 200_000
    max_cartesian_combinations: int = 100_000

    @model_validator(mode="after")
    def ensure_nonempty_bindings(self) -> "ManifestDef":
        empty = [name for name, values in self.bindings.items() if not values]
        if empty:
            raise ValueError(f"bindings 中存在空值域: {', '.join(empty)}")
        if self.max_search_nodes <= 0 or self.max_cartesian_combinations <= 0:
            raise ValueError("搜索与笛卡尔积预算必须为正数")
        return self


class SpecRegistry:
    """加载并验证四类静态规格。"""

    def __init__(self, base_dir: str):
        self.base_dir = base_dir
        self.grammars_dir = os.path.join(base_dir, "grammars")
        self.matrices_dir = os.path.join(base_dir, "matrices")
        self.manifests_dir = os.path.join(base_dir, "manifests")
        self.fixtures_dir = os.path.join(base_dir, "fixtures")

        self.syntaxes: Dict[str, SyntaxDef] = {}
        self.matrices: Dict[str, MatrixDef] = {}
        self.manifests: Dict[str, ManifestDef] = {}
        self.fixtures: Dict[str, FixtureDef] = {}
        self.source_paths: Dict[str, Dict[str, str]] = {
            "syntax": {}, "matrix": {}, "manifest": {}, "fixture": {}
        }

    def load_all(self) -> None:
        self.syntaxes.clear()
        self.matrices.clear()
        self.manifests.clear()
        self.fixtures.clear()
        for paths in self.source_paths.values():
            paths.clear()

        errors: List[str] = []
        self._load_directory(self.grammars_dir, SyntaxDef, self.syntaxes, "syntax", errors)
        self._load_directory(self.matrices_dir, MatrixDef, self.matrices, "matrix", errors)
        self._load_directory(self.fixtures_dir, FixtureDef, self.fixtures, "fixture", errors)
        self._load_directory(self.manifests_dir, ManifestDef, self.manifests, "manifest", errors)
        self._validate_references(errors)
        if errors:
            raise SpecLoadError(errors)

    def _load_directory(self, directory: str, model_type: Any, target: Dict[str, Any],
                        kind: str, errors: List[str]) -> None:
        if not os.path.isdir(directory):
            return
        for root, _, files in os.walk(directory):
            for filename in sorted(files):
                if not filename.endswith((".yaml", ".yml")):
                    continue
                path = os.path.join(root, filename)
                try:
                    with open(path, "r", encoding="utf-8") as handle:
                        raw = yaml.safe_load(handle)
                    if not isinstance(raw, dict):
                        raise ValueError("YAML 顶层必须是对象")
                    spec = model_type(**raw)
                    if spec.id in target:
                        prior = self.source_paths[kind][spec.id]
                        raise ValueError(f"重复 ID '{spec.id}'；已由 {prior} 定义")
                    target[spec.id] = spec
                    self.source_paths[kind][spec.id] = path
                except (OSError, yaml.YAMLError, ValidationError, ValueError) as exc:
                    errors.append(f"{path}: {exc}")

    def _validate_references(self, errors: List[str]) -> None:
        for syntax_id, syntax in self.syntaxes.items():
            placeholders = syntax.production_placeholders()
            undeclared = sorted(placeholders - set(syntax.slots))
            if undeclared:
                errors.append(
                    f"{self.source_paths['syntax'][syntax_id]}: production 引用了未声明 slot: "
                    f"{', '.join(undeclared)}"
                )
            unused = sorted(set(syntax.slots) - placeholders)
            if unused:
                errors.append(
                    f"{self.source_paths['syntax'][syntax_id]}: slots 未被 production 消费: "
                    f"{', '.join(unused)}"
                )
            for sub_name in syntax.sub_grammars:
                if sub_name not in {
                    name for slot in syntax.slots.values() for name in slot.allowed_sub_grammars
                }:
                    errors.append(
                        f"{self.source_paths['syntax'][syntax_id]}: sub_grammar '{sub_name}' 没有被任何 slot 引用"
                    )

        for matrix_id, matrix in self.matrices.items():
            try:
                ConstraintSolver(matrix.compatibility_rules)
            except ConstraintError as exc:
                errors.append(f"{self.source_paths['matrix'][matrix_id]}: 兼容性规则错误: {exc}")

        for manifest_id, manifest in self.manifests.items():
            path = self.source_paths["manifest"][manifest_id]
            syntax = self.syntaxes.get(manifest.target_syntax)
            if syntax is None:
                errors.append(f"{path}: target_syntax '{manifest.target_syntax}' 不存在")
                continue

            available_names = syntax.all_slot_names()
            unknown_bindings = sorted(set(manifest.bindings) - available_names)
            if unknown_bindings:
                errors.append(f"{path}: bindings 引用了未知 slot: {', '.join(unknown_bindings)}")
            missing_matrices = sorted(set(manifest.import_matrices) - set(self.matrices))
            if missing_matrices:
                errors.append(f"{path}: 引用了不存在的 matrix: {', '.join(missing_matrices)}")
            missing_fixtures = sorted(set(manifest.fixtures) - set(self.fixtures))
            if missing_fixtures:
                errors.append(f"{path}: 引用了不存在的 fixture: {', '.join(missing_fixtures)}")
            for dimension_pair in manifest.high_priority_dimensions:
                if len(dimension_pair) != 2:
                    errors.append(f"{path}: high_priority_dimensions 每项必须恰好有两个维度")
                elif any(name not in available_names for name in dimension_pair):
                    errors.append(f"{path}: high_priority_dimensions 引用了未知 slot: {dimension_pair}")

            all_rules: List[str] = list(manifest.additional_constraints)
            for matrix_ref in manifest.import_matrices:
                matrix = self.matrices.get(matrix_ref)
                if matrix:
                    all_rules.extend(matrix.compatibility_rules)
            try:
                solver = ConstraintSolver(all_rules)
                solver.validate_references(available_names)
            except ConstraintError as exc:
                errors.append(f"{path}: 约束规则错误: {exc}")

    def get_syntax(self, syntax_id: str) -> Optional[SyntaxDef]:
        return self.syntaxes.get(syntax_id)

    def get_matrix(self, matrix_id: str) -> Optional[MatrixDef]:
        return self.matrices.get(matrix_id)

    def get_manifest(self, manifest_id: str) -> Optional[ManifestDef]:
        return self.manifests.get(manifest_id)

    def get_fixture(self, fixture_id: str) -> Optional[FixtureDef]:
        return self.fixtures.get(fixture_id)
