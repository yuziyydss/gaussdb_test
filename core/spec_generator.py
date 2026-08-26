"""文法与插槽生成引擎 (Spec Generator Engine)：

编译 (ManifestDef + SyntaxDef + MatrixDef + SchemaContext)，
实现 AST 插槽递归展开、多列列表生成、CSP 约束过滤与错误码自动传播。
"""
import re
from typing import List, Dict, Any, Optional, Tuple

from .spec_model import SyntaxDef, MatrixDef, ManifestDef, SlotDef, SubGrammarDef, SpecRegistry
from .combinator import generate
from .constraint_solver import ConstraintSolver
from .generator import GeneratedCase, _clean_sql
from .symbol_table import SchemaContext, TableSymbol, ColumnSymbol, apply_sql_effect_to_context


class SpecSQLGenerator:
    """基于解耦规格（语法 + 矩阵 + 清单）的下一代 SQL 生成引擎。"""

    def __init__(self, registry: SpecRegistry):
        self.registry = registry

    def generate_cases_for_manifest(self, manifest: ManifestDef,
                                    context: SchemaContext = None) -> List[GeneratedCase]:
        """根据测试清单生成完整测试用例集。"""
        syntax = self.registry.get_syntax(manifest.target_syntax)
        if not syntax:
            raise ValueError(f"Target syntax not found: {manifest.target_syntax}")

        # 1. 加载并合并所有关联的兼容矩阵
        merged_matrix = self._merge_matrices(manifest.import_matrices)

        # 2. 准备参数组合搜索空间
        param_space = dict(manifest.bindings)
        # 如果清单未绑定某插槽但语法中有默认 values，补齐插槽候选值
        for slot_name, slot_def in syntax.slots.items():
            if slot_name not in param_space and slot_def.values:
                param_space[slot_name] = slot_def.values

        if not param_space:
            param_space["_dummy"] = ["1"]

        # 3. 运行组合算法 (Pairwise / Cartesian / Equivalence)
        raw_combos = generate(param_space, manifest.strategy)

        # 4. 收集并应用所有约束 (Matrix 兼容性规则 + Manifest 自定义约束)
        all_rules = list(merged_matrix.compatibility_rules) + list(manifest.additional_constraints)
        if all_rules:
            solver = ConstraintSolver(all_rules)
            valid_combos = solver.filter_combos(raw_combos)
        else:
            valid_combos = raw_combos

        # 5. 逐个组合进行 AST 插槽展开与 SQL 渲染
        cases: List[GeneratedCase] = []
        case_idx = 0

        for combo in valid_combos:
            case_idx += 1
            case_id = f"{manifest.id}_{case_idx:04d}"

            # 递归展开插槽并推导预期结果
            rendered_sql, expected, sqlstates = self._expand_and_render(
                syntax=syntax,
                combo=combo,
                matrix=merged_matrix,
                context=context
            )

            cases.append(GeneratedCase(
                factor_id=manifest.id,
                case_id=case_id,
                strategy=manifest.strategy,
                params=dict(combo),
                sql=_clean_sql(rendered_sql),
                expected=expected,
                expected_sqlstate=sqlstates[0] if sqlstates else "",
                expected_sqlstates=sqlstates,
                context="default",
            ))

        return cases

    def _merge_matrices(self, matrix_refs: List[str]) -> MatrixDef:
        """合并清单引用的所有兼容矩阵。"""
        merged = MatrixDef(id="merged_matrix", name="Merged Matrix")
        for mref in matrix_refs:
            m = self.registry.get_matrix(mref)
            if m:
                merged.data_types.update(m.data_types)
                merged.storage_engines.update(m.storage_engines)
                merged.compatibility_rules.extend(m.compatibility_rules)
        return merged

    def _expand_and_render(self, syntax: SyntaxDef, combo: Dict[str, str],
                           matrix: MatrixDef, context: SchemaContext = None) -> Tuple[str, str, List[str]]:
        """执行 AST 插槽展开，同时自动推导预期结果与 SQLSTATE 错误码集合。"""
        expected = "success"
        sqlstates: List[str] = []

        scope: Dict[str, str] = {}

        # 遍历主语法的所有插槽
        for slot_name, slot_def in syntax.slots.items():
            slot_val = combo.get(slot_name)

            # 1. 列表插槽展开 (element_list): 如 table_body 多列
            if slot_def.type == "element_list":
                col_type = combo.get("column_datatype") or combo.get(f"{slot_name}.column_datatype") or "INTEGER"
                col_constraint = combo.get("column_constraint") or combo.get(f"{slot_name}.column_constraint") or ""
                
                # 检查数据类型是否属于 Matrix 中定义的非法类型
                dt_def = matrix.data_types.get(col_type)
                if dt_def and dt_def.invalid_values and col_type in dt_def.invalid_values:
                    expected = "error"
                    sqlstates.extend(dt_def.expected_sqlstates_for_invalid)
                elif col_type == "FAKETYPE":
                    expected = "error"
                    sqlstates.extend(["42704", "42601"])

                # 生成列定义
                elements = [f"col_1 {col_type} {col_constraint}".strip()]
                # 支持多列生成
                if slot_def.min_elements > 1:
                    elements.append("col_2 VARCHAR(50)")
                scope[slot_name] = slot_def.delimiter.join(elements)

            # 2. 普通 Token 插槽展开
            else:
                val_to_use = slot_val if slot_val is not None else (slot_def.values[0] if slot_def.values else "")
                
                # 检查非法类型
                if slot_name == "column_datatype" and val_to_use == "FAKETYPE":
                    expected = "error"
                    sqlstates.extend(["42704", "42601"])
                elif slot_name in matrix.data_types:
                    dt = matrix.data_types[slot_name]
                    if dt.invalid_values and val_to_use in dt.invalid_values:
                        expected = "error"
                        sqlstates.extend(dt.expected_sqlstates_for_invalid)

                # 符号动作处理 (Symbol action)
                if slot_def.symbol_action == "consumes_table" and context:
                    tbl = context.pick_table()
                    if tbl:
                        val_to_use = tbl.name

                scope[slot_name] = val_to_use

        # 绑定通用默认常量 (如 table_name)
        if "table_name" not in scope:
            scope["table_name"] = combo.get("table_name", "t_factor_test")

        # 渲染最终产生式模板
        try:
            rendered = syntax.production.format(**scope)
        except KeyError as e:
            # 插槽未完全填充时优雅回退
            missing_key = str(e).strip("'")
            scope[missing_key] = ""
            rendered = syntax.production.format(**scope)

        return rendered, expected, sqlstates
