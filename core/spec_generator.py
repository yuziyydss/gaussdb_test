"""静态规格生成器：规格 → 已验证的 SQL 测试计划。

本模块不连接数据库。它只负责选择合法组合、证明覆盖、渲染 SQL，并验证
fixture 声明的表/列与简单查询、视图别名之间的一致性。
"""
from __future__ import annotations

import hashlib
import math
import re
from dataclasses import dataclass, field
from itertools import combinations
from typing import Any, Dict, Iterable, List, Optional, Set, Tuple

from .combinator import Pair, PairwiseGenerationError, PairwiseResult, generate_cartesian, generate_constraint_aware_pairwise
from .constraint_solver import ConstraintSolver
from .generator import GeneratedCase, _clean_sql
from .spec_model import FixtureDef, ManifestDef, MatrixDef, SlotDef, SpecRegistry, SyntaxDef
from .symbol_table import ColumnSymbol, SchemaContext, TableSymbol


class GenerationValidationError(ValueError):
    """规格虽然能加载，但无法生成可证明的静态用例。"""


@dataclass
class GenerationReport:
    """一次生成的覆盖与可行性证据。"""

    manifest_id: str
    strategy: str
    candidate_combination_estimate: int
    feasible_pair_count: int
    covered_pair_count: int
    feasible_combination_count: Optional[int] = None
    missing_pairs: List[Pair] = field(default_factory=list)
    generated_case_count: int = 0
    duplicate_case_ids: List[str] = field(default_factory=list)
    filtered_pair_reasons: Dict[str, int] = field(default_factory=dict)
    search_nodes: int = 0
    high_priority_pair_count: int = 0
    covered_high_priority_pair_count: int = 0

    @property
    def pairwise_complete(self) -> bool:
        return not self.missing_pairs and self.covered_pair_count == self.feasible_pair_count

    def to_dict(self) -> Dict[str, Any]:
        return {
            "manifest_id": self.manifest_id,
            "strategy": self.strategy,
            "candidate_combination_estimate": self.candidate_combination_estimate,
            "feasible_combination_count": self.feasible_combination_count,
            "feasible_pair_count": self.feasible_pair_count,
            "covered_pair_count": self.covered_pair_count,
            "missing_pairs": [list(pair) for pair in self.missing_pairs],
            "pairwise_complete": self.pairwise_complete,
            "generated_case_count": self.generated_case_count,
            "duplicate_case_ids": self.duplicate_case_ids,
            "filtered_pair_reasons": dict(self.filtered_pair_reasons),
            "search_nodes": self.search_nodes,
            "high_priority_pair_count": self.high_priority_pair_count,
            "covered_high_priority_pair_count": self.covered_high_priority_pair_count,
        }


