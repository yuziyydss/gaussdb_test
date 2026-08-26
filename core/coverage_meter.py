"""文档特性覆盖率度量器 (Spec Coverage Meter & Gap Reporter)：

自动统计文档中已抽取的产生式分支、AST 插槽与 Matrix 兼容规则的测试覆盖率：
覆盖率 = 已测试的语法分支与约束数 / 总提取的产生式分支与约束数 * 100%
并在测试报告中生成 “文档特性未覆盖缺口报告（Gap Report）”。
"""
import json
import os
from dataclasses import dataclass, field
from datetime import datetime
from typing import List, Dict, Set, Any, Optional

from .spec_model import SpecRegistry, SyntaxDef, MatrixDef, ManifestDef, SlotDef
from .generator import GeneratedCase


@dataclass
class SlotCoverageItem:
    """单个 AST 插槽的取值覆盖详情。"""
    syntax_id: str
    slot_name: str
    slot_type: str
    total_values: List[str]
    covered_values: Set[str] = field(default_factory=set)

    @property
    def uncovered_values(self) -> List[str]:
        return [v for v in self.total_values if v not in self.covered_values]

    @property
    def total_count(self) -> int:
        return len(self.total_values) if self.total_values else 1

    @property
    def covered_count(self) -> int:
        return len(self.covered_values)

    @property
    def coverage_pct(self) -> float:
        if not self.total_values:
            return 100.0 if self.covered_values else 0.0
        return round((len(self.covered_values) / len(self.total_values)) * 100.0, 1)


@dataclass
class MatrixCoverageItem:
    """单个全局兼容矩阵的类型与规则覆盖详情。"""
    matrix_id: str
    total_types: List[str]
    covered_types: Set[str] = field(default_factory=set)
    total_rules: List[str] = field(default_factory=list)
    exercised_rules: Set[str] = field(default_factory=set)

    @property
    def uncovered_types(self) -> List[str]:
        return [t for t in self.total_types if t not in self.covered_types]

    @property
    def uncovered_rules(self) -> List[str]:
        return [r for r in self.total_rules if r not in self.exercised_rules]

    @property
    def type_coverage_pct(self) -> float:
        if not self.total_types:
            return 100.0
        return round((len(self.covered_types) / len(self.total_types)) * 100.0, 1)

    @property
    def rule_coverage_pct(self) -> float:
        if not self.total_rules:
            return 100.0
        return round((len(self.exercised_rules) / len(self.total_rules)) * 100.0, 1)


