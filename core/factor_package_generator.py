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

_AUTO_INCREMENT_INSERT_TRIGGERS = {'insert_source_autoincrement_null':'NULL',
                                 'insert_source_autoincrement_zero':'0',
                                 'insert_source_autoincrement_default':'DEFAULT',
                                 'insert_source_autoincrement_omitted':'omitted'}


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
        # An inconsistent finite trigger profile is a specification error,
        # not an infeasible pair to silently remove in structural filtering.
        for source_id in param_space.get('source_profile', []):
            if source_id in _AUTO_INCREMENT_INSERT_TRIGGERS:
                value = resolved['source_profile'][source_id]
                trigger = _AUTO_INCREMENT_INSERT_TRIGGERS[source_id]
                expected_render = 'VALUES(1)' if trigger == 'omitted' else f'VALUES({trigger},1)'
                if (re.sub(r'\s+', '', value.render).upper() != expected_render
                        or value.attributes.get('source_profile.properties.auto_increment_trigger') != trigger):
                    raise GenerationValidationError('auto_increment_contract: inconsistent declared trigger profile')
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
            self._validate_selected_value_modes(manifest, combo, resolved, consumed_dimension_ids)
            fixture_refs = self._fixture_refs_for_combo(
                manifest,
                combo,
                resolved,
                consumed_dimension_ids,
            )
            fixture_refs = self._ordered_fixture_refs(fixture_refs)
            self._validate_structural_contract(factor, combo, resolved)
            self._validate_rendered_index_contract(factor, manifest, combo, resolved, sql)
            target = resolved.get('target_list', {}).get(combo.get('target_list'))
            if target and target.attributes.get('target_list.properties.function_output_contract'):
                requirements = {r.key: r.allowed_values for r in manifest.environment_requirements}
                function_contract = target.attributes['target_list.properties.function_output_contract']
                if (requirements.get('compatibility_mode') != ['M']
                        or requirements.get('function_resolution') != [function_contract]):
                    raise GenerationValidationError(
                        'M aggregate contract requires compatibility_mode=M and '
                        f'function_resolution={function_contract} gates')
            self._validate_fixture_contract(
                combo,
                resolved,
                fixture_refs,
                consumed_dimension_ids,
            )
            setup_sqls, teardown_sqls = self._compile_fixture_lifecycle(fixture_refs)
            owned_target = resolved.get('owned_by_clause', {}).get(combo.get('owned_by_clause'))
            system_targets = {'cs_owned_rowid_a_invalid': 'rowid', 'cs_owned_rowno_a_invalid': 'rowno'}
            if factor.id == 'create_sequence' and (
                    combo.get('owned_by_clause') in system_targets
                    or (owned_target and owned_target.attributes.get('owned_by_clause.properties.system_column'))):
                from .system_column_contract import check_sequence_system_target
                gates = {gate.key: gate.allowed_values for gate in manifest.environment_requirements}
                column = system_targets.get(combo.get('owned_by_clause'))
                if (column is None or owned_target is None
                        or owned_target.attributes.get('owned_by_clause.properties.system_column') is not True
                        or owned_target.attributes.get('owned_by_clause.properties.system_column_identity') != 'hasrowid_a_v1'
                        or manifest.expected.default != 'error' or manifest.expected.scope != 'syntax_and_semantics'
                        or manifest.expected.oracle_status != 'needs_verification'
                        or manifest.expected.error_category != 'system_column_ownership_forbidden'
                        or manifest.expected.sqlstates or manifest.expected.error_message_regex
                        or manifest.violates_rule_refs != ['cs_rule_owned_by_non_system_column']
                        or len(gates) != len(manifest.environment_requirements)
                        or factor.source.catalog_chapter_ref is None
                        or factor.source.catalog_chapter_ref.source_relpath != 'general/ddl/create_sequence.txt'):
                    raise GenerationValidationError('system_column_contract: finite target and uncalibrated negative required')
                try:
                    check_sequence_system_target(sql, setup_sqls, teardown_sqls, gates, 'g_a3_cs_system_owner', column)
                except ValueError as exc:
                    raise GenerationValidationError(str(exc)) from exc
            index_target = resolved.get('table_profile', {}).get(combo.get('table_profile'))
            if factor.id == 'create_index' and (
                    combo.get('table_profile') == 'ci_table_ustore_local_fresh'
                    or
                    (index_target and (index_target.attributes.get('table_profile.properties.subpartitioned')
                                       or index_target.attributes.get('table_profile.properties.index_partition_contract')))
                    or any(re.search(r'\bSUBPARTITION\s+BY\b', statement, re.I) for statement in setup_sqls)):
                from .index_partition_contract import check_index_partition, check_ustore_local_index
                from .finite_sql_contract import ReviewNeeded
                chapter = factor.source.catalog_chapter_ref
                if (index_target is None or chapter is None or chapter.source_relpath != 'general/ddl/create_index.txt'
                        or manifest.expected.default != 'success' or manifest.expected.scope != 'syntax_only'):
                    raise GenerationValidationError('index_partition_contract: reviewed general positive source required')
                gates = {gate.key: gate.allowed_values for gate in manifest.environment_requirements}
                if len(gates) != len(manifest.environment_requirements):
                    raise GenerationValidationError('index_partition_contract: duplicate environment gates')
                if 'M' in gates.get('compatibility_mode', []):
                    raise GenerationValidationError('index_partition_contract: M chapter requires separate review')
                properties = {key.removeprefix('table_profile.properties.'): value
                              for key, value in index_target.attributes.items() if key.startswith('table_profile.properties.')}
                try:
                    checker = (check_ustore_local_index
                               if combo.get('table_profile') == 'ci_table_ustore_local_fresh'
                               or properties.get('index_partition_contract') == 'ustore_range_local'
                               else check_index_partition)
                    checker(sql, setup_sqls, teardown_sqls, target=index_target.render,
                            properties=properties, gates=gates)
                except (ValueError, ReviewNeeded) as exc:
                    raise GenerationValidationError('index_partition_contract: '+getattr(exc, 'detail', str(exc))) from exc
            if factor.id == 'create_database' and any(
                    group.id == 'create_database_encoding_c_template0_profiles'
                    and any(value.id == combo.get('encoding') for value in group.values)
                    for group in factor.dimensions['encoding'].classes):
                from .database_encoding_contract import check_server_encoding_context
                try:
                    check_server_encoding_context(factor, manifest, resolved['encoding'][combo['encoding']],
                                                  resolved['encoding'], sql, setup_sqls, teardown_sqls)
                except ValueError as exc:
                    raise GenerationValidationError(str(exc)) from exc
            if factor.id in ('create_foreign_table', 'drop_foreign_table'):
                from .log_fdw_catalog_contract import check_log_fdw_catalog
                name_dimension = 'table_name' if factor.id == 'create_foreign_table' else 'table_names'
                target = resolved.get(name_dimension, {}).get(combo.get(name_dimension))
                chapter = factor.source.catalog_chapter_ref
                if (target is None or target.attributes.get(name_dimension+'.properties.foreign_table_contract')
                        != 'log_fdw_catalog_one_text_column' or chapter is None
                        or chapter.source_relpath != 'general/ddl/'+factor.id+'.txt'
                        or manifest.expected.default != 'success' or manifest.expected.scope != 'syntax_only'):
                    raise GenerationValidationError('log_fdw_catalog: explicit finite source/target contract required')
                if factor.id == 'create_foreign_table' and combo.get('format') != 'create_foreign_table_format_not_applicable':
                    raise GenerationValidationError('log_fdw_catalog: file format must be not_applicable')
                try:
                    check_log_fdw_catalog(factor.id.split('_')[0], sql, setup_sqls, teardown_sqls,
                        {gate.key: gate.allowed_values for gate in manifest.environment_requirements})
                except ValueError as exc:
                    raise GenerationValidationError(str(exc)) from exc
            if factor.id == 'alter_foreign_table':
                from .log_fdw_catalog_contract import check_log_fdw_option_change
                chapter = factor.source.catalog_chapter_ref
                gates = {gate.key: gate.allowed_values for gate in manifest.environment_requirements}
                operation = {'aft_log_'+op: op for op in ('implicit', 'add', 'set', 'drop')}.get(combo.get('operation'))
                if (chapter is None or chapter.source_relpath != 'general/ddl/alter_foreign_table.txt'
                        or manifest.expected.default != 'success' or manifest.expected.scope != 'syntax_only'
                        or operation is None or len(gates) != len(manifest.environment_requirements)
                        or 'M' in gates.get('compatibility_mode', [])):
                    raise GenerationValidationError('log_fdw_catalog: reviewed general ALTER options contract required')
                try:
                    check_log_fdw_option_change(sql, setup_sqls, teardown_sqls, gates, operation)
                except ValueError as exc:
                    raise GenerationValidationError(str(exc)) from exc
            foreign_target = resolved.get('table_profile', {}).get(combo.get('table_profile'))
            auto_actions = {'at_action_autoincrement_ten_fresh': 10, 'at_action_autoincrement_zero_fresh': 0}
            if factor.id == 'alter_table' and (
                    combo.get('action_profile') in auto_actions
                    or combo.get('table_profile') == 'at_table_autoincrement_fresh'):
                from .auto_increment_contract import check_autoincrement_transition
                gates = {gate.key: gate.allowed_values for gate in manifest.environment_requirements}
                chapter = factor.source.catalog_chapter_ref
                if (combo.get('action_profile') not in auto_actions
                        or combo.get('table_profile') != 'at_table_autoincrement_fresh'
                        or foreign_target is None
                        or foreign_target.attributes.get('table_profile.properties.auto_increment_contract') != 'fresh_initial_one'
                        or chapter is None or chapter.source_relpath != 'general/ddl/alter_table.txt'
                        or manifest.expected.default != 'success' or manifest.expected.scope != 'syntax_only'
                        or manifest.violates_rule_refs or len(gates) != len(manifest.environment_requirements)):
                    raise GenerationValidationError('auto_increment_contract: explicit finite fresh B target required')
                try:
                    evidence = check_autoincrement_transition(sql, setup_sqls, teardown_sqls, gates, foreign_target.render)
                    if evidence['requested_value'] != auto_actions[combo['action_profile']]:
                        raise ValueError('auto_increment_contract: selected action differs from rendered value')
                except ValueError as exc:
                    raise GenerationValidationError(str(exc)) from exc
            if factor.id == 'alter_table' and (
                    combo.get('action_profile') == 'at_action_set_rowid_fresh'
                    or combo.get('table_profile') == 'at_table_rowid_off_fresh'
                    or re.search(r'\bSET\s+WITH\s+ROWID\b', sql, re.I)):
                from .system_column_contract import check_alter_rowid_target
                gates = {gate.key: gate.allowed_values for gate in manifest.environment_requirements}
                chapter = factor.source.catalog_chapter_ref
                if (combo.get('action_profile') != 'at_action_set_rowid_fresh'
                        or combo.get('table_profile') != 'at_table_rowid_off_fresh'
                        or foreign_target is None
                        or foreign_target.attributes.get('table_profile.properties.rowid_transition_contract') != 'ordinary_empty_off_to_on'
                        or chapter is None or chapter.source_relpath != 'general/ddl/alter_table.txt'
                        or manifest.expected.default != 'success' or manifest.expected.scope != 'syntax_only'
                        or manifest.violates_rule_refs or len(gates) != len(manifest.environment_requirements)):
                    raise GenerationValidationError('system_column_contract: reviewed ordinary ROWID transition required')
                try:
                    check_alter_rowid_target(sql, setup_sqls, teardown_sqls, gates, foreign_target.render)
                except ValueError as exc:
                    raise GenerationValidationError(str(exc)) from exc
            if factor.id == 'alter_table' and (
                    (foreign_target and (foreign_target.attributes.get('table_profile.properties.foreign_table_contract')
                                         or foreign_target.attributes.get('table_profile.properties.external')))
                    or any(re.search(r'\bCREATE\s+FOREIGN\s+TABLE\b', statement, re.I) for statement in setup_sqls)):
                from .log_fdw_catalog_contract import check_log_fdw_enable_rls_negative
                chapter = factor.source.catalog_chapter_ref
                gates = {gate.key: gate.allowed_values for gate in manifest.environment_requirements}
                if (foreign_target is None
                        or foreign_target.attributes.get('table_profile.properties.foreign_table_contract') != 'log_fdw_enable_rls_negative'
                        or chapter is None or chapter.source_relpath != 'general/ddl/alter_table.txt'
                        or manifest.expected.default != 'error'
                        or manifest.expected.error_category != 'unsupported_rls_target'
                        or manifest.expected.scope != 'syntax_and_semantics'
                        or manifest.expected.oracle_status != 'needs_verification'
                        or manifest.violates_rule_refs != ['at_rule_rls_target_supported']
                        or len(gates) != len(manifest.environment_requirements)
                        or 'M' in gates.get('compatibility_mode', [])):
                    raise GenerationValidationError('log_fdw_catalog: reviewed general ALTER negative contract required')
                try:
                    check_log_fdw_enable_rls_negative(sql, setup_sqls, teardown_sqls, gates, foreign_target.render)
                except ValueError as exc:
                    raise GenerationValidationError(str(exc)) from exc
            self._validate_fixture_write_contract(factor, setup_sqls)
            self._validate_rendered_index_keys(factor, manifest, combo, resolved, sql, setup_sqls)
            partition_target=resolved.get('partition_table_profile',{}).get(combo.get('partition_table_profile'))
            partition_contract=(partition_target.attributes.get('partition_table_profile.properties.partition_selector_contract')
                                if partition_target else None)
            if partition_contract:
                from .partition_selector_contract import check_rendered_partition_selector
                from .finite_sql_contract import ReviewNeeded
                chapter=factor.source.catalog_chapter_ref
                if (partition_contract!='integer_range_key_shape' or chapter is None or
                        chapter.source_relpath!='general/ddl/truncate.txt' or
                        any(r.key=='compatibility_mode' and r.allowed_values!=['general'] for r in manifest.environment_requirements)):
                    raise GenerationValidationError('partition_contract_unknown: requires reviewed general TRUNCATE source')
                partition_value=resolved.get('partition_value_profile',{}).get(combo.get('partition_value_profile'))
                try:
                    check_rendered_partition_selector(sql,setup_sqls,profile_target=partition_target.render,
                        keys=partition_target.attributes.get('partition_table_profile.properties.partition_keys'),
                        values=(partition_value.attributes.get('partition_value_profile.properties.items') if partition_value else None))
                except ReviewNeeded as exc:
                    raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            single_modify_action = resolved.get('action_profile', {}).get(combo.get('action_profile'))
            if (factor.id == 'alter_table' and single_modify_action
                    and single_modify_action.attributes.get('action_profile.properties.column_modify_single_contract_required')):
                single_target = resolved.get('table_profile', {}).get(combo.get('table_profile'))
                if not single_target or not single_target.attributes.get('table_profile.properties.column_modify_single_contract'):
                    raise GenerationValidationError('column_modify_single_contract: selected action requires actual target contract')
            for dimension_id in consumed_dimension_ids:
                table_target = resolved.get(dimension_id, {}).get(combo.get(dimension_id))
                contract_keys = [dimension_id+'.properties.'+key for key in ('column_rename_contract','column_add_contract','column_modify_contract','column_modify_single_contract')
                                 if table_target and dimension_id+'.properties.'+key in table_target.attributes]
                if not contract_keys:
                    continue
                if len(contract_keys)!=1:
                    raise GenerationValidationError('Column transition must select exactly one contract')
                contract_key=contract_keys[0];column_contract=table_target.attributes[contract_key]
                if contract_key.endswith('.column_modify_single_contract'):
                    from .shared_column_contract import check_rendered_column_modify_single_b
                    from .finite_sql_contract import ReviewNeeded
                    chapter = factor.source.catalog_chapter_ref
                    if (not isinstance(column_contract, dict) or set(column_contract) != {'kind', 'widen_column'}
                            or column_contract['kind'] != 'ordinary_b_single_widen'
                            or chapter is None or chapter.source_relpath != 'general/ddl/alter_table.txt'
                            or manifest.expected.scope != 'syntax_only' or manifest.expected.default != 'success'):
                        raise GenerationValidationError('column_modify_single_contract: finite general positive source required')
                    try:
                        check_rendered_column_modify_single_b(sql, setup_sqls, teardown_sqls,
                            profile_target=table_target.render, widen_column=column_contract['widen_column'],
                            requirements=manifest.environment_requirements)
                    except ReviewNeeded as exc:
                        raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
                    continue
                is_add=contract_key.endswith('.column_add_contract')
                is_modify=contract_key.endswith('.column_modify_contract')
                from .finite_sql_contract import ReviewNeeded
                from .shared_column_contract import check_rendered_column_rename, check_rendered_column_add, check_rendered_column_modify
                fields=({'kind','added_column'} if is_add else {'kind','widen_column','not_null_column'}
                        if is_modify else {'kind','source_column','target_column'})
                kind=('ordinary_nullable_integer' if is_add else 'ordinary_widen_and_not_null'
                      if is_modify else 'ordinary_same_definition')
                if not isinstance(column_contract,dict) or set(column_contract)!=fields or column_contract['kind']!=kind:
                    raise GenerationValidationError('Unknown column transition contract shape')
                gates = [r.allowed_values for r in manifest.environment_requirements if r.key == 'compatibility_mode']
                if len(gates)>1:
                    raise GenerationValidationError('column_rename_mode: duplicate compatibility_mode gates')
                chapter = factor.source.catalog_chapter_ref
                chapter_modes = {'general/ddl/alter_table.txt':'B','m_compat/ddl/alter_table.txt':'M'}
                if chapter is None or chapter.source_relpath not in chapter_modes:
                    raise GenerationValidationError('column_rename_source_unknown: requires reviewed ALTER TABLE chapter identity')
                if is_modify and chapter.source_relpath!='general/ddl/alter_table.txt':
                    raise GenerationValidationError('column_modify_source_unknown: requires reviewed general MODIFY chapter')
                try:
                    if is_modify:
                        check_rendered_column_modify(sql,setup_sqls,profile_target=table_target.render,
                            widen_column=column_contract['widen_column'],not_null_column=column_contract['not_null_column'])
                    elif is_add:
                        check_rendered_column_add(sql,setup_sqls,profile_target=table_target.render,
                            added_column=column_contract['added_column'],compatibility_modes=gates[0] if gates else [],
                            position_compatibility_mode=chapter_modes[chapter.source_relpath])
                    else:
                        check_rendered_column_rename(sql, setup_sqls, profile_target=table_target.render,
                            source_column=column_contract['source_column'], target_column=column_contract['target_column'],
                            compatibility_modes=gates[0] if gates else [],
                            change_compatibility_mode=chapter_modes[chapter.source_relpath])
                except ReviewNeeded as exc:
                    raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            insert_target = resolved.get('target_profile', {}).get(combo.get('target_profile'))
            auto_insert_sources = _AUTO_INCREMENT_INSERT_TRIGGERS
            auto_insert_targets = {'insert_target_autoincrement_fresh':'g_b_insert_autoinc(id,note)',
                                   'insert_target_autoincrement_omitted':'g_b_insert_autoinc(note)'}
            auto_insert_marker = (insert_target.attributes.get('target_profile.properties.auto_increment_contract')
                                  if insert_target else None)
            if (combo.get('target_profile') in auto_insert_targets
                    or combo.get('source_profile') in auto_insert_sources or auto_insert_marker):
                from .auto_increment_contract import check_autoincrement_insert
                gates = {gate.key:gate.allowed_values for gate in manifest.environment_requirements}
                chapter = factor.source.catalog_chapter_ref
                if (factor.id != 'insert' or chapter is None or chapter.source_relpath != 'general/dml/insert.txt'
                        or combo.get('target_profile') not in auto_insert_targets
                        or combo.get('source_profile') not in auto_insert_sources
                        or auto_insert_marker != 'fresh_initial_one'
                        or manifest.expected.default != 'success' or manifest.expected.scope != 'syntax_only'
                        or manifest.violates_rule_refs or len(gates) != len(manifest.environment_requirements)
                        or re.sub(r'\s+', '', insert_target.render).lower() != auto_insert_targets[combo['target_profile']]
                        or (combo['target_profile'] == 'insert_target_autoincrement_omitted')
                            != (auto_insert_sources[combo['source_profile']] == 'omitted')):
                    raise GenerationValidationError('auto_increment_contract: reviewed B INSERT identity required')
                try:
                    evidence = check_autoincrement_insert(sql, setup_sqls, teardown_sqls, gates, 'g_b_insert_autoinc')
                    if evidence['allocation_trigger'] != auto_insert_sources[combo['source_profile']]:
                        raise ValueError('auto_increment_contract: selected trigger differs from rendered input')
                except ValueError as exc:
                    raise GenerationValidationError(str(exc)) from exc
            partial_contract = (insert_target.attributes.get('target_profile.properties.partial_index_contract')
                                if insert_target else None)
            conflict_value = resolved.get('conflict_clause', {}).get(combo.get('conflict_clause'))
            partial_required = (conflict_value and conflict_value.attributes.get(
                'conflict_clause.properties.partial_index_contract_required'))
            # A removed tag must not silently turn actual expression/partial
            # arbitration into ordinary input-column validation.
            actual_partial = (factor.id == 'insert' and re.search(
                r'\bON\s+CONFLICT\s*\(\s*\(.*\bWHERE\b',
                re.sub(r"'(?:''|[^'])*'|\"(?:\"\"|[^\"])*\"", "''", sql), re.I | re.S))
            if partial_contract or partial_required or actual_partial:
                from .insert_partial_index_contract import check_partial_index_insert
                from .finite_sql_contract import ReviewNeeded
                chapter = factor.source.catalog_chapter_ref
                gates = {gate.key: gate.allowed_values for gate in manifest.environment_requirements}
                required = {'compatibility_mode': ['PG'],
                            'operator_binding': ['builtin_integer_plus_and_gt'],
                            'actor_authority': ['fixture_creator_insert_select_index'],
                            'case_namespace': ['isolated_user_schema']}
                if (partial_contract != 'integer_plus_one_exact_predicate' or factor.id != 'insert'
                        or chapter is None or chapter.source_relpath != 'general/dml/insert.txt'
                        or manifest.expected.default != 'success' or manifest.expected.scope != 'syntax_only'
                        or len(gates) != len(manifest.environment_requirements)
                        or any(gates.get(key) != value for key, value in required.items())):
                    raise GenerationValidationError('partial_index_contract: explicit general PG source, target and gates required')
                try:
                    evidence = check_partial_index_insert(sql, setup_sqls, teardown_sqls)
                    partial_expected_target = evidence['table']+'('+evidence['key_column']+','+evidence['predicate_column']+')'
                    if re.sub(r'\s+', '', insert_target.render).lower() != partial_expected_target:
                        raise ReviewNeeded('partial_index_target_unknown', 'Profile target disagrees with actual index target')
                except ReviewNeeded as exc:
                    raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            replace_contract = (insert_target.attributes.get('target_profile.properties.replace_conflict_contract')
                                if insert_target else None)
            if replace_contract:
                from .finite_sql_contract import Contradiction, ReviewNeeded
                from .shared_column_contract import check_rendered_replace_unique_keys
                modes = {r.key: r.allowed_values for r in manifest.environment_requirements}
                if replace_contract != 'fixture_two_inline_integer_keys' or modes.get('compatibility_mode') != ['M']:
                    raise GenerationValidationError('Finite REPLACE unique_key contract requires compatibility_mode=M')
                source = resolved.get('source_profile', {}).get(combo.get('source_profile'))
                try:
                    check_rendered_replace_unique_keys(sql, setup_sqls, profile_target=insert_target.render,
                        required_keys=insert_target.attributes.get('target_profile.properties.required_inline_keys'),
                        expected_conflicts=(source.attributes.get('source_profile.properties.expected_conflict_rows')
                                            if source else None))
                except (Contradiction, ReviewNeeded) as exc:
                    raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            primary_key_contract = (insert_target.attributes.get('target_profile.properties.primary_key_contract')
                                    if insert_target else None)
            if primary_key_contract:
                from .finite_sql_contract import Contradiction, ReviewNeeded
                from .shared_column_contract import check_rendered_insert_primary_key
                modes = {r.key: r.allowed_values for r in manifest.environment_requirements}
                if primary_key_contract != 'fixture_inline_primary_key':
                    raise GenerationValidationError('Unknown primary_key_contract: '+str(primary_key_contract))
                if modes.get('compatibility_mode') != ['PG']:
                    raise GenerationValidationError('PG primary-key conflict contract requires compatibility_mode=PG')
                try:
                    check_rendered_insert_primary_key(sql, setup_sqls, profile_target=insert_target.render,
                        key_columns=insert_target.attributes.get('target_profile.properties.required_primary_key'))
                except (Contradiction, ReviewNeeded) as exc:
                    raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            target_contract = (insert_target.attributes.get('target_profile.properties.target_column_contract')
                               if insert_target else None)
            if target_contract:
                from .finite_sql_contract import Contradiction, ReviewNeeded
                from .shared_column_contract import check_rendered_insert_target
                attributes = insert_target.attributes
                try:
                    check_rendered_insert_target(sql, setup_sqls,
                        profile_target=insert_target.render,
                        available_types=attributes.get('target_profile.properties.available_types', []),
                        available_count=attributes.get('target_profile.properties.available_column_count'),
                        target_types=attributes.get('target_profile.properties.target_types', []),
                        target_count=attributes.get('target_profile.properties.target_column_count'),
                        explicit_columns=attributes.get('target_profile.properties.explicit_columns', False),
                        is_view=attributes.get('target_profile.properties.is_view', False),
                        generated=attributes.get('target_profile.properties.generated', False),
                        generated_columns=attributes.get('target_profile.properties.generated_columns', []),
                        contract=target_contract)
                except (Contradiction, ReviewNeeded) as exc:
                    raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            query_source_profile = resolved.get('source_profile', {}).get(combo.get('source_profile'))
            query_contract = (query_source_profile.attributes.get('source_profile.properties.query_output_contract')
                              if query_source_profile else None)
            if query_contract:
                from .finite_sql_contract import Contradiction, ReviewNeeded
                from .query_output_contract import check_rendered_insert_query
                try:
                    check_rendered_insert_query(sql, setup_sqls,
                        profile_query=query_source_profile.render,
                        output_types=query_source_profile.attributes.get('source_profile.properties.output_types', []),
                        source_tables=query_source_profile.attributes.get('source_profile.properties.source_tables', []),
                        source_columns=query_source_profile.attributes.get('source_profile.properties.source_columns', []),
                        contract=query_contract)
                except (Contradiction, ReviewNeeded) as exc:
                    raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            if target and target.attributes.get('target_list.properties.function_output_contract'):
                from .finite_sql_contract import Contradiction, ReviewNeeded
                from .query_output_contract import check_rendered_aggregate_source
                source = resolved['source_form'][combo['source_form']]
                chapter = factor.source.catalog_chapter_ref
                try:
                    check_rendered_aggregate_source(sql, setup_sqls,
                        items=target.attributes.get('target_list.properties.items', []),
                        output_types=target.attributes.get('target_list.properties.output_types', []),
                        available_columns=source.attributes.get('source_form.properties.available_columns', []),
                        available_types=source.attributes.get('source_form.properties.available_types', []),
                        source_tables=target.attributes.get('target_list.properties.source_tables', []),
                        mode='M' if chapter and chapter.source_relpath.startswith('m_compat/') else None,
                        identity=target.attributes['target_list.properties.function_output_contract'])
                except (Contradiction, ReviewNeeded) as exc:
                    raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            file_assets = self._compile_fixture_files(fixture_refs, sql, setup_sqls)
            for dimension in ('query_profile', 'source_profile'):
                selected_profile = resolved.get(dimension, {}).get(combo.get(dimension))
                if not selected_profile or dimension not in consumed_dimension_ids:
                    continue
                common_contract = selected_profile.attributes.get(dimension+'.properties.common_type_contract')
                if common_contract:
                    from .common_type_contract import CONTRACT_MODES, check_common_type_query
                    from .finite_sql_contract import Contradiction, ReviewNeeded
                    modes = [r.allowed_values for r in manifest.environment_requirements if r.key == 'compatibility_mode']
                    chapter = factor.source.catalog_chapter_ref
                    required_mode = CONTRACT_MODES.get(common_contract)
                    if (required_mode is None or modes != [[required_mode]]
                            or not chapter or not chapter.source_relpath.startswith('general/')):
                        raise GenerationValidationError(f'Common type contract requires general source and one physical {required_mode or "known"} gate')
                    try:
                        check_common_type_query(sql, setup_sqls, mode=required_mode, contract=common_contract,
                            output_types=selected_profile.attributes.get(dimension+'.properties.output_types'))
                    except (Contradiction, ReviewNeeded) as exc:
                        raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            if manifest.expected.default == "success":
                chapter = factor.source.catalog_chapter_ref
                from .auto_increment_contract import insert_audit_context
                rendered_contract = inspect_write(sql, setup_sqls, conflict_source_scope=(
                    'm_compat' if chapter and chapter.source_relpath.startswith('m_compat/') else 'general'),
                    auto_increment_context=insert_audit_context(combo,
                        [gate.model_dump() for gate in manifest.environment_requirements],teardown_sqls))
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
                file_assets=file_assets,
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
    def _validate_selected_value_modes(manifest, combo, resolved, consumed_dimensions):
        """Opt-in applicability on actually rendered values; never a DB probe.

        A manifest may narrow a value's declared modes, not broaden them.
        Multiple active requirements all apply. No solver context injection,
        implicit mode, inactive-branch constraint or expected-result rewriting.
        """
        gates = [r for r in manifest.environment_requirements if r.key == 'compatibility_mode']
        for dimension in consumed_dimensions:
            value = resolved[dimension][combo[dimension]]
            environment_key = dimension + '.properties.required_environment_capabilities'
            if environment_key in value.attributes:
                requirements = value.attributes[environment_key]
                if not isinstance(requirements, dict) or not requirements:
                    raise GenerationValidationError(f'{manifest.id}: invalid required_environment_capabilities for {dimension}')
                for name, required_values in requirements.items():
                    if (not isinstance(name, str) or not name or not isinstance(required_values, list)
                            or not required_values or not all(isinstance(v, str) and v for v in required_values)
                            or len(set(required_values)) != len(required_values)):
                        raise GenerationValidationError(f'{manifest.id}: invalid environment requirement for {dimension}')
                    matching = [r for r in manifest.environment_requirements if r.key == name]
                    if len(matching) != 1:
                        raise GenerationValidationError(f'{manifest.id}: {dimension} requires exactly one {name} gate')
                    allowed_values = matching[0].allowed_values
                    if (not allowed_values or not all(isinstance(v, str) for v in allowed_values)
                            or len(set(allowed_values)) != len(allowed_values)
                            or not set(allowed_values).issubset(required_values)):
                        raise GenerationValidationError(f'{manifest.id}: {name} broadens {dimension} requirement')
            key = dimension + '.properties.required_compatibility_modes'
            if key not in value.attributes:
                continue
            required = value.attributes[key]
            if (not isinstance(required, list) or not required
                    or not all(isinstance(mode, str) and mode in {'A','B','C','PG','M'} for mode in required)
                    or len(set(required)) != len(required)):
                raise GenerationValidationError(f'{manifest.id}: invalid required_compatibility_modes for {dimension}')
            if len(gates) != 1:
                raise GenerationValidationError(f'{manifest.id}: {dimension} requires exactly one compatibility_mode gate')
            allowed = gates[0].allowed_values
            if (not allowed or len(set(allowed)) != len(allowed)
                    or not set(allowed).issubset(required)):
                raise GenerationValidationError(
                    f'{manifest.id}: compatibility_mode {allowed} broadens {dimension} requirement {required}')

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

    def _compile_fixture_files(self, fixture_refs, sql, setup_sqls):
        from .fixture_file_contract import inspect_fixture_files
        files=[];targets=set()
        referenced=set(re.findall(r"\b(?:INFILE|FROM|TO)\s+'([^']+)'", '\n'.join([sql]+setup_sqls), re.I))
        for fixture_id in self._ordered_fixture_refs(fixture_refs):
            fixture=self.registry.get_fixture(fixture_id)
            if not fixture or not fixture.provides.files:
                continue
            for asset in inspect_fixture_files(fixture, self.registry.source_paths[fixture_id], self.registry.specs_dir):
                if asset['target_path'] in targets:raise ValueError('duplicate file asset target across fixtures')
                if asset['target_path'] not in referenced:raise ValueError('file asset target not referenced by SQL')
                targets.add(asset['target_path']);files.append(asset)
        return files

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
                chapter = factor.source.catalog_chapter_ref
                FactorPackageSQLGenerator._validate_select_expression_contract(
                    combo, resolved,
                    documented_mode='M' if chapter and chapter.source_relpath.startswith('m_compat/') else None,
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
    def _validate_rendered_index_contract(factor, manifest, combo, resolved, sql):
        """Hard post-render guard: never silently discard declared pairs."""
        from .finite_sql_contract import ReviewNeeded
        from .index_storage_contract import check_rendered_index_fillfactor
        for check in factor.structural_checks:
            if check.kind != 'index_fillfactor_contract':
                continue
            chapter = factor.source.catalog_chapter_ref
            requirements = [r for r in manifest.environment_requirements if r.key == 'compatibility_mode']
            if (not chapter or not chapter.source_relpath.startswith('m_compat/')
                    or len(requirements) != 1 or requirements[0].allowed_values != ['M']):
                raise GenerationValidationError('index_fillfactor_mode: requires M source and exact M gate')
            # A negative label alone is insufficient; its targeted rule must
            # consume the same confirmed constraint fact as this actual check.
            facts = [f for f in factor.facts if f.id in check.fact_refs]
            rules = [r for r in factor.rules if set(r.fact_refs) == set(check.fact_refs)]
            if (len(check.fact_refs) != 1 or len(facts) != 1 or facts[0].type != 'constraint'
                    or facts[0].status != 'confirmed' or len(rules) != 1):
                raise GenerationValidationError('index_fillfactor_fact_rule: requires one confirmed constraint/rule')
            storage = resolved.get('storage', {}).get(combo.get('storage'))
            if storage is None:
                raise GenerationValidationError('index_storage_unknown: missing selected storage')
            try:
                result = check_rendered_index_fillfactor(sql, storage.render)
            except ReviewNeeded as exc:
                raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc
            targeted = rules[0].id in manifest.violates_rule_refs
            if result['range_valid']:
                if targeted:
                    raise GenerationValidationError('index_fillfactor_target_not_violated: actual range is valid')
            elif not (targeted and manifest.suite_type == 'negative' and manifest.expected.default == 'error'):
                raise GenerationValidationError(
                    f"index_fillfactor_range: actual {result['fillfactor']} outside documented 10..100")

    @staticmethod
    def _validate_rendered_index_keys(factor, manifest, combo, resolved, sql, setup):
        from .finite_sql_contract import ReviewNeeded
        from .index_storage_contract import check_rendered_index_keys
        for check in factor.structural_checks:
            if check.kind != 'index_key_source_contract':
                continue
            chapter = factor.source.catalog_chapter_ref
            requirements = [r for r in manifest.environment_requirements if r.key == 'compatibility_mode']
            if (not chapter or not chapter.source_relpath.startswith('m_compat/')
                    or len(requirements) != 1 or requirements[0].allowed_values != ['M']):
                raise GenerationValidationError('index_key_mode: requires M source and exact M gate')
            facts = [f for f in factor.facts if f.id in check.fact_refs]
            if (len(check.fact_refs) != 2 or len(facts) != 2
                    or any(f.type != 'constraint' or f.status != 'confirmed' for f in facts)):
                raise GenerationValidationError('index_key_facts: requires confirmed source/limit constraints')
            key = resolved.get('key_profile', {}).get(combo.get('key_profile'))
            if key is None:
                raise GenerationValidationError('index_key_unknown: missing key profile')
            try:
                check_rendered_index_keys(sql, setup,
                    items=key.attributes.get('key_profile.properties.items', []),
                    key_count=key.attributes.get('key_profile.properties.key_column_count'),
                    source_tables=key.attributes.get('key_profile.properties.source_tables', []),
                    source_columns=key.attributes.get('key_profile.properties.source_columns', []))
            except ReviewNeeded as exc:
                raise GenerationValidationError(f'{manifest.id}: {exc.code}: {exc.detail}') from exc

    @staticmethod
    def _validate_fixture_write_contract(factor, setup):
        """Opt-in finite seed writes; setup errors cannot satisfy a target Oracle.

        Each write sees only preceding setup. This does not prove DDL execution,
        final target state, seed cardinality, uniqueness, triggers or runtime.
        Unsupported writes remain unknown instead of being silently passed.
        """
        for check in factor.structural_checks:
            if check.kind != 'fixture_write_contract':
                continue
            facts = [f for f in factor.facts if f.id in check.fact_refs]
            if (not check.fact_refs or len(facts) != len(check.fact_refs)
                    or any(f.type != 'constraint' or f.status != 'confirmed' for f in facts)):
                raise GenerationValidationError('fixture_write_facts: requires confirmed constraint evidence')
            inspected = 0
            for index, sql in enumerate(setup):
                if '--' in sql or '/*' in sql:
                    raise GenerationValidationError('fixture_write_unknown: commented setup is outside finite scope')
                if not re.match(r'^\s*(?:INSERT|UPDATE|REPLACE|DELETE|WITH)\b', sql, re.I):
                    continue
                chapter = factor.source.catalog_chapter_ref
                result = inspect_write(sql, setup[:index], conflict_source_scope=(
                    'm_compat' if chapter and chapter.source_relpath.startswith('m_compat/') else 'general'))
                if result['status'] != 'checked':
                    kind = 'contradiction' if result['status'] == 'rejected' else 'unknown'
                    raise GenerationValidationError(f"fixture_write_{kind}: step {index}: {result['issues']}")
                inspected += 1
            if not inspected:
                raise GenerationValidationError('fixture_write_unknown: no finite setup writes were inspected')

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
        Untyped NULL markers are narrower: actual finite VALUES tokens must
        establish them; they do not widen the common type-compatibility helper.
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

        null_positions = {i for i, typ in enumerate(source_types) if str(typ).upper() == 'NULL'}
        if null_positions:
            from .finite_sql_contract import ReviewNeeded
            from .shared_column_contract import finite_values_null_positions, finite_rendered_values_null_positions
            try:
                if source.render.strip():
                    proven_nulls = finite_rendered_values_null_positions(source.render, output_count)
                else:
                    proven_nulls = finite_values_null_positions(
                        source.attributes.get('source_profile.properties.items'), output_count)
                if not null_positions.issubset(proven_nulls):
                    raise ReviewNeeded('null_input_unknown', 'Declared NULL differs from actual VALUES tokens')
            except ReviewNeeded as exc:
                raise GenerationValidationError(f"INSERT {source.id}: {exc.code}: {exc.detail}") from exc

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
            and index - 1 not in null_positions
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
        documented_mode: Optional[str] = None,
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

        from .finite_sql_contract import Contradiction
        from .shared_column_contract import check_direct_projection_types

        def check_projection(items, types):
            try:
                check_direct_projection_types(items, types, available_columns, available_types)
            except Contradiction as exc:
                raise GenerationValidationError(f"SELECT 投影类型不兼容或列不存在 {exc.code}: {exc.detail}") from exc

        check_projection(target_items, target_output_types)

        function_contract = target.attributes.get('target_list.properties.function_output_contract')
        if function_contract:
            from .finite_sql_contract import ReviewNeeded
            from .query_output_contract import check_documented_aggregate_types
            if not target.attributes.get('target_list.properties.has_aggregate', False):
                raise GenerationValidationError('Function signature requires aggregate projection identity')
            try:
                check_documented_aggregate_types(target_items, target_output_types,
                    available_columns, available_types, mode=documented_mode, identity=function_contract)
            except (ReviewNeeded, Contradiction) as exc:
                raise GenerationValidationError(f'SELECT {exc.code}: {exc.detail}') from exc

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
        # New variants carry semantics, not the general package's value ID.
        # Preserve the legacy default for existing specs without this property.
        lock_value = selected("lock_clause")
        lock_active = bool(lock_value.attributes.get(
            "lock_clause.properties.active",
            combo.get("lock_clause") != "select_lock_none",
        ))
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
            # The right SELECT may read another table; do not borrow the left
            # source's types. Its source/fixture proof remains a separate gate.
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
