"""规格静态校验器 (Spec Linter)：

在测试生成与执行前，静态校验三类规格文件 (Syntax, Matrix, Manifest) 的完整性与一致性：
1. 引用完整性校验 (Dangling references)
2. 插槽闭合性校验 (AST Slot closure in production template)
3. CSP 规则语法与死锁检查
"""
import re
from dataclasses import dataclass
from typing import List, Dict, Tuple
from .spec_model import SpecRegistry, SyntaxDef, MatrixDef, ManifestDef
from .constraint_solver import ConstraintError, ConstraintRule, ConstraintSolver


@dataclass
class LintIssue:
    file_type: str  # syntax | matrix | manifest
    spec_id: str
    level: str      # ERROR | WARNING
    message: str


class SpecLinter:
    """规格完整性与语法校验器。"""

    def __init__(self, registry: SpecRegistry):
        self.registry = registry

    def lint_all(self) -> List[LintIssue]:
        """对注册表中所有已加载的规格进行全面检查。"""
        issues: List[LintIssue] = []
        issues.extend(self.lint_syntaxes())
        issues.extend(self.lint_matrices())
        issues.extend(self.lint_manifests())
        issues.extend(self.lint_fixtures())
        return issues

    def lint_syntaxes(self) -> List[LintIssue]:
        issues: List[LintIssue] = []
        for sid, syntax in self.registry.syntaxes.items():
            # 检查 production 中的占位符是否在 slots 中定义
            placeholders = re.findall(r"\{([a-zA-Z0-9_]+)\}", syntax.production)
            for p in placeholders:
                if p not in syntax.slots:
                    issues.append(LintIssue(
                        file_type="syntax",
                        spec_id=sid,
                        level="ERROR",
                        message=f"产生式中的占位符 '{{{p}}}' 未在 slots 字典中显式声明定义"
                    ))
            for slot_name in syntax.slots:
                if slot_name not in placeholders:
                    issues.append(LintIssue(
                        file_type="syntax",
                        spec_id=sid,
                        level="ERROR",
                        message=f"slots 中的 '{slot_name}' 未被 production 消费"
                    ))
        return issues

    def lint_matrices(self) -> List[LintIssue]:
        issues: List[LintIssue] = []
        for mid, matrix in self.registry.matrices.items():
            for rule in matrix.compatibility_rules:
                try:
                    _ = ConstraintRule(rule)
                except ConstraintError as e:
                    issues.append(LintIssue(
                        file_type="matrix",
                        spec_id=mid,
                        level="ERROR",
                        message=f"兼容性规则语法错误: '{rule}' -> {e}"
                    ))
        return issues

    def lint_manifests(self) -> List[LintIssue]:
        issues: List[LintIssue] = []
        for man_id, manifest in self.registry.manifests.items():
            # 1. 检查引用的语法是否存在
            if manifest.target_syntax not in self.registry.syntaxes:
                issues.append(LintIssue(
                    file_type="manifest",
                    spec_id=man_id,
                    level="ERROR",
                    message=f"引用的 target_syntax '{manifest.target_syntax}' 不存在于语法库中"
                ))

            # 2. 检查引用的矩阵是否存在
            for mref in manifest.import_matrices:
                if mref not in self.registry.matrices:
                    issues.append(LintIssue(
                        file_type="manifest",
                        spec_id=man_id,
                    level="ERROR",
                        message=f"引用的 import_matrix '{mref}' 未在已加载矩阵中找到"
                    ))

            # 3. 检查 bindings、fixture 与约束引用是否闭合。
            syntax = self.registry.get_syntax(manifest.target_syntax)
            if syntax:
                available = syntax.all_slot_names()
                unknown_bindings = sorted(set(manifest.bindings) - available)
                if unknown_bindings:
                    issues.append(LintIssue(
                        file_type="manifest", spec_id=man_id, level="ERROR",
                        message=f"bindings 引用了未知 slot: {', '.join(unknown_bindings)}"
                    ))
                for fixture_id in manifest.fixtures:
                    if fixture_id not in self.registry.fixtures:
                        issues.append(LintIssue(
                            file_type="manifest", spec_id=man_id, level="ERROR",
                            message=f"引用的 fixture '{fixture_id}' 不存在"
                        ))
                rules = list(manifest.additional_constraints)
                for matrix_id in manifest.import_matrices:
                    matrix = self.registry.get_matrix(matrix_id)
                    if matrix:
                        rules.extend(matrix.compatibility_rules)
                try:
                    solver = ConstraintSolver(rules)
                    solver.validate_references(available)
                except ConstraintError as e:
                    issues.append(LintIssue(
                        file_type="manifest", spec_id=man_id, level="ERROR",
                        message=f"测试清单约束错误: {e}"
                    ))
        return issues

    def lint_fixtures(self) -> List[LintIssue]:
        issues: List[LintIssue] = []
        for fixture_id, fixture in self.registry.fixtures.items():
            for table in fixture.tables:
                if not table.columns:
                    issues.append(LintIssue(
                        file_type="fixture", spec_id=fixture_id, level="WARNING",
                        message=f"fixture 表 '{table.name}' 未声明列，无法参与列级静态校验"
                    ))
        return issues