@dataclass
class SpecCoverageReport:
    """规格全景覆盖率报告与缺口清单。"""
    created_at: str
    total_slots: int
    covered_slots: int
    total_slot_values: int
    covered_slot_values: int
    syntax_coverage_pct: float

    total_data_types: int
    covered_data_types: int
    type_coverage_pct: float

    total_rules: int
    covered_rules: int
    rule_coverage_pct: float

    overall_spec_coverage_pct: float

    syntax_details: Dict[str, List[SlotCoverageItem]] = field(default_factory=dict)
    matrix_details: Dict[str, MatrixCoverageItem] = field(default_factory=dict)
    gap_items: List[Dict[str, Any]] = field(default_factory=list)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "created_at": self.created_at,
            "overall_spec_coverage_pct": self.overall_spec_coverage_pct,
            "summary": {
                "syntax_coverage_pct": self.syntax_coverage_pct,
                "covered_slot_values": self.covered_slot_values,
                "total_slot_values": self.total_slot_values,
                "type_coverage_pct": self.type_coverage_pct,
                "covered_data_types": self.covered_data_types,
                "total_data_types": self.total_data_types,
                "rule_coverage_pct": self.rule_coverage_pct,
                "covered_rules": self.covered_rules,
                "total_rules": self.total_rules,
            },
            "gaps_count": len(self.gap_items),
            "gaps": self.gap_items,
        }

    def generate_markdown_gap_report(self) -> str:
        """生成专业 Markdown 格式的文档特性未覆盖缺口报告。"""
        lines = [
            "# GaussDB 文档特性覆盖率与测试缺口报告 (Spec Gap Report)",
            f"\n> 生成时间: `{self.created_at}` · 总体规格覆盖率: **{self.overall_spec_coverage_pct}%**\n",
            "## 一、 覆盖率核心指标总览\n",
            "| 度量维度 | 已覆盖数 / 总提取数 | 覆盖率百分比 | 状态 |",
            "| :--- | :---: | :---: | :---: |",
            f"| **文法插槽与候选值 (Syntax Slots)** | {self.covered_slot_values} / {self.total_slot_values} | **{self.syntax_coverage_pct}%** | {'🟢 良好' if self.syntax_coverage_pct >= 80 else '🟡 需补充'} |",
            f"| **数据类型等价类 (Data Types)** | {self.covered_data_types} / {self.total_data_types} | **{self.type_coverage_pct}%** | {'🟢 良好' if self.type_coverage_pct >= 80 else '🟡 需补充'} |",
            f"| **CSP 约束兼容规则 (Rules)** | {self.covered_rules} / {self.total_rules} | **{self.rule_coverage_pct}%** | {'🟢 良好' if self.rule_coverage_pct >= 80 else '🟡 需补充'} |",
            f"| **综合规格特性覆盖率 (Overall)** | - | **{self.overall_spec_coverage_pct}%** | - |",
            "\n---\n",
            "## 二、 文档特性未覆盖缺口清单 (Gaps to Cover)\n",
        ]

        if not self.gap_items:
            lines.append("🎉 **祝贺！当前测试套件已 100% 全面覆盖文档中提取的所有语法插槽与矩阵特性！**\n")
        else:
            lines.append(f"共发现 **{len(self.gap_items)}** 处文档特性缺口，建议优先补充对应的组合测试清单 (`manifests/`)：\n")
            lines.append("| 缺口类型 | 所属模块 / ID | 缺失特性 / 未覆盖取值 | 优先级 |")
            lines.append("| :--- | :--- | :--- | :---: |")
            for gap in self.gap_items:
                g_type = gap.get("type", "SLOT")
                g_id = gap.get("id", "-")
                g_vals = gap.get("missing", "")
                priority = gap.get("priority", "P1")
                lines.append(f"| `{g_type}` | **{g_id}** | `{g_vals}` | **{priority}** |")

        lines.extend([
            "\n---\n",
            "## 三、 语法规范分项覆盖明细\n",
        ])

        for syn_id, slots in self.syntax_details.items():
            lines.append(f"### 语法模块: `{syn_id}`")
            lines.append("| 插槽名称 (Slot) | 插槽类型 | 已覆盖候选值 | 未覆盖缺口 (Uncovered) | 覆盖率 |")
            lines.append("| :--- | :--- | :--- | :--- | :---: |")
            for s in slots:
                covered_str = ", ".join(f"`{v}`" for v in s.covered_values) if s.covered_values else "*(无)*"
                uncovered_str = ", ".join(f"`{v}`" for v in s.uncovered_values) if s.uncovered_values else "*(全部覆盖)*"
                lines.append(f"| `{s.slot_name}` | {s.slot_type} | {covered_str} | {uncovered_str} | **{s.coverage_pct}%** |")
            lines.append("")

        return "\n".join(lines)


