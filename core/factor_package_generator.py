"""Constraint-aware SQL generator for Factor Package Schema V1."""
from __future__ import annotations

import hashlib
import math
import re
from itertools import combinations
from typing import Any, Dict, Iterable, List, Optional, Set, Tuple

from .combinator import Pair, PairwiseGenerationError, generate_cartesian, generate_constraint_aware_pairwise
from .constraint_solver import ConstraintSolver
from .finite_sql_contract import inspect_write, finite_inline_nonnull_columns
from .generator import GeneratedCase
from .spec_generator import GenerationReport, GenerationValidationError
from .factor_package_model import (
    FactorManifestDef,
    FactorPackageDef,
    FactorPackageRegistry,
    ResolvedDimensionValue,
    SyntaxASTNodeDef,
)


class _FactorRuleSolver:
    """Resolve dimension properties before evaluating positive or negative rules."""

    def __init__(
        self,
        normal_expressions: List[str],
        target_violation_expressions: List[Tuple[str, str]],
        resolved_values: Dict[str, Dict[str, ResolvedDimensionValue]],
        factor: FactorPackageDef,
    ):
        self.normal_solver = ConstraintSolver(normal_expressions)
        self.target_solvers = [
            (rule_id, ConstraintSolver([expression]))
            for rule_id, expression in target_violation_expressions
        ]
        self.resolved_values = resolved_values
        self.factor = factor

    def validate_references(self, available_names: Iterable[str]) -> None:
        missing_dimensions = sorted(set(self.resolved_values) - set(available_names))
        if missing_dimensions:
            raise GenerationValidationError(
                f"Pairwise 参数空间缺少维度: {', '.join(missing_dimensions)}"
            )

    def _enrich(self, combo: Dict[str, Any]) -> Dict[str, Any]:
        enriched = dict(combo)
        for dimension_id, selected_id in combo.items():
            value = self.resolved_values.get(dimension_id, {}).get(str(selected_id))
            if value is not None:
                enriched.update(value.attributes)
        return enriched

    def is_possible(self, partial_combo: Dict[str, Any]) -> Tuple[bool, Optional[str]]:
        possible, reason = self.normal_solver.is_possible(self._enrich(partial_combo))
        if not possible:
            return False, reason
        if set(partial_combo) == set(self.resolved_values):
            return self._structural_contract_result(partial_combo)
        return True, None

    def is_valid(self, combo: Dict[str, Any]) -> Tuple[bool, Optional[str]]:
        enriched = self._enrich(combo)
        normal_valid, reason = self.normal_solver.is_valid(enriched)
        if not normal_valid:
            return False, reason
        structural_valid, structural_reason = self._structural_contract_result(combo)
        if not structural_valid:
            return False, structural_reason
        if not self.target_solvers:
            return True, None
        violated = []
        for rule_id, target_solver in self.target_solvers:
            target_valid, _ = target_solver.is_valid(enriched)
            if not target_valid:
                violated.append(rule_id)
        if violated:
            return True, None
        target_ids = ", ".join(rule_id for rule_id, _ in self.target_solvers)
        return False, f"negative case must violate one of: {target_ids}"

    def _structural_contract_result(
        self, combo: Dict[str, Any]
    ) -> Tuple[bool, Optional[str]]:
        try:
            FactorPackageSQLGenerator._validate_structural_contract(
                self.factor,
                {name: str(value) for name, value in combo.items()},
                self.resolved_values,
            )
        except GenerationValidationError as exc:
            return False, str(exc)
        return True, None

    def filter_combos(self, combos: List[Dict[str, str]]) -> List[Dict[str, str]]:
        return [combo for combo in combos if self.is_valid(combo)[0]]