class SpecSQLGenerator:
    """编译 ``Manifest + Grammar + Matrix + Fixture`` 为静态 SQL 用例。"""

    def __init__(self, registry: SpecRegistry):
        self.registry = registry

    def generate_cases_for_manifest(self, manifest: ManifestDef,
                                    context: Optional[SchemaContext] = None) -> List[GeneratedCase]:
        cases, _ = self.generate_with_report(manifest, context)
        return cases

    def generate_with_report(self, manifest: ManifestDef,
                             context: Optional[SchemaContext] = None) -> Tuple[List[GeneratedCase], GenerationReport]:
        syntax = self.registry.get_syntax(manifest.target_syntax)
        if syntax is None:
            raise GenerationValidationError(f"Target syntax not found: {manifest.target_syntax}")

        matrix = self._merge_matrices(manifest.import_matrices)
        effective_context = self._context_with_fixtures(context, manifest.fixtures)
        param_space = self._parameter_space(syntax, manifest)
        candidate_estimate = math.prod(len(values) for values in param_space.values())
        all_rules = list(matrix.compatibility_rules) + list(manifest.additional_constraints)
        solver = ConstraintSolver(all_rules)
        solver.validate_references(param_space)

        if manifest.strategy == "pairwise":
            try:
                pairwise = generate_constraint_aware_pairwise(
                    param_space,
                    solver=solver,
                    high_priority_dimensions=manifest.high_priority_dimensions,
                    max_search_nodes=manifest.max_search_nodes,
                )
            except PairwiseGenerationError as exc:
                raise GenerationValidationError(f"{manifest.id}: {exc}") from exc
            combos = pairwise.suite
            report = self._report_from_pairwise(manifest, candidate_estimate, pairwise)
        else:
            if candidate_estimate > manifest.max_cartesian_combinations:
                raise GenerationValidationError(
                    f"{manifest.id}: {manifest.strategy} 需要枚举 {candidate_estimate} 个组合，"
                    f"超过 max_cartesian_combinations={manifest.max_cartesian_combinations}；"
                    "请改用 pairwise 或显式缩小值域。"
                )
            raw_combos = generate_cartesian(param_space)
            combos = solver.filter_combos(raw_combos)
            report = self._report_from_complete_combos(manifest, candidate_estimate, combos)

        cases: List[GeneratedCase] = []
        case_ids: Set[str] = set()
        duplicate_case_ids: List[str] = []
        for combo in combos:
            rendered_sql, expected, sqlstates = self._expand_and_render(
                syntax=syntax,
                combo=combo,
                matrix=matrix,
                context=effective_context,
                default_expected=manifest.default_expected,
            )
            self._validate_static_context(combo, effective_context)
            case_id = self._stable_case_id(manifest.id, combo)
            if case_id in case_ids:
                duplicate_case_ids.append(case_id)
                continue
            case_ids.add(case_id)
            cases.append(GeneratedCase(
                factor_id=manifest.id,
                case_id=case_id,
                strategy=manifest.strategy,
                params=dict(combo),
                sql=_clean_sql(rendered_sql),
                expected=expected,
                expected_sqlstate=sqlstates[0] if sqlstates else "",
                expected_sqlstates=sqlstates,
                context="static",
                preconditions=list(manifest.fixtures),
            ))

        report.generated_case_count = len(cases)
        report.duplicate_case_ids = duplicate_case_ids
        if duplicate_case_ids:
            raise GenerationValidationError(
                f"{manifest.id}: 生成了重复 case_id: {', '.join(duplicate_case_ids)}"
            )
        if manifest.strategy == "pairwise" and not report.pairwise_complete:
            raise GenerationValidationError(
                f"{manifest.id}: Pairwise 覆盖不完整: {report.missing_pairs}"
            )
        return cases, report

    def _parameter_space(self, syntax: SyntaxDef, manifest: ManifestDef) -> Dict[str, List[str]]:
        """Manifest 是候选值来源；grammar.values 仅作为未绑定 slot 的兼容默认值。"""
        param_space = {name: list(values) for name, values in manifest.bindings.items()}
        for slot_name, slot_def in syntax.slots.items():
            if slot_name not in param_space and slot_def.values:
                param_space[slot_name] = list(slot_def.values)
        if not param_space:
            param_space["_dummy"] = ["1"]
        return param_space

    def _merge_matrices(self, matrix_refs: List[str]) -> MatrixDef:
        merged = MatrixDef(id="merged_matrix", name="Merged Matrix")
        for reference in matrix_refs:
            matrix = self.registry.get_matrix(reference)
            if matrix is None:
                raise GenerationValidationError(f"Matrix not found: {reference}")
            merged.data_types.update(matrix.data_types)
            merged.storage_engines.update(matrix.storage_engines)
            merged.compatibility_rules.extend(matrix.compatibility_rules)
        return merged

    def _context_with_fixtures(self, context: Optional[SchemaContext], fixture_ids: List[str]) -> SchemaContext:
        effective = context.snapshot() if context is not None else SchemaContext()
        for fixture_id in fixture_ids:
            fixture = self.registry.get_fixture(fixture_id)
            if fixture is None:
                raise GenerationValidationError(f"Fixture not found: {fixture_id}")
            self._apply_fixture(effective, fixture)
        return effective

    @staticmethod
    def _apply_fixture(context: SchemaContext, fixture: FixtureDef) -> None:
        for table_def in fixture.tables:
            existing = context.get_table(table_def.name)
            columns = [ColumnSymbol(name=column.name, datatype=column.type) for column in table_def.columns]
            table = TableSymbol(
                name=table_def.name,
                columns=columns,
                storage_engine=table_def.storage_engine,
                partition_type=table_def.partition_type,
                is_temporary=table_def.temporary,
            )
            if existing is not None and existing.to_dict() != table.to_dict():
                raise GenerationValidationError(
                    f"fixture '{fixture.id}' 与已有上下文对表 '{table_def.name}' 的声明冲突"
                )
            context.register_table(table)

    @staticmethod
    def _stable_case_id(manifest_id: str, combo: Dict[str, str]) -> str:
        canonical = "|".join(f"{name}={combo[name]}" for name in sorted(combo))
        digest = hashlib.sha256(canonical.encode("utf-8")).hexdigest()[:12]
        return f"{manifest_id}_{digest}"

    def _expand_and_render(self, syntax: SyntaxDef, combo: Dict[str, str], matrix: MatrixDef,
                           context: SchemaContext, default_expected: str) -> Tuple[str, str, List[str]]:
        expected = default_expected
        sqlstates: List[str] = []
        scope: Dict[str, str] = {}

        for slot_name, slot_def in syntax.slots.items():
            slot_value = combo.get(slot_name)
            if slot_def.type == "element_list":
                column_type = combo.get("column_datatype") or combo.get(f"{slot_name}.column_datatype") or "INTEGER"
                column_constraint = combo.get("column_constraint") or combo.get(f"{slot_name}.column_constraint") or ""
                datatype_def = matrix.data_types.get(column_type)
                if datatype_def and column_type in datatype_def.invalid_values:
                    expected = "error"
                    sqlstates.extend(datatype_def.expected_sqlstates_for_invalid)
                elif column_type == "FAKETYPE":
                    expected = "error"
                    sqlstates.extend(["42704", "42601"])

                elements = [f"col_1 {column_type} {column_constraint}".strip()]
                if slot_def.min_elements > 1:
                    elements.append("col_2 VARCHAR(50)")
                scope[slot_name] = slot_def.delimiter.join(elements)
                continue

            value = slot_value if slot_value is not None else (slot_def.values[0] if slot_def.values else "")
            if slot_name == "column_datatype" and value == "FAKETYPE":
                expected = "error"
                sqlstates.extend(["42704", "42601"])
            if slot_def.symbol_action == "consumes_table" and context.tables:
                table = context.pick_table()
                if table is not None:
                    value = table.name
            scope[slot_name] = value

        missing = syntax.production_placeholders() - set(scope)
        if missing:
            raise GenerationValidationError(
                f"{syntax.id}: 无法为必要 slot 提供值: {', '.join(sorted(missing))}"
            )
        return syntax.production.format(**scope), expected, list(dict.fromkeys(sqlstates))

    def _validate_static_context(self, combo: Dict[str, str], context: SchemaContext) -> None:
        """验证当前支持的简单 SELECT 与 CREATE VIEW 别名契约。

        该检查刻意只处理扁平 ``SELECT ... FROM table [WHERE ...]``。复杂查询
        需要未来的 QueryProfile/AST，而不会被错误地当作已验证。
        """
        query = combo.get("query")
        if not query or not context.tables:
            return
        match = re.match(
            r"^\s*SELECT\s+(?P<projection>.+?)\s+FROM\s+(?P<table>[A-Za-z_][A-Za-z0-9_]*)"
            r"(?:\s+WHERE\s+.+)?\s*$",
            query,
            flags=re.IGNORECASE,
        )
        if match is None:
            return
        table_name = match.group("table")
        table = context.get_table(table_name)
        if table is None:
            raise GenerationValidationError(f"查询引用的表 '{table_name}' 不在 fixture/context 中")

        projection = match.group("projection").strip()
        if projection == "*":
            output_columns = table.column_names()
        else:
            output_columns = []
            for expression in projection.split(","):
                column_name = expression.strip().split()[0]
                if table.get_column(column_name) is None:
                    raise GenerationValidationError(
                        f"查询引用的列 '{column_name}' 不存在于 fixture 表 '{table_name}'"
                    )
                output_columns.append(column_name)

        column_list = combo.get("column_list", "").strip()
        if column_list:
            if not (column_list.startswith("(") and column_list.endswith(")")):
                raise GenerationValidationError(f"视图列名列表格式错误: {column_list}")
            aliases = [name.strip() for name in column_list[1:-1].split(",") if name.strip()]
            if len(aliases) != len(output_columns):
                raise GenerationValidationError(
                    f"视图列名数量 ({len(aliases)}) 与查询输出列数量 ({len(output_columns)}) 不一致"
                )

    @staticmethod
    def _pair_set(combos: List[Dict[str, str]], parameters: List[str]) -> Set[Pair]:
        positions = {name: index for index, name in enumerate(parameters)}
        pairs: Set[Pair] = set()
        for combo in combos:
            for left, right in combinations(parameters, 2):
                if positions[left] < positions[right]:
                    pairs.add((left, combo[left], right, combo[right]))
                else:
                    pairs.add((right, combo[right], left, combo[left]))
        return pairs

    def _report_from_pairwise(self, manifest: ManifestDef, candidate_estimate: int,
                              result: PairwiseResult) -> GenerationReport:
        priority_dimensions = {frozenset(pair) for pair in manifest.high_priority_dimensions}
        priority_pairs = {
            pair for pair in result.feasible_pairs
            if frozenset((pair[0], pair[2])) in priority_dimensions
        }
        covered_priority_pairs = priority_pairs & result.covered_pairs
        return GenerationReport(
            manifest_id=manifest.id,
            strategy=manifest.strategy,
            candidate_combination_estimate=candidate_estimate,
            feasible_pair_count=len(result.feasible_pairs),
            covered_pair_count=len(result.covered_pairs & result.feasible_pairs),
            missing_pairs=sorted(result.missing_pairs),
            filtered_pair_reasons=result.infeasible_pair_reasons,
            search_nodes=result.search_nodes,
            high_priority_pair_count=len(priority_pairs),
            covered_high_priority_pair_count=len(covered_priority_pairs),
        )

    def _report_from_complete_combos(self, manifest: ManifestDef, candidate_estimate: int,
                                     combos: List[Dict[str, str]]) -> GenerationReport:
        parameters = list(self._parameter_space(self.registry.get_syntax(manifest.target_syntax), manifest))
        pairs = self._pair_set(combos, parameters)
        return GenerationReport(
            manifest_id=manifest.id,
            strategy=manifest.strategy,
            candidate_combination_estimate=candidate_estimate,
            feasible_pair_count=len(pairs),
            covered_pair_count=len(pairs),
        )