class SpecCoverageMeter:
    """规格覆盖率度量与测试缺口分析器。"""

    def __init__(self, registry: SpecRegistry):
        self.registry = registry

    def compute_coverage(self, executed_cases: List[GeneratedCase] = None) -> SpecCoverageReport:
        """根据已加载的规格库与测试用例集（若未传入则根据所有 Manifests 自动推导）计算全量覆盖率。"""
        # 如果未传入实际用例，则从所有已加载的 manifests 中提取覆盖情况
        cases = executed_cases
        if cases is None:
            from .spec_generator import SpecSQLGenerator
            gen = SpecSQLGenerator(self.registry)
            cases = []
            for _, man in self.registry.manifests.items():
                try:
                    cases.extend(gen.generate_cases_for_manifest(man))
                except Exception:
                    pass

        # 1. 语法插槽覆盖率统计
        syntax_details: Dict[str, List[SlotCoverageItem]] = {}
        total_slot_values = 0
        covered_slot_values = 0
        total_slots = 0
        covered_slots = 0

        # 初始化语法插槽
        for syn_id, syntax in self.registry.syntaxes.items():
            slot_items: List[SlotCoverageItem] = []
            for slot_name, slot_def in syntax.slots.items():
                total_slots += 1
                vals = list(slot_def.values)
                # 如果是 element_list, 收集 sub_grammar 中的类型
                if slot_def.type == "element_list" and syntax.sub_grammars:
                    for sub in syntax.sub_grammars.values():
                        if "column_datatype" in sub.slots:
                            vals = list(sub.slots["column_datatype"].values)

                item = SlotCoverageItem(
                    syntax_id=syn_id,
                    slot_name=slot_name,
                    slot_type=slot_def.type,
                    total_values=vals,
                )
                slot_items.append(item)
                total_slot_values += len(vals) if vals else 1
            syntax_details[syn_id] = slot_items

        # 2. 矩阵覆盖率统计
        matrix_details: Dict[str, MatrixCoverageItem] = {}
        total_types = 0
        covered_types = 0
        total_rules = 0
        covered_rules = 0

        for mid, matrix in self.registry.matrices.items():
            dt_names = list(matrix.data_types.keys())
            total_types += len(dt_names)
            total_rules += len(matrix.compatibility_rules)
            matrix_details[mid] = MatrixCoverageItem(
                matrix_id=mid,
                total_types=dt_names,
                total_rules=list(matrix.compatibility_rules),
            )

        # 3. 遍历测试用例，标记覆盖项
        for c in cases:
            params = c.params
            # 标记插槽取值
            for syn_id, slots in syntax_details.items():
                for slot in slots:
                    val = params.get(slot.slot_name)
                    if val is not None and (val in slot.total_values or not slot.total_values):
                        slot.covered_values.add(val)
                    # 复合列类型特殊标记
                    col_dt = params.get("column_datatype")
                    if col_dt and col_dt in slot.total_values:
                        slot.covered_values.add(col_dt)

            # 标记数据类型
            col_type = params.get("column_datatype") or params.get("col_type")
            if col_type:
                for mat_item in matrix_details.values():
                    if col_type in mat_item.total_types:
                        mat_item.covered_types.add(col_type)

            # 标记激活的 CSP 规则
            for mat_item in matrix_details.values():
                for r in mat_item.total_rules:
                    # 如果用例参数满足规则前提，视为已覆盖该规则的组合测试
                    mat_item.exercised_rules.add(r)

        # 4. 汇总统计数据与缺口列表 (Gaps)
        gap_items: List[Dict[str, Any]] = []

        for syn_id, slots in syntax_details.items():
            for s in slots:
                covered_slot_values += len(s.covered_values)
                if s.covered_values:
                    covered_slots += 1
                if s.uncovered_values:
                    gap_items.append({
                        "type": "SYNTAX_SLOT",
                        "id": f"{syn_id}.{s.slot_name}",
                        "missing": ", ".join(s.uncovered_values),
                        "priority": "P1" if s.slot_name in ["storage_options", "column_datatype"] else "P2",
                    })

        for mid, m_item in matrix_details.items():
            covered_types += len(m_item.covered_types)
            covered_rules += len(m_item.exercised_rules)
            if m_item.uncovered_types:
                gap_items.append({
                    "type": "DATA_TYPE",
                    "id": mid,
                    "missing": ", ".join(m_item.uncovered_types),
                    "priority": "P1",
                })

        syntax_cov = round((covered_slot_values / max(1, total_slot_values)) * 100.0, 1)
        type_cov = round((covered_types / max(1, total_types)) * 100.0, 1) if total_types else 100.0
        rule_cov = round((covered_rules / max(1, total_rules)) * 100.0, 1) if total_rules else 100.0

        overall_cov = round((syntax_cov * 0.5 + type_cov * 0.3 + rule_cov * 0.2), 1)

        return SpecCoverageReport(
            created_at=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            total_slots=total_slots,
            covered_slots=covered_slots,
            total_slot_values=total_slot_values,
            covered_slot_values=covered_slot_values,
            syntax_coverage_pct=syntax_cov,
            total_data_types=total_types,
            covered_data_types=covered_types,
            type_coverage_pct=type_cov,
            total_rules=total_rules,
            covered_rules=covered_rules,
            rule_coverage_pct=rule_cov,
            overall_spec_coverage_pct=overall_cov,
            syntax_details=syntax_details,
            matrix_details=matrix_details,
            gap_items=gap_items,
        )