class FactorPackageSQLGenerator:
    """Compile one V1 manifest into deterministic SQL and coverage evidence."""

    def __init__(self, registry: FactorPackageRegistry):
        self.registry = registry

    def generate_cases_for_manifest(
        self, manifest: FactorManifestDef
    ) -> List[GeneratedCase]:
        cases, _ = self.generate_with_report(manifest)
        return cases

    def generate_with_report(
        self, manifest: FactorManifestDef
    ) -> Tuple[List[GeneratedCase], GenerationReport]:
        factor = self.registry.get_factor(manifest.factor_ref)
        syntax = self.registry.get_syntax(manifest.syntax_ref)
        if factor is None or syntax is None:
            raise GenerationValidationError(
                f"{manifest.id}: factor 或 syntax 引用不存在"
            )
        if (
            manifest.coverage_requirements.strength != 2
            or not manifest.coverage_requirements.require_all_feasible_pairs
        ):
            raise GenerationValidationError(
                f"{manifest.id}: V1 当前只支持强制完整覆盖的 Pairwise strength=2"
            )

        resolved = self.registry.resolve_dimension_values(factor.id)
        param_space = self.build_param_space(factor, manifest)
        candidate_estimate = math.prod(len(values) for values in param_space.values())
        solver = self._build_solver(factor, manifest, resolved)

        if not param_space:
            # A fixed SQL production has one empty assignment. Keep the legacy
            # combinator's empty-input behavior unchanged, and still apply all
            # product, structural, and targeted-negative constraints here.
            combos = solver.filter_combos([{}])
            if not combos:
                raise GenerationValidationError("固定语句不满足目标规则")
            report = GenerationReport(
                manifest_id=manifest.id,
                strategy=manifest.strategy,
                candidate_combination_estimate=1,
                feasible_combination_count=1,
                feasible_pair_count=0,
                covered_pair_count=0,
                missing_pairs=[],
                search_nodes=1,
            )
        elif manifest.strategy == "pairwise":
            if candidate_estimate <= 10_000:
                combos, feasible_pairs, feasible_combo_count = self._small_space_pairwise(param_space, solver)
                covered_pairs = self._pair_set(combos, list(param_space))
                report = GenerationReport(
                    manifest_id=manifest.id,
                    strategy=manifest.strategy,
                    candidate_combination_estimate=candidate_estimate,
                    feasible_pair_count=len(feasible_pairs),
                    covered_pair_count=len(covered_pairs & feasible_pairs),
                    feasible_combination_count=feasible_combo_count,
                    missing_pairs=sorted(feasible_pairs - covered_pairs),
                    search_nodes=candidate_estimate,
                )
            else:
                try:
                    result = generate_constraint_aware_pairwise(param_space, solver=solver)
                except PairwiseGenerationError as exc:
                    raise GenerationValidationError(f"{manifest.id}: {exc}") from exc
                combos = result.suite
                report = GenerationReport(
                    manifest_id=manifest.id,
                    strategy=manifest.strategy,
                    candidate_combination_estimate=candidate_estimate,
                    feasible_pair_count=len(result.feasible_pairs),
                    covered_pair_count=len(result.covered_pairs & result.feasible_pairs),
                    missing_pairs=sorted(result.missing_pairs),
                    filtered_pair_reasons=result.infeasible_pair_reasons,
                    search_nodes=result.search_nodes,
                )
        else:
            if candidate_estimate > 100_000:
                raise GenerationValidationError(
                    f"{manifest.id}: 完整枚举需要 {candidate_estimate} 个组合，超过 100000"
                )
            combos = solver.filter_combos(generate_cartesian(param_space))
            pairs = self._pair_set(combos, list(param_space))
            report = GenerationReport(
                manifest_id=manifest.id,
                strategy=manifest.strategy,
                candidate_combination_estimate=candidate_estimate,
                feasible_pair_count=len(pairs),
                covered_pair_count=len(pairs),
                feasible_combination_count=len(combos),
            )

        cases: List[GeneratedCase] = []
        seen_case_ids: Set[str] = set()
        seen_sql: Set[str] = set()
        for combo in combos:
            valid, failed_rule = solver.is_valid(combo)
            if not valid:
                raise GenerationValidationError(
                    f"{manifest.id}: Pairwise 返回了不满足目标规则的组合: {failed_rule}"
                )
            case_id = self._stable_case_id(manifest.id, combo)
            sql, consumed_dimension_ids = self._render_sql_with_consumption(
                factor, manifest, combo, case_id, resolved
            )
            fixture_refs = self._fixture_refs_for_combo(
                manifest,
                combo,
                resolved,
                consumed_dimension_ids,
            )
            fixture_refs = self._ordered_fixture_refs(fixture_refs)
            self._validate_structural_contract(factor, combo, resolved)
            self._validate_fixture_contract(
                combo,
                resolved,
                fixture_refs,
                consumed_dimension_ids,
            )
            setup_sqls, teardown_sqls = self._compile_fixture_lifecycle(fixture_refs)
            if manifest.expected.default == "success":
                rendered_contract = inspect_write(sql, setup_sqls)
                if rendered_contract["status"] == "rejected":
                    raise GenerationValidationError(
                        f"{manifest.id}: rendered SQL/fixture contradiction: "
                        f"{rendered_contract['issues']}"
                    )
                # Unsupported expressions are not a proof of correctness.
                # audit_rendered_sql_contracts records these as needs_review;
                # do not silently filter them out of the declared pair domain.
            if case_id in seen_case_ids:
                raise GenerationValidationError(f"{manifest.id}: 重复 case_id: {case_id}")
            if sql in seen_sql:
                raise GenerationValidationError(f"{manifest.id}: 不同组合生成了重复 SQL: {sql}")
            seen_case_ids.add(case_id)
            seen_sql.add(sql)
            cases.append(GeneratedCase(
                factor_id=factor.id,
                case_id=case_id,
                strategy=manifest.strategy,
                params=dict(combo),
                sql=sql,
                expected=manifest.expected.default,
                expected_sqlstates=list(manifest.expected.sqlstates),
                expected_error_category=manifest.expected.error_category or "",
                expected_error_regex=manifest.expected.error_message_regex or "",
                expected_oracle_status=manifest.expected.oracle_status,
                expected_scope=manifest.expected.scope,
                setup_sqls=setup_sqls,
                teardown_sqls=teardown_sqls,
                context=f"factor_package_v1:{manifest.expected.scope}",
                preconditions=fixture_refs,
                consumed_dimension_ids=sorted(consumed_dimension_ids),
                environment_requirements=[
                    requirement.model_dump()
                    for requirement in manifest.environment_requirements
                ],
            ))

        report.generated_case_count = len(cases)
        if manifest.strategy == "pairwise" and not report.pairwise_complete:
            raise GenerationValidationError(
                f"{manifest.id}: Pairwise 覆盖不完整: {report.missing_pairs}"
            )
        return cases, report

    @staticmethod
    def build_param_space(
        factor: FactorPackageDef,
        manifest: FactorManifestDef,
    ) -> Dict[str, List[str]]:
        """Resolve explicit manifest bindings plus declared factor defaults."""
        param_space: Dict[str, List[str]] = {}
        for dimension_id, dimension in factor.dimensions.items():
            selected = manifest.bindings.get(dimension_id)
            if selected is not None:
                param_space[dimension_id] = list(selected)
            elif dimension.default_value_id is not None:
                param_space[dimension_id] = [dimension.default_value_id]
            else:
                raise GenerationValidationError(
                    f"{manifest.id}: dimension '{dimension_id}' 既没有 binding，"
                    "也没有 default_value_id"
                )
        return param_space

    @staticmethod
    def _build_solver(
        factor: FactorPackageDef,
        manifest: FactorManifestDef,
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
    ) -> _FactorRuleSolver:
        target_ids = set(manifest.violates_rule_refs)
        normal_expressions = [
            rule.expression for rule in factor.rules if rule.id not in target_ids
        ]
        normal_expressions.extend(rule.expression for rule in manifest.local_rules)
        target_expressions = [
            (rule.id, rule.expression) for rule in factor.rules if rule.id in target_ids
        ]
        return _FactorRuleSolver(
            normal_expressions,
            target_expressions,
            resolved,
            factor,
        )

    def _render_sql(
        self,
        factor: FactorPackageDef,
        manifest: FactorManifestDef,
        combo: Dict[str, str],
        case_id: str,
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
    ) -> str:
        sql, _ = self._render_sql_with_consumption(
            factor, manifest, combo, case_id, resolved
        )
        return sql

    def _render_sql_with_consumption(
        self,
        factor: FactorPackageDef,
        manifest: FactorManifestDef,
        combo: Dict[str, str],
        case_id: str,
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
    ) -> Tuple[str, Set[str]]:
        syntax = self.registry.get_syntax(manifest.syntax_ref)
        if syntax is None:
            raise GenerationValidationError(f"syntax 不存在: {manifest.syntax_ref}")
        scope: Dict[str, str] = {}
        dimension_slots = {
            slot_name
            for slot_name, slot in syntax.slots.items()
            if slot.dimension_ref is not None
        }
        for slot_name, slot in syntax.slots.items():
            if slot.dimension_ref is not None:
                selected_id = combo[slot_name]
                scope[slot_name] = resolved[slot_name][selected_id].render
                continue
            policy = manifest.identifier_policy.get(slot_name)
            if slot.type == "identifier" and policy is not None:
                suffix = case_id.rsplit("_", 1)[-1][:8]
                identifier = f"{policy.prefix}_{suffix}"
                scope[slot_name] = (
                    f"{policy.schema_prefix}.{identifier}"
                    if policy.schema_prefix else identifier
                )
                continue
            raise GenerationValidationError(
                f"{manifest.id}: slot '{slot_name}' 没有 dimension_ref 或 identifier_policy"
            )
        if syntax.ast is not None:
            consumed_dimension_ids: Set[str] = set()
            raw_sql = self._render_ast_node(
                syntax.ast,
                syntax.subgrammars,
                combo,
                scope,
                resolved,
                [],
                consumed_dimension_ids,
                dimension_slots,
            )
        else:
            consumed_dimension_ids = (
                syntax.production_placeholders() & dimension_slots
            )
            raw_sql = syntax.production.format(**scope)
        sql = self._collapse_whitespace(raw_sql)
        terminator = syntax.rendering.statement_terminator
        if terminator and not sql.endswith(terminator):
            sql += terminator
        return sql, consumed_dimension_ids

    def _render_ast_node(
        self,
        node: SyntaxASTNodeDef,
        subgrammars: Dict[str, SyntaxASTNodeDef],
        combo: Dict[str, str],
        scope: Dict[str, str],
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
        ref_stack: List[str],
        consumed_dimension_ids: Optional[Set[str]] = None,
        dimension_slots: Optional[Set[str]] = None,
    ) -> str:
        if consumed_dimension_ids is None:
            consumed_dimension_ids = set()
        if dimension_slots is None:
            dimension_slots = set(combo)
        if node.kind == "literal":
            return node.text or ""
        if node.kind == "slot":
            if node.slot in dimension_slots:
                consumed_dimension_ids.add(node.slot)
            return scope[node.slot]
        if node.kind == "sequence":
            return "".join(
                self._render_ast_node(
                    child,
                    subgrammars,
                    combo,
                    scope,
                    resolved,
                    ref_stack,
                    consumed_dimension_ids,
                    dimension_slots,
                )
                for child in node.items
            )
        if node.kind == "choice":
            if node.selector in dimension_slots:
                consumed_dimension_ids.add(node.selector)
            selected_id = combo[node.selector]
            branch = node.branches.get(selected_id) or node.branches.get("*")
            if branch is None:
                raise GenerationValidationError(
                    f"AST choice '{node.selector}' 没有值 '{selected_id}' 的 branch"
                )
            return self._render_ast_node(
                branch,
                subgrammars,
                combo,
                scope,
                resolved,
                ref_stack,
                consumed_dimension_ids,
                dimension_slots,
            )
        if node.kind == "optional":
            if node.selector in dimension_slots:
                consumed_dimension_ids.add(node.selector)
            if combo[node.selector] not in set(node.enabled_values):
                return ""
            return self._render_ast_node(
                node.item,
                subgrammars,
                combo,
                scope,
                resolved,
                ref_stack,
                consumed_dimension_ids,
                dimension_slots,
            )
        if node.kind == "repeat":
            if node.slot in dimension_slots:
                consumed_dimension_ids.add(node.slot)
            selected_id = combo[node.slot]
            value = resolved[node.slot][selected_id]
            attribute_name = f"{node.slot}.properties.{node.items_property}"
            items = value.attributes.get(attribute_name)
            if not isinstance(items, list) or not items:
                raise GenerationValidationError(
                    f"AST repeat slot '{node.slot}' 的值 '{selected_id}' "
                    f"必须提供非空列表属性 '{node.items_property}'"
                )
            if not all(isinstance(item, str) for item in items):
                raise GenerationValidationError(
                    f"AST repeat slot '{node.slot}' 的 '{node.items_property}' 只能包含字符串"
                )
            return node.separator.join(items)
        if node.kind == "ref":
            ref_name = node.ref
            if ref_name in ref_stack:
                cycle = " -> ".join([*ref_stack, ref_name])
                raise GenerationValidationError(f"AST subgrammar 存在无终止递归: {cycle}")
            target = subgrammars.get(ref_name)
            if target is None:
                raise GenerationValidationError(f"AST subgrammar 不存在: {ref_name}")
            return self._render_ast_node(
                target,
                subgrammars,
                combo,
                scope,
                resolved,
                [*ref_stack, ref_name],
                consumed_dimension_ids,
                dimension_slots,
            )
        raise GenerationValidationError(f"未知 AST node kind: {node.kind}")

    @staticmethod
    def _collapse_whitespace(sql: str) -> str:
        output: List[str] = []
        in_single_quote = False
        whitespace_pending = False
        for char in sql.strip():
            if char == "'":
                if whitespace_pending and output and output[-1] != " ":
                    output.append(" ")
                whitespace_pending = False
                in_single_quote = not in_single_quote
                output.append(char)
            elif char.isspace() and not in_single_quote:
                whitespace_pending = True
            else:
                if whitespace_pending and output and output[-1] != " ":
                    output.append(" ")
                whitespace_pending = False
                output.append(char)
        return "".join(output)

    @staticmethod
    def _stable_case_id(manifest_id: str, combo: Dict[str, str]) -> str:
        canonical = "|".join(f"{name}={combo[name]}" for name in sorted(combo))
        digest_input = f"{manifest_id}|{canonical}"
        digest = hashlib.sha256(digest_input.encode("utf-8")).hexdigest()[:12]
        return f"{manifest_id}_{digest}"

    @staticmethod
    def _fixture_refs_for_combo(
        manifest: FactorManifestDef,
        combo: Dict[str, str],
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
        consumed_dimension_ids: Optional[Set[str]] = None,
    ) -> List[str]:
        refs = list(manifest.fixture_refs)
        active_dimensions = (
            set(combo)
            if consumed_dimension_ids is None
            else set(consumed_dimension_ids)
        )
        for dimension_id, selected_id in combo.items():
            if dimension_id not in active_dimensions:
                continue
            refs.extend(resolved[dimension_id][selected_id].fixture_refs)
        return list(dict.fromkeys(refs))

    def _compile_fixture_lifecycle(
        self, fixture_refs: List[str]
    ) -> Tuple[List[str], List[str]]:
        fixture_refs = self._ordered_fixture_refs(fixture_refs)
        table_contracts = self._fixture_table_contracts(fixture_refs)
        setup: List[str] = []
        teardown_groups: List[List[str]] = []
        seen_tables: Set[str] = set()
        for fixture_id in fixture_refs:
            fixture = self.registry.get_fixture(fixture_id)
            if fixture is None:
                raise GenerationValidationError(f"fixture 不存在: {fixture_id}")
            execution = fixture.execution
            if execution.status != "ready":
                raise GenerationValidationError(
                    f"fixture '{fixture_id}' 尚不可执行: {execution.status}"
                )
            if execution.mode == "explicit":
                setup.extend(execution.setup_sqls)
                teardown_groups.append(list(execution.teardown_sqls))
                continue

            fixture_setup: List[str] = []
            fixture_teardown: List[str] = []
            for table in fixture.provides.tables:
                self._validate_sql_identifier(table.name)
                column_names = [column.name.lower() for column in table.columns]
                if len(column_names) != len(set(column_names)):
                    raise GenerationValidationError(
                        f"fixture '{fixture_id}' 表 '{table.name}' 的未引号列名大小写重复"
                    )
                if table.name in seen_tables:
                    continue
                seen_tables.add(table.name)
                fixture_setup.append(f"DROP TABLE IF EXISTS {table.name} CASCADE;")
                columns = []
                for column in table.columns:
                    self._validate_sql_identifier(column.name)
                    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*(?:\s*\([^;]*\))?", column.type):
                        raise GenerationValidationError(
                            f"fixture '{fixture_id}' 包含不安全列类型: {column.type!r}"
                        )
                    nullability = "" if column.nullable else " NOT NULL"
                    columns.append(f"{column.name} {column.type}{nullability}")
                persistence = "TEMP " if table.persistence == "temporary" else ""
                storage = (
                    " WITH (storage_type=ustore)"
                    if table.table_kind == "ustore_regular"
                    else ""
                )
                if table.table_kind not in {"regular", "ustore_regular"}:
                    raise GenerationValidationError(
                        f"fixture '{fixture_id}' 的 table_kind={table.table_kind!r} "
                        "必须使用 explicit execution"
                    )
                fixture_setup.append(
                    f"CREATE {persistence}TABLE {table.name} "
                    f"({', '.join(columns)}){storage};"
                )
                fixture_teardown.insert(
                    0, f"DROP TABLE IF EXISTS {table.name} CASCADE;"
                )

            if fixture.seed.rows:
                if len(fixture.provides.tables) != 1:
                    raise GenerationValidationError(
                        f"fixture '{fixture_id}' 使用自动 seed 时必须只提供一张表"
                    )
                table = fixture.provides.tables[0]
                column_names = [column.name for column in table.columns]
                rows = []
                for row in fixture.seed.rows:
                    unknown = sorted(set(row) - set(column_names))
                    if unknown:
                        raise GenerationValidationError(
                            f"fixture '{fixture_id}' seed 包含未知列: {unknown}"
                        )
                    for column in table.columns:
                        if not column.nullable and row.get(column.name) is None:
                            raise GenerationValidationError(
                                f"fixture '{fixture_id}' seed 的非空列 '{column.name}' 缺值或为 NULL"
                            )
                    rows.append(
                        "(" + ", ".join(
                            self._sql_literal(row.get(column_name))
                            for column_name in column_names
                        ) + ")"
                    )
                fixture_setup.append(
                    f"INSERT INTO {table.name} ({', '.join(column_names)}) VALUES "
                    f"{', '.join(rows)};"
                )
            setup.extend(fixture_setup)
            teardown_groups.append(fixture_teardown)

        # Only reject demonstrated contradictions. Missing/opaque DDL evidence
        # does not establish nullable=True or a complete fixture contract.
        declared_tables = {name.lower(): table for name, table in table_contracts.items()}
        for name, nonnull_columns in finite_inline_nonnull_columns(setup).items():
            table = declared_tables.get(name)
            if table is None:
                continue
            for column in table.columns:
                if column.nullable and column.name.lower() in nonnull_columns:
                    raise GenerationValidationError(
                        f"fixture 表 '{name}' 列 '{column.name}' 的 nullable=True 与实际 DDL 非空约束矛盾"
                    )

        teardown = [
            sql
            for group in reversed(teardown_groups)
            for sql in group
        ]
        return setup, teardown

    def _fixture_table_contracts(
        self,
        fixture_refs: List[str],
    ) -> Dict[str, Any]:
        """Resolve one authoritative table contract per provided table name."""
        fixture_refs = self._ordered_fixture_refs(fixture_refs)
        tables: Dict[str, Any] = {}
        owners: Dict[str, str] = {}
        signatures: Dict[str, Tuple[Any, ...]] = {}
        unquoted_spellings: Dict[str, str] = {}
        for fixture_id in fixture_refs:
            fixture = self.registry.get_fixture(fixture_id)
            if fixture is None:
                raise GenerationValidationError(f"fixture 不存在: {fixture_id}")
            for table in fixture.provides.tables:
                if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*)?", table.name):
                    # Require one spelling rather than guessing the namespace's
                    # case policy or silently composing DROP/CREATE aliases.
                    normalized = table.name.lower()
                    previous = unquoted_spellings.setdefault(normalized, table.name)
                    if previous != table.name:
                        raise GenerationValidationError(
                            f"fixture 未引号表名 '{previous}' 与 '{table.name}' 仅大小写不同；"
                            "请统一声明拼写，不能假定为两个独立对象"
                        )
                signature = (
                    table.persistence,
                    table.table_kind,
                    tuple(
                        (column.name, column.type, column.nullable)
                        for column in table.columns
                    ),
                )
                existing = signatures.get(table.name)
                if existing is not None and existing != signature:
                    raise GenerationValidationError(
                        f"fixture '{owners[table.name]}' 与 '{fixture_id}' "
                        f"对同名表 '{table.name}' 的 provides 契约冲突"
                    )
                if existing is None:
                    tables[table.name] = table
                    owners[table.name] = fixture_id
                    signatures[table.name] = signature
        return tables

    def _ordered_fixture_refs(self, fixture_refs: List[str]) -> List[str]:
        try:
            return self.registry.fixture_topological_order(fixture_refs)
        except ValueError as exc:
            raise GenerationValidationError(str(exc)) from exc

    @staticmethod
    def _validate_sql_identifier(value: str) -> None:
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", value):
            raise GenerationValidationError(
                f"fixture 标识符不是安全的未引用名称: {value!r}"
            )

    @staticmethod
    def _sql_literal(value: Any) -> str:
        if value is None:
            return "NULL"
        if isinstance(value, bool):
            return "TRUE" if value else "FALSE"
        if isinstance(value, float) and not math.isfinite(value):
            raise GenerationValidationError(
                "fixture seed 非有限浮点值需要注明目标类型的 explicit fixture，不能作为裸 SQL 数值生成"
            )
        if isinstance(value, (int, float)) and not isinstance(value, bool):
            return str(value)
        return "'" + str(value).replace("'", "''") + "'"

    def _validate_fixture_contract(
        self,
        combo: Dict[str, str],
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
        fixture_refs: List[str],
        consumed_dimension_ids: Optional[Set[str]] = None,
    ) -> None:
        fixture_tables = self._fixture_table_contracts(fixture_refs)
        tables = {
            table_name: {column.name for column in table.columns}
            for table_name, table in fixture_tables.items()
        }
        active_dimensions = (
            set(combo)
            if consumed_dimension_ids is None
            else set(consumed_dimension_ids)
        )
        selected_values = [
            (dimension_id, resolved[dimension_id][selected_id])
            for dimension_id, selected_id in combo.items()
            if dimension_id in active_dimensions
        ]
        required_tables = list(dict.fromkeys(
            table_name
            for dimension_id, value in selected_values
            for table_name in value.attributes.get(
                f"{dimension_id}.properties.source_tables", []
            )
        ))
        required_columns = list(dict.fromkeys(
            column_name
            for dimension_id, value in selected_values
            for column_name in value.attributes.get(
                f"{dimension_id}.properties.source_columns", []
            )
        ))
        for table_name in required_tables:
            if table_name not in tables:
                raise GenerationValidationError(
                    f"所选 profile 引用的表 '{table_name}' 未由 fixture 提供"
                )
        for dimension_id, value in selected_values:
            profile_tables = value.attributes.get(
                f"{dimension_id}.properties.source_tables", []
            )
            profile_columns = value.attributes.get(
                f"{dimension_id}.properties.source_columns", []
            )
            columns_by_table = value.attributes.get(
                f"{dimension_id}.properties.source_columns_by_table"
            )
            if columns_by_table is not None:
                if not isinstance(columns_by_table, dict) or not all(
                    isinstance(table_name, str)
                    and isinstance(column_names, list)
                    and all(isinstance(column_name, str) for column_name in column_names)
                    for table_name, column_names in columns_by_table.items()
                ):
                    raise GenerationValidationError(
                        f"profile '{value.id}' 的 source_columns_by_table 必须是表名到列名列表的映射"
                    )
                unknown_tables = sorted(set(columns_by_table) - set(profile_tables))
                if unknown_tables:
                    raise GenerationValidationError(
                        f"profile '{value.id}' 的逐表列契约引用了 source_tables 之外的表: "
                        f"{unknown_tables}"
                    )
                missing_table_contracts = sorted(set(profile_tables) - set(columns_by_table))
                if missing_table_contracts:
                    raise GenerationValidationError(
                        f"profile '{value.id}' 的逐表列契约缺少表: {missing_table_contracts}"
                    )
                flattened_columns = {
                    column_name
                    for column_names in columns_by_table.values()
                    for column_name in column_names
                }
                declared_columns = set(profile_columns)
                if flattened_columns != declared_columns:
                    raise GenerationValidationError(
                        f"profile '{value.id}' 的 source_columns_by_table 扁平列集合"
                        "与 source_columns 不一致: "
                        f"by_table_only={sorted(flattened_columns - declared_columns)}, "
                        f"flat_only={sorted(declared_columns - flattened_columns)}"
                    )
                for table_name, column_names in columns_by_table.items():
                    if table_name not in tables:
                        raise GenerationValidationError(
                            f"所选 profile 引用的表 '{table_name}' 未由 fixture 提供"
                        )
                    missing_columns = sorted(set(column_names) - tables[table_name])
                    if missing_columns:
                        raise GenerationValidationError(
                            f"profile '{value.id}' 引用的表 '{table_name}' 中不存在的列: "
                            f"{missing_columns}"
                        )
            elif len(profile_tables) > 1 and profile_columns:
                raise GenerationValidationError(
                    f"多表 profile '{value.id}' 必须提供 source_columns_by_table 逐表列契约"
                )
            elif profile_columns and profile_tables:
                missing_columns = sorted(
                    set(profile_columns) - tables[profile_tables[0]]
                )
                if missing_columns:
                    raise GenerationValidationError(
                        f"所选 profile 引用的表 '{profile_tables[0]}' 中不存在的列: "
                        f"{missing_columns}"
                    )

            features = value.attributes.get(
                f"{dimension_id}.properties.features", []
            )
            if "wildcard_projection" in features:
                profile_tables = value.attributes.get(
                    f"{dimension_id}.properties.source_tables", []
                )
                if not profile_tables:
                    continue
                actual_output_count = sum(len(tables[name]) for name in profile_tables)
                declared_output_count = value.attributes.get(
                    f"{dimension_id}.properties.output_column_count"
                )
                if declared_output_count != actual_output_count:
                    raise GenerationValidationError(
                        f"profile '{value.id}' 的 SELECT * 实际输出 "
                        f"{actual_output_count} 列，但 profile 声明 {declared_output_count} 列"
                    )

    @staticmethod
    def _validate_structural_contract(
        factor: FactorPackageDef,
        combo: Dict[str, str],
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
    ) -> None:
        for check in factor.structural_checks:
            if check.kind == "column_count_matches_query":
                column_value = resolved["column_list"][combo["column_list"]]
                query_value = resolved["query_profile"][combo["query_profile"]]
                alias_count = column_value.attributes.get("column_list.output_column_count")
                output_count = query_value.attributes.get("query_profile.properties.output_column_count")
                if alias_count not in (None, "inherited") and alias_count != output_count:
                    raise GenerationValidationError(
                        f"column_list '{column_value.id}' 有 {alias_count} 个名称，"
                        f"query profile '{query_value.id}' 输出 {output_count} 列"
                    )
            elif check.kind == "select_expression_contract":
                FactorPackageSQLGenerator._validate_select_expression_contract(
                    combo, resolved
                )
            elif check.kind == "insert_input_contract":
                FactorPackageSQLGenerator._validate_insert_input_contract(
                    combo, resolved
                )
            elif check.kind == "index_column_count_contract":
                FactorPackageSQLGenerator._validate_index_column_count_contract(
                    combo, resolved
                )

    @staticmethod
    def _effective_index_scope(
        combo: Dict[str, str],
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
    ) -> str:
        """Return the documented effective scope for a CREATE INDEX shape."""
        table = resolved["table_profile"][combo["table_profile"]]
        if not bool(table.attributes.get(
            "table_profile.properties.partitioned", False
        )):
            return "none"

        scope = resolved["scope_clause"][combo["scope_clause"]]
        if bool(scope.attributes.get(
            "scope_clause.properties.local_scope", False
        )) or bool(scope.attributes.get(
            "scope_clause.properties.explicit_partitions", False
        )):
            return "local"
        if bool(scope.attributes.get(
            "scope_clause.properties.global_scope", False
        )):
            return "global"

        key = resolved["key_profile"][combo["key_profile"]]
        unique = combo.get("unique_modifier") == "ci_unique"
        contains_partition_key = bool(key.attributes.get(
            "key_profile.properties.contains_partition_key", False
        ))
        return "local" if unique and contains_partition_key else "global"

    @staticmethod
    def _validate_index_column_count_contract(
        combo: Dict[str, str],
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
    ) -> None:
        """Validate documented CREATE INDEX key and INCLUDE column contracts.

        The PDF limits *key fields* to 31 for global indexes and 32 for other
        indexes.  INCLUDE columns are explicitly non-key columns, so they must
        not be folded into that numeric limit without an independent source.
        """
        required = {"key_profile", "include_profile", "table_profile", "scope_clause"}
        if not required.issubset(combo):
            return
        key = resolved["key_profile"][combo["key_profile"]]
        include = resolved["include_profile"][combo["include_profile"]]

        key_items = key.attributes.get("key_profile.properties.items", [])
        key_count = key.attributes.get("key_profile.properties.key_column_count")
        include_count = include.attributes.get(
            "include_profile.properties.include_column_count", 0
        )
        if not isinstance(key_items, list) or not key_items:
            raise GenerationValidationError(
                f"CREATE INDEX key profile '{key.id}' 必须提供非空 items"
            )
        if key_count != len(key_items):
            raise GenerationValidationError(
                f"CREATE INDEX key profile '{key.id}' 声明 {key_count} 列，"
                f"但 items 实际为 {len(key_items)} 列"
            )
        if not isinstance(include_count, int) or include_count < 0:
            raise GenerationValidationError(
                f"CREATE INDEX include profile '{include.id}' 的列数无效"
            )
        key_columns = set(key.attributes.get(
            "key_profile.properties.source_columns", []
        ))
        include_columns = set(include.attributes.get(
            "include_profile.properties.source_columns", []
        ))
        overlap = sorted(key_columns & include_columns)
        if overlap:
            raise GenerationValidationError(
                f"CREATE INDEX INCLUDE 必须是非键列，重复列: {overlap}"
            )

        effective_scope = FactorPackageSQLGenerator._effective_index_scope(
            combo, resolved
        )
        limit = 31 if effective_scope == "global" else 32
        if key_count > limit:
            raise GenerationValidationError(
                f"CREATE INDEX 键列数 {key_count}，超过当前形态上限 {limit}"
            )

    @staticmethod
    def _validate_insert_input_contract(
        combo: Dict[str, str],
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
    ) -> None:
        """Validate INSERT target columns against VALUES/DEFAULT/query output.

        Profiles keep SQL rendering independent from this contract.  The same
        validator therefore works for one or many VALUES rows and for a SELECT
        source, while DEFAULT VALUES explicitly bypasses arity/type matching.
        """
        if "target_profile" not in combo or "source_profile" not in combo:
            return

        target = resolved["target_profile"][combo["target_profile"]]
        source = resolved["source_profile"][combo["source_profile"]]
        source_kind = source.attributes.get(
            "source_profile.properties.source_kind"
        )
        if source.attributes.get("source_profile.properties.requires_cte", False):
            with_value = resolved["with_clause"][combo["with_clause"]]
            if not with_value.attributes.get(
                "with_clause.properties.provides_cte", False
            ):
                raise GenerationValidationError(
                    f"INSERT source profile '{source.id}' 要求 WITH 提供对应 CTE"
                )
        if source_kind == "default_values":
            return

        target_types = list(target.attributes.get(
            "target_profile.properties.target_types", []
        ))
        available_types = list(target.attributes.get(
            "target_profile.properties.available_types", target_types
        ))
        explicit_columns = bool(target.attributes.get(
            "target_profile.properties.explicit_columns", False
        ))
        source_types = list(source.attributes.get(
            "source_profile.properties.output_types", []
        ))
        output_count = source.attributes.get(
            "source_profile.properties.output_column_count"
        )
        if not isinstance(output_count, int) or output_count < 1:
            raise GenerationValidationError(
                f"INSERT source profile '{source.id}' 必须声明正整数 output_column_count"
            )
        if len(source_types) != output_count:
            raise GenerationValidationError(
                f"INSERT source profile '{source.id}' 的 output_types 数量与 "
                "output_column_count 不一致"
            )

        if explicit_columns:
            expected_count = target.attributes.get(
                "target_profile.properties.target_column_count"
            )
            if expected_count != output_count:
                raise GenerationValidationError(
                    f"INSERT 显式目标列数与输入列数不一致: "
                    f"target={expected_count} source={output_count}"
                )
            compared_target_types = target_types
        else:
            available_count = target.attributes.get(
                "target_profile.properties.available_column_count",
                len(available_types),
            )
            if not isinstance(available_count, int) or output_count > available_count:
                raise GenerationValidationError(
                    f"INSERT 隐式目标最多接受 {available_count} 列，输入为 {output_count} 列"
                )
            compared_target_types = available_types[:output_count]

        if len(compared_target_types) != output_count:
            raise GenerationValidationError(
                f"INSERT target profile '{target.id}' 的类型契约不完整"
            )
        incompatible = [
            index
            for index, (target_type, source_type) in enumerate(
                zip(compared_target_types, source_types), start=1
            )
            if str(source_type).upper() != "DEFAULT"
            and not FactorPackageSQLGenerator._types_compatible(
                target_type, source_type
            )
        ]
        if incompatible:
            raise GenerationValidationError(
                f"INSERT 目标列与输入类型不兼容，列位置: {incompatible}"
            )

    @staticmethod
    def _validate_select_expression_contract(
        combo: Dict[str, str],
        resolved: Dict[str, Dict[str, ResolvedDimensionValue]],
    ) -> None:
        if "statement_form" not in combo:
            return

        def selected(dimension_id: str) -> ResolvedDimensionValue:
            return resolved[dimension_id][combo[dimension_id]]

        statement = selected("statement_form")
        if not statement.attributes.get("statement_form.properties.uses_select_contract", False):
            return

        source = selected("source_form")
        if source.attributes.get("source_form.properties.requires_cte", False):
            with_value = selected("with_clause")
            if not with_value.attributes.get("with_clause.properties.provides_cte", False):
                raise GenerationValidationError(
                    "CTE 查询源要求 WITH 分支提供 cte_ast"
                )
        source_dimension = source.attributes.get(
            "source_form.properties.contract_source_dimension"
        )
        if source_dimension:
            nested_target = selected(source_dimension)
            available_columns = list(nested_target.attributes.get(
                f"{source_dimension}.properties.output_columns", []
            ))
            available_types = list(nested_target.attributes.get(
                f"{source_dimension}.properties.output_types", []
            ))
        else:
            available_columns = list(source.attributes.get(
                "source_form.properties.available_columns", []
            ))
            available_types = list(source.attributes.get(
                "source_form.properties.available_types", []
            ))
        if len(available_columns) != len(available_types):
            raise GenerationValidationError(
                "查询源的 available_columns 与 available_types 数量不一致"
            )

        target = selected("target_list")
        target_items = list(target.attributes.get(
            "target_list.properties.items", []
        ))
        target_output_columns = list(target.attributes.get(
            "target_list.properties.output_columns", []
        ))
        target_output_types = list(target.attributes.get(
            "target_list.properties.output_types", []
        ))
        if not target_items or not (
            len(target_items)
            == len(target_output_columns)
            == len(target_output_types)
        ):
            raise GenerationValidationError(
                "SELECT 投影 items、output_columns 与 output_types 必须非空且数量一致"
            )
        target_refs = set(target.attributes.get(
            "target_list.properties.referenced_columns", []
        ))
        missing_target_refs = sorted(target_refs - set(available_columns))
        if missing_target_refs:
            raise GenerationValidationError(
                f"SELECT 投影引用了查询源不存在的列: {missing_target_refs}"
            )

        where_value = selected("where_clause")
        where_refs = set(where_value.attributes.get(
            "where_clause.properties.referenced_columns", []
        ))
        missing_where_refs = sorted(where_refs - set(available_columns))
        if missing_where_refs:
            raise GenerationValidationError(
                f"WHERE 引用了查询源不存在的列: {missing_where_refs}"
            )

        group_value = selected("group_by_list")
        group_columns = set(group_value.attributes.get(
            "group_by_list.properties.columns", []
        ))
        group_active = bool(group_value.attributes.get(
            "group_by_list.properties.active", False
        ))
        missing_group_refs = sorted(group_columns - set(available_columns))
        if missing_group_refs:
            raise GenerationValidationError(
                f"GROUP BY 引用了查询源不存在的列: {missing_group_refs}"
            )
        nonaggregate_columns = set(target.attributes.get(
            "target_list.properties.nonaggregate_columns", []
        ))
        has_aggregate = bool(target.attributes.get(
            "target_list.properties.has_aggregate", False
        ))
        if group_active and not nonaggregate_columns.issubset(group_columns):
            missing = sorted(nonaggregate_columns - group_columns)
            raise GenerationValidationError(
                f"SELECT 非聚集列未完整进入 GROUP BY: {missing}"
            )
        if not group_active and has_aggregate and nonaggregate_columns:
            raise GenerationValidationError(
                "SELECT 同时包含聚集与非聚集列，但未声明 GROUP BY"
            )

        order_value = selected("order_by_list")
        order_columns = set(order_value.attributes.get(
            "order_by_list.properties.columns", []
        ))
        target_outputs = set(target_output_columns)
        modifier = selected("select_modifier")
        distinct = bool(modifier.attributes.get(
            "select_modifier.properties.distinct", False
        ))
        if (distinct or group_active) and not order_columns.issubset(target_outputs):
            missing = sorted(order_columns - target_outputs)
            raise GenerationValidationError(
                f"DISTINCT/GROUP BY 查询的 ORDER BY 列未进入投影: {missing}"
            )
        if not (distinct or group_active):
            allowed_order_columns = set(available_columns) | target_outputs
            missing = sorted(order_columns - allowed_order_columns)
            if missing:
                raise GenerationValidationError(
                    f"ORDER BY 引用了不可见列: {missing}"
                )

        set_value = selected("set_operator")
        set_active = bool(set_value.attributes.get(
            "set_operator.properties.active", False
        ))
        lock_active = combo.get("lock_clause") != "select_lock_none"
        if lock_active and (distinct or group_active or has_aggregate or set_active):
            raise GenerationValidationError(
                "锁定子句不能与 DISTINCT、分组/聚集或集合运算组合"
            )
        if set_active:
            right = selected("right_target_list")
            right_items = list(right.attributes.get(
                "right_target_list.properties.items", []
            ))
            right_outputs = list(right.attributes.get(
                "right_target_list.properties.output_columns", []
            ))
            right_types = list(right.attributes.get(
                "right_target_list.properties.output_types", []
            ))
            if not right_items or not (
                len(right_items) == len(right_outputs) == len(right_types)
            ):
                raise GenerationValidationError(
                    "集合右侧 items、output_columns 与 output_types 必须非空且数量一致"
                )
            if len(target_output_types) != len(right_types):
                raise GenerationValidationError(
                    "集合运算两侧输出列数不一致: "
                    f"left={len(target_output_types)} right={len(right_types)}"
                )
            incompatible = [
                index
                for index, (left_type, right_type) in enumerate(
                    zip(target_output_types, right_types), start=1
                )
                if not FactorPackageSQLGenerator._set_types_equal(
                    left_type, right_type
                )
            ]
            if incompatible:
                raise GenerationValidationError(
                    f"集合运算两侧类型不兼容，列位置: {incompatible}"
                )

    @staticmethod
    def _types_compatible(left_type: str, right_type: str) -> bool:
        left = str(left_type).upper()
        right = str(right_type).upper()
        if left == right:
            return True
        numeric = {
            "INT1", "INT2", "INT4", "INT8", "INTEGER", "BIGINT",
            "FLOAT4", "FLOAT8", "NUMERIC", "DECIMAL",
        }
        text = {"CHAR", "VARCHAR", "VARCHAR2", "NVARCHAR2", "TEXT"}
        return (left in numeric and right in numeric) or (left in text and right in text)

    @staticmethod
    def _set_types_equal(left_type: str, right_type: str) -> bool:
        """Apply SELECT set-operation typing without INSERT coercion rules.

        The SELECT chapter requires corresponding columns to have the same data
        type and order.  INSERT intentionally uses the broader
        ``_types_compatible`` coercion classes, but reusing those classes here
        would incorrectly accept INTEGER/NUMERIC and VARCHAR/TEXT pairs.
        """
        return str(left_type).strip().upper() == str(right_type).strip().upper()

    @staticmethod
    def _pair_set(combos: List[Dict[str, str]], parameters: List[str]) -> Set[Pair]:
        pairs: Set[Pair] = set()
        for combo in combos:
            for left, right in combinations(parameters, 2):
                pairs.add((left, combo[left], right, combo[right]))
        return pairs

    @classmethod
    def _small_space_pairwise(
        cls,
        param_space: Dict[str, List[str]],
        solver: _FactorRuleSolver,
    ) -> Tuple[List[Dict[str, str]], Set[Pair], int]:
        """Use every feasible combo as a candidate when the full space is small."""
        feasible_combos = solver.filter_combos(generate_cartesian(param_space))
        if not feasible_combos:
            raise GenerationValidationError("参数空间不存在满足目标规则的组合")
        parameters = list(param_space)
        feasible_pairs = cls._pair_set(feasible_combos, parameters)
        if not feasible_pairs:
            return feasible_combos, feasible_pairs, len(feasible_combos)

        candidates = [
            (combo, cls._pair_set([combo], parameters))
            for combo in feasible_combos
        ]
        remaining = set(feasible_pairs)
        selected: List[Dict[str, str]] = []
        while remaining:
            combo, pairs = max(candidates, key=lambda item: len(item[1] & remaining))
            gain = pairs & remaining
            if not gain:
                raise GenerationValidationError("无法从可行组合中完成 Pairwise 覆盖")
            selected.append(combo)
            remaining.difference_update(gain)
        return selected, feasible_pairs, len(feasible_combos)
